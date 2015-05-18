class Project < ActiveRecord::Base
  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true
end
