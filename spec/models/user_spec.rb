require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :projects }

  it 'is not valid without a username ' do
    user = User.new(email: 'k@k.com', password:'12345678', password_confirmation: '12345678')
    expect(user).to have(1).error_on(:username)
    expect(user).not_to be_valid
  end

  it { is_expected.to have_many :donations }

  it { should have_many(:donations).dependent(:destroy) }

  it { is_expected.to have_many :comments }

  it { should have_many(:comments).dependent(:destroy) }
end
