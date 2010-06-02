class CreateBacklog < ActiveRecord::Migration
  def self.up
    create_table :backlog do |t|
      t.references :sprint
      t.references :project,        :null => false
      t.references :user
      t.string :name
      t.integer :importance
      t.integer :initial_estimate
      t.string :how_to_demo
      t.text :notes
      t.date :start_date
      t.date :end_date
      t.boolean :finished, :default=>false

      t.timestamps
    end

    add_index :backlog, 'sprint_id', :name => 'fk_backlog_project'
    add_index :backlog, 'project_id', :name => 'fk_backlog_sprint'
  end

  def self.down
    drop_table :backlog
  end
end
