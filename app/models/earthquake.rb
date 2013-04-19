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
  validates :source, presence: true, length: {in: 1..2}
  validates :eqid, presence: true, uniqueness: { scope: :source }
  validates :longitude, numericality: true
  validates :latitude, numericality: true
  validates :version, numericality: true
  validates :magnitude, numericality: true
  validates :nst, numericality: true
  validates :depth, numericality: true
end
