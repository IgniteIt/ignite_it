require 'rails_helper'

module ProjectsHelper
  def create_project(name, description, goal, exp_date)
    click_link 'Add a project'
    fill_in 'Name', with: name
    fill_in 'Description', with: description
    fill_in 'Goal', with: goal
    select exp_date, from: 'Expiration date'
    click_button 'Create Project'
  end

  def edit_project(description)
    click_link 'Edit'
    fill_in 'Description', with: description
    click_button 'Update Project'
  end

  def regular_description
    'This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.'
  end

  def edited_description
    'This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    This is a regular description because is longer than 200 chars.
    And it has been edited!'
  end

end