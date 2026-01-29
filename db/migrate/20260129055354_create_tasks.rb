class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, foreign_key:true
      t.string :title, null:false
      t.string :descryption
      t.integer :status, default:0

      t.timestamps
    end
  end
end
