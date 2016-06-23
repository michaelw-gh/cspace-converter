class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(import_file, import_batch, import_converter, import_profile, rows = [])
    converter_class = "CollectionSpace::Converter::#{import_converter}".constantize
    profiles        = converter_class.registered_profiles
    profile         = profiles[import_profile]
    raise "Invalid profile #{import_profile} for #{profiles}" unless profile

    data_object_attributes = {
      import_file: import_file,
      import_batch: import_batch,
      import_converter: import_converter,
      import_profile: import_profile,
    }

    rows.each do |data|
      object = DataObject.new.from_json JSON.generate(data)
      object.set_attributes data_object_attributes

      profile["Procedures"].each do |procedure, attributes|
        object.add_procedure procedure, attributes
      end

      # "Authorities" => { "Person" => ["recby", "recfrom"] }
      profile["Authorities"].each do |authority, fields|
        object.add_authorities authority, fields
      end

      object.save!
    end
  end
end
