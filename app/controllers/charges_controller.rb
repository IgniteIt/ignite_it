class ChargesController < ApplicationController
  include DonationsHelper

  def new
    @project = Project.find(params[:project_id])
    @donations = @project.donations.all.where(user: current_user)
    @amount = @donations.sum(:amount)
  end

  def create
    @project = Project.find(params[:project_id])
    @donations = @project.donations.all.where(user: current_user)
    @amount = @donations.sum(:amount)

    @donations.update_all(paid: true)

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Payment for #{@project.name}",
      :currency    => 'GBP'
    )


  rescue Stripe::CardError => e
    flash[:error] = e.message
  end
end
