class CreateEarthquakes < ActiveRecord::Migration
  def change
    create_table :earthquakes do |t|
      t.string :source, null: false, limit: 2
      t.string :eqid, null: false, limit: 30
      t.integer :version, default: 0
      t.datetime :date_time
      t.float :latitude
      t.float :longitude
      t.column :magnitude, :real
      t.column :depth, :real
      t.integer :nst
      t.string :region
      t.timestamps
    end
    add_index :earthquakes, [:source, :eqid], unique: true
  end
end
