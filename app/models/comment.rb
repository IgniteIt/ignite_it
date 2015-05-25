class Comment < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user

  def is_owner?(user)
    self.user == user
  end
end
