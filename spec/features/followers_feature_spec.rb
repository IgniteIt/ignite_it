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
      visit '/projects'
      expect(page).not_to have_css('.glyphicon-star-empty')
    end
  end

  context 'user logged in' do
    before do
      stub_request(:post, "https://api:key-d862abdfc169a5e8ba9b0a23ba5b9b78@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages")
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)
      visit '/projects'
    end

    scenario 'cannot follow projects twice', js: true, driver: :selenium do
      find('.glyphicon-star-empty').click
      expect(page).not_to have_css('.glyphicon-star-empty')
      expect(page).to have_css '.glyphicon-star'
    end

    scenario 'can unfollow projects', js: true, driver: :selenium do
      find('.glyphicon-star-empty').click
      find('.glyphicon-star').click
      expect(page).to have_css('.glyphicon-star-empty')
      expect(page).not_to have_css '.glyphicon-star'
    end

    scenario 'a user can follow a project, which updates the project follow count', js: true, driver: :selenium do
      find('.glyphicon-star-empty').click
      expect(page).to have_css('.followers_count', text: "1")
    end

    scenario 'if follow is not saved, then user is redirected to the projects page', js: true, driver: :selenium do
      find('.glyphicon-star-empty').click
      visit "/projects/#{Project.last.id}/followers/new"
      expect(current_path).to eq '/projects'
      expect(page).to have_content ('You are already following the project')
    end
  end
end
