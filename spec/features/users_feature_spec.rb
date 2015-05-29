require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
include UserHelper

context "user not signed in and on the homepage" do
  it "should see a 'sign in' link and a 'sign up' link" do
    visit('/projects')
    expect(page).to have_link('Sign in')
    expect(page).to have_link('Sign up')
  end

  it "should not see 'sign out' link" do
    visit('/projects')
    expect(page).not_to have_link('Sign out')
  end

  it "when facebook credentials are invalid, will show an error" do
    configure_user_stubs
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_link 'Sign in'
    click_link 'facebook_login'
    expect(page).to have_content ('Invalid credentials')
  end

  it "when facebook credentials are valid, it will make a user" do
    configure_user_stubs
    click_link 'Sign in'
    click_link 'facebook_login'
    expect(User.last.email).to eq "testing@facebook.com"
  end

  it "on sign up, the user is sent an email" do
    sign_up
    expect(WebMock).to have_requested(:post,
      "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages"
      ).with(:body => "from=postmaster%40sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org&to=test%40example.com&subject=Thanks!&text=Thank%20you%20for%20signing%20up%20to%20IgniteIt!")
  end
end

context "user signed in on the homepage" do

  before do
    sign_up
  end

  it "should see 'sign out' link" do
    visit('/projects')
    expect(page).to have_link('Sign out')
  end

  it "should not see a 'sign in' link and a 'sign up' link" do
    visit('/projects')
    expect(page).not_to have_link('Sign in')
    expect(page).not_to have_link('Sign up')
  end

  it "can log in with a username instead of an email" do
    click_link('Sign out')
    log_in
    expect(page).to have_content('Signed in successfully')
  end
end

context "user can upload an avatar" do
  before do
    visit('/projects')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password Confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    attach_file 'user_avatar', './spec/fixtures/me.jpg'
    click_button('Sign up')
  end

  it 'should be able to upload an avatar' do
    visit('/projects')
    expect(page.find('#avatar_image')['src']).to have_content 'me.jpg'
  end
end

context "user can edit their profile" do
  before do
    sign_up
  end

  it "user can edit their profile" do
    visit('/projects')
    expect(page).to have_link('Edit profile')
  end
end

context "user can add a username" do
  it "can add a username" do
    sign_up
    expect(page).to have_content('Paul')
  end
end

context "user is associated with a project they made" do
  include ProjectsHelper
  it "can create a project and see their username" do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    click_link 'Sign out'
    click_link 'Campaign'
    expect(page).to have_content('This project was created by Paul')
  end
end
