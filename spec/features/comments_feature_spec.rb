require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'
require 'helpers/blogs_helper_spec'
require 'helpers/comments_helper_spec'

feature 'Commenting' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper
  include BlogsHelper
  include CommentsHelper

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    make_blog
  end

  scenario 'users can comment on a blog post' do
    make_comment
    expect(page).to have_content('I disagree!')
  end

  scenario 'only logged in users can comment' do
    click_link 'Sign out'
    click_link 'Campaign'
    click_link 'Comment'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'users can delete their own comments' do
    make_comment
    click_link 'Delete Comment'
    expect(page).to have_content('Comment deleted')
  end

  scenario 'users can edit their own comments' do
    make_comment
    click_link 'Edit Comment'
    fill_in 'Comment', with: 'I agree'
    click_button 'Submit'
    expect(page).to have_content('I agree')
  end

  scenario 'only users who made comments can delete or edit them' do
    make_comment
    click_link 'Sign out'
    sign_up('g@g.com', 'George')
    visit("/projects/#{Project.last.id}/blogs/#{Blog.last.id}/comments/#{Comment.last.id}/edit")
    expect(page).to have_content('Error, you did not create this comment')
    page.driver.submit :delete, "/projects/#{Project.last.id}/blogs/#{Blog.last.id}/comments/#{Comment.last.id}", {}
    expect(page).to have_content('Error, you did not create this comment')
  end
end