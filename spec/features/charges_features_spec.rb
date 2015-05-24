require 'rails_helper'
require 'helpers/users_helper_spec'
require 'helpers/projects_helper_spec'
require 'helpers/donations_helper_spec'
require 'helpers/charges_helper_spec'

feature 'stripe' do

 include UserHelper
 include DonationsHelper
 include ProjectsHelper
 include ChargesHelper

  FactoryGirl.define do
    factory :user do
      email 'test@example.com'
      username 'testtest'
      password 'f4k3p455w0rd'
    end
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end
  
  before do
    stub_request(:post, "https://api:key-d862abdfc169a5e8ba9b0a23ba5b9b78@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages")
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
    @project = Project.create(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (1), sector: 'Environment', address: 'London', user: User.last)
  end

  after do
    Warden.test_reset! 
  end

  context 'if the user can pay' do
    before do
      @project.donations.create(amount: 7500, user: @user)
      sleep(1)
      visit "/projects/#{Project.last.id}/charges/new"
    end

    scenario 'fills in and submits stripe form', js: true, driver: :selenium do
      charge_helper
      expect(page).to have_content('you paid £ 75 for Campaign!')
    end

    scenario 'it change donation status to true', js: true, driver: :selenium do
      charge_helper
      expect(Donation.first.paid).to eq true
    end
  end

  context 'if the user can\'t pay' do

    scenario 'because he hasn\'t donated' do
      sleep(1)
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end

    scenario 'because the time is not expired' do
      @project.donations.create(amount: 7500, user: @user)
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end

    scenario 'because he has already paid' do
      @project.donations.create(amount: 7500, user: @user, paid: true)
      sleep(1)
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end

    scenario 'because the goal was not reached' do
      @project.donations.create(amount: 5000, user: @user)
      sleep(1)
      visit "/projects/#{Project.last.id}/charges/new"
      expect(page).to have_content 'No no'
    end
  end
end