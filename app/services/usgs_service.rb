require 'open-uri'
require 'csv'


# This class is responsible for retrieving the raw earthquakes data from USGS via CSV.
class USGSService
  # The 7-day recent earthquakes resource
  EQS7DAY = 'http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt'

  include Enumerable

  # Instantiate with the 7-day resource URL
  def self.latest
    new(EQS7DAY)
  end

  # @param [#to_s] - valid URI to the USGS CSV resource to use for this retrieval
  def initialize(data_url)
    @data_url = URI.parse(data_url)
  end

  attr_reader :data_url

  def to_a
    rewind
    super
  end

  alias :all :to_a

  # triggers fetch, and parses each row; skips rows with errors
  def each
    rewind
    return self.enum_for(:each) unless block_given?
    csv.each do |row|
      next unless out = convert_row(row)
      yield(out)
    end
  end

  # @param [CSV::Row, Hash] a row from the #csv method
  def convert_row(row)
    {
        source: row[:src],
        eqid: row[:eqid],
        version: row[:version].to_i,
        date_time: row[:datetime].to_datetime,
        magnitude: row[:magnitude].to_f,
        latitude: row[:lat].to_f,
        longitude: row[:lon].to_f,
        depth: row[:depth].to_f,
        nst: row[:nst].to_i,
        region: row[:region]
    }
  rescue => ex
    log :error, "%s - %s (%s) - %s" % [ex.class, ex.message, row.inspect, ex.backtrace.join(?|)]
    return nil
  end

  def rewind
    csv.rewind
  end

  def csv
    @csv ||= CSV.new(data, headers: true, header_converters: [:downcase, :symbol])
  end

  def data
    return @data if defined?(@data)
    retries = 3
    begin
      Timeout.timeout(5.seconds) do
        @data = open(data_url.to_s).read
      end
      return @data
    rescue
      if retries > 0
        retries -= 1
        retry
      else
        raise
      end
    end
  end

  private

  def log(level, message)
    Rails.logger.send level, "[USGS Import] #{message}"
  end
end
