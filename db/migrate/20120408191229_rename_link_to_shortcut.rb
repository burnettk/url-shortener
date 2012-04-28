# changing the following tables: links, link_visits
class RenameLinkToShortcut < ActiveRecord::Migration
  def up
    # kill links keys
    execute %Q[ALTER TABLE links DROP INDEX index_links_on_shortcut]
    execute %Q[ALTER TABLE links DROP INDEX index_links_on_created_at]
    execute %Q[ALTER TABLE links DROP FOREIGN KEY links_ibfk_user_id]
    execute %Q[ALTER TABLE links DROP INDEX links_ibfk_user_id]

    # kill link_visits keys
    execute %Q[ALTER TABLE link_visits DROP FOREIGN KEY link_visits_ibfk_user_id] 
    execute %Q[ALTER TABLE link_visits DROP FOREIGN KEY link_visits_ibfk_link_id]
    execute %Q[ALTER TABLE link_visits DROP INDEX link_visits_ibfk_user_id]
    execute %Q[ALTER TABLE link_visits DROP INDEX link_visits_ibfk_link_id]

    execute %Q[ALTER TABLE link_visits DROP INDEX index_link_visits_on_path]
    execute %Q[ALTER TABLE link_visits DROP INDEX index_link_visits_on_created_at]

    rename_table :links, :shortcuts
    rename_table :link_visits, :shortcut_visits

    rename_column :shortcut_visits, :link_id, :shortcut_id

    # re-add keys to shortcut_visits
    add_index :shortcut_visits, :path
    add_index :shortcut_visits, :created_at
    execute(%Q[ALTER TABLE shortcut_visits ADD CONSTRAINT shortcut_visits_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
    execute(%Q[ALTER TABLE shortcut_visits ADD CONSTRAINT shortcut_visits_ibfk_shortcut_id FOREIGN KEY (shortcut_id) REFERENCES shortcuts (id)])

    # re-add keys to shortcuts
    add_index :shortcuts, :shortcut, :unique => true
    add_index :shortcuts, :created_at
    execute(%Q[ALTER TABLE shortcuts ADD CONSTRAINT shortcuts_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
  end

  def down
    # kill links keys
    execute %Q[ALTER TABLE shortcuts DROP INDEX index_shortcuts_on_shortcut]
    execute %Q[ALTER TABLE shortcuts DROP INDEX index_shortcuts_on_created_at]
    execute %Q[ALTER TABLE shortcuts DROP FOREIGN KEY shortcuts_ibfk_user_id]
    execute %Q[ALTER TABLE shortcuts DROP INDEX shortcuts_ibfk_user_id]

    # kill link_visits keys
    execute %Q[ALTER TABLE shortcut_visits DROP FOREIGN KEY shortcut_visits_ibfk_user_id] 
    execute %Q[ALTER TABLE shortcut_visits DROP FOREIGN KEY shortcut_visits_ibfk_shortcut_id]
    execute %Q[ALTER TABLE shortcut_visits DROP INDEX shortcut_visits_ibfk_user_id]
    execute %Q[ALTER TABLE shortcut_visits DROP INDEX shortcut_visits_ibfk_shortcut_id]
    execute %Q[ALTER TABLE shortcut_visits DROP INDEX index_shortcut_visits_on_path]
    execute %Q[ALTER TABLE shortcut_visits DROP INDEX index_shortcut_visits_on_created_at]

    rename_table :shortcuts, :links
    rename_table :shortcut_visits, :link_visits

    rename_column :link_visits, :shortcut_id, :link_id

    # re-add keys to link_visits
    add_index :link_visits, :path
    add_index :link_visits, :created_at
    execute(%Q[ALTER TABLE link_visits ADD CONSTRAINT link_visits_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
    execute(%Q[ALTER TABLE link_visits ADD CONSTRAINT link_visits_ibfk_link_id FOREIGN KEY (link_id) REFERENCES links (id)])

    # re-add keys to links
    add_index :links, :shortcut, :unique => true
    add_index :links, :created_at
    execute(%Q[ALTER TABLE links ADD CONSTRAINT links_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
  end
end
