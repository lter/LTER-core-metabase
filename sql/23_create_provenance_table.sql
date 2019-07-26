ALTER TABLE lter_metabase."MethodInstruments" RENAME TO "DataSetMethodInstruments";

ALTER TABLE lter_metabase."MethodProtocols" RENAME TO "DataSetMethodProtocols";

ALTER TABLE lter_metabase."MethodSoftware" RENAME TO "DataSetMethodSoftware";

ALTER TABLE lter_metabase."DataSetMethodSteps" RENAME COLUMN "MethodStepSet" TO "MethodStepID";

CREATE TABLE lter_metabase."DataSetMethodProvenance" (
	"DataSetID" integer NOT NULL,
	"MethodStepID" integer NOT NULL,
	"SourcePackageID" character varying(50)
);

COMMENT ON COLUMN lter_metabase."DataSetMethodProvenance"."SourcePackageID" IS 'packageId of the source data package in the PASTA system. e.g.: knb-lter-ble.1.5';

ALTER TABLE lter_metabase."DataSetMethodProvenance"
	ADD CONSTRAINT "PK_DataSetMethodProvenance"
	PRIMARY KEY ("DataSetID", "SourcePackageID");

ALTER TABLE lter_metabase."DataSetMethodProvenance"
	ADD CONSTRAINT "FK_DataSetMethodProvenance"
	FOREIGN KEY ("DataSetID", "MethodStepID")
	REFERENCES lter_metabase."DataSetMethodSteps" ("DataSetID", "MethodStepID")
	ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetMethodProvenance" OWNER TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."DataSetMethodProvenance" TO %db_owner%;
	
-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,23,now(),'using 23_create_provenance_table.sql');
