class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.references :category, foreign_key: true

      t.timestamps
    end
    #add_foreign_key :tests,:categories
  end
end
