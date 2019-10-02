-- Draft of db tables for semantic annotation    September 2019 An and Gastil

CREATE SCHEMA semantic_annotation;

-- Parent control tables:
/*  
 * ListSemanticAnnotations: TermID, TermLabel, TermSource (or TermOntology,
 * basically where the term came from). PK is TermID + TermSource
 */
 CREATE TABLE semantic_annotation."EMLSemanticAnnotationTerms"
 (
  "TermID"    character varying(40), -- example envo1234 or ecso014004 
  "TermLabel" character varying(200), -- expect never to need more than 100.
  -- "TermSource" character(4), -- Seems extraneous. Dependent on URI. Where the term came from. Basically ENVO or ECSO. I suggest omit this column.
  "TermURI"   text, -- unless pg has a special data type for URIs? Expect unlikely to need more than 100 char. 
  CONSTRAINT "pk_semantic_annotation_TermID" PRIMARY KEY ("TermID"),
  CONSTRAINT "uq_semantic_annotation_TermURI" UNIQUE ("TermURI")
);


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


-- Xref tables:
-- DataSetAnnotations: DataSetID, PropertyTermID, ValueTermID

CREATE TABLE semantic_annotation."DataSetAnnotation"
(
  "DataSetID"   integer,
  "TermID"      character varying(40),
  "ObjectPropertyID"    character varying(200),
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
  "ColumnPosition"  smallint, -- alternatively, AttributeName.
  "TermID"      character varying(40),
  "ObjectPropertyID"    character varying(200),
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

--CREATE VIEW mb2eml_r.vw_eml_semantic_annotation -- TODO An do you want this in mb2eml_r or in semantic_annotation schema?
CREATE VIEW semantic_annotation.vw_eml_semantic_annotation
AS
(
    SELECT 
    a."DataSetID", 
    a."EntitySortOrder", 
    a."ColumnPosition",                           -- or An do you prefer to use a."AttributeName"?
    o."ObjectPropertyLabel" AS propertyuri_label, -- propertyURI_label
    o."ObjectPropertyURI" AS propertyuri,         -- propertyURI
    t."TermLabel" AS valueuri_label,              -- valueURI_label
    t."TermURI" AS valueuri                       -- valueURI 
    FROM semantic_annotation."DataSetAttributeAnnotation" a
    INNER JOIN semantic_annotation."EMLSemanticAnnotationTerms" t
    ON t."TermID"=a."TermID"
    INNER JOIN semantic_annotation."EMLObjectProperties" o
    ON o."ObjectPropertyID"=a."ObjectPropertyID"
    
    UNION
    
    SELECT 
    d."DataSetID", 
    0 AS "EntitySortOrder", 
    0 AS "ColumnPosition",                        -- or "AttributeName"
    o."ObjectPropertyLabel" AS propertyuri_label, -- propertyURI_label
    o."ObjectPropertyURI" AS propertyuri,         -- propertyURI
    t."TermLabel" AS valueuri_label,              -- valueURI_label
    t."TermURI" AS valueuri                       -- valueURI 
    FROM semantic_annotation."DataSetAnnotation" d
    INNER JOIN semantic_annotation."EMLSemanticAnnotationTerms" t
    ON t."TermID"=d."TermID"
    INNER JOIN semantic_annotation."EMLObjectProperties" o
    ON o."ObjectPropertyID"=d."ObjectPropertyID"
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

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,33,now(),'applied 33_semantic_annotation.sql');

