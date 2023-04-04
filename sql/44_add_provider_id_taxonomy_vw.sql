-- 2023-03-14 An realized that it would be good for this view to also contain the provider's URL and name

DROP VIEW mb2eml_r.vw_eml_taxonomy;

-- mb2eml_r.vw_eml_taxonomy source

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_taxonomy
AS SELECT d."DataSetID" AS datasetid,
    d."TaxonID" AS taxonid,
    p."ProviderName" AS taxonid_provider,
    p."ProviderID" AS providerid,
    p."ProviderURL" AS providerurl,
    l."TaxonRankName" AS taxonrankname,
    l."TaxonRankValue" AS taxonrankvalue,
    l."CommonName" AS commonname
   FROM lter_metabase."DataSetTaxa" d
     JOIN lter_metabase."ListTaxa" l ON d."TaxonID"::text = l."TaxonID"::text AND d."TaxonomicProviderID"::text = l."TaxonomicProviderID"::text
     JOIN lter_metabase."ListTaxonomicProviders" p ON d."TaxonomicProviderID"::text = p."ProviderID"::text
  ORDER BY d."DataSetID";

   ALTER TABLE mb2eml_r.vw_eml_taxonomy OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_taxonomy TO %db_owner%;

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(1, 0, 44, now(), 'apply 44_add_provider_id_taxonomy.sql');