require 'rails_helper'
require 'helpers/projects_helper_spec'

describe Project, :type => :model do
  include ProjectsHelper

  it 'is not valid with a name of less than five characters' do
    project = Project.new(name: 'Ca', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    expect(project).to have(1).error_on(:name)
    expect(project).not_to be_valid
  end

  it 'is not valid with a description of less than 200 characters' do
    project = Project.new(name: 'Campaign', description: 'Short description', goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    expect(project).to have(1).error_on(:description)
    expect(project).not_to be_valid
  end

  it 'is not valid unless it has an unique name' do
    Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    expect(project).to have(1).error_on(:name)
  end

  it 'is not valid without a goal' do
    project = Project.new(name: 'Campaign', description: regular_description, expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    expect(project).to have(1).error_on(:goal)
    expect(project).not_to be_valid
  end

  it 'is not valid without an expiration date' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', sector: 'Environment', address: 'London')
    expect(project).to have(1).error_on(:expiration_date)
    expect(project).not_to be_valid
  end

  it 'is not valid without a sector' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', address: 'London')
    expect(project).to have(1).error_on(:sector)
    expect(project).not_to be_valid
  end

  it 'is not valid without an address' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment')
    expect(project).to have(1).error_on(:address)
    expect(project).not_to be_valid
  end

end
