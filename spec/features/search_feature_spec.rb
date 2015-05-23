require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'Project search' do
  include ProjectsHelper
  include UserHelper

  before do
    sign_up
    visit '/'
    create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
    visit '/'
    create_project('Another', regular_description, '100', '30 days from now', 'Energy', 'Manchester')
    visit '/'
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

    scenario 'if unable to get location, it set London as default' do
      expect(page).to have_content 'London'
      expect(page).not_to have_content 'Manchester'
    end

    scenario 'it populates the sector search trough database values' do
      expect(page).to have_select(:sector_search, options: ['Search by sector', 'Environment', 'Energy'])
    end

    scenario 'it paginate the query' do
      num = 0
      5.times do
        create_project("Another #{num}", regular_description, '100', '30 days from now', 'Energy', 'London')
        visit '/'
        num += 1
      end
      click_link 'Next ›'
      expect(page).to have_content "Another 4"
      expect(page).not_to have_content "Another 3"
    end
  end

  context 'performing a search' do
    scenario 'it can search for a project by location' do
      fill_in :search, with: 'Manchester'
      click_button 'Search'
      expect(page).to have_content 'Manchester'
      expect(page).not_to have_content 'London'
    end

    scenario 'it can search for a project by his name' do
      fill_in :search, with: 'Another'
      click_button 'Search'
      expect(page).to have_content 'Another'
      expect(page).not_to have_content 'Campaign'
    end

    scenario 'it can search for a project by his sector' do
      select 'Energy', from: :sector_search
      click_button 'Sector search'
      expect(page).to have_content 'Another'
      expect(page).not_to have_content 'Campaign'
    end
  end
end