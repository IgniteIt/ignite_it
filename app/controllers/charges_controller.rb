class ChargesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    # Amount in cents
    @donation = @project.donations.all.where(user: current_user)
    @amount = "#{@donation.sum(:amount)}0"
  end

  def create
    @project = Project.find(params[:project_id])
    # Amount in cents
    @donation = @project.donations.all.where(user: current_user)
    @amount = "#{@donation.sum(:amount)}0"

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'GBP'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
  end
end