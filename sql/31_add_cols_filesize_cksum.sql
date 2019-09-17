-- Add columns for filesize and cksum.

ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "FileSize" integer;
ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "FileSizeUnits" varchar(10) DEFAULT 'byte';

ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "Checksum" text;
COMMENT ON COLUMN lter_metabase."DataSetEntities"."Checksum"
  IS 'Such as an MD5 hash. Can be any method as long as method is specified in eml-writing config and only one method is used. (Until/unless we add a column for cksum method.)';


  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,31,now(),'applied 31_add_cols_filesize_cksum.sql');
