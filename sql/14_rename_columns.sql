

ALTER TABLE lter_metabase."DataSetAttributeEnumeration" RENAME COLUMN code TO "Code";
ALTER TABLE lter_metabase."DataSetAttributeEnumeration" RENAME COLUMN definition TO "Definition";

ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "PrecisionDateTime" TO "DateTimePrecision";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "PrecisionNumeric" TO "NumericPrecision";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "FormatString" TO "DateTimeFormatString";
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "Description" DROP DEFAULT;
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "MeasurementScaleDomainID" SET NOT NULL;


COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName';
ALTER TABLE lter_metabase."DataSetEntities" RENAME COLUMN "DataAnomalies" TO "AdditionalInfo";


ALTER TABLE lter_metabase."DataSetKeywords" ALTER COLUMN "ThesaurusID" TYPE varchar(50) USING "ThesaurusID"::varchar;
ALTER TABLE lter_metabase."DataSetKeywords" ALTER COLUMN "ThesaurusID" SET DEFAULT 'none'::character varying;

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'if not creator, then will go into associatedParty';

ALTER TABLE lter_metabase."DataSetSites" ALTER COLUMN "EntitySortOrder" SET DEFAULT 0;
COMMENT ON COLUMN lter_metabase."DataSetSites"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';
ALTER TABLE lter_metabase."DataSetSites" RENAME COLUMN "SiteCode" TO "SiteID";

ALTER TABLE lter_metabase."DataSetTemporal" ALTER COLUMN "EntitySortOrder" SET DEFAULT 0;
COMMENT ON COLUMN lter_metabase."DataSetTemporal"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';

ALTER TABLE lter_metabase."ListPeople" RENAME COLUMN "Phone1" TO "Phone";

ALTER TABLE lter_metabase."ListSites" RENAME COLUMN "SiteDesc" TO "SiteDescription";
ALTER TABLE lter_metabase."ListSites" RENAME COLUMN unit TO "AltitudeUnit";
ALTER TABLE lter_metabase."ListSites" RENAME COLUMN "SiteCode" TO "SiteID";

ALTER TABLE lter_metabase."ListSites" DROP CONSTRAINT "CK_SiteRegister_SiteType";

ALTER TABLE lter_metabase."ListPeopleID" RENAME COLUMN "Identificationtype" TO "IdentificationSystem";

ALTER TABLE lter_metabase."ListPeopleID" RENAME COLUMN "Identificationlink" TO "IdentificationURL";

