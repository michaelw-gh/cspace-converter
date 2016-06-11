class AuthorityObjectsController < ApplicationController

  def index
    @objects = ProcedureObject.where(category: "Authority")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = ProcedureObject.where(category: "Authority").where(id: params[:id]).first
  end

end
