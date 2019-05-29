class FixInstrumentColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :students, :instrument, :instrument_name
  end
end
