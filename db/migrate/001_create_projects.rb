class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.primary_key('id')
      t.string 'name'
      t.string 'users'
      t.string 'stakeholders'
      t.string 'managers'
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
