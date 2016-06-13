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

      profile["Procedures"].each do |procedure, attributes|
        procedure_data = {}
        # check for existence or update
        procedure_data[:category]         = "Procedure"
        procedure_data[:type]             = procedure
        procedure_data[:identifier_field] = attributes["identifier_field"]
        procedure_data[:identifier]       = object.read_attribute( attributes["identifier"] )
        procedure_data[:title]            = object.read_attribute( attributes["title"] )
        procedure_data[:content]          = object.to_procedure_xml(procedure)
        object.collection_space_objects.build procedure_data
      end

      # "Authorities" => { "Person" => ["recby", "recfrom"] }
      profile["Authorities"].each do |authority, fields|
        fields.each do |field|
          term_display_name = object.read_attribute(field)
          next unless term_display_name

          # attempt to split field in case it is multi-valued
          term_display_name.split(Rails.application.config.csv_mvf_delimiter).map(&:strip).each do |name|
            authority_data = {}
            # check for existence or update
            authority_data[:category]         = "Authority"
            authority_data[:type]             = authority
            authority_data[:identifier_field] = 'shortIdentifier'
            authority_data[:identifier]       = CollectionSpace::Identifiers.short_identifier(name)
            authority_data[:title]            = name
            authority_data[:content]          = object.to_auth_xml(authority, name)
            object.collection_space_objects.build authority_data
          end
        end
      end

      object.save!
    end
  end
end
