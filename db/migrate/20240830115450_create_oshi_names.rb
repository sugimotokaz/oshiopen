class CreateOshiNames < ActiveRecord::Migration[7.1]
  def change
    create_table :oshi_names do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
