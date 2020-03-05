-- Draft of db tables for semantic annotation    September 2019 An and Gastil

CREATE SCHEMA semantic_annotation;
grant usage on schema semantic_annotation to %db_owner%;
grant usage on schema semantic_annotation to read_only_user;
grant usage on schema semantic_annotation to read_write_user;


-- Parent control tables:
/*  
 * ListSemanticAnnotations: TermID, TermLabel, TermSource (or TermOntology,
 * basically where the term came from). PK is TermID + TermSource
 */
 CREATE TABLE semantic_annotation."EMLSemanticAnnotationTerms"
 (
  "TermID"    character varying(40), -- example envo1234 or ecso014004 
  "TermLabel" character varying(200), -- expect never to need more than 100.
  "TermURI"   text, -- unless pg has a special data type for URIs? Expect unlikely to need more than 100 char. 
  CONSTRAINT "pk_semantic_annotation_TermID" PRIMARY KEY ("TermID"),
  CONSTRAINT "uq_semantic_annotation_TermURI" UNIQUE ("TermURI")
);

ALTER TABLE semantic_annotation."EMLSemanticAnnotationTerms"
  ADD CONSTRAINT ck_semantic_annotation_no_lead_trail_whitespace
  CHECK ("TermID" like btrim("TermID") AND "TermLabel" like btrim("TermLabel") AND "TermURI" like btrim("TermURI"));
COMMENT ON CONSTRAINT ck_semantic_annotation_no_lead_trail_whitespace ON semantic_annotation."EMLSemanticAnnotationTerms"
  IS 'Ensure no extra characters get entered as is common when pasting from ECSO.';

-- ListSemanticOntologies: Ontology
/* 
 * We do not need this table. The URIs determine which ontology (or vocabulary) a term is from.
 * So the parent table would not be controlling anything. 
 * If we do opt for a column "TermSource" we can put a CHECK constraint such as IN ('ENVO','ECSO').
 */


-- A tiny table!
CREATE TABLE semantic_annotation."EMLObjectProperties" -- like "of Characteristic" or "is a measurement of" or "is about"
(
  "ObjectPropertyID"    character varying(200),
  "ObjectPropertyLabel"   character varying(200),
  "ObjectPropertyURI"     text,
  CONSTRAINT "pk_EMLObjectProperty" PRIMARY KEY ("ObjectPropertyID"),
  CONSTRAINT "uq_objectPropertyURI" UNIQUE ("ObjectPropertyURI")
);

ALTER TABLE semantic_annotation."EMLObjectProperties"
  ADD CONSTRAINT ck_object_properties_no_lead_trail_whitespace
  CHECK ("ObjectPropertyID" like btrim("ObjectPropertyID") AND "ObjectPropertyLabel" like btrim("ObjectPropertyLabel") AND "ObjectPropertyURI" like btrim("ObjectPropertyURI"));

-- Xref tables:
-- DataSetAnnotations: DataSetID, PropertyTermID, ValueTermID

