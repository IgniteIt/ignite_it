class Donation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :amount, presence: true

  def with_pence(amount)
    amount.to_i * 100
  end

  def without_pence(amount)
    amount / 100
  end

end
