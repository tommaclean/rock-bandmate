class ChangeStudentAttrsFmNameToId < ActiveRecord::Migration[4.2]
  def change
    rename_column :students, :instrument_name, :instrument_id
    change_column :students, :instrument_id, :integer
    rename_column :students, :band_name, :band_id
    change_column :students, :band_id, :integer
  end
end
