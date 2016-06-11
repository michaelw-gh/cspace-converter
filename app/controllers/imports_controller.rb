class ImportsController < ApplicationController

  def new
    #
  end

  def create
    # TODO ... import in background
    flash[:notice] = "Background import job running. Refresh page for results."
    redirect_to procedures_path
  end

end
