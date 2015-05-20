require 'rails_helper'

module PaymentsHelper
  def make_payment
    click_link 'Donate'
    fill_in('Amount', with: 75)
    click_button 'Submit'
  end
end

# RSpec.describe DonationsHelper, type: :helper do
# end
