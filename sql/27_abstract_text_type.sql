-- Add variable content type for abstract to table and view.

ALTER TABLE lter_metabase."DataSet" 
  ADD COLUMN "AbstractType" character varying(10);

-- Column cannot be null before adding NOT NULL to it. All example data (so far) is type file.
UPDATE lter_metabase."DataSet"
SET "AbstractType" = 'file'
WHERE "Abstract" like 'abstract.%.docx';

ALTER TABLE lter_metabase."DataSet" 
  ALTER COLUMN "AbstractType" SET NOT NULL;

COMMENT ON COLUMN lter_metabase."DataSet"."AbstractType" IS 'Indicates which type of content Abstract column contains (plaintext, md, file).';

ALTER TABLE lter_metabase."DataSet" 
  ADD CONSTRAINT "CK_DataSet_AbstractType" 
    CHECK ("AbstractType"::text = ANY (ARRAY['file'::character varying::text, 'md'::character varying::text, 'plaintext'::character varying::text]));

DROP VIEW mb2eml_r.vw_eml_dataset; -- because changes output columns, cannot merely REPLACE.
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_dataset AS 
 SELECT d."DataSetID" AS datasetid, 
    d."Revision" AS revision_number, 
    d."Title" AS title, 
    d."AbstractType" AS abstract_type,
    d."Abstract" AS abstract, 
    d."ShortName" AS shortname, 
    d."UpdateFrequency" AS maintenanceupdatefrequency, 
    d."MaintenanceDescription" AS maintenance_description, 
    d."PubDate" AS pubdate
   FROM lter_metabase."DataSet" d
  ORDER BY d."DataSetID";

ALTER TABLE mb2eml_r.vw_eml_dataset OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_dataset TO %db_owner%;

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,27,now(),'applied 27_abstract_text_type.sql');
