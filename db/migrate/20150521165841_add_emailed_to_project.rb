class AddEmailedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :emailed, :string
  end
end
