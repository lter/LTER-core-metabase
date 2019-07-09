CREATE TABLE lter_metabase."ListTaxonomicProviders" (
	"ProviderID" varchar(20) NOT NULL,
	"ProviderName" varchar(100) NOT NULL,
	"ProviderURL" varchar(250) NULL,
	CONSTRAINT "PK_ListTaxonomicAuthorities" PRIMARY KEY ("ProviderID")
);

COPY lter_metabase."ListTaxonomicProviders" ("ProviderID", "ProviderName", "ProviderURL") FROM stdin;
itis	Integrated Taxonomic Information System	https://itis.gov/
ncbi	National Center for Biotechnology Information	https://www.ncbi.nlm.nih.gov/taxonomy
eol	Encyclopedia of Life	https://eol.org/
col	Catalogue of Life	https://www.catalogueoflife.org/
tropicos	Tropicos	https://www.tropicos.org/
gbif	Global Biodiversity Information Facility	https://www.gbif.org/en/
nbn	National Biodiversity Network	https://nbn.org.uk/
worms	World Register of Marine Species	http://www.marinespecies.org/
natserv	NatureServe	http://explorer.natureserve.org/index.htm
bold	Barcode of Life Data System	http://v3.boldsystems.org/
wiki	Wikispecies	https://species.wikimedia.org/wiki/Main_Page
pow	Kew's Plants of the World	http://www.plantsoftheworldonline.org/
\.

ALTER TABLE lter_metabase."ListTaxa" RENAME COLUMN "TaxonomicAuthority" TO "TaxonomicProviderID";

ALTER TABLE lter_metabase."ListTaxa" ALTER COLUMN "TaxonRankValue" SET NOT NULL;

ALTER TABLE lter_metabase."ListTaxa" ADD CONSTRAINT "FK_ListTaxa_AuthorityID" FOREIGN KEY ("TaxonomicProviderID") REFERENCES lter_metabase."ListTaxonomicAuthorities"("ProviderID") ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetTaxa" RENAME COLUMN "TaxonomicAuthority" TO "TaxonomicProviderID";


ALTER TABLE lter_metabase."ListTaxonomicProviders" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListTaxonomicProviders" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListTaxonomicProviders" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListTaxonomicProviders" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListTaxonomicProviders" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListTaxonomicProviders" TO %db_owner%;

DROP VIEW mb2eml_r.vw_eml_taxonomy;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_taxonomy
AS SELECT d."DataSetID" AS datasetid,
    d."TaxonID" AS taxonid,
    p."ProviderName" AS taxonid_provider,
    p."ProviderID" as providerid,
    l."TaxonRankName" AS taxonrankname,
    l."TaxonRankValue" AS taxonrankvalue,
    l."CommonName" AS commonname
   FROM lter_metabase."DataSetTaxa" d
     JOIN lter_metabase."ListTaxa" l ON d."TaxonID"::text = l."TaxonID"::text AND d."TaxonomicProviderID"::text = l."TaxonomicProviderID"::text
     join lter_metabase."ListTaxonomicProviders" p on d."TaxonomicProviderID"::text = p."ProviderID"::text
  ORDER BY d."DataSetID";
 
 ALTER TABLE lter_metabase."ListTaxonomicProviders" OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_taxonomy TO %db_owner%;