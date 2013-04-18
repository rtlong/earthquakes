class SetUpEarthdistance < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS cube'
    execute 'CREATE EXTENSION IF NOT EXISTS earthdistance'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS earthdistance'
    execute 'DROP EXTENSION IF EXISTS cube'
  end
end
