-- Widen character limit for ListSites.AltitudeUnit
DROP VIEW mb2eml_r.vw_eml_geographiccoverage; 

ALTER TABLE lter_metabase."ListSites" 
  ALTER COLUMN "AltitudeUnit" TYPE varchar(100) USING "AltitudeUnit"::varchar;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_geographiccoverage
AS SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."GeoCoverageSortOrder" AS geocoverage_sort_order,
    d."SiteID" AS id,
    s."SiteName"::text || COALESCE(': '::text || s."SiteDescription"::text, ''::text) AS geographicdescription,
    s."NBoundLat" AS northboundingcoordinate,
    s."SBoundLat" AS southboundingcoordinate,
    s."EBoundLon" AS eastboundingcoordinate,
    s."WBoundLon" AS westboundingcoordinate,
    s."AltitudeMin" AS altitudeminimum,
    s."AltitudeMax" AS altitudemaximum,
    s."AltitudeUnit" AS altitudeunits
   FROM lter_metabase."DataSetSites" d
     LEFT JOIN lter_metabase."ListSites" s ON d."SiteID"::text = s."SiteID"::text
  ORDER BY d."DataSetID", d."GeoCoverageSortOrder", d."SiteID";

ALTER TABLE mb2eml_r.vw_eml_geographiccoverage OWNER TO %db_owner%;
GRANT SELECT, INSERT, UPDATE ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_geographiccoverage TO %db_owner%;

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (1, 0, 40,now(),'applied 40_widen_altitude_unit_limit.sql');
