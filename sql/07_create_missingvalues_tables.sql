-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE lter_metabase."MissingCodesList" (
	"MissingValueCodeID" character varying(20) NOT NULL,
	"MissingValueCode" character varying(200) NOT NULL,
	"MissingValueCodeExplanation" character varying(1024) NOT NULL
);

ALTER TABLE ONLY lter_metabase."MissingCodesList" 
	ADD CONSTRAINT "PK_MissingCodesList_MissingValueCodeID" 
	PRIMARY KEY("MissingValueCodeID");
	
ALTER TABLE lter_metabase."MissingCodesList"
    OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."MissingCodesList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MissingCodesList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MissingCodesList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."MissingCodesList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."MissingCodesList" TO read_only_user;

CREATE TABLE lter_metabase."AttributeMissingCodes" (
	"DataSetID" integer NOT NULL,
	"EntitySortOrder" integer NOT NULL,
	"ColumnName" character varying(200) NOT NULL,
	"MissingValueCodeID" character varying(20) NOT NULL
);

ALTER TABLE lter_metabase."AttributeMissingCodes"
    OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."AttributeMissingCodes" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."AttributeMissingCodes" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MissingCodesList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."AttributeMissingCodes" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."AttributeMissingCodes" TO read_only_user;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
	ADD CONSTRAINT "FK_DatasetMissingCode_MissingValueCodeID" 
	FOREIGN KEY ("MissingValueCodeID") 
	REFERENCES lter_metabase."MissingCodesList"("MissingValueCodeID") 
	ON UPDATE CASCADE;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
    ADD CONSTRAINT "FK_DataSet_SortOrder_ColumnName" 
	FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnName") 
	REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnName") 
	ON UPDATE CASCADE;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
    ADD CONSTRAINT "PK_AttributeMissingCodes" 
	PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID");
	
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_missingcodes AS
	SELECT 
	d."DataSetID" as datasetid, 
	d."EntitySortOrder" as entity_position, 
	d."ColumnName" as "attributeName", 
	e."MissingValueCode" as code, 
	e."MissingValueCodeExplanation" as definition 
	FROM (lter_metabase."AttributeMissingCodes" d 
	JOIN lter_metabase."MissingCodesList" e 
	ON (((d."MissingValueCodeID")::text = (e."MissingValueCodeID")::text))) 
	ORDER BY d."DataSetID";

ALTER TABLE mb2eml_r.vw_eml_missingcodes OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_missingcodes FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_missingcodes FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_missingcodes TO read_write_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_missingcodes TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_missingcodes TO read_only_user;