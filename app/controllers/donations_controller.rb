class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new
  end

  def create
    @project = Project.find(params[:project_id])
    @project.donations.create(donation_params)
    redirect_to project_path(@project)
  end

  def donation_params
    params.require(:donation).permit(:amount)
  end
end
