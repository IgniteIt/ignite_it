require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'

feature 'Donations' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/'
  end

  context 'as a user I want to be able to donate money' do
    scenario 'I can donate money to a project and it is visible on the project page' do
      click_link 'Campaign'
      make_payment(75)
      expect(page).to have_content('25')
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'Current project pledged money is visible on the homepage' do
      click_link 'Campaign'
      make_payment(75)
      visit '/'
      expect(page).to have_content('£25 remaining')
    end

    scenario 'Must be logged in to donate' do
      click_link 'Sign out'
      click_link 'Campaign'
      click_link 'Donate'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'can\'t donate if the time has expired' do
      project = Project.last
      project.set_expiration_date(1.second)
      project.save
      sleep(1)
      click_link 'Campaign'
      expect(page).not_to have_link 'Donate'
    end

    scenario 'Can list users who donated' do
      click_link 'Campaign'
      make_payment
      expect(page).to have_content('Paul donated £25')
    end
  end
end
