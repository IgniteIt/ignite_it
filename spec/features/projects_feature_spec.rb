require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'

feature 'projects' do
  include ProjectsHelper
  include UserHelper

  before do
    sign_up
  end

  before(:each) do
    Project.any_instance.stub(:geocode).and_return([1,1])
  end

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
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      expect(page).to have_content 'Campaign'
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    scenario 'after creating a project the list in the home page self update' do
      visit '/'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      visit '/'
      expect(page).to have_content 'Campaign'
      expect(page).to have_content '£100'
      expect(page).to have_css("#due_date_timer_#{Project.last.id}")
    end

    context 'creating an invalid project' do
      it 'does not let you submit a name that is too short' do
        visit '/'
        create_project('Ca', regular_description, '100', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Ca'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a description that is too short' do
        visit '/'
        create_project('Campaign', 'Short description', '100', '30 days from now', 'Environment', 'London')
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a unique name' do
        visit '/'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
        visit '/'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a goal' do
        visit '/'
        create_project('Campaign', regular_description, '', '30 days from now', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without an expiration date' do
        visit '/'
        create_project('Campaign', regular_description, '100', 'Select an expiration date', 'Environment', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without a sector' do
        visit '/'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Select a sector', 'London')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end

      it 'does not let you submit a project without an address' do
        visit '/'
        create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', '')
        expect(page).not_to have_content 'Campaign'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'projects have been added' do
    before do
      visit '/'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
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

    context 'on the view page' do
      before do
        click_link 'Campaign'
      end

      scenario 'there is a project with a name' do
        expect(page).to have_content 'Campaign'
      end

      scenario 'there is a project with a goal' do
        expect(page).to have_content '£100'
      end

      scenario 'there is a project with a expiration date' do
        expect(page).to have_css('#due_date_timer')
      end

      scenario 'there is a project with a expiration date' do
        expect(page).to have_css('#map')
      end

      scenario 'there is a project with an image' do
        expect(page).to have_xpath("//img[@alt='Rubber duck']")
      end

      scenario 'there is a project with a video' do
        expect(page).to have_xpath("//iframe[@src='//www.youtube.com/embed/FOjdXSrtUxA?wmode=transparent']")
      end
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

    scenario 'only users who made a project can delete them' do
      click_link 'Sign out'
      sign_up('g@g.com','George')
      visit('/')
      click_link 'Campaign'
      page.driver.submit :delete, "/projects/#{Project.last.id}", {}
      expect(page).to have_content 'Error'
    end

    scenario 'only users who made a project can edit them' do
      click_link 'Sign out'
      sign_up('g@g.com', 'George')
      visit('/')
      click_link 'Campaign'
      visit("/projects/#{Project.last.id}/edit")
      expect(page).to have_content 'Error'
    end
  end

  context 'User can navigate the app' do
    before do
      visit '/'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      visit '/'
    end

    scenario 'project view page has a return to homepage link' do
      click_link 'Campaign'
      click_link 'Return to Homepage'
      expect(current_path).to eq '/projects'
    end
  end

end
