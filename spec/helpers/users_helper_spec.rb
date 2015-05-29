require 'rails_helper'

module UserHelper
  def sign_up(email='test@example.com', username='Paul')
    visit('/projects')
    click_link('Sign up')
    fill_in('Email', with: email)
    fill_in('Password', with: 'testtest')
    fill_in('Password Confirmation', with: 'testtest')
    fill_in('Username', with: username)
    click_button('Sign up')
  end

  def log_in
    visit('/projects')
    click_link('Sign in')
    fill_in('user_login', with: 'Paul')
    fill_in('user_password', with: 'testtest')
    click_button('Log in')
  end

  def configure_user_stubs
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'testing@facebook.com',
                :name => 'George McGowan'
              }
    })
    WebMock.stub_request(:post, "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
        with(:body => {"from"=>"postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", "subject"=>"Thanks!", "text"=>"Thank you for signing up to IgniteIt!", "to"=>"testing@facebook.com"},
          :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'166', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    visit('/projects')
  end
end
