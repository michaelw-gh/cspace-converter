class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, import_type, import_batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    # cannot lookup relationships so force delete if there is a csid for the object
    force_delete = (import_type == "Relationship" and action_method == :remote_delete) ? true : false

    objects = CollectionSpaceObject.includes(:data_object)
      .where(type: import_type)
      .entries.select { |object|
      (import_batch.nil? or object.data_object.import_batch == import_batch) ? object : nil;
    }

    # TODO: add logging

    objects.each do |object|
      service = RemoteActionService.new(object)
      if force_delete or service.remote_already_exists?
        deleted = service.send(action_method) if action_method == :remote_delete
        logger.error "Failed to delete #{object.inspect}" unless deleted
      else
        transferred = service.send(action_method) if action_method == :remote_transfer
        logger.error "Failed to transfer #{object.inspect}" unless transferred
      end
    end
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
    }[action]
  end
end
