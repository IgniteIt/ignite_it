require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'
require 'helpers/blogs_helper_spec'

feature 'Commenting' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper
  include BlogsHelper

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    make_blog
  end

  scenario 'users can comment on a blog post' do
    click_link 'Comment'
    fill_in 'Comment', with: 'I disagree!'
    click_button 'Submit'
    expect(page).to have_content('I disagree!')
  end
end