class AddColumnsToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :profile_image, :string
    add_column :profiles, :gender, :integer, null: false, default: 0
    add_column :profiles, :birth_year, :integer, null: true, default: nil
    add_column :profiles, :self_introduction, :text
  end
end
