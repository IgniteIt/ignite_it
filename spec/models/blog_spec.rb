require 'rails_helper'

describe Blog, :type => :model do
  it { is_expected.to belong_to :project }
end