require 'rails_helper'

module ProjectsHelper
  def create_project(name, description, goal, exp_date, sector, address)
    click_link 'Add a project'
    fill_in_form(name, description, goal, exp_date, sector, address)
    click_button 'Create Project'
  end

  def create_project_with_media(name, description, goal, exp_date, sector, address)
    click_link 'Add a project'
    fill_in_media(name, description, goal, exp_date, sector, address)
    click_button 'Create Project'
  end

  def edit_project(description)
    click_link 'Edit'
    fill_in 'Description', with: description
    click_button 'Update Project'
  end

  def regular_description
    'Regular description' * 20
  end

  def edited_description
    'Edited description' * 20
  end

  def fill_in_form(name, description, goal, exp_date, sector, address)
    fill_in 'Name', with: name
    fill_in 'Description', with: description
    fill_in 'Goal', with: goal
    fill_in 'Address', with: address
    select exp_date, from: 'Expiration date'
    select sector, from: 'Sector'
  end

  def fill_in_media(name, description, goal, exp_date, sector, address)
    fill_in_form(name, description, goal, exp_date, sector, address)
    fill_in 'Video url', with: "https://www.youtube.com/watch?v=FOjdXSrtUxA"
    attach_file "Image",  Rails.root + "spec/asset_specs/rubber_duck.jpg"
  end

  def configure_project_stubs
    WebMock.stub_request(:post, "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
      with(:body => {"from"=>"postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", "subject"=>"Thanks!", "text"=>"Thank you for signing up to IgniteIt!", "to"=>"g@g.com"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'153', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
    WebMock.stub_request(:post, "https://api:key-d862abdfc169a5e8ba9b0a23ba5b9b78@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
       with(:body => hash_including({"from"=>"Campaign <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>", "subject"=>"Campaign was edited"})).to_return(:status => 200, :body => "", :headers => {}) # "text"=>"Dear Paul, \n A project you supported has been edited, click here to see the edit: http://localhost:3000/projects/12\n.", "to"=>"test@example.com"},
  end
end