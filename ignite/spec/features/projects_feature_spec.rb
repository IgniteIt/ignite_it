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

  context 'creating projects' do
    scenario 'prompts user to fill out a form, then displays a new project' do
      visit '/'
      create_project('Campaign', regular_description, '100')
      expect(page).to have_content 'Campaign'
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    context 'creating an invalid project' do
      it 'does not let you submit a name that is too short' do
        visit '/'
        create_project('Ca', regular_description, '100')
        expect(page).not_to have_content 'Ca'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a description that is too short' do
        visit '/'
        create_project('Campaign', 'Short description', '100')
        expect(page).not_to have_content 'Short description'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a unique name' do
        visit '/'
        create_project('Campaign', regular_description, '100')
        visit '/'
        create_project('Campaign', regular_description, '100')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a goal' do
        visit '/'
        create_project('Campaign', regular_description, '')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'project have been added' do
    before do
      visit '/'
      create_project('Campaign', regular_description, '100')
      visit '/'
    end

    scenario 'display projects' do
      expect(page).to have_content('Campaign')
      expect(page).not_to have_content('No projects yet')
    end

    scenario 'lets a user view a project' do
      click_link 'Campaign'
      expect(page).to have_content('Campaign')
      expect(page).to have_content(regular_description)
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'lets a user edit a project' do
      click_link 'Campaign'
      edit_project(edited_description)
      expect(page).to have_content 'And it has been edited!'
      expect(page).to have_content 'Project has been updated'
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'lets a user delete a project' do
      click_link 'Campaign'
      click_link 'Delete'
      expect(page).not_to have_content('Campaign')
      expect(page).to have_content 'Project has been deleted'
      expect(current_path).to eq '/'
    end
  end
end
