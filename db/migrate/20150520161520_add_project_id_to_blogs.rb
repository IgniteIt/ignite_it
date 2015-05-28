class AddProjectIdToBlogs < ActiveRecord::Migration
  def change
    add_reference :blogs, :project, index: true, foreign_key: true
  end
end
