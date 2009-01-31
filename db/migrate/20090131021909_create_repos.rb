class CreateRepos < ActiveRecord::Migration
  def self.up
    create_table :repos do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :repos
  end
end
