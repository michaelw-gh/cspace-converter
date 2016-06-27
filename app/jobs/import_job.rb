class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(import_file, import_batch, converter_type, converter_profile, rows = [])
    data_object_attributes = {
      import_file:       import_file,
      import_batch:      import_batch,
      converter_type:    converter_type,
      converter_profile: converter_profile,
    }

    rows.each do |data|
      object = DataObject.new.from_json JSON.generate(data)
      object.set_attributes data_object_attributes
      # validate object immediately after initial attributes set
      object.save!

      object.add_procedures
      object.add_authorities
      object.save!
    end
  end
end
