require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'user follows a project' do

  include ProjectsHelper
  include UserHelper

  before do
    sign_up
    visit '/'
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    click_link 'Sign out'
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  context 'user not logged in' do
    scenario 'cannot follow projects' do
      expect(page).not_to have_link('Follow')
    end
  end

  context 'user logged in' do
    before do
      log_in
    end

    scenario 'cannot follow projects twice' do
      click_link 'Follow'
      expect(page).not_to have_link 'Follow'
      expect(page).to have_link 'Unfollow'
    end

    scenario 'can unfollow projects' do
      click_link 'Follow'
      click_link 'Unfollow'
      expect(page).to have_link 'Follow'
      expect(page).not_to have_link 'Unfollow'
    end

    scenario 'a user can follow a project, which updates the project follow count' do
      click_link 'Follow'
      expect(page).to have_content('1 follower')
    end

    scenario 'if follow is not saved, then user is redirected to the projects page' do
      click_link 'Follow'
      visit "/projects/#{Project.last.id}/followers/new"
      expect(current_path).to eq '/projects'
      expect(page).to have_content ('You are already following the project')
    end

    scenario 'only users who follow a project can unfollow it' do
      click_link 'Follow'
      click_link 'Sign out'
      sign_up('g@g.com', 'George')
      page.driver.submit :delete, "/projects/#{Project.last.id}/followers/#{Follower.last.id}", {}
      expect(page).to have_content 'Cannot unfollow the project'
    end
  end
end
