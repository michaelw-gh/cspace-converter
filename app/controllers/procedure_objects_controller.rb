class ProcedureObjectsController < ApplicationController

  def index
    @objects = ProcedureObject.where(category: "Procedure")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = ProcedureObject.where(category: "Procedure").where(id: params[:id]).first
  end

end
