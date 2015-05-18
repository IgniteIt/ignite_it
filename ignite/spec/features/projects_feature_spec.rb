require 'rails_helper'

feature 'projects' do
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
      Project.create(name: 'Project', description: 'This is the first project')
    end

    scenario 'display projects' do
      visit '/'
      expect(page).to have_content('Project')
      expect(page).not_to have_content('No projects yet')
    end
  end

  context 'creating projects' do
    scenario 'prompts user to fill out a form, then displays a new project' do
      visit '/'
      click_link "Add a project"
      fill_in 'Name', with: 'Project'
      click_button 'Create Project'
      expect(page).to have_content 'Project'
      expect(current_path).to eq '/'
    end
  end
end