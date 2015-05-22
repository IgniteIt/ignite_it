require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
include UserHelper

context "user not signed in and on the homepage" do
  it "should see a 'sign in' link and a 'sign up' link" do
    visit('/')
    expect(page).to have_link('Sign in')
    expect(page).to have_link('Sign up')
  end

  it "should not see 'sign out' link" do
    visit('/')
    expect(page).not_to have_link('Sign out')
  end

  it "when facebook credentials are invalid, will show an error" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit('/')
    click_link 'Sign in with Facebook'
    expect(page).to have_content ('Invalid credentials')
  end

  it "when facebook credentials are valid, it will make a user" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'testing@facebook.com',
                :name => 'George McGowan'
              }
    })
    visit('/')
    click_link 'Sign in with Facebook'
    expect(User.last.email).to eq "testing@facebook.com"
  end
end

context "user signed in on the homepage" do

  before do
    sign_up
  end

  it "should see 'sign out' link" do
    visit('/')
    expect(page).to have_link('Sign out')
  end

  it "should not see a 'sign in' link and a 'sign up' link" do
    visit('/')
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
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    attach_file 'user_avatar', './spec/fixtures/me.jpg'
    click_button('Sign up')
  end

  it 'should be able to upload an avatar' do
    visit('/')
    expect(page.find('#avatar_image')['src']).to have_content 'me.jpg'
  end
end

context "user can edit their profile" do
  before do
    sign_up
  end

  it "user can edit their profile" do
    visit('/')
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
