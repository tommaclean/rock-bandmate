class AddBandNameAndInstrumentToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :band_name, :string
    add_column :students, :instrument, :string
  end
end
