require 'open-uri'
require 'csv'

class USGSService
  EQS7DAY='http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt'

  def self.latest
    new(EQS7DAY)
  end

  def initialize(data_url)
    @data_url = URI.parse(data_url)
  end
  attr_reader :data_url

  def parse
    csv.map { |row| convert_row(row) }
  end

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
  end

  def csv
    CSV.new data, headers: true, header_converters: [:downcase, :symbol]
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
end
