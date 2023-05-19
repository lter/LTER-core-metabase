-- mb2eml_r.vw_eml_entities source

-- 2023-05-15 adding character encoding, which was already a column in EMLFileTypes
-- to the view

DROP VIEW if exists mb2eml_r.vw_eml_entities;

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
    k."CharacterEncoding" as encoding,
    e."FileSize" AS filesize,
    e."FileSizeUnits" AS filesize_units,
    e."Checksum" AS checksum
   FROM lter_metabase."DataSetEntities" e
     LEFT JOIN lter_metabase."EMLFileTypes" k ON e."FileType"::text = k."FileType"::text
  ORDER BY e."DataSetID", e."EntitySortOrder";


   ALTER TABLE mb2eml_r.vw_eml_entities OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_entities FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_entities FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_entities TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_entities TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_entities TO %db_owner%;

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(1, 0, 45, now(), 'apply 45_add_character_encoding_to_vw.sql');