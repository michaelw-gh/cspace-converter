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
    search_args = {
      path: @service[:path],
      type: "#{@service[:schema]}_common",
      field: @object.identifier_field,
      expression: "= '#{@object.identifier}'",
    }

    query    = CollectionSpace::Search.new.from_hash search_args
    response = $collectionspace_client.search(query).parsed
    # TODO: check status
    return response["abstract_common_list"]["totalItems"].to_i > 0 ? true : false
  end

end