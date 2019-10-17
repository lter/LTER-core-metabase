-- This patch fixes issue #87 

-- The numeric part of dataset_archive_id should be identical to the integer DataSetID column.
-- (The only exception known is for BON, a non-LTER site. There, the pkg_state lists dataSource datasets as well as BON datasets.)
-- We do not want the example rows to misslead.

UPDATE pkg_mgmt.pkg_state
SET dataset_archive_id = replace(dataset_archive_id,'sbc.','sbc.990')
WHERE dataset_archive_id NOT LIKE 'knb-lter-sbc.990%'
;
  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (1,0,38,now(),'applied 38_pkg_state_data_archive_id_correction_to_examples.sql');
