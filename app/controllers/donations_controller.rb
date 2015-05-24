class DonationsController < ApplicationController
  before_action :authenticate_user!
  include DonationsHelper

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = @project.donations.new(user: current_user, paid: false,
                                          amount: with_pence(donation_params[:amount]))
    if @project.has_expired?
      flash[:notice] = 'Project has expired'
    else
      @donation.save
    end
    redirect_to project_path(@project)
  end

  def donation_params
    params.require(:donation).permit(:amount)
  end
end
