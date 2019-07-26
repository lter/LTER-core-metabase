DROP VIEW mb2eml_r.vw_eml_datasetmethod;
DROP TABLE lter_metabase."DataSetMethods";
DROP TABLE lter_metabase."ListProtocols";

DROP VIEW mb2eml_r.vw_eml_attributes;
ALTER TABLE lter_metabase."DataSetAttributes" DROP COLUMN "MissingValueCode";
ALTER TABLE lter_metabase."DataSetAttributes" DROP COLUMN "MissingValueCodeExplanation";


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_attributes
AS SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    d."AttributeLabel" AS "attributeLabel",
    d."Description" AS "attributeDefinition",
        CASE
            WHEN d."MeasurementScaleDomainID"::text ~~ 'nominal%'::text THEN 'nominal'::character varying
            WHEN d."MeasurementScaleDomainID"::text ~~ 'ordinal%'::text THEN 'ordinal'::character varying
            ELSE d."MeasurementScaleDomainID"
        END AS "measurementScale",
        CASE
            WHEN d."MeasurementScaleDomainID"::text ~~ '%Enum'::text THEN 'enumeratedDomain'::text
            WHEN d."MeasurementScaleDomainID"::text ~~ '%Text'::text THEN 'textDomain'::text
            WHEN d."MeasurementScaleDomainID"::text = ANY (ARRAY['ratio'::text, 'interval'::text]) THEN 'numericDomain'::text
            WHEN d."MeasurementScaleDomainID"::text = 'dateTime'::text THEN 'dateTimeDomain'::text
            ELSE NULL::text
        END AS domain,
    d."StorageType" AS "storageType",
    d."DateTimeFormatString" AS "formatString",
    d."DateTimePrecision" AS "dateTimePrecision",
    d."TextPatternDefinition" AS definition,
    d."Unit" AS unit,
    d."NumericPrecision" AS "precision",
    d."NumberType" AS "numberType",
    d."BoundsMinimum" AS minimum,
    d."BoundsMaximum" AS maximum
   FROM lter_metabase."DataSetAttributes" d
  ORDER BY d."DataSetID", d."EntitySortOrder", d."ColumnPosition";

ALTER TABLE mb2eml_r.vw_eml_attributes OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributes TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributes TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_attributes TO %db_owner%;