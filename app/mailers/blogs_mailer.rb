class BlogsMailer < ApplicationMailer
  def email_re_blog(project)
    project.donations.each do |donation|
      person = User.find(donation.user_id)
      RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
         "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
         :from => "#{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
         :to => "#{person.email}",
         :subject => "#{project.name} has posted a blog",
         :text => "Dear #{person.username}, \n A project you supported has published a blog post,"\
                  "click here to see it: http://localhost:3000/projects/#{project.id}\n."
         # :html => "Dear #{person.username}, \n A project you supported has published a blog post,"\
                  # "click here to see it: http://localhost:3000/projects/#{project.id}\n."
    end
  end
end
