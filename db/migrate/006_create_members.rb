class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.references :project,    :null => false
      t.references :user,       :null => false
      t.string :role,           :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
