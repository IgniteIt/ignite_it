class ProjectMailer < ApplicationMailer
  def updated(project)
    project.donations.each do |donation|
      person = User.find(donation.user_id)
      RestClient.post "https://api:key-5367fa0dd4de3f39b6ed08eeb818e4b7"\
         "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
         :from => "#{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
         :to => "#{person.email}",
         :subject => "#{project.name} was edited",
         :text => "Dear #{person.username}, \n A project you supported has been edited, click here to see the edit: http://localhost:3000/projects/#{project.id}\n."
    end
  end
end



      #     mg_client = Mailgun::Client.new(ENV['MAILGUN_KEY'])
      # message_params = {:from    => "postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org",
      #                   :to      => person.email,
      #                   :subject => "#{project.name} was edited",
      #                   :text    => "Dear #{person.username}, \n A project you supported has been edited, click here to see the edit: http://localhost:3000/projects/#{project.id}\n."
      #                   }
      # mg_client.send_message "sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", message_params