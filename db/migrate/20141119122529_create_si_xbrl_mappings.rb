class CreateSiXbrlMappings < ActiveRecord::Migration
  def change
    create_table :si_xbrl_mappings do |t|
      t.belongs_to :standard_item
      t.string :xbrl_name

      t.timestamps
    end
  end
end
