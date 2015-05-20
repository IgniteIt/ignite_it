require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'payments' do
  include ProjectsHelper
  include UserHelper

  before do
    sign_up
    visit '/'
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/'
  end


  context 'as a user I want to be able to donate money' do
    scenario 'I can donate money to a project' do
      click_link 'Campaign'
      click_link 'Donate'
      fill_in('Amount', with: 75)
      click_button 'Submit'
      expect(page).to have_content('25')
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end
  end
end
