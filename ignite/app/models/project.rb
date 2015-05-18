class Project < ActiveRecord::Base
  validates :name, length: {minimum: 5}
end
