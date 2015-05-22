require 'rails_helper'
require 'helpers/donations_helper_spec'

describe Donation, :type => :model do

  it { is_expected.to belong_to :user }

  it 'is not valid without an amount' do
    donation = Donation.new
    expect(donation).to have(1).error_on(:amount)
    expect(donation).not_to be_valid
  end

  it 'has a false paid status when created' do
    donation = Donation.create(amount: 75, paid: false)
    expect(donation.paid).to equal(false)
  end
end