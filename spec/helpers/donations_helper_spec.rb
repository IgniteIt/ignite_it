require 'rails_helper'

module DonationsHelper
  def make_payment(amount)
    click_link 'Donate'
    fill_in('Amount', with: amount)
    click_button 'Submit'
  end
end

# RSpec.describe DonationsHelper, type: :helper do
# end
