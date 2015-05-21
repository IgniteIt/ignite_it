require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

# Checks to see if a project has been fully funded, past it's expiration date
# and emails users to tell them to pay up.

s.every '1h' do
  Rails.logger.info "Checking for completed projects #{Time.now}"
  Project.all.each do |project|
    expires = project.expiration_date - Time.now
    donations = project.donations.sum(:amount)
    if expires < 0 && project.goal <= donations && project.emailed != 'True'
      Donation.all.each do |donation|
        person = User.find(donation.user_id)
        RestClient.post "https://api:key-5367fa0dd4de3f39b6ed08eeb818e4b7"\
           "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
           :from => "{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
           :to => "#{person.email}",
           :subject => "#{project.name} was a success!",
           :text => "Dear #{person.username}, \n Please pay us. \n Click link to make payment: http://localhost:3000/projects/#{project.id}/charges/new\n Thanks"
        end
      Rails.logger.info "Sending Emails on project completion"
      project.update(emailed: 'True')
    end
  end
end
