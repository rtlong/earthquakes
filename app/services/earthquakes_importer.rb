class EarthquakesImporter

  # @param [USGSService]
  def initialize(service)
    @service = service
  end

  # For each earthquake received from the service, check for an existing Earthquake record with the same `source` and `eqid`. If found, will either update that record (if the new version is greater than the existing record) or skip it; if not found, will create a new record.
  # @todo consider batching the queries to make this more efficient
  def import_all
    @service.each do |e|
      Earthquake.where(source: e[:source], eqid: e[:eqid]).first_or_initialize.tap do |earthquake|
        next unless earthquake.version < e[:version]
        earthquake.update_attributes(e)
      end
    end
  end

end
