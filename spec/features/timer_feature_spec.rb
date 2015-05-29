require 'rails_helper'
require 'helpers/users_helper_spec'
require 'helpers/projects_helper_spec'

feature 'timer' do

 include UserHelper
 include ProjectsHelper
  
  before do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
    @project = Project.new(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (30.days), sector: 'Environment', address: 'London', video_url: "", user: User.last)
  end

  context 'when a project is running' do
    
    scenario 'it calculates 30 days from now in weeks and days', js: true, driver: :selenium do
      @project.save
      visit '/projects'
      expect(page).to have_content('4 Weeks 1 Day')
    end

    scenario 'it calculates 60 days from now in months and weeks', js: true, driver: :selenium do
      @project.set_expiration_date(60.days)
      @project.save
      visit '/projects'
      expect(page).to have_content('1 Month 4 Weeks')
    end

    scenario 'it calculates 10 days from now in weeks and days', js: true, driver: :selenium do
      @project.set_expiration_date(10.days)
      @project.save
      visit '/projects'
      expect(page).to have_content('1 Week 2 Days')
    end

    scenario 'it calculates 6 days from now in days and hours', js: true, driver: :selenium do
      @project.set_expiration_date(6.days)
      @project.save
      visit '/projects'
      expect(page).to have_content('5 Days 23 Hours')
    end

    scenario 'it calculates 1 day from now in hours and minutes', js: true, driver: :selenium do
      @project.set_expiration_date(1.day)
      @project.save
      visit '/projects'
      expect(page).to have_content('23 Hours 59 Minutes')
    end

    scenario 'it calculates 1 hour from now in minutes and seconds', js: true, driver: :selenium do
      @project.set_expiration_date(1.hour)
      @project.save
      visit '/projects'
      expect(page).to have_content('59 Minutes')
      expect(page).to have_content('Seconds')
    end
  end

  context 'when a projects expires' do
    # scenario 'change his status when user is on the page', js: true, driver: :selenium do
    #   @project.set_expiration_date(2.seconds)
    #   @project.save
    #   visit "/"
    #   expect(page).to have_content('Seconds')
    #   sleep(1)
    #   expect(page).to have_content('Project Closed')
    # end

    scenario 'when a user arrives on the page status is already changed', js: true, driver: :selenium do
      @project.set_expiration_date(1.second)
      @project.save
      sleep(1)
      visit '/projects'
      find('#search_link').click
      fill_in :search, with: 'Campaign'
      click_button 'Search'
      expect(page).to have_content('Project Closed')
    end
  end
end