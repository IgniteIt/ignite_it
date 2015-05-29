require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'

feature 'projects crud' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper

  before do
    sign_up
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
    configure_project_stubs
  end

  context 'creating projects' do

    scenario 'prompts user to fill out a form, then displays a new project' do
      visit '/projects'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      expect(page).to have_content 'Campaign'
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'after creating a project the list in the home page self update' do
      visit '/projects'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      visit '/projects'
      expect(page).to have_content 'Campaign'
      expect(page).to have_content '£100'
      expect(page).to have_css("#due_date_timer_#{Project.last.id}")
    end

    context 'creating an invalid project' do
      it 'does not let you submit a name that is too short' do
        visit '/projects'
        create_project('Ca', regular_description, '100', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Ca'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a description that is too short' do
        visit '/projects'
        create_project('Campaign', 'Short description', '100', '30 days from now', 'Environment', 'London')
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a unique name' do
        visit '/projects'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
        visit '/projects'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a goal' do
        visit '/projects'
        create_project('Campaign', regular_description, '', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without an expiration date' do
        visit '/projects'
        create_project('Campaign', regular_description, '100', 'Select an expiration date', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a sector' do
        visit '/projects'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Select a sector', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without an address' do
        visit '/projects'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', '')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'Editing and deleting a project' do

    before do
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    end

    scenario 'lets a user edit a project' do
      click_link 'Campaign'
      edit_project(edited_description)
      expect(page).to have_content 'Edited description'
      expect(page).to have_content 'Project has been updated'
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'lets a user delete a project' do
      click_link 'Campaign'
      click_link 'Delete'
      expect(page).not_to have_content('Campaign')
      expect(page).to have_content 'Project has been deleted'
      expect(current_path).to eq '/projects'
    end

    scenario 'only users who made a project can delete them' do
      click_link 'Sign out'
      sign_up('g@g.com','George')
      visit('/projects')
      click_link 'Campaign'
      page.driver.submit :delete, "/projects/#{Project.last.id}", {}
      expect(page).to have_content 'Error'
    end

    scenario 'only users who made a project can edit them' do
      click_link 'Sign out'
      sign_up('g@g.com', 'George')
      visit('/projects')
      click_link 'Campaign'
      visit("/projects/#{Project.last.id}/edit")
      expect(page).to have_content 'Error'
    end

    scenario 'when a project you donated to is edited, you are sent an email' do
      make_payment
      edit_project(regular_description)
      expect(WebMock).to have_requested(:post, 
        "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages"
        ).with(:body => hash_including({"from"=>"Campaign <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>", "subject"=>"Campaign was edited"}))
    end
  end
end