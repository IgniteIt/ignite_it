require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/blogs_helper_spec'
require 'helpers/donations_helper_spec'

feature 'blogs' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper
  include BlogsHelper

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    configure_project_stubs
    configure_blog_stubs
  end

  context 'Projects and their blogs' do
    scenario 'Owner creates a blog' do
      make_blog
      expect(page).to have_content('Blog 1')
      expect(page).to have_content('This is my project')
      expect(current_path).to eq ("/projects/#{Project.last.id}")
    end

    scenario 'Owner has to be signed in to create blog' do
      click_link 'Sign out'
      sign_up('g@g.com', 'Shaggy')
      click_link 'Campaign'
      click_link 'Create Blog'
      expect(page).to have_content('You are not the project owner')
    end

    scenario 'When owner makes a blog, all donors are notified' do
      make_payment(25)
      make_blog
      expect(WebMock).to have_requested(:post, 
        "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages"
        ).with(:body => hash_including({"from"=>"Campaign <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>", "subject"=>"Campaign has posted a blog"}))
    end
  end
end
