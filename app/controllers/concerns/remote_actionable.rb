module RemoteActionable
  extend ActiveSupport::Concern

  def delete
    perform(params[:category]) do |service|
      if service.remote_delete
        flash[:notice] = "Record deleted"
      else
        flash[:error] = "Failed to delete record"
      end
    end
  end

  def ping
    perform(params[:category]) do |service|
      if service.remote_already_exists?
        flash[:notice] = "Record found"
      else
        flash[:warning] = "Record not found"
      end      
    end
  end

  def transfer
    perform(params[:category]) do |service|
      if service.remote_already_exists?
        flash[:warning] = "Record already exists"
      else
        if service.remote_transfer
          flash[:notice] = "Record created"
        else
          flash[:warning] = "Record was not created"
        end
      end
    end
  end

  private

  def perform(category)
    @object  = CollectionSpaceObject.where(category: category).where(id: params[:id]).first
    service  = RemoteActionService.new(@object)

    begin
      yield service
    rescue Exception => ex
      flash[:error] = "Connection error\n#{ex.message} #{service.inspect}"
    end

    redirect_to send("#{category.downcase}_path".to_sym, @object)
  end
end