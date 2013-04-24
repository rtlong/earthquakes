class EarthquakesImporter

  # @param [USGSService]
  def initialize(service)
    @service = service
  end

  # @attr [#call] will be sent :call to indicate progress
  attr_accessor :reporter

  # For each earthquake received from the service, check for an existing Earthquake record with the same `source` and `eqid`. If found, will either update that record (if the new version is greater than the existing record) or skip it; if not found, will create a new record.
  # @todo consider batching the queries to make this more efficient
  def import_all
    @service.each do |e|
      Earthquake.where(source: e[:source], eqid: e[:eqid]).first_or_initialize.tap do |earthquake|
        break unless earthquake.new_record? || earthquake.version < e[:version]
        earthquake.update_attributes!(e)
      end
      report_progress
    end
  end

  def report_progress
    reporter.try(:call)
  end

end
