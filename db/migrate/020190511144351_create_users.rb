class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :user_name
      t.string :password_digest
      t.string :image_url
    
      t.timestamps
      
    end
    add_index :users, :user_name, :unique => true
    
  end
end
