class Project < ActiveRecord::Base
  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true
  validates :expiration_date, presence: true

  def set_expiration_date(days)
    if (days).to_i > 0
      expiration_date = (Time.now + (days).to_i)
    end
  end
end