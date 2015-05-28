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

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end
  
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

    scenario 'who is not the owner cannot create a blog' do
      click_link 'Sign out'
      sign_up('g@g.com', 'Shaggy')
      click_link 'Campaign'
      expect(page).not_to have_content 'Create Blog'
    end

    scenario 'Owner has to be signed in to create blog' do
      click_link 'Sign out'
      sign_up('g@g.com', 'Shaggy')
      click_link 'Campaign'
      visit "/projects/#{Project.last.id}/blogs/new"
      expect(page).to have_content('You are not the project owner')
    end

    scenario 'When owner makes a blog, all donors are notified' do
      make_payment
      make_blog
      expect(WebMock).to have_requested(:post, 
        "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages"
        ).with(:body => hash_including({"from"=>"Campaign <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>", "subject"=>"Campaign has posted a blog"}))
    end

    scenario 'Owner can edit a blog' do
      make_blog
      click_link 'Edit Update'
      fill_in 'Content', with: 'This is not my project'
      click_button 'Submit'
      expect(page).to have_content 'This is not my project'
    end

    scenario 'Owner can delete a blog' do
      make_blog
      click_link 'Delete Update'
      expect(page).to have_content 'Blog deleted'
      expect(page).not_to have_content 'This is my project'
    end

    scenario 'Only owner can edit and delete blogs' do
      make_blog
      click_link 'Sign out'
      sign_up('g@g.com', 'Shaggy')
      click_link 'Campaign'
      visit("/projects/#{Project.last.id}/blogs/#{Blog.last.id}/edit")
      expect(page).to have_content('You are not the project owner')
      page.driver.submit :delete, "/projects/#{Project.last.id}/blogs/#{Blog.last.id}", {}
      expect(page).to have_content('You are not the project owner')
    end
  end
end
