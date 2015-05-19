class AddExpirationDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :expiration_date, :datetime
  end
end
