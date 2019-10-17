-- Enable time stamp triggers 

-- Usage: (1) disable triggers (2) load data with timestamps desired to be preserved (3) enable triggers

ALTER TABLE lter_metabase."ListPeople" ENABLE TRIGGER people_trig_dbupdatetime;

ALTER TABLE pkg_mgmt."pkg_sort" ENABLE TRIGGER pkg_sort_trig_dbudatetime;

ALTER TABLE pkg_mgmt."pkg_state" ENABLE TRIGGER pkg_state_trig_dbudatetime;

/* man page for: DISABLE TRIGGER [ trigger_name | ALL | USER ]
 * 
 * These forms configure the firing of trigger(s) belonging to the table. 
 * A disabled trigger is still known to the system, but is not executed when its triggering event occurs. 
 * ...
 * This script needs updating whenever a table is added or renamed.
 */

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,36,now(),'applied 36_disable_triggers.sql');
