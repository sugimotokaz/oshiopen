class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :notice
      t.integer :category, null: false, default: 0
      t.integer :visible_gender, null: false, default: 0
      t.boolean :visible_oshi, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.references :oshi_name, null: false, foreign_key: true

      t.timestamps
    end
  end
end
