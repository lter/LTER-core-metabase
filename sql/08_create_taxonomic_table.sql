-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE lter_metabase."TaxaList" (
	"TaxonID" character varying(50) NOT NULL,
	"TaxonomicAuthority" character varying(50) NOT NULL,
	"TaxonRankName" character varying(50),
	"TaxonRankValue" character varying(200),
	"CommonName" character varying(200),
	"LocalID" character varying(50)
);

ALTER TABLE ONLY lter_metabase."TaxaList"
	ADD CONSTRAINT "PK_TaxaList"
	PRIMARY KEY ("TaxonID", "TaxonomicAuthority");

CREATE TABLE lter_metabase."DataSetTaxa" (
	"DataSetID" integer NOT NULL,
	"TaxonID" character varying(50) NOT NULL,
	"TaxonomicAuthority" character varying(50) NOT NULL
);

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "PK_DataSetTaxa"
	PRIMARY KEY ("DataSetID", "TaxonID", "TaxonomicAuthority");

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "FK_DataSetTaxa_DataSetID" 
	FOREIGN KEY("DataSetID") 
	REFERENCES lter_metabase."DataSet"("DataSetID") 
	ON UPDATE CASCADE;

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "FK_DataSetTaxa_TaxonID" 
	FOREIGN KEY("TaxonID", "TaxonomicAuthority") 
	REFERENCES lter_metabase."TaxaList"("TaxonID", "TaxonomicAuthority") 
	ON UPDATE CASCADE;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_taxonomy AS
	SELECT d."DataSetID" as datasetid, 
	d."TaxonID" as taxonid, 
	d."TaxonomicAuthority" as taxonid_provider, 
	l."TaxonRankName" as taxonrankname, 
	l."TaxonRankValue" as taxonrankvalue,
	l."CommonName" as commonname 
	FROM lter_metabase."DataSetTaxa" d 
	JOIN lter_metabase."TaxaList" l 
	ON (((d."TaxonID")::text = (l."TaxonID")::text)) AND (((d."TaxonomicAuthority")::text = (l."TaxonomicAuthority")::text)) 
	ORDER BY d."DataSetID";
	
ALTER TABLE lter_metabase."TaxaList" OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."TaxaList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."TaxaList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."TaxaList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."TaxaList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."TaxaList" TO read_only_user;
	
ALTER TABLE lter_metabase."DataSetTaxa" OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."DataSetTaxa" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetTaxa" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetTaxa" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetTaxa" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetTaxa" TO read_only_user;

ALTER TABLE mb2eml_r.vw_eml_taxonomy OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_taxonomy TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;