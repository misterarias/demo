BEGIN;

-- User login tables
DROP TABLE IF EXISTS client CASCADE;
CREATE TABLE client (
  id serial PRIMARY KEY,
  user_name varchar(50) NOT NULL,
  password varchar(60) NOT NULL,
  full_name varchar(100) NOT NULL,
  company_name VARCHAR(100) NOT NULL,
  account_expired boolean,
  account_locked boolean,
  password_expired boolean,
  enabled boolean
);

-- Client's apps define what data will be available for each client
DROP TABLE IF EXISTS client_app CASCADE;
CREATE TABLE client_app (
  id serial PRIMARY KEY,
  client_id integer REFERENCES client(id) ON DELETE CASCADE,
  app_token VARCHAR(100) NOT NULL,
  app_name VARCHAR(100) NOT NULL,
  UNIQUE(app_name,app_token)
);
CREATE INDEX client_app_app_token_index ON client_app(app_token);

DROP TABLE IF EXISTS role CASCADE;
CREATE TABLE role (
  id serial PRIMARY KEY,
  authority varchar(50) NOT NULL
);

-- A person is the abstraction of each of the device owners
DROP TABLE IF EXISTS person CASCADE;
CREATE TABLE person (
  id serial PRIMARY KEY,
  name  varchar(100),
  age varchar(100),
  gender varchar(100)
);

-- MxN relationship between a client and a role
DROP TABLE IF EXISTS client_roles;
CREATE TABLE client_roles(
  client_id integer NOT NULL REFERENCES client(id) ON DELETE CASCADE,
  role_id integer NOT NULL REFERENCES role(id) ON DELETE CASCADE,
  PRIMARY KEY (client_id, role_id)
);

-- A device belongs (should belong) to exactly one person, but its owner might be unknown...
-- A device's data always comes from one app
DROP TABLE IF EXISTS devices CASCADE;
CREATE TABLE devices (
  id serial PRIMARY KEY,
  client_app_id INTEGER NOT NULL REFERENCES client_app(id) ON DELETE CASCADE,
  person_id integer REFERENCES person(id) DEFAULT NULL,
  brand varchar(100),
  model varchar(100),
  original_device_id varchar(100)
);
CREATE INDEX devices_id_client_app_id_index ON devices(id, client_app_id);
CREATE INDEX devices_original_device_id_index ON devices(original_device_id);
CREATE INDEX devices_person_id_index ON devices(person_id) WHERE person_id is not null;

-- A given device can have many locations
DROP TABLE IF EXISTS locations;
CREATE TABLE locations(
  device_id serial NOT NULL REFERENCES devices(id),
  received  timestamp NOT NULL,
  latitude  double precision NOT NULL,
  longitude double precision NOT NULL,
  label varchar(100),
  timezone INTEGER DEFAULT 0,
  PRIMARY KEY(device_id, received)
);
CREATE INDEX locations_received_index ON locations(received);

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories(
  id  serial PRIMARY KEY,
  name varchar(100)
);

DROP TABLE IF EXISTS segments CASCADE;
CREATE TABLE segments(
  id  serial PRIMARY KEY,
  name varchar(100),
  segment_id integer REFERENCES segments(id) default NULL
);

DROP TABLE IF EXISTS apps CASCADE;
CREATE TABLE apps(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  package_name TEXT,
  UNIQUE(name, package_name)
);

-- Manage the MxN relation between devices and apps
DROP TABLE IF EXISTS installed_apps;
CREATE TABLE installed_apps(
  device_id serial NOT NULL REFERENCES devices(id),
  app_id serial NOT NULL REFERENCES apps(id),
  installed_on  timestamp default NOW(),
  last_seen_on  timestamp NOT NULL
);

-- Manage the MxN relation between segments and apps
DROP TABLE IF EXISTS app_segments;
CREATE TABLE app_segments(
  segment_id serial NOT NULL REFERENCES segments(id),
  app_id serial NOT NULL REFERENCES apps(id)
);

-- Manage the MxN relation between categories and apps
DROP TABLE IF EXISTS app_categories;
CREATE TABLE app_categories(
  category_id serial NOT NULL REFERENCES categories(id),
  app_id serial NOT NULL REFERENCES apps(id)
);

DROP TABLE IF EXISTS places cascade;
CREATE TABLE places(
  id serial PRIMARY KEY,
  place_id varchar(200) not null, -- Google Places Place ID
  name varchar(200) default '',
  administrative_area_level_1 varchar(100) default '',
  administrative_area_level_2 varchar(100) default '',
  administrative_area_level_3 varchar(100) default '',
  administrative_area_level_4 varchar(100) default '',
  sublocality_level_1 varchar(100) default '',
  sublocality_level_2 varchar(100) default '',
  route varchar(200) default '',
  country varchar(100) default '',
  locality varchar(200) default '',
  vicinity varchar(200) default '',
  postal_code varchar(100) default '',
  international_phone_number varchar(100) default '',
  latitude double precision not null,
  longitude double precision not null,
  rating float default -1,
  price_level float default -1
);
CREATE INDEX places_place_id_index ON places(place_id);

DROP TABLE IF EXISTS locations_cleaned cascade;
CREATE TABLE locations_cleaned(
  device_id serial NOT NULL REFERENCES devices(id),
  latitude double precision NOT NULL,
  longitude double precision NOT NULL,
  device_location_id integer,
  stay_time_h decimal NOT NULL,
  from_time timestamp NOT NULL,
  to_time timestamp NOT NULL,
  from_local_time timestamp NOT NULL,
  to_local_time timestamp NOT NULL,
  geom GEOGRAPHY NOT NULL, -- Fill With: ST_MakePoint(latitude, longitude)
  PRIMARY KEY(device_id, from_time)
);
CREATE INDEX locations_cleaned_device_index ON locations_cleaned(device_id);
CREATE INDEX locations_cleaned_dev_loc_index ON locations_cleaned(device_id, device_location_id);
CREATE INDEX locations_cleaned_geom_gist_index ON locations_cleaned using gist(geom);

