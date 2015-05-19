class Project < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true
  validates :expiration_date, presence: true
  validates :sector, presence: true
  validates :address, presence: true

  belongs_to :user

  def set_expiration_date(days)
    if (days).to_i > 0
      self.expiration_date = (Time.now + (days).to_i)
    end
  end
end