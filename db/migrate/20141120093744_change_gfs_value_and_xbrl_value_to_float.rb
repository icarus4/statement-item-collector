class ChangeGfsValueAndXbrlValueToFloat < ActiveRecord::Migration
  def change
    change_column :value_comparisons, :gfs_value, :float
    change_column :value_comparisons, :xbrl_value, :float
  end
end
