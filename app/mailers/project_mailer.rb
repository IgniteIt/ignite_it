class ProjectMailer < ApplicationMailer
  def updated(project)
    project.donations.each do |donation|
      person = User.find(donation.user_id)
      RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
         "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
         :from => "#{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
         :to => "#{person.email}",
         :subject => "#{project.name} was edited",
         :text => "Dear #{person.username}, \n A project you supported has been edited, click here to see the edit: http://localhost:3000/projects/#{project.id}\n."
         Rails.logger.info "I have been called. The user is #{person.username}"
    end
  end

  def reset_password_instructions(person, token, opts={})
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
         "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
         :from => "#IgniteIt <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
         :to => "#{person.email}",
         :subject => "Reset your password",
         :text => "Dear #{person.username}, \n Please reset your password: http://localhost:3000/users/password/edit?reset_password_token=#{token}\n IgniteIt"
         Rails.logger.info "I have been called. The user is #{person.username}"
  end
end
