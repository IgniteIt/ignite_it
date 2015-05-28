require 'rails_helper'

module DonationsHelper
  def make_payment(amount=25)
    click_link 'Donate'
    fill_in('Amount', with: amount)
    click_button 'Donate'
  end

  def make_neg_payment(amount=-10)
    click_link 'Donate'
    fill_in('Amount', with: amount)
    click_button 'Donate'
  end
end
