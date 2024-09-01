class CreateOshiDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :oshi_details do |t|
      t.text :reason_for_favorite
      t.text :trigger_for_favorite
      t.text :activity_history
      t.references :profile, null: false, foreign_key: true
      t.references :oshi_name, null: false, foreign_key: true

      t.timestamps
    end
  end
end
