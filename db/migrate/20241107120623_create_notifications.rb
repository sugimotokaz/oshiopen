class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :visited, null: false, foreign_key: { to_table: :users }
      t.references :article, null: true, foreign_key: true
      t.references :comment, null: true, foreign_key: true
      t.string :action, null: false, default: ''
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
    add_index :notifications, [:visitor_id, :visited_id]
  end
end
