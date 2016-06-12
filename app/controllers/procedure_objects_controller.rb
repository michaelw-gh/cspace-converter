class ProcedureObjectsController < ApplicationController

  def index
    @objects = CollectionSpaceObject.where(category: "Procedure")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = CollectionSpaceObject.where(category: "Procedure").where(id: params[:id]).first
  end

  # remote actions

  def delete
    @object = CollectionSpaceObject.where(category: "Procedure").where(id: params[:id]).first
    service = CollectionSpace::Converter::Default.service @object.type

    begin
      if already_exists?(service, @object)
        response = $collectionspace_client.delete(@object.uri)
        if response.status_code.to_s =~ /^2/
          @object.csid = nil
          @object.uri  = nil
          @object.save!
          flash[:notice] = "Record deleted"
        else
          flash[:error] = "Failed to delete record"
        end
      else
        flash[:warning] = "Record not found"
      end
    rescue Exception => ex
      flash[:error] = "Connection error\n#{ex.message}"
    end

    redirect_to procedure_path(@object)
  end

  def ping
    @object = CollectionSpaceObject.where(category: "Procedure").where(id: params[:id]).first
    service = CollectionSpace::Converter::Default.service @object.type

    begin
      if already_exists?(service, @object)
        flash[:notice] = "Record found"
      else
        flash[:warning] = "Record not found"
      end
    rescue Exception => ex
      flash[:error] = "Connection error\n#{ex.message}"
    end

    redirect_to procedure_path(@object)
  end

  def transfer
    @object = CollectionSpaceObject.where(category: "Procedure").where(id: params[:id]).first
    service = CollectionSpace::Converter::Default.service @object.type

    begin
      if already_exists?(service, @object)
        flash[:warning] = "Record already exists"
      else
        response = $collectionspace_client.post(service, @object.content)
        if response.status_code == 201
          # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
          location     = response.headers["Location"].split("/")
          csid         = location[-1]
          uri          = "#{location[-2]}/#{csid}"
          @object.csid = csid
          @object.uri  = uri
          @object.save!
          flash[:notice] = "Record created"
        else
          flash[:warning] = "Record was not created"
        end
      end
    rescue Exception => ex
      flash[:error] = "Connection error\n#{ex.message}"
    end

    redirect_to procedure_path(@object)
  end

  private

  # TODO: will need to move this ...
  def already_exists?(service, object)
    search_args = {
      path: service,
      type: "#{service}_common",
      field: object.identifier_field,
      expression: "= '#{object.identifier}'",
    }

    query    = CollectionSpace::Search.new.from_hash search_args
    response = $collectionspace_client.search(query).parsed
    # TODO: check status
    return response["abstract_common_list"]["totalItems"].to_i > 0 ? true : false
  end

end
