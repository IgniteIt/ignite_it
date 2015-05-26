require 'rails_helper'

describe Follower, type: :model do
  it { is_expected.to belong_to :project}
  it { is_expected.to belong_to :user}
end
