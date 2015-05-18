require 'rails_helper'

module ProjectsHelper

  def create_project(name, description)
    click_link 'Add a project'
    fill_in 'Name', with: name
    fill_in 'Description', with: description
    click_button 'Create Project'
  end
end