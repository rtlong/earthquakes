class ChangeNumericColumnTypes < ActiveRecord::Migration
  def change
    change_table :earthquakes do |t|
      t.change :latitude, :decimal, precision: 7, scale: 4
      t.change :longitude, :decimal, precision: 7, scale: 4
      t.change :magnitude, :decimal, precision: 3, scale: 1
      t.change :depth, :decimal, precision: 6, scale: 1
    end
  end
end
