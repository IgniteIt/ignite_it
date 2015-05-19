class AddAddressToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :address, :text
  end
end
