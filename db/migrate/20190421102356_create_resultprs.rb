class CreateResultprs < ActiveRecord::Migration[5.2]
  def change
    create_table :resultprs do |t|
      t.date :date_span_from
      t.date :date_span_to
      t.boolean :empty_flg

      t.timestamps
    end
  end
end
