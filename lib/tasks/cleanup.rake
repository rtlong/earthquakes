namespace :cleanup do
  task :earthquakes => :environment do
    count = Earthquake.stale.delete_all
    puts "Cleared out #{count} old records"
  end
end
