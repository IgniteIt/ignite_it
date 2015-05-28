require 'rails_helper'
require 'helpers/projects_helper_spec'

describe Project, :type => :model do

  FactoryGirl.define do
    factory :a_user, class: User
    factory :another_user, class: User
  end

  before(:each) do
    allow_any_instance_of(Project).to receive(:geocode).and_return([1,1])
  end

  include ProjectsHelper

  it { is_expected.to belong_to :user }

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

  it 'is not valid with an invalid video url' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', video_url: 'www.iminvalid.com/invalid')
    expect(project).to have(1).error_on(:video_url)
    expect(project).not_to be_valid
  end

  it 'can calculate the expiration date' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.set_expiration_date(30.days)
    days_from_now = (((project.expiration_date - Time.now).to_i / 60) / 60) / 24
    expect(days_from_now).to eq(29)
  end

  it 'knows if he has no pic' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    expect(project.has_pic?).to eq false
  end

  it 'knows if he has no video' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London', video_url: "")
    expect(project.has_video?).to eq false
  end

  it 'knows the total of the donations' do
    project = Project.create!(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 1000)
    project.donations.create(amount: 3000)
    expect(project.donation_sum).to eq 40
  end

  it 'knows the remaining' do
    project = Project.create!(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 1000)
    project.donations.create(amount: 3000)
    expect(project.remaining).to eq 60
  end

  it 'knows if the goal was reached' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 10000)
    expect(project.goal_reached?).to be true
  end

  it 'knows if the goal was not reached' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 5000)
    expect(project.goal_reached?).to be false
  end

  it 'prints a message with how much left to reach the goal' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.set_expiration_date(1.day)
    project.donations.create(amount: 1000)
    project.donations.create(amount: 3000)
    expect(project.remaining_message).to eq 'Pending: £ 60'
  end

  it 'print a message when the goal is reached' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 10000)
    expect(project.remaining_message).to eq 'Goal reached!'
  end

  it 'print a message when the goal is not reached' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.remaining_message).to eq 'Goal not reached.'
  end

  it 'knows if a project has expired' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.has_expired?).to be true
  end

  it 'knows if a project is not expired' do
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.set_expiration_date(30.days)
    expect(project.has_expired?).to be false
  end

  it 'knows if a project has succeded' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 10000)
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.success?).to be true
  end

  it 'knows if a project has not succeded' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 1000)
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.success?).to be false
  end

  it 'knows if a project was paid' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 1000, user: user, paid: true)
    project.donations.create(amount: 1000, user: user, paid: true)
    expect(project.was_paid?(user)).to be true
  end

  it 'knows if a project was not paid' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 1000, user: user, paid: true)
    project.donations.create(amount: 1000, user: user, paid: false)
    expect(project.was_paid?(user)).to be false
  end

  # it 'knows if he can get user location' do
  #   expect(cant_get_location?).to be true
  # end

  it 'can get sector values' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project = Project.create(name: 'Another', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Energy', address: 'London')
    expect(options_for_sector_search).to eq([["Search by sector", nil, {:disabled=>true, :selected=>true}], 'Energy', 'Environment'])
  end

  it 'knows if a user has donated' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 1000, user: user)
    expect(project.has_donated?(user)).to be true
  end

  it 'knows if a user has not donated' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    another_user = build(:another_user)
    project.donations.create(amount: 1000, user: another_user)
    expect(project.has_donated?(user)).to be false
  end

  it 'knows if a project is payable by a user' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 10000, user: user)
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.is_payable_by(user)).to be true
  end

  it 'knows if a project is not payable by a user because it is already paid' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 1000, user: user, paid: true)
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.is_payable_by(user)).to be false
  end

  it 'knows if a project is not payable by a user because the time has not expired' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.donations.create(amount: 1000, user: user)
    project.set_expiration_date(30.days)
    expect(project.is_payable_by(user)).to be false
  end

  it 'knows if a project is not payable by a user because he hasn\'t donated' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    user = build(:a_user)
    project.set_expiration_date(1.second)
    sleep(1)
    expect(project.is_payable_by(user)).to be false
  end

  it 'knows if a user is the owner' do
    a_user = build(:a_user)
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London', user: a_user)
    expect(project.is_owner?(a_user)).to eq true
  end

  it 'knows if a user is not the owner' do
    a_user = build(:a_user)
    another_user = build(:another_user)
    project = Project.new(name: 'Campaign', description: regular_description, goal: '100', expiration_date: '30 days from now', sector: 'Environment', address: 'London', user: a_user)
    expect(project.is_owner?(another_user)).to eq false
  end

  it 'knows the percentage of the goal completed for each project' do
    project = Project.create(name: 'Campaign', description: regular_description, goal: 100, expiration_date: '30 days from now', sector: 'Environment', address: 'London')
    project.donations.create(amount: 1000)
    expect(project.percentage_goal_completed).to eq(10)
    expect(project.percentage_goal_pending).to eq(90)
  end

end
