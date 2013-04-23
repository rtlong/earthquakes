=begin
CREATE TABLE earthquakes (
    id integer NOT NULL,
    source character varying(2) NOT NULL,
    eqid character varying(30) NOT NULL,
    version integer DEFAULT 0,
    date_time timestamp without time zone,
    latitude double precision,
    longitude double precision,
    magnitude real,
    depth real,
    nst integer,
    region character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
CREATE UNIQUE INDEX index_earthquakes_on_source_and_eqid ON earthquakes USING btree (source, eqid);
=end

class Earthquake < ActiveRecord::Base
  validates :source, presence: true, length: { in: 1..2 }
  validates :eqid, presence: true, uniqueness: { scope: :source }, length: { in: 1..30 }
  validates :longitude, numericality: true
  validates :latitude, numericality: true
  validates :version, numericality: true
  validates :magnitude, numericality: true
  validates :nst, numericality: true
  validates :depth, numericality: true

  #scope :lt_version, proc{|version| where(arel_table[:version].lt(version)) }

  scope :for_serialization, proc { select([:source, :eqid, :version, :date_time, :latitude, :longitude, :magnitude, :depth, :nst, :region]) }

  # This works like pluck (in fact the code was taken from .pluck), to return a collection Hash without instantiating AR objects, for speed
  def self.as_hashes
    result = connection.select_all(self.all.arel)
    types = result.column_types.merge self.column_types

    result.map do |attributes|
      initialize_attributes(attributes).tap do |hash|
        hash.each do |key, value|
          if column = types[key]
            hash[key] = column.type_cast(value)
          end
        end
      end
    end

  end
end
