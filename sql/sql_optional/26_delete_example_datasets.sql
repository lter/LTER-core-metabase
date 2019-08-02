/* Deletes all the example data that came with the installation.
 * 
 * CAUTION: if you happen to have a dataset with an ID in this 99* set, Bye Bye!
 *
 * Notice the child table has to be deleted before the parent table.
 * That is why this is not just alphabetical order. DataSet is last.
 *
 * This script only deletes example DataSet data, not List or EML rows.
 */
DELETE FROM lter_metabase."DataSetAttributeEnumeration"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetAttributeMissingCodes"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetAttributes"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetEntities"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetKeywords"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetMethodInstruments"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetMethodProtocols"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetMethodProvenance"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetMethodSoftware"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetMethodSteps"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetPersonnel"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetSites"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetTaxa"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSetTemporal"
WHERE "DataSetID" in (99013,99021,99024,99054);

DELETE FROM lter_metabase."DataSet"
WHERE "DataSetID" in (99013,99021,99024,99054);

-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,26,now(),'from 26_delete_example_datasets.sql');
