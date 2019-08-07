CREATE TABLE mb2eml_r.boilerplate (
	bp_setting character varying(20) NOT NULL,
	scope character varying(20) NOT NULL,
	system character varying(20) NOT NULL,
	access xml,
	distribution xml,
	publisher_nameid character varying(20),
	contact_nameid character varying(20),
	metadata_provider_nameid character varying(20),
	project xml,
	CONSTRAINT "pk_boilerplate" PRIMARY KEY(bp_setting),
	CONSTRAINT "fk_boilerplate_publisher_nameid" FOREIGN KEY (publisher_nameid)
      REFERENCES lter_metabase."ListPeople" ("NameID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT "fk_boilerplate_contact_nameid" FOREIGN KEY (contact_nameid)
      REFERENCES lter_metabase."ListPeople" ("NameID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT "fk_boilerplate_metadata_provider_nameid" FOREIGN KEY (metadata_provider_nameid)
      REFERENCES lter_metabase."ListPeople" ("NameID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);


ALTER TABLE mb2eml_r.boilerplate OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.boilerplate FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.boilerplate FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.boilerplate TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.boilerplate TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.boilerplate TO %db_owner%;


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_boilerplate AS 
	SELECT bp_setting as bp_setting,
	scope as scope,
	system as system,
	access as access,
	distribution as distribution,
	project as project
	FROM mb2eml_r.boilerplate;

ALTER TABLE mb2eml_r.vw_eml_boilerplate OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_boilerplate FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_boilerplate FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_boilerplate TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_boilerplate TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_boilerplate TO %db_owner%;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_bp_people AS 
	SELECT bp_setting as bp_setting,
    'publisher' as bp_role,
	p."GivenName" as givenname,
	p."MiddleName" as givenname2,
	p."SurName" as surname,
	p."Organization" as organization,
	p."Address1" as address1,
	p."Address2" as address2,
	p."Address3" as address3,
	p."City" as city,
	p."State" as state, 
	p."Country" as country,
	p."ZipCode" as zipcode,
	p."Phone" as phone1,
	i."IdentificationSystem" as userid_type,
	i."IdentificationURL" as userid 
	FROM lter_metabase."ListPeople" p
		INNER JOIN mb2eml_r.boilerplate b ON b."publisher_nameid" = p."NameID"
		LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID" = p."NameID"

	UNION 

	SELECT bp_setting as bp_setting,
	'metadata_provider' as bp_role,
	p."GivenName" as givenname,
	p."MiddleName" as givenname2,
	p."SurName" as surname,
	p."Organization" as organization,
	p."Address1" as address1,
	p."Address2" as address2,
	p."Address3" as address3,
	p."City" as city,
	p."State" as state, 
	p."Country" as country,
	p."ZipCode" as zipcode,
	p."Phone" as phone1,
	i."IdentificationSystem" as userid_type,
	i."IdentificationURL" as userid 
	FROM lter_metabase."ListPeople" p
		INNER JOIN mb2eml_r.boilerplate b ON b."metadata_provider_nameid" = p."NameID"
		LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID" = p."NameID"

	UNION

	SELECT bp_setting as bp_setting,
	'contact' as bp_role,
	p."GivenName" as givenname,
	p."MiddleName" as givenname2,
	p."SurName" as surname,
	p."Organization" as organization,
	p."Address1" as address1,
	p."Address2" as address2,
	p."Address3" as address3,
	p."City" as city,
	p."State" as state, 
	p."Country" as country,
	p."ZipCode" as zipcode,
	p."Phone" as phone1,
	i."IdentificationSystem" as userid_type,
	i."IdentificationURL" as userid 
	FROM lter_metabase."ListPeople" p
		INNER JOIN mb2eml_r.boilerplate b ON b."contact_nameid" = p."NameID"
		LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID" = p."NameID"
	;

ALTER TABLE mb2eml_r.vw_eml_bp_people OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_bp_people FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_bp_people FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_bp_people TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_bp_people TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_bp_people TO %db_owner%;


-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,29,now(),'apply 29_create_boilerplate.sql');
