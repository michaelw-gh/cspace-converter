class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(import_file, import_batch, import_converter, import_profile, rows = [])
    converter_class = "CollectionSpace::Converter::#{import_converter}".constantize
    profiles        = converter_class.registered_profiles
    profile         = profiles[import_profile]
    raise "Invalid profile #{import_profile} for #{profiles}" unless profile

    rows.each do |data|
      object = DataObject.new.from_json JSON.generate(data)
      object.write_attribute(:import_file, import_file)
      object.write_attribute(:import_batch, import_batch)
      object.write_attribute(:import_converter, import_converter)
      object.write_attribute(:import_profile, import_profile)

      profile.each do |procedure, attributes|
        data = {}
        # check for existence or update
        data[:type]       = procedure
        data[:identifier] = object.read_attribute( attributes["identifier"] )
        data[:title]      = object.read_attribute( attributes["title"] )
        data[:content]    = object.to_cspace_xml(procedure).to_s
        object.procedure_objects.build data
      end
      object.save!
    end
  end
end
