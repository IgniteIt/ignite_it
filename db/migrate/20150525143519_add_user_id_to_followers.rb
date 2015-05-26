class AddUserIdToFollowers < ActiveRecord::Migration
  def change
    add_reference :followers, :user, index: true, foreign_key: true
  end
end
