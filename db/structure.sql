--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: earthquakes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE earthquakes (
    id integer NOT NULL,
    source character varying(2) NOT NULL,
    eqid character varying(30) NOT NULL,
    version integer DEFAULT 0,
    date_time timestamp without time zone,
    latitude numeric(7,4),
    longitude numeric(7,4),
    magnitude numeric(3,1),
    depth numeric(6,1),
    nst integer,
    region character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: earthquakes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE earthquakes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: earthquakes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE earthquakes_id_seq OWNED BY earthquakes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY earthquakes ALTER COLUMN id SET DEFAULT nextval('earthquakes_id_seq'::regclass);


--
-- Name: earthquakes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY earthquakes
    ADD CONSTRAINT earthquakes_pkey PRIMARY KEY (id);


--
-- Name: index_earthquakes_on_source_and_eqid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_earthquakes_on_source_and_eqid ON earthquakes USING btree (source, eqid);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130418062356');

INSERT INTO schema_migrations (version) VALUES ('20130418064812');

INSERT INTO schema_migrations (version) VALUES ('20130423074321');
