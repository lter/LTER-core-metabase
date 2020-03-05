-- This patch renames the parent table for missing value codes to be generalized to also hold enumeration code-defintion pairs.
ALTER TABLE lter_metabase."ListMissingCodes" RENAME TO "ListCodes";
ALTER TABLE lter_metabase."ListCodes" RENAME "MissingValueCodeID" TO "CodeID";
ALTER TABLE lter_metabase."ListCodes" RENAME "MissingValueCode" TO "Code";
ALTER TABLE lter_metabase."ListCodes" RENAME "MissingValueCodeExplanation" TO "CodeExplanation";

--The code is max 20 characters so cannot use column names.
--Two codes: VALID and QM are re-used so I appended the length of their definition, just to
-- get these into the table. Then you can manually edit as desired.

INSERT INTO lter_metabase."ListCodes"
SELECT 
CASE "Code" 
  when 'VALID' then max('enum.'||"Code"||length("Definition")::text)
  when 'QM' then max('enum.'||"Code"||length("Definition")::text)
  else max('enum.'||"Code")
END AS "CodeID",
"Code", "Definition" AS "CodeExplanation"
FROM lter_metabase."DataSetAttributeEnumeration"
group by "Code", "Definition";

-- modify xref table

-- add new codeid col
ALTER TABLE lter_metabase."DataSetAttributeEnumeration"
	ADD COLUMN "CodeID" character varying(20);

-- update codeid col with join from listcodes
UPDATE lter_metabase."DataSetAttributeEnumeration" d
	SET "CodeID" = l."CodeID"
	FROM lter_metabase."ListCodes" l
	where
	d."Code" = l."Code" 
	AND d."Definition" = l."CodeExplanation";

-- drop view
DROP VIEW mb2eml_r.vw_eml_attributecodedefinition;

-- drop the two old cols, add new PK and FK
ALTER TABLE lter_metabase."DataSetAttributeEnumeration"
	DROP CONSTRAINT "pk_emlattributecodedefinition_pk",
	DROP COLUMN "Code",
	DROP COLUMN "Definition",
	ADD CONSTRAINT "PK_DataSetAttributeEnumeration" 
		PRIMARY KEY("DataSetID", "EntitySortOrder", "ColumnName", "CodeID"),
	ADD CONSTRAINT "FK_DataSetAttributeEnumeration_ListCodes"
		FOREIGN KEY("CodeID") REFERENCES lter_metabase."ListCodes"("CodeID");

-- re-create view with JOIN this time
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_attributecodedefinition
AS SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    l."Code" AS code,
    l."CodeExplanation" AS definition
   FROM lter_metabase."DataSetAttributeEnumeration" d LEFT JOIN lter_metabase."ListCodes" l
   ON d."CodeID" = l."CodeID"
  ORDER BY d."DataSetID", d."EntitySortOrder";

 ALTER TABLE mb2eml_r.vw_eml_attributecodedefinition OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO %db_owner%;


-- record patch applied

INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (1,0,41,now(),'applied 41_consolidate_missing_enumeration_codes.sql');
