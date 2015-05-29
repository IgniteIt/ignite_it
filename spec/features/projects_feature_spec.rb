require 'rails_helper'
require 'helpers/projects_helper_spec'
require 'helpers/users_helper_spec'
require 'helpers/donations_helper_spec'

feature 'projects' do
  include ProjectsHelper
  include UserHelper
  include DonationsHelper

  before do
    sign_up
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  context 'no projects have been added' do
    scenario 'page should have a title' do
      visit '/projects'
      expect(page).to have_title('Ignite')
    end

    scenario 'should display a prompt to add a project' do
      visit '/projects'
      expect(page).to have_content 'No projects found'
      expect(page).to have_link 'new_project_link'
    end
  end

  context 'projects have been added' do
    before do
      visit '/projects'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      visit '/projects'
    end

    scenario 'display projects' do
      expect(page).to have_content('Campaign')
      expect(page).not_to have_content('No projects found')
    end

    scenario 'lets a user view a project' do
      click_link 'Campaign'
      expect(page).to have_content('Campaign')
      expect(page).to have_content(regular_description)
      expect(current_path).to eq "/projects/#{Project.last.id}"
    end

    context 'on the show page' do
      before do
        click_link 'Campaign'
      end

      scenario 'there is a project with a name' do
        expect(page).to have_content 'Campaign'
      end

      scenario 'there is a project with a goal' do
        expect(page).to have_content '£ 100'
      end

      scenario 'there is a project with a expiration date' do
        expect(page).to have_css("#due_date_timer_#{Project.last.id}")
      end

      scenario 'there is a project with a remaning amount' do
        make_payment(75)
        expect(page).to have_content('Pending: £ 25')
      end

      scenario 'there is a project with a completed goal' do
        make_payment(100)
        expect(page).to have_content('Goal reached!')
      end

      scenario 'there is a project with a non completed goal' do
        project = Project.last
        project.set_expiration_date(1.second)
        project.save
        sleep(1)
        visit current_path
        expect(page).to have_content('Goal not reached.')
      end

      scenario 'there is a project with a map' do
        expect(page).to have_css('#map')
      end

      context 'Project is over and the goal was reached' do
        before do
          make_payment(100)
          project = Project.last
          project.set_expiration_date(1.second)
          project.save
          sleep(1)
          visit current_path
        end

        scenario 'it shows a goal reached message' do
          expect(page).to have_content 'Goal reached'
        end
      end
    end
  end

  context 'project has been created with media' do
      
      before do
        visit '/projects'
        create_project_with_media('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      end

      context'on the show page' do

        scenario 'there is a project with an image' do
          expect(page).to have_xpath("//img[@alt='Rubber duck']")
        end

        scenario 'there is a project with a video' do
          expect(page).to have_xpath("//iframe[@src='//www.youtube.com/embed/FOjdXSrtUxA?wmode=transparent']")
        end

      end
    end

  context 'User can navigate the app' do
    before do
      visit '/projects'
      create_project('Campaign', regular_description, '100', '30 days from now', 'Environment', 'London')
      visit '/projects'
    end

    scenario 'project view page has a return to homepage link' do
      click_link 'Campaign'
      click_link 'Ignite'
      expect(current_path).to eq '/projects'
    end
  end

end
