class AddSectorToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sector, :string
  end
end
