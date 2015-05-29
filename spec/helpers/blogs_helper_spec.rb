require 'rails_helper'

module BlogsHelper
  def make_blog
    visit '/projects'
    click_link 'Campaign'
    click_link 'Write Update'
    fill_in 'Title', with: 'Blog 1'
    fill_in 'Content', with: 'This is my project'
    click_button 'Submit'
  end

  def configure_blog_stubs
    WebMock.stub_request(:post, "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
         with(:body => hash_including({"from"=>"Campaign <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>", "subject"=>"Campaign has posted a blog"})).to_return(:status => 200, :body => "", :headers => {}) #, "text"=>"Dear Paul, \n A project you supported has published a blog post,click here to see it: http://localhost:3000/projects/3\n.", "to"=>"test@example.com"},
  end
end