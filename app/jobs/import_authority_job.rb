require 'json'

class ImportAuthorityJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    import_file       = config[:filename]
    import_batch      = config[:batch]
    converter_module  = config[:module]
    identifier_field  = config[:id_field]
    authority_type    = config[:type]
    authority_subtype = config[:subtype]
    use_previous_auth_cache = config[:use_previous_auth_cache]

    data_object_attributes = {
      import_type:       'Authority',
      import_file:       import_file,
      import_batch:      import_batch,
      converter_module:  converter_module,
      converter_profile: 'authority',
      use_auth_cache_file: use_previous_auth_cache
    }

    #
    # Fetch the authority and vocabulary terms for the cspace profile type
    #
    begin
      file = File.join(Rails.root, 'config', 'initializers', 'converters', converter_module, 'auth_cache.json')
      authorities_cache = JSON.parse(File.read(file))
      #
      # Use Rails to cache the authorities/vocabularies and terms 
      #
      Rails.cache.write(AuthCache::AUTHORITIES_CACHE, authorities_cache)
    rescue Errno::ENOENT => e
      Rails.logger.warn "No authority cache file found at #{file}"
    end unless use_previous_auth_cache

    #
    # row_count is used to reference the current row in logging and error messages
    #
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
