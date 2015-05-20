require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'

feature 'payments' do
  include ProjectsHelper
  include UserHelper
  include PaymentsHelper

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/'
  end

  context 'as a user I want to be able to donate money' do
    scenario 'I can donate money to a project and it is visible on the project page' do
      click_link 'Campaign'
      make_payment
      expect(page).to have_content('25')
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'Current project pledged money is visible on the homepage' do
      click_link 'Campaign'
      make_payment
      visit '/'
      expect(page).to have_content('£25 Remaining')
    end

    scenario 'Must be logged in to donate' do
      click_link 'Sign out'
      click_link 'Campaign'
      click_link 'Donate'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
