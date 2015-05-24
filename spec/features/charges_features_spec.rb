require 'rails_helper'
require 'helpers/users_helper_spec'
require 'helpers/projects_helper_spec'
require 'helpers/donations_helper_spec'
require 'helpers/charges_helper_spec'

feature 'stripe' do

 include UserHelper
 include DonationsHelper
 include ProjectsHelper
 include ChargesHelper

  before do
    sign_up
    Project.create(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (5), sector: 'Environment', address: 'London', user: User.last)
  end

  context 'if the user can pay' do
    before do
      visit '/'
      click_link 'Campaign'
      make_payment(75)
      sleep(2)
      visit "/projects/#{Project.last.id}/charges/new"
    end

    scenario 'fills in and submits stripe form', js: true, driver: :selenium do
      selenium_helper
      expect(page).to have_content('you paid £ 75 for Campaign!')
    end

    scenario 'it change donation status to true', js: true, driver: :selenium do
      selenium_helper
      expect(Donation.first.paid).to eq true
    end
  end

  context 'if the user can\'t pay' do

    scenario 'because he hasn\'t donated' do
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end

    scenario 'because the time is not expired' do
      visit '/'
      click_link 'Campaign'
      make_payment(75)
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end
  end
end