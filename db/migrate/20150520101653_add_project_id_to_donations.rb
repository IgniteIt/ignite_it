class AddProjectIdToDonations < ActiveRecord::Migration
  def change
    add_reference :donations, :project, index: true, foreign_key: true
  end
end
