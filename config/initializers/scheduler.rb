require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

# Checks to see if a project has been fully funded, past it's expiration date
# and emails users to tell them to pay up.

s.every '1h' do
  Rails.logger.info "Checking for completed projects #{Time.now}"
  project_expire_check
end

def project_expire_check
  Project.all.each do |project|
    expires = project.expiration_date - Time.now
    donations = project.donations.sum(:amount)
    if expires < 0 && project.goal <= donations && project.emailed != 'True'
      complete_emailer(project)
    elsif expires < 0 && project.goal > donations && project.emailed != 'True'
      goal_not_met(project)
    end
  end
end

private

def complete_emailer(project)
  donations = Donation.where(project_id: project.id)
  donations.each do |donation|
    person = User.find(donation.user_id)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
       "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
       :from => "#{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
       :to => "#{person.email}",
       :subject => "#{project.name} was a success!",
       :text => "Dear #{person.username}, \n Please pay us. \n Click link to make payment: http://localhost:3000/projects/#{project.id}/charges/new\n Thanks"
  end
  Rails.logger.info "Sending Emails on project completion"
  project.update(emailed: 'True')
end

def goal_not_met(project)
  donations = Donation.where(project_id: project.id)
  donations.each do |donation|
    person = User.find(donation.user_id)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
       "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
       :from => "#{project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
       :to => "#{person.email}",
       :subject => "#{project.name} was a unsuccessful",
       :text => "Dear #{person.username}, \n As the project failed to reach its funds goal your pledge is no longer required."
  end
  Rails.logger.info "Sending Emails on project completion"
  project.update(emailed: 'True')
end
