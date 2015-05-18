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
end