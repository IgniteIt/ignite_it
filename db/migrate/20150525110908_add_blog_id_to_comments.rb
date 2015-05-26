class AddBlogIdToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :blog, index: true, foreign_key: true
  end
end
