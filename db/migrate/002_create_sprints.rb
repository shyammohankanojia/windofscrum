class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      t.primary_key('id')
      t.references  :project,       :null => false
      t.string      :name
      t.date        :start_date
      t.date        :release_date
      t.integer     'available_man_days'
      t.decimal      'estimated_focus_factor', {:precision => 2, :scale => 2}
      t.boolean     'finished',     :default => false
    end
    add_index :sprints, 'project_id', :name => 'idx_sprints_project_id'
  end

  def self.down
    drop_table :sprints
  end
end
