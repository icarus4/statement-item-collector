class AddFiscalPeriodEndDateToStatements < ActiveRecord::Migration
  def up
    add_column :statements, :end_date, :date
    change_column :statements, :quarter, :integer, null: true
  end

  def down
    remove_column :statements, :end_date
    change_column :statements, :quarter, :integer, null: false
  end
end
