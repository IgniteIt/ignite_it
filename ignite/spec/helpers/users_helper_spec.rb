require 'rails_helper'

module UserHelper
  def sign_up
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    fill_in('Username', with: 'Paul')
    click_button('Sign up')
  end
end