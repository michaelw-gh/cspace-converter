class DataObjectsController < ApplicationController

  def index
    @objects = DataObject.page params[:page]
  end

  def show
    @object = DataObject.where(id: params[:id]).first
  end

end
