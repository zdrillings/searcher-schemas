-- direction: up
-- ref: 149148892140

\c searcher;

BEGIN;

	CREATE SCHEMA IF NOT EXISTS job_configuration;
	SET search_path TO job_configuration;

	CREATE OR REPLACE FUNCTION update_last_modified() RETURNS TRIGGER
	  LANGUAGE plpgsql
	  AS  
	  $$  
	    BEGIN
		      NEW.last_modified = CURRENT_TIMESTAMP;
		      RETURN NEW;
		    END;
		  $$; 


	CREATE TABLE users (
		id                    BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_modified         TIMESTAMPTZ NOT NULL DEFAULT now(),
		email                 VARCHAR(255) NOT NULL UNIQUE
	);

	CREATE INDEX ON users (created_on);
	CREATE INDEX ON users (last_modified);

	CREATE TRIGGER users_last_modified
	BEFORE UPDATE
	ON users
	FOR EACH ROW 
		EXECUTE PROCEDURE update_last_modified();

	CREATE TABLE search_type (
		id BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_modified         TIMESTAMPTZ NOT NULL DEFAULT now(),
		name VARCHAR(255) NOT NULL UNIQUE
	);

	CREATE INDEX ON search_type (created_on);
	CREATE INDEX ON search_type (last_modified);

	CREATE TRIGGER search_type_last_modified
	BEFORE UPDATE
	ON search_type
	FOR EACH ROW 
		EXECUTE PROCEDURE update_last_modified();


	CREATE TABLE search_cadence (
		id BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_modified         TIMESTAMPTZ NOT NULL DEFAULT now(),
		name VARCHAR(255) NOT NULL UNIQUE
	);

	CREATE INDEX ON search_cadence (created_on);
	CREATE INDEX ON search_cadence (last_modified);

	CREATE TRIGGER search_cadence_last_modified
	BEFORE UPDATE
	ON search_cadence
	FOR EACH ROW 
		EXECUTE PROCEDURE update_last_modified();


	CREATE TABLE job (
		id BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_modified         TIMESTAMPTZ NOT NULL DEFAULT now(),
		user_id		      BIGINT REFERENCES users (id) ON DELETE CASCADE,	
		search_type_id	      BIGINT REFERENCES search_type (id),
		report_cadence_id     BIGINT REFERENCES search_cadence (id),
		search_string         VARCHAR(255) NOT NULL
	);

	CREATE INDEX ON job (created_on);
	CREATE INDEX ON job (last_modified);

	CREATE TRIGGER job_last_modified
	BEFORE UPDATE
	ON job
	FOR EACH ROW 
		EXECUTE PROCEDURE update_last_modified();

	CREATE TABLE job_status (
		id BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_modified         TIMESTAMPTZ NOT NULL DEFAULT now(),
		name VARCHAR(255) NOT NULL UNIQUE
	);

	CREATE INDEX ON job_status (created_on);
	CREATE INDEX ON job_status (last_modified);

	CREATE TRIGGER job_status_last_modified
	BEFORE UPDATE
	ON job_status
	FOR EACH ROW 
		EXECUTE PROCEDURE update_last_modified();


	CREATE TABLE job_history (
		id BIGSERIAL PRIMARY KEY,
		created_on            TIMESTAMPTZ NOT NULL DEFAULT now(),
		job_id			BIGINT REFERENCES job (id),
		job_status_id		BIGINT REFERENCES job_status (id),
		report_location		 VARCHAR(255) NOT NULL
	);

	CREATE INDEX ON job_history (created_on);


COMMIT;



-- start rev query
INSERT INTO "common"."schema_history" (alter_hash, ran_on) VALUES ('149148892140', NOW());
-- end rev query
