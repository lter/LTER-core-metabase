

-- this patch fixes some minor issues found after the release of LTER-core-metabase

-- issue 83 https://github.com/lter/LTER-core-metabase/issues/83
ALTER TABLE lter_metabase."DataSetMethodSteps"
  RENAME TO "DataSetMethod";

-- issue 82 https://github.com/lter/LTER-core-metabase/issues/82
  ALTER TABLE lter_metabase."DataSet"
DROP CONSTRAINT "IX_DataSet_Accession";

-- issue 81 https://github.com/lter/LTER-core-metabase/issues/81
update lter_metabase."DataSet"
set "PubDate" = '2019-08-07',
    "UpdateFrequency" = 'annually',
    "MaintenanceDescription" = 'Ongoing time series.'
where "DataSetID" = 99013;

update lter_metabase."DataSet"
set "PubDate" = '2016-09-08',
    "UpdateFrequency" = 'notPlanned',
    "MaintenanceDescription" = 'Completed timeseries. No future data updates anticpated.'
where "DataSetID" = 99021;

update lter_metabase."DataSet"
set "PubDate" = '2019-01-15',
    "UpdateFrequency" = 'annually',
    "MaintenanceDescription" = 'Ongoing time series. Data updates may be delayed by analysis.'
where "DataSetID" = 99024;

update lter_metabase."DataSet"
set "PubDate" = '2014-01-14',
    "UpdateFrequency" = 'notPlanned',
    "MaintenanceDescription" = 'Completed timeseries. No future data updates anticpated.'
where "DataSetID" = 99054;

-- issue 80 https://github.com/lter/LTER-core-metabase/issues/80

delete from pkg_mgmt.pkg_core_area
where "DataSetID" < 99000 or "DataSetID" > 100000
;
delete from pkg_mgmt.pkg_core_area
where "DataSetID" < 99000 or "DataSetID" > 100000
;
delete from pkg_mgmt.pkg_sort
where "DataSetID" < 99000 or "DataSetID" > 100000
;

-- issue not registered to github where some names for method documents in the example data do not follow a convention

update lter_metabase."DataSetMethod"
set "Description" = replace("Description",'method.','method.990')
where "Description" not like 'method.990%';

-- issue not registered to github where DataSet.PubDate has a DEFAULT of now(), which is a bad idea (TM)

ALTER TABLE lter_metabase."DataSet" 
	ALTER COLUMN "PubDate"
	DROP DEFAULT;


  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (1,0,35,now(),'applied 35_bug_fixes.sql');