class RemoveNameFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :name, :string
  end
end
