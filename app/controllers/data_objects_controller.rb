class DataObjectsController < ApplicationController

  def index
    @objects = DataObject.all
  end

  def show
    @object = DataObject.where(id: params[:id]).first
  end

end
