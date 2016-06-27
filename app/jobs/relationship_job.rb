class RelationshipJob < ActiveJob::Base
  queue_as :default

  def perform(import_batch)
    objects = DataObject.where(import_batch: import_batch)
    objects.each do |object|
      # clear out any existing relationships
      object.collection_space_objects.where(category: 'Relationship').destroy_all
      object.add_relationships
      object.save!
    end
  end
end
