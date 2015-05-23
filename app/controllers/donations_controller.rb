class DonationsController < ApplicationController
  before_action :authenticate_user!
  include DonationsHelper

  include DonationsHelper

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = @project.donations.create(user: current_user, paid: false,
                                          amount: with_pence(donation_params[:amount]))
    redirect_to project_path(@project)
  end

  def donation_params
    params.require(:donation).permit(:amount)
  end
end
