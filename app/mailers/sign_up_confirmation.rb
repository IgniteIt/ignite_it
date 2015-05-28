class SignUpConfirmation < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sign_up_confirmation.sign_up_confirm.subject
  #
  def sign_up_confirm(user)
    mg_client = Mailgun::Client.new(ENV['MAILGUN_KEY'])
    message_params = {:from    => "postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org",
                      :to      => user.email,
                      :subject => 'Thanks!',
                      :text    => 'Thank you for signing up to IgniteIt!'
                      }
    mg_client.send_message "sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", message_params
  end
end
