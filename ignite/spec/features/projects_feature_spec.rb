require 'rails_helper'
require 'helpers/projects_helper_spec'

feature 'projects' do

  include ProjectsHelper

  context 'no projects have been added' do
    scenario 'page should have a title' do
      visit '/'
      expect(page).to have_title('Ignite')
    end

    scenario 'should display a prompt to add a project' do
      visit '/'
      expect(page).to have_content 'No projects yet'
      expect(page).to have_link 'Add a project'
    end
  end

  context 'project have been added' do
    before do
      visit '/'
      create_project('Project', 'This is the first project')
    end

    scenario 'display projects' do
      expect(page).to have_content('Project')
      expect(page).not_to have_content('No projects yet')
    end
  end

  context 'creating projects' do
    scenario 'prompts user to fill out a form, then displays a new project' do
      visit '/'
      create_project('Project', 'This is the first project')
      expect(page).to have_content 'Project'
      expect(current_path).to eq '/'
    end
  end

  context 'viewing projects' do
    scenario 'lets a user view a project' do
      visit '/'
      create_project('Project', 'This is the first project')
      click_link 'Project'
      expect(page).to have_content('Project')
      expect(page).to have_content('This is the first project')
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end
  end
end
