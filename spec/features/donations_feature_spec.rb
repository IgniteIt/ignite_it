require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'

feature 'Donations' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/projects'
  end

  context 'as a user I want to be able to donate money' do
    scenario 'I can donate money to a project and it is visible on the project page' do
      click_link 'Campaign'
      make_payment(75)
      expect(page).to have_content('25')
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'I can not make a negative donation' do
      click_link 'Campaign'
      make_neg_payment
      expect(page).to have_content('Incorrect value, please enter a positive amount')
    end

    scenario 'Must be logged in to donate' do
      click_link "Sign out"
      visit("/projects/#{Project.last.id}/donations/new")
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    scenario 'Can list users who donated' do
      click_link 'Campaign'
      make_payment
      expect(page).to have_content('Paul: £25')
    end


    context 'if the project has expired' do

      context 'and the user has not donated' do
        before do
          @project = Project.last
          @project.set_expiration_date(1.second)
          @project.save
          sleep(1)
        end

        scenario 'can\'t donate' do
          click_link 'Campaign'
          expect(page).to have_content 'Project expired!'
          expect(page).not_to have_link 'Donate'
        end

        scenario 'can\'t visit new donation page' do
          visit "projects/#{@project.id}/donations/new"
          expect(page).to have_content('Project has expired')
        end

        scenario 'can\'t donate in any case' do
          @project.set_expiration_date(2.seconds)
          @project.save
          visit "projects/#{@project.id}/donations/new"
          fill_in('Amount', with: 75)
          sleep(2)
          click_button 'Donate'
          expect(page).to have_content('Project has expired')
        end
      end

      context 'the user has donated and the goal was reached' do

        before do
          click_link 'Campaign'
          make_payment('100')
          @project = Project.last
          @project.set_expiration_date(1.second)
          @project.save
          sleep(1)
        end

        scenario 'show a pay link if user has donated' do
          click_link 'Campaign'
          click_link 'Pay'
          expect(page).to have_content 'Amount: £ 100'
        end
      end

      context 'the user has donated but the goal was not reached' do

        before do
          click_link 'Campaign'
          make_payment('50')
          @project = Project.last
          @project.set_expiration_date(1.second)
          @project.save
          sleep(1)
        end

        scenario 'show a project expired message' do
          click_link 'Campaign'
          expect(page).to have_content 'Project expired!'
        end
      end
    end
  end
end
