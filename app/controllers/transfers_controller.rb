class TransfersController < ApplicationController

  def new
    # form
  end

  def create
    action = params[:remote_action]
    type   = params[:type]
    batch  = params[:batch]

    batch = nil if batch =~ /all/i

    TransferJob.perform_later(action, type, batch)
    flash[:notice] = "Transfer job running. Check back periodically for results."
    redirect_to root_path
  end

end
