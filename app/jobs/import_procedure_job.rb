require 'json'

# TODO: rename ImportProcedureJob
class ImportProcedureJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    import_file       = config[:filename]
    import_batch      = config[:batch]
    converter_module  = config[:module]
    converter_profile = config[:profile]
    use_previous_auth_cache = config[:use_previous_auth_cache]

    data_object_attributes = {
      import_type:       'Procedure',
      import_file:       import_file,
      import_batch:      import_batch,
      converter_module:  converter_module,
      converter_profile: converter_profile,
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

      object.add_procedures
      object.save!

      object.add_authorities
      object.save!
    end
  end
end