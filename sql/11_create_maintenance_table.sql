-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE pkg_mgmt.cv_maint_freq(
	eml_maint_freq character varying(50)
)

COPY pkg_mgmt.cv_maint_freq (eml_maint_freq) FROM stdin;
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
	ADD COLUMN "ShortName" character varying(50),
	ADD COLUMN "PackageNumber" integer,
	ADD COLUMN "UpdateFrequency" character varying(50),
	ADD COLUMN "MaintenanceDescription" character varying(1024);
	
ALTER TABLE lter_metabase."DataSet"
	ADD CONSTRAINT "FK_DataSet_UpdateFrequency"
	FOREIGN KEY ("UpdateFrequency")
	REFERENCES pkg_mgmt.cv_maint_freq(eml_maint_freq)
	ON UPDATE CASCADE;
	
ALTER TABLE lter_metabase."PackageNumber"
	ADD CONSTRAINT "UQ_DataSet_PackageNumber"
	UNIQUE ("PackageNumber");
	
COMMENT ON COLUMN lter_metabase."DataSet"."ShortName" IS 'Goes into /dataset/shortName.';
	
COMMENT ON COLUMN lter_metabase."DataSet"."PackageNumber" IS 'Goes into /eml/packageID.';
	
COMMENT ON COLUMN lter_metabase."DataSet"."UpdateFrequency" IS 'Use controlled vocabulary in pkg_mgmt.cv_maint_freq. goes into /dataset/maintenance/maintenanceUpdateFrequency. ';

COMMENT ON COLUMN lter_metabase."DataSet"."MaintenanceDescription" IS 'Freeform text meant to go into /dataset/maintenance/description/.';
	

CREATE TABLE lter_metabase."DataSetMaintenance"(
	"DataSetID" integer NOT NULL,
	"RevisionNumber" integer NOT NULL,
	"RevisionNotes" character varying(1024),
	"ChangeScope" character varying(50),
	"ChangeDate" date NOT NULL,
	"NameID" character varying(20) NOT NULL
);

COMMENT ON COLUMN lter_metabase."DataSetMaintenance"."ChangeScope" IS 'Goes into/dataset/maintenance/changeHistory/changeScope/. E.g.: data, metadata, or data and metadata.';

ALTER TABLE lter_metabase."DataSetMaintenance"
	ADD CONSTRAINT "FK_DataSetMaintenance_DataSetID"
	FOREIGN KEY ("DataSetID") 
	REFERENCES lter_metabase."DataSet"("DataSetID")
	ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetMaintenance" 
	ADD CONSTRAINT "FK_DataSetMaintenance_NameID" 
	FOREIGN KEY ("NameID") 
	REFERENCES lter_metabase."People"("NameID")
	ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetMaintenance"
	ADD CONSTRAINT "PK_DataSetMaintenance"
	PRIMARY KEY ("DataSetID", "RevisionNumber");


-- add foreign key to pkg_mgmt.pkg_state
ALTER TABLE pkg_mgmt.pkg_state
	ADD CONSTRAINT "FK_pkg_state_RevisionNumber"
	FOREIGN KEY ("DataSetID", rev)
	REFERENCES lter_metabase."DataSetMaintenance"("DataSetID", "RevisionNumber")
	ON UPDATE CASCADE;
	
-- alter dataset view to (1) drop revision number since that information is exposed via vw_eml_maintenance, (2) get ShortName and packageNumber from DataSet, and (3) drop pubdate since that is exposed via vw_eml_maintenance 
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_dataset AS
	SELECT d."DataSetID" AS datasetid, 
	d."PackageNumber" AS alternatedid, 
	d."PackageNumber" AS edinum, 
	d."Title" AS title, 
	d."Abstract" AS abstract, 
	-- k.data_receipt_date AS projdate, 
	-- k.update_date_catalog AS pubdate, 
	d."ShortName" AS shortname 
	FROM lter_metabase."DataSet" d 
	ORDER BY d."DataSetID";



CREATE OR REPLACE VIEW mb2eml_r.vw_eml_maintenance AS
	SELECT d."DataSetID" AS datasetid, 
		d."RevisionNumber" AS revision_number,  
		d."RevisionNotes" as revision_notes,
		d."ChangeScope" as change_scope,
		d."ChangeDate" as revision_date,
		(p."GivenName")::text AS givenname, 
		p."MiddleName" AS givenname2, 
		p."SurName" AS surname,
FROM (lter_metabase."DataSetMaintenance" d 
LEFT JOIN lter_metabase."People" p 
ON (((d."NameID")::text = (p."NameID")::text))) 
ORDER BY d."DataSetID", d."RevisionNumber";


ALTER TABLE pkg_mgmt.cv_maint_freq OWNER TO %db_owner%;

REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_maint_freq TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_maint_freq TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.cv_maint_freq TO %db_owner%;

ALTER TABLE lter_metabase."DataSetMaintenance" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."DataSetMaintenance" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetMaintenance" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMaintenance" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMaintenance" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."DataSetMaintenance" TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_maintenance OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_maintenance FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_maintenance FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_maintenance TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_maintenance TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_maintenance TO %db_owner%;