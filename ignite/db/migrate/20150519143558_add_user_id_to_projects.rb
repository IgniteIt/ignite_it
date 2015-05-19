class AddUserIdToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :user, index: true, foreign_key: true
  end
end
