class CreateParserStats < ActiveRecord::Migration
  def change
    create_table :parser_stats do |t|
      t.belongs_to :statement
      t.integer :gfs_value_count
      t.integer :xbrl_value_count
      t.integer :value_match_count
      t.float :xbrl_value_discovered_ratio
      t.float :accuracy_ratio

      t.index :statement_id
      t.index :gfs_value_count
      t.index :xbrl_value_count
      t.index :value_match_count
      t.index :xbrl_value_discovered_ratio
      t.index :accuracy_ratio

      t.timestamps
    end
  end
end
