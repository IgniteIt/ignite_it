require 'rails_helper'

module DonationsHelper
  def make_payment(amount=25)
    click_button 'Donate'
    fill_in('Amount', with: amount)
    click_button 'Submit'
  end
end
