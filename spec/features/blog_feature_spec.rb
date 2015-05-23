require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'blogs' do
  include ProjectsHelper
  include UserHelper

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    configure_project_stubs
  end

  context 'Projects and their blogs' do
    scenario 'Owner creates a blog' do
      click_link 'Campaign'
      click_link 'Create Blog'
      fill_in 'Title', with: 'Blog 1'
      fill_in 'Content', with: 'This is my project'
      click_button 'Submit'
      expect(page).to have_content('Blog 1')
      expect(page).to have_content('This is my project')
      expect(current_path).to eq ("/projects/#{Project.last.id}")
    end

    scenario 'Owner has to be signed in to create blog' do
      click_link 'Sign out'
      sign_up('g@g.com', 'Shaggy')
      click_link 'Campaign'
      click_link 'Create Blog'
      expect(page).to have_content('You are not the project owner')
    end

    xscenario 'When owner makes blog, all donors are notified' do
    end
  end
end
