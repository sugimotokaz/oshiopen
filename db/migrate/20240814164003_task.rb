class Task < ActiveRecord::Migration[7.1]
  def change
    drop_table :tasks
  end
end
