require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'user follows a project' do

  include ProjectsHelper
  include UserHelper

  before do
    @project = Project.create(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (120), sector: 'Environment', address: 'London', user: User.last)
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  context 'user not logged in' do
    scenario 'cannot follow projects' do
      visit '/'
      expect(page).not_to have_link('Follow', exact: true)
    end
  end

  context 'user logged in' do
    before do
      stub_request(:post, "https://api:key-d862abdfc169a5e8ba9b0a23ba5b9b78@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages")
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)
      visit '/'
    end

    scenario 'cannot follow projects twice', js: true, driver: :selenium do
      click_link 'Follow'
      expect(page).not_to have_link('Follow', exact: true)
      expect(page).to have_link 'Unfollow'
    end

    scenario 'can unfollow projects', js: true, driver: :selenium do
      click_link 'Follow'
      click_link 'Unfollow'
      expect(page).to have_link('Follow', exact: true)
      expect(page).not_to have_link 'Unfollow'
    end

    scenario 'a user can follow a project, which updates the project follow count', js: true, driver: :selenium do
      click_link 'Follow'
      expect(page).to have_content('1 follower')
    end

    scenario 'if follow is not saved, then user is redirected to the projects page' do
      click_link 'Follow'
      visit "/projects/#{Project.last.id}/followers/new"
      expect(current_path).to eq '/projects'
      expect(page).to have_content ('You are already following the project')
    end

    # scenario 'only users who follow a project can unfollow it' do
    #   sign_up('g@g.com', 'George')
    #   page.driver.submit :delete, "/projects/#{Project.last.id}/followers/#{Follower.last.id}", {}
    #   expect(page).to have_content 'Cannot unfollow the project'
    # end
  end
end
