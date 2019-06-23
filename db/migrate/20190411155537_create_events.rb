class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user
      t.string :title
      t.boolean :disp_flg
      t.datetime :start#, unique = true
      t.datetime :end#, unique = true
      t.string :allDay
      t.references :categoris
      t.boolean :useless_flag

      t.timestamps
    end
      #add_foreign_key :events, :category
      #add_foreign_key :events, :user
      #add_index :events, [:time_from, :time_to], unique: true
      add_index :events, :start, unique: true
      add_index :events, :end, unique: true
  end
end
