class AddValueUnmatchedCountToCoverageStats < ActiveRecord::Migration
  def change
    add_column :coverage_stats, :value_unmatch_count, :integer
    add_index :coverage_stats, :value_unmatch_count
  end
end
