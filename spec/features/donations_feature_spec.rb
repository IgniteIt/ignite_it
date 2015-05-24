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

    scenario 'Can list users who donated' do
      click_link 'Campaign'
      make_payment
      expect(page).to have_content('Paul donated £25')
    end

    context 'if the project has expired' do
      before do
        @project = Project.last
        @project.set_expiration_date(1.second)
        @project.save
        sleep(1)
      end

      scenario 'can\'t donate if the time has expired' do
        click_link 'Campaign'
        expect(page).not_to have_link 'Donate'
      end

      scenario 'can\'t visit new donation page if project has expired' do
        visit "projects/#{@project.id}/donations/new"
        expect(page).to have_content('Project has expired')
      end

      scenario 'can\'t donate in any case if the project has expired' do
        @project.set_expiration_date(2.seconds)
        @project.save
        visit "projects/#{@project.id}/donations/new"
        fill_in('Amount', with: 75)
        sleep(2)
        click_button 'Submit'
        expect(page).to have_content('Project has expired')
      end
    end
  end
end
