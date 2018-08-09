require 'json'

class ImportAuthorityJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    data_object_attributes = {
      import_type:       'Authority',
      import_file:       config[:filename],
      import_batch:      config[:batch],
      converter_module:  config[:module],
      converter_profile: 'authority',
      use_auth_cache_file: config[:use_previous_auth_cache]
    }

    # Fetch the authority and vocabulary terms for the cspace profile type
    AuthCache.setup(config[:module]) unless config[:use_previous_auth_cache]

    # Authority config
    identifier_field  = config[:id_field]
    authority_type    = config[:type]
    authority_subtype = config[:subtype]

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      row_count = row_count + 1

      object = DataObject.new.from_json JSON.generate(data)
      object.set_attributes data_object_attributes,row_count
      # validate object immediately after initial attributes set
      object.save!

      # TODO: support for explicit identifiers
      identifier = CSIDF.short_identifier(object.read_attribute(identifier_field))
      unless CollectionSpaceObject.has_authority?(identifier)
        # CREATE NEW CSPACE OBJECT
        object.add_authority(authority_type, authority_subtype, object.read_attribute(identifier_field))
        object.save! # we have a stub
      end
      cspace_object = CollectionSpaceObject.where(category: 'Authority', identifier: identifier).first
      # TODO: update parent of cspace object if different (i.e. was stub record)
      cspace_object.content = object.to_auth_xml(authority_type)
      cspace_object.save!
    end
  end
end
