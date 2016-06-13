class RemoteActionService

  attr_reader :object, :service

  def initialize(object)
    @object = object
    @service = CollectionSpace::Converter::Default.service @object.type
  end

  def remote_delete
    deleted = false
    response = $collectionspace_client.delete(@object.uri)
    if response.status_code.to_s =~ /^2/
      @object.csid = nil
      @object.uri  = nil
      @object.save!
      deleted = true
    end
    deleted
  end

  def remote_transfer
    transferred = false
    response = $collectionspace_client.post(@service[:path], @object.content)
    if response.status_code == 201
      # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
      csid = response.headers["Location"].split("/")[-1]
      uri  = "#{@service[:path]}/#{csid}"
      @object.csid = csid
      @object.uri  = uri
      @object.save!
      transferred = true
    end
    transferred
  end

  def remote_already_exists?
    exists      = false
    search_args = {
      path: @service[:path],
      type: "#{@service[:schema]}_common",
      field: @object.identifier_field,
      expression: "= '#{@object.identifier}'",
    }
    message_string = "#{@service[:path]} #{@service[:schema]} #{@object.identifier_field} #{@object.identifier}"

    query    = CollectionSpace::Search.new.from_hash search_args
    response = $collectionspace_client.search(query)
    unless response.status_code.to_s =~ /^2/
      raise "Error searching #{message_string}"
    end
    parsed_response = response.parsed

    result_count = parsed_response["abstract_common_list"]["totalItems"].to_i
    if result_count == 1
      exists       = true
      # set csid and uri in case they are lost (i.e. batch was deleted)
      @object.csid = parsed_response["abstract_common_list"]["list_item"]["csid"]
      @object.uri  = parsed_response["abstract_common_list"]["list_item"]["uri"].gsub(/^\//, '')
      @object.save!
    else
      raise "Ambiguous result count (#{result_count.to_s}) for #{message_string}" if result_count > 1
      # TODO: set csid and uri to nil if 0?
    end
    exists
  end

end