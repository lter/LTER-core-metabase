-- This patch addresses issue #90

-- Allows 'docbook' to be specified as a DescriptionType/AbstractType

ALTER TABLE lter_metabase."DataSetMethod"
    DROP CONSTRAINT "CK_DataSetMethodSteps_DescriptionType";

ALTER TABLE lter_metabase."DataSetMethod"
    ADD CONSTRAINT "CK_DataSetMethod_DescriptionType" 
    CHECK ((("DescriptionType")::text = ANY (ARRAY[('file'::character varying)::text, 
        ('md'::character varying)::text, 
        ('plaintext'::character varying)::text,
        ('docbook'::character varying)::text])));

ALTER TABLE lter_metabase."DataSet"
    DROP CONSTRAINT "CK_DataSet_AbstractType";

ALTER TABLE lter_metabase."DataSet"
    ADD CONSTRAINT "CK_DataSet_AbstractType" 
    CHECK ((("AbstractType")::text = ANY (ARRAY[('file'::character varying)::text, 
        ('md'::character varying)::text, 
        ('plaintext'::character varying)::text,
        ('docbook'::character varying)::text])));

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(1, 0, 39, now(), 'apply 39_add_docbook_descriptiontype.sql');
