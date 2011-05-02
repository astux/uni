class CreateScholarities < ActiveRecord::Migration
  def self.up
    create_table :scholarities do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :scholarities
  end
end
