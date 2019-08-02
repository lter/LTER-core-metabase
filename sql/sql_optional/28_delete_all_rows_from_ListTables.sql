/* Deletes all the ListTable data.
 * 
 * CAUTION: these commands delete all rows, not just selected rows.
 * ListTables are more site-specific than EMLTables. 
 * Perhaps you may want to run this before loading your site's content.
 * Do not run this after loading your site's content, or it will delete that too.
 *
 * Note the order of these deletes does matter. Delete rows from child table, then parent.
 */

DELETE FROM lter_metabase."ListKeywords";
DELETE FROM lter_metabase."ListKeywordThesauri";
DELETE FROM lter_metabase."ListMethodInstruments";
DELETE FROM lter_metabase."ListMethodProtocols";
DELETE FROM lter_metabase."ListMethodSoftware";
DELETE FROM lter_metabase."ListMissingCodes";
DELETE FROM lter_metabase."ListPeopleID";
DELETE FROM lter_metabase."ListPeople";
DELETE FROM lter_metabase."ListSites";
DELETE FROM lter_metabase."ListTaxa";
DELETE FROM lter_metabase."ListTaxonomicProviders";


-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,28,now(),'applied 28_delete_all_rows_from_ListTables.sql'); 
