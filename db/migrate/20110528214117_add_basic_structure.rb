class AddBasicStructure < ActiveRecord::Migration
  def self.up
    create_table :users, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :identifier, :null => false
      t.string :active_directory_objectguid
      t.timestamps
    end
    add_index :users, :identifier, :unique => true
    add_index :users, :active_directory_objectguid, :unique => true


    create_table :links, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :shortcut, :null => false
      t.string :url, :null => false
      t.boolean :active, :null => false, :default => true
      t.belongs_to :user, :null => false
      t.timestamps
    end
    add_index :links, :shortcut, :unique => true
    add_index :links, :created_at
    execute(%Q[ALTER TABLE links ADD CONSTRAINT links_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])


    create_table :link_visits, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.belongs_to :link, :null => false
      t.belongs_to :user, :null => false
      t.string :path, :null => false
      t.datetime :created_at
    end
    add_index :link_visits, :path
    add_index :link_visits, :created_at
    execute(%Q[ALTER TABLE link_visits ADD CONSTRAINT link_visits_ibfk_user_id FOREIGN KEY (user_id) REFERENCES users (id)])
    execute(%Q[ALTER TABLE link_visits ADD CONSTRAINT link_visits_ibfk_link_id FOREIGN KEY (link_id) REFERENCES links (id)])
  end

  def self.down
    drop_table :link_visits
    drop_table :links
    drop_table :users
  end
end
