class AddColumnsToOshiDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :oshi_details, :oshi_image, :string
  end
end
