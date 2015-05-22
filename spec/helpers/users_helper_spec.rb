require 'rails_helper'

module UserHelper
  def sign_up(email='test@example.com', username='Paul')
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: email)
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: username)
    click_button('Sign up')
  end

  def log_in
    visit('/')
    click_link('Sign in')
    fill_in('user_login', with: 'Paul')
    fill_in('user_password', with: 'testtest')
    click_button('Log in')
  end
end
