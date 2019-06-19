-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE pkg_mgmt.cv_maint_freq(
	eml_maintenance_frequency character varying(50)
)

COPY pkg_mgmt.cv_maint_freq (eml_maintenance_frequency) FROM stdin;
annually
asNeeded
biannually
continually
daily
irregular
monthly
notPlanned
weekly
unknown
otherMaintenancePeriod
\.

ALTER TABLE lter_metabase."DataSet"
	ADD COLUMN "ShortName" character varying(200),
	ADD COLUMN "UpdateFrequency" character varying(50),
	ADD COLUMN "MaintenanceDescription" character varying(500);
	
alter table lter_metabase."DataSet"
	RENAME COLUMN "Accession" TO "Revision";
	
alter table lter_metabase."DataSet"
	ALTER COLUMN "Revision" TYPE int4 USING "Revision"::int4;
	
ALTER TABLE lter_metabase."DataSet"
	ADD CONSTRAINT "FK_DataSet_UpdateFrequency"
	FOREIGN KEY ("UpdateFrequency")
	REFERENCES pkg_mgmt.cv_maint_freq(eml_maintenance_frequency)
	ON UPDATE CASCADE;
	
COMMENT ON COLUMN lter_metabase."DataSet"."ShortName" IS 'Goes into /dataset/shortName.';
	
COMMENT ON COLUMN lter_metabase."DataSet"."UpdateFrequency" IS 'Use controlled vocabulary in pkg_mgmt.cv_maint_freq. goes into /dataset/maintenance/maintenanceUpdateFrequency. ';

COMMENT ON COLUMN lter_metabase."DataSet"."MaintenanceDescription" IS 'Freeform text meant to go into /dataset/maintenance/description/.';
	

CREATE TABLE pkg_mgmt.maintenance_changehistory(
	"DataSetID" integer NOT NULL,
	revision_number integer NOT NULL,
	revision_notes character varying(1024),
	change_scope character varying(50),
	change_date date NOT NULL,
	"NameID" character varying(20) NOT NULL
);

COMMENT ON COLUMN pkg_mgmt.maintenance_changehistory.change_scope IS 'Goes into/dataset/maintenance/changeHistory/changeScope/. E.g.: data, metadata, or data and metadata.';

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "FK_maintenance_changehistory_DataSetID"
	FOREIGN KEY ("DataSetID") 
	REFERENCES lter_metabase."DataSet"("DataSetID")
	ON UPDATE CASCADE;

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "FK_maintenance_changehistory_NameID" 
	FOREIGN KEY ("NameID") 
	REFERENCES lter_metabase."People"("NameID")
	ON UPDATE CASCADE;

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "PK_maintenance_changehistory"
	PRIMARY KEY ("DataSetID", revision_number);
	
-- alter dataset view

DROP VIEW mb2eml_r.vw_eml_dataset;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_dataset AS
	SELECT d."DataSetID" AS datasetid, 
	d."Revision" as revision_number,
	d."Title" AS title, 
	d."Abstract" AS abstract, 
	d."ShortName" AS shortname,
	d."UpdateFrequency" as update_frequency,
	d."MaintenanceDescription" as maintenance_desc 
	FROM lter_metabase."DataSet" d 
	ORDER BY d."DataSetID";

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_changehistory AS
	SELECT m."DataSetID" AS datasetid, 
		m.revision_number,  
		m.revision_notes,
		m.change_scope,
		m.change_date,
		(p."GivenName")::text AS givenname, 
		p."MiddleName" AS givenname2, 
		p."SurName" AS surname
	FROM (pkg_mgmt.maintenance_changehistory m 
		LEFT JOIN lter_metabase."People" p ON (((m."NameID")::text = (p."NameID")::text))) 
	ORDER BY m."DataSetID", m.revision_number;


ALTER TABLE pkg_mgmt.cv_maint_freq OWNER TO %db_owner%;

REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_maint_freq TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_maint_freq TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.cv_maint_freq TO %db_owner%;

ALTER TABLE pkg_mgmt.maintenance_changehistory OWNER TO %db_owner%;

REVOKE ALL ON TABLE pkg_mgmt.maintenance_changehistory FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.maintenance_changehistory FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.maintenance_changehistory TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.maintenance_changehistory TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.maintenance_changehistory TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_changehistory OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_changehistory FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_changehistory FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_changehistory TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_changehistory TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_changehistory TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_dataset OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_dataset TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_dataset TO %db_owner%;