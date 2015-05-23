require 'rails_helper'
require './app/helpers/donations_helper'

describe Donation, :type => :model do

  include DonationsHelper

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

  it 'can calculate the amount with pence' do
    donation = Donation.create(amount: 75, paid: false)
    amount = donation.amount
    expect(with_pence(amount)).to eq 7500
  end

  it 'can calculate the amount without pence' do
    donation = Donation.create(amount: 7500, paid: false)
    amount = donation.amount
    expect(without_pence(amount)).to eq 75
  end
end