class AddPaidToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :paid, :boolean
  end
end
