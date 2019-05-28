class CreateBands < ActiveRecord::Migration[4.2]
  def change
    create_table :instruments do |t|
      t.string :name
    end
  end
end
