class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references    :story
      t.references    :comment
      t.string      'user_name',      :null => false
      t.timestamp   'creation_date',  :null => false
      t.string      'title',          :null => false
      t.text        'text',           :null => false

      t.timestamps
    end

    add_index :comments, 'story_id'
    add_index :comments, 'id'
  end

  def self.down
    drop_table :comments
  end
end
