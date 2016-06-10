class SitesController < ApplicationController

  def index
  end

  def nuke
    DataObject.destroy_all
    flash[:notice] = "Database nuked, all records deleted!"
    redirect_to root_path
  end

end
