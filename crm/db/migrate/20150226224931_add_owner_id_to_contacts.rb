class AddOwnerIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :owner_id, :integer
  end
end
