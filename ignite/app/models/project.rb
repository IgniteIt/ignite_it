class Project < ActiveRecord::Base
  validates :name, length: {minimum: 5}
  validates :description, length: {minimum: 200}
end
