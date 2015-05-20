class AddUserIdToDonations < ActiveRecord::Migration
  def change
    add_reference :donations, :user, index: true, foreign_key: true
  end
end
