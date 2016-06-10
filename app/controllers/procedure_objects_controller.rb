class ProcedureObjectsController < ApplicationController

  def index
    @objects = ProcedureObject.page params[:page]
  end

  def show
    @object = ProcedureObject.where(id: params[:id]).first
  end

end
