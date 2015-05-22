class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = @project.donations.new(user: current_user)
    @donation.amount = @donation.with_pence(donation_params[:amount])
    @donation.paid = false
    @donation.save
    redirect_to project_path(@project)
  end

  def donation_params
    params.require(:donation).permit(:amount)
  end
end
