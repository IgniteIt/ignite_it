require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'Project search' do
  include ProjectsHelper
  include UserHelper

  before do
    Project.create!(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (120), sector: 'Environment', address: 'London')
    Project.create!(name: 'Another', description: regular_description, goal: '75', expiration_date: Time.now + (120), sector: 'Energy', address: 'Manchester')
    Project.create!(name: 'Third', description: regular_description, goal: '75', expiration_date: Time.now + (120), sector: 'Energy', address: 'London')
    visit '/projects'
    find('#search_link').click
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  context 'when a search is not performed' do
    # NO CLUE
    #
    # scenario 'it sets user location as default search param' do
    #   expect(page).to have_content 'Manchester'
    #   expect(page).not_to have_content 'London'
    # end

    it 'doesn\'t show the search' do
      expect(page).to have_content 'London'
      expect(page).not_to have_content 'Manchester'
    end

    scenario 'it populates the sector search trough database values' do
      expect(page).to have_select(:sector, options: ['Search by sector', 'Energy', 'Environment'])
    end

  end

  context 'performing a search' do

    scenario 'it paginate the query', js: true, driver: :selenium do
      num = 0
      until num > 5 do
        Project.create(name: "Another #{num}", description: regular_description, goal: '75', expiration_date: Time.now + (120), sector: 'Energy', address: 'Manchester')
        num += 1
      end
      fill_in :search, with: 'Another'
      click_button 'Search'
      click_link 'Next ›'
      expect(page).to have_content "Another 4"
      expect(page).not_to have_content "Another 3"
    end

    scenario 'it can search for a project by location', js: true, driver: :selenium do
      fill_in :search, with: 'Manchester'
      click_button 'Search'
      expect(page).to have_content 'Manchester'
      expect(page).not_to have_content 'London'
    end

    scenario 'it can search for a project by his name', js: true, driver: :selenium do
      fill_in :search, with: 'Another'
      click_button 'Search'
      expect(page).to have_content 'Another'
      expect(page).not_to have_content 'Campaign'
    end

    scenario 'it can search for a project by his sector', js: true, driver: :selenium do
      select 'Energy', from: :sector
      click_button 'Search'
      expect(page).to have_content 'Third'
      expect(page).not_to have_content 'Campaign'
    end

    scenario 'it can perform a combined search', js: true, driver: :selenium do
      select 'Energy', from: :sector
      fill_in :search, with: 'Manchester'
      click_button 'Search'
      expect(page).to have_content 'Another'
      expect(page).not_to have_content 'Campaign'
    end
  end
end