CREATE TABLE semantic_annotation."DataSetAnnotation"
(
  "DataSetID"   integer,
  "TermID"      character varying(40),
  "ObjectPropertyID"    character varying(200) DEFAULT 'IAO_0000136', -- IAO_0000136 = "is about"
  CONSTRAINT "pk_DataSetAnnotation_DataSetID_TermID" PRIMARY KEY ("DataSetID","TermID"),
  CONSTRAINT "fk_SA_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_SA_TermID" FOREIGN KEY ("TermID") REFERENCES semantic_annotation."EMLSemanticAnnotationTerms" ("TermID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_SA_ObjPropID" FOREIGN KEY ("ObjectPropertyID") REFERENCES semantic_annotation."EMLObjectProperties" ("ObjectPropertyID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION
);

-- I noticed we forgot to put a UNIQUE CONSTRAINT on (di,ei,ai). Fixing that, not just so it can be used in a FK, but also to prevent errors.
ALTER TABLE lter_metabase."DataSetAttributes"
  ADD CONSTRAINT "DataSetAttributes_UQ_DataSetID_EntitySortOrder_ColumnPosition" UNIQUE ("DataSetID", "EntitySortOrder", "ColumnPosition");


CREATE TABLE semantic_annotation."DataSetAttributeAnnotation"
(
  "DataSetID"   integer,
  "EntitySortOrder" integer,
  "ColumnPosition"  int, -- alternatively, AttributeName.
  "TermID"      character varying(40),
  "ObjectPropertyID"    character varying(200) DEFAULT 'containsMeasurementsOfType',
  CONSTRAINT "pk_DataSetAttributeAnnotation_DataSetID_TermID" PRIMARY KEY ("DataSetID","EntitySortOrder","ColumnPosition","TermID"),
  CONSTRAINT "fk_SAA_DataSetID" FOREIGN KEY ("DataSetID","EntitySortOrder","ColumnPosition") REFERENCES lter_metabase."DataSetAttributes" ("DataSetID","EntitySortOrder","ColumnPosition")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_SAA_TermID" FOREIGN KEY ("TermID") REFERENCES semantic_annotation."EMLSemanticAnnotationTerms" ("TermID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_SAA_ObjPropID" FOREIGN KEY ("ObjectPropertyID") REFERENCES semantic_annotation."EMLObjectProperties" ("ObjectPropertyID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION
);

-- VIEW(s) for MetaEgres

-- view joins the xref table with its parent tables to output all the stuff needed to write the EML.
-- The place to put the snippet, identified by a (di,ei,ai) if for an attribute or just (di) for a dataset.
-- Choose either the UNION option to have one VIEW, or two separate VIEWs.

--CREATE VIEW mb2eml_r.vw_eml_semantic_annotation -- TODO move to semantic_annotation later once sa schema part of distribution.
CREATE or replace VIEW semantic_annotation.vw_eml_semantic_annotation
AS
(
    SELECT 
    a."DataSetID" as datasetid, 
    a."EntitySortOrder" as entity_position, 
    d."ColumnName" as "attributeName",
    a."ColumnPosition" as column_position,                       -- or An do you prefer to use a."AttributeName"?
    o."ObjectPropertyLabel" AS propertyuri_label, -- propertyURI_label
    o."ObjectPropertyURI" AS propertyuri,         -- propertyURI
    t."TermLabel" AS valueuri_label,              -- valueURI_label
    t."TermURI" AS valueuri                       -- valueURI 
    FROM semantic_annotation."DataSetAttributeAnnotation" a
    INNER JOIN lter_metabase."DataSetAttributes" d
    ON d."DataSetID" = a."DataSetID" AND d."EntitySortOrder" = a."EntitySortOrder" and d."ColumnPosition" = a."ColumnPosition"
    INNER JOIN semantic_annotation."EMLSemanticAnnotationTerms" t
    ON t."TermID"=a."TermID"
    INNER JOIN semantic_annotation."EMLObjectProperties" o
    ON o."ObjectPropertyID"=a."ObjectPropertyID"

    
    UNION
    
    SELECT 
    d."DataSetID" as datasetid, 
    0 as entity_position,
    '0' as "attributeName",
    0 as column_position,                    -- or "AttributeName"
    o."ObjectPropertyLabel" AS propertyuri_label, -- propertyURI_label
    o."ObjectPropertyURI" AS propertyuri,         -- propertyURI
    t."TermLabel" AS valueuri_label,              -- valueURI_label
    t."TermURI" AS valueuri                       -- valueURI 
    FROM semantic_annotation."DataSetAnnotation" d
    INNER JOIN semantic_annotation."EMLSemanticAnnotationTerms" t
    ON t."TermID"=d."TermID"
    INNER JOIN semantic_annotation."EMLObjectProperties" o
    ON o."ObjectPropertyID"=d."ObjectPropertyID"
    ORDER BY datasetid, entity_position, column_position
);

/*  Example EML Snippet
 * 
 * <attribute id="att.12">
 * <attributeName>biomass</attributeName>
 * ...
 * <annotation>
 *    <propertyURI label="of characteristic">http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#ofCharacteristic</propertyURI>
 *    <valueURI label="Mass">http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Mass</valueURI>
 * </annotation>
 * 
 * property is like "is a measurement of" for atts, or "is about" for datasets
 * value is like Mass for atts
 * 
 *  */

ALTER TABLE semantic_annotation.vw_eml_semantic_annotation OWNER TO %db_owner%;

REVOKE ALL ON TABLE semantic_annotation.vw_eml_semantic_annotation FROM PUBLIC;
REVOKE ALL ON TABLE semantic_annotation.vw_eml_semantic_annotation FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE semantic_annotation.vw_eml_semantic_annotation TO read_write_user;
GRANT SELECT ON TABLE semantic_annotation.vw_eml_semantic_annotation TO read_only_user;
GRANT ALL ON TABLE semantic_annotation.vw_eml_semantic_annotation TO %db_owner%;

ALTER TABLE semantic_annotation."DataSetAttributeAnnotation" OWNER TO %db_owner%;

REVOKE ALL ON TABLE semantic_annotation."DataSetAttributeAnnotation" FROM PUBLIC;
REVOKE ALL ON TABLE semantic_annotation."DataSetAttributeAnnotation" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE semantic_annotation."DataSetAttributeAnnotation" TO read_write_user;
GRANT SELECT ON TABLE semantic_annotation."DataSetAttributeAnnotation" TO read_only_user;
GRANT ALL ON TABLE semantic_annotation."DataSetAttributeAnnotation" TO %db_owner%;

ALTER TABLE semantic_annotation."DataSetAnnotation" OWNER TO %db_owner%;

REVOKE ALL ON TABLE semantic_annotation."DataSetAnnotation" FROM PUBLIC;
REVOKE ALL ON TABLE semantic_annotation."DataSetAnnotation" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE semantic_annotation."DataSetAnnotation" TO read_write_user;
GRANT SELECT ON TABLE semantic_annotation."DataSetAnnotation" TO read_only_user;
GRANT ALL ON TABLE semantic_annotation."DataSetAnnotation" TO %db_owner%;

ALTER TABLE semantic_annotation."EMLObjectProperties" OWNER TO %db_owner%;

REVOKE ALL ON TABLE semantic_annotation."EMLObjectProperties" FROM PUBLIC;
REVOKE ALL ON TABLE semantic_annotation."EMLObjectProperties" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE semantic_annotation."EMLObjectProperties" TO read_write_user;
GRANT SELECT ON TABLE semantic_annotation."EMLObjectProperties" TO read_only_user;
GRANT ALL ON TABLE semantic_annotation."EMLObjectProperties" TO %db_owner%;

ALTER TABLE semantic_annotation."EMLSemanticAnnotationTerms" OWNER TO %db_owner%;

REVOKE ALL ON TABLE semantic_annotation."EMLSemanticAnnotationTerms" FROM PUBLIC;
REVOKE ALL ON TABLE semantic_annotation."EMLSemanticAnnotationTerms" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE semantic_annotation."EMLSemanticAnnotationTerms" TO read_write_user;
GRANT SELECT ON TABLE semantic_annotation."EMLSemanticAnnotationTerms" TO read_only_user;
GRANT ALL ON TABLE semantic_annotation."EMLSemanticAnnotationTerms" TO %db_owner%;

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,33,now(),'applied 33_semantic_annotation.sql revision 2019-10-03');
