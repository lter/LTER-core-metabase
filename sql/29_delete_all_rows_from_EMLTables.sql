/* CAUTION
 * do not execute this DELETE patch without understanding.
 *
 * This deletes ALL rows from all tables starting with EML in the table name.
 * You may need this content. 
 * Some EMLTable content is the same for all LTER sites and is provided with installation for that reason.
 * Other EMLTables are more site-specific, or specific to a science domain, and may not relate to your site.
 * A few EMLTables are necessary to construct EML, such as MeasurementScale.
 *
 * These deletes only succeed if the dependent rows of child tables have already been deleted,
 * such as with 26_delete_example_datasets.sql or equivalent.
 */

DELETE FROM lter_metabase."EMLFileTypes";
DELETE FROM lter_metabase."EMLKeywordTypes";
DELETE FROM lter_metabase."EMLMeasurementScaleDomains"; 
DELETE FROM lter_metabase."EMLMeasurementScales";
DELETE FROM lter_metabase."EMLNumberTypes";
DELETE FROM lter_metabase."EMLStorageTypes";
DELETE FROM lter_metabase."EMLUnitDictionary";
DELETE FROM lter_metabase."EMLUnitTypes";

-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,29,now(),'applied 29_delete_all_rows_from_EMLTables.sql'); 