DROP TABLE IF EXISTS device_locations cascade;
CREATE TABLE device_locations(
  device_id serial NOT NULL REFERENCES devices(id),
  device_location_id integer,
  tag varchar(100),
  place_id integer REFERENCES places(id),
  freq_workweek_h decimal NOT NULL DEFAULT 0,
  freq_weekend_h decimal NOT NULL DEFAULT 0,
  freq_workweek_n integer NOT NULL DEFAULT 0,
  freq_weekend_n integer NOT NULL DEFAULT 0,
  PRIMARY KEY(device_id, device_location_id)
);

DROP TABLE IF EXISTS place_types CASCADE;
CREATE TABLE place_types(
  id serial NOT NULL PRIMARY KEY,
  name varchar(100) NOT NULL
);

DROP TABLE IF EXISTS points_of_interest_types ;
CREATE TABLE points_of_interest_types (
  place_id serial REFERENCES places(id) ON DELETE CASCADE,
  type_id serial REFERENCES place_types(id) ON DELETE CASCADE,
  PRIMARY KEY (place_id, type_id)
);


-- Profiles' information, linked to a device
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
  device_id serial NOT NULL REFERENCES devices(id),
  user_name  varchar(50) not null,
  type  varchar(50) not null,
  installed_on  timestamp default NOW(),
  last_seen_on  timestamp NOT NULL,
  PRIMARY KEY (device_id, user_name, type)
);
CREATE INDEX profiles_type_index ON profiles(type);
-- If primary key search seems underperformant, try this:
--CREATE INDEX profiles_user_name_index ON profiles(user_name);

-- Will grow in the future
DROP TYPE IF EXISTS event_origin_t CASCADE;
CREATE TYPE event_origin_t as enum ('web', 'app');
DROP TYPE IF EXISTS event_type_t CASCADE;
CREATE TYPE event_type_t as enum ('locations', 'apps', 'webtrack', 'apptrack', 'indigitall');

DROP TABLE IF EXISTS device_event_info;
CREATE TABLE device_event_info (
  device_id serial NOT NULL REFERENCES devices(id),
  event_type  event_type_t default 'locations',
  event_origin event_origin_t default 'app',
  event_count integer default 1,
  last_seen_on timestamp default now(),
  PRIMARY KEY (device_id, event_type, event_origin)
);

DROP TABLE IF EXISTS client_segments;
CREATE TABLE client_segments(
  device_id serial NOT NULL REFERENCES devices(id),
  segment_id serial NOT NULL REFERENCES segments(id),
  degree FLOAT NOT NULL,
  PRIMARY KEY (device_id, segment_id)
);

-- To be deleted... temporary to simulate in-progress functionalities
DROP TABLE IF EXISTS device_properties_tmp;
CREATE TABLE device_properties_tmp (
  device_id integer,
  social_media_activity varchar(100),
  social_media_influence varchar(100),
  socio_economic_status varchar(100),
  -- moved to the 'person' entity -- age varchar(100),
  -- moved to the 'person' entity -- gender varchar(100),
  twitter_username varchar(100),
  PRIMARY KEY (device_id)
);

-- Represents a set of filters saved by an user
DROP TABLE IF EXISTS filter_sets CASCADE;
CREATE TABLE filter_sets (
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  date_created timestamp NOT NULL,
  last_updated timestamp NOT NULL,
  client_id integer REFERENCES client(id) NOT NULL,
  unique(client_id, name)
);

-- Representes a single filter operation that a filter set belongs
DROP TABLE IF EXISTS filters CASCADE;
CREATE TABLE filters (
  id serial PRIMARY KEY,
  field_name varchar(100) NOT NULL,
  operator varchar(10) NOT NULL,
  filter_set_id integer REFERENCES filter_sets(id) NOT NULL
);

-- Represents the value(s) of a filter
DROP TABLE IF EXISTS filter_values CASCADE;
CREATE TABLE filter_values (
  id serial PRIMARY KEY,
  type varchar(20) NOT NULL,
  position integer NOT NULL,
  value varchar(200) NOT NULL,
  filter_id integer REFERENCES filters(id) NOT NULL
);
COMMIT;

-- This table mostly holds information that links an external user with one of our device.
-- Each item must be unique, so we assume that two different partners can have same (client_id, device_id) items,
-- even if that is unlikely.
DROP TABLE IF EXISTS external_info CASCADE;
CREATE TABLE external_info (
  id serial PRIMARY KEY,
  client_id INTEGER NOT NULL REFERENCES client(id),
  device_id INTEGER NOT NULL REFERENCES devices(id),
  external_user_id TEXT NOT NULL,
  UNIQUE(device_id, client_id, external_user_id)
);

-- For each external_info, we can hold many data blobs, but timestamp cannot overlap
DROP TABLE IF EXISTS external_info_data CASCADE;
CREATE TABLE external_info_data (
  external_info_id INTEGER NOT NULL REFERENCES external_info(id),
  data_blob TEXT NOT NULL,
  timestamp timestamp not null,
  PRIMARY KEY(external_info_id, timestamp)
);

-- Each 'client' can have its list of places
DROP TABLE IF EXISTS client_places CASCADE;
CREATE TABLE client_places (
  place_id  INTEGER NOT NULL REFERENCES places(id),
  client_id INTEGER NOT NULL REFERENCES client(id),
  PRIMARY KEY(place_id, client_id)
);
