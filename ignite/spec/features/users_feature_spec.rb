require 'rails_helper'

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
end

context "user signed in on the homepage" do

  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    click_button('Sign up')
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
    visit('/')
    click_link('Sign out')
    click_link('Sign in')
    fill_in('user_login', with: 'Paul')
    fill_in('user_password', with: 'testtest')
    click_button('Log in')
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
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    click_button('Sign up')
  end

  it "user can edit their profile" do
    visit('/')
    expect(page).to have_link('Edit profile')
  end
end

context "user can add a username" do
  it "can add a username" do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    click_button('Sign up')
    expect(page).to have_content('Paul')
  end
end
