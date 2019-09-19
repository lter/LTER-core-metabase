-- Add columns for filesize and cksum.

ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "FileSize" integer;
ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "FileSizeUnits" varchar(10) DEFAULT 'byte';

ALTER TABLE lter_metabase."DataSetEntities" ADD COLUMN "Checksum" text;
COMMENT ON COLUMN lter_metabase."DataSetEntities"."Checksum"
  IS 'Such as an MD5 hash. Can be any method as long as method is specified in eml-writing config and only one method is used. (Until/unless we add a column for cksum method.)';

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_entities
AS SELECT e."DataSetID" AS datasetid,
    e."EntitySortOrder" AS entity_position,
    e."EntityType" AS entitytype,
    e."EntityName" AS entityname,
    e."EntityDescription" AS entitydescription,
    concat(e."Urlhead", e."Subpath") AS urlpath,
    e."FileName" AS filename,
    e."EntityRecords" AS entityrecords,
    k."FileFormat" AS fileformat,
    k."EML_FormatType" AS formattype,
    k."RecordDelimiter" AS recorddelimiter,
    k."NumHeaderLines" AS headerlines,
    k."NumFooterLines" AS footerlines,
    k."FieldDelimiter" AS fielddlimiter,
    k."externallyDefinedFormat_formatName" AS formatname,
    k."QuoteCharacter" AS quotecharacter,
    k."CollapseDelimiters" AS collapsedelimiter,
    e."FileSize" as filesize,
    e."FileSizeUnits" as filesize_units,
    e."Checksum" as checksum
   FROM lter_metabase."DataSetEntities" e
     LEFT JOIN lter_metabase."EMLFileTypes" k ON e."FileType"::text = k."FileType"::text
  ORDER BY e."DataSetID", e."EntitySortOrder";



  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,31,now(),'applied 31_add_cols_filesize_cksum.sql');
