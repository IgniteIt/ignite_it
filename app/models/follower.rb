class Follower < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :user, uniqueness: { scope: :project, message: "is already following this project" }
end
