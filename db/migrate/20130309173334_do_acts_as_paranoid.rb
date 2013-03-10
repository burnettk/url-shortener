class DoActsAsParanoid < ActiveRecord::Migration
  def up
    rename_column :shortcuts, :active, :deleted_at
    change_column :shortcuts, :deleted_at, :datetime, :null => true, :default => nil
    update 'update shortcuts set deleted_at = null'
    execute(%Q[ALTER TABLE shortcuts DROP FOREIGN KEY shortcuts_ibfk_user_id])
    execute(%Q[ALTER TABLE shortcuts DROP KEY shortcuts_ibfk_user_id])
    rename_column :shortcuts, :user_id, :created_by_user_id
    execute(%Q[ALTER TABLE shortcuts ADD CONSTRAINT shortcuts_ibfk_created_by_user_id FOREIGN KEY (created_by_user_id) REFERENCES users (id)])
    add_column :shortcuts, :updated_by_user_id, :integer, :after => 'created_by_user_id'
    execute(%Q[ALTER TABLE shortcuts ADD CONSTRAINT shortcuts_ibfk_updated_by_user_id FOREIGN KEY (updated_by_user_id) REFERENCES users (id)])
  end

  def down
    execute(%Q[ALTER TABLE shortcuts DROP FOREIGN KEY shortcuts_ibfk_updated_by_user_id])
    execute(%Q[ALTER TABLE shortcuts DROP KEY shortcuts_ibfk_updated_by_user_id])
    remove_column :shortcuts, :updated_by_user_id
    execute(%Q[ALTER TABLE shortcuts DROP FOREIGN KEY shortcuts_ibfk_created_by_user_id])
    execute(%Q[ALTER TABLE shortcuts DROP KEY shortcuts_ibfk_created_by_user_id])
    rename_column :shortcuts, :created_by_user_id, :user_id
    execute(%Q[ALTER TABLE shortcuts ADD CONSTRAINT shortcuts_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
    change_column :shortcuts, :deleted_at, :boolean, :default => true, :null => false
    rename_column :shortcuts, :deleted_at, :active
    update 'update shortcuts set active = 1'
  end
end
