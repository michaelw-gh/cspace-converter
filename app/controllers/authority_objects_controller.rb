class AuthorityObjectsController < ApplicationController
  include RemoteActionable

  def index
    @objects = CollectionSpaceObject.where(category: "Authority")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = CollectionSpaceObject.where(category: "Authority").where(id: params[:id]).first
  end

  # remote actions (concerns/remote_actionable)

end
