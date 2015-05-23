require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'blogs' do
  include ProjectsHelper
  include UserHelper

  before do
    sign_up
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/'
    # WebMock.disable_net_connect!(allow_localhost: true)
    # stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=London&language=en&sensor=false").
    #      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    #      to_return(:status => 200, :body => "", :headers => {})
  end

  context 'Projects and their blogs' do
    scenario 'Owner creates a blog' do
      click_link 'Campaign'
      click_link 'Create Blog'
      fill_in 'Title', with: 'Blog 1'
      fill_in 'Content', with: 'This is my project'
      click_button 'Submit'
      expect(page).to have_content('Blog 1')
      expect(page).to have_content('This is my project')
      expect(current_path).to eq ("/projects/#{Project.last.id}")
    end

    scenario 'Owner has to be signed in to create blog' do
      click_link 'Sign out'
      sign_up('paul@paul.com', 'Shaggy')
      click_link 'Campaign'
      click_link 'Create Blog'
      expect(page).to have_content('You are not the project owner')
    end

    xscenario 'When owner makes blog, all donors are notified' do
      
      # stub_request(:post, "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net").
      #   with(:body => "abc", :headers => { 'Content-Length' => 3 })

      # uri = URI.parse("https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net")
      # req = Net::HTTP::Post.new(uri.path)
      # req['Content-Length'] = 3

      # res = Net::HTTP.start(uri.host, uri.port) do |http|
      #   http.request(req, "abc")
      # end    # ===> Success
    end
  end
end
