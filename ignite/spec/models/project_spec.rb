require 'rails_helper'

describe Project, :type => :model do
  it "is not valid with a name of less than five characters" do
    project = Project.new(name: 'Ca')
    expect(project).to have(1).error_on(:name)
    expect(project).not_to be_valid
  end
end