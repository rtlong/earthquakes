namespace :imports do
  namespace :earthquakes do
    task :latest => :environment do
      service = USGSService.latest
      importer = EarthquakesImporter.new(service)

      if defined?(ProgressBar)
        progress_bar = ProgressBar.new(service.count)
        importer.reporter = -> { progress_bar.increment! }
      else
        importer.reporter = -> { print ?. }
      end

      importer.import_all
      puts service.count
    end
  end
end
