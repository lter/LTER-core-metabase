--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

-- Started on 2023-05-19 12:04:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 112006)
-- Name: lter_metabase; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA lter_metabase;


ALTER SCHEMA lter_metabase OWNER TO %db_owner%;

--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA lter_metabase; Type: COMMENT; Schema: -; Owner: %db_owner%
--

COMMENT ON SCHEMA lter_metabase IS 'Contains metadata for dataset EML.';


--
-- TOC entry 7 (class 2615 OID 112007)
-- Name: mb2eml_r; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA mb2eml_r;


ALTER SCHEMA mb2eml_r OWNER TO %db_owner%;

--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA mb2eml_r; Type: COMMENT; Schema: -; Owner: %db_owner%
--

COMMENT ON SCHEMA mb2eml_r IS 'Contains read-only views for exporting to EML via R.';


--
-- TOC entry 8 (class 2615 OID 112008)
-- Name: pkg_mgmt; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA pkg_mgmt;


ALTER SCHEMA pkg_mgmt OWNER TO %db_owner%;

--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA pkg_mgmt; Type: COMMENT; Schema: -; Owner: %db_owner%
--

COMMENT ON SCHEMA pkg_mgmt IS 'Contains tables for internal data package inventory and tracking.';


--
-- TOC entry 285 (class 1255 OID 112009)
-- Name: update_modified_column(); Type: FUNCTION; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE FUNCTION pkg_mgmt.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.dbupdatetime = now();
    RETURN NEW;	
END;
$$;


ALTER FUNCTION pkg_mgmt.update_modified_column() OWNER TO %db_owner%;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 199 (class 1259 OID 112010)
-- Name: DataSet; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSet" (
    "DataSetID" integer NOT NULL,
    "Revision" integer,
    "Title" character varying(300) NOT NULL,
    "PubDate" date,
    "Abstract" character varying(5000) NOT NULL,
    "ShortName" character varying(200),
    "UpdateFrequency" character varying(50),
    "MaintenanceDescription" character varying(500),
    "AbstractType" character varying(10) NOT NULL,
    "BoilerplateSetting" character varying(20) DEFAULT 'default'::character varying NOT NULL,
    CONSTRAINT "CK_DataSetMethodSteps_AbstractType" CHECK ((("AbstractType")::text = ANY (ARRAY[('file'::character varying)::text, ('md'::character varying)::text, ('plaintext'::character varying)::text, ('docbook'::character varying)::text]))),
    CONSTRAINT "CK_DataSet_AbstractType" CHECK ((("AbstractType")::text = ANY (ARRAY[('file'::character varying)::text, ('md'::character varying)::text, ('plaintext'::character varying)::text, ('docbook'::character varying)::text])))
);


ALTER TABLE lter_metabase."DataSet" OWNER TO %db_owner%;

--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN "DataSet"."ShortName"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSet"."ShortName" IS 'Goes into /dataset/shortName.';


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN "DataSet"."UpdateFrequency"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSet"."UpdateFrequency" IS 'Use controlled vocabulary in pkg_mgmt.cv_maint_freq. goes into /dataset/maintenance/maintenanceUpdateFrequency. ';


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN "DataSet"."MaintenanceDescription"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSet"."MaintenanceDescription" IS 'Freeform text meant to go into /dataset/maintenance/description/.';


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN "DataSet"."AbstractType"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSet"."AbstractType" IS 'Indicates which type of content Abstract column contains (plaintext, md, file).';


--
-- TOC entry 277 (class 1259 OID 112809)
-- Name: DataSetAnnotation; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAnnotation" (
    "DataSetID" integer NOT NULL,
    "TermID" character varying(40) NOT NULL,
    "ObjectPropertyID" character varying(200) DEFAULT 'IAO_0000136'::character varying
);


ALTER TABLE lter_metabase."DataSetAnnotation" OWNER TO %db_owner%;

--
-- TOC entry 278 (class 1259 OID 112832)
-- Name: DataSetAttributeAnnotation; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAttributeAnnotation" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnPosition" integer NOT NULL,
    "TermID" character varying(40) NOT NULL,
    "ObjectPropertyID" character varying(200) DEFAULT 'containsMeasurementsOfType'::character varying
);


ALTER TABLE lter_metabase."DataSetAttributeAnnotation" OWNER TO %db_owner%;

--
-- TOC entry 200 (class 1259 OID 112019)
-- Name: DataSetAttributeEnumeration; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAttributeEnumeration" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnName" character varying(200) NOT NULL,
    "CodeID" character varying(20) NOT NULL
);


ALTER TABLE lter_metabase."DataSetAttributeEnumeration" OWNER TO %db_owner%;

--
-- TOC entry 201 (class 1259 OID 112022)
-- Name: DataSetAttributeMissingCodes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAttributeMissingCodes" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnName" character varying(200) NOT NULL,
    "MissingValueCodeID" character varying(20) NOT NULL
);


ALTER TABLE lter_metabase."DataSetAttributeMissingCodes" OWNER TO %db_owner%;

--
-- TOC entry 202 (class 1259 OID 112025)
-- Name: DataSetAttributes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAttributes" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnPosition" smallint NOT NULL,
    "ColumnName" character varying(200) NOT NULL,
    "AttributeID" character varying(200) NOT NULL,
    "AttributeLabel" character varying(200) NOT NULL,
    "Description" character varying(2000) NOT NULL,
    "StorageType" character varying(30),
    "MeasurementScaleDomainID" character varying(12) NOT NULL,
    "DateTimeFormatString" character varying(40),
    "DateTimePrecision" character varying(40),
    "TextPatternDefinition" character varying(500),
    "Unit" character varying(100),
    "NumericPrecision" double precision,
    "NumberType" character varying(30),
    "BoundsMinimum" character varying(100),
    "BoundsMaximum" character varying(100),
    CONSTRAINT "DataSetAttributes_CK_FormatString" CHECK (((("DateTimeFormatString" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ 'dateTime'::text)) OR (("DateTimeFormatString" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ 'dateTime'::text)))),
    CONSTRAINT "DataSetAttributes_CK_NumberType" CHECK (((("NumberType" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("NumberType" IS NOT NULL) AND (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text]))))),
    CONSTRAINT "DataSetAttributes_CK_PrecisionDateTime" CHECK (((("DateTimePrecision" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ 'dateTime'::text)) OR (("DateTimePrecision" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ 'dateTime'::text)))),
    CONSTRAINT "DataSetAttributes_CK_PrecisionNumeric" CHECK (((("NumericPrecision" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])))),
    CONSTRAINT "DataSetAttributes_CK_TextPatternDefinition" CHECK (((("TextPatternDefinition" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ '%Text'::text)) OR (("TextPatternDefinition" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ '%Text'::text)))),
    CONSTRAINT "DataSetAttributes_CK_unit" CHECK (((("Unit" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("Unit" IS NOT NULL) AND (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])))))
);


ALTER TABLE lter_metabase."DataSetAttributes" OWNER TO %db_owner%;

--
-- TOC entry 203 (class 1259 OID 112037)
-- Name: DataSetEntities; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetEntities" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "EntityName" character varying(100) NOT NULL,
    "EntityType" character varying(50) NOT NULL,
    "EntityDescription" character varying(1000) NOT NULL,
    "EntityRecords" integer,
    "FileType" character varying(10),
    "Urlhead" character varying(1024),
    "Subpath" character varying(1024),
    "FileName" character varying(200),
    "AdditionalInfo" character varying(7000),
    "FileSize" integer,
    "FileSizeUnits" character varying(10) DEFAULT 'byte'::character varying,
    "Checksum" text
);


ALTER TABLE lter_metabase."DataSetEntities" OWNER TO %db_owner%;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN "DataSetEntities"."EntityType"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetEntities"."EntityType" IS 'One of "dataTable," "spatialVector," "spatialRaster," or "otherEntity."';


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN "DataSetEntities"."FileName"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName';


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN "DataSetEntities"."Checksum"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetEntities"."Checksum" IS 'Such as an MD5 hash. Can be any method as long as method is specified in eml-writing config and only one method is used. (Until/unless we add a column for cksum method.)';


--
-- TOC entry 204 (class 1259 OID 112044)
-- Name: DataSetKeywords; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetKeywords" (
    "DataSetID" integer NOT NULL,
    "Keyword" character varying(100) NOT NULL,
    "ThesaurusID" character varying(50) DEFAULT 'none'::character varying NOT NULL
);


ALTER TABLE lter_metabase."DataSetKeywords" OWNER TO %db_owner%;

--
-- TOC entry 205 (class 1259 OID 112048)
-- Name: DataSetMethod; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethod" (
    "DataSetID" integer NOT NULL,
    "MethodStepID" integer NOT NULL,
    "DescriptionType" character varying(10),
    "Description" text,
    "Method_xml" xml,
    CONSTRAINT "CK_DataSetMethodSteps_DescriptionHasType" CHECK (((("DescriptionType" IS NULL) AND ("Description" IS NULL)) OR (("DescriptionType" IS NOT NULL) AND ("Description" IS NOT NULL)))),
    CONSTRAINT "CK_DataSetMethodSteps_text_or_xml" CHECK ((("Description" IS NOT NULL) OR ("Method_xml" IS NOT NULL))),
    CONSTRAINT "CK_DataSetMethod_DescriptionType" CHECK ((("DescriptionType")::text = ANY (ARRAY[('file'::character varying)::text, ('md'::character varying)::text, ('plaintext'::character varying)::text, ('docbook'::character varying)::text])))
);


ALTER TABLE lter_metabase."DataSetMethod" OWNER TO %db_owner%;

--
-- TOC entry 206 (class 1259 OID 112057)
-- Name: DataSetMethodInstruments; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethodInstruments" (
    "DataSetID" integer NOT NULL,
    "MethodStepID" integer NOT NULL,
    "InstrumentID" integer NOT NULL
);


ALTER TABLE lter_metabase."DataSetMethodInstruments" OWNER TO %db_owner%;

--
-- TOC entry 207 (class 1259 OID 112060)
-- Name: DataSetMethodProtocols; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethodProtocols" (
    "DataSetID" integer NOT NULL,
    "MethodStepID" integer NOT NULL,
    "ProtocolID" integer NOT NULL
);


ALTER TABLE lter_metabase."DataSetMethodProtocols" OWNER TO %db_owner%;

--
-- TOC entry 208 (class 1259 OID 112063)
-- Name: DataSetMethodProvenance; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethodProvenance" (
    "DataSetID" integer NOT NULL,
    "MethodStepID" integer NOT NULL,
    "SourcePackageID" character varying(50) NOT NULL
);


ALTER TABLE lter_metabase."DataSetMethodProvenance" OWNER TO %db_owner%;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN "DataSetMethodProvenance"."SourcePackageID"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetMethodProvenance"."SourcePackageID" IS 'packageId of the source data package in the PASTA system. e.g.: knb-lter-ble.1.5';


--
-- TOC entry 209 (class 1259 OID 112066)
-- Name: DataSetMethodSoftware; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethodSoftware" (
    "DataSetID" integer NOT NULL,
    "MethodStepID" integer NOT NULL,
    "SoftwareID" integer NOT NULL
);


ALTER TABLE lter_metabase."DataSetMethodSoftware" OWNER TO %db_owner%;

--
-- TOC entry 210 (class 1259 OID 112069)
-- Name: DataSetPersonnel; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetPersonnel" (
    "DataSetID" integer NOT NULL,
    "NameID" character varying(20) NOT NULL,
    "AuthorshipOrder" smallint NOT NULL,
    "AuthorshipRole" character varying(100)
);


ALTER TABLE lter_metabase."DataSetPersonnel" OWNER TO %db_owner%;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN "DataSetPersonnel"."AuthorshipOrder"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipOrder" IS 'This is only relevant for "creator" roles.';


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN "DataSetPersonnel"."AuthorshipRole"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'if not creator, then will go into associatedParty';


--
-- TOC entry 281 (class 1259 OID 112872)
-- Name: DataSetPublications; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetPublications" (
    "DataSetID" integer NOT NULL,
    "Revision" integer,
    "PublicationID" integer NOT NULL,
    "RelationshipType" character varying(40),
    CONSTRAINT "fk_SAA_ObjPropID" CHECK ((("RelationshipType")::text = ANY (ARRAY[('literatureCited'::character varying)::text, ('usageCitation'::character varying)::text, ('referencePublication'::character varying)::text])))
);


ALTER TABLE lter_metabase."DataSetPublications" OWNER TO %db_owner%;

--
-- TOC entry 211 (class 1259 OID 112072)
-- Name: DataSetSites; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetSites" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer DEFAULT 0 NOT NULL,
    "SiteID" character varying(50) NOT NULL,
    "GeoCoverageSortOrder" integer DEFAULT 1 NOT NULL
);


ALTER TABLE lter_metabase."DataSetSites" OWNER TO %db_owner%;

--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN "DataSetSites"."EntitySortOrder"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetSites"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';


--
-- TOC entry 212 (class 1259 OID 112077)
-- Name: DataSetTaxa; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetTaxa" (
    "DataSetID" integer NOT NULL,
    "TaxonID" character varying(50) NOT NULL,
    "TaxonomicProviderID" character varying(50) NOT NULL
);


ALTER TABLE lter_metabase."DataSetTaxa" OWNER TO %db_owner%;

--
-- TOC entry 213 (class 1259 OID 112080)
-- Name: DataSetTemporal; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetTemporal" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer DEFAULT 0 NOT NULL,
    "BeginDate" date NOT NULL,
    "EndDate" date NOT NULL,
    "UseOnlyYear" boolean
);


ALTER TABLE lter_metabase."DataSetTemporal" OWNER TO %db_owner%;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN "DataSetTemporal"."EntitySortOrder"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."DataSetTemporal"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';


--
-- TOC entry 214 (class 1259 OID 112084)
-- Name: EMLFileTypes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLFileTypes" (
    "FileType" character varying(10) NOT NULL,
    "TypeName" character varying(50) NOT NULL,
    "FileFormat" character varying(80) NOT NULL,
    "Extension" character varying(10) NOT NULL,
    "Description" character varying(255) NOT NULL,
    "Delimiters" character varying(50) NOT NULL,
    "Header" character varying(300) NOT NULL,
    "EML_FormatType" character varying(50),
    "RecordDelimiter" character varying(10),
    "NumHeaderLines" smallint,
    "NumFooterLines" smallint,
    "AttributeOrientation" character varying(20) DEFAULT 'column'::character varying,
    "QuoteCharacter" character(1),
    "FieldDelimiter" character varying(10),
    "CharacterEncoding" character varying(20),
    "CollapseDelimiters" character varying(3),
    "LiteralCharacter" character varying(4),
    "externallyDefinedFormat_formatName" character varying(200),
    "externallyDefinedFormat_formatVersion" character varying(200),
    CONSTRAINT "CK_FileTypeList_CollapseDelimiters" CHECK (((("CollapseDelimiters")::text = ANY (ARRAY[('yes'::character varying)::text, ('no'::character varying)::text])) OR ("CollapseDelimiters" IS NULL)))
);


ALTER TABLE lter_metabase."EMLFileTypes" OWNER TO %db_owner%;

--
-- TOC entry 215 (class 1259 OID 112092)
-- Name: EMLKeywordTypes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLKeywordTypes" (
    "KeywordType" character varying(20) NOT NULL,
    "TypeDefinition" character varying(500)
);


ALTER TABLE lter_metabase."EMLKeywordTypes" OWNER TO %db_owner%;

--
-- TOC entry 216 (class 1259 OID 112098)
-- Name: EMLMeasurementScaleDomains; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLMeasurementScaleDomains" (
    "EMLDomainType" character varying(17) NOT NULL,
    "MeasurementScale" character varying(8) NOT NULL,
    "NonNumericDomain" character varying(17),
    "MeasurementScaleDomainID" character varying(12) NOT NULL
);


ALTER TABLE lter_metabase."EMLMeasurementScaleDomains" OWNER TO %db_owner%;

--
-- TOC entry 217 (class 1259 OID 112101)
-- Name: EMLMeasurementScales; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLMeasurementScales" (
    "measurementScale" character varying(20) NOT NULL
);


ALTER TABLE lter_metabase."EMLMeasurementScales" OWNER TO %db_owner%;

--
-- TOC entry 218 (class 1259 OID 112104)
-- Name: EMLNumberTypes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLNumberTypes" (
    "NumberType" character varying(30) NOT NULL
);


ALTER TABLE lter_metabase."EMLNumberTypes" OWNER TO %db_owner%;

--
-- TOC entry 276 (class 1259 OID 112798)
-- Name: EMLObjectProperties; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLObjectProperties" (
    "ObjectPropertyID" character varying(200) NOT NULL,
    "ObjectPropertyLabel" character varying(200),
    "ObjectPropertyURI" text,
    CONSTRAINT ck_object_properties_no_lead_trail_whitespace CHECK (((("ObjectPropertyID")::text ~~ btrim(("ObjectPropertyID")::text)) AND (("ObjectPropertyLabel")::text ~~ btrim(("ObjectPropertyLabel")::text)) AND ("ObjectPropertyURI" ~~ btrim("ObjectPropertyURI"))))
);


ALTER TABLE lter_metabase."EMLObjectProperties" OWNER TO %db_owner%;

--
-- TOC entry 219 (class 1259 OID 112107)
-- Name: EMLStorageTypes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLStorageTypes" (
    "StorageType" character varying(30) NOT NULL,
    "typeSystem" character varying(200)
);


ALTER TABLE lter_metabase."EMLStorageTypes" OWNER TO %db_owner%;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN "EMLStorageTypes"."typeSystem"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."EMLStorageTypes"."typeSystem" IS 'include the entire url if it is a url';


--
-- TOC entry 220 (class 1259 OID 112110)
-- Name: EMLUnitDictionary; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLUnitDictionary" (
    id character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    custom boolean DEFAULT false NOT NULL,
    "unitType" character varying(50),
    abbreviation character varying(50),
    "multiplierToSI" character varying(50),
    "parentSI" character varying(50),
    "constantToSI" character varying(50),
    description character varying(1000)
);


ALTER TABLE lter_metabase."EMLUnitDictionary" OWNER TO %db_owner%;

--
-- TOC entry 221 (class 1259 OID 112117)
-- Name: EMLUnitTypes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLUnitTypes" (
    id character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    dimension_name character varying(50) NOT NULL,
    dimension_power integer
);


ALTER TABLE lter_metabase."EMLUnitTypes" OWNER TO %db_owner%;

--
-- TOC entry 222 (class 1259 OID 112120)
-- Name: ListCodes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListCodes" (
    "CodeID" character varying(20) NOT NULL,
    "Code" character varying(200) NOT NULL,
    "CodeExplanation" character varying(1024) NOT NULL
);


ALTER TABLE lter_metabase."ListCodes" OWNER TO %db_owner%;

--
-- TOC entry 223 (class 1259 OID 112126)
-- Name: ListKeywordThesauri; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListKeywordThesauri" (
    "ThesaurusID" character varying(50) NOT NULL,
    "ThesaurusLabel" character varying(250),
    "ThesaurusUrl" character varying(250),
    "UseInMetadata" boolean DEFAULT true NOT NULL,
    "ThesaurusSortOrder" integer
);


ALTER TABLE lter_metabase."ListKeywordThesauri" OWNER TO %db_owner%;

--
-- TOC entry 224 (class 1259 OID 112133)
-- Name: ListKeywords; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListKeywords" (
    "Keyword" character varying(50) NOT NULL,
    "ThesaurusID" character varying(50) NOT NULL,
    "KeywordType" character varying(20) DEFAULT 'theme'::character varying NOT NULL
);


ALTER TABLE lter_metabase."ListKeywords" OWNER TO %db_owner%;

--
-- TOC entry 225 (class 1259 OID 112137)
-- Name: ListMethodInstruments; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListMethodInstruments" (
    "InstrumentID" integer NOT NULL,
    "Description" character varying(5000) NOT NULL
);


ALTER TABLE lter_metabase."ListMethodInstruments" OWNER TO %db_owner%;

--
-- TOC entry 226 (class 1259 OID 112143)
-- Name: ListMethodProtocols; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListMethodProtocols" (
    "ProtocolID" integer NOT NULL,
    "NameID" character varying(50),
    "Title" character varying(300),
    "URL" character varying(1024) NOT NULL
);


ALTER TABLE lter_metabase."ListMethodProtocols" OWNER TO %db_owner%;

--
-- TOC entry 227 (class 1259 OID 112149)
-- Name: ListMethodSoftware; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListMethodSoftware" (
    "SoftwareID" integer NOT NULL,
    "Title" character varying(1024),
    "AuthorSurname" character varying(100),
    "Description" character varying(5000),
    "Version" character varying(32),
    "URL" character varying(1024)
);


ALTER TABLE lter_metabase."ListMethodSoftware" OWNER TO %db_owner%;

--
-- TOC entry 228 (class 1259 OID 112155)
-- Name: ListPeople; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListPeople" (
    "NameID" character varying(20) NOT NULL,
    "GivenName" character varying(30) NOT NULL,
    "MiddleName" character varying(30),
    "SurName" character varying(50) NOT NULL,
    "Organization" character varying(50),
    "Address1" character varying(100),
    "Address2" character varying(100),
    "Address3" character varying(100),
    "City" character varying(30),
    "State" character varying(20),
    "Country" character varying(30),
    "ZipCode" character varying(20),
    "Email" character varying(50),
    "WebPage" character varying(100),
    "Phone" character varying(50),
    dbupdatetime timestamp without time zone,
    "Position" character varying(100)
);


ALTER TABLE lter_metabase."ListPeople" OWNER TO %db_owner%;

--
-- TOC entry 229 (class 1259 OID 112161)
-- Name: ListPeopleID; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListPeopleID" (
    "NameID" character varying(20) NOT NULL,
    "IdentificationID" smallint NOT NULL,
    "IdentificationSystem" character varying(30),
    "IdentificationURL" character varying(200)
);


ALTER TABLE lter_metabase."ListPeopleID" OWNER TO %db_owner%;

--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN "ListPeopleID"."IdentificationSystem"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationSystem" IS 'ID System, e.g. ORCID or LTER LDAP.';


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN "ListPeopleID"."IdentificationURL"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationURL" IS 'Full URLs under the ID system. E.g: "https://orcid.org/0000-0002-1693-8322"';


--
-- TOC entry 280 (class 1259 OID 112864)
-- Name: ListPublications; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListPublications" (
    "PublicationID" integer NOT NULL,
    "Bibtex" character varying(2000)
);


ALTER TABLE lter_metabase."ListPublications" OWNER TO %db_owner%;

--
-- TOC entry 275 (class 1259 OID 112787)
-- Name: ListSemanticAnnotationTerms; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListSemanticAnnotationTerms" (
    "TermID" character varying(40) NOT NULL,
    "TermLabel" character varying(200),
    "TermURI" text,
    CONSTRAINT ck_semantic_annotation_no_lead_trail_whitespace CHECK (((("TermID")::text ~~ btrim(("TermID")::text)) AND (("TermLabel")::text ~~ btrim(("TermLabel")::text)) AND ("TermURI" ~~ btrim("TermURI"))))
);


ALTER TABLE lter_metabase."ListSemanticAnnotationTerms" OWNER TO %db_owner%;

--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 275
-- Name: CONSTRAINT ck_semantic_annotation_no_lead_trail_whitespace ON "ListSemanticAnnotationTerms"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON CONSTRAINT ck_semantic_annotation_no_lead_trail_whitespace ON lter_metabase."ListSemanticAnnotationTerms" IS 'Ensure no extra characters get entered as is common when pasting from ECSO.';


--
-- TOC entry 230 (class 1259 OID 112164)
-- Name: ListSites; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListSites" (
    "SiteID" character varying(50) NOT NULL,
    "SiteType" character varying(10) NOT NULL,
    "SiteName" character varying(100) NOT NULL,
    "SiteLocation" character varying(100) NOT NULL,
    "SiteDescription" character varying(1000),
    "Ownership" character varying(100),
    "ShapeType" character varying(20) NOT NULL,
    "CenterLon" double precision,
    "CenterLat" double precision,
    "WBoundLon" double precision,
    "EBoundLon" double precision,
    "SBoundLat" double precision,
    "NBoundLat" double precision,
    "AltitudeMin" double precision,
    "AltitudeMax" double precision,
    "AltitudeUnit" character varying(100),
    CONSTRAINT "CK_SiteRegister_ShapeType" CHECK ((("ShapeType")::text = ANY (ARRAY[('point'::character varying)::text, ('rectangle'::character varying)::text, ('polygon'::character varying)::text, ('polyline'::character varying)::text, ('vector'::character varying)::text])))
);


ALTER TABLE lter_metabase."ListSites" OWNER TO %db_owner%;

--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN "ListSites"."SiteType"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListSites"."SiteType" IS 'does not go into EML. this is meant to help LTER sites sort and organize their sampling sites. For example, SBC had "intertidal," "beach," "reef" site types, etc.';


--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN "ListSites"."SiteName"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListSites"."SiteName" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN "ListSites"."SiteLocation"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListSites"."SiteLocation" IS 'does not go into EML. this is meant to help LTER sites organize their sites.';


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN "ListSites"."SiteDescription"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListSites"."SiteDescription" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN "ListSites"."ShapeType"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListSites"."ShapeType" IS 'one of: point, rectangle, polygon, polyline, vector';


--
-- TOC entry 231 (class 1259 OID 112171)
-- Name: ListTaxa; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListTaxa" (
    "TaxonID" character varying(50) NOT NULL,
    "TaxonomicProviderID" character varying(50) NOT NULL,
    "TaxonRankName" character varying(50),
    "TaxonRankValue" character varying(200) NOT NULL,
    "CommonName" character varying(200),
    "LocalID" character varying(50)
);


ALTER TABLE lter_metabase."ListTaxa" OWNER TO %db_owner%;

--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN "ListTaxa"."TaxonID"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."ListTaxa"."TaxonID" IS 'The taxon ID under the specified taxonomic system (provider).';


--
-- TOC entry 232 (class 1259 OID 112177)
-- Name: ListTaxonomicProviders; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ListTaxonomicProviders" (
    "ProviderID" character varying(20) NOT NULL,
    "ProviderName" character varying(100) NOT NULL,
    "ProviderURL" character varying(250)
);


ALTER TABLE lter_metabase."ListTaxonomicProviders" OWNER TO %db_owner%;

--
-- TOC entry 233 (class 1259 OID 112180)
-- Name: boilerplate; Type: TABLE; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE TABLE mb2eml_r.boilerplate (
    bp_setting character varying(20) NOT NULL,
    scope character varying(20) NOT NULL,
    system character varying(20) NOT NULL,
    access xml,
    distribution xml,
    publisher_nameid character varying(20),
    contact_nameid character varying(20) NOT NULL,
    metadata_provider_nameid character varying(20),
    project xml,
    intellectual_rights xml,
    licensed xml
);


ALTER TABLE mb2eml_r.boilerplate OWNER TO %db_owner%;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN boilerplate.intellectual_rights; Type: COMMENT; Schema: mb2eml_r; Owner: %db_owner%
--

COMMENT ON COLUMN mb2eml_r.boilerplate.intellectual_rights IS 'the old freeform text EML element';


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN boilerplate.licensed; Type: COMMENT; Schema: mb2eml_r; Owner: %db_owner%
--

COMMENT ON COLUMN mb2eml_r.boilerplate.licensed IS 'the new structured EML 2.2 element';


--
-- TOC entry 234 (class 1259 OID 112186)
-- Name: vw_custom_units; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_custom_units AS
 SELECT v."DataSetID" AS datasetid,
    v."Unit" AS id,
    u."unitType",
    u.abbreviation,
    u."multiplierToSI",
    u."parentSI",
    u."constantToSI",
    u.description
   FROM (lter_metabase."DataSetAttributes" v
     JOIN lter_metabase."EMLUnitDictionary" u ON (((v."Unit")::text = (u.name)::text)))
  GROUP BY v."DataSetID", v."Unit", u."unitType", u.abbreviation, u."multiplierToSI", u."parentSI", u."constantToSI", u.description
  ORDER BY v."DataSetID";


ALTER TABLE mb2eml_r.vw_custom_units OWNER TO %db_owner%;

--
-- TOC entry 235 (class 1259 OID 112191)
-- Name: vw_eml_associatedparty; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_associatedparty AS
 SELECT d."DataSetID" AS datasetid,
    d."AuthorshipOrder" AS authorshiporder,
    d."AuthorshipRole" AS authorshiprole,
    d."NameID" AS nameid,
    (p."GivenName")::text AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    p."Organization" AS organization,
    p."Address1" AS address1,
    p."Address2" AS address2,
    p."Address3" AS address3,
    p."City" AS city,
    p."State" AS state,
    p."Country" AS country,
    p."ZipCode" AS zipcode,
    p."Phone" AS phone1,
    p."Email" AS email,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Position" AS "position",
    p."WebPage" AS online_url
   FROM ((lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."ListPeople" p ON (((d."NameID")::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."ListPeopleID" i ON (((d."NameID")::text = (i."NameID")::text)))
  ORDER BY d."DataSetID", d."AuthorshipOrder";


ALTER TABLE mb2eml_r.vw_eml_associatedparty OWNER TO %db_owner%;

--
-- TOC entry 236 (class 1259 OID 112196)
-- Name: vw_eml_attributecodedefinition; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_attributecodedefinition AS
 SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    l."Code" AS code,
    l."CodeExplanation" AS definition
   FROM (lter_metabase."DataSetAttributeEnumeration" d
     LEFT JOIN lter_metabase."ListCodes" l ON (((d."CodeID")::text = (l."CodeID")::text)))
  ORDER BY d."DataSetID", d."EntitySortOrder";


ALTER TABLE mb2eml_r.vw_eml_attributecodedefinition OWNER TO %db_owner%;

--
-- TOC entry 237 (class 1259 OID 112200)
-- Name: vw_eml_attributes; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_attributes AS
 SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    d."AttributeLabel" AS "attributeLabel",
    d."Description" AS "attributeDefinition",
        CASE
            WHEN ((d."MeasurementScaleDomainID")::text ~~ 'nominal%'::text) THEN 'nominal'::character varying
            WHEN ((d."MeasurementScaleDomainID")::text ~~ 'ordinal%'::text) THEN 'ordinal'::character varying
            ELSE d."MeasurementScaleDomainID"
        END AS "measurementScale",
        CASE
            WHEN ((d."MeasurementScaleDomainID")::text ~~ '%Enum'::text) THEN 'enumeratedDomain'::text
            WHEN ((d."MeasurementScaleDomainID")::text ~~ '%Text'::text) THEN 'textDomain'::text
            WHEN ((d."MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])) THEN 'numericDomain'::text
            WHEN ((d."MeasurementScaleDomainID")::text = 'dateTime'::text) THEN 'dateTimeDomain'::text
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

--
-- TOC entry 238 (class 1259 OID 112205)
-- Name: vw_eml_boilerplate; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_boilerplate AS
 SELECT boilerplate.bp_setting,
    boilerplate.scope,
    boilerplate.system,
    boilerplate.access,
    boilerplate.distribution,
    boilerplate.project,
    boilerplate.intellectual_rights,
    boilerplate.licensed
   FROM mb2eml_r.boilerplate;


ALTER TABLE mb2eml_r.vw_eml_boilerplate OWNER TO %db_owner%;

--
-- TOC entry 239 (class 1259 OID 112209)
-- Name: vw_eml_bp_people; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_bp_people AS
 SELECT b.bp_setting,
    'publisher'::text AS bp_role,
    p."GivenName" AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    p."Organization" AS organization,
    p."Address1" AS address1,
    p."Address2" AS address2,
    p."Address3" AS address3,
    p."City" AS city,
    p."State" AS state,
    p."Country" AS country,
    p."ZipCode" AS zipcode,
    p."Phone" AS phone1,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Email" AS email,
    p."Position" AS "position",
    p."WebPage" AS online_url
   FROM ((lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON (((b.publisher_nameid)::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."ListPeopleID" i ON (((i."NameID")::text = (p."NameID")::text)))
UNION
 SELECT b.bp_setting,
    'metadata_provider'::text AS bp_role,
    p."GivenName" AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    p."Organization" AS organization,
    p."Address1" AS address1,
    p."Address2" AS address2,
    p."Address3" AS address3,
    p."City" AS city,
    p."State" AS state,
    p."Country" AS country,
    p."ZipCode" AS zipcode,
    p."Phone" AS phone1,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Email" AS email,
    p."Position" AS "position",
    p."WebPage" AS online_url
   FROM ((lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON (((b.metadata_provider_nameid)::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."ListPeopleID" i ON (((i."NameID")::text = (p."NameID")::text)))
UNION
 SELECT b.bp_setting,
    'contact'::text AS bp_role,
    p."GivenName" AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    p."Organization" AS organization,
    p."Address1" AS address1,
    p."Address2" AS address2,
    p."Address3" AS address3,
    p."City" AS city,
    p."State" AS state,
    p."Country" AS country,
    p."ZipCode" AS zipcode,
    p."Phone" AS phone1,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Email" AS email,
    p."Position" AS "position",
    p."WebPage" AS online_url
   FROM ((lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON (((b.contact_nameid)::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."ListPeopleID" i ON (((i."NameID")::text = (p."NameID")::text)));


ALTER TABLE mb2eml_r.vw_eml_bp_people OWNER TO %db_owner%;

--
-- TOC entry 240 (class 1259 OID 112214)
-- Name: maintenance_changehistory; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.maintenance_changehistory (
    "DataSetID" integer NOT NULL,
    revision_number integer NOT NULL,
    revision_notes character varying(1024),
    change_scope character varying(50),
    change_date date NOT NULL,
    "NameID" character varying(20) NOT NULL
);


ALTER TABLE pkg_mgmt.maintenance_changehistory OWNER TO %db_owner%;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN maintenance_changehistory.change_scope; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.maintenance_changehistory.change_scope IS 'Goes into/dataset/maintenance/changeHistory/changeScope/. E.g.: data, metadata, or data and metadata.';


--
-- TOC entry 241 (class 1259 OID 112220)
-- Name: vw_eml_changehistory; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_changehistory AS
 SELECT m."DataSetID" AS datasetid,
    m.revision_number,
    m.revision_notes,
    m.change_scope,
    m.change_date,
    (p."GivenName")::text AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname
   FROM (pkg_mgmt.maintenance_changehistory m
     LEFT JOIN lter_metabase."ListPeople" p ON (((m."NameID")::text = (p."NameID")::text)))
  ORDER BY m."DataSetID", m.revision_number;


ALTER TABLE mb2eml_r.vw_eml_changehistory OWNER TO %db_owner%;

--
-- TOC entry 242 (class 1259 OID 112225)
-- Name: vw_eml_creator; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_creator AS
 SELECT d."DataSetID" AS datasetid,
    d."AuthorshipOrder" AS authorshiporder,
    d."AuthorshipRole" AS authorshiprole,
    d."NameID" AS nameid,
    (p."GivenName")::text AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    p."Organization" AS organization,
    p."Address1" AS address1,
    p."Address2" AS address2,
    p."Address3" AS address3,
    p."City" AS city,
    p."State" AS state,
    p."Country" AS country,
    p."ZipCode" AS zipcode,
    p."Phone" AS phone1,
    p."Email" AS email,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Position" AS "position",
    p."WebPage" AS online_url
   FROM ((lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."ListPeople" p ON (((d."NameID")::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."ListPeopleID" i ON (((d."NameID")::text = (i."NameID")::text)))
  WHERE ((d."AuthorshipRole")::text = 'creator'::text)
  ORDER BY d."DataSetID", d."AuthorshipOrder";


ALTER TABLE mb2eml_r.vw_eml_creator OWNER TO %db_owner%;

--
-- TOC entry 243 (class 1259 OID 112230)
-- Name: vw_eml_dataset; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_dataset AS
 SELECT d."DataSetID" AS datasetid,
    d."Revision" AS revision_number,
    d."Title" AS title,
    d."AbstractType" AS abstract_type,
    d."Abstract" AS abstract,
    d."ShortName" AS shortname,
    d."UpdateFrequency" AS maintenanceupdatefrequency,
    d."MaintenanceDescription" AS maintenance_description,
    d."PubDate" AS pubdate,
    d."BoilerplateSetting" AS bp_setting
   FROM lter_metabase."DataSet" d
  ORDER BY d."DataSetID";


ALTER TABLE mb2eml_r.vw_eml_dataset OWNER TO %db_owner%;

--
-- TOC entry 284 (class 1259 OID 112906)
-- Name: vw_eml_entities; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_entities AS
 SELECT e."DataSetID" AS datasetid,
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
    k."CharacterEncoding" AS encoding,
    e."FileSize" AS filesize,
    e."FileSizeUnits" AS filesize_units,
    e."Checksum" AS checksum
   FROM (lter_metabase."DataSetEntities" e
     LEFT JOIN lter_metabase."EMLFileTypes" k ON (((e."FileType")::text = (k."FileType")::text)))
  ORDER BY e."DataSetID", e."EntitySortOrder";


ALTER TABLE mb2eml_r.vw_eml_entities OWNER TO %db_owner%;

--
-- TOC entry 244 (class 1259 OID 112239)
-- Name: vw_eml_geographiccoverage; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_geographiccoverage AS
 SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."GeoCoverageSortOrder" AS geocoverage_sort_order,
    d."SiteID" AS id,
    ((s."SiteName")::text || COALESCE((': '::text || (s."SiteDescription")::text), ''::text)) AS geographicdescription,
    s."NBoundLat" AS northboundingcoordinate,
    s."SBoundLat" AS southboundingcoordinate,
    s."EBoundLon" AS eastboundingcoordinate,
    s."WBoundLon" AS westboundingcoordinate,
    s."AltitudeMin" AS altitudeminimum,
    s."AltitudeMax" AS altitudemaximum,
    s."AltitudeUnit" AS altitudeunits
   FROM (lter_metabase."DataSetSites" d
     LEFT JOIN lter_metabase."ListSites" s ON (((d."SiteID")::text = (s."SiteID")::text)))
  ORDER BY d."DataSetID", d."GeoCoverageSortOrder", d."SiteID";


ALTER TABLE mb2eml_r.vw_eml_geographiccoverage OWNER TO %db_owner%;

--
-- TOC entry 245 (class 1259 OID 112244)
-- Name: vw_eml_instruments; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_instruments AS
 SELECT m."DataSetID" AS datasetid,
    m."MethodStepID" AS methodstep_id,
    l."Description" AS instrument
   FROM (lter_metabase."DataSetMethodInstruments" m
     JOIN lter_metabase."ListMethodInstruments" l ON ((m."InstrumentID" = l."InstrumentID")));


ALTER TABLE mb2eml_r.vw_eml_instruments OWNER TO %db_owner%;

--
-- TOC entry 246 (class 1259 OID 112248)
-- Name: vw_eml_keyword; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_keyword AS
 SELECT d."DataSetID" AS datasetid,
    t."ThesaurusSortOrder" AS thesaurus_sort_order,
    d."Keyword" AS keyword,
    COALESCE(t."ThesaurusLabel", 'none'::character varying) AS keyword_thesaurus,
    k."KeywordType" AS keywordtype
   FROM ((lter_metabase."DataSetKeywords" d
     LEFT JOIN lter_metabase."ListKeywords" k ON (((d."Keyword")::text = (k."Keyword")::text)))
     JOIN lter_metabase."ListKeywordThesauri" t ON (((k."ThesaurusID")::text = (t."ThesaurusID")::text)))
  GROUP BY d."DataSetID", t."ThesaurusSortOrder", d."Keyword", t."ThesaurusLabel", k."KeywordType"
  ORDER BY d."DataSetID", t."ThesaurusSortOrder", d."Keyword";


ALTER TABLE mb2eml_r.vw_eml_keyword OWNER TO %db_owner%;

--
-- TOC entry 247 (class 1259 OID 112253)
-- Name: vw_eml_methodstep_description; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_methodstep_description AS
 SELECT m."DataSetID" AS datasetid,
    m."MethodStepID" AS methodstep_id,
    m."Description" AS description,
    m."DescriptionType" AS description_type
   FROM lter_metabase."DataSetMethod" m;


ALTER TABLE mb2eml_r.vw_eml_methodstep_description OWNER TO %db_owner%;

--
-- TOC entry 248 (class 1259 OID 112257)
-- Name: vw_eml_missingcodes; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_missingcodes AS
 SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    e."Code" AS code,
    e."CodeExplanation" AS definition
   FROM (lter_metabase."DataSetAttributeMissingCodes" d
     JOIN lter_metabase."ListCodes" e ON (((d."MissingValueCodeID")::text = (e."CodeID")::text)))
  ORDER BY d."DataSetID";


ALTER TABLE mb2eml_r.vw_eml_missingcodes OWNER TO %db_owner%;

--
-- TOC entry 249 (class 1259 OID 112261)
-- Name: vw_eml_protocols; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_protocols AS
 SELECT m."DataSetID" AS datasetid,
    m."MethodStepID" AS methodstep_id,
    p."GivenName" AS givenname,
    p."MiddleName" AS givenname2,
    p."SurName" AS surname,
    l."Title" AS title,
    l."URL" AS url
   FROM ((lter_metabase."ListMethodProtocols" l
     LEFT JOIN lter_metabase."DataSetMethodProtocols" m ON ((m."ProtocolID" = l."ProtocolID")))
     LEFT JOIN lter_metabase."ListPeople" p ON (((l."NameID")::text = (p."NameID")::text)));


ALTER TABLE mb2eml_r.vw_eml_protocols OWNER TO %db_owner%;

--
-- TOC entry 250 (class 1259 OID 112266)
-- Name: vw_eml_provenance; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_provenance AS
 SELECT m."DataSetID" AS datasetid,
    m."MethodStepID" AS methodstep_id,
    m."SourcePackageID" AS "data_source_packageId"
   FROM lter_metabase."DataSetMethodProvenance" m;


ALTER TABLE mb2eml_r.vw_eml_provenance OWNER TO %db_owner%;

--
-- TOC entry 282 (class 1259 OID 112888)
-- Name: vw_eml_publications; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_publications AS
 SELECT d."DataSetID" AS datasetid,
    d."Revision" AS revision,
    l."Bibtex" AS bibtex,
    d."RelationshipType" AS relationship
   FROM (lter_metabase."DataSetPublications" d
     LEFT JOIN lter_metabase."ListPublications" l ON ((d."PublicationID" = l."PublicationID")))
  ORDER BY d."DataSetID";


ALTER TABLE mb2eml_r.vw_eml_publications OWNER TO %db_owner%;

--
-- TOC entry 279 (class 1259 OID 112853)
-- Name: vw_eml_semantic_annotation; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_semantic_annotation AS
 SELECT a."DataSetID" AS datasetid,
    a."EntitySortOrder" AS entity_position,
    d."ColumnName" AS "attributeName",
    a."ColumnPosition" AS column_position,
    o."ObjectPropertyLabel" AS propertyuri_label,
    o."ObjectPropertyURI" AS propertyuri,
    t."TermLabel" AS valueuri_label,
    t."TermURI" AS valueuri
   FROM (((lter_metabase."DataSetAttributeAnnotation" a
     JOIN lter_metabase."DataSetAttributes" d ON (((d."DataSetID" = a."DataSetID") AND (d."EntitySortOrder" = a."EntitySortOrder") AND (d."ColumnPosition" = a."ColumnPosition"))))
     JOIN lter_metabase."ListSemanticAnnotationTerms" t ON (((t."TermID")::text = (a."TermID")::text)))
     JOIN lter_metabase."EMLObjectProperties" o ON (((o."ObjectPropertyID")::text = (a."ObjectPropertyID")::text)))
UNION
 SELECT d."DataSetID" AS datasetid,
    0 AS entity_position,
    '0'::character varying AS "attributeName",
    0 AS column_position,
    o."ObjectPropertyLabel" AS propertyuri_label,
    o."ObjectPropertyURI" AS propertyuri,
    t."TermLabel" AS valueuri_label,
    t."TermURI" AS valueuri
   FROM ((lter_metabase."DataSetAnnotation" d
     JOIN lter_metabase."ListSemanticAnnotationTerms" t ON (((t."TermID")::text = (d."TermID")::text)))
     JOIN lter_metabase."EMLObjectProperties" o ON (((o."ObjectPropertyID")::text = (d."ObjectPropertyID")::text)))
  ORDER BY 1, 2, 4;


ALTER TABLE mb2eml_r.vw_eml_semantic_annotation OWNER TO %db_owner%;

--
-- TOC entry 251 (class 1259 OID 112270)
-- Name: vw_eml_software; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_software AS
 SELECT m."DataSetID" AS datasetid,
    m."MethodStepID" AS methodstep_id,
    l."Title" AS title,
    l."AuthorSurname" AS "surName",
    l."Description" AS abstract,
    l."URL" AS url,
    l."Version" AS version
   FROM (lter_metabase."DataSetMethodSoftware" m
     JOIN lter_metabase."ListMethodSoftware" l ON ((m."SoftwareID" = l."SoftwareID")));


ALTER TABLE mb2eml_r.vw_eml_software OWNER TO %db_owner%;

--
-- TOC entry 283 (class 1259 OID 112892)
-- Name: vw_eml_taxonomy; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_taxonomy AS
 SELECT d."DataSetID" AS datasetid,
    d."TaxonID" AS taxonid,
    p."ProviderName" AS taxonid_provider,
    p."ProviderID" AS providerid,
    p."ProviderURL" AS providerurl,
    l."TaxonRankName" AS taxonrankname,
    l."TaxonRankValue" AS taxonrankvalue,
    l."CommonName" AS commonname
   FROM ((lter_metabase."DataSetTaxa" d
     JOIN lter_metabase."ListTaxa" l ON ((((d."TaxonID")::text = (l."TaxonID")::text) AND ((d."TaxonomicProviderID")::text = (l."TaxonomicProviderID")::text))))
     JOIN lter_metabase."ListTaxonomicProviders" p ON (((d."TaxonomicProviderID")::text = (p."ProviderID")::text)))
  ORDER BY d."DataSetID";


ALTER TABLE mb2eml_r.vw_eml_taxonomy OWNER TO %db_owner%;

--
-- TOC entry 252 (class 1259 OID 112279)
-- Name: vw_eml_temporalcoverage; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_temporalcoverage AS
 SELECT "DataSetTemporal"."DataSetID" AS datasetid,
    "DataSetTemporal"."EntitySortOrder" AS entity_position,
        CASE "DataSetTemporal"."UseOnlyYear"
            WHEN true THEN to_char(("DataSetTemporal"."BeginDate")::timestamp with time zone, 'YYYY'::text)
            ELSE to_char(("DataSetTemporal"."BeginDate")::timestamp with time zone, 'YYYY-MM-DD'::text)
        END AS begindate,
        CASE "DataSetTemporal"."UseOnlyYear"
            WHEN true THEN to_char(("DataSetTemporal"."EndDate")::timestamp with time zone, 'YYYY'::text)
            ELSE to_char(("DataSetTemporal"."EndDate")::timestamp with time zone, 'YYYY-MM-DD'::text)
        END AS enddate
   FROM lter_metabase."DataSetTemporal"
  ORDER BY "DataSetTemporal"."DataSetID", "DataSetTemporal"."EntitySortOrder";


ALTER TABLE mb2eml_r.vw_eml_temporalcoverage OWNER TO %db_owner%;

--
-- TOC entry 253 (class 1259 OID 112283)
-- Name: cv_cra; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_cra (
    cra_id character varying(10) NOT NULL,
    cra_name character varying(100) NOT NULL
);


ALTER TABLE pkg_mgmt.cv_cra OWNER TO %db_owner%;

--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE cv_cra; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.cv_cra IS 'core study area';


--
-- TOC entry 254 (class 1259 OID 112286)
-- Name: cv_maint_freq; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_maint_freq (
    eml_maintenance_frequency character varying(50) NOT NULL
);


ALTER TABLE pkg_mgmt.cv_maint_freq OWNER TO %db_owner%;

--
-- TOC entry 255 (class 1259 OID 112289)
-- Name: cv_mgmt_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_mgmt_type (
    mgmt_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_mgmt_type OWNER TO %db_owner%;

--
-- TOC entry 256 (class 1259 OID 112295)
-- Name: cv_network_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_network_type (
    network_type character varying(3) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_network_type OWNER TO %db_owner%;

--
-- TOC entry 257 (class 1259 OID 112301)
-- Name: cv_spatial_extent; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatial_extent (
    spatial_extent character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatial_extent OWNER TO %db_owner%;

--
-- TOC entry 258 (class 1259 OID 112307)
-- Name: cv_spatial_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatial_type (
    spatial_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatial_type OWNER TO %db_owner%;

--
-- TOC entry 259 (class 1259 OID 112313)
-- Name: cv_spatio_temporal; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatio_temporal (
    spatiotemporal character(4) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatio_temporal OWNER TO %db_owner%;

--
-- TOC entry 260 (class 1259 OID 112319)
-- Name: cv_status; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_status (
    status character varying(20) NOT NULL
);


ALTER TABLE pkg_mgmt.cv_status OWNER TO %db_owner%;

--
-- TOC entry 261 (class 1259 OID 112322)
-- Name: cv_temporal_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_temporal_type (
    temporal_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_temporal_type OWNER TO %db_owner%;

--
-- TOC entry 262 (class 1259 OID 112328)
-- Name: pkg_core_area; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.pkg_core_area (
    "DataSetID" integer NOT NULL,
    "Core_area" character varying(10) NOT NULL
);


ALTER TABLE pkg_mgmt.pkg_core_area OWNER TO %db_owner%;

--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE pkg_core_area; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_core_area IS 'core study area';


--
-- TOC entry 263 (class 1259 OID 112331)
-- Name: pkg_sort; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.pkg_sort (
    "DataSetID" integer NOT NULL,
    network_type character varying(3),
    is_signature boolean,
    is_core boolean,
    temporal_type character varying(22),
    spatial_extent character varying(18),
    spatiotemporal character(4),
    is_thesis boolean,
    is_reference boolean,
    is_exogenous boolean,
    spatial_type character varying(32),
    management_type character varying(64) DEFAULT 'non_templated'::character varying,
    in_pasta boolean,
    dbupdatetime timestamp without time zone
);


ALTER TABLE pkg_mgmt.pkg_sort OWNER TO %db_owner%;

--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE pkg_sort; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_sort IS 'pkg_state is wordy and pkg_sort is terse. Instead of one really wide table.  Just easier to edit.';


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN pkg_sort.network_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.network_type IS 'Two values have been defined by the LTER network: Type I and Type II
if neither applies, NULL.';


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN pkg_sort.is_signature; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.is_signature IS 'defined at discretion of site or PI';


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN pkg_sort.spatial_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.spatial_type IS 'choices: multi-site, one site of one, one place of a site series, non-spatial.';


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN pkg_sort.management_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.management_type IS 'template vs non_templated. The way the metadata is generated.';


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN pkg_sort.in_pasta; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.in_pasta IS 'This package ID is in production pasta. No implications re access restrictions. Merely passing evaluate does not mean in_pasta is true. column synth_readiness is for that property.';


--
-- TOC entry 264 (class 1259 OID 112335)
-- Name: pkg_state; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.pkg_state (
    "DataSetID" integer NOT NULL,
    dataset_archive_id character varying(21),
    rev integer,
    nickname character varying(64),
    data_receipt_date date,
    status character varying(64),
    synth_readiness character varying(15),
    staging_dir character varying(1024),
    eml_draft_path character varying(128),
    notes text,
    pub_notes text,
    who2bug character varying(64),
    dir_internal_final character varying(256),
    dbupdatetime timestamp without time zone,
    update_date_catalog date
);


ALTER TABLE pkg_mgmt.pkg_state OWNER TO %db_owner%;

--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE pkg_state; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_state IS 'aka wordy';


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.dataset_archive_id; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dataset_archive_id IS 'ie knb-lter-mcr.1234 or if not assigned a real id yet then what';


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.rev; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.rev IS 'revision is needed for showDraft. By definition, rev for draft0 is 0. Rev for cataloged make null so latest rev is shown.';


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.nickname; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.nickname IS 'ie fish_survey or flume or par. This is NOT the eml shortName except perhaps by coincidence.  shortName is stored elsewhere. This is not the staging directory except by coincidence.';


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.status; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.status IS 'anticipated, draft0, cataloged, backlog or anticipated, draft then back to cataloged';


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.synth_readiness; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.synth_readiness IS 'One of metadata_only, download, integration, annotated.  These are levels of readiness for synthesis. Each builds on the lower levels.';


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.staging_dir; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.staging_dir IS 'The subdirectory where the IMs work on data files after receiving in final_dir and prior to posting in external_dir. Root portion of path is a different constant for MCR than SBC.';


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.eml_draft_path; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.eml_draft_path IS 'For most pkgs this is merely ''mcr/''. For RAPID datasets this is ''mcr/RAPID/''. For drafts split out into a named dir this might be ''mcr/core/optical/EML/''';


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.notes; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.notes IS 'what needs doing. what the holdup is. issues.';


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.pub_notes; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.pub_notes IS 'Reason for being in this state, ie why it is metadata-only currently or Type II.  Such as grad student data or pending publication. May apply to status, network_type, synthesis_readiness.';


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.who2bug; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.who2bug IS 'often not the creator rather the tech or whoever we need to pester';


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.dir_internal_final; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dir_internal_final IS 'directory where submitted so-called final data is staged for inspection.  where to look for new data.';


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.dbupdatetime; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dbupdatetime IS 'automatically updates itself.';


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN pkg_state.update_date_catalog; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.update_date_catalog IS 'Date package last updated in catalog (same as pathquery updatedate)';


--
-- TOC entry 265 (class 1259 OID 112341)
-- Name: version_tracker_metabase; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.version_tracker_metabase (
    major_version integer NOT NULL,
    minor_version integer NOT NULL,
    patch integer NOT NULL,
    date_installed timestamp without time zone,
    comment text
);


ALTER TABLE pkg_mgmt.version_tracker_metabase OWNER TO %db_owner%;

--
-- TOC entry 266 (class 1259 OID 112347)
-- Name: vw_backlog; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_backlog AS
 SELECT s.dataset_archive_id AS dataset_id,
        CASE
            WHEN ((s.status)::text = 'draft0'::text) THEN 0
            ELSE s.rev
        END AS rev,
    s.eml_draft_path,
    s.nickname,
    s.data_receipt_date AS "data received",
    replace((s.status)::text, '_'::text, ' '::text) AS status,
    o.network_type AS "network type",
    replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type",
    t."Title" AS title,
        CASE
            WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying
            ELSE s.who2bug
        END AS "who to bug",
    s.update_date_catalog AS "catalog last updated",
    to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated"
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" t ON (((s."DataSetID")::text = (t."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  WHERE ((s.data_receipt_date > s.update_date_catalog) OR ((s.status)::text ~~ 'backlog'::text))
  ORDER BY s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_backlog OWNER TO %db_owner%;

--
-- TOC entry 267 (class 1259 OID 112352)
-- Name: vw_cataloged; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_cataloged AS
 SELECT pkg_state.dataset_archive_id AS dataset_id,
    pkg_state.nickname,
    pkg_sort.temporal_type,
    pkg_sort.management_type,
    pkg_sort.network_type,
    pkg_state.update_date_catalog,
    pkg_state.notes
   FROM (pkg_mgmt.pkg_state
     JOIN pkg_mgmt.pkg_sort ON (((pkg_state."DataSetID")::text = (pkg_sort."DataSetID")::text)))
  WHERE ((pkg_state.status)::text = 'cataloged'::text)
  ORDER BY pkg_sort.temporal_type, pkg_state.nickname;


ALTER TABLE pkg_mgmt.vw_cataloged OWNER TO %db_owner%;

--
-- TOC entry 268 (class 1259 OID 112357)
-- Name: vw_draft_anticipated; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_draft_anticipated AS
 SELECT pkg_state.dataset_archive_id AS dataset_id,
    pkg_state.nickname,
    pkg_sort.temporal_type,
    pkg_sort.management_type,
    pkg_sort.network_type,
    pkg_state.status,
    pkg_state.notes
   FROM (pkg_mgmt.pkg_state
     JOIN pkg_mgmt.pkg_sort ON (((pkg_state."DataSetID")::text = (pkg_sort."DataSetID")::text)))
  WHERE (((pkg_state.status)::text = 'draft0'::text) OR ((pkg_state.status)::text = 'anticipated'::text))
  ORDER BY pkg_state.status DESC, pkg_sort.temporal_type, pkg_state.nickname;


ALTER TABLE pkg_mgmt.vw_draft_anticipated OWNER TO %db_owner%;

--
-- TOC entry 269 (class 1259 OID 112362)
-- Name: vw_drafts_bak; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_drafts_bak AS
 SELECT s.dataset_archive_id AS dataset_id,
        CASE
            WHEN ((s.status)::text = 'draft0'::text) THEN 0
            ELSE s.rev
        END AS rev,
    s.eml_draft_path,
    s.nickname,
    s.data_receipt_date AS "data received",
    replace((s.status)::text, '_'::text, ' '::text) AS status,
    o.network_type AS "network type",
    replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type",
    m."Title" AS title,
        CASE
            WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying
            ELSE s.who2bug
        END AS "who to bug",
    s.update_date_catalog AS "catalog last updated",
    to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated"
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  WHERE ((s.data_receipt_date > s.update_date_catalog) OR ((s.status)::text ~~ 'backlog'::text) OR ((s.status)::text ~~ 'draft%'::text))
  ORDER BY s.eml_draft_path, s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_drafts_bak OWNER TO %db_owner%;

--
-- TOC entry 270 (class 1259 OID 112367)
-- Name: vw_dump; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_dump AS
 SELECT s.dataset_archive_id AS dataset_id,
    s.rev,
    s.nickname,
    s.data_receipt_date,
    s.status,
    s.synth_readiness,
    s.staging_dir,
    s.eml_draft_path,
    s.notes,
    s.pub_notes,
    s.who2bug,
    s.dir_internal_final,
    s.dbupdatetime,
    s.update_date_catalog,
    o."DataSetID" AS dataset_id_,
    o.network_type,
    o.is_signature,
    o.is_core,
    o.temporal_type,
    o.spatial_extent,
    o.spatiotemporal,
    o.is_thesis,
    o.is_reference,
    o.is_exogenous,
    o.spatial_type,
    o.dbupdatetime AS dbupdatetime_,
    o.management_type
   FROM (pkg_mgmt.pkg_state s
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  ORDER BY (split_part(replace((s.dataset_archive_id)::text, 'X'::text, '9'::text), '.'::text, 2));


ALTER TABLE pkg_mgmt.vw_dump OWNER TO %db_owner%;

--
-- TOC entry 271 (class 1259 OID 112372)
-- Name: vw_im_plan; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_im_plan AS
 SELECT replace((o.temporal_type)::text, '_'::text, ' '::text) AS "Temporal type",
    ((split_part((s.dataset_archive_id)::text, '.'::text, 1) || '.'::text) || split_part((s.dataset_archive_id)::text, '.'::text, 2)) AS "Dataset ID",
    s.nickname AS "Short Name",
    o.network_type AS "Network type",
    o.management_type AS "Management type",
    to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "Catalog update date",
    s.notes AS "Notes",
    replace(replace((s.status)::text, '_'::text, ' '::text), 'draft'::text, 'revision pending'::text) AS status
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  WHERE ((s.status)::text = ANY (ARRAY[('cataloged'::character varying)::text, ('backlog'::character varying)::text, ('redesign_anticipated'::character varying)::text, ('draft'::character varying)::text]))
  ORDER BY o.temporal_type, s.nickname, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_im_plan OWNER TO %db_owner%;

--
-- TOC entry 272 (class 1259 OID 112377)
-- Name: vw_pub; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_pub AS
 SELECT s.dataset_archive_id AS dataset_id,
    o.network_type AS "network type",
    replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type",
    o.is_signature AS "is signature",
    o.is_core AS "is core",
    o.is_thesis AS "is thesis",
    o.is_reference AS "is reference",
    o.is_exogenous AS "is exogenous",
    m."Title" AS title,
    to_char((s.data_receipt_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "data last received",
    to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "catalog updated",
    replace(replace((s.status)::text, '_'::text, ' '::text), 'draft'::text, 'revision pending'::text) AS status,
    s.nickname
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  WHERE ((s.status)::text = ANY (ARRAY[('cataloged'::character varying)::text, ('backlog'::character varying)::text, ('redesign_anticipated'::character varying)::text, ('draft'::character varying)::text]))
  ORDER BY o.is_signature DESC, o.is_core DESC, o.temporal_type, o.is_thesis, o.is_reference, o.is_exogenous, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_pub OWNER TO %db_owner%;

--
-- TOC entry 273 (class 1259 OID 112382)
-- Name: vw_self; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_self AS
 SELECT s.dataset_archive_id AS dataset_id,
        CASE
            WHEN ((s.status)::text = 'draft0'::text) THEN 0
            ELSE s.rev
        END AS rev,
    s.eml_draft_path,
    s.nickname,
    s.data_receipt_date AS "data received",
    replace((s.status)::text, '_'::text, ' '::text) AS status,
    o.network_type AS "network type",
    replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type",
    m."Title" AS title,
        CASE
            WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying
            ELSE s.who2bug
        END AS "who to bug",
    s.update_date_catalog AS "catalog last updated",
    to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated"
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  ORDER BY s.status, s.who2bug, (split_part((s.dataset_archive_id)::text, '.'::text, 2));


ALTER TABLE pkg_mgmt.vw_self OWNER TO %db_owner%;

--
-- TOC entry 274 (class 1259 OID 112387)
-- Name: vw_temporal; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_temporal AS
 SELECT s.dataset_archive_id AS dataset_id,
        CASE
            WHEN ((s.status)::text = 'draft0'::text) THEN 0
            ELSE s.rev
        END AS rev,
    s.eml_draft_path,
    s.nickname,
    to_char((s.data_receipt_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "data received",
    to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "catalog updated",
    to_char((s.dbupdatetime)::timestamp with time zone, 'YYYY-MM-DD'::text) AS db_updated,
    replace((s.status)::text, '_'::text, ' '::text) AS status,
    o.network_type AS "network type",
    replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type",
    m."Title" AS title,
        CASE
            WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying
            ELSE s.who2bug
        END AS "who to bug"
   FROM ((pkg_mgmt.pkg_state s
     LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text)))
     LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text)))
  ORDER BY s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_temporal OWNER TO %db_owner%;

--
-- TOC entry 3434 (class 0 OID 112010)
-- Dependencies: 199
-- Data for Name: DataSet; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSet" ("DataSetID", "Revision", "Title", "PubDate", "Abstract", "ShortName", "UpdateFrequency", "MaintenanceDescription", "AbstractType", "BoilerplateSetting") FROM stdin;
99013	21	SBC LTER: TEST: Water temperature at the bottom	2019-08-07	abstract.99013.docx	Reef bottom water temperature	annually	Ongoing time series.	file	default
99021	11	SBC LTER: TEST: NPP dataset with 3 tables	2016-09-08	abstract.99021.docx	Beach wrack IV 2005-06	notPlanned	Completed timeseries. No future data updates anticpated.	file	default
99024	17	SBC LTER: TEST: kelp CHN	2019-01-15	abstract.99024.docx	Kelp - algal weights and CHN	annually	Ongoing time series. Data updates may be delayed by analysis.	file	default
99054	4	SBC LTER: TEST: Giant kelp canopy biomass from Landsat, 1982 - 2011	2014-01-14	abstract.99054.docx	Satellite kelp canopy biomass	notPlanned	Completed timeseries. No future data updates anticpated.	file	default
\.


--
-- TOC entry 3485 (class 0 OID 112809)
-- Dependencies: 277
-- Data for Name: DataSetAnnotation; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAnnotation" ("DataSetID", "TermID", "ObjectPropertyID") FROM stdin;
\.


--
-- TOC entry 3486 (class 0 OID 112832)
-- Dependencies: 278
-- Data for Name: DataSetAttributeAnnotation; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAttributeAnnotation" ("DataSetID", "EntitySortOrder", "ColumnPosition", "TermID", "ObjectPropertyID") FROM stdin;
\.


--
-- TOC entry 3435 (class 0 OID 112019)
-- Dependencies: 200
-- Data for Name: DataSetAttributeEnumeration; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAttributeEnumeration" ("DataSetID", "EntitySortOrder", "ColumnName", "CodeID") FROM stdin;
99013	1	site_code	enum.ABUR
99013	1	site_code	enum.AHND
99013	1	site_code	enum.AQUE14
99013	1	site_code	enum.BULL
99013	1	site_code	enum.CARP
99013	1	site_code	enum.GOLB
99013	1	site_code	enum.IVEE
99013	1	site_code	enum.MOHK
99013	1	site_code	enum.NAPL
99013	1	site_code	enum.SCDI
99013	1	site_code	enum.SCTW
99013	1	frondcondition	enum.growing
99013	1	frondcondition	enum.terminal
99021	1	Site	enum.ABUR
99021	1	Site	enum.MOHK
99021	1	Site	enum.AQUE15
99021	2	Site	enum.ABUR
99021	2	Site	enum.MOHK
99021	2	Site	enum.AQUE15
99021	3	Site	enum.ABUR
99021	3	Site	enum.MOHK
99021	3	Site	enum.AQUE15
99024	1	SITE	enum.ABUR
99024	1	SITE	enum.AQUE14
99024	1	SITE	enum.MOHK
99024	1	Replicate	enum.1
99024	1	Replicate	enum.2
\.


--
-- TOC entry 3436 (class 0 OID 112022)
-- Dependencies: 201
-- Data for Name: DataSetAttributeMissingCodes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAttributeMissingCodes" ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID") FROM stdin;
99021	3	date	1
99021	3	plant_ID	1
99021	3	Site	1
99021	2	date	1
99021	2	Site	1
99021	1	season	1
99021	1	Site	1
99021	1	year	1
99024	1	CN_RATIO	2
99024	1	N	2
99024	1	H	2
99024	1	C	2
99024	1	ANALYTICAL_WT	2
99024	1	DRY_WET	2
99024	1	DRY	2
99024	1	WET	2
99024	1	_N	2
99024	1	SITE	2
99024	1	DATE	2
99024	1	MONTH	2
99024	1	YEAR	2
99013	1	NOTES	2
99013	1	MeanDry	2
99013	1	Cover	2
99013	1	Density	2
99013	1	fake_col_w_taxonCov	2
99013	1	fake-temp	2
99013	1	fake_ord_text	2
99013	1	fake_xsect_code	2
99013	1	site_code	2
99013	1	serial	2
99013	1	temp_c	2
99013	1	time	2
99013	1	date	2
99021	3	new_fronds	3
99021	3	total_fronds	3
99021	2	SE_Plant_loss_rate	3
99021	2	SE_Plant_density	3
99021	2	SE_Frond_density	3
99021	2	SE_FSC_nitrogen	3
99021	2	SE_FSC_carbon	3
99021	2	SE_FSC_dry	3
99021	2	SE_FSC_wet	3
99021	2	Frond_loss_rate	3
99021	2	Plant_loss_rate	3
99021	2	Plant_density	3
99021	2	Frond_density	3
99021	2	FSC_nitrogen	3
99021	2	FSC_carbon	3
99021	2	FSC_dry	3
99021	2	FSC_wet	3
99021	1	SE_growth_rate_nitrogen	3
99021	1	SE_growth_rate_carbon	3
99021	1	SE_growth_rate_dry	3
99021	1	SE_growth_rate_wet	3
99021	1	SE_NPP_nitrogen	3
99021	1	SE_NPP_carbon	3
99021	1	SE_NPP_dry	3
99021	1	SE_NPP_wet	3
99021	1	Growth_rate_nitrogen	3
99021	1	Growth_rate_carbon	3
99021	1	Growth_rate_dry	3
99021	1	Growth_rate_wet	3
99021	1	NPP_nitrogen	3
99021	1	NPP_carbon	3
99021	2	SE_Frond_loss_rate	3
99021	1	NPP_dry	3
99021	1	NPP_wet	3
99054	101	biomass	4
\.


--
-- TOC entry 3437 (class 0 OID 112025)
-- Dependencies: 202
-- Data for Name: DataSetAttributes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAttributes" ("DataSetID", "EntitySortOrder", "ColumnPosition", "ColumnName", "AttributeID", "AttributeLabel", "Description", "StorageType", "MeasurementScaleDomainID", "DateTimeFormatString", "DateTimePrecision", "TextPatternDefinition", "Unit", "NumericPrecision", "NumberType", "BoundsMinimum", "BoundsMaximum") FROM stdin;
99021	1	2	year	year	Year	Year of collection	string	dateTime	YYYY	1	\N	\N	\N	\N	\N	\N
99054	101	3	date_utc	date_utc	Date UTC	Date of measurement, Universal Time Coordinate	date	dateTime	YYYYMMDD	1	\N	\N	\N	\N	\N	\N
99013	1	1	date	date	Date	date	date	dateTime	MM/DD/YYYY	1	\N	\N	\N	\N	1/1/2000	1/1/2100
99013	1	2	time	time	time	time	string	dateTime	hh:mm:ss	1	\N	\N	\N	\N	\N	\N
99013	1	3	temp_c	temp_c	Temperature C	water temperature	float	interval	\N	\N	\N	celsius	0.0100000000000000002	real	5	20
99013	1	4	serial	serial	Serial Number	Serial number of instrument used for observation. Instruments: 32K StowAway TidbiT (-5 deg C to 37 deg C) manufactured by Onset Computer Corporation.	integer	nominalText	\N	\N	integer as text	\N	\N	\N	\N	\N
99013	1	5	site_code	site_code	Site	Name of field site. Depth of temperature logger at each site varies from 4.95 to 8.15 meters. See enumerated list for site-specific depths.	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99013	1	6	fake_xsect_code	fake_xsect_code	Fake transect code	this is a fake col to test ordinalenum	string	ordinalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99013	1	7	fake_ord_text	fake_ord_text	Fake ordinal text field	this is a test field	string	ordinalText	\N	\N	any text	\N	\N	\N	\N	\N
99013	1	8	fake-temp	fake-temp	Temperature fake	this is fake	float	ratio	\N	\N	\N	kelvin	0.100000000000000006	real	273	373
99013	1	9	fake temp	fake temp	asdf	asdf	float	ratio	\N	\N	\N	kelvin	0.100000000000000006	real	\N	\N
99013	1	10	fake_col_w_taxonCov	fake_col_w_taxonCov	Fake taxa	this is a fake col to test this is a fake column. string field	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99013	1	20	Density	Density	Density	For all except MAPY: Average number of individuals present per square meter of transect. For MAPY (M. pyrifera): Average number of fronds present per square meter of transect.	float	ratio	\N	\N	\N	numberPerMeterSquared	0.0100000000000000002	real	\N	\N
99013	1	21	Cover	Cover	Percent Cover	Percent cover estimated from Uniform Point Contact observations as the fraction of total points at which that species was present out of 80 points x 100.	float	ratio	\N	\N	\N	percent	0.0100000000000000002	real	\N	\N
99013	1	22	MeanDry	MeanDry	Average Dry Mass	Average dry mass (g per individual) for taxa with abundance reported as density derived from field allometric measurements and lab-derived relationships.	float	ratio	\N	\N	\N	gram	0.0100000000000000002	real	\N	\N
99013	1	23	OBS_CODE	OBS_CODE	Observer Code	Numeric code indicating the SBCLTER data collector	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99013	1	24	NOTES	NOTES	Notes	Text annotations to data observations	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99013	1	104	frondlength	frondlength	Frond length	Total length of sample frond sample blade is on, in meters (frond = stipe plus all blades)	decimal	ratio	\N	\N	\N	meter	0.0100000000000000002	real	\N	\N
99013	1	109	totalblades	totalblades	Total blades	Total number of blades on the frond	integer	ratio	\N	\N	\N	number	1	integer	\N	\N
99013	1	207	LMA	LMA	Blade wet mass density	Blade wet mass per unit area (mg/cm2)	decimal	ratio	\N	\N	\N	milligramPerCentimeterSquared	0.00100000000000000002	real	\N	\N
99013	1	208	ChA	ChA	Blade Chla content	Blade Chlorophyll a content (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N
99013	1	209	ChC	ChC	Blade Chlc content	Blade Chlorophyll c content (ug/cm2) 	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N
99013	1	210	FX	FX	Blade fucoxanthin content	Blade Fucoxanthin content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N
99013	1	305	frondcondition	frondcondition	Frond condition	Growth stage of plant (TO DO FROND?) from which sample was taken, either growing or terminal	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99013	1	307	length	length	Blade length	Total blade length TO DO: Maximum blade length? (per Dan's note)	decimal	ratio	\N	\N	\N	centimeter	0.100000000000000006	real	\N	\N
99013	1	308	width	width	Blade width	Width of sample blade at widest point	decimal	ratio	\N	\N	\N	centimeter	0.0100000000000000002	real	\N	\N
99013	1	309	wetmass	wetmass	Blade wet mass	Area-specific wet mass (g/cm2)	decimal	ratio	\N	\N	\N	gramPerCentimeterSquared	0.00100000000000000002	real	\N	\N
99013	1	3010	drymass	drymass	Blade dry mass	Area specific dry mass (g/cm2)	decimal	ratio	\N	\N	\N	gramPerCentimeterSquared	1.00000000000000006e-09	real	\N	\N
99013	1	3013	ChlC	ChlC	Blade Chlc content	Blade Chlorophyll c content (ug/cm2) 	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N
99013	1	3014	FX_table3	FX_table3	Blade fucoxanthin content	Blade Fucoxanthin content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N
99013	1	3015	carbon	carbon	Blade carbon content	Blade carbon content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.100000000000000006	real	\N	\N
99013	1	3044	frondlength_t3	frondlength_t3	Frond length	Total length of sample frond sample blade is on (frond = stipe plus all blades)	decimal	ratio	\N	\N	\N	meter	0.25	real	\N	\N
99021	1	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99021	1	3	season	season	Season	Season (winter, spring, summer and autumn as defined by the winter solstice, spring equinox, summer solstice and autumnal equinox) in which the site is sampled.	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99021	1	4	NPP_wet	NPP_wet	NPP Wet	The seasonal rate of M. pyrifera biomass production in units of wet mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	5	NPP_dry	NPP_dry	NPP Dry	The seasonal rate of M. pyrifera biomass production in units of dry mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	2	18	SE_Frond_loss_rate	SE_Frond_loss_rate	SE Frond Loss Rate	The standard error in the calculated rate of frond loss (day-1). This error is sampling error associated with calculating a mean loss rate for the entire plot based on 10 to15 tagged plants.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	6	NPP_carbon	NPP_carbon	NPP Carbon	The seasonal rate of M. pyrifera biomass production in units of carbon mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99024	1	6	_N	_N	Number of Samples	Number of individual kelp core samples combined to create the composite site sample used for the analysis	integer	ratio	\N	\N	\N	number	1	integer	\N	\N
99021	1	7	NPP_nitrogen	NPP_nitrogen	NPP Nitrogen	The seasonal rate of M. pyrifera biomass production in units of nitrogen mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	8	Growth_rate_wet	Growth_rate_wet	Growth rate, wet	The seasonal growth rate of M. pyrifera wet mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	9	Growth_rate_dry	Growth_rate_dry	Growth rate, dry	The seasonal growth rate of M. pyrifera dry mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	10	Growth_rate_carbon	Growth_rate_carbon	Growth rate, carbon	The seasonal growth rate of M. pyrifera carbon mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	11	Growth_rate_nitrogen	Growth_rate_nitrogen	Growth rate, nitrogen	The seasonal growth rate of M. pyrifera nitrogen mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	12	SE_NPP_wet	SE_NPP_wet	Std error, NPP wet	The standard error in our estimate of NPP in units of wet mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	13	SE_NPP_dry	SE_NPP_dry	Ste error, NPP dry	The standard error in our estimate of NPP in units of dry mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	14	SE_NPP_carbon	SE_NPP_carbon	Std error, NPP carbon	The standard error in our estimate of NPP in units of carbon mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	15	SE_NPP_nitrogen	SE_NPP_nitrogen	St error, NPP nitrogen	The standard error in our estimate of NPP in units of nitrogen mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	100000	100000
99021	1	16	SE_growth_rate_wet	SE_growth_rate_wet	Std error, growth rate wet	The standard error in our estimate of the growth rate of wet mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	17	SE_growth_rate_dry	SE_growth_rate_dry	Std error, growth rate dry	The standard error in our estimate of the growth rate of dry mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	18	SE_growth_rate_carbon	SE_growth_rate_carbon	Std error, growth rate carbon	The standard error in our estimate of the growth rate of carbon mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	1	19	SE_growth_rate_nitrogen	SE_growth_rate_nitrogen	Std error, growth rate nitrogen	The standard error in our estimate of the growth rate of nitrogen mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	2	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99021	2	2	date	date	date	Date of collection	string	dateTime	YYYY-MM-DD	1	\N	\N	\N	\N	\N	\N
99021	2	3	FSC_wet	FSC_wet	FSC Wet	The wet mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the wet mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total wet mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	integer	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	4	FSC_dry	FSC_dry	FSC Dry	The dry mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the dry mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total dry mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	5	FSC_carbon	FSC_carbon	FSC Carbon	The carbon mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the carbon mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total carbon mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	6	FSC_nitrogen	FSC_nitrogen	FSC Nitrogen	The nitrogen mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the nitrogen mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total nitrogen mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	7	Frond_density	Frond_density	Frond Density	The density of M. pyrifera fronds in the plot (number m-2).	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	100000	100000
99021	2	8	Plant_density	Plant_density	Plant Density	The density of M. pyrifera plants in the plot (number m-2). Only plants with at least one frond greater than 1m are counted.mv	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	100000	100000
99021	2	9	Plant_loss_rate	Plant_loss_rate	Plant Density	The loss rate of M. pyrifera plants during the sampling interval (fraction of plants lost day-1). These data are based on losses of 10 to15 tagged plants, as described in Section I.B Measuring loss rate.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	2	10	Frond_loss_rate	Frond_loss_rate	Frond loss rate	The average loss rate of fronds during the sampling interval (fraction of fronds lost day-1). These data are the mean loss rate of tagged fronds from 10 to15 tagged plants, as described in Section I.B Measuring loss rate. The mean is based on frond loss from plants that survive the period; losses of whole plants are accounted for in the plant loss rate.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	2	11	SE_FSC_wet	SE_FSC_wet	SE FSC Wet	The standard error in our estimate of foliar standing crop in units of wet mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in wet mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass conversion ratio	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	12	SE_FSC_dry	SE_FSC_dry	SE FSC Dry	The standard error in our estimate of foliar standing crop in units of dry mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in section I.B Quantifying Uncertainty. The error in dry mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass and wet-mass:dry-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99054	101	4	biomass	biomass	Biomass	wet weight (kg) of kelp canopy in the pixel (900 meter squared)	float	ratio	\N	\N	\N	kilogram	1	real	\N	\N
99021	2	13	SE_FSC_carbon	SE_FSC_carbon	SE FSC Carbon	The standard error in our estimate of foliar standing crop in units of carbon mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in carbon mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass, wet-mass:dry-mass and dry-mass:carbon-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	14	SE_FSC_nitrogen	SE_FSC_nitrogen	SE FSC Nitrogen	The standard error in our estimate of foliar standing crop in units of nitrogen mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in nitrogen mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass, wet-mass:dry-mass and dry-mass:nitrogen-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	100000	100000
99021	2	15	SE_Frond_density	SE_Frond_density	SE Frond Density	The standard error in our estimate of M. pyrifera frond density (number m-2). Error in frond density reflects variation in the total number of plants sampled in a plot. This estimate is produced by comparing repeated sampling by different observers of a single plot.	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	100000	100000
99021	2	16	SE_Plant_density	SE_Plant_density	SE Plant Density	The standard error in our estimate of M. pyrifera plant density (number m-2). Error in plant density reflects variation in the total number of plants sampled in a plot. This estimate is produced by comparing repeated sampling by different observers of a single plot.	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	100000	100000
99021	2	17	SE_Plant_loss_rate	SE_Plant_loss_rate	SE Plant Loss Rate	The standard error in our estimate of M. pyrifera plant loss (day-1). This error is sampling error associated with calculating a mean loss rate for the entire plot based on 10 to15 tagged plants.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	100000	100000
99021	3	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99021	3	2	plant_ID	plant_ID	Plant ID	Identifier for tagged plant	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99021	3	3	date	date	Date	Date of collection	string	dateTime	YYYY-MM-DD	1	\N	\N	\N	\N	\N	\N
99021	3	4	total_fronds	total_fronds	Total Fronds	Total number of fronds greater than 1 m in length on the plant. Includes both tagged fronds remaining from previous sampling and new fronds	integer	ratio	\N	\N	\N	number	1	integer	100000	100000
99021	3	5	new_fronds	new_fronds	New Fronds	Number of untagged fronds greater than 1 m in length on the plant. Assumes that these fronds were either initiated during the previous sampling interval. A value of zero means that no new fronds were counted	integer	ratio	\N	\N	\N	number	1	integer	100000	100000
99024	1	1	CONSEC_	CONSEC_	Sample number	Sample number	integer	nominalText	\N	\N	integer as text	\N	\N	\N	\N	\N
99024	1	2	YEAR	YEAR	Year	Calendar year of data collection	integer	dateTime	YYYY	1	\N	\N	\N	\N	\N	\N
99024	1	3	MONTH	MONTH	Month	Calendar month of data collection	integer	dateTime	MM	1	\N	\N	\N	\N	\N	\N
99024	1	4	DATE	DATE	Date	The date the sample was collected in the field	string	dateTime	mm/dd/yyyy	1	\N	\N	\N	\N	\N	\N
99024	1	5	SITE	SITE	Site Name	The name of the physical location of the reef site where samples were collected.	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99024	1	7	Replicate	Replicate	Replicate	Sample replicate	integer	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N
99024	1	8	WET	WET	Wet Weight	Wet weight of he sample measured at time of coring	float	ratio	\N	\N	\N	gram	0.000100000000000000005	real	\N	\N
99024	1	9	DRY	DRY	Dry Weight	Dry weight of sample measured after drying sample in 60 degree celcius oven for 3-5 days	float	ratio	\N	\N	\N	gram	0.000100000000000000005	real	\N	\N
99024	1	10	DRY_WET	DRY_WET	Dry Weight / Wet Weight	The ratio of dry to wet weight	float	ratio	\N	\N	\N	gramPerGram	9.99999999999999955e-07	real	\N	\N
99024	1	11	ANALYTICAL_WT	ANALYTICAL_WT	Analytical Dry Weight	Weight of dry sample used in CHN analysis	float	ratio	\N	\N	\N	microgram	0.100000000000000006	real	\N	\N
99024	1	12	C	C	% Carbon	Percentage of carbon in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	\N	\N
99024	1	13	H	H	% Hydrogen	Percentage of hydrogen in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	\N	\N
99024	1	14	N	N	% Nitrogen	Percentage of nitrogen in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	\N	\N
99024	1	15	CN_RATIO	CN_RATIO	%Carbon to %Nitrogen Ratio	Carbon to nitrogen ratio of the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	\N	\N
99024	1	16	NOTES	NOTES	Notes	Text annotations to data observations	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N
99054	101	1	latitude	latitude	Latitude	Latitude of center of pixel. Degrees North	float	ratio	\N	\N	\N	degree	1.00000000000000002e-08	real	\N	\N
99054	101	2	longitude	longitude	Longitude	Longitude of center of pixel. Degrees East	float	ratio	\N	\N	\N	degree	1.00000000000000002e-08	real	\N	\N
\.


--
-- TOC entry 3438 (class 0 OID 112037)
-- Dependencies: 203
-- Data for Name: DataSetEntities; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetEntities" ("DataSetID", "EntitySortOrder", "EntityName", "EntityType", "EntityDescription", "EntityRecords", "FileType", "Urlhead", "Subpath", "FileName", "AdditionalInfo", "FileSize", "FileSizeUnits", "Checksum") FROM stdin;
99054	102	UCSB kelp timeseries video	otherEntity	Movie: time series of kelp canopy distribution near UC Santa Barbara, 1984 - 2009	\N	mov_A	http://sbc.lternet.edu/external/Reef/Data/	kelp_biomass_landsat/	ucsb_kelp_ts.mov	\N	\N	byte	\N
99054	101	Kelp biomass, Landsat	dataTable	Kelp Biomass from Landsat	44930474	csv_A	http://sbc.lternet.edu/external/Reef/Data/	kelp_biomass_landsat/	kelp_biomass_landsat.zip	<para>The text table is 1.6 gb, and has been compressed to 365 mb for download.</para>	\N	byte	\N
99013	1	bottom_temp_all_years_20120626.csv	dataTable	continuous temperature at permanent reef sites	10	csv_D	http://sbc.lternet.edu/external/Reef/Data/Bottom_Temperature/	\N	bottom_temp_all_years_20120626.csv	\N	\N	byte	\N
99021	3	Census_of_fronds_on_marked_plants_20120613.csv	dataTable	Census of fronds on marked plants	20	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	Census_of_fronds_on_marked_plants_20120613.csv	\N	\N	byte	\N
99021	1	M_pyrifera_net_primary_production_and_growth_20120614.csv	dataTable	Macrocystis pyrifera net primary production and growth	30	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	M_pyrifera_net_primary_production_and_growth_20120614.csv	\N	\N	byte	\N
99021	2	M_pyrifera_standing_crop_plant_density_and_loss_rates_20120614.csv	dataTable	Macrocystis pyrifera standing crop, plant density and loss rates	40	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	M_pyrifera_standing_crop_plant_density_and_loss_rates_20120614.csv	\N	\N	byte	\N
99024	1	CHN_all_years.csv	dataTable	Macrocystis pyrifera CHN data	50	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	CHN_all_years.csv	\N	\N	byte	\N
\.


--
-- TOC entry 3439 (class 0 OID 112044)
-- Dependencies: 204
-- Data for Name: DataSetKeywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetKeywords" ("DataSetID", "Keyword", "ThesaurusID") FROM stdin;
99013	Carpinteria	sbclter_place
99013	temperature	lter_cv
99013	Water Temperature	gcmd6
99013	Santa Barbara Coastal	lter_cv
99013	LTER	lter_cv
99013	Ocean_biogeochemistry	sbclter
99013	Arroyo Burro	sbclter_place
99013	Santa Cruz Island, Diablo	sbclter_place
99013	Bullito	sbclter_place
99013	Santa Cruz Island, Twin Harbor West	sbclter_place
99013	Arroyo Quemado	sbclter_place
99013	Isla Vista	sbclter_place
99013	Arroyo Hondo	sbclter_place
99013	Naples	sbclter_place
99013	Mohawk	sbclter_place
99013	Goleta Bay	sbclter_place
99013	Temperature	knb
99013	Marine	knb
99021	seasonality	lter_cv
99021	Ecosystem Processes	sbclter
99021	Santa Barbara Coastal	lter_cv
99021	net primary production	ea
99021	growth	lter_cv
99021	Fronds	nbii
99021	populations	lter_cv_cra
99021	Primary production	nbii
99021	long term ecological research	lter_cv
99021	standing crop	ea
99021	Biogeochemistry	sbclter
99021	Carbon	gcmd6
99021	Arroyo Burro Reef	sbclter_place
99021	LTER	lter_cv
99021	biomass	lter_cv
99021	algae	gcmd6
99021	marine algae	ea
99021	Biomass	gcmd6
99021	growth rate	ea
99021	Nearshore Ocean	sbclter
99021	Mohawk Reef	sbclter_place
99021	Kelp Forest	sbclter
99021	Macrocystis pyrifera	none
99021	mass	lter_cv
99021	Marine Plants	gcmd6
99021	Mass (property)	nbii
99021	carbon	lter_cv
99021	Dominant Species	gcmd6
99021	Community Structure	sbclter
99021	productivity	lter_cv
99021	primary production	lter_cv_cra
99021	standing crop	lter_cv
99021	giant kelp	ea
99021	Arroyo Quemado Reef	sbclter_place
99021	Reef	sbclter
99024	LTER	lter_cv
99024	net primary production	none
99024	Marine Plants	gcmd6
99024	growth rate	none
99024	marine algae	ea
99024	Santa Barbara Coastal	lter_cv
99024	giant kelp	none
99024	algae	lter_cv
99024	carbon	lter_cv
99024	Dominant Species	gcmd6
99024	Macrocystis pyrifera	none
99024	standing crop	lter_cv
99024	biomass	lter_cv
99024	primary production	lter_cv_cra
99054	canopy	lter_cv
99054	Santa Catalina Island	sbclter_place
99054	Biomass	nbii
99054	wet weight	none
99054	Landsat	none
99054	Ventura County	sbclter_place
99054	populations	lter_cv_cra
99054	Kelp Forest	sbclter
99054	Santa Barbara Channel Islands	sbclter_place
99054	Santa Barbara Coastal	lter_cv
99054	San Clemente Island	sbclter_place
99054	remote sensing	none
99054	Los Angeles County	sbclter_place
99054	Orange County	sbclter_place
99054	kelp biomass	none
99054	Biomass Dynamics	gcmd6
99054	San Miguel Island	sbclter_place
99054	satellite	none
99054	LTER	lter_cv
99054	nearshore ocean	sbclter
99054	remote sensing	sbclter
99054	Santa Rosa Island	sbclter_place
99054	kelp canopy	none
99054	Santa Barbara Island	sbclter_place
99054	Santa Cruz Island	sbclter_place
99054	San Diego County	sbclter_place
99054	Santa Barbara County	sbclter_place
99054	Biomass	gcmd6
99054	Anacapa Island	sbclter_place
99054	biomass	lter_cv
99054	San Nicolas Island	sbclter_place
\.


--
-- TOC entry 3440 (class 0 OID 112048)
-- Dependencies: 205
-- Data for Name: DataSetMethod; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethod" ("DataSetID", "MethodStepID", "DescriptionType", "Description", "Method_xml") FROM stdin;
99021	10	file	method.99021.10.docx	\N
99024	10	file	method.99024.10.docx	\N
99013	10	file	method.99013.10.docx	\N
99021	20	file	method.99021.20.docx	\N
\.


--
-- TOC entry 3441 (class 0 OID 112057)
-- Dependencies: 206
-- Data for Name: DataSetMethodInstruments; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethodInstruments" ("DataSetID", "MethodStepID", "InstrumentID") FROM stdin;
99021	10	1
99021	10	2
\.


--
-- TOC entry 3442 (class 0 OID 112060)
-- Dependencies: 207
-- Data for Name: DataSetMethodProtocols; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethodProtocols" ("DataSetID", "MethodStepID", "ProtocolID") FROM stdin;
99021	10	57
99024	10	55
99013	10	46
99021	10	35
\.


--
-- TOC entry 3443 (class 0 OID 112063)
-- Dependencies: 208
-- Data for Name: DataSetMethodProvenance; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethodProvenance" ("DataSetID", "MethodStepID", "SourcePackageID") FROM stdin;
99021	10	knb-lter-ble.1.5
99021	10	knb-lter-sbc.6003.3
\.


--
-- TOC entry 3444 (class 0 OID 112066)
-- Dependencies: 209
-- Data for Name: DataSetMethodSoftware; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethodSoftware" ("DataSetID", "MethodStepID", "SoftwareID") FROM stdin;
99021	10	1
99021	10	2
99021	20	3
\.


--
-- TOC entry 3445 (class 0 OID 112069)
-- Dependencies: 210
-- Data for Name: DataSetPersonnel; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetPersonnel" ("DataSetID", "NameID", "AuthorshipOrder", "AuthorshipRole") FROM stdin;
99021	dreed	3	creator
99021	arassweiler	1	creator
99021	karkema	2	creator
99021	mbrzezinski	4	creator
99024	dreed	1	creator
99013	dreed	1	creator
99021	mobrien	1	queen bee
99024	mobrien	1	field technician
99013	sharrer	1	data processing
99013	mbrzezinski	2	metadataProvider
99054	sbclter	1	creator
99054	kcavanaugh	2	creator
99054	dsiegel	3	creator
99054	dreed	4	creator
\.


--
-- TOC entry 3488 (class 0 OID 112872)
-- Dependencies: 281
-- Data for Name: DataSetPublications; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetPublications" ("DataSetID", "Revision", "PublicationID", "RelationshipType") FROM stdin;
\.


--
-- TOC entry 3446 (class 0 OID 112072)
-- Dependencies: 211
-- Data for Name: DataSetSites; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetSites" ("DataSetID", "EntitySortOrder", "SiteID", "GeoCoverageSortOrder") FROM stdin;
99013	0	ABUR_reef	1
99013	0	AHON_reef	1
99013	0	AQUE_reef	1
99013	0	BULL_reef	1
99013	0	CARP_reef	1
99013	0	GOLB_reef	1
99013	0	IVEE_reef	1
99013	0	MOHK_reef	1
99013	0	NAPL_reef	1
99013	0	SCDI_reef	1
99013	0	SCTW_reef	1
99021	0	ABUR_reef	1
99021	0	AQUE_reef	1
99021	0	MOHK_reef	1
99024	0	ABUR_reef	1
99024	0	AQUE_reef	1
99024	0	MOHK_reef	1
99054	0	geocov_ds54	1
\.


--
-- TOC entry 3447 (class 0 OID 112077)
-- Dependencies: 212
-- Data for Name: DataSetTaxa; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetTaxa" ("DataSetID", "TaxonID", "TaxonomicProviderID") FROM stdin;
\.


--
-- TOC entry 3448 (class 0 OID 112080)
-- Dependencies: 213
-- Data for Name: DataSetTemporal; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetTemporal" ("DataSetID", "EntitySortOrder", "BeginDate", "EndDate", "UseOnlyYear") FROM stdin;
99054	0	1982-11-24	2011-09-13	f
\.


--
-- TOC entry 3449 (class 0 OID 112084)
-- Dependencies: 214
-- Data for Name: EMLFileTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLFileTypes" ("FileType", "TypeName", "FileFormat", "Extension", "Description", "Delimiters", "Header", "EML_FormatType", "RecordDelimiter", "NumHeaderLines", "NumFooterLines", "AttributeOrientation", "QuoteCharacter", "FieldDelimiter", "CharacterEncoding", "CollapseDelimiters", "LiteralCharacter", "externallyDefinedFormat_formatName", "externallyDefinedFormat_formatVersion") FROM stdin;
csv_C	CSV unix, hdr, ftr	comma separated values	csv	CSV. unix line ending, 1-line header, 1-line footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\n	1	1	column	"	,	\N	no	\\	\N	\N
csv_D	CSV ms, hdr, no ftr	comma separated values	csv	CSV. ms line ending, 1-line header, no footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\r\\n	1	0	column	"	,	\N	no	\\	\N	\N
csv_E	CSV ms,  hdr, ftr	comma separated values	csv	CSV. ms line ending, 1-line header, 1-line footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\r\\n	1	1	column	"	,	\N	no	\\	\N	\N
excel_A	MS-Excel file, xlsx extension	MS-Excel	xslx	readable by several versions, eg available 2009 - 2015	not applicable	not applicable	externallyDefinedFormat	\N	\N	\N	column	\N	\N	\N	\N	\N	MS-Excel	\N
gif_A	GIF type A	GIF image	gif	GIF image	not applicable	not applicable	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	GIF	\N
mov_A	Movie, type A	MOV	mov	QuickTime movie	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	QuickTime movie	\N
netcdf	NetCDF type	NetCDF file	nc	self-describing, machine-independent data formats and it was developed at the Unidata Program Center in Boulder, Colorado.	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	NetCDF	\N
png_A	PNG type A	PNG	png	PNG image	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	PNG	\N
csv_A	CSV unix, no hdr, no ftr	comma separated values	csv	CSV. unix line ending, no header, no footer, optional quoted strings and literal chars.	single comma	none	textFormat	\\n	0	0	column	"	,	\N	no	\\	\N	\N
csv_B	CSV unix, hdr, no ftr	comma separated values	csv	CSV. unix line ending, 1-line header, no footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\n	1	0	column	"	,	\N	no	\\	\N	\N
csv_F	CSV unix, 2-ln-hdr, no ftr	comma separated values	csv	CSV. unix line ending, 2-line header (table-specific), no footer, optional quoted strings and literal chars.	single comma	table-specific	textFormat	\\n	2	0	column	"	,	\N	no	\\	\N	\N
csv_G	CSV unix, 6-ln-hdr, no ftr	comma separated values	csv	CSV. unix line ending, 6-line header (table-specific), no footer, optional quoted strings and literal chars.	single comma	table-specific	textFormat	\\n	6	0	column	"	,	\N	no	\\	\N	\N
csv_H	CSV slash-r, hdr	comma-sep, mac line ending	csv	slash-r used by old macs (OS-9 and earlier)	single comma	column names	textFormat	\\r	1	0	column	"	,	\N	no	\\	\N	\N
mat_A	MATLAB type	MATLAB formatted data	mat	Partial access of variables in MATLAB workspace or saved MATLAB workspace	not applicable	none	externallyDefinedFormat	\N	\N	\N	column	\N	\N	\N	\N	\N	MATLAB	\N
txt_A	TXT type A	text file	txt	text file, unix line-ending, space-separated, collapse yes, hex code in EML, no header, no footer, optional quoted strings and literal chars.	space (hex code), collapse multiple.	none	textFormat	\\n	0	\N	column	"	#x20	\N	yes	\\	\N	\N
txt_B	TXT type B	text file	txt	ODV format: text file, unix line-ending, semicolon-separated, 1-line header, no footer, optional quoted strings and literal chars.	single semicolon	column names	textFormat	\\n	1	\N	column	"	;	\N	no	\\	\N	\N
txt_C	TXT type C	text file	txt	txt, tab-delimited. microsoft line ending, 1-line header, no footer, optional quoted strings and literal chars.	tab	column names	textFormat	\\r\\n	1	\N	column	"	\\t	\N	no	\\	\N	\N
txt_D	TXT type D	text file, moorings as of 2014	txt	resembles txt_A, but has a one line header	single space	column names	textFormat	\\n	1	\N	column	"	#x20	\N	yes	\\	\N	\N
txt_E	TXT type E	text file	txt	text file, unix line-ending, tab-separated, collapse yes, 1-line header, no footer, optional quoted strings and literal chars.	tab	column names	textFormat	\\n	1	\N	column	"	\\t	\N	yes	\\	\N	\N
\.


--
-- TOC entry 3450 (class 0 OID 112092)
-- Dependencies: 215
-- Data for Name: EMLKeywordTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLKeywordTypes" ("KeywordType", "TypeDefinition") FROM stdin;
place	\N
theme	\N
taxonomic	\N
stratum	\N
temporal	\N
\.


--
-- TOC entry 3451 (class 0 OID 112098)
-- Dependencies: 216
-- Data for Name: EMLMeasurementScaleDomains; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLMeasurementScaleDomains" ("EMLDomainType", "MeasurementScale", "NonNumericDomain", "MeasurementScaleDomainID") FROM stdin;
dateTimeDomain	dateTime		dateTime
numericDomain	interval		interval
nonNumericDomain	nominal	enumeratedDomain	nominalEnum
nonNumericDomain	nominal	textDomain	nominalText
nonNumericDomain	ordinal	enumeratedDomain	ordinalEnum
nonNumericDomain	ordinal	textDomain	ordinalText
numericDomain	ratio		ratio
\.


--
-- TOC entry 3452 (class 0 OID 112101)
-- Dependencies: 217
-- Data for Name: EMLMeasurementScales; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLMeasurementScales" ("measurementScale") FROM stdin;
dateTime
interval
nominal
ordinal
ratio
\.


--
-- TOC entry 3453 (class 0 OID 112104)
-- Dependencies: 218
-- Data for Name: EMLNumberTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLNumberTypes" ("NumberType") FROM stdin;
integer
natural
real
whole
\.


--
-- TOC entry 3484 (class 0 OID 112798)
-- Dependencies: 276
-- Data for Name: EMLObjectProperties; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLObjectProperties" ("ObjectPropertyID", "ObjectPropertyLabel", "ObjectPropertyURI") FROM stdin;
\.


--
-- TOC entry 3454 (class 0 OID 112107)
-- Dependencies: 219
-- Data for Name: EMLStorageTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLStorageTypes" ("StorageType", "typeSystem") FROM stdin;
anyURI	http://www.w3.org/2001/XMLSchema-datatypes
boolean	http://www.w3.org/2001/XMLSchema-datatypes
byte	http://www.w3.org/2001/XMLSchema-datatypes
date	http://www.w3.org/2001/XMLSchema-datatypes
dateTime	http://www.w3.org/2001/XMLSchema-datatypes
decimal	http://www.w3.org/2001/XMLSchema-datatypes
double	http://www.w3.org/2001/XMLSchema-datatypes
duration	http://www.w3.org/2001/XMLSchema-datatypes
float	http://www.w3.org/2001/XMLSchema-datatypes
gDay	http://www.w3.org/2001/XMLSchema-datatypes
gMonth	http://www.w3.org/2001/XMLSchema-datatypes
gMonthDay	http://www.w3.org/2001/XMLSchema-datatypes
gYear	http://www.w3.org/2001/XMLSchema-datatypes
gYearMonth	http://www.w3.org/2001/XMLSchema-datatypes
int	http://www.w3.org/2001/XMLSchema-datatypes
integer	http://www.w3.org/2001/XMLSchema-datatypes
long	http://www.w3.org/2001/XMLSchema-datatypes
short	http://www.w3.org/2001/XMLSchema-datatypes
string	http://www.w3.org/2001/XMLSchema-datatypes
time	http://www.w3.org/2001/XMLSchema-datatypes
\.


--
-- TOC entry 3455 (class 0 OID 112110)
-- Dependencies: 220
-- Data for Name: EMLUnitDictionary; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLUnitDictionary" (id, name, custom, "unitType", abbreviation, "multiplierToSI", "parentSI", "constantToSI", description) FROM stdin;
ampere	ampere	f	current	A	1	\N	\N	SI unit of electrical current
amperePerMeter	amperePerMeter	f	magneticFieldStrength	A/m	1	\N	\N	ampere per meter
amperePerSquareMeter	amperePerSquareMeter	f	currentDensity	A/m²	1	\N	\N	ampere per meter squared
are	are	f	area	a	100	squareMeter	\N	100 square meters
atmosphere	atmosphere	f	pressure	atm	101325	pascal	\N	1 atmosphere = 101325 pascals
bar	bar	f	pressure	bar	100000	pascal	\N	1 bar = 100000 pascals
becquerel	becquerel	f	radionucleotideActivity	Bq	1	\N	\N	becquerel
britishThermalUnit	britishThermalUnit	f	energy	btu	1055.0559	joule	\N	1 btu = 1055.0559 J
bushel	bushel	f	volume	b	0.035239	liter	\N	1 bushel = 35.23907 liters
bushelsPerAcre	bushelsPerAcre	f	volumetricArea	\N	0.00870	litersPerSquareMeter	\N	bushels per acre -- 1 bushel = 35.23907 liters/1 acre = 4046.8564 squareMeters
calorie	calorie	f	energy	cal	4.1868	joule	\N	1 cal = 4.1868 J
candela	candela	f	luminosity	cd	1	\N	\N	SI unit of luminosity
candelaPerSquareMeter	candelaPerSquareMeter	f	luminance	cd/m²	1	\N	\N	candela Per Square Meter
centigram	centigram	f	mass	cg	0.00001	kilogram	\N	0.00001 kg
centimeter	centimeter	f	\N	cm	0.01	meter	\N	.01 meters
centimeterPerYear	centimeterPerYear	f	speed	cm/year	0.000000000317098	metersPerSecond	\N	centimeter Per Year
centisecond	centisecond	f	\N	csec	0.01	second	\N	1/100 of a second
coulomb	coulomb	f	charge	C	1	\N	\N	SI unit of charge
cubicCentimetersPerCubicCentimeters	cubicCentimetersPerCubicCentimeters	f	volumePerVolume	\N	1	\N	\N	cubic centimeters per cubic centimeter
cubicFeetPerSecond	cubicFeetPerSecond	f	volumetricRate	ft³/sec	28.316874	litersPerSecond	\N	cubic feet per second
cubicInch	cubicInch	f	volume	in³	0.000016387064	liter	\N	cubic inch
cubicMeter	cubicMeter	f	volume	m³	1	\N	\N	cubic meter
cubicMeterPerKilogram	cubicMeterPerKilogram	f	specificVolume	m³/kg	1	\N	\N	cubic meters per kilogram
cubicMetersPerSecond	cubicMetersPerSecond	f	volumetricRate	m³/s	1	litersPerSecond	\N	cubic meters per second
cubicMicrometersPerGram	cubicMicrometersPerGram	f	specificVolume	µm³/kg	1	\N	\N	cubic micrometers per gram
day	day	t	time	day	86400	second	\N	day (86400 seconds)
decibar	decibar	t	pressure	dbar	10000	pascal	\N	decibar = 0.1 bar
decigram	decigram	f	mass	dg	0.0001	kilogram	\N	0.0001 kg
decimeter	decimeter	f	\N	dm	0.1	meter	\N	.1 meters
decisecond	decisecond	f	\N	dsec	0.1	second	\N	1/10 of a second
dekagram	dekagram	f	mass	dag	0.01	kilogram	\N	.01 kg
dekameter	dekameter	f	\N	dam	10	meter	\N	10 meters
dekasecond	dekasecond	f	\N	dasec	10	second	\N	10 seconds
disintegrationsPerMinute	disintegrationsPerMinute	t	radionucleotideActivity	DPM	0.0166666667	becquerel	\N	DPM = radioactive disintegrations per minute
disintegrationsPerMinutePerGram	disintegrationsPerMinutePerGram	t	radionucleotideActivity	DPM/g	\N	\N	\N	DPM/g = radioactive disintegrations per minute per gram of sample
fahrenheit	fahrenheit	f	\N	F	0.556	kelvin	-17.778	An obsolescent unit of temperature still used in popular meteorology
farad	farad	f	capacitance	F	1	\N	\N	farad
fathom	fathom	f	\N	\N	1.8288	meter	\N	6 feet
feetPerDay	feetPerDay	f	speed	ft/day	0.00000352778	metersPerSecond	\N	feet per day
feetPerHour	feetPerHour	f	speed	ft/hr	0.000084667	metersPerSecond	\N	feet per hour
feetPerSecond	feetPerSecond	f	speed	ft/s	0.3048	metersPerSecond	\N	feet per second
feetSquaredPerDay	feetSquaredPerDay	f	transmissivity	ft²/day	0.000124586	metersSquaredPerSecond	\N	feet squared per day
foot	foot	f	\N	ft	0.3048	meter	\N	12 inches
Foot_Gold_Coast	Foot_Gold_Coast	f	\N	gcft	0.3047997	meter	\N	12 inches
Foot_US	Foot_US	f	\N	usft	0.3048	meter	\N	12 inches
footPound	footPound	f	energy	\N	1.355818	joule	\N	1 ft-lbs = 1.355818 J
gallon	gallon	f	\N	gal	3.785412	liter	\N	US liquid gallon
grad	grad	f	angle	grad	0.015707	radian	\N	grad
gram	gram	f	mass	g	0.001	kilogram	\N	0.001 kg
gramsPerCentimeterSquaredPerSecond	gramsPerCentimeterSquaredPerSecond	f	arealMassDensityRate	\N	0.1	kilogramsPerMeterSquaredPerSecond	\N	grams Per Centimeter Squared Per Second
gramsPerCubicCentimeter	gramsPerCubicCentimeter	f	massDensity	g/cm³	1000	kilogramsPerCubicMeter	\N	grams per cubic centimeter
gramsPerGram	gramsPerGram	f	massPerMass	\N	1	\N	\N	grams per gram
gramsPerHectarePerDay	gramsPerHectarePerDay	f	arealMassDensityRate	\N	0.0000000000011574	kilogramsPerMeterSquaredPerSecond	\N	grams Per Hectare Squared Per Day
gramsPerLiter	gramsPerLiter	f	massDensity	g/l	1	kilogramsPerCubicMeter	\N	grams per liter
gramsPerLiterPerDay	gramsPerLiterPerDay	f	volumetricMassDensityRate	\N	1	\N	\N	grams Per (Liter Per Day)
gramsPerMeterSquaredPerHour	gramsPerMeterSquaredPerHour	t	arealMassDensityRate	g/m^2/hr	0.0000166667	kilogramsPerMeterSquaredPerSecond	\N	grams per meter square per hour
gramsPerMeterSquaredPerYear	gramsPerMeterSquaredPerYear	f	arealMassDensityRate	\N	0.0000000000317098	kilogramsPerMeterSquaredPerSecond	\N	grams Per Meter Squared Per Year
gramsPerMilliliter	gramsPerMilliliter	f	massDensity	g/ml	1000	kilogramsPerCubicMeter	\N	grams per milliliter
gramsPerSquareMeter	gramsPerSquareMeter	f	arealMassDensity	g/m²	0.001	kilogramsPerSquareMeter	\N	grams per square meter
gramsPerYear	gramsPerYear	f	massFlux	g/yr	0.0000000000317	kilogramsPerSecond	\N	grams Per Year
gray	gray	f	specificEnergy	Gy	1	\N	\N	gray
hectare	hectare	f	area	ha	10000	squareMeter	\N	1 hectare is 10^4 square meters
celsius	celsius	f	\N	C	1	kelvin	273.18	SI-derived unit of temperature
hectogram	hectogram	f	mass	hg	0.1	kilogram	\N	.1 kg
degree	degree	f	angle	°	0.0174532924	radian	\N	360 degrees comprise a unit circle.
gramPerOneQuarterMeterSquared	gramPerOneQuarterMeterSquared	t	arealMassDensity	g/0.25m^2	\N	\N	\N	Grams per 0.25 square meter surface area
hectometer	hectometer	f	\N	hm	100	meter	\N	100 meters
hectosecond	hectosecond	f	\N	hsec	100	second	\N	100 seconds
henry	henry	f	inductance	H	1	\N	\N	henry
hertz	hertz	f	frequency	Hz	1	\N	\N	hertz
hour	hour	f	\N	hr	3600	second	\N	3600 seconds
inch	inch	f	\N	in	0.0254	meter	\N	An imperial measure of length
joule	joule	f	energy	J	1	\N	\N	joule = N*m
katal	katal	f	catalyticActivity	kat	1	\N	\N	katal
kelvin	kelvin	f	temperature	K	1	\N	\N	SI unit of temperature
kilogram	kilogram	f	mass	kg	1	\N	\N	SI unit of mass
kilogramPerCubicMeter	kilogramPerCubicMeter	f	massDensity	\N	1	\N	\N	kilogram per cubic meter
kilogramsPerHectare	kilogramsPerHectare	f	arealMassDensity	\N	0.0001	kilogramsPerSquareMeter	\N	kilograms per hectare
kilogramsPerHectarePerYear	kilogramsPerHectarePerYear	f	arealMassDensityRate	\N	0.000317	kilogramsPerMeterSquaredPerSecond	\N	kilograms Per Hectare Per Year
kilogramsPerMeterSquaredPerSecond	kilogramsPerMeterSquaredPerSecond	f	arealMassDensityRate	\N	1	\N	\N	kilograms per meter sqared per second
kilogramsPerMeterSquaredPerYear	kilogramsPerMeterSquaredPerYear	f	arealMassDensityRate	\N	0000000317	kilogramsPerMeterSquaredPerSecond	\N	kilograms Per Meter Squared Per Year
kilogramsPerSecond	kilogramsPerSecond	f	massFlux	kg/s	1	\N	\N	kilograms per second
kilogramsPerSquareMeter	kilogramsPerSquareMeter	f	arealMassDensity	kg/m²	1	\N	\N	kilograms per square meter
kilohertz	kilohertz	f	frequency	KHz	1000	hertz	\N	kilohertz
kiloliter	kiloliter	f	volume	kL	1	cubicMeter	\N	1 cubic meter
kilometer	kilometer	f	\N	km	1000	meter	\N	1000 meters
kilometersPerHour	kilometersPerHour	f	speed	km/hr	0.2778	metersPerSecond	\N	km/hr
kilopascal	kilopascal	f	pressure	kPa	1000	pascal	\N	kilopascal
kilosecond	kilosecond	f	\N	ksec	1000	second	\N	1000 seconds
kilovolt	kilovolt	f	potentialDifference	kV	1000	volt	\N	kilovolt
kilowatt	kilowatt	f	power	kW	1000	watt	\N	kilowatt
knots	knots	f	speed	\N	0.514444	metersPerSecond	\N	knots
Link_Clarke	Link_Clarke	f	\N	\N	0.2011661949	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
liter	liter	f	volume	L	0.001	cubicMeter	\N	1000 cm^3
lumen	lumen	f	luminosity	lm	1	\N	\N	lumen
lux	lux	f	illuminance	lx	1	\N	\N	lux
megagram	megagram	f	mass	Mg	1000	kilogram	\N	1000 kg
megahertz	megahertz	f	frequency	MHz	1000000	hertz	\N	megahertz
megameter	megameter	f	\N	Mm	1000000	meter	\N	1000000 meters
megapascal	megapascal	f	pressure	MPa	1000000	pascal	\N	megapascal
megasecond	megasecond	f	\N	Msec	1000000	second	\N	1000000 seconds
megavolt	megavolt	f	potentialDifference	MV	1000000	volt	\N	megavolt
megawatt	megawatt	f	power	MW	1000000	watt	\N	megawatt
meter	meter	f	length	m	1	\N	\N	SI unit of length
metersPerDay	metersPerDay	f	speed	m/day	.0000115741	\N	\N	meters per day
metersPerGram	metersPerGram	f	massSpecificLength	m/g	1	\N	\N	meters per gram
metersPerSecond	metersPerSecond	f	speed	m/s	1	metersPerSecond	\N	meters per second
metersPerSecondSquared	metersPerSecondSquared	f	acceleration	m/s²	1	\N	\N	meters per second squared
metersSquaredPerDay	metersSquaredPerDay	f	transmissivity	m²/day	86400	metersSquaredPerSecond	\N	meters squared per day
metersSquaredPerSecond	metersSquaredPerSecond	f	transmissivity	m²/s	1	\N	\N	meters squared per second
microCuriePerMicroMole	microCuriePerMicroMole	t	radionucleotideActivity	µCi/µmol	1	\N	\N	specific activity of a radionuclide
microEinsteinsPerSquareMeter	microEinsteinsPerSquareMeter	t	illuminance	µE/m^2	1	\N	\N	micro Einsteins (1E-06 moles of photons) per square meter (radiant flux)
microEinsteinsPerSquareMeterPerSecond	microEinsteinsPerSquareMeterPerSecond	t	illuminance	µE/m^2/s	1	\N	\N	micro Einsteins (1E-06 moles of photons) per square meter per second (radiant flux density)
microgram	microgram	f	mass	µg	0.000000001	kilogram	\N	0.000000001 kg
microgramsPerGram	microgramsPerGram	f	massPerMass	\N	0.000001	gramsPerGram	\N	micrograms per gram
microgramsPerLiter	microgramsPerLiter	f	massDensity	µg/l	0.000001	kilogramsPerCubicMeter	\N	micrograms / liter
microgramsPerMilligram	microgramsPerMilligram	t	massPerMass	ug/mg	0.001	gramsPerGram	\N	micrograms per milligram
microgramsPerMilliliter	microgramsPerMilliliter	t	massDensity	µg/ml	0.000001	gramsPerMilliliter	\N	micrograms per milliliter
microliter	microliter	f	volume	µl	0.000000001	cubicMeter	\N	1/1000000 of a liter
micrometer	micrometer	f	\N	µm	0.000001	meter	\N	.000001 meters
microMolesPerKilogram	microMolesPerKilogram	t	amountOfSubstanceConcentration	µmol/kg	1	\N	\N	µmol/kg = µmoles per kilogram of substance
micron	micron	f	\N	µ	0.000001	meter	\N	.000001 meters
microsecond	microsecond	f	\N	µsec	0.000001	second	\N	1/100000 of a second
mile	mile	f	\N	mile	1609.344	meter	\N	5280 ft or 1609.344 meters
milesPerHour	milesPerHour	f	speed	mph	0.44704	metersPerSecond	\N	miles per hour
milesPerMinute	milesPerMinute	f	speed	mpm	26.8224	metersPerSecond	\N	miles per minute
milesPerSecond	milesPerSecond	f	speed	mps	1609.344	metersPerSecond	\N	miles per second
millibar	millibar	f	pressure	mbar	100	pascal	\N	millibar
milligram	milligram	f	mass	mg	0.000001	kilogram	\N	0.000001 kg
milligramsPerCubicMeter	milligramsPerCubicMeter	f	massDensity	mg/m³	0.000001	kilogramsPerCubicMeter	\N	milligrams Per Cubic Meter
milligramsPerLiter	milligramsPerLiter	f	massDensity	mg/l	0.001	kilogramsPerCubicMeter	\N	milligrams / liter
literPerSquareMeter	literPerSquareMeter	f	volumetricArea	l/m²	1	\N	\N	liters per square meter
milliGramsPerMilliLiter	milliGramsPerMilliLiter	f	massDensity	kg/m³	1	kilogramsPerCubicMeter	\N	milligrams per milliliter
milligramsPerSquareMeter	milligramsPerSquareMeter	f	arealMassDensity	mg/m²	0.000001	kilogramsPerSquareMeter	\N	milligrams Per Square Meter
millihertz	millihertz	f	frequency	mHz	0.000001	hertz	\N	millihertz
milliliter	milliliter	f	volume	ml	0.000001	cubicMeter	\N	1/1000 of a liter
milliliterPerLiter	milliliterPerLiter	t	volumePerVolume	ml/L	1	\N	\N	milliters of solution per total volume
millimeter	millimeter	f	\N	mm	0.001	meter	\N	.001 meters
millimetersPerSecond	millimetersPerSecond	f	speed	mm/s	0.001	metersPerSecond	\N	millimeters per second
millimolesPerGram	millimolesPerGram	f	amountOfSubstanceWeight	\N	1	molesPerKilogram	\N	millimoles per gram
millimolesPerSquareMeterPerHour	millimolesPerSquareMeterPerHour	t	amountOfSubstanceWeightFlux	mmol/m^2/hr	1	\N	\N	millimoles per square meter per hour (areal flux or diffusion of a substance)
millisecond	millisecond	f	\N	msec	0.001	second	\N	1/1000 of a second
millivolt	millivolt	f	potentialDifference	mV	0.001	volt	\N	millivolt
milliwatt	milliwatt	f	power	mW	0.001	watt	\N	milliwatt
minute	minute	f	\N	min	60	second	\N	60 seconds
molality	molality	f	amountOfSubstanceWeight	m	1	\N	\N	molality = moles/kg
molarity	molarity	f	amountOfSubstanceConcentration	M	1000	molesPerCubicMeter	\N	molarity = moles/liter
mole	mole	f	amount	mol	1	\N	\N	SI unit of substance amount
molePerCubicMeter	molePerCubicMeter	f	amountOfSubstanceConcentration	\N	1	\N	\N	mole per cubic meter
molesPerGram	molesPerGram	f	amountOfSubstanceWeight	\N	1000	molesPerKilogram	\N	moles per gram
molesPerKilogram	molesPerKilogram	f	amountOfSubstanceWeight	\N	1	\N	\N	moles per kilogram
molesPerKilogramPerSecond	molesPerKilogramPerSecond	f	amountOfSubstanceWeightFlux	\N	1	\N	\N	moles per kilogram per second
nanogram	nanogram	f	mass	ng	0.000000000001	kilogram	\N	0.000000000001 kg
nanometer	nanometer	f	\N	nm	0.000000001	meter	\N	.000000001 meters
nanomolesPerGramPerSecond	nanomolesPerGramPerSecond	f	amountOfSubstanceWeightFlux	\N	0.000001	molesPerKilogramPerSecond	\N	nanomoles Per Gram Per Second
nanosecond	nanosecond	f	\N	nsec	0.000000001	second	\N	1/1000000 of a second
nauticalMile	nauticalMile	f	\N	\N	1852	meter	\N	nautical mile
newton	newton	f	force	N	1	\N	\N	newton
nominalDay	nominalDay	f	time	\N	86400	second	\N	one day excluding leap seconds, 86400 seconds
nominalHour	nominalHour	f	time	\N	3600	second	\N	one hour excluding leap seconds, 3600 seconds
nominalLeapYear	nominalLeapYear	f	time	\N	31622400	second	\N	one 366 day year excluding leap seconds, 31622400 seconds
nominalMinute	nominalMinute	f	time	\N	60	second	\N	one minute excluding leap seconds, 60 seconds
nominalWeek	nominalWeek	f	time	\N	604800	second	\N	one day excluding leap seconds, 604800 seconds
nominalYear	nominalYear	f	time	\N	31536000	second	\N	one year excluding leap seconds and leap days, 31536000 seconds
numberPerGram	numberPerGram	f	massSpecificCount	\N	1	\N	\N	number of entities per gram
numberPerKilometerSquared	numberPerKilometerSquared	f	arealDensity	\N	0.000001	numberPerMeterSquared	\N	number per kilometer squared
numberPerMeterCubed	numberPerMeterCubed	f	volumetricDensity	\N	1	\N	\N	number per meter cubed
numberPerMeterSquared	numberPerMeterSquared	f	arealDensity	\N	1	\N	\N	number per meter squared
numberPerMilliliter	numberPerMilliliter	t	volumetricDensity	number/ml	1	\N	\N	number of particles or organisms per milliliter of solution
numberPerSquareCentimeterPerHour	numberPerSquareCentimeterPerHour	t	frequency	number/cm^2/hr	1	\N	\N	rate of change of areal density of a substance (e.g. growth or expulsion rate)
ohm	ohm	f	resistance	O	1	\N	\N	ohm
ohmMeter	ohmMeter	f	resistivity	Om	1	\N	\N	ohm meters
partsPerMillion	partsPerMillion	t	dimensionless	ppm	1	\N	\N	ratio of two quantities as parts per million (1:1000000)
partsPerThousand	partsPerThousand	t	dimensionless	ppt	1	\N	\N	ratio of two quantities as parts per thousand (1:1000)
pascal	pascal	f	pressure	Pa	1	\N	\N	pascal
percent	percent	t	dimensionless	%	1	\N	\N	ratio of two quantities as percent composition (1:100)
picoCuriesPerGram	picoCuriesPerGram	t	radionucleotideActivity	pCi/g	\N	\N	\N	pCi/g = 1E-12 Curies per gram of sample, equal to 2.22 radioactive disintegrations per minute per gram of sample
picoMolesPerLiter	picoMolesPerLiter	t	amountOfSubstanceConcentration	pM	0.000000000001	molarity	\N	picomoles per liter of solution
picoMolesPerLiterPerHour	picoMolesPerLiterPerHour	t	amountOfSubstanceWeightFlux	pmol/L/hr	1	\N	\N	picomoles per liter of solution per hour (concentration flux)
pint	pint	f	\N	pint	0.473176	liter	\N	US liquid pint
pound	pound	f	\N	lbs	0.4536	kilogram	\N	1 pound in the Avoirdupois (commerce) scale
poundsPerSquareInch	poundsPerSquareInch	f	arealMassDensity	lbs/in²	17.85	kilogramsPerSquareMeter	\N	lbs/square inch
quart	quart	f	\N	qt	0.946353	liter	\N	US liquid quart
radian	radian	f	angle	rad	1	\N	\N	2 pi radians comprise a unit circle.
second	second	f	time	sec	1	\N	\N	SI unit of time
serialDateNumberYear0000	serialDateNumberYear0000	t	dimensionless	\N	1	\N	\N	fractional days representing a serial date number based on 1 = 1-Jan-0000
siemen	siemen	f	conductance	S	1	\N	\N	siemen
siemensPerMeter	siemensPerMeter	t	conductance	S/m	1	\N	\N	siemens per meter (electrolytic conductivity of a solution)
sievert	sievert	f	doseEquivalent	Sv	1	\N	\N	sievert
squareCentimeters	squareCentimeters	f	area	\N	0.0001	squareMeter	\N	square centimeters
squareFoot	squareFoot	f	area	ft²	0.092903	squareMeter	\N	12 inches squared
squareKilometers	squareKilometers	f	area	\N	1000000	squareMeter	\N	square kilometers
squareMeter	squareMeter	f	area	m²	1	\N	\N	square meters
squareMeterPerKilogram	squareMeterPerKilogram	f	specificArea	m²/kg	1	\N	\N	square meters per kilogram
squareMile	squareMile	f	area	mile²	2589998.49806	squareMeter	\N	1 mile squared
squareMillimeters	squareMillimeters	f	area	\N	0.000001	squareMeter	\N	square millmeters
squareYard	squareYard	f	area	yd²	0.836131	squareMeter	\N	36 inches squared
tesla	tesla	f	magneticFluxDensity	T	1	\N	\N	tesla
ton	ton	f	\N	ton	907.1999	kilogram	\N	standard US (short) ton = 2000 lbs
tonne	tonne	f	mass	T	1000	kilogram	\N	metric ton or tonne
tonnePerHectare	tonnePerHectare	f	arealMassDensity	\N	0.1	kilogramsPerSquareMeter	\N	metric ton or tonne per hectare
tonnesPerYear	tonnesPerYear	f	massFlux	\N	0.0000317	kilogramsPerSecond	\N	tonnes Per Year
volt	volt	f	potentialDifference	V	1	\N	\N	volt
watt	watt	f	power	W	1	\N	\N	watt = J/s
waveNumber	waveNumber	f	lengthReciprocal	\N	1	\N	\N	1/meters
weber	weber	f	magneticFlux	Wb	1	\N	\N	weber
yard	yard	f	\N	yard	0.9144	meter	\N	3 feet
Yard_Indian	Yard_Indian	f	\N	\N	0.914398530744440774	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
Yard_Sears	Yard_Sears	f	\N	\N	0.91439841461602867	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
yardsPerSecond	yardsPerSecond	f	speed	yd/s	0.9144	metersPerSecond	\N	yards per second
angstrom	angstrom	f	\N	\N	0.0000000001	meter	\N	1/10000000000 meter
meterSquared	meterSquared	t	area	m2	1	meter	0	area, meter squared from the LTER unit dictionary
numberPerLiter	numberPerLiter	t	volumetricDensity		0.001	numberPerMeterCubed	0	number of entities per liter
gramPerMeterCubed	gramPerMeterCubed	t	massDensity	g m-3	0.001	kilogramPerMeterCibed	0	gram per cubic meter
gramPerMeterSquared	gramPerMeterSquared	t	arealMassDensity	g/m2	0.001	kilogramsPerSquareMeter	0	grams per square meter
kilogramPerMeterSquared	kilogramPerMeterSquared	f	arealMassDensity	kg/m2	1	kilogramPerMeterSquared	\N	kilograms per square meter
kilogramPerMeterCubed	kilogramPerMeterCubed	f	massDensity	kg/m3	1	kilogramPerMeterCubed	\N	kilograms per cubit meter
micromolePerMeterSquared	micromolePerMeterSquared	f	amountOfSubstanceConcentration	umol/m2	0.000001	molePerMeterSquared	1	commonly used for integrated concentration of chemical constituents in natural water bodies
permil	permil	t	dimensionless	o/oo	0.001	\N	0	permil is a shorthand way of saying parts per thousand parts. values must have the same dimensions.
picomolePerLiterPerHour	picomolePerLiterPerHour	t	amountOfSubstanceWeightFlux	pmol/L/hr	\N	\N	\N	picomoles per liter of solution per hour (concentration flux)
hectoPascal	hectoPascal	t	pressure	hPa	\N	pascal	\N	SI unit for atmospheric pressure, equivalent in magnitude to millibar
reciprocalDay	reciprocalDay	t	timeReciprocal	day^-1	\N	second	\N	per day, specific growth rate
reciprocalMeterPerSteradian	reciprocalMeterPerSteradian	t	lengthReciprocal	m-1 sr-1	\N	meterPerSteradian	\N	describes directional optical measurements
reciprocalMeter	reciprocalMeter	t	lengthReciprocal	m-1	\N	meter	\N	per meter, describes optical properties
microwattPerSquareCentimeterPerNanometer	microwattPerSquareCentimeterPerNanometer	t	power	\N	\N	joule	\N	irradiance unit
wattPerMeterSquared	wattPerMeterSquared	t	power	\N	\N	\N	\N	irradiance unit
microwattPerCentimeterSquaredPerNanometerPerSteradian	microwattPerCentimeterSquaredPerNanometerPerSteradian	t	power	\N	\N	joule	\N	directional irradiance unit
milligramPerMeterCubed	milligramPerMeterCubed	t	volumetricMassDensity	\N	\N	kilogramPerMeterCubed	0	concentration unit, sometimes used for pigments in natural waters.same magnitude as microgramPerLiter
milligramPerMeterCubedPerDay	milligramPerMeterCubedPerDay	t	volumetricMassDensityRate	mg m-3 d-1	\N	kilogramPerMeterCubedPerSecond	0	a volumetric flux unit. often used for a primary production rate, e.g., for a parcel of water. Often is specific to an element, e.g., carbon
micromolePerLiter	micromolePerLiter	t	amountOfSubstanceConcentration	\N	\N	molePerMeterCubed	0	commonly used for concentration of some chemical constituents of natural water bodies, e.g., nutrients. It has the same magnitude as micromolar, but micromolar can only be used for a dissolved constituent
milligramPerLiter	milligramPerLiter	t	volumetricMassDensity	\N	\N	kilogramPerCubicMeter	0	concentration unit, sometimes used for pigments in natural waters
microgramPerLiter	microgramPerLiter	t	\N	\N	\N	gramPerMeterCubed	0	concentration unit. Based on the dimensions (mass/volume), the unitType is probably density, but this would be misleading, so it is left NULL here.
microeinsteinPerMeterSquaredPerSecond	microeinsteinPerMeterSquaredPerSecond	t	energy	\N	\N	joule	\N	PAR irradiance unit, Seabird 911. 1Ein = energy of 1 mole photons
microeinsteinPerCentimeterSquaredPerSecond	microeinsteinPerCentimeterSquaredPerSecond	t	energy	\N	\N	joule	\N	PAR irradiance unit, 1Ein = energy of 1 mole photons
kilogramPerMeterSquaredPerDay	kilogramPerMeterSquaredPerDay	t	areaMassDensityRate	kg m-2 d-1	\N	kilogramPerMeterCubed	0	areal primary production rate, may apply to DW, or to element content, e.g., Carbon or Nitrogen"
inchesMercury	inchesMercury	t	pressure	inHg	\N	inch	\N	old unit for atmospheric pressure
siemensPerCentimeter	siemensPerCentimeter	t	conductance	\N	\N	siemensPerMeter	0	conductivity unit, seawater, A siemems is equal to one ampere per volt.
microequivalentPerLiter	microequivalentPerLiter	t	amountOfSubstanceConcentration	\N	\N	molesPerMeterCubed	0	concentration of charge (on dissolved ions). A single ultiplier to SI is not possible, since conversion includes valence of ion, which can vary
micromolePerKilogram	micromolePerKilogram	t	\N	\N	\N	molePerKilogram	0	a concentration unit used in oceanography. volume changes with depth, but mass does not. Not sure what the unitType should be.
milligramPerMeterSquaredPerDay	milligramPerMeterSquaredPerDay	t	areaMassDensityRate	mg m-2 d-1	\N	kilogramPerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for an integrated water column. May have context of dry weight, or specific to an element, e.g., carbon
millimolePerMeterSquaredPerHour	millimolePerMeterSquaredPerHour	t	\N	mmol m-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. 
molePerMeterSquaredPerDay	molePerMeterSquaredPerDay	t	\N	mmol m-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit, moles (of an element) per day.
millimolePerMeterCubed	millimolePerMeterCubed	t	\N	mmol m-2 h-1	\N	molePerMeterCubed	0	a concentration unit..
numberPerNumber	numberPerNumber	t	numberPerNumber		\N	gramsPerGram	\N	ratio with no scaling,
microgramPerMeterSquared	microgramPerMeterSquared	f	arealDensity	ug/m2	0.000000001	kilogramPerMeterSquared	1	used for integrated concentration of chemical constituents when measuered by weight, eg, pigments.
micromolePerMeterSquaredPerDay	micromolePerMeterSquaredPerDay	f	amountOfSubstanceWeightFlux	umol/m2/day	0.000001	molePerMeterSquaredPerDay	1	areal uptake rate
micromolePerMeterSquaredPerSecond	micromolePerMeterSquaredPerSecond	f	amountOfSubstanceWeightFlux	umol/m2/sec	0.000001	molePerMeterSquaredPerSecond	1	areal flux rate
biomassDensityUnitPerAbundanceUnit	biomassDensityUnitPerAbundanceUnit	f	\N	\N	\N	\N	\N	a ratio of two other units
milligramPerMeterSquaredPerHourPerGram	milligramPerMeterSquaredPerHourPerGram	f	\N	\N	\N	\N	\N	specifc areal flux rate
productionRatePerGramPerIrradiance	productionRatePerGramPerIrradiance	f	\N	\N	\N	\N	\N	slope of a PI curve
gramPerMeterSquaredPerDay	gramPerMeterSquaredPerDay	f	massFlux	g/m2/day	\N	\N	\N	\N
literPerHectare	literPerHectare	f	volumetricArea	\N	0.0001	litersPerSquareMeter	\N	liters per hectare
literPerSecond	literPerSecond	f	volumetricRate	l/s	1	\N	\N	liters per second
centimeterPerSecond	centimeterPerSecond	f	speed	cm/s	0.01	metersPerSecond	\N	centimeters per second
gramPerGram	gramPerGram	f	massPerMass	g/g	\N	\N	\N	\N
meterPerSecond	meterPerSecond	f	speed	m/s	\N	\N	\N	\N
kilometerSquared	kilometerSquared	f	area	\N	\N	\N	\N	\N
numberPer85CentimeterSquaredPerDay	numberPer85CentimeterSquaredPerDay	t	arealDensityRate	\N	\N	\N	\N	number of organisms (things) per area of 85 cm squared per day
number	number	f	dimensionless	\N	\N	\N	\N	a number
dimensionless	dimensionless	f	dimensionless	\N	\N	\N	\N	a designation asserting the absence of an associated unit
acre	acre	f	area	a	4046.8564	squareMeter	\N	1 acre = 4046.8564 square meters or 1 hectare = 2.4710 acres
TODO	TODO	t	\N	TODO	TODO	TODO	TODO	TODO
millimolePerMeterSquaredPerDay	millimolePerMeterSquaredPerDay	t	\N	mmol/m^2/day	1	mole	0	millimole per square meter per day
milliMolesPerKilogram	milliMolesPerKilogram	t	amountOfSubstanceConcentration	mmol/kg	1	\N	\N	mmol/kg = millimoles per kilogram of substance. used in seawater to factor out changes in volume with depth.
centimeterSquared	centimeterSquared	f	area	cm2	.0001	meterSquared	\N	\N
becquerelPerLiter	becquerelPerLiter	f	radioactivity	Bq/L	0.000001	becquerelPerMeterCubed	\N	One Becquerel (Bq) is defined as the activity of a quantity of radioactive material in which one nucleus decays per second. The Bq unit is therefore equivalent to an inverse second, s^1.  (Wikipedia)
microatmosphere	microatmosphere	t	pressure	microatm	0.101325	pascal	0	1 microAtmosphere = 0.000001 atmospheres = 1013.25 millibars = 0.101325 Pascals = 0.0000147 lb/sq.in
milligramPerCentimeterSquared	milligramPerCentimeterSquared	f	arealMassDensity	mg/cm2	0.01	kilogramPerMeterSquared	\N	\N
microgramPerCentimeterSquared	microgramPerCentimeterSquared	f	arealMassDensity	ug/cm2	0.0001	kilogramPerMeterSquared	\N	\N
numberPerMicroliter	numberPerMicroliter	t	volumetricDensity	number/ul	1	\N	\N	number of particles or organisms per microliter of solution
micromolePerCentimeterSquaredPerHourPerPhotonFlux	micromolePerCentimeterSquaredPerHourPerPhotonFlux	t	arealDensityRate	(umol cm-2 h-1)/(umol m-2 s-1)	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for a sample of plant tissue. May have context of dry weight, or specific to an element, e.g., carbon
kilogramPerHour	kilogramPerHour	f	massFlux	kg/hr	1	\N	\N	kilograms per hour
millisiemensPerMeter	millisiemensPerMeter	f	conductance	mS/m	0.001	siemensPerMeter	0	asdfasdfasdfasdfasdf
gramPerCentimeterSquared	gramPerCentimeterSquared	t	arealMassDensity	g/cm2	0.0000001	kilogramsPerSquareMeter	0	grams per square centimeter
kilogramPerHourPerPerson	kilogramPerHourPerPerson	f	\N	kg/hr/person	1	\N	\N	kilograms per hour, per person, eg, person performing work 
milligramPerGramPerHour	milligramPerGramPerHour	f	\N	mg g-1 h-1	.001	kilogramPerKilogramPerHour	\N	mass-specific rate
micromolePerCentimeterSquaredPerHour	micromolePerCentimeterSquaredPerHour	t	arealDensityRate	umol cm-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for a sample of plant tissue. May have context of dry weight, or specific to an element, e.g., carbon
milligramPerGramPerHourPerPhotonFlux	milligramPerGramPerHourPerPhotonFlux	f	\N	(mg g-1 h-1)/(umol m-2 s-1)	.001	kilogramPerKilogramPerHourPerPhotonFlux	\N	flux-specific mass-specific rate
gramPerOneTenthMeterSquared	gramPerOneTenthMeterSquared	t	arealMassDensity	g/0.1m^2	\N	\N	\N	Grams per 0.1 square meter surface area
metricTon	metricTon	f	mass	T	1000	kilogram	\N	metric ton or tonne
microMolesPerGramPerHour	microMolesPerGramPerHour	t	amountOfSubstanceWeightFlux	µmol/g/h	0.000000001	molePerKilogramPerHour	\N	µmol/g/h= µmoles per gram of substance per hour
microMolesPerLiterPerHour	microMolesPerLiterPerHour	t	amountOfSubstanceWeightFlux	µmol/l/h	0.000001	molePerLiterPerHour	\N	µmol/l/h = µmoles per liter of solution per hour
microMolesPerLiter	microMolesPerLiter	t	amountOfSubstanceConcentration	µM/l	0.000001	\N	\N	µM = µmoles per liter of solution
kilogramPerDay	kilogramPerDay	t	massFlux	kg/day	1	\N	\N	kilograms per day
numberPerDay	numberPerDay	t	massPerMassRate	number/day	1	\N	\N	rate per day
kilogramPerMole	kilogramPerMole	f	\N	Kg/mol	1	\N	\N	kilogram per mole
\.


--
-- TOC entry 3456 (class 0 OID 112117)
-- Dependencies: 221
-- Data for Name: EMLUnitTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLUnitTypes" (id, name, dimension_name, dimension_power) FROM stdin;
acceleration	acceleration	length	-2
amount	amount	amount	\N
amountOfSubstanceConcentration	amountOfSubstanceConcentration	amount	-3
amountOfSubstanceWeight	amountOfSubstanceWeight	amount	-1
amountOfSubstanceWeightFlux	amountOfSubstanceWeightFlux	amount	-1
angle	angle	angle	\N
area	area	length	2
arealDensity	arealDensity	dimensionless	-2
arealMassDensity	arealMassDensity	mass	-2
arealMassDensityRate	arealMassDensityRate	mass	-2
capacitance	capacitance	mass	-1
catalyticActivity	catalyticActivity	time	-1
charge	charge	charge	\N
conductance	conductance	mass	-1
current	current	charge	-1
currentDensity	currentDensity	charge	-1
dimensionless	dimensionless	dimensionless	\N
doseEquivalent	doseEquivalent	time	-2
energy	energy	mass	2
force	force	mass	-2
frequency	frequency	time	-1
illuminance	illuminance	luminosity	-2
inductance	inductance	mass	2
length	length	length	\N
lengthReciprocal	lengthReciprocal	length	-1
luminance	luminance	luminosity	-2
luminosity	luminosity	luminosity	\N
magneticFieldStrength	magneticFieldStrength	charge	-1
magneticFlux	magneticFlux	mass	2
magneticFluxDensity	magneticFluxDensity	mass	-1
mass	mass	mass	\N
massDensity	massDensity	mass	-3
massFlux	massFlux	mass	-1
massPerMass	massPerMass	mass	-1
massSpecificCount	massSpecificCount	dimensionless	-1
massSpecificLength	massSpecificLength	length	-1
potentialDifference	potentialDifference	mass	2
power	power	mass	2
pressure	pressure	mass	-2
radionucleotideActivity	radionucleotideActivity	time	-1
resistance	resistance	mass	2
resistivity	resistivity	mass	3
specificArea	specificArea	mass	-1
specificEnergy	specificEnergy	time	-2
specificVolume	specificVolume	mass	-1
speed	speed	length	-1
temperature	temperature	temperature	\N
time	time	time	\N
transmissivity	transmissivity	length	2
volume	volume	length	3
volumePerVolume	volumePerVolume	length	3
volumetricArea	volumetricArea	length	3
volumetricDensity	volumetricDensity	dimensionless	-3
volumetricMassDensityRate	volumetricMassDensityRate	mass	-3
volumetricRate	volumetricRate	length	3
NULL	Null unit type	Null	0
timeReciprocal	timeReciprocal	time	-1
numberPerNumber	numberPerNumber	count	1
volumetricMassDensity	volumetricMassDensity	mass	\N
areaMassDensityRate	areaMassDensityRate	mass	\N
arealDensityRate	arealDensityRate	area	\N
massPerMassRate	massPerMassRate	mass	-1
massRate	massRate	mass	-1
massDensityRate	massDensityRate	mass	-1
amountOfSubstanceFlux	amountOfSubstanceFlux	amount	-1
radioactivity	radioactivity	time	-1
molePerMeterSquaredPerSecond	molePerMeterSquaredPerSecond	amount	\N
\.


--
-- TOC entry 3457 (class 0 OID 112120)
-- Dependencies: 222
-- Data for Name: ListCodes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListCodes" ("CodeID", "Code", "CodeExplanation") FROM stdin;
1	-99999	no information available
2	-99999	value not recorded or not available
3	-99999	not available, or not collected
4	-998	no measurement available, satellite view obscured by clouds
enum.ABUR	ABUR	Arroyo Burro
enum.NAPL	NAPL	Naples
enum.AQUE15	AQUE	Arroyo Quemado.
enum.GOLB	GOLB	Goleta Bay
enum.SCTW	SCTW	Santa Cruz Island, Twin Harbor West Reef
enum.SCDI	SCDI	Santa Cruz Island, Diablo 
enum.CARP	CARP	Carpinteria
enum.terminal	terminal	Frond has reached terminal size
enum.1	1	Sample replicate 1
enum.IVEE	IVEE	Isla Vista
enum.2	2	Sample replicate 2
enum.AQUE14	AQUE	Arroyo Quemado
enum.MOHK	MOHK	Mohawk
enum.AHND	AHND	Arroyo Hondo
enum.BULL	BULL	Bulito
enum.growing	growing	Frond is still growing
\.


--
-- TOC entry 3458 (class 0 OID 112126)
-- Dependencies: 223
-- Data for Name: ListKeywordThesauri; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListKeywordThesauri" ("ThesaurusID", "ThesaurusLabel", "ThesaurusUrl", "UseInMetadata", "ThesaurusSortOrder") FROM stdin;
dwc	Darwin Core Terms	\N	t	100
ea	Ecological Archives	\N	t	90
ebv	Essential Biodiversity Variables	\N	t	80
gcmd6	Global Change Master Directory (GCMD) v6.0.0.0.0	\N	t	50
knb	Knowledge Network for Biocomplexity	\N	t	60
nbii	NBII Biocomplexity	\N	t	80
none	\N	\N	t	110
lter_cv	LTER Controlled Vocabulary v1	\N	t	20
lter_cv_cra	LTER Core Research Areas	\N	t	10
sbclter	SBC-LTER Controlled Vocabulary	\N	t	30
sbclter_place	Santa Barbara Coastal LTER Places	\N	t	40
\.


--
-- TOC entry 3459 (class 0 OID 112133)
-- Dependencies: 224
-- Data for Name: ListKeywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListKeywords" ("Keyword", "ThesaurusID", "KeywordType") FROM stdin;
abundance	lter_cv	theme
acidity	lter_cv	theme
Air Temperature	lter_cv	theme
algae	lter_cv	theme
alkalinity	lter_cv	theme
ammonium	lter_cv	theme
aquatic invertebrates	lter_cv	theme
Atmospheric Pressure	lter_cv	theme
benthic	lter_cv	theme
biomass	lter_cv	theme
canopy	lter_cv	theme
carbon	lter_cv	theme
carbon dioxide	lter_cv	theme
carbon to nitrogen ratio	lter_cv	theme
chemistry	lter_cv	theme
chlorophyll	lter_cv	theme
chlorophyll a	lter_cv	theme
Climate	lter_cv	theme
community composition	lter_cv	theme
community dynamics	lter_cv	theme
community patterns	lter_cv	theme
community respiration	lter_cv	theme
community structure	lter_cv	theme
crabs	lter_cv	theme
CTD	lter_cv	theme
depth	lter_cv	theme
detritus	lter_cv	theme
Dew point	lter_cv	theme
dissolved inorganic carbon	lter_cv	theme
dissolved organic carbon	lter_cv	theme
distribution	lter_cv	theme
ecosystem ecology	lter_cv	theme
endangered species	lter_cv	theme
fertilization	lter_cv	theme
fishes	lter_cv	theme
forests	lter_cv	theme
Freshwater	lter_cv	theme
gastropods	lter_cv	theme
genetics	lter_cv	theme
growth	lter_cv	theme
herbivores	lter_cv	theme
humans	lter_cv	theme
hydrology	lter_cv	theme
incubation	lter_cv	theme
invertebrates	lter_cv	theme
irradiance	lter_cv	theme
kelp	lter_cv	theme
larvae	lter_cv	theme
length	lter_cv	theme
light	lter_cv	theme
long term	lter_cv	theme
long term ecological research	lter_cv	theme
LTER	lter_cv	theme
macroalgae	lter_cv	theme
macroinvertebrates	lter_cv	theme
marine	lter_cv	theme
mass	lter_cv	theme
measurements	lter_cv	theme
mollusks	lter_cv	theme
Moorea Coral Reef LTER	lter_cv	theme
net primary production	lter_cv	theme
nitrate	lter_cv	theme
nitrite	lter_cv	theme
nitrogen	lter_cv	theme
nutrients	lter_cv	theme
oceans	lter_cv	theme
organism	lter_cv	theme
oxygen	lter_cv	theme
particulate organic carbon	lter_cv	theme
percent cover	lter_cv	theme
pH	lter_cv	theme
phosphate	lter_cv	theme
phosphorus	lter_cv	theme
photosynthesis	lter_cv	theme
photosynthetically active radiation	lter_cv	theme
phytoplankton	lter_cv	theme
population dynamics	lter_cv	theme
populations	lter_cv	theme
precipitation	lter_cv	theme
predation	lter_cv	theme
predators	lter_cv	theme
productivity	lter_cv	theme
respiration	lter_cv	theme
salinity	lter_cv	theme
sand	lter_cv	theme
Santa Barbara Coastal	lter_cv	theme
seasonality	lter_cv	theme
seawater	lter_cv	theme
size	lter_cv	theme
soluble reactive phosphorus	lter_cv	theme
spatial variability	lter_cv	theme
species	lter_cv	theme
species composition	lter_cv	theme
stage height	lter_cv	theme
standing crop	lter_cv	theme
stream discharge	lter_cv	theme
streams	lter_cv	theme
surveys	lter_cv	theme
temperature	lter_cv	theme
terrestrial	lter_cv	theme
total nitrogen	lter_cv	theme
total phosphorus	lter_cv	theme
transects	lter_cv	theme
trophic dynamics	lter_cv	theme
trophic structure	lter_cv	theme
water	lter_cv	theme
wind	lter_cv	theme
wind direction	lter_cv	theme
wind speed	lter_cv	theme
disturbance	lter_cv_cra	theme
Disturbance Patterns	lter_cv_cra	theme
inorganic matter and flux	lter_cv_cra	theme
inorganic nutrients	lter_cv_cra	theme
organic matter	lter_cv_cra	theme
populations	lter_cv_cra	theme
primary production	lter_cv_cra	theme
McMurdo Sound	none	place
Moorea Coral Reef	none	place
AB00	sbclter_place	place
ALE	sbclter_place	place
Alegria	sbclter_place	place
Anacapa Island	sbclter_place	place
ARB	sbclter_place	place
ARQ	sbclter_place	place
Arroyo Burro	sbclter_place	place
Arroyo Burro Beach	sbclter_place	place
Arroyo Burro Reef	sbclter_place	place
Arroyo Hondo	sbclter_place	place
Arroyo Hondo Reef	sbclter_place	place
Arroyo Quemado	sbclter_place	place
Arroyo Quemado Beach	sbclter_place	place
Arroyo Quemado Reef	sbclter_place	place
AT07	sbclter_place	place
Atascadero	sbclter_place	place
Baja California	sbclter_place	place
BARONRANCH262	sbclter_place	place
BC02	sbclter_place	place
Bullito	sbclter_place	place
Bullito Reef	sbclter_place	place
Cambria	sbclter_place	place
CAR	sbclter_place	place
Carpenteria Reef	sbclter_place	place
Carpinteria	sbclter_place	place
CARPINTERIA208	sbclter_place	place
Carpinteria City Beach	sbclter_place	place
Carpinteria Reef	sbclter_place	place
CATERWTP229	sbclter_place	place
Central California	sbclter_place	place
Coal Oil Point	sbclter_place	place
COLDSPRINGS210	sbclter_place	place
CP00	sbclter_place	place
CP201	sbclter_place	place
DOSPUEBLOS226	sbclter_place	place
DOULTONTUNNEL231	sbclter_place	place
DV01	sbclter_place	place
East UCSB Campus Beach	sbclter_place	place
EDISONTRAIL252	sbclter_place	place
EL201	sbclter_place	place
EL202	sbclter_place	place
El Capitan State Beach	sbclter_place	place
ELDESEO255	sbclter_place	place
Ellwood	sbclter_place	place
Ellwood Pier	sbclter_place	place
FK00	sbclter_place	place
Gaviota	sbclter_place	place
Gaviota Pier	sbclter_place	place
Gaviota State Beach	sbclter_place	place
GB201	sbclter_place	place
Goleta Bay	sbclter_place	place
Goleta Bay Reef	sbclter_place	place
GOLETARDYARD211	sbclter_place	place
GV01	sbclter_place	place
GV201	sbclter_place	place
GV202	sbclter_place	place
Haskells Beach	sbclter_place	place
HO00	sbclter_place	place
HO201	sbclter_place	place
HO202	sbclter_place	place
Isla Vista	sbclter_place	place
Isla Vista Reef	sbclter_place	place
Isla Vista West Beach	sbclter_place	place
KTYD227	sbclter_place	place
Lompoc Landing	sbclter_place	place
Los Angeles County	sbclter_place	place
Maria Ygnacio	sbclter_place	place
MC00	sbclter_place	place
MC06	sbclter_place	place
Mendocino	sbclter_place	place
Mission	sbclter_place	place
MKO	sbclter_place	place
Mohawk	sbclter_place	place
Mohawk Reef	sbclter_place	place
NAP	sbclter_place	place
Naples	sbclter_place	place
Naples Reef	sbclter_place	place
NOJOQUI236	sbclter_place	place
Ocean Beach	sbclter_place	place
ON02	sbclter_place	place
Orange County	sbclter_place	place
Point Cabrillo	sbclter_place	place
Purissima	sbclter_place	place
Razors	sbclter_place	place
Refugio	sbclter_place	place
Refugio State Beach	sbclter_place	place
RG01	sbclter_place	place
RG201	sbclter_place	place
RG202	sbclter_place	place
RG203	sbclter_place	place
RG204	sbclter_place	place
RN01	sbclter_place	place
RS02	sbclter_place	place
San Clemente Island	sbclter_place	place
San Diego	sbclter_place	place
San Diego County	sbclter_place	place
San Jose	sbclter_place	place
SANMARCOSPASS212	sbclter_place	place
San Miguel Island	sbclter_place	place
San Nicolas Island	sbclter_place	place
Santa Barbara	sbclter_place	place
Santa Barbara Channel Islands	sbclter_place	place
Santa Barbara County	sbclter_place	place
Santa Barbara Island	sbclter_place	place
Santa Catalina Island	sbclter_place	place
Santa Clara	sbclter_place	place
Santa Claus Lane Beach	sbclter_place	place
Santa Cruz Island	sbclter_place	place
Santa Cruz Island, Diablo	sbclter_place	place
Santa Cruz Island Diablo Reef	sbclter_place	place
Santa Cruz Island, Prisoners Harbor	sbclter_place	place
Santa Cruz Island, Twin Harbor West	sbclter_place	place
Santa Cruz Island Twin Harbor West Reef	sbclter_place	place
Santa Rosa Island	sbclter_place	place
SBENGBLDG234	sbclter_place	place
SCCOOS Shore Station	sbclter_place	place
Scripps	sbclter_place	place
SM01	sbclter_place	place
SM04	sbclter_place	place
Southern California	sbclter_place	place
South UCSB Campus Beach	sbclter_place	place
SP02	sbclter_place	place
STANWOODFS228	sbclter_place	place
Stearns Wharf	sbclter_place	place
TE03	sbclter_place	place
Tecolotito	sbclter_place	place
TROUTCLUB242	sbclter_place	place
UCSB200	sbclter_place	place
Ventura	sbclter_place	place
Ventura County	sbclter_place	place
amphipod	none	taxonomic
Anisocladella pacifica	none	taxonomic
Articulated Corallines	none	taxonomic
Azolla	none	taxonomic
Bossiella orbigniana	none	taxonomic
Botryocladia pseudodichotoma	none	taxonomic
Brown algae	none	taxonomic
California Spiny Lobster	none	taxonomic
Callophyllis flabellulata	none	taxonomic
caprellid	none	taxonomic
Chara	none	taxonomic
Chondracanthus corymbifera	none	taxonomic
Chondracanthus spinosa	none	taxonomic
Cladophora	none	taxonomic
Cladophora graminea	none	taxonomic
Codium	none	taxonomic
Corallina chilensis	none	taxonomic
Corallina officinalis	none	taxonomic
crustaceans	none	taxonomic
Crustose green algae	none	taxonomic
Cryptopleura ruprechtiana	none	taxonomic
Cystoseira	none	taxonomic
Cystoseira osmundacea	none	taxonomic
Desmarestia	none	taxonomic
Desmarestia ligulata	none	taxonomic
diatoms	none	taxonomic
Dictyopteris	none	taxonomic
Dictyota	none	taxonomic
echinoderms	none	taxonomic
Ectocarpaceae	none	taxonomic
Egregia	none	taxonomic
Egregia menziesii	none	taxonomic
Egregia menziesii (Feather boa kelp)	none	taxonomic
Eisenia arborea	none	taxonomic
Eisenia arborea (Southern sea palm)	none	taxonomic
Embiotoca jacksoni (Black surfperch)	none	taxonomic
Embiotoca lateralis (Striped surfperch)	none	taxonomic
Encrusting Corallines	none	taxonomic
Enhydra lutris	none	taxonomic
Fauchea	none	taxonomic
Filamentous Red Algal Turf	none	taxonomic
Fryella	none	taxonomic
gammarid	none	taxonomic
Gelidium	none	taxonomic
Gelidium nudifrons	none	taxonomic
Gelidium robustum	none	taxonomic
giant kelp	none	taxonomic
Gigartina	none	taxonomic
Gracilaria	none	taxonomic
Gracilaria spp.	none	taxonomic
Green algae	none	taxonomic
Halidrys	none	taxonomic
Halymenia	none	taxonomic
Halymenia spp.	none	taxonomic
Hypsypops rubicundus (Garibaldi)	none	taxonomic
idoteid	none	taxonomic
Iridaea	none	taxonomic
isopod	none	taxonomic
jaeropsid	none	taxonomic
Laminaria farlowii	none	taxonomic
Laminaria farlowii (Kelp)	none	taxonomic
Laminariales	none	taxonomic
Laurencia	none	taxonomic
Laurencia spectabalis	none	taxonomic
Lemna	none	taxonomic
Ludwigia	none	taxonomic
Macrocystis	none	taxonomic
Macrocystis pyrifera	none	taxonomic
Macrocystis pyrifera (Giant kelp)	none	taxonomic
Microcladia coulteri	none	taxonomic
Mougeotia	none	taxonomic
Nasturtium	none	taxonomic
Nienburgia andersoniana	none	taxonomic
Nostoc	none	taxonomic
Panulirus interruptus	none	taxonomic
Phyllospadix	none	taxonomic
Plocamium	none	taxonomic
polychaetes	none	taxonomic
Polyneura latissima	none	taxonomic
Polysiphonia	none	taxonomic
Prionitis lanceolata	none	taxonomic
Prionitis lanceolata (Red alga)	none	taxonomic
Pseudolithophyllum	none	taxonomic
Pterosiphonia dendroidea	none	taxonomic
Pterygophora californica	none	taxonomic
Pterygophora californica (Rock weed)	none	taxonomic
Pycnopodia helianthoides (sunflower sea star)	none	taxonomic
Red algae	none	taxonomic
Rhacochilus toxotes (Rubberlip surfperch)	none	taxonomic
Rhacochilus vacca (Pile surfperch)	none	taxonomic
Rhodymenia californica	none	taxonomic
Rhodymeniaceae	none	taxonomic
Sarcodiotheca furcata	none	taxonomic
Sarcodiotheca gaudichaudii	none	taxonomic
Sargassum	none	taxonomic
Sargassum filicinum	none	taxonomic
Sargassum horneri	none	taxonomic
Sciadaphycus stellatus	none	taxonomic
Scinaia confusa	none	taxonomic
Scytosiphon lomentaria	none	taxonomic
sea otters	none	taxonomic
Spirogyra	none	taxonomic
Strongylocentrotus purpuratus (Purple sea urchin)	none	taxonomic
Talitrid amphipod	none	taxonomic
Ulva spp.	none	taxonomic
Urchins	none	taxonomic
Zostera	none	taxonomic
giant kelp	ea	theme
growth rate	ea	theme
marine algae	ea	theme
net primary production	ea	theme
standing crop	ea	theme
advection	gcmd6	theme
algae	gcmd6	theme
Beaches	gcmd6	theme
Benthic habitat	gcmd6	theme
Carbon	gcmd6	theme
CODAR	gcmd6	theme
Discharge/Flow	gcmd6	theme
Dominant Species	gcmd6	theme
Eddies	gcmd6	theme
fish	gcmd6	theme
Irradiance	gcmd6	theme
Macroalgae	gcmd6	theme
Marine algae	gcmd6	theme
Marine Invertebrates	gcmd6	theme
Marine Plants	gcmd6	theme
Nitrogen Compounds	gcmd6	theme
Organic Matter	gcmd6	theme
Rivers/Streams	gcmd6	theme
runoff	gcmd6	theme
Stage Height	gcmd6	theme
Surface Water Chemistry	gcmd6	theme
Suspended Solids	gcmd6	theme
Upwelling/Downwelling	gcmd6	theme
Biomass	gcmd6	theme
Biomass Dynamics	gcmd6	theme
Air Temperature	gcmd6	theme
Atmospheric Pressure Measurements	gcmd6	theme
Dew Point	gcmd6	theme
Humidity	gcmd6	theme
Incoming Solar Radiation	gcmd6	theme
Longwave Radiation	gcmd6	theme
Maximum/Minimum Temperature	gcmd6	theme
Precipitation Amount	gcmd6	theme
Rain	gcmd6	theme
Solar Radiation	gcmd6	theme
Surface Pressure	gcmd6	theme
Surface Winds	gcmd6	theme
ammonia	gcmd6	theme
Attenuation/Transmission	gcmd6	theme
Chlorophyll	gcmd6	theme
Conductivity	gcmd6	theme
Density	gcmd6	theme
Fluorescence	gcmd6	theme
Nitrate	gcmd6	theme
Nitrite	gcmd6	theme
Nitrogen	gcmd6	theme
Nutrients	gcmd6	theme
Ocean Color	gcmd6	theme
Ocean Currents	gcmd6	theme
Organic Carbon	gcmd6	theme
Oxygen	gcmd6	theme
Phosphate	gcmd6	theme
Photosynthetically Active Radiation	gcmd6	theme
Pigments	gcmd6	theme
Potential Density	gcmd6	theme
precipitation amount	gcmd6	theme
Pressure	gcmd6	theme
Radon	gcmd6	theme
Salinity	gcmd6	theme
Scattering	gcmd6	theme
Sea Surface Temperature	gcmd6	theme
Silicate	gcmd6	theme
Stable Isotopes	gcmd6	theme
Surface Current Radar	gcmd6	theme
Tidal Currents	gcmd6	theme
Vorticity	gcmd6	theme
Water-leaving Radiance	gcmd6	theme
Water Temperature	gcmd6	theme
Wind-driven Circulation	gcmd6	theme
Ammonium	knb	theme
Biomass	knb	theme
Carbon	knb	theme
Chlorophyll	knb	theme
fish	knb	theme
Freshwater	knb	theme
invertebrate	knb	theme
Marine	knb	theme
Nitrate	knb	theme
Nutrients	knb	theme
Phosphate	knb	theme
Precipitation	knb	theme
Productivity	knb	theme
Radiation	knb	theme
Temperature	knb	theme
terrestrial	knb	theme
acidity	nbii	theme
adults	nbii	theme
age composition	nbii	theme
Age groups	nbii	theme
Age structure	nbii	theme
alkalinity	nbii	theme
alleles	nbii	theme
Aquatic environments	nbii	theme
Aquatic organisms	nbii	theme
Beaches	nbii	theme
Benthos	nbii	theme
Biomass	nbii	theme
Biota	nbii	theme
Bivalves	nbii	theme
Canidae	nbii	theme
Carbon	nbii	theme
Chlorophylls	nbii	theme
Collection (specimen gethering)	nbii	theme
Community composition	nbii	theme
Compensation	nbii	theme
Cover	nbii	theme
Crabs	nbii	theme
Data	nbii	theme
Density	nbii	theme
Detritus	nbii	theme
discharges	nbii	theme
Echinodermata	nbii	theme
Ecological abundance	nbii	theme
Ecosystems	nbii	theme
Estimation	nbii	theme
Food resources	nbii	theme
Fronds	nbii	theme
Gastropods	nbii	theme
Genus	nbii	theme
Herbivorous fishes	nbii	theme
Invasive species	nbii	theme
Irradiation	nbii	theme
Kelps	nbii	theme
Live Weight	nbii	theme
Location	nbii	theme
Marine fishes	nbii	theme
Marine invertebrates	nbii	theme
Marine sciences	nbii	theme
Mass (property)	nbii	theme
Nutrients	nbii	theme
Pisces	nbii	theme
Predators	nbii	theme
Primary production	nbii	theme
Recording	nbii	theme
Recruitment	nbii	theme
Reefs	nbii	theme
Seaweeds	nbii	theme
Size	nbii	theme
Species	nbii	theme
Species diversity	nbii	theme
streams	nbii	theme
Substrates	nbii	theme
Trophic levels	nbii	theme
water	nbii	theme
Water	nbii	theme
Zoobenthos	nbii	theme
alpha	none	theme
Benthic cover	none	theme
biomass	none	theme
birds	none	theme
climate change	none	theme
core	none	theme
demographic connectivity	none	theme
dispersal	none	theme
dogs	none	theme
dry mass	none	theme
fecundity	none	theme
Fishing pressure	none	theme
food web	none	theme
genbank	none	theme
genetic diversity	none	theme
giant kelp forest	none	theme
Gross primary production	none	theme
growth rate	none	theme
holdfasts	none	theme
inbreeding depression	none	theme
Invertebrate	none	theme
kelp biomass	none	theme
kelp canopy	none	theme
kelp forest	none	theme
kelp forest food web	none	theme
Kelp_forest_monitoring	none	theme
Landsat	none	theme
Landsat 5	none	theme
larvae	none	theme
larval settlement	none	theme
length-weight relationship	none	theme
LTER	none	theme
LTER Core Research Areas	none	theme
macroalgae	none	theme
Macroalgae	none	theme
macrofauna	none	theme
Marine Invertebrates	none	theme
marine mammals	none	theme
marine plants	none	theme
Marine Plants	none	theme
mating system	none	theme
metapopulation	none	theme
microsatellite loci	none	theme
microsatellite locus	none	theme
microsatellite marker	none	theme
microsatellites	none	theme
modularity	none	theme
molluscs	none	theme
Net community production	none	theme
net primary production	none	theme
Net primary production	none	theme
network theory	none	theme
ongoing	none	theme
Ongoing	none	theme
patch dynamics	none	theme
photosynthesis	none	theme
pmax	none	theme
remote sensing	none	theme
respiration	none	theme
ROMS modeling	none	theme
satellite	none	theme
SBC	none	theme
self-fertilization	none	theme
simulation	none	theme
sorus (cluster of sporangia)	none	theme
spatial autocorrelation	none	theme
spatial genetic structure	none	theme
species richness	none	theme
spore	none	theme
stream chemistry	none	theme
structural equation modeling	none	theme
synchrony	none	theme
taxonomy	none	theme
time series	none	theme
understory algae	none	theme
wet weight	none	theme
Zostera bed	none	theme
carbonate chemistry	sbclter	theme
CDIP MOP	sbclter	theme
discharge	sbclter	theme
GIS	sbclter	theme
Historical kelp	sbclter	theme
hydrology	sbclter	theme
Kelp_forest_monitoring	sbclter	theme
MIRADA	sbclter	theme
moorings	sbclter	theme
Ocean_biogeochemistry	sbclter	theme
OMEGAS	sbclter	theme
phytoplankton	sbclter	theme
populations	sbclter	theme
precipitation	sbclter	theme
profiles	sbclter	theme
rainfall	sbclter	theme
reference	sbclter	theme
senescence	sbclter	theme
Stable_isotopes	sbclter	theme
UNOLS_cruises	sbclter	theme
watershed	sbclter	theme
Beach	sbclter	theme
Kelp Forest	sbclter	theme
nearshore ocean	sbclter	theme
Nearshore Ocean	sbclter	theme
Reef	sbclter	theme
Watershed	sbclter	theme
Biogeochemistry	sbclter	theme
Community Structure	sbclter	theme
Ecosystem Processes	sbclter	theme
Genomics	sbclter	theme
maximum wave height	sbclter	theme
Meteorology	sbclter	theme
peak wave period	sbclter	theme
Physical Oceanography	sbclter	theme
rainfall amount	sbclter	theme
remote sensing	sbclter	theme
significant wave height	sbclter	theme
temperature	sbclter	theme
Landsat 7	none	theme
Landsat 8	none	theme
urea	none	theme
non-native species	none	theme
offshore platforms	none	theme
artificial habitat	none	theme
watersipora subatra	none	theme
epibenthic invertebrates	none	theme
glider observation	none	theme
Ocean optics	none	theme
cross-shelf variability	none	theme
controls on bio-optical properties	none	theme
nearshore processes	none	theme
instruments and techniques	none	theme
phytoplankton	none	theme
Sediment	none	theme
Pore Water	none	theme
Sediment flux	none	theme
Water column	none	theme
Inner continential shelf	none	theme
Permeable Sediment	none	theme
Advection	none	theme
sediment	none	theme
grain size	none	theme
lignin	none	theme
TOM	none	theme
El Nino	none	theme
INSERT_SITE	sbclter	theme
SBC LTER	none	theme
Water salinity	nbii	theme
Oceanography	nbii	theme
Coral Reef	lter_cv	theme
aquatic	lter_cv	theme
invasive species	none	theme
phenology	none	theme
habitat affinity	none	theme
allometry	none	theme
\.


--
-- TOC entry 3460 (class 0 OID 112137)
-- Dependencies: 225
-- Data for Name: ListMethodInstruments; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListMethodInstruments" ("InstrumentID", "Description") FROM stdin;
1	My keyboard.
2	My two eyeballs.
\.


--
-- TOC entry 3461 (class 0 OID 112143)
-- Dependencies: 226
-- Data for Name: ListMethodProtocols; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListMethodProtocols" ("ProtocolID", "NameID", "Title", "URL") FROM stdin;
8	dreed	MDS MkV Light Sensor Protocol 	http://sbc.lternet.edu/external/Reef/Protocols/Light/MDS_MkV_Light_Sensor_Protocol.pdf
11	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/kelp_biomass_landsat/SBC_LTER_protocol_Cavanaugh_Bell_landsat5_kelp_biomass.pdf
13	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/rodriguez_2014/._rodriguez_2014_macrocystis_frond_turnover_20150403.pdf
14	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Turf_NPP/Turf_and_Foliose_Algae_Productivity_Experiment_Protocol.pdf
16	dreed	SBC LTER Kelp Forest Community Structure Methods - Density of Reef Fish-20130524	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_Density_fish_20130524.pdf
17	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Cover_Protocol.pdf
18	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Quadrat_Protocol.pdf
19	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Swath_Protocol.pdf
20	dreed	Kelp Forest Community Structure Methods - Bottom Topography-20130524	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_Bottom_topography_20130524.pdf
22	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Species_Codes.pdf
23	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Fish_Protocol.pdf
24	dreed	Kelp Forest Community Structure Methods - Percent Cover of Algae, Invertebrates and Bottom Substrate-20130524	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_Percent_cover_20130524.pdf
26	dreed	Kelp Forest Community Structure Methods - Density of algae and invertebrates-20130524	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_Density_algae_inverts_20130524.pdf
27	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBCLTER_Kelp_Protocol.pdf
28	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/LTE_Detritus_Processing_Protocol_2009.pdf
29	dreed	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Irrad_sfc_seafloor_20130523.pdf
30	dreed	SBC-LTER Long Term Experiment Methods - Biomass of Macroalgal Detritus-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Biomass_detritus_20130523.pdf
31	dreed	SBC-LTER Long Term Experiment Methods - Bottom Topography Last Modified: 5/25/2013	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Bottom_topography_20130524.pdf
32	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/Methods_excerpt_Harrer_etal_2013.pdf
33	dreed	SBC LTER Long Term Experiment Methods - Reef Fish Density-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Density_fish_20130524.pdf
34	dreed	SBC LTER Long Term Experiment Methods - Net Primary Production of Macroalgae-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_NPP_macroalgae_20130524.pdf
35	dreed	SBC LTER Long Term Experiment Methods - Density of algae and invertebrates-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Density_algae_inverts_20130524.pdf
36	dreed	SBC-LTER Long Term Experiment Methods - Density of Giant Kelp-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Density_giant_kelp_20130524.pdf
37	dreed	SBC LTER Long Term Experiment Methods - Percent Cover of Algae, Invertebrates and Bottom Substrate-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Percent_cover_algae_inverts_20130524.pdf
38	dreed	SBC LTER Long Term Experiment Methods - Understory Kelp Allometrics-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Understory_kelp_allometrics_20130523.pdf
39	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/Long_Term_Experiment_Protocols_2009.pdf
40	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/Kelp_Removal_diagram.pdf
92	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/worksheets.pdf
21	dreed	SBC LTER Protocols: Biomass of algae invertebrates and fish	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_biomass_bytaxon_20161018.pdf
41	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/Long_Term_Experiment_Protocols_2010.pdf
95	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/ADCP_Teledyne_RDI_ocean_surveyor_ds_lr.pdf
42	dreed	SBC LTER Long Term Experiment Methods - Biomass of Macroalgae-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Biomass_macroalgae_20130523.pdf
43	dreed	SBC LTER Long Term Experiment Methods - Sea Urchin Size Structure-20130525	http://sbc.lternet.edu/external/Reef/Protocols/Long_Term_Kelp_Removal/SBC_LTER_protocol_Reed_LTE_Urchin_size_structure_20130523.pdf
44	dreed	Methods for macroalgal photosynthetic parameters and biomass relationships 	http://sbc.lternet.edu/external/Reef/Protocols/NPP_macroalgae/SBC_LTER_20130513_Algal_PE_Biomass_Parameters.pdf
45	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/NPP_macroalgae/Methods_macrolgal_PE_biomass_relationships.pdf
46	dreed	SBC LTER Methods: Measurement of continuous benthic water temperature	http://sbc.lternet.edu/external/Reef/Protocols/Bottom_Temperature/SBC_LTER_protocol_Reed_Continuous_benthic_water_temperature_20130615.pdf
47	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Bottom_Temperature/Continuous_Temperature_Protocol.pdf
48	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Foodweb_Stable_Isotopes/SBC LTER Foodweb Isotopes-Benthic organisms.pdf
49	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Foodweb_Stable_Isotopes/SBCLTER_Species_Codes.pdf
50	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Foodweb_Stable_Isotopes/SBC LTER Foodweb Isotopes-Sediment.pdf
51	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Foodweb_Stable_Isotopes/SBC LTER Foodweb Isotopes-Monthly Water and Kelp.pdf
52	dreed	SBC LTER Protocols - Reed Lab - Lobster Abundance and Size-20141007	http://sbc.lternet.edu/external/Reef/Protocols/lobsters/Reed_2014-09-29_lobster_abundance.pdf
53	dreed	SBC LTER Protocols - Reed Lab - Lobster Fishing Pressure-20141008	http://sbc.lternet.edu/external/Reef/Protocols/lobsters/Reed_2014-09-29_lobster_trap_counts.pdf
54	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/SBC-LTER_Kelp_NPP_Protocol.pdf
55	dreed	SBC LTER Protocols - Reed Lab - Giant Kelp Carbon and Nitrogen Content-20130703	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/SBC_LTER_protocol_Reed_Giant_kelp_carbon_nitrogen_content_20130718.pdf
56	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/Kelp_Net_Primary_Production_Protocol.pdf
57	arassweiler	Net primary production, growth and standing crop of Macrocystis pyrifera in southern California	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/Rassweiler_et_al_2008_NPP_Mpyrifera_E089-119.pdf
58	\N	\N	http://sbc.lternet.edu/external/Reef/Protocols/Historical_Kelp/Historical_Kelp_Overview.pdf
62	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_towed_CTD_processing.pdf
63	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_MaterialSafetyDataSheets.pdf
65	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/wipetest.pdf
66	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/ADCP_Teledyne_RDI_wh_mariner_ds_lr.pdf
67	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Kapsenberg_pHsample_collection_SCUBA_20160805.pdf
70	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/water_collection.pdf
71	mbrzezinski	Particulate Silica Filtration Procedure	http://sbc.lternet.edu/external/Ocean/Protocols/Particulate_Si_filtration.pdf
72	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_CTD_processing.pdf
73	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_ADCP_collection.pdf
74	mbrzezinski	Discrete Chlorophyll Filtration Procedrure: 2000-2008	http://sbc.lternet.edu/external/Ocean/Protocols/Chl_filtration_discrete.pdf
75	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/SBE_37_power_budget.pdf
76	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Variable_fluorescence.pdf
77	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_ADCP_processing.pdf
78	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Phytoplankton_Sampling.pdf
80	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_UDAS_collection.pdf
81	mbrzezinski	Processing Chlorophyll Samples - Digital Fluorometer Use: 2009-Present	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2009-01-01_Chl_analysis.pdf
82	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2003_Primary_Production.pdf
83	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Carlson_2011-06-22_DNAeasy_protocol.pdf
84	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/SBE37SM_014.pdf
85	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Scanfish.pdf
86	mbrzezinski	Water Collection Procedure - Field	http://sbc.lternet.edu/external/Ocean/Protocols/Field_water_collection.pdf
87	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Nutrient_DON_DOP_filtration.pdf
88	mbrzezinski	Primary Production – modified JGOFS 14C method	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2002b_Primary_Production.pdf
89	mbrzezinski	Particulate Si Determination 	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2001_PSi_protocol_2001.pdf
91	mbrzezinski	Processing Chlorophyll Samples-Digital Fluorometer Use: 2000-2008	http://sbc.lternet.edu/external/Ocean/Protocols/Chl_analysis.pdf
93	mbrzezinski	CHN and Isotope Filtration Procedure	http://sbc.lternet.edu/external/Ocean/Protocols/CHN_Isotope_filtration.pdf
94	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_CTD_collection.pdf
96	mbrzezinski	Discrete Chlorophyll Filtration Procedure: 2009-Present	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2009-01-01_Chl_filtration_discrete.pdf
98	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Hofmann_Washburn_SeaFET_deployment_processing_20150801.pdf
99	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_towed_CTD_collection.pdf
100	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Monthly_CTD_processing.pdf
101	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Carlson_2011-06-22_DOC_SOP.pdf
103	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2002a_Primary_Production.pdf
104	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Monthly_Water_Sampling_CTD_bottles_textonly.pdf
105	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2002c_Primary_Production.pdf
106	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/LTERcruise_UDAS_processing.pdf
107	mbrzezinski	Water Collection-Field	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2008-06-10_field_water_collection.pdf
108	mbrzezinski	Particulate CHN Filtration Procedure-Stable Isotope of C and N as well	http://sbc.lternet.edu/external/Ocean/Protocols/Brzezinski_2009-01-01_C_N_filtration.pdf
110	\N	\N	http://sbc.lternet.edu/external/Ocean/Protocols/Carlson_2011-06-22_Bacterial_Production_protocol.pdf
111	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_Precipitation_daily_reference_2009.pdf
112	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_Precipitation_Measurement_2009.pdf
113	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_Land_Precipitation_Protocol.pdf
114	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_SBCPWD_Precipitation_Data_Processing_2009.pdf
115	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_SBCPWD_Precipitation_Data_Retrieval_2009.pdf
116	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/Precipitation/SBCLTER_Precipitation_Data_Processing_2009.pdf
117	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/SBCLTER_Stream_Discharge_Measurement_2009.pdf
118	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/SBCLTER_Land_Stream_Discharge_Protocol.pdf
121	\N	\N	http://sbc.lternet.edu/external/Land/Protocols/SBCLTER_Stream_Discharge_Data_Processing_2009.pdf
126	mobrien	Ocean Data View User's Guide-Version 3.0	http://sbc.lternet.edu/external/SOFTWARE/OceanDataView/odvGuide.pdf
127	mobrien	README: Using Ocean Data View with SBC LTER data	http://sbc.lternet.edu/external/SOFTWARE/OceanDataView/README.txt
128	dreed	Estimates of kelp blade erosion rates	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/Kelp_blade_loss_protocol_20170901.pdf
10	kcavanaugh	Kelp Canopy Biomass Landsat 5 (2011-2013)	http://sbc.lternet.edu/external/Reef/Protocols/kelp_biomass_landsat/cavanaugh_2011_kelp_canopy_area_biomass_landsat5.pdf
25	dreed	SBC LTER Kelp Forest Community Structure Methods - Density of giant kelp	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_Forest_Community_Dynamics/SBC_LTER_protocol_Reed_Kelp_forest_community_Density_giant_kelp_20130524.pdf
133	dreed	Net primary production, growth and standing crop of Macrocystis pyrifera in Southern California	http://sbc.lternet.edu/external/Reef/Protocols/Kelp_NPP/KelpNPP_20180522.pdf
\.


--
-- TOC entry 3462 (class 0 OID 112149)
-- Dependencies: 227
-- Data for Name: ListMethodSoftware; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListMethodSoftware" ("SoftwareID", "Title", "AuthorSurname", "Description", "Version", "URL") FROM stdin;
1	The Programming Language Called R	LottaLuminaries	The Programming Language Formerly Called S is now named R. 	3.6.0	https://www.r-project.org/
2	High and Mighty Excel	MrMicrosoft	Tried, tested, and true.	19	https://microsoft.com
3	Good Ole Paint	MrMicrosoft	Oh, what shall my life be without ye?	999.000.1	https://microsoft.com
\.


--
-- TOC entry 3463 (class 0 OID 112155)
-- Dependencies: 228
-- Data for Name: ListPeople; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListPeople" ("NameID", "GivenName", "MiddleName", "SurName", "Organization", "Address1", "Address2", "Address3", "City", "State", "Country", "ZipCode", "Email", "WebPage", "Phone", dbupdatetime, "Position") FROM stdin;
dreed	Daniel	C	Reed	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	dan.reed@lifesci.ucsb.edu	http://sbc.lternet.edu/people/danreed/	805-893-8363	2019-08-02 14:14:40.622753	\N
sharrer	Shannon	\N	Harrer	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	harrer@msi.ucsb.edu	\N	805-893-7295	2019-08-02 14:14:40.622753	\N
kcavanaugh	Kyle	C	Cavanaugh	\N	Department of Geography	University of California	\N	Los Angeles	CA	US	90095	kcavanaugh@geog.ucla.edu	\N	\N	2019-08-02 14:14:40.622753	\N
mobrien	Margaret	C	O'Brien	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	margaret.obrien@ucsb.edu	\N	805-893-2071	2019-08-02 14:14:40.622753	\N
karkema	Katie	\N	Arkema	\N	UCSB	\N	\N	\N	\N	\N	\N	karkema@stanford.edu	\N	\N	2019-08-02 14:14:40.622753	\N
mbrzezinski	Mark	Allen	Brzezinski	\N	Department of Ecology, Evolution and Marine Biology	University of California	\N	Santa Barbara	CA	US	93106-9620	brzezins@lifesci.ucsb.edu	http://www.lifesci.ucsb.edu/eemb/faculty/brzezinski/	805-893-8605	2019-08-02 14:14:40.622753	\N
sbclter				Santa Barbara Coastal LTER	Marine Science Institute	University of California	\N	Santa Barbara	CA	USA	93106	sbclter@msi.ucsb.edu	http://sbc.lternet.edu	\N	2019-08-02 14:14:40.622753	\N
dsiegel	David	A	Siegel	\N	Earth Research Institute	University of California	\N	Santa Barbara	CA	US	93106-3060	davey@eri.ucsb.edu	http://www.icess.ucsb.edu/~davey/	805-893-4547	2019-08-02 14:14:40.622753	\N
arassweiler	Andrew	A	Rassweiler	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	andrew.rassweiler@lifesci.ucsb.edu	\N	805-893-7823	2019-08-02 14:14:40.622753	\N
\.


--
-- TOC entry 3464 (class 0 OID 112161)
-- Dependencies: 229
-- Data for Name: ListPeopleID; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListPeopleID" ("NameID", "IdentificationID", "IdentificationSystem", "IdentificationURL") FROM stdin;
dreed	1	ORCID	0000-0003-3015-8717
dsiegel	1	ORCID	0000-0003-1674-3055
mbrzezinski	1	ORCID	0000-0003-3432-2297
kcavanaugh	1	ORCID	0000-0002-3313-0878
arassweiler	1	ORCID	0000-0002-8760-3888
mobrien	1	ORCID	0000-0002-1693-8322
\.


--
-- TOC entry 3487 (class 0 OID 112864)
-- Dependencies: 280
-- Data for Name: ListPublications; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListPublications" ("PublicationID", "Bibtex") FROM stdin;
\.


--
-- TOC entry 3483 (class 0 OID 112787)
-- Dependencies: 275
-- Data for Name: ListSemanticAnnotationTerms; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListSemanticAnnotationTerms" ("TermID", "TermLabel", "TermURI") FROM stdin;
\.


--
-- TOC entry 3465 (class 0 OID 112164)
-- Dependencies: 230
-- Data for Name: ListSites; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListSites" ("SiteID", "SiteType", "SiteName", "SiteLocation", "SiteDescription", "Ownership", "ShapeType", "CenterLon", "CenterLat", "WBoundLon", "EBoundLon", "SBoundLat", "NBoundLat", "AltitudeMin", "AltitudeMax", "AltitudeUnit") FROM stdin;
046161	other	NEWHALL 5 NW	California, USA	NEWHALL 5 NW	National Weather Service - COOP	point	-118.599999999999994	34.3999999999999986	-118.599999999999994	-118.599999999999994	34.3999999999999986	34.3999999999999986	538	538	meter
046162	other	NEWHALL S FC32CE	California, USA	NEWHALL S FC32CE	National Weather Service - COOP	point	-118.533332999999999	34.3833330000000004	-118.533332999999999	-118.533332999999999	34.3833330000000004	34.3833330000000004	378.899999999999977	378.899999999999977	meter
046399	other	OJAI	California, USA	OJAI	National Weather Service - COOP	point	-119.25	34.4666670000000011	-119.25	-119.25	34.4666670000000011	34.4666670000000011	216.400000000000006	216.400000000000006	meter
046569	other	OXNARD	California, USA	OXNARD	National Weather Service - COOP	point	-119.183333000000005	34.2000000000000028	-119.183333000000005	-119.183333000000005	34.2000000000000028	34.2000000000000028	14.9000000000000004	14.9000000000000004	meter
046572	other	OXNARD WSFO	California, USA	OXNARD WSFO	National Weather Service - COOP	point	-119.133332999999993	34.2166670000000011	-119.133332999999993	-119.133332999999993	34.2166670000000011	34.2166670000000011	19.1999999999999993	19.1999999999999993	meter
046940	other	PIRU 2 ESE	California, USA	PIRU 2 ESE	National Weather Service - COOP	point	-118.75	34.3999999999999986	-118.75	-118.75	34.3999999999999986	34.3999999999999986	222.5	222.5	meter
047735	other	SANDBERG	California, USA	SANDBERG	National Weather Service - COOP	point	-118.716667000000001	34.75	-118.716667000000001	-118.716667000000001	34.75	34.75	1374.59999999999991	1374.59999999999991	meter
047902	other	SANTA BARBARA	California, USA	SANTA BARBARA	National Weather Service - COOP	point	-119.683333000000005	34.4166669999999968	-119.683333000000005	-119.683333000000005	34.4166669999999968	34.4166669999999968	1.5	1.5	meter
047904	other	Univ. of California - Santa Barbara (Coal Oil Point Reserve)	California, USA	Univ. of California - Santa Barbara (Coal Oil Point Reserve)	National Weather Service - COOP	point	-119.879599999999996	34.4140599999999992	-119.879599999999996	-119.879599999999996	34.4140599999999992	34.4140599999999992	15	15	meter
047905	other	SANTA BARBARA MUNICIPAL AP	California, USA	SANTA BARBARA MUNICIPAL AP	National Weather Service - COOP	point	-119.849999999999994	34.4333329999999975	-119.849999999999994	-119.849999999999994	34.4333329999999975	34.4333329999999975	2.70000000000000018	2.70000000000000018	meter
047957	other	SANTA PAULA	California, USA	SANTA PAULA	National Weather Service - COOP	point	-119.133332999999993	34.3166670000000025	-119.133332999999993	-119.133332999999993	34.3166670000000025	34.3166670000000025	72.2000000000000028	72.2000000000000028	meter
048014	other	SAUGUS POWER PLANT 1	California, USA	SAUGUS POWER PLANT 1	National Weather Service - COOP	point	-118.450000000000003	34.5833330000000032	-118.450000000000003	-118.450000000000003	34.5833330000000032	34.5833330000000032	641.600000000000023	641.600000000000023	meter
049285	other	VENTURA	California, USA	VENTURA	National Weather Service - COOP	point	-119.299999999999997	34.2833329999999989	-119.299999999999997	-119.299999999999997	34.2833329999999989	34.2833329999999989	32	32	meter
AB	other	Arroyo Burro	California, USA	Arroyo Burro	SBC	point	-119.744380000000007	34.4001700000000028	-119.744380000000007	-119.744380000000007	34.4001700000000028	34.4001700000000028	\N	\N	\N
ABB	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.743750000000006	34.4030500000000004	-119.743750000000006	-119.743750000000006	34.4030500000000004	34.4030500000000004	\N	\N	\N
ABBA	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.743750000000006	34.4030500000000004	-119.743750000000006	-119.743750000000006	34.4030500000000004	34.4030500000000004	\N	\N	\N
ABUR	other	ABUR	California, USA	Arroyo Burro Reef is located on the Santa Barbara Channel\r\n  near the mouth of Arroyo Burro Creek and Beach. Depth ranges from 5.4 to 7 meters.	\N	point	-119.744591499999999	34.4002750000000006	-119.744591499999999	-119.744591499999999	34.4002750000000006	34.4002750000000006	\N	\N	\N
ABUR1	other	ABUR1	California, USA	Arroyo Burro Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 305 (degree). Transect begins directly offshore of the Arroyo Burro creek mouth. Bedrock and sand substrate has little relief (0-0.5 m). Depth approximately 24-27â. This transect often becomes inundated with sand.	\N	point	-119.744382999999999	34.4001170000000016	-119.744382999999999	-119.744382999999999	34.4001170000000016	34.4001170000000016	-7.62000000000000011	-7.62000000000000011	meter
ABUR_1km_box	reef	Arroyo Burro Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.74333	34.4697299999999984	-119.749170000000007	-119.737499999999997	34.3894999999999982	34.4037999999999968	\N	\N	\N
ABUR2	other	ABUR2	California, USA	Arroyo Burro Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 320 (degree). Transect consists of low bedrock ridges (0-0.5m) with areas of sand. The first half of the transect is in deeper sand and the second half runs along a ridge covered in shallow sand. Depth is approximately 22'.	\N	point	-119.744799999999998	34.4004329999999996	-119.744799999999998	-119.744799999999998	34.4004329999999996	34.4004329999999996	-6.70999999999999996	-6.70999999999999996	meter
ABUR_reef	reef	Arroyo Burro reef	California, USA	Arroyo Burro Reef is located on the Santa Barbara Channel near the mouth of Arroyo Burro Creek and Beach. Depth ranges from 5.4 to 7 meters.	\N	polygon	-119.822502	34.413829800000002	-119.822502	-119.822502	34.413829800000002	34.413829800000002	\N	\N	\N
AHND	other	AHND	California, USA	Arroyo Hondo Reef is located on the Santa Barbara Channel near the east end of Gaviota State Park, CA. Depth ranges from -4.3m to -6.6 meters.	\N	point	-120.142616500000003	34.4718170000000015	-120.142616500000003	-120.142616500000003	34.4718170000000015	34.4718170000000015	\N	\N	\N
AHND1	other	AHND1	California, USA	Arroyo Hondo Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 105 (degree). From 2003-present this transect has been ~0.5m deep sand, with no exposed reef, but Diopatra beds with epiphytic algae are present . Depth slopes from approximately 16â at the 0 m bolt to 24â at the 40 m bolt.	\N	point	-120.144383000000005	34.4718670000000031	-120.144383000000005	-120.144383000000005	34.4718670000000031	34.4718670000000031	-6.09999999999999964	-6.09999999999999964	meter
AHND_1km_box	reef	Arroyo Hondo Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.143330000000006	34.4697299999999984	-120.149169999999998	-120.137500000000003	34.4624000000000024	34.472999999999999	\N	\N	\N
AHND2	other	AHND2	California, USA	Arroyo Hondo Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). This transect is in a boulder field with some relief (0-0.75m) and patchy sand with Diopatra beds. Depth is approximately 25'.	\N	point	-120.14085	34.4717669999999998	-120.14085	-120.14085	34.4717669999999998	34.4717669999999998	-7.62000000000000011	-7.62000000000000011	meter
AHND_to_AQUE	reef	Arroyo Hondo to Arroyo Quemado	California, USA	Area between the reefs Arroyo Hondo (AHND) and  Arroyo Quemado (AQUE)	\N	point	-120.135000000000005	34.4697299999999984	-120.135000000000005	-120.135000000000005	34.4697299999999984	34.4697299999999984	\N	\N	\N
AHND_to_AQUE_1km_box	reef	Arroyo Hondo-to-Arroyo Quemado lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.135000000000005	34.4697299999999984	-120.137500000000003	-120.132499999999993	34.4620999999999995	34.472999999999999	\N	\N	\N
AHON_reef	reef	Arroyo Hondo Reef	California, USA	Arroyo Hondo Reef is located on the Santa Barbara Channel near the east end of Gaviota State Park, CA. Depth ranges from -4.3m to -6.6 meters. 	\N	polygon	-120.144401999999999	34.4724007000000015	-120.144401999999999	-120.144401999999999	34.4724007000000015	34.4724007000000015	\N	\N	\N
ABUR_ws	land	Arroyo Burro watershed	California, USA	Arroyo Burro watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
ALC	other	Anacapa Island Landing Cove Pier (ALC)	California, USA	North shore of Anacapa Island, Santa Barbara Channel Islands, California.	\N	point	-119.362099999999998	34.0163999999999973	-119.362099999999998	-119.362099999999998	34.0163999999999973	34.0163999999999973	\N	\N	\N
B0065	other	CDIP Modeled output site B0065	California, USA	CDIP Modeled output site: B0065. Nearest to SBC LTER site(s): CARP1 CARP10 CARP2 CARP3 CARP4 CARP6 CARP7 CARP9	\N	point	-119.543099999999995	34.3900999999999968	-119.543099999999995	-119.543099999999995	34.3900999999999968	34.3900999999999968	\N	\N	\N
ALE	other	ALE	California, USA	Alegria (ALE) is located offshore from the community of Hollister Ranch, between Gaviota and Pt. Conception. Depth: 15 meters.	\N	point	-120.28998	34.4608500000000006	-120.28998	-120.28998	34.4608500000000006	34.4608500000000006	-16.5	0	meter
ALE_nearsh	nearshore	Alegria nearshore ocean	California, USA	Nearshore ocean area near the community of Hollister Ranch, between Gaviota and Pt. Conception. Depth: 15 meters.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
anacapa	other	Anacapa Island CA	California, USA	Anacapa Island CA	\N	point	-119.362097000000006	34.0168099999999995	-119.362097000000006	-119.362097000000006	34.0168099999999995	34.0168099999999995	\N	\N	\N
ANA_nearsh	nearshore	Anacapa Island, northeast 	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQB	other	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	point	-120.118617	34.4704669999999993	-120.118617	-120.118617	34.4704669999999993	34.4704669999999993	\N	\N	\N
AQBA	other	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	point	-120.118617	34.4704669999999993	-120.118617	-120.118617	34.4704669999999993	34.4704669999999993	\N	\N	\N
AQM	other	station AQM on Arroyo Quemado Reef, Santa Barbara Channel	California, USA	station AQM on Arroyo Quemado Reef, Santa Barbara Channel	\N	point	-120.120050000000006	34.4667200000000022	-120.120050000000006	-120.120050000000006	34.4667200000000022	34.4667200000000022	-11.6999999999999993	0	meter
AQUE	other	AQUE	California, USA	Arroyo Quemado Reef: Arroyo Quemado Reef depth range from 5.4m to 10.7m. There are 7 permanent transects: Transect I --- Transect VII. Reference on Land is close to US101/Arroyo Quemada Ln.	\N	point	-120.119050000000001	34.4677498799999995	-120.119050000000001	-120.119050000000001	34.4677498799999995	34.4677498799999995	\N	\N	\N
AQUE1	other	AQUE1	California, USA	Arroyo Quemado Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins west of the river mouth, on the backside of one of the larger ridges (1m). Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 24'.	\N	point	-120.121416999999994	34.4687830000000019	-120.121416999999994	-120.121416999999994	34.4687830000000019	34.4687830000000019	-7.32000000000000028	-7.32000000000000028	meter
AQUE_1km_box	reef	Arroyo Quemado Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.123329999999996	34.4697299999999984	-120.132499999999993	-120.114170000000001	34.4579000000000022	34.4720999999999975	\N	\N	\N
AQUE2	other	AQUE2	California, USA	Arroyo Quemado Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect transverses slightly southeast across the prominent east/west ridges. Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 24'.	\N	point	-120.120783000000003	34.4687330000000003	-120.120783000000003	-120.120783000000003	34.4687330000000003	34.4687330000000003	-7.32000000000000028	-7.32000000000000028	meter
AQUE3	other	AQUE3	California, USA	Arroyo Quemado Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 113 (degree). Transect begins at the western edge of the hard substrate, nearly directly offshore of the river mouth (~200 m). Silt covered bedrock and small boulder substrate with little relief (0-0.5 m), some moderate sized areas of deep sand present along with Pterygophora and Diopatra beds. Depth is approximately 30'.	\N	point	-120.119282999999996	34.4679330000000022	-120.119282999999996	-120.119282999999996	34.4679330000000022	34.4679330000000022	-9.14000000000000057	-9.14000000000000057	meter
AQUE4	other	AQUE4	California, USA	Arroyo Quemado Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins east of the river mouth. Bedrock with several large boulder outcrops creating some significant relief (0-2.5 m) along transect. Some moderate sized areas of sand (1-5 m). Depth is approximately 23 feet.	\N	point	-120.117182999999997	34.4674669999999992	-120.117182999999997	-120.117182999999997	34.4674669999999992	34.4674669999999992	-7.00999999999999979	-7.00999999999999979	meter
AQUE5	other	AQUE5	California, USA	Arroyo Quemado Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 95 (degree). Bedrock substrate, some moderate relief (0-1.5 m), one small overhanging ridge with sand channels and Diopatra beds. Depth is approximately 33 feet.	\N	point	-120.117350000000002	34.4668500000000009	-120.117350000000002	-120.117350000000002	34.4668500000000009	34.4668500000000009	-10.0600000000000005	-10.0600000000000005	meter
AQUE6	other	AQUE6	California, USA	Arroyo Quemado Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins slightly west of the river mouth. Sand (1-3cm deep) and bedrock substrate with low relief (0-0.5m). Depth is approximately 33 feet.	\N	point	-120.120850000000004	34.4675500000000028	-120.120850000000004	-120.120850000000004	34.4675500000000028	34.4675500000000028	-10.0600000000000005	-10.0600000000000005	meter
AQUE7	other	AQUE7	California, USA	Arroyo Quemado Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 95 (degree). Transect begins east of the river mouth. Bedrock with several large boulder outcrops creating some significant relief (0-2.5 m) along transect. Some moderate sized areas of sand (1-3 m) present along with Diopatra beds. Depth is approximately 25 feet.	\N	point	-120.117783000000003	34.4673999999999978	-120.117783000000003	-120.117783000000003	34.4673999999999978	34.4673999999999978	-7.62000000000000011	-7.62000000000000011	meter
AQUE8	other	AQUE8	California, USA	Arroyo Quemado Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Substrate is mostly bedrock with several large boulder outcrops. Some moderate sized areas of sand present. Depth is approximately 30â. Kelp is continually cleared in 2m band on all sides of this transect.	\N	point	-120.117783000000003	34.4672830000000019	-120.117783000000003	-120.117783000000003	34.4672830000000019	34.4672830000000019	-9.09999999999999964	-9.09999999999999964	meter
AQUE_reef	reef	Arroyo Quemado Reef	California, USA	Arroyo Quemado Reef is located on the Santa Barbara Channel near the mouth of Arroyo Quemada Creek, Santa Barbara County, CA. Depth ranges from -5.4 to -10.7 meters.	\N	polygon	-120.121498000000003	34.4688300999999981	-120.121498000000003	-120.121498000000003	34.4688300999999981	34.4688300999999981	\N	\N	\N
ARB	other	near Arroyo Burro Beach, instruments removed may 2005, weight and small float remain	California, USA	near Arroyo Burro Beach, instruments removed may 2005, weight and small float remain	\N	point	-119.744470000000007	34.3995800000000003	-119.744470000000007	-119.744470000000007	34.3995800000000003	34.3995800000000003	-7.90000000000000036	0	meter
ARQ	other	ARQ	California, USA	Arroyo Quemado Reef (ARQ) is located 0.16km from river mouth; estimated depth is 35 feet. This site (ARQ) is about 200m to the SE of a previously sampled site, AQM.	\N	point	-120.119649999999993	34.4649500000000018	-120.119649999999993	-120.119649999999993	34.4649500000000018	34.4649500000000018	\N	\N	\N
Arroyo Burro Beach	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.743750000000006	34.4030500000000004	-119.743750000000006	-119.743750000000006	34.4030500000000004	34.4030500000000004	\N	\N	\N
AHON_ws	land	Arroyo Hondo watershed	California, USA	Arroyo Hondo watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQUE_beach	beach	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQUE_ws	land	Arroyo Quemado watershed	California, USA	Arroyo Quemado watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AT07	other	Atascadero Creek at Puente Street	California, USA	Atascadero Creek, Atascadero at Puente	\N	point	-119.784139999999994	34.4322599999999994	-119.784139999999994	-119.784139999999994	34.4322599999999994	34.4322599999999994	\N	\N	\N
B0064	other	CDIP Modeled output site B0064	California, USA	CDIP Modeled output site: B0064. Nearest to SBC LTER site(s): CARP5 CARP8	\N	point	-119.538300000000007	34.3894999999999982	-119.538300000000007	-119.538300000000007	34.3894999999999982	34.3894999999999982	\N	\N	\N
B0263	other	CDIP Modeled output site B0263	California, USA	CDIP Modeled output site: B0263. Nearest to SBC LTER site(s): MOHK2 MOHK3 MOHK4	\N	point	-119.728999999999999	34.3935000000000031	-119.728999999999999	-119.728999999999999	34.3935000000000031	34.3935000000000031	\N	\N	\N
B0264	other	CDIP Modeled output site B0264	California, USA	CDIP Modeled output site: B0264. Nearest to SBC LTER site(s): MOHK1	\N	point	-119.7303	34.3939999999999984	-119.7303	-119.7303	34.3939999999999984	34.3939999999999984	\N	\N	\N
B0278	other	CDIP Modeled output site B0278	California, USA	CDIP Modeled output site: B0278. Nearest to SBC LTER site(s): ABUR1	\N	point	-119.744100000000003	34.3995999999999995	-119.744100000000003	-119.744100000000003	34.3995999999999995	34.3995999999999995	\N	\N	\N
B0279	other	CDIP Modeled output site B0279	California, USA	CDIP Modeled output site: B0279. Nearest to SBC LTER site(s): ABUR2	\N	point	-119.745000000000005	34.3997000000000028	-119.745000000000005	-119.745000000000005	34.3997000000000028	34.3997000000000028	\N	\N	\N
B0354	other	CDIP Modeled output site B0354	California, USA	CDIP Modeled output site: B0354. Nearest to SBC LTER site(s): GOLB1 GOLB2	\N	point	-119.820400000000006	34.4099000000000004	-119.820400000000006	-119.820400000000006	34.4099000000000004	34.4099000000000004	\N	\N	\N
B0394	other	CDIP Modeled output site B0394	California, USA	CDIP Modeled output site: B0394. Nearest to SBC LTER site(s): IVEE1 IVEE2	\N	point	-119.856999999999999	34.4022000000000006	-119.856999999999999	-119.856999999999999	34.4022000000000006	34.4022000000000006	\N	\N	\N
B0492	other	CDIP Modeled output site B0492	California, USA	CDIP Modeled output site: B0492. Nearest to SBC LTER site(s): NAPL1 NAPL2 NAPL3 NAPL4 NAPL5 NAPL6 NAPL7 NAPL8 NAPL9	\N	point	-119.948800000000006	34.4309999999999974	-119.948800000000006	-119.948800000000006	34.4309999999999974	34.4309999999999974	\N	\N	\N
B0494	other	CDIP Modeled output site B0494	California, USA	CDIP Modeled output site: B0494. Nearest to SBC LTER site(s): NAPL10	\N	point	-119.951999999999998	34.4316000000000031	-119.951999999999998	-119.951999999999998	34.4316000000000031	34.4316000000000031	\N	\N	\N
B0662	other	CDIP Modeled output site B0662	California, USA	CDIP Modeled output site: B0662. Nearest to SBC LTER site(s): AQUE4 AQUE5 AQUE7 AQUE8	\N	point	-120.117400000000004	34.4671000000000021	-120.117400000000004	-120.117400000000004	34.4671000000000021	34.4671000000000021	\N	\N	\N
B0664	other	CDIP Modeled output site B0664	California, USA	CDIP Modeled output site: B0664. Nearest to SBC LTER site(s): AQUE3	\N	point	-120.119600000000005	34.4673000000000016	-120.119600000000005	-120.119600000000005	34.4673000000000016	34.4673000000000016	\N	\N	\N
B0665	other	CDIP Modeled output site B0665	California, USA	CDIP Modeled output site: B0665. Nearest to SBC LTER site(s): AQUE6	\N	point	-120.120500000000007	34.4677999999999969	-120.120500000000007	-120.120500000000007	34.4677999999999969	34.4677999999999969	\N	\N	\N
B0666	other	CDIP Modeled output site B0666	California, USA	CDIP Modeled output site: B0666. Nearest to SBC LTER site(s): AQUE1 AQUE2	\N	point	-120.121399999999994	34.4680999999999997	-120.121399999999994	-120.121399999999994	34.4680999999999997	34.4680999999999997	\N	\N	\N
B0685	other	CDIP Modeled output site B0685	California, USA	CDIP Modeled output site: B0685. Nearest to SBC LTER site(s): AHND2	\N	point	-120.140900000000002	34.4705999999999975	-120.140900000000002	-120.140900000000002	34.4705999999999975	34.4705999999999975	\N	\N	\N
B0688	other	CDIP Modeled output site B0688	California, USA	CDIP Modeled output site: B0688. Nearest to SBC LTER site(s): AHND1	\N	point	-120.143900000000002	34.4709000000000003	-120.143900000000002	-120.143900000000002	34.4709000000000003	34.4709000000000003	\N	\N	\N
B0871	other	CDIP Modeled output site B0871	California, USA	CDIP Modeled output site: B0871. Nearest to SBC LTER site(s): BULL1 BULL3 BULL6	\N	point	-120.331900000000005	34.4562000000000026	-120.331900000000005	-120.331900000000005	34.4562000000000026	34.4562000000000026	\N	\N	\N
BaronRanch262	other	Baron Ranch	California, USA	Baron Ranch	\N	point	-120.129166699999999	34.4833333300000007	-120.129166699999999	-120.129166699999999	34.4833333300000007	34.4833333300000007	\N	\N	\N
bc_1	other	BC 1	California, USA	The BC reef is the west side of Platt's Harbor. BC 1 is SE of the main point.	\N	point	-119.741416700000002	34.0507666700000016	-119.741416700000002	-119.741416700000002	34.0507666700000016	34.0507666700000016	-30	-30	Foot_US
bc_2	other	BC 2	California, USA	The BC reef is the west side of Platt's Harbor. BC 2 is NW of the main point.	\N	point	-119.741816700000001	34.0511666700000006	-119.741816700000001	-119.741816700000001	34.0511666700000006	34.0511666700000006	-30	-30	Foot_US
bc_point	other	BC Point	California, USA	The BC reef is the west side of Platt's Harbor. BC Point is  off a small outcrop.	\N	point	-119.740633299999999	34.0503500000000017	-119.740633299999999	-119.740633299999999	34.0503500000000017	34.0503500000000017	-30	-30	Foot_US
BI	other	Bulito Inshore	California, USA	Bulito Inshore	\N	point	-120.333399999999997	34.4588999999999999	-120.333399999999997	-120.333399999999997	34.4588999999999999	34.4588999999999999	\N	\N	\N
BO	other	Bulito Offshore	California, USA	Bulito Offshore	\N	point	-120.333600000000004	34.4581999999999979	-120.333600000000004	-120.333600000000004	34.4581999999999979	34.4581999999999979	\N	\N	\N
BR	other	Bulito Reef	California, USA	Bulito Reef	\N	point	-120.333500000000001	34.4585000000000008	-120.333500000000001	-120.333500000000001	34.4585000000000008	34.4585000000000008	\N	\N	\N
BULL	other	BULL	California, USA	Builto: Bulito has three permanent transect: Transect I, III, VI. Depth Range from -5.5 to -7.3. Reference on land is close to Ranch Real road and Hollister Ranch road crossing section.	\N	point	-120.333489999999998	34.4585053300000013	-120.333489999999998	-120.333489999999998	34.4585053300000013	34.4585053300000013	\N	\N	\N
BULL1	other	BULL1	California, USA	Bulito Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Transect is closest to the river mouth, bedrock and shale substrate with some slight relief (0-1 m) and thick understory algal cover.	\N	point	-120.333432999999999	34.4588830000000002	-120.333432999999999	-120.333432999999999	34.4588830000000002	34.4588830000000002	-5.49000000000000021	-5.49000000000000021	meter
BULL3	other	BULL3	California, USA	Bulito Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Bedrock and shale substrate with some sandy areas and slight relief (0-1 m). Thick Pterygophora beds typically present. Depth is approximately 20 feet.	\N	point	-120.333483000000001	34.4584830000000011	-120.333483000000001	-120.333483000000001	34.4584830000000011	34.4584830000000011	-6.09999999999999964	-6.09999999999999964	meter
BULL6	other	BULL6	California, USA	Bulito Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock and shale substrate with some sandy areas and slight relief (0-1m). Depth is approximately 24 feet.	\N	point	-120.333550000000002	34.4581500000000034	-120.333550000000002	-120.333550000000002	34.4581500000000034	34.4581500000000034	-7.32000000000000028	-7.32000000000000028	meter
BULL_reef	reef	Bulito Reef	California, USA	Bulito Reef is located on the Santa Barbara Channel between Gaviota and Pt. Conception, CA. Depth ranges from -5.5 to -7.3 meters.	\N	polygon	-120.333602999999997	34.4561995999999979	-120.333602999999997	-120.333602999999997	34.4561995999999979	34.4561995999999979	\N	\N	\N
CP201	other	Carpinteria Creek at Veddar's Ranch	California, USA	Carpinteria at Veddar's Ranch	\N	point	-119.481039999999993	34.4237400000000022	-119.481039999999993	-119.481039999999993	34.4237400000000022	34.4237400000000022	\N	\N	\N
cape_evans_mcmurdo	other	Cape Evans, McMurdo Sound, Antarctica	McMurdo Sound, Antarctica	 Cape Evans is located about 20 km north of McMurdo Station, the U.S. Antarctic research center on the south tip of Ross Island, on the shore of McMurdo Sound.	\N	point	166.415899999999993	-77.6346170000000058	166.415899999999993	166.415899999999993	-77.6346170000000058	-77.6346170000000058	\N	\N	\N
frys_3	other	Fry's 3	California, USA	Fry's 3 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.756299999999996	34.0577666699999995	-119.756299999999996	-119.756299999999996	34.0577666699999995	34.0577666699999995	-30	-30	Foot_US
CAR	other	Carpinteria Reef mooring 	California, USA	Carpinteria Reef (CAR) is ofshore of the rock groin near the salt marsh, west of the campground. Depth is estimated at 26 ft.	\N	point	-119.539900000000003	34.3901499999999984	-119.539900000000003	-119.539900000000003	34.3901499999999984	34.3901499999999984	-8.5	0	meter
CARP	other	CARP	California, USA	Carpinteria Reef is located on the Santa Barbara Channel offshore of the Carpinteria Salt Marsh. Depth range is from -2.2 to -8.8 meters	\N	point	-119.541693300000006	34.3916319000000001	-119.541693300000006	-119.541693300000006	34.3916319000000001	34.3916319000000001	\N	\N	\N
geocov_adcp150.ds1104.e4	other	geocov_adcp150.ds1104.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.634500000000003	35.4046999999999983	-121.991799999999998	-119.277199999999993	34.0247000000000028	36.7847000000000008	-495	-23	meter
CARP1	other	CARP1	California, USA	Carpinteria Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 70 (degree). Transect runs parallel along the significant NE-running reef ridge and has significant relief (up to 3 m) on the northern side. Bedrock substrate with some slight relief (0-1 m). Depth is approximately 8-12 feet.	\N	point	-119.543800000000005	34.3924170000000018	-119.543800000000005	-119.543800000000005	34.3924170000000018	34.3924170000000018	-3.04999999999999982	-3.04999999999999982	meter
CARP10	other	CARP10	California, USA	Carpinteria Transect 10: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with moderate relief (0-1.5 m). Depth approximately 24â. Transect heading is ~ 90 degrees. Kelp continually cleared in 2m band on all sides of the transect. Depth is approximately 24 feet.	\N	point	-119.541183000000004	34.3912169999999975	-119.541183000000004	-119.541183000000004	34.3912169999999975	34.3912169999999975	-7.40000000000000036	-7.40000000000000036	meter
CARP_1km_box	reef	Carpinteria Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.539169999999999	34.4697299999999984	-119.548330000000007	-119.530000000000001	34.3851000000000013	34.4050000000000011	\N	\N	\N
CARP2	other	CARP2	California, USA	Carpinteria Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 60 (degree). Generally a mudstone substrate with little relief (0-0.5 m). Depth is approximately 10-13 feet.	\N	point	-119.540367000000003	34.3927669999999992	-119.540367000000003	-119.540367000000003	34.3927669999999992	34.3927669999999992	-3.50999999999999979	-3.50999999999999979	meter
CARP3	other	CARP3	California, USA	Carpinteria Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Bedrock substrate with some moderate relief (0-1.5 m), boulders, and some small areas (1-3 m) of silt and sand. Depth is approximately 24 feet.	\N	point	-119.543999999999997	34.3915170000000003	-119.543999999999997	-119.543999999999997	34.3915170000000003	34.3915170000000003	-7.32000000000000028	-7.32000000000000028	meter
CARP4	other	CARP4	California, USA	Carpinteria Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand. 0 bolt begins at the crevice between two ridges. Depth is approximately 22 feet.	\N	point	-119.541650000000004	34.3917169999999999	-119.541650000000004	-119.541650000000004	34.3917169999999999	34.3917169999999999	-6.70999999999999996	-6.70999999999999996	meter
CARP5	other	CARP5	California, USA	Carpinteria Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Mudstone ridges (1-2m) with areas of shell debris, cobble, and small boulders. Depth is approximately 20 feet.	\N	point	-119.539316999999997	34.3918170000000032	-119.539316999999997	-119.539316999999997	34.3918170000000032	34.3918170000000032	-6.09999999999999964	-6.09999999999999964	meter
CARP6	other	CARP6	California, USA	Carpinteria Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand. Depth is approximately 27 feet.	\N	point	-119.544133000000002	34.3911170000000013	-119.544133000000002	-119.544133000000002	34.3911170000000013	34.3911170000000013	-8.23000000000000043	-8.23000000000000043	meter
CARP7	other	CARP7	California, USA	Carpinteria Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand and cobble channels. Depth is approximately 27 feet.	\N	point	-119.541832999999997	34.3912329999999997	-119.541832999999997	-119.541832999999997	34.3912329999999997	34.3912329999999997	-8.23000000000000043	-8.23000000000000043	meter
CARP8	other	CARP8	California, USA	Carpinteria Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Mudstone substrate with some moderate relief (0-1.5 m) and some small areas of shell debris, cobble, and small boulders. Depth is approximately 27 feet.	\N	point	-119.539533000000006	34.3913999999999973	-119.539533000000006	-119.539533000000006	34.3913999999999973	34.3913999999999973	-8.23000000000000043	-8.23000000000000043	meter
CARP9	other	CARP9	California, USA	Carpinteria Transect 9: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand and cobble channels. Depth is approximately 27 feet.	\N	point	-119.541117	34.3911170000000013	-119.541117	-119.541117	34.3911170000000013	34.3911170000000013	-8.23000000000000043	-8.23000000000000043	meter
Carpinteria208	other	Carpinteria Fire Station	California, USA	Carpinteria Fire Station	\N	point	-119.516666700000002	34.3999999999999986	-119.516666700000002	-119.516666700000002	34.3999999999999986	34.3999999999999986	\N	\N	\N
Carpinteria City Beach	other	Carpinteria City Beach	California, USA	Carpinteria City Beach	\N	point	-119.526989999999998	34.39452	-119.526989999999998	-119.526989999999998	34.39452	34.39452	\N	\N	\N
CARP_reef	reef	Carpinteria reef	California, USA	Carpinteria Reef is located on the Santa Barbara Channel offshore of the Carpinteria Salt Marsh. Depth range is from -2.2 to -8.8 meters. 	\N	polygon	-119.539901999999998	34.3902015999999975	-119.539901999999998	-119.539901999999998	34.3902015999999975	34.3902015999999975	\N	\N	\N
CaterWTP229	other	Cater Water Treatment Plant	California, USA	Cater Water Treatment Plant	\N	point	-119.730277799999996	34.4541666699999993	-119.730277799999996	-119.730277799999996	34.4541666699999993	34.4541666699999993	\N	\N	\N
CI	other	Carpinteria Inshore	California, USA	Carpinteria Inshore	\N	point	-119.539249999999996	34.3938800000000029	-119.539249999999996	-119.539249999999996	34.3938800000000029	34.3938800000000029	\N	\N	\N
CO	other	Carpinteria Offshore	California, USA	Carpinteria Offshore	\N	point	-119.541870000000003	34.3838700000000017	-119.541870000000003	-119.541870000000003	34.3838700000000017	34.3838700000000017	\N	\N	\N
ColdSprings210	other	Cold Springs Basin	California, USA	Cold Springs Basin	\N	point	-119.616666699999996	34.4500000000000028	-119.616666699999996	-119.616666699999996	34.4500000000000028	34.4500000000000028	\N	\N	\N
COP	intertidal	Coal Oil Point	California, USA	Coal Oil Point (COP) is located in the rocky intertidal area on the western edge of the University of California, Santa Barbara (UCSB) campus, and is part of the UC Natural Reserve System	\N	point	-119.878286099999997	34.4068596199999988	-119.878286099999997	-119.878286099999997	34.4068596199999988	34.4068596199999988	\N	\N	\N
CP00	other	Carpinteria Creek at 8th St Foot Bridge	California, USA	Carpinteria Creek, 8th St Foot Bridge	\N	point	-119.514129999999994	34.3930124500000005	-119.514129999999994	-119.514129999999994	34.3930124500000005	34.3930124500000005	\N	\N	\N
CR	other	Carpinteria Reef - near mooring site CAR	California, USA	Carpinteria Reef - near mooring site CAR	\N	point	-119.539869999999993	34.3902300000000025	-119.539869999999993	-119.539869999999993	34.3902300000000025	34.3902300000000025	\N	\N	\N
FRYS_reef	reef	Santa Cruz Is, Fry's Cove	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
cruiseTransectA	other	cruiseTransectA	California, USA	Santa Barbara Channel offshore transect cruiseTransectA: from near Pt. Conception, grid station 1 (34.4569,-120.5585 ) approximately SSE to San Miguel Island, grid station 5 (34.1163,-120.3918). This line includes grid stations 1-5.	\N	rectangle	-120.475149999999999	34.2866	-120.558499999999995	-120.391800000000003	34.1163000000000025	34.4568999999999974	\N	\N	\N
cruiseTransectB	other	cruiseTransectB	California, USA	Santa Barbara Channel offshore transect cruiseTransectB from Sam Miguel Island, grid station 5 (34.1163,-120.3918) approximately NNE to mid-channel near platform Heritage, grid station 8 (34.4065,-120.2308), continuing approximately NE to Arroyo Hondo Reef, grid station 9 (34.4632,-120.1216) .This line includes grid stations 5-9.	\N	rectangle	-120.256699999999995	34.289749999999998	-120.391800000000003	-120.121600000000001	34.1163000000000025	34.4632000000000005	\N	\N	\N
cruiseTransectC	other	cruiseTransectC	California, USA	Santa Barbara Channel offshore transect cruiseTransectC from Arroyo Hondo Reef, grid station 9 (34.4632,-120.1216) approximately S to Santa Rosa Island, grid station 10 (34.05828,-120.10035 )	\N	rectangle	-120.110974999999996	34.2607416700000016	-120.121600000000001	-120.100350000000006	34.0582833300000019	34.4632000000000005	\N	\N	\N
cruiseTransectD	other	cruiseTransectD	California, USA	Santa Barbara Channel offshore transect cruiseTransectD from Santa Rosa Island, grid station 10 (34.05828,-120.10035) approximately NNE to Naples Reef, grid station 14 (34.4097,-119.951 ). This line includes grid stations 10-14	\N	rectangle	-120.025675000000007	34.2339899999999986	-120.100350000000006	-119.950999999999993	34.4097000000000008	34.0582800000000034	\N	\N	\N
cruiseTransectE1	other	cruiseTransectE1	California, USA	Santa Barbara Channel offshore transect cruiseTransectE1 from Naples reef, grid station 14 (34.4097,-119.951) approximately SSE to mid-channel near the East Santa Barbara Weather Buoy, grid station 15 (34.2491,-119.9069) continuing approximately SSE to Santa Cruz Island, grid station 16 (34.0665,-119.79). This line includes grid stations 14-16.	\N	rectangle	-119.870500000000007	34.2381000000000029	-119.950999999999993	-119.790000000000006	34.0664999999999978	34.4097000000000008	\N	\N	\N
cruiseTransectF	other	cruiseTransectF	California, USA	Santa Barbara Channel offshore transect cruiseTransectF from Santa Cruz Island, grid station 16 approximately NE ( 34.0665,-119.79) to Carpinteria reef, grid station 20 (34.3766,-119.5448). This line includes grid stations 16-20.	\N	rectangle	-119.667400000000001	34.2215500000000006	-119.790000000000006	-119.544799999999995	34.0664999999999978	34.3766000000000034	\N	\N	\N
cruiseTransectG	other	cruiseTransectG	California, USA	Santa Barbara Channel offshore transect cruiseTransectG from Carpinteria reef (34.3766,-119.5448), grid station 20 approximately SSE to Anacapa Island (34.0256,-119.4394). grid station 21	\N	rectangle	-119.492099999999994	34.2010999999999967	-119.544799999999995	-119.439400000000006	34.0255999999999972	34.3766000000000034	\N	\N	\N
cruiseTransectH	other	cruiseTransectH	California, USA	Santa Barbara Channel offshore transect cruiseTransectH from Anacapa Island, grid station 21 approximately NE (34.0256,-119.4394) to the mouth of the Santa Clara River, grid station 25 (34.2255,-119.2803). This line includes grid stations 21-25.	\N	rectangle	-119.359849999999994	34.1255499999999969	-119.439400000000006	-119.280299999999997	34.0255999999999972	34.2254999999999967	\N	\N	\N
cruiseTransectS	other	cruiseTransectS	California, USA	Santa Barbara Channel along-shore transect cruiseTransect S from the mouth of the Ventura River to Pt. Conception, along the 20 meter isobath. Waypoints follow.	\N	polyline	-119.918400000000005	34.3364499999999992	-120.550799999999995	-119.286000000000001	34.2222999999999971	34.4506000000000014	\N	\N	\N
diablo	other	Diablo Pt	California, USA	 Diablo Pt, north shore Santa Cruz Island	\N	point	-119.757450000000006	34.0581499999999977	-119.757450000000006	-119.757450000000006	34.0581499999999977	34.0581499999999977	-30	-30	Foot_US
DosPueblos226	other	Dos Pueblos Ranch	California, USA	Dos Pueblos Ranch	\N	point	-119.951666700000004	34.446666669999999	-119.951666700000004	-119.951666700000004	34.446666669999999	34.446666669999999	\N	\N	\N
DoultonTunnel231	other	Doulton Tunnel	California, USA	Doulton Tunnel	\N	point	-119.563888899999995	34.4569444400000009	-119.563888899999995	-119.563888899999995	34.4569444400000009	34.4569444400000009	\N	\N	\N
DV01	other	Devereaux Creek at Devereaux Slough inflow	California, USA	DV01, Devereaux Creek, Devereaux Creek at Devereaux Slough inflow	\N	point	-119.87406	34.4176100000000034	-119.87406	-119.87406	34.4176100000000034	34.4176100000000034	\N	\N	\N
East UCSB Campus Beach	other	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.842010000000002	34.4107600000000033	-119.842010000000002	-119.842010000000002	34.4107600000000033	34.4107600000000033	\N	\N	\N
EdisonTrail252	other	Edison Trail	California, USA	Edison Trail	\N	point	-119.5077778	34.4427777800000001	-119.5077778	-119.5077778	34.4427777800000001	34.4427777800000001	\N	\N	\N
EL201	other	El Capitan at State Beach	California, USA	El Capitan at State Beach	\N	point	-120.024883000000003	34.4622829999999993	-120.024883000000003	-120.024883000000003	34.4622829999999993	34.4622829999999993	\N	\N	\N
EL202	other	El Capitan at Upper Bill Wallace Trail	California, USA	El Capitan at Upper Bill Wallace Trail	\N	point	-120.007850000000005	34.4961169999999981	-120.007850000000005	-120.007850000000005	34.4961169999999981	34.4961169999999981	\N	\N	\N
El Capitan State Beach	other	El Capitan State Beach	California, USA	El Capitan State Beach	\N	point	-120.025360000000006	34.4587700000000012	-120.025360000000006	-120.025360000000006	34.4587700000000012	34.4587700000000012	\N	\N	\N
ElDeseo255	other	El Deseo	California, USA	El Deseo	\N	point	-119.695833300000004	34.4916666700000007	-119.695833300000004	-119.695833300000004	34.4916666700000007	34.4916666700000007	\N	\N	\N
ELL_nearsh	nearshore	Ellwood	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
EUCB	beach	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.842016999999998	34.4107669999999999	-119.842016999999998	-119.842016999999998	34.4107669999999999	34.4107669999999999	\N	\N	\N
EUCBA	beach	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.842016999999998	34.4107669999999999	-119.842016999999998	-119.842016999999998	34.4107669999999999	34.4107669999999999	\N	\N	\N
fbpc	other	Point Cabrillo, Mendocino County CA	California, USA	Point Cabrillo, Mendocino County CA	\N	point	-123.826790000000003	39.3503699999999981	-123.826790000000003	-123.826790000000003	39.3503699999999981	39.3503699999999981	\N	\N	\N
fern_1	other	Fern 1	California, USA	Fern 1 is located on the west edge of a small headland east of Fry's Harbor.	\N	point	-119.749633299999999	34.0536499999999975	-119.749633299999999	-119.749633299999999	34.0536499999999975	34.0536499999999975	-30	-30	Foot_US
fern_o	other	Fern Offshore	California, USA	Fern Offshore is located on the east edge of a small headland east of Fry's Harbor.	\N	point	-119.747033299999998	34.0529166700000019	-119.747033299999998	-119.747033299999998	34.0529166700000019	34.0529166700000019	-30	-30	Foot_US
FERN_reef	reef	Santa Cruz Is, Fern	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
FK00	other	Franklin Creek at Carpinteria Ave	California, USA	Franklin Creek, Carpinteria Ave	\N	point	-119.521450000000002	34.4016478699999979	-119.521450000000002	-119.521450000000002	34.4016478699999979	34.4016478699999979	\N	\N	\N
foster_urchin_sampling_2010	other	Foster et al, Urchin collection site	California, USA	Collection site for Foster et al (2014) Urchin sampling	\N	point	-119.829999999999998	34.4149999999999991	-119.829999999999998	-119.829999999999998	34.4149999999999991	34.4149999999999991	\N	\N	\N
frys_1	other	Fry's 1	California, USA	Fry's 1 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.755099999999999	34.0569500000000005	-119.755099999999999	-119.755099999999999	34.0569500000000005	34.0569500000000005	-30	-30	Foot_US
ELCAP_ws	land	El Capitan Watershed	California, USA	El Capitan Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
frys_2	other	Fry's 2	California, USA	Fry's 2 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.755883299999994	34.0576500000000024	-119.755883299999994	-119.755883299999994	34.0576500000000024	34.0576500000000024	-30	-30	Foot_US
gaviota	other	Gaviota Pier, Santa Barbara County CA	California, USA	Gaviota Pier, Santa Barbara County CA	\N	point	-120.228210000000004	34.4697800000000001	-120.228210000000004	-120.228210000000004	34.4697800000000001	34.4697800000000001	\N	\N	\N
Gaviota State Beach	other	Gaviota State Beach	California, USA	Gaviota State Beach	\N	point	-120.22757	34.4710899999999967	-120.22757	-120.22757	34.4710899999999967	34.4710899999999967	\N	\N	\N
GB201	other	Gobernador at Veddar's Ranch	California, USA	Gobernador at Veddar's Ranch	\N	point	-119.470889999999997	34.4245000000000019	-119.470889999999997	-119.470889999999997	34.4245000000000019	34.4245000000000019	\N	\N	\N
geocov_adcp150.ds1101.e4	other	geocov_adcp150.ds1101.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.631050000000002	35.3884499999999989	-121.992900000000006	-119.269199999999998	34.0234000000000023	36.7535000000000025	-495	-23	meter
geocov_adcp150.ds1102.e4	other	geocov_adcp150.ds1102.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922449999999998	34.2444500000000005	-120.563500000000005	-119.281400000000005	34.0240000000000009	34.4649000000000001	-495	-23	meter
geocov_adcp150.ds1103.e4	other	geocov_adcp150.ds1103.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.634600000000006	35.4169499999999999	-121.987799999999993	-119.281400000000005	34.0253000000000014	36.8085999999999984	-495	-23	meter
ATMY	other	ATMY	California, USA	Atascadero Creek, Atascadero	\N	point	-119.810784999999996	34.4247190000000032	-119.810784999999996	-119.810784999999996	34.4247190000000032	34.4247190000000032	\N	\N	\N
geocov_adcp150.ds1105.e4	other	geocov_adcp150.ds1105.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.83005	35.4080500000000029	-122.377499999999998	-119.282600000000002	34.0223000000000013	36.7937999999999974	-495	-23	meter
geocov_adcp150.ds1106.e4	other	geocov_adcp150.ds1106.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.661850000000001	35.3896000000000015	-122.043999999999997	-119.279700000000005	34.0234000000000023	36.7558000000000007	-495	-23	meter
geocov_adcp150.ds1107.e4	other	geocov_adcp150.ds1107.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.636600000000001	35.4142999999999972	-121.992500000000007	-119.280699999999996	34.0255999999999972	36.8029999999999973	-495	-23	meter
geocov_adcp150.ds1108.e4	other	geocov_adcp150.ds1108.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.939400000000006	34.2496500000000026	-120.602000000000004	-119.276799999999994	34.022199999999998	34.4771000000000001	-487	-15	meter
geocov_adcp300.ds1109.e4	other	geocov_adcp300.ds1109.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.619399999999999	35.40625	-121.986999999999995	-119.251800000000003	34.024799999999999	36.787700000000001	-125	-7	meter
geocov_adcp300.ds1110.e4	other	geocov_adcp300.ds1110.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.931899999999999	34.2444500000000005	-120.575000000000003	-119.288799999999995	34.0244	34.464500000000001	-125	-7	meter
geocov_adcp300.ds1111.e4	other	geocov_adcp300.ds1111.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.641499999999994	35.4077500000000001	-121.996899999999997	-119.286100000000005	34.0230000000000032	36.7924999999999969	-206	-10	meter
geocov_adcp300.ds1112.e4	other	geocov_adcp300.ds1112.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.949650000000005	34.2453999999999965	-120.611800000000002	-119.287499999999994	34.0264000000000024	34.4643999999999977	-203	-7	meter
geocov_adcp300.ds1113.e4	other	geocov_adcp300.ds1113.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.925200000000004	34.2444500000000005	-120.569999999999993	-119.2804	34.024799999999999	34.464100000000002	-203	-7	meter
geocov_adcp300.ds1114.e4	other	geocov_adcp300.ds1114.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.929900000000004	34.246850000000002	-120.578999999999994	-119.280799999999999	34.0251000000000019	34.4686000000000021	-203	-7	meter
geocov_adcp300.ds1115.e4	other	geocov_adcp300.ds1115.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.945899999999995	34.2550499999999971	-120.611400000000003	-119.2804	34.0266999999999982	34.4834000000000032	-203	-7	meter
geocov_adcp300.ds1116.e4	other	geocov_adcp300.ds1116.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.924700000000001	34.2438000000000002	-120.567899999999995	-119.281499999999994	34.0242999999999967	34.4632999999999967	-203	-7	meter
geocov_adcp75.ds1111.e5	other	geocov_adcp75.ds1111.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-121.482500000000002	35.6568499999999986	-121.832800000000006	-121.132199999999997	35.1501999999999981	36.1634999999999991	-731	-27	meter
geocov_adcp75.ds1112.e5	other	geocov_adcp75.ds1112.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-120.837050000000005	35.5166499999999985	-121.991600000000005	-119.682500000000005	34.3721000000000032	36.6612000000000009	-731	-27	meter
geocov_adcp75.ds1114.e5	other	geocov_adcp75.ds1114.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.929550000000006	34.2466500000000025	-120.578500000000005	-119.280600000000007	34.0251000000000019	34.4682000000000031	-731	-27	meter
geocov_adcp75.ds1115.e5	other	geocov_adcp75.ds1115.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.933350000000004	34.247799999999998	-120.586299999999994	-119.2804	34.0266999999999982	34.4688999999999979	-491	-19	meter
geocov_adcp75.ds1116.e5	other	geocov_adcp75.ds1116.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.924400000000006	34.2439499999999981	-120.567300000000003	-119.281499999999994	34.0242999999999967	34.4635999999999996	-491	-19	meter
geocov_ctdbottledata.ds1001.e3	other	geocov_ctdbottledata.ds1001.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.916399999999996	34.2364499999999978	-120.551199999999994	-119.281599999999997	34.0253999999999976	34.447499999999998	-75	0	meter
geocov_ctdbottledata.ds1002.e3	other	geocov_ctdbottledata.ds1002.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921149999999997	34.2439499999999981	-120.5608	-119.281499999999994	34.0251999999999981	34.4626999999999981	-99999	0	meter
geocov_ctdbottledata.ds1003.e3	other	geocov_ctdbottledata.ds1003.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9208	34.2444500000000005	-120.5595	-119.2821	34.0262000000000029	34.4626999999999981	-530	0	meter
geocov_ctdbottledata.ds1004.e3	other	geocov_ctdbottledata.ds1004.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.917649999999995	34.2464500000000029	-120.5578	-119.277500000000003	34.0307000000000031	34.4622000000000028	-550	0	meter
geocov_ctdbottledata.ds1005.e3	other	geocov_ctdbottledata.ds1005.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922849999999997	34.2441499999999976	-120.561199999999999	-119.284499999999994	34.0242999999999967	34.4639999999999986	-575	0	meter
geocov_ctdbottledata.ds1006.e3	other	geocov_ctdbottledata.ds1006.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920000000000002	34.2441499999999976	-120.5595	-119.280500000000004	34.0257999999999967	34.4624999999999986	-580	0	meter
geocov_ctdbottledata.ds1007.e3	other	geocov_ctdbottledata.ds1007.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920599999999993	34.2436500000000024	-120.559200000000004	-119.281999999999996	34.0253000000000014	34.4620000000000033	-76	0	meter
geocov_ctdbottledata.ds1008.e3	other	geocov_ctdbottledata.ds1008.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921599999999998	34.2421500000000023	-120.561999999999998	-119.281199999999998	34.0234999999999985	34.460799999999999	-575	0	meter
GAV_ws	land	Gaviota watershed	California, USA	Gaviota watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
geocov_ctdbottledata.ds1009.e3	other	geocov_ctdbottledata.ds1009.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.915300000000002	34.24315	-120.559899999999999	-119.270700000000005	34.0253999999999976	34.4609000000000023	-75	0	meter
geocov_ctdbottledata.ds1010.e3	other	geocov_ctdbottledata.ds1010.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.925299999999993	34.2440500000000014	-120.5595	-119.2911	34.0247000000000028	34.4634	-99999	0	meter
geocov_ctdbottledata.ds1011.e3	other	geocov_ctdbottledata.ds1011.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922650000000004	34.2441000000000031	-120.559100000000001	-119.286199999999994	34.024799999999999	34.4634	-75	0	meter
geocov_ctdbottledata.ds1012.e3	other	geocov_ctdbottledata.ds1012.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.923599999999993	34.245199999999997	-120.559700000000007	-119.287499999999994	34.0264999999999986	34.4639000000000024	-75	0	meter
geocov_ctdbottledata.ds1013.e3	other	geocov_ctdbottledata.ds1013.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920850000000002	34.244250000000001	-120.561199999999999	-119.280500000000004	34.0249999999999986	34.4635000000000034	-75	0	meter
geocov_ctdbottledata.ds1014.e3	other	geocov_ctdbottledata.ds1014.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920550000000006	34.2448499999999996	-120.560100000000006	-119.281000000000006	34.0255999999999972	34.464100000000002	-77	0	meter
geocov_ctdbottledata.ds1015.e3	other	geocov_ctdbottledata.ds1015.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920100000000005	34.2449999999999974	-120.559799999999996	-119.2804	34.0274000000000001	34.4626000000000019	-75	0	meter
geocov_ctdbottledata.ds1016.e3	other	geocov_ctdbottledata.ds1016.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920749999999998	34.2439999999999998	-120.560000000000002	-119.281499999999994	34.024799999999999	34.4632000000000005	-75	0	meter
geocov_ctddowncast.ds1001.e1	other	geocov_ctddowncast.ds1001.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.916399999999996	34.2364499999999978	-120.551199999999994	-119.281599999999997	34.0253999999999976	34.447499999999998	-500.776999999999987	0	meter
geocov_ctddowncast.ds1002.e1	other	geocov_ctddowncast.ds1002.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921149999999997	34.2439499999999981	-120.5608	-119.281499999999994	34.0251999999999981	34.4626999999999981	-530.488000000000056	0	meter
geocov_ctddowncast.ds1003.e1	other	geocov_ctddowncast.ds1003.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9208	34.2444500000000005	-120.5595	-119.2821	34.0262000000000029	34.4626999999999981	-533.458999999999946	0	meter
geocov_ctddowncast.ds1004.e1	other	geocov_ctddowncast.ds1004.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.917649999999995	34.2464500000000029	-120.5578	-119.277500000000003	34.0307000000000031	34.4622000000000028	-577.025999999999954	0	meter
geocov_ctddowncast.ds1005.e1	other	geocov_ctddowncast.ds1005.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922849999999997	34.2441499999999976	-120.561199999999999	-119.284499999999994	34.0242999999999967	34.4639999999999986	-579.996999999999957	0	meter
geocov_ctddowncast.ds1006.e1	other	geocov_ctddowncast.ds1006.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920000000000002	34.2441499999999976	-120.5595	-119.280500000000004	34.0257999999999967	34.4624999999999986	-580.986999999999966	0	meter
geocov_ctddowncast.ds1007.e1	other	geocov_ctddowncast.ds1007.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920599999999993	34.2436500000000024	-120.559200000000004	-119.281999999999996	34.0253000000000014	34.4620000000000033	-580.986999999999966	0	meter
geocov_ctddowncast.ds1008.e1	other	geocov_ctddowncast.ds1008.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921599999999998	34.2421500000000023	-120.561999999999998	-119.281199999999998	34.0234999999999985	34.460799999999999	-575.046000000000049	0	meter
geocov_ctddowncast.ds1009.e1	other	geocov_ctddowncast.ds1009.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.915300000000002	34.24315	-120.559899999999999	-119.270700000000005	34.0253999999999976	34.4609000000000023	-578.017000000000053	0	meter
geocov_ctddowncast.ds1010.e1	other	geocov_ctddowncast.ds1010.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.925299999999993	34.2440500000000014	-120.5595	-119.2911	34.0247000000000028	34.4634	-576.035999999999945	0	meter
geocov_ctddowncast.ds1011.e1	other	geocov_ctddowncast.ds1011.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922650000000004	34.2441000000000031	-120.559100000000001	-119.286199999999994	34.024799999999999	34.4634	-576.035999999999945	0	meter
geocov_ctddowncast.ds1012.e1	other	geocov_ctddowncast.ds1012.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.923599999999993	34.245199999999997	-120.559700000000007	-119.287499999999994	34.0264999999999986	34.4639000000000024	-576.035999999999945	0	meter
geocov_ctddowncast.ds1013.e1	other	geocov_ctddowncast.ds1013.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920850000000002	34.244250000000001	-120.561199999999999	-119.280500000000004	34.0249999999999986	34.4635000000000034	-575.046000000000049	0	meter
geocov_ctddowncast.ds1014.e1	other	geocov_ctddowncast.ds1014.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920550000000006	34.2448499999999996	-120.560100000000006	-119.281000000000006	34.0255999999999972	34.464100000000002	-570.096000000000004	0	meter
geocov_ctddowncast.ds1015.e1	other	geocov_ctddowncast.ds1015.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920100000000005	34.2449999999999974	-120.559799999999996	-119.2804	34.0274000000000001	34.4626000000000019	-576.035999999999945	0	meter
geocov_ctddowncast.ds1016.e1	other	geocov_ctddowncast.ds1016.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920749999999998	34.2439999999999998	-120.560000000000002	-119.281499999999994	34.024799999999999	34.4632000000000005	-499.786999999999978	0	meter
geocov_ctdtransects.ds1201.e2	other	geocov_ctdtransects.ds1201.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.970950000000002	34.2971000000000004	-120.667500000000004	-119.2744	34.0341000000000022	34.5600999999999985	-119.579999999999998	-0.800000000000000044	meter
geocov_ctdtransects.ds1202.e2	other	geocov_ctdtransects.ds1202.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921099999999996	34.2477000000000018	-120.553200000000004	-119.289000000000001	34.0313999999999979	34.4639999999999986	-119.680000000000007	-0.839999999999999969	meter
geocov_ctdtransects.ds1203.e2	other	geocov_ctdtransects.ds1203.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9392	34.2443000000000026	-120.562299999999993	-119.316100000000006	34.027000000000001	34.4615999999999971	-118.400000000000006	-0.780000000000000027	meter
geocov_ctdtransects.ds1204.e2	other	geocov_ctdtransects.ds1204.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.940049999999999	34.2441999999999993	-120.556700000000006	-119.323400000000007	34.0245999999999995	34.4637999999999991	-117.280000000000001	-0.0200000000000000004	meter
geocov_ctdtransects.ds1205.e2	other	geocov_ctdtransects.ds1205.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9251	34.2432000000000016	-120.565600000000003	-119.284599999999998	34.0255999999999972	34.460799999999999	-108.390000000000001	-0.119999999999999996	meter
geocov_ctdtransects.ds1206.e2	other	geocov_ctdtransects.ds1206.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921049999999994	34.2443000000000026	-120.556200000000004	-119.285899999999998	34.0277000000000029	34.4609000000000023	-98.5	-0.130000000000000004	meter
geocov_ctdtransects.ds1207.e2	other	geocov_ctdtransects.ds1207.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.923649999999995	34.2458999999999989	-120.559600000000003	-119.287700000000001	34.0311000000000021	34.4607000000000028	-104	-0.419999999999999984	meter
geocov_ctdtransects.ds1208.e2	other	geocov_ctdtransects.ds1208.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.906350000000003	34.2394000000000034	-120.372699999999995	-119.439999999999998	34.0283999999999978	34.4504000000000019	-119.099999999999994	-0.469999999999999973	meter
geocov_ctdtransects.ds1209.e2	other	geocov_ctdtransects.ds1209.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9315	34.2466500000000025	-120.5608	-119.302199999999999	34.0313000000000017	34.4620000000000033	-119.650000000000006	-1.03000000000000003	meter
geocov_ctdtransects.ds1210.e2	other	geocov_ctdtransects.ds1210.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.061400000000006	34.4159000000000006	-120.391599999999997	-119.731200000000001	34.3785000000000025	34.4532999999999987	-78.9599999999999937	-0.25	meter
geocov_ctdtransects.ds1211.e2	other	geocov_ctdtransects.ds1211.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.877849999999995	34.2411499999999975	-120.396000000000001	-119.359700000000004	34.0230000000000032	34.4592999999999989	-119.689999999999998	-0.0800000000000000017	meter
geocov_ctdtransects.ds1212.e2	other	geocov_ctdtransects.ds1212.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.957149999999999	34.2434000000000012	-120.563000000000002	-119.351299999999995	34.0287999999999968	34.4579999999999984	-119.900000000000006	-0.0599999999999999978	meter
geocov_ctdtransects.ds1213.e2	other	geocov_ctdtransects.ds1213.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.954499999999996	34.2496500000000026	-120.558499999999995	-119.350499999999997	34.0422999999999973	34.4570000000000007	-119.620000000000005	-1.54000000000000004	meter
geocov_ctdtransects.ds1214.e2	other	geocov_ctdtransects.ds1214.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.933149999999998	34.2508499999999998	-120.558999999999997	-119.307299999999998	34.0386000000000024	34.4630999999999972	-117.659999999999997	-0.179999999999999993	meter
geocov_ctdtransects.ds1215.e2	other	geocov_ctdtransects.ds1215.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.937399999999997	34.2479000000000013	-120.577500000000001	-119.297300000000007	34.0260999999999996	34.4697000000000031	-119.900000000000006	-0.119999999999999996	meter
geocov_ctdtransects.ds1216.e2	other	geocov_ctdtransects.ds1216.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.926699999999997	34.2433499999999995	-120.559399999999997	-119.293999999999997	34.0251000000000019	34.4615999999999971	-119.689999999999998	-0.23000000000000001	meter
geocov_ctdupcast.ds1001.e2	other	geocov_ctdupcast.ds1001.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.916799999999995	34.2362499999999983	-120.5518	-119.281800000000004	34.0253000000000014	34.4472000000000023	-499.786999999999978	0	meter
geocov_ctdupcast.ds1002.e2	other	geocov_ctdupcast.ds1002.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921400000000006	34.2439999999999998	-120.561000000000007	-119.281800000000004	34.0251000000000019	34.4628999999999976	-529.498000000000047	0	meter
geocov_ctdupcast.ds1003.e2	other	geocov_ctdupcast.ds1003.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920850000000002	34.2443000000000026	-120.559899999999999	-119.281800000000004	34.0260000000000034	34.4626000000000019	-532.469000000000051	0	meter
geocov_ctdupcast.ds1004.e2	other	geocov_ctdupcast.ds1004.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.917649999999995	34.2464500000000029	-120.5578	-119.277500000000003	34.0307000000000031	34.4622000000000028	-576.035999999999945	0	meter
geocov_ctdupcast.ds1005.e2	other	geocov_ctdupcast.ds1005.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.922849999999997	34.2441499999999976	-120.561199999999999	-119.284499999999994	34.0242999999999967	34.4639999999999986	-579.006999999999948	0	meter
geocov_ctdupcast.ds1006.e2	other	geocov_ctdupcast.ds1006.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920000000000002	34.2441499999999976	-120.5595	-119.280500000000004	34.0257999999999967	34.4624999999999986	-579.996999999999957	0	meter
geocov_ctdupcast.ds1007.e2	other	geocov_ctdupcast.ds1007.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920599999999993	34.2436500000000024	-120.559200000000004	-119.281999999999996	34.0253000000000014	34.4620000000000033	-579.996999999999957	0	meter
geocov_ctdupcast.ds1008.e2	other	geocov_ctdupcast.ds1008.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921599999999998	34.2421500000000023	-120.561999999999998	-119.281199999999998	34.0234999999999985	34.460799999999999	-574.05600000000004	0	meter
geocov_ctdupcast.ds1009.e2	other	geocov_ctdupcast.ds1009.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.915649999999999	34.2429500000000004	-120.560299999999998	-119.271000000000001	34.0253000000000014	34.4605999999999995	-577.025999999999954	0	meter
geocov_ctdupcast.ds1010.e2	other	geocov_ctdupcast.ds1010.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.927449999999993	34.2441000000000031	-120.563299999999998	-119.291600000000003	34.0245999999999995	34.4635999999999996	-575.046000000000049	0	meter
geocov_ctdupcast.ds1011.e2	other	geocov_ctdupcast.ds1011.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.923150000000007	34.2439499999999981	-120.560100000000006	-119.286199999999994	34.0245999999999995	34.4632999999999967	-575.046000000000049	0	meter
geocov_ctdupcast.ds1012.e2	other	geocov_ctdupcast.ds1012.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.924199999999999	34.2451500000000024	-120.560699999999997	-119.287700000000001	34.027000000000001	34.4632999999999967	-575.046000000000049	0	meter
geocov_ctdupcast.ds1013.e2	other	geocov_ctdupcast.ds1013.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921700000000001	34.2443499999999972	-120.562399999999997	-119.281000000000006	34.0249999999999986	34.4637000000000029	-574.05600000000004	0	meter
geocov_ctdupcast.ds1014.e2	other	geocov_ctdupcast.ds1014.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921400000000006	34.2447999999999979	-120.561499999999995	-119.281300000000002	34.025500000000001	34.464100000000002	-569.105999999999995	0	meter
geocov_ctdupcast.ds1015.e2	other	geocov_ctdupcast.ds1015.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.920950000000005	34.245199999999997	-120.561199999999999	-119.280699999999996	34.0277999999999992	34.4626000000000019	-575.046000000000049	0	meter
geocov_ctdupcast.ds1016.e2	other	geocov_ctdupcast.ds1016.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.921400000000006	34.2438500000000019	-120.561099999999996	-119.281700000000001	34.0244	34.4632999999999967	-498.795999999999992	0	meter
geocov_ds101.e1	other	Central California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from TO DO California, USA to the TO DO California.	\N	rectangle	-118.941520600000004	33.8411402500000023	-120.7536427	-117.129398499999994	32.5038629900000018	35.1784175000000019	\N	\N	\N
geocov_ds101.e2	other	Southern California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from Purisima Point to San Diego, California USA, including the eight Santa Barbara Channel Isands.	\N	rectangle	-121.786209999999997	36.2520154999999988	-122.783234500000006	-120.7891884	35.1756903400000027	37.9475250899999992	\N	\N	\N
geocov_ds102.e1	other	Southern California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from Point Arguello to San Diego, California USA, including the eight Santa Barbara Channel Isands.	\N	rectangle	-118.900000000000006	33.6000000000000014	-120.604799999999997	-117.247	32.6569999999999965	34.5561900000000009	\N	\N	\N
geocov_ds104.e1	reef	NE Pacific coast	California, USA	Nearshore reefs from Sitka, Alaska, USA to Bahia Tortugas, Baja California Sur, Mexico along the Pacific coast of North America. 	\N	rectangle	0	0	-135.347849999999994	-114.876559999999998	27.6559500000000007	57.0417300000000012	\N	\N	\N
geocov_ds104.e2	reef	Central California	California, USA	TO DO	\N	rectangle	0	0	-122.168390000000002	-121.880269999999996	36.5090000000000003	36.9859999999999971	\N	\N	\N
geocov_ds14	other	data_coverage_ds14	California, USA	The Geographic region of the kelp bed data extends along the California coast, down through the coast of Baja, Mexico: Central California (Halfmoon Bay to Purisima Point), Southern California (Point Arguello to the United States/Mexico border including the Channel Islands) and Baja California (points south of the United States/Mexico border including several offshore islands).	\N	rectangle	-119.795000000000002	33.6899999999999977	-122.439999999999998	-117.150000000000006	30	37.3800000000000026	\N	\N	\N
geocov_ds2	other	data_coverage_ds2	California, USA	Stations are located in the coastal watersheds draining into the Santa Barbara Channel, California, USA.	\N	rectangle	-119.84975	34.4770200000000031	-120.228610000000003	-119.470889999999997	34.4237400000000022	34.5302999999999969	\N	\N	\N
geocov_ds5	other	data_coverage_ds5	California, USA	Streamflow data obtained from coastal streams in southern California draining into the Santa Barbara Channel	\N	rectangle	-119.707499999999996	34.365000000000002	-120.226100000000002	-119.188900000000004	34.2421999999999969	34.4878	\N	\N	\N
geocov_ds54	other	data_coverage_ds54	California, USA	In California, USA, coastal areas along the mainland from Purisima Point (Santa Barbara County) in the north to the US-Mexico border. Coastal areas of the eight Northern and Southern Channel Islands.	\N	rectangle	-118.8841623	33.62544209	-120.639244700000006	-117.129079899999994	32.5038629900000018	34.7470211899999981	\N	\N	\N
geocov_ds90	other	California and Baja California Coasts	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from northern California, USA to the southern tip of Baja California Sur, Mexico.	\N	rectangle	-116.777000000000001	32.0300000000000011	-124.139999000000003	-109.414344	23.0043749999999996	41.0549999999999997	\N	\N	\N
geocov_udas.ds1101.e2	other	geocov_udas.ds1101.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.616650000000007	35.2257999999999996	-121.9602	-119.273099999999999	34.021099999999997	36.4305000000000021	-3	-3	meter
grid22	other	grid22	California, USA	Santa Barbara Channel offshore station grid22	\N	point	-119.3917	34.0870000000000033	-119.3917	-119.3917	34.0870000000000033	34.0870000000000033	-227	-227	meter
geocov_udas.ds1102.e2	other	geocov_udas.ds1102.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.924449999999993	34.2441499999999976	-120.564499999999995	-119.284400000000005	34.022199999999998	34.4660999999999973	-3	-3	meter
geocov_udas.ds1103.e2	other	geocov_udas.ds1103.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.635400000000004	35.3742000000000019	-121.984800000000007	-119.286000000000001	34.0225999999999971	36.7257999999999996	-3	-3	meter
geocov_udas.ds1104.e2	other	geocov_udas.ds1104.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.633399999999995	35.3526999999999987	-121.988799999999998	-119.278000000000006	34.025500000000001	36.6799000000000035	-3	-3	meter
geocov_udas.ds1105.e2	other	geocov_udas.ds1105.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.635450000000006	35.3604500000000002	-121.987399999999994	-119.283500000000004	34.0223000000000013	36.698599999999999	-3	-3	meter
geocov_udas.ds1106.e2	other	geocov_udas.ds1106.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.657650000000004	35.3832499999999968	-122.039400000000001	-119.275899999999993	34.0217000000000027	36.7447999999999979	-3	-3	meter
geocov_udas.ds1107.e2	other	geocov_udas.ds1107.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.633650000000003	35.4116	-121.988699999999994	-119.278599999999997	34.0251000000000019	36.798099999999998	-3	-3	meter
GOLB_reef1	reef	GOLB	California, USA	Goleta Bay reef	\N	point	-119.824167000000003	34.4087829999999997	-119.824167000000003	-119.824167000000003	34.4087829999999997	34.4087829999999997	\N	\N	\N
geocov_udas.ds1108.e2	other	geocov_udas.ds1108.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.559899999999999	35.0969499999999996	-121.839799999999997	-119.280000000000001	34.0197999999999965	36.1741000000000028	-3	-3	meter
geocov_udas.ds1109.e2	other	geocov_udas.ds1109.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.909649999999999	34.2436000000000007	-120.564700000000002	-119.254599999999996	34.0236999999999981	34.4635000000000034	-3	-3	meter
geocov_udas.ds1110.e2	other	geocov_udas.ds1110.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.930350000000004	34.2430499999999967	-120.572699999999998	-119.287999999999997	34.0223000000000013	34.4637999999999991	-3	-3	meter
geocov_udas.ds1111.e2	other	geocov_udas.ds1111.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.64255	35.3207000000000022	-121.993899999999996	-119.291200000000003	34.025500000000001	36.6159000000000034	-3	-3	meter
geocov_udas.ds1112.e2	other	geocov_udas.ds1112.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.583500000000001	35.1236000000000033	-121.879599999999996	-119.287400000000005	34.0234000000000023	36.2237999999999971	-3	-3	meter
geocov_udas.ds1113.e2	other	geocov_udas.ds1113.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.934150000000002	34.2447999999999979	-120.588999999999999	-119.279300000000006	34.0230000000000032	34.4665999999999997	-3	-3	meter
geocov_udas.ds1114.e2	other	geocov_udas.ds1114.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.930499999999995	34.2434999999999974	-120.576999999999998	-119.284000000000006	34.0204000000000022	34.4665999999999997	-3	-3	meter
geocov_udas.ds1115.e2	other	geocov_udas.ds1115.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.945700000000002	34.2531000000000034	-120.608400000000003	-119.283000000000001	34.0238999999999976	34.4823000000000022	-3	-3	meter
geocov_udas.ds1116.e2	other	geocov_udas.ds1116.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.924499999999995	34.2428499999999971	-120.567300000000003	-119.281700000000001	34.0245999999999995	34.4611000000000018	-3	-3	meter
GOLB1	other	GOLB1	California, USA	Goleta Bay Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at western edge of existing kelp bed. Mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 18 feet.	\N	point	-119.822400000000002	34.4137830000000022	-119.822400000000002	-119.822400000000002	34.4137830000000022	34.4137830000000022	-5.49000000000000021	-5.49000000000000021	meter
GOLB_1km_box	reef	Goleta Bay Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.819580000000002	34.4697299999999984	-119.828329999999994	-119.810829999999996	34.4050999999999974	34.4155999999999977	\N	\N	\N
GOLB2	other	GOLB2	California, USA	Goleta Bay Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect has mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 18 feet.	\N	point	-119.821799999999996	34.413649999999997	-119.821799999999996	-119.821799999999996	34.413649999999997	34.413649999999997	-5.49000000000000021	-5.49000000000000021	meter
GoletaRdYard211	other	Santa Barbara County Road Yard	California, USA	Santa Barbara County Road Yard	\N	point	-119.766666700000002	34.4500000000000028	-119.766666700000002	-119.766666700000002	34.4500000000000028	34.4500000000000028	\N	\N	\N
grid1	other	grid1	California, USA	Santa Barbara Channel offshore station grid1	\N	point	-120.558499999999995	34.4568999999999974	-120.558499999999995	-120.558499999999995	34.4568999999999974	34.4568999999999974	-84	-84	meter
grid10	other	grid10	California, USA	Santa Barbara Channel offshore station grid10	\N	point	-120.100350000000006	34.0583000000000027	-120.100350000000006	-120.100350000000006	34.0583000000000027	34.0583000000000027	-56	-56	meter
grid11	other	grid11	California, USA	Santa Barbara Channel offshore station grid11	\N	point	-120.051100000000005	34.1507000000000005	-120.051100000000005	-120.051100000000005	34.1507000000000005	34.1507000000000005	-499	-499	meter
grid12	other	grid12	California, USA	Santa Barbara Channel offshore station grid12	\N	point	-120.025000000000006	34.2254999999999967	-120.025000000000006	-120.025000000000006	34.2254999999999967	34.2254999999999967	-588	-588	meter
grid13	other	grid13	California, USA	Santa Barbara Channel offshore station grid13	\N	point	-119.991299999999995	34.3121000000000009	-119.991299999999995	-119.991299999999995	34.3121000000000009	34.3121000000000009	-533	-533	meter
grid14	other	grid14	California, USA	Santa Barbara Channel offshore station grid14	\N	point	-119.950999999999993	34.4097000000000008	-119.950999999999993	-119.950999999999993	34.4097000000000008	34.4097000000000008	-60	-60	meter
grid15	other	grid15	California, USA	Santa Barbara Channel offshore station grid15	\N	point	-119.906899999999993	34.2490999999999985	-119.906899999999993	-119.906899999999993	34.2490999999999985	34.2490999999999985	-518	-518	meter
grid16	other	grid16	California, USA	Santa Barbara Channel offshore station grid16	\N	point	-119.790000000000006	34.0664999999999978	-119.790000000000006	-119.790000000000006	34.0664999999999978	34.0664999999999978	-75	-75	meter
grid17	other	grid17	California, USA	Santa Barbara Channel offshore station grid17	\N	point	-119.722999999999999	34.1514999999999986	-119.722999999999999	-119.722999999999999	34.1514999999999986	34.1514999999999986	-366	-366	meter
GOLB_reef	reef	Goleta Bay	California, USA	Goleta Bay is located on the Santa Barbara Channel east of Goleta Pier. Depth range is -4.2 to -5 meters.	\N	polygon	-119.822402999999994	34.4137993000000009	-119.822402999999994	-119.822402999999994	34.4137993000000009	34.4137993000000009	\N	\N	\N
GOLB	other	GOLB	California, USA	Goleta Bay is located on the Santa Barbara Channel east of Goleta Pier. Depth range is -4.2 to -5 meters.	\N	point	-119.872100000000003	34.4137164999999996	-119.822100000000006	-119.822100000000006	34.4137164999999996	34.4137164999999996	\N	\N	\N
grid18	other	grid18	California, USA	Santa Barbara Channel offshore station grid18	\N	point	-119.663600000000002	34.2254999999999967	-119.663600000000002	-119.663600000000002	34.2254999999999967	34.2254999999999967	-147	-147	meter
grid19	other	grid19	California, USA	Santa Barbara Channel offshore station grid19	\N	point	-119.604200000000006	34.3010000000000019	-119.604200000000006	-119.604200000000006	34.3010000000000019	34.3010000000000019	-84	-84	meter
grid2	other	grid2	California, USA	Santa Barbara Channel offshore station grid2	\N	point	-120.522099999999995	34.375	-120.522099999999995	-120.522099999999995	34.375	34.375	-262	-262	meter
grid20	other	grid20	California, USA	Santa Barbara Channel offshore station grid20	\N	point	-119.544799999999995	34.3766000000000034	-119.544799999999995	-119.544799999999995	34.3766000000000034	34.3766000000000034	-29	-29	meter
grid21	other	grid21	California, USA	Santa Barbara Channel offshore station grid21	\N	point	-119.439400000000006	34.0255999999999972	-119.439400000000006	-119.439400000000006	34.0255999999999972	34.0255999999999972	-75	-75	meter
grid23	other	grid23	California, USA	Santa Barbara Channel offshore station grid23	\N	point	-119.3583	34.1257999999999981	-119.3583	-119.3583	34.1257999999999981	34.1257999999999981	-180	-180	meter
grid24	other	grid24	California, USA	Santa Barbara Channel offshore station grid24	\N	point	-119.320499999999996	34.1783000000000001	-119.320499999999996	-119.320499999999996	34.1783000000000001	34.1783000000000001	-22	-22	meter
grid25	other	grid25	California, USA	Santa Barbara Channel offshore station grid25	\N	point	-119.280299999999997	34.2254999999999967	-119.280299999999997	-119.280299999999997	34.2254999999999967	34.2254999999999967	-18	-18	meter
grid3	other	grid3	California, USA	Santa Barbara Channel offshore station grid3	\N	point	-120.473799999999997	34.2749999999999986	-120.473799999999997	-120.473799999999997	34.2749999999999986	34.2749999999999986	-442	-442	meter
grid4	other	grid4	California, USA	Santa Barbara Channel offshore station grid4	\N	point	-120.430000000000007	34.1935000000000002	-120.430000000000007	-120.430000000000007	34.1935000000000002	34.1935000000000002	-170	-170	meter
grid5	other	grid5	California, USA	Santa Barbara Channel offshore station grid5	\N	point	-120.392660000000006	34.1171399999999991	-120.392660000000006	-120.392660000000006	34.1171399999999991	34.1171399999999991	-71	-71	meter
grid6	other	grid6	California, USA	Santa Barbara Channel offshore station grid6	\N	point	-120.333399999999997	34.2222999999999971	-120.333399999999997	-120.333399999999997	34.2222999999999971	34.2222999999999971	-470	-470	meter
grid7	other	grid7	California, USA	Santa Barbara Channel offshore station grid7	\N	point	-120.276799999999994	34.3215000000000003	-120.276799999999994	-120.276799999999994	34.3215000000000003	34.3215000000000003	-378	-378	meter
grid8	other	grid8	California, USA	Santa Barbara Channel offshore station grid8	\N	point	-120.230800000000002	34.4065000000000012	-120.230800000000002	-120.230800000000002	34.4065000000000012	34.4065000000000012	-214	-214	meter
grid9	other	grid9	California, USA	Santa Barbara Channel offshore station grid9	\N	point	-120.121600000000001	34.4632000000000005	-120.121600000000001	-120.121600000000001	34.4632000000000005	34.4632000000000005	-29	-29	meter
GV201	other	Gaviota at Hwy 101 N rest stop	California, USA	Gaviota at Hwy 101 N rest stop	\N	point	-120.229169999999996	34.4801100000000034	-120.229169999999996	-120.229169999999996	34.4801100000000034	34.4801100000000034	\N	\N	\N
GV202	other	Gaviota at Las Cruces School	California, USA	Gaviota at Las Cruces School	\N	point	-120.228610000000003	34.5076499999999982	-120.228610000000003	-120.228610000000003	34.5076499999999982	34.5076499999999982	\N	\N	\N
Haskells	other	Haskells Beach	California, USA	Haskells Beach	\N	point	-119.91413	34.4297699999999978	-119.91413	-119.91413	34.4297699999999978	34.4297699999999978	\N	\N	\N
HO00	other	HO00, Arroyo Hondo Creek, Arroyo Hondo at Upstream Side of 101 Bridge	California, USA	HO00, Arroyo Hondo Creek, Arroyo Hondo at Upstream Side of 101 Bridge	\N	point	-120.141220000000004	34.4752858000000018	-120.141220000000004	-120.141220000000004	34.4752858000000018	34.4752858000000018	\N	\N	\N
HO201	other	Arroyo Hondo at East Avocado Orchard	California, USA	Arroyo Hondo at East Avocado Orchard	\N	point	-120.140640000000005	34.4765099999999975	-120.140640000000005	-120.140640000000005	34.4765099999999975	34.4765099999999975	\N	\N	\N
HO202	other	Arroyo Hondo at Upper Outlaw Trail	California, USA	Arroyo Hondo at Upper Outlaw Trail	\N	point	-120.136780000000002	34.4905899999999974	-120.136780000000002	-120.136780000000002	34.4905899999999974	34.4905899999999974	\N	\N	\N
howlands	reef	Howland landing	California, USA	Howland Landing is located on the western end (northern side) of Santa Catalina Island, in the Channel Islands of California, a few miles from the town of Two Harbors.	\N	point	-118.522000000000006	33.4650000000000034	-118.522000000000006	-118.522000000000006	33.4650000000000034	33.4650000000000034	\N	\N	\N
INSERT	other	INSERT TEMPLATE SITE	California, USA	This site is a place holder for a site to be added by code. INSERT DESCRIPTION	\N	point	0	0	0	0	0	0	\N	\N	\N
Isla Vista West Beach	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.873850000000004	34.4092800000000025	-119.873850000000004	-119.873850000000004	34.4092800000000025	34.4092800000000025	\N	\N	\N
IVEE	other	IVEE	California, USA	Isla Vista (IV) Reef is located on the Santa Barbara Channel near the University of California Santa Barbara, CA. Depth range is from -8.2 to -8.8 meters.	\N	point	-119.857550000000003	34.4027829999999994	-119.857550000000003	-119.857550000000003	34.4027829999999994	34.4027829999999994	\N	\N	\N
IVEE1	other	IVEE1	California, USA	Isla Vista Reef Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at western edge of existing eastern kelp bed near Depressions beach; a mudstone and small boulder substrate with some sand channels and slight relief (0-1 m). Depth is approximately 30 feet.	\N	point	-119.857866999999999	34.4028330000000011	-119.857866999999999	-119.857866999999999	34.4028330000000011	34.4028330000000011	-9.14000000000000057	-9.14000000000000057	meter
IVEE_1km_box	reef	Isla Vista Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.872079999999997	34.4697299999999984	-119.893330000000006	-119.850830000000002	34.3958000000000013	34.4189000000000007	\N	\N	\N
IVEE2	other	IVEE2	California, USA	IV Reef Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Transect has a mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 30 feet.	\N	point	-119.857232999999994	34.4027329999999978	-119.857232999999994	-119.857232999999994	34.4027329999999978	34.4027329999999978	-9.14000000000000057	-9.14000000000000057	meter
IVEE_beach	beach	Isla Vista Beach	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
IVEE_reef	reef	Isla Vista Reef	California, USA	Isla Vista (IV) Reef is located on the Santa Barbara Channel near the University of California Santa Barbara, CA. Depth range is from -8.2 to -8.8 meters	\N	polygon	-119.857803000000004	34.4137993000000009	-119.857803000000004	-119.857803000000004	34.4137993000000009	34.4137993000000009	\N	\N	\N
IVWB	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.873850000000004	34.4092830000000021	-119.873850000000004	-119.873850000000004	34.4092830000000021	34.4092830000000021	\N	\N	\N
IVWBA	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.873850000000004	34.4092830000000021	-119.873850000000004	-119.873850000000004	34.4092830000000021	34.4092830000000021	\N	\N	\N
klose_DT1	other	klose_DT1	California, USA	CaÃ±adaLarga. Urban; industrial. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Low dissolved oxygen. Category for this study: Non-reference.	\N	point	-119.295140000000004	34.3370499999999979	-119.295140000000004	-119.295140000000004	34.3370499999999979	34.3370499999999979	\N	\N	\N
klose_DT2	other	klose_DT2	California, USA	San Antonio Creek. Residential, Agricultural; downstream from large horse stable and winery. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: High nitrogen concentrations. Category for this study: Non-reference.	\N	point	-119.306960000000004	34.3809499999999986	-119.306960000000004	-119.306960000000004	34.3809499999999986	34.3809499999999986	\N	\N	\N
klose_REF11	other	klose_REF11	California, USA	Ventura River below NF/Upper Matilija Conf.. Residential, Wildlands. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.296800000000005	34.4831199999999995	-119.296800000000005	-119.296800000000005	34.4831199999999995	34.4831199999999995	\N	\N	\N
klose_REF12	other	klose_REF12	California, USA	North Fork Matilija Creek. Primarily Wildlands; limited upstream development. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.306489999999997	34.4912899999999993	-119.306489999999997	-119.306489999999997	34.4912899999999993	34.4912899999999993	\N	\N	\N
klose_REF13	other	klose_REF13	California, USA	Upper Matilija Creek. Primarily Wildlands; limited upstream development. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.329059999999998	34.4939699999999974	-119.329059999999998	-119.329059999999998	34.4939699999999974	34.4939699999999974	\N	\N	\N
klose_ST1	other	klose_ST1	California, USA	Ventura River Bridge. Urban; below industrial, agricultural areas; surrounded by major roads, bike path, railroad tracks, and bridge. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae, eutrophication. Category for this study: Non-reference.	\N	point	-119.309399999999997	34.2772099999999966	-119.309399999999997	-119.309399999999997	34.2772099999999966	34.2772099999999966	\N	\N	\N
klose_ST10	other	klose_ST10	California, USA	Ventura River Above San Antonio Creek. Residential; rural with low density residential housing. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.308179999999993	34.3814399999999978	-119.308179999999993	-119.308179999999993	34.3814399999999978	34.3814399999999978	\N	\N	\N
klose_ST2	other	klose_ST2	California, USA	Ventura River Reach. Urban; below industrial, agricultural areas; surrounded by major roads, bike path, railroad tracks, and bridge. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae, eutrophication. Category for this study: Non-reference.	\N	point	-119.309070000000006	34.2769699999999986	-119.309070000000006	-119.309070000000006	34.2769699999999986	34.2769699999999986	\N	\N	\N
klose_ST3	other	klose_ST3	California, USA	Main Street (Reach 1). Urban, Agricultural; multiple uses â industrial, agricultural, institutional. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae. Category for this study: Non-reference.	\N	point	-119.308899999999994	34.2827300000000008	-119.308899999999994	-119.308899999999994	34.2827300000000008	34.2827300000000008	\N	\N	\N
klose_ST4	other	klose_ST4	California, USA	Stanley Drain (Reach 2). Agricultural; below industrial, residential, and institutional areas. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae. Category for this study: Non-reference.	\N	point	-119.301699999999997	34.3043899999999979	-119.301699999999997	-119.301699999999997	34.3043899999999979	34.3043899999999979	\N	\N	\N
klose_ST5	other	klose_ST5	California, USA	Shell Road. Urban; industrial. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.295559999999995	34.3166200000000003	-119.295559999999995	-119.295559999999995	34.3166200000000003	34.3166200000000003	\N	\N	\N
klose_ST6	other	klose_ST6	California, USA	Ventura River Below Ojai Sanitation Plant. Urban; multiple uses â industrial, agricultural, institutional. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.296779999999998	34.3374600000000001	-119.296779999999998	-119.296779999999998	34.3374600000000001	34.3374600000000001	\N	\N	\N
klose_ST7	other	klose_ST7	California, USA	Ventura River Above Ojai Sanitation Plant. Agricultural; below industrial, residential, and institutional areas. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.299130000000005	34.344380000000001	-119.299130000000005	-119.299130000000005	34.344380000000001	34.344380000000001	\N	\N	\N
klose_ST8	other	klose_ST8	California, USA	Foster Park. County Park on one side, undeveloped land on other. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.309200000000004	34.3534900000000007	-119.309200000000004	-119.309200000000004	34.3534900000000007	34.3534900000000007	\N	\N	\N
klose_ST9	other	klose_ST9	California, USA	Ventura River Below San Antonio Creek. Residential; rural with low density residential housing. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.307950000000005	34.3796999999999997	-119.307950000000005	-119.307950000000005	34.3796999999999997	34.3796999999999997	\N	\N	\N
KTYD227	other	KTYD	California, USA	KTYD	\N	point	-119.691716	34.4223009999999974	-119.691716	-119.691716	34.4223009999999974	34.4223009999999974	\N	\N	\N
lions_head	reef	Lions Head Point	California, USA	Lion Head Point is located on the western end (northern side) of Catalina Island, in the Channel Islands of California, near the town of Two Harbors.	\N	point	-118.501999999999995	33.453000000000003	-118.501999999999995	-118.501999999999995	33.453000000000003	33.453000000000003	\N	\N	\N
LOL	intertidal	Lompoc Landing	California, USA	Lompoc Landing (LOL) is a rocky intertidal site located on the Vandenberg Air Force Base (VAFB) and is just north of Surf Beach	\N	point	-120.608799399999995	34.7190567900000033	-120.608799399999995	-120.608799399999995	34.7190567900000033	34.7190567900000033	\N	\N	\N
MC06	other	Mission Creek at Rocky Nook, USGS 11119745	California, USA	Mission Creek at Rocky Nook, USGS 11119745	\N	point	-119.712440000000001	34.4407199999999989	-119.712440000000001	-119.712440000000001	34.4407199999999989	34.4407199999999989	\N	\N	\N
mcrlter1_fringing_reef	other	MCR LTER 1 Fringing Reef	Moorea, French Polynesia	Moorea, French MCR LTER 1 Fringing Reef, Moorea, French Polynesia	MCR LTER	rectangle	-149.798900000000003	-17.4802999999999997	-149.798900000000003	-149.798900000000003	-17.4802999999999997	-17.4802999999999997	\N	\N	\N
MENDOCINO	nearshore	Mendocino  	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
MI	other	Mohawk Inshore	California, USA	Mohawk Inshore	\N	point	-119.729169999999996	34.3948800000000006	-119.729169999999996	-119.729169999999996	34.3948800000000006	34.3948800000000006	\N	\N	\N
MK	other	Mohawk Reef	California, USA	Mohawk Reef	\N	point	-119.730119999999999	34.3933800000000005	-119.730119999999999	-119.730119999999999	34.3933800000000005	34.3933800000000005	\N	\N	\N
MK_CS1	other	Mohawk Inshore Cross Shelf 1	California, USA	Mohawk Inshore Cross Shelf 1	\N	point	-119.730119999999999	34.3675500000000014	-119.730119999999999	-119.730119999999999	34.3675500000000014	34.3675500000000014	\N	\N	\N
MK_CS2	other	Mohawk Reef Cross Shelf 2	California, USA	Mohawk Reef Cross Shelf 2	\N	point	-119.730119999999999	34.3757999999999981	-119.730119999999999	-119.730119999999999	34.3757999999999981	34.3757999999999981	\N	\N	\N
MK_CS3	other	Mohawk Reef Cross Shelf 3	California, USA	Mohawk Reef Cross Shelf 3	\N	point	-119.730119999999999	34.384999999999998	-119.730119999999999	-119.730119999999999	34.384999999999998	34.384999999999998	\N	\N	\N
MK_CS4	other	Mohawk Reef Cross Shelf 4	California, USA	Mohawk Reef Cross Shelf 4	\N	point	-119.730119999999999	34.3901299999999992	-119.730119999999999	-119.730119999999999	34.3901299999999992	34.3901299999999992	\N	\N	\N
MK_CS5	other	Mohawk Reef Cross Shelf 5	California, USA	Mohawk Reef Cross Shelf 5	\N	point	-119.730119999999999	34.3933800000000005	-119.730119999999999	-119.730119999999999	34.3933800000000005	34.3933800000000005	\N	\N	\N
MKO	other	MKO	California, USA	MKO is located at Mohawk reef, at the offshore spar buoy. Depth is 10.8 meters.	\N	point	-119.730119999999999	34.3932300000000026	-119.730119999999999	-119.730119999999999	34.3932300000000026	34.3932300000000026	\N	\N	\N
MOHK	other	MOHK	California, USA	Mohawk Reef: Mohawk Reef depth ranges from 4.5m to 6.0 m. Reference on land is Mohawk Rd / Edgewater Way.	\N	point	-119.729569999999995	34.3940708000000015	-119.729569999999995	-119.729569999999995	34.3940708000000015	34.3940708000000015	\N	\N	\N
MOHK1	other	MOHK1	California, USA	Mohawk Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect has a bedrock substrate with some moderate relief (0-1.5 m) and some small (1-2 m) areas of silty sand / shell hash. Transect follows a reef ledge that is ~1-2m off the sand below. Depth is approximately 24 feet.	\N	point	-119.730000000000004	34.3943330000000032	-119.730000000000004	-119.730000000000004	34.3943330000000032	34.3943330000000032	-7.32000000000000028	-7.32000000000000028	meter
MOHK_1km_box	reef	Mohawk Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.732500000000002	34.4697299999999984	-119.737499999999997	-119.727500000000006	34.3858000000000033	34.3995000000000033	\N	\N	\N
NI	other	Naples Inshore	California, USA	Naples Inshore	\N	point	-119.950530000000001	34.4277200000000008	-119.950530000000001	-119.950530000000001	34.4277200000000008	34.4277200000000008	\N	\N	\N
NO	other	Naples Offshore	California, USA	Naples Offshore	\N	point	-119.956019999999995	34.4130499999999984	-119.956019999999995	-119.956019999999995	34.4130499999999984	34.4130499999999984	\N	\N	\N
MOHK2	other	MOHK2	California, USA	Mohawk Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small (1-2 m) areas of silty sand. Transect follows a small reef ledge that is ~1m off the sand below. Depth is approximately 24 feet.	\N	point	-119.729366999999996	34.3941500000000033	-119.729366999999996	-119.729366999999996	34.3941500000000033	34.3941500000000033	-7.32000000000000028	-7.32000000000000028	meter
MOHK3	other	MOHK3	California, USA	Mohawk Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 55 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small (1-3 m) areas of silty sand. Transect follows a small reef ledge that is ~1.5m off the sand below. Depth is approximately 26 feet.	\N	point	-119.729483000000002	34.3937999999999988	-119.729483000000002	-119.729483000000002	34.3937999999999988	34.3937999999999988	-7.91999999999999993	-7.91999999999999993	meter
MOHK4	other	MOHK4	California, USA	Mohawk Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 270 (degree). Runs west along bedrock substrate with low relief (0-1.5m) and some areas of silty sand. Depth approximately 25 feet.. Kelp continually cleared in 2m band on all sides of the transect.	\N	point	-119.729416999999998	34.3939999999999984	-119.729416999999998	-119.729416999999998	34.3939999999999984	34.3939999999999984	-7.40000000000000036	-7.40000000000000036	meter
MOHK_reef	reef	Mohawk Reef	California, USA	Mohawk Reef is located on the Santa Barbara Channel, east of Arroyo Burro Beach, Santa Barbara, CA. Depth range from 4.5m to 6.0 m	\N	polygon	-119.730002999999996	34.3943291000000002	-119.730002999999996	-119.730002999999996	34.3943291000000002	34.3943291000000002	\N	\N	\N
NAP	other	NAP	California, USA	 The reef is offshore from the community of Naples. Depth: 16.5 meters.	\N	point	-119.950320000000005	34.4238799999999969	-119.950320000000005	-119.950320000000005	34.4238799999999969	34.4238799999999969	-16.5	0	meter
NAPL	other	NAPL	California, USA	Naples Reef is located on the Santa Barbara Channel near the community of Naples and Dos Pueblos Canyon, Santa Barbara County, CA. Depth ranges from -5.9 to -13.4 meters.	\N	point	-119.951539999999994	34.422121599999997	-119.951539999999994	-119.951539999999994	34.422121599999997	34.422121599999997	\N	\N	\N
NAPL1	other	NAPL1	California, USA	Naples Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 60 (degree). Transect begins at extreme western edge of Naples main reef. Bedrock substrate with some significant relief (0-2 m). Depth is approximately 25 feet.	\N	point	-119.952933000000002	34.4223330000000018	-119.952933000000002	-119.952933000000002	34.4223330000000018	34.4223330000000018	-7.62000000000000011	-7.62000000000000011	meter
NAPL10	other	NAPL10	California, USA	Naples Transect 10: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some significant relief (0-2.5m). Transect crosses several ridges that run ~110-120 degrees. Depth is approximately 30â. Kelp continually cleared in 2m band on all sides of the transect.	\N	point	-119.951217	34.422032999999999	-119.951217	-119.951217	34.422032999999999	34.422032999999999	-9.09999999999999964	-9.09999999999999964	meter
NAPL_1km_box	reef	Naples Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.957499999999996	34.4697299999999984	-119.966669999999993	-119.948329999999999	34.4232999999999976	34.4406999999999996	\N	\N	\N
NAPL2	other	NAPL2	California, USA	Naples Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some significant relief (0-2 m). Depth is approximately 25 feet.	\N	point	-119.952316999999994	34.4224669999999975	-119.952316999999994	-119.952316999999994	34.4224669999999975	34.4224669999999975	-7.62000000000000011	-7.62000000000000011	meter
NAPL3	other	NAPL3	California, USA	Naples Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some significant relief (0-2 m). Depth approximately 25'.	\N	point	-119.951700000000002	34.4223670000000013	-119.951700000000002	-119.951700000000002	34.4223670000000013	34.4223670000000013	-7.62000000000000011	-7.62000000000000011	meter
NAPL4	other	NAPL4	California, USA	Naples Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). âDeep Cobble.â Located approximately 7 m south of the ridges that define the main reef. Depth is approximately 35 feet.	\N	point	-119.951899999999995	34.4222999999999999	-119.951899999999995	-119.951899999999995	34.4222999999999999	34.4222999999999999	-10.6699999999999999	-10.6699999999999999	meter
NAPL5	other	NAPL5	California, USA	Naples Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 100 (degree). Transect begins at the apex of the âhorseshoeâ on the first flat bench east of deep cobble. Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 35 feet.	\N	point	-119.951283000000004	34.4218830000000011	-119.951283000000004	-119.951283000000004	34.4218830000000011	34.4218830000000011	-10.6699999999999999	-10.6699999999999999	meter
NAPL6	other	NAPL6	California, USA	Naples Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 105 (degree). Bedrock substrate with some significant relief (0-2 m). Depth increases from approximately 33 to 45 feet along transect.	\N	point	-119.950632999999996	34.4219500000000025	-119.950632999999996	-119.950632999999996	34.4219500000000025	34.4219500000000025	-11.8900000000000006	-11.8900000000000006	meter
NAPL7	other	NAPL7	California, USA	Naples Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at the western end of âThree fingersâ where the reef begins to slope from east to west into deeper water. Bedrock substrate with some significant relief (0-2 m). Depth decreases from approximately 36 to 28 feet along transect.	\N	point	-119.951832999999993	34.4219000000000008	-119.951832999999993	-119.951832999999993	34.4219000000000008	34.4219000000000008	-9.75	-9.75	meter
SanMarcosPass212	other	San Marcos Pass USFS Stn	California, USA	San Marcos Pass USFS Stn	\N	point	-119.8238889	34.5111111100000016	-119.8238889	-119.8238889	34.5111111100000016	34.5111111100000016	\N	\N	\N
Santa Claus Lane Beach	other	Santa Claus Lane Beach	California, USA	Santa Claus Lane Beach	\N	point	-119.551580000000001	34.4085299999999989	-119.551580000000001	-119.551580000000001	34.4085299999999989	34.4085299999999989	\N	\N	\N
NAPL8	other	NAPL8	California, USA	Naples Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 100 (degree). Located on a prominent ridge (3 m relief). Bedrock substrate with some significant relief (0-2 m). Depth increases from approximately 33 to 45 feet along the transect.	\N	point	-119.950316999999998	34.4218329999999995	-119.950316999999998	-119.950316999999998	34.4218329999999995	34.4218329999999995	-11.8900000000000006	-11.8900000000000006	meter
NAPL9	other	NAPL9	California, USA	Naples Transect 9: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some significant relief (0-2 m). Depth approximately 25 feet.	\N	point	-119.951217	34.422150000000002	-119.951217	-119.951217	34.422150000000002	34.422150000000002	-7.62000000000000011	-7.62000000000000011	meter
NAPL_reef	reef	Naples Reef	California, USA	Naples Reef is located on the Santa Barbara Channel near the community of Naples and Dos Pueblos Canyon, Santa Barbara County, CA. Depth ranges from -5.9 to -13.4 meters.	\N	polygon	-119.950301999999994	34.4239006000000032	-119.949996999999996	-119.949996999999996	34.4239006000000032	34.4239006000000032	\N	\N	\N
Nojoqui236	other	Nojoqui Falls Park	California, USA	Nojoqui Falls Park	\N	point	-120.177777800000001	34.5338888900000001	-120.177777800000001	-120.177777800000001	34.5338888900000001	34.5338888900000001	\N	\N	\N
NR	other	Naples Reef - near mooring site NAP	California, USA	Naples Reef - near mooring site NAP	\N	point	-119.950320000000005	34.4238500000000016	-119.950320000000005	-119.950320000000005	34.4238500000000016	34.4238500000000016	\N	\N	\N
ocnbch	other	Ocean Beach, San Diego CA	California, USA	Ocean Beach, San Diego CA	\N	point	-117.256619999999998	32.749139999999997	-117.256619999999998	-117.256619999999998	32.749139999999997	32.749139999999997	\N	\N	\N
ON02	other	ON02, San Onofre Creek, San Onofre Creek at Highway 101 North culvert	California, USA	ON02, San Onofre Creek, San Onofre Creek at Highway 101 North culvert	\N	point	-120.288849999999996	34.4720000000000013	-120.288849999999996	-120.288849999999996	34.4720000000000013	34.4720000000000013	\N	\N	\N
pb1	other	Santa Barbara Channel offshore station pb1	California, USA	Santa Barbara Channel offshore station pb1	\N	point	-119.840670000000003	34.3901699999999977	-119.840670000000003	-119.840670000000003	34.3901699999999977	34.3901699999999977	-55	-55	meter
pb2	other	Santa Barbara Channel offshore station pb2	California, USA	Santa Barbara Channel offshore station pb2	\N	point	-119.862669999999994	34.3434999999999988	-119.862669999999994	-119.862669999999994	34.3434999999999988	34.3434999999999988	-252	-252	meter
pb3	other	Santa Barbara Channel offshore station pb3	California, USA	Santa Barbara Channel offshore station pb3	\N	point	-119.884500000000003	34.2968299999999999	-119.884500000000003	-119.884500000000003	34.2968299999999999	34.2968299999999999	-403	-403	meter
pb4	other	Santa Barbara Channel offshore station pb4	California, USA	Santa Barbara Channel offshore station pb4	\N	point	-119.906329999999997	34.2501699999999971	-119.906329999999997	-119.906329999999997	34.2501699999999971	34.2501699999999971	-522	-522	meter
pb5	other	Santa Barbara Channel offshore station pb5	California, USA	Santa Barbara Channel offshore station pb5	\N	point	-119.928330000000003	34.2034999999999982	-119.928330000000003	-119.928330000000003	34.2034999999999982	34.2034999999999982	-538	-538	meter
pb6	other	Santa Barbara Channel offshore station pb6	California, USA	Santa Barbara Channel offshore station pb6	\N	point	-119.95017	34.1568299999999994	-119.95017	-119.95017	34.1568299999999994	34.1568299999999994	-440	-440	meter
GOSL	reef	GOSL	California, USA	Goleta Slough	\N	point	-119.827594000000005	34.4184750000000008	-119.827594000000005	-119.827594000000005	34.4184750000000008	34.4184750000000008	\N	\N	\N
pb7	other	Santa Barbara Channel offshore station pb7	California, USA	Santa Barbara Channel offshore station pb7	\N	point	-120.033330000000007	34.0833299999999966	-120.033330000000007	-120.033330000000007	34.0833299999999966	34.0833299999999966	-83	-83	meter
PRZ	other	Prisoner's Harbor Pier, Santa Cruz Island (PRZ)	California, USA	North shore of Santa Cruz Island, Santa Barbara Channel Islands, California.	\N	point	-119.684299999999993	34.0204000000000022	-119.684299999999993	-119.684299999999993	34.0204000000000022	34.0204000000000022	\N	\N	\N
PUR	nearshore	Purisima Point	California	Purisima (PUR) is located pproximately 3.5 km SSE of Purisima Point, California, USA, in rocky habitat 15 meters below Mean Sea Level (MSL).	\N	point	-120.627600000000001	34.7260199999999983	-120.627600000000001	-120.627600000000001	34.7260199999999983	34.7260199999999983	-15	0	meter
QI	other	Arroyo Quemado Inshore	California, USA	Arroyo Quemado Inshore	\N	point	-120.119330000000005	34.4684299999999979	-120.119330000000005	-120.119330000000005	34.4684299999999979	34.4684299999999979	\N	\N	\N
QM	other	Arroyo Quemado Reef1 - - at pre2005-mooring site AQM	California, USA	Arroyo Quemado Reef1 - - at pre2005-mooring site AQM	\N	point	-120.120570000000001	34.4646400000000028	-120.120570000000001	-120.120570000000001	34.4646400000000028	34.4646400000000028	\N	\N	\N
QO	other	Arroyo Qmemado Offshore	California, USA	Arroyo Qmemado Offshore	\N	point	-120.119370000000004	34.4613999999999976	-120.119370000000004	-120.119370000000004	34.4613999999999976	34.4613999999999976	\N	\N	\N
QR	other	Arroyo Quemado Reef - near pre2005 mooring site AQM	California, USA	Arroyo Quemado Reef - near pre2005 mooring site AQM	\N	point	-120.120050000000006	34.4672199999999975	-120.120050000000006	-120.120050000000006	34.4672199999999975	34.4672199999999975	\N	\N	\N
Refugio State Beach	other	Refugio State Beach	California, USA	Refugio State Beach	\N	point	-120.070750000000004	34.4629300000000001	-120.070750000000004	-120.070750000000004	34.4629300000000001	34.4629300000000001	\N	\N	\N
RG201	other	Refugio at State Park	California, USA	Refugio at State Park	\N	point	-120.076261000000002	34.4618529999999978	-120.076261000000002	-120.076261000000002	34.4618529999999978	34.4618529999999978	\N	\N	\N
RG202	other	Refugio at Lower Aguacitos Ranch	California, USA	Refugio at Lower Aguacitos Ranch	\N	point	-120.074830000000006	34.4912199999999984	-120.074830000000006	-120.074830000000006	34.4912199999999984	34.4912199999999984	\N	\N	\N
RG203	other	Refugio at Upper Aguacitos Ranch	California, USA	Refugio at Upper Aguacitos Ranch	\N	point	-120.079470000000001	34.5085600000000028	-120.079470000000001	-120.079470000000001	34.5085600000000028	34.5085600000000028	\N	\N	\N
RG204	other	Refugio at Rancho La Scherpa	California, USA	Refugio at Rancho La Scherpa	\N	point	-120.056359999999998	34.5302999999999969	-120.056359999999998	-120.056359999999998	34.5302999999999969	34.5302999999999969	\N	\N	\N
RMC	intertidal	Rancho Marino	California, USA	Rancho Marino (RMC) is in the rocky intertidal area near Cambria, CA. It is is part of the Univeristy of California Natural Reserve System	\N	point	-121.092846600000001	35.5403047799999996	-121.092846600000001	-121.092846600000001	35.5403047799999996	35.5403047799999996	\N	\N	\N
RN01	other	Rincon Creek, Hwy 101 Culvert, North	California, USA	Rincon Creek, Hwy 101 Culvert, North	\N	point	-119.477940000000004	34.3772999999999982	-119.477940000000004	-119.477940000000004	34.3772999999999982	34.3772999999999982	\N	\N	\N
RS02	other	RS02, Rattlesnake Creek, Rattlesnake at Las Canoas Bridge	California, USA	RS02, Rattlesnake Creek, Rattlesnake at Las Canoas Bridge	\N	point	-119.692220000000006	34.457611110000002	-119.692220000000006	-119.692220000000006	34.457611110000002	34.457611110000002	\N	\N	\N
RZR	intertidal	Razors	California, USA	Razors (RZR) is in the rocky intertidal near Alegria Beach, located on the Hollister Ranch, between Gaviota and Point Conception	\N	point	-120.278177999999997	34.4671369499999969	-120.278177999999997	-120.278177999999997	34.4671369499999969	34.4671369499999969	\N	\N	\N
SANDIEGO	nearshore	San Diego nearshore ocean	California, USA	San Diego CA, may have multiple piers.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
TroutClub242	other	Trout Club	California, USA	Trout Club	\N	point	-119.799999999999997	34.4897222199999973	-119.799999999999997	-119.799999999999997	34.4897222199999973	34.4897222199999973	\N	\N	\N
RINC_ws	land	Rincon Watershed	California, USA	Rincon Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
sbc-boilerplate-geoCov_SBC	other	Santa Barbara Coastal LTER bounding box	California, USA	The Santa Barbara Coastal LTER research area extends from Point Conception (W) to the mouth of the Santa Clara River (E) and from the Santa Ynez Mountains (N) to the north shores of the Channel Islands (S), California, USA	\N	rectangle	-119.864999999999995	34.265500000000003	-120.474999999999994	-119.254999999999995	34	34.5309999999999988	\N	\N	\N
sbc_boilerplate-geoCov_SBCHAN	other	Santa Barbara Channel	California, USA	Santa Barbara Channel: SBCHAN: The Channel is roughly defined on the north by the coastline of mainland California, USA, on the east by the outlet of the Santa Clara River, on the south by the Santa Barbara Channel Islands, and on the west by Point Arguello.	\N	rectangle	-120	34.25	-120.799999999999997	-119.200000000000003	33.8999999999999986	34.6000000000000014	-612	0	meter
SB_channel	offshore	Santa Barbara Channel	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
sbell	other	Ellwood Pier, Goleta CA	California, USA	Ellwood Pier, Goleta CA	\N	point	-119.924080000000004	34.4308499999999995	-119.924080000000004	-119.924080000000004	34.4308499999999995	34.4308499999999995	\N	\N	\N
SBEngBldg234	other	Santa Barbara Co. FCD Eng. Bldg.	California, USA	Santa Barbara Co. FCD Eng. Bldg.	\N	point	-119.700000000000003	34.4166666699999979	-119.700000000000003	-119.700000000000003	34.4166666699999979	34.4166666699999979	\N	\N	\N
SB_harbor	nearshore	Santa Barbara Harbor	California, USA	Santa Barbara Harbor is bounded by Stearns Wharf on the east and the harbor breakwater on the wes and south.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SBH_manual1	other	Santa Barbara Harbor Shore Station - approximate location.	California, USA	Santa Barbara Harbor Shore Station - approximate location.	\N	point	-119.686999999999998	34.4099999999999966	-119.686999999999998	-119.686999999999998	34.4099999999999966	34.4099999999999966	\N	\N	\N
sbstwrf	other	Stearns Wharf, Santa Barbara CA	California, USA	Stearns Wharf, Santa Barbara CA	\N	point	-119.684929999999994	34.4093400000000003	-119.684929999999994	-119.684929999999994	34.4093400000000003	34.4093400000000003	\N	\N	\N
SCBC_reef	reef	Santa Cruz Island, BC Point Reef	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCDI2	other	SCDI2	California, USA	Santa Cruz Island Diablo Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 305 (degree). Transect runs along rocky reef with patches of sand/shell debris and several large boulders. Depth is approximately 30 feet.	\N	point	-119.757632999999998	34.0586330000000004	-119.757632999999998	-119.757632999999998	34.0586330000000004	34.0586330000000004	-9.14000000000000057	-9.14000000000000057	meter
SCDI3	other	SCDI3	California, USA	Santa Cruz Island Diablo Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 335 (degree). Transect runs along rocky reef with patches of sand/shell debris and several large boulders and ledges. Depth varies from approximately 43 to 50 feet.	\N	point	-119.757632999999998	34.0586669999999998	-119.757632999999998	-119.757632999999998	34.0586669999999998	34.0586669999999998	-14.3000000000000007	-14.3000000000000007	meter
SCDI_reef	reef	Santa Cruz Island, Diablo Canyon Reef	California, USA	Diablo Reef is located the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.5 to -15 meters	\N	polygon	-119.757499999999993	34.0587997000000016	-119.757499999999993	-119.757499999999993	34.0587997000000016	34.0587997000000016	\N	\N	\N
SCLA_beach	beach	Santa Claus Lane Beach	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCLBA	other	Santa Claus Lane Beach	California, USA	Santa Claus Lane Beach	\N	point	-119.551582999999994	34.4085329999999985	-119.551582999999994	-119.551582999999994	34.4085329999999985	34.4085329999999985	\N	\N	\N
SCTE_reef	reef	Santa Cruz Island, Twin Harbors East reef	California, USA	Twin Harbors East Reef, north shore of Santa Cruz Island, Santa Barbara Channel Islands, CA.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCTW2	other	SCTW2	California, USA	Santa Cruz Island Twin Harbors West Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 330 (degree). Transect 2 lies along rocky reef with large boulders and patches of sand/shell debris. Depth is approximately 20'.	\N	point	-119.715132999999994	34.0444000000000031	-119.715132999999994	-119.715132999999994	34.0444000000000031	34.0444000000000031	-6.09999999999999964	-6.09999999999999964	meter
SCTW3	other	SCTW3	California, USA	Santa Cruz Island Twin Harbors West Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 290 (degree). Transect 3 lies along rocky reef with large boulders and patches of sand/shell debris. Depth is approximately 30 feet. At the end of the transect there is a pinnacle about 3-4m tall.	\N	point	-119.715132999999994	34.0444669999999974	-119.715132999999994	-119.715132999999994	34.0444669999999974	34.0444669999999974	-12	-12	meter
SCTW_reef	reef	Santa Cruz Island, Twin Harbor West reef	California, USA	Twin Harbor West Reef is located on the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.0 to -15 meters. Twin Harbor West Reef is located on the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.0 to -15 meters. 	\N	polygon	-119.715500000000006	34.0444984000000019	-119.715500000000006	-119.715500000000006	34.0444984000000019	34.0444984000000019	\N	\N	\N
sio	other	Scripps Peir, San Diego CA	California, USA	Scripps Peir, San Diego CA	\N	point	-117.256469999999993	32.8503899999999973	-117.256469999999993	-117.256469999999993	32.8503899999999973	32.8503899999999973	\N	\N	\N
SM01	other	Santa Monica Creek, Via Real	California, USA	Santa Monica Creek, Via Real	\N	point	-119.528689999999997	34.404797649999999	-119.528689999999997	-119.528689999999997	34.404797649999999	34.404797649999999	\N	\N	\N
SM04	other	Santa Monica at Scoop	California, USA	Santa Monica at Scoop	\N	point	-119.527010000000004	34.4189851200000021	-119.527010000000004	-119.527010000000004	34.4189851200000021	34.4189851200000021	\N	\N	\N
SMN	other	San Miguel Island, North (SMN)	California, USA	North shore of San Migule Island, Santa Barbara Channel Islands, California.	\N	point	-120.345500000000001	34.0570000000000022	-120.345500000000001	-120.345500000000001	34.0570000000000022	34.0570000000000022	\N	\N	\N
South UCSB Campus Beach	other	South UCSB Campus Beach	California, USA	South UCSB Campus Beach	\N	point	-119.846029999999999	34.4054799999999972	-119.846029999999999	-119.846029999999999	34.4054799999999972	34.4054799999999972	\N	\N	\N
SP02	other	San Pedro Creek at Stow Canyon Park, , USGS 11120520	California, USA	San Pedro Creek at Stow Canyon Park, , USGS 11120520	\N	point	-119.840280000000007	34.4486100000000022	-119.840280000000007	-119.840280000000007	34.4486100000000022	34.4486100000000022	\N	\N	\N
StanwoodFS228	other	Stanwood Fire Station	California, USA	Stanwood Fire Station	\N	point	-119.683333300000001	34.4500000000000028	-119.683333300000001	-119.683333300000001	34.4500000000000028	34.4500000000000028	\N	\N	\N
TE03	other	Tecolotito Creek, Hollister Road	California, USA	Tecolotito Creek, Hollister Road	\N	point	-119.857619999999997	34.4305499999999967	-119.857619999999997	-119.857619999999997	34.4305499999999967	34.4305499999999967	\N	\N	\N
temp_fk	reef	temp_fk	California, USA	Temporary, so bulk upload can reference it	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
TO02	other	TO02, Tecolote Creek at Vereda Galeria, Goleta	California, USA	TO02, Tecolote Creek at Vereda Galeria, Goleta	\N	point	-119.917914999999994	34.4406139999999965	-119.917914999999994	-119.917914999999994	34.4406139999999965	34.4406139999999965	\N	\N	\N
SCDI	other	SCDI	California, USA	Santa Cruz Island, Diablo	\N	point	-119.757630000000006	34.0586500000000001	-119.757630000000006	-119.757630000000006	34.0586500000000001	34.0586500000000001	\N	\N	\N
SCLB	other	SCLB	California, USA	Santa Claus Lane Beach	\N	point	-119.551582999999994	34.4085329999999985	-119.551582999999994	-119.551582999999994	34.4085329999999985	34.4085329999999985	\N	\N	\N
SCTW	other	SCTW	California, USA	Santa Cruz Island, Twin Harbor West	\N	point	-119.715500000000006	34.0444999999999993	-119.715130000000002	-119.715130000000002	34.0444334999999967	34.0444334999999967	\N	\N	\N
twin_e	other	Twin E	California, USA	Twin Harbors, East. North shore, Santa Cruz Island, CA	\N	point	-119.714083299999999	34.04345	-119.714083299999999	-119.714083299999999	34.04345	34.04345	-30	-30	Foot_US
twin_w	other	Twin W	California, USA	Twin Harbors, West. North shore, Santa Cruz Island, CA	\N	point	-119.715133300000005	34.0444000000000031	-119.715133300000005	-119.715133300000005	34.0444000000000031	34.0444000000000031	-30	-30	Foot_US
UCSB200	other	UCSB200	California, USA	UCSB200: Santa Barbara County Public Works Department Flood Control District Site at: Ellison Hall Roof, UC Santa Barbara	\N	point	-119.846111100000002	34.4149999999999991	-119.846111100000002	-119.846111100000002	34.4149999999999991	34.4149999999999991	30.5	30.5	meter
UCSB_beach	beach	UC Santa Barbara Beach	California, USA	Univeristy of California, Santa Barbara. Area sometimes called Campus Point.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
UCSB_msi	other	UC Santa Barbara, Marine Science Institute	California, USA	Marine Science Institute, Univeristy of California, Santa Barbara	\N	point	-119.841999999999999	34.4125000000000014	-119.841999999999999	-119.841999999999999	34.4125000000000014	34.4125000000000014	\N	\N	\N
geocov_ds74	other	Central and Southern California (USA) 	California, USA	Coastal areas along the mainland from near Año Nuevo (San Mateo County) in the north to San Diego in the south. Coastal areas of the eight Northern and Southern Channel Islands	\N	rectangle	-118	32.5	-122.783234500000006	-114.044759999999997	32.375	37.9475250899999992	\N	\N	\N
Carpinteria State Beach	other	Carpinteria State Beach	California, USA	Carpinteria State Beach	\N	point	-119.521236000000002	34.3911510000000007	-119.521236000000002	-119.521236000000002	34.3911510000000007	34.3911510000000007	\N	\N	\N
EBCH	other	East Santa Barbara City Beach	California, USA	East Santa Barbara City Beach	\N	point	-119.674177999999998	34.4157510000000002	-119.674177999999998	-119.674177999999998	34.4157510000000002	34.4157510000000002	\N	\N	\N
PF_B	offshore	Platform B	California, USA	Platform B in Santa Barbara Channel	\N	point	-119.621499999999997	34.3322999999999965	-119.621499999999997	-119.621499999999997	34.3322999999999965	34.3322999999999965	\N	\N	\N
PF_GINA	offshore	Platform Gina	California, USA	Platform Gina in Santa Barbara Channel	\N	point	-119.276200000000003	34.1174000000000035	-119.276200000000003	-119.276200000000003	34.1174000000000035	34.1174000000000035	\N	\N	\N
glider1	other	glide range	California, USA	Santa Barbara Channel	\N	point	-119.730000000000004	34.3918000000000035	-119.730000000000004	-119.730000000000004	34.3918000000000035	34.3918000000000035	\N	\N	\N
glider2	other	glide range	California, USA	Santa Barbara Channel	\N	point	-119.730000000000004	34.3541000000000025	-119.730000000000004	-119.730000000000004	34.3541000000000025	34.3541000000000025	\N	\N	\N
ABUR_beach	beach	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
BELL_ws	land	Bell Canyon Creek watershed	California, USA	Bell Canyon Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
CARP_ws	land	Carpinteria watershed	California, USA	Carpinteria watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
FRANK_ws	land	Franklin Creek Watershed	California, USA	Franklin Creek Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
GAV_nearsh	nearshore	Gaviota 	California, USA	Gaviota 	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
MISS_ws	land	Mission Creek watershed	California, USA	Mission Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
REFU_ws	land	Refugio Creek Watershed	California, USA	Refugio Creek Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SMON_ws	land	Santa Monica Creed watershed	California, USA	Santa Monica Creed watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SPED_ws	land	San Pedro Creek watershed	California, USA	San Pedro Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SPLV	land	SPLV	California, USA	San Pedro /Las Vegas	\N	point	-119.831845999999999	34.4354450000000014	-119.831845999999999	-119.831845999999999	34.4354450000000014	34.4354450000000014	\N	\N	\N
GATE	land	GATE	California, USA	Glen Annie/Tecolotito	\N	point	-119.859153000000006	34.4322190000000035	-119.859153000000006	-119.859153000000006	34.4322190000000035	34.4322190000000035	\N	\N	\N
MISS_rapid	land	MICR	California, USA	Mission Creek watershed	\N	point	-119.679900000000004	34.4075666999999967	-119.679900000000004	-119.679900000000004	34.4075666999999967	34.4075666999999967	\N	\N	\N
AB00	other	AB00	California, USA	Arroyo Burro, Arroyo Burro at Cliff Drive	\N	point	-119.740210000000005	34.4050502699999967	-119.740210000000005	-119.740210000000005	34.4050502699999967	34.4050502699999967	\N	\N	\N
ABURE	land	ABURE	California, USA	Arroyo Burro Estuary	\N	point	-119.742856000000003	34.4039739999999981	-119.742856000000003	-119.742856000000003	34.4039739999999981	34.4039739999999981	\N	\N	\N
ABUR_rapid	land	ABUR	California, USA	Arroyo Burro	\N	point	-119.743483299999994	34.3965166999999994	-119.743483299999994	-119.743483299999994	34.3965166999999994	34.3965166999999994	\N	\N	\N
AHON_reef1	reef	AHND	California, USA	Arroyo Hondo Reef	\N	point	-120.140917000000002	34.4791669999999968	-120.140917000000002	-120.140917000000002	34.4791669999999968	34.4791669999999968	\N	\N	\N
AQUE_reef1	reef	AQUE	California, USA	Arroyo Quemado Reef.	\N	polygon	-120.131666999999993	34.469183000000001	-120.131666999999993	-120.131666999999993	34.469183000000001	34.469183000000001	\N	\N	\N
IVEE_reef1	reef	IVEE	California, USA	Isla Vista (IV) Reef	\N	point	-119.865233000000003	34.4036329999999992	-119.865233000000003	-119.865233000000003	34.4036329999999992	34.4036329999999992	\N	\N	\N
MOHK_rapid	other	MOHK	California, USA	Mohawk	\N	point	-119.728083299999994	34.387516699999999	-119.728083299999994	-119.728083299999994	34.387516699999999	34.387516699999999	\N	\N	\N
REFU_rapid	other	REFU	California, USA	Refugio	\N	point	-120.069999999999993	34.4572000000000003	-120.069999999999993	-120.069999999999993	34.4572000000000003	34.4572000000000003	\N	\N	\N
GV01	other	 Gaviota Creek	California, USA	GV01, Gaviota Creek, Gaviota at Hwy 101 South Rest Stop Exit	\N	point	-120.229169999999996	34.4855000000000018	-120.229169999999996	-120.229169999999996	34.4855000000000018	34.4855000000000018	\N	\N	\N
MC00	other	MC00	California, USA	Mission Creek, Mission at Montecito St	\N	point	-119.694990000000004	34.4130730299999996	-119.694990000000004	-119.694990000000004	34.4130730299999996	34.4130730299999996	\N	\N	\N
RG01	other	RG01	California, USA	Refugio Creek, Refugio at Hwy 101 Bridge	\N	point	-120.069320000000005	34.4657316400000013	-120.069320000000005	-120.069320000000005	34.4657316400000013	34.4657316400000013	\N	\N	\N
BC02	other	BC02	California, USA	Bell Canyon Creek, Bell Canyon Creek at Winchester Canyon Road culvert	\N	point	-119.905630000000002	34.4385400000000033	-119.905630000000002	-119.905630000000002	34.4385400000000033	34.4385400000000033	\N	\N	\N
GV01_rapid	other	GV01	California, USA	Gaviota Creek, Gaviota at Hwy 101 South Rest Stop Exit	\N	point	-120.229285000000004	34.4735719999999972	-120.229285000000004	-120.229285000000004	34.4735719999999972	34.4735719999999972	\N	\N	\N
CHACR	reef	CHACR	California, USA	CHALK CAMP RIGHT	\N	point	-118.490217000000001	33.4439670000000007	-118.490217000000001	-118.490217000000001	33.4439670000000007	33.4439670000000007	\N	\N	\N
CHACL	reef	CHACL	California, USA	CHALK CAMP LEFT	\N	point	-118.490217000000001	33.4439670000000007	-118.490217000000001	-118.490217000000001	33.4439670000000007	33.4439670000000007	\N	\N	\N
BFCSR	reef	BFCSR	California, USA	BIG FISHERMAN COVE SOUTH RIGHT	\N	point	-118.486383000000004	33.4443669999999997	-118.486383000000004	-118.486383000000004	33.4443669999999997	33.4443669999999997	\N	\N	\N
BFCSL	reef	BFCSL	California, USA	BIG FISHERMAN COVE SOUTH LEFT	\N	point	-118.486383000000004	33.4443669999999997	-118.486383000000004	-118.486383000000004	33.4443669999999997	33.4443669999999997	\N	\N	\N
LCR	reef	LCR	California, USA	LULU COVE RIGHT	\N	point	-118.506732999999997	33.4543669999999977	-118.506732999999997	-118.506732999999997	33.4543669999999977	33.4543669999999977	\N	\N	\N
LCL	reef	LCL	California, USA	LULU COVE LEFT	\N	point	-118.506100000000004	33.4543170000000032	-118.506100000000004	-118.506100000000004	33.4543170000000032	33.4543170000000032	\N	\N	\N
IRR	reef	IRR	California, USA	ISTHMUS REEF RIGHT	\N	point	-118.490300000000005	33.4478670000000022	-118.490300000000005	-118.490300000000005	33.4478670000000022	33.4478670000000022	\N	\N	\N
IRL	reef	IRL	California, USA	ISTHMUS REEF LEFT	\N	point	-118.490300000000005	33.4478670000000022	-118.490300000000005	-118.490300000000005	33.4478670000000022	33.4478670000000022	\N	\N	\N
CRACL	reef	CRACL	California, USA	CRACK COVE LEFT	\N	point	-118.503579999999999	33.4534170000000017	-118.503579999999999	-118.503579999999999	33.4534170000000017	33.4534170000000017	\N	\N	\N
CRACR	reef	CRACR	California, USA	CRACK COVE RIGHT	\N	point	-118.503579999999999	33.4534170000000017	-118.503579999999999	-118.503579999999999	33.4534170000000017	33.4534170000000017	\N	\N	\N
LH	reef	LH	California, USA	LION HEAD	\N	point	-118.501582999999997	33.4534329999999969	-118.501582999999997	-118.501582999999997	33.4534329999999969	33.4534329999999969	\N	\N	\N
BRE	reef	BRE	California, USA	BIRD ROCK EAST	\N	point	-118.486500000000007	33.4502499999999969	-118.486500000000007	-118.486500000000007	33.4502499999999969	33.4502499999999969	\N	\N	\N
CHECW	reef	CHECW	California, USA	CHERRY COVE WEST	\N	point	-118.501783000000003	33.4533670000000001	-118.501783000000003	-118.501783000000003	33.4533670000000001	33.4533670000000001	\N	\N	\N
IP	reef	IP	California, USA	INTAKE PIPES	\N	point	-118.485100000000003	33.4468999999999994	-118.485100000000003	-118.485100000000003	33.4468999999999994	33.4468999999999994	\N	\N	\N
IR	reef	IR	California, USA	ISTHMUS REEF	\N	point	-118.490300000000005	33.4478670000000022	-118.490300000000005	-118.490300000000005	33.4478670000000022	33.4478670000000022	\N	\N	\N
PC	reef	PC	California, USA	PUMPERNICKEL COVE	\N	point	-118.479016999999999	33.4479159999999993	-118.479016999999999	-118.479016999999999	33.4479159999999993	33.4479159999999993	\N	\N	\N
SRE	reef	SRE	California, USA	SHIP ROCK EAST	\N	point	-118.491820000000004	33.4628500000000031	-118.491820000000004	-118.491820000000004	33.4628500000000031	33.4628500000000031	\N	\N	\N
CHAC	reef	CHAC	California, USA	CHALK CAMP	\N	point	-118.490217000000001	33.4439670000000007	-118.490217000000001	-118.490217000000001	33.4439670000000007	33.4439670000000007	\N	\N	\N
HP	reef	HP	California, USA	HABITAT REEF	\N	point	-118.487932999999998	33.4447669999999988	-118.487932999999998	-118.487932999999998	33.4447669999999988	33.4447669999999988	\N	\N	\N
IPL	reef	IPL	California, USA	INTAKE PIPES LEFT	\N	point	-118.485100000000003	33.4468999999999994	-118.485100000000003	-118.485100000000003	33.4468999999999994	33.4468999999999994	\N	\N	\N
BFCNR	reef	BFCNR	California, USA	BIG FISHERMAN COVE NORTH RIGHT	\N	point	-118.484733000000006	33.4453170000000028	-118.484733000000006	-118.484733000000006	33.4453170000000028	33.4453170000000028	\N	\N	\N
BFCNL	reef	BFCNL	California, USA	BIG FISHERMAN COVE NORTH LEFT	\N	point	-118.484733000000006	33.4453170000000028	-118.484733000000006	-118.484733000000006	33.4453170000000028	33.4453170000000028	\N	\N	\N
IPR	reef	IPR	California, USA	INTAKE PIPES RIGHT	\N	point	-118.485100000000003	33.4468999999999994	-118.485100000000003	-118.485100000000003	33.4468999999999994	33.4468999999999994	\N	\N	\N
CHECER	reef	CHECER	California, USA	CHERRY COVE EAST RIGHT	\N	point	-118.499549999999999	33.4495330000000024	-118.499549999999999	-118.499549999999999	33.4495330000000024	33.4495330000000024	\N	\N	\N
FJCW	reef	FJCW	California, USA	FOURTH OF JULY COVE WEST	\N	point	-118.499583000000001	33.4479169999999968	-118.499583000000001	-118.499583000000001	33.4479169999999968	33.4479169999999968	\N	\N	\N
FJCER	reef	FJCER	California, USA	FOURTH OF JULY COVE EAST RIGHT	\N	point	-118.498050000000006	33.4459500000000034	-118.498050000000006	-118.498050000000006	33.4459500000000034	33.4459500000000034	\N	\N	\N
FJCEL	reef	FJCEL	California, USA	FOURTH OF JULY COVE EAST LEFT	\N	point	-118.498050000000006	33.4459500000000034	-118.498050000000006	-118.498050000000006	33.4459500000000034	33.4459500000000034	\N	\N	\N
BRWR	reef	BRWR	California, USA	BIRD ROCK WEST RIGHT	\N	point	-118.488050000000001	33.4511170000000035	-118.488050000000001	-118.488050000000001	33.4511170000000035	33.4511170000000035	\N	\N	\N
BRWL	reef	BRWL	California, USA	BIRD ROCK WEST LEFT	\N	point	-118.488	33.4519670000000033	-118.488	-118.488	33.4519670000000033	33.4519670000000033	\N	\N	\N
BRER	reef	BRER	California, USA	BIRD ROCK EAST RIGHT	\N	point	-118.486483000000007	33.4502170000000021	-118.486483000000007	-118.486483000000007	33.4502170000000021	33.4502170000000021	\N	\N	\N
BREL	reef	BREL	California, USA	BIRD ROCK EAST LEFT	\N	point	-118.486500000000007	33.4502499999999969	-118.486500000000007	-118.486500000000007	33.4502499999999969	33.4502499999999969	\N	\N	\N
WR	reef	WR	California, USA	WHALE ROCK	\N	point	-118.605733000000001	33.4791999999999987	-118.605733000000001	-118.605733000000001	33.4791999999999987	33.4791999999999987	\N	\N	\N
GR	reef	GR	California, USA	GREEN ROCK	\N	point	-118.597783000000007	33.4777330000000006	-118.597783000000007	-118.597783000000007	33.4777330000000006	33.4777330000000006	\N	\N	\N
LBR	reef	LBR	California, USA	LORENZO BEACH RIGHT	\N	point	-118.569833000000003	33.4760169999999988	-118.569833000000003	-118.569833000000003	33.4760169999999988	33.4760169999999988	\N	\N	\N
LBL	reef	LBL	California, USA	LORENZO BEACH LEFT	\N	point	-118.568550000000002	33.4754999999999967	-118.568550000000002	-118.568550000000002	33.4754999999999967	33.4754999999999967	\N	\N	\N
AP	reef	AP	California, USA	ARROW POINT	\N	point	-118.538933	33.4767500000000027	-118.538933	-118.538933	33.4767500000000027	33.4767500000000027	\N	\N	\N
PL	reef	PL	California, USA	PARSONS LANDING	\N	point	-118.554749999999999	33.4745830000000026	-118.554749999999999	-118.554749999999999	33.4745830000000026	33.4745830000000026	\N	\N	\N
HL	reef	HL	California, USA	HOWLAND LANDING	\N	point	-118.522082999999995	33.4658330000000035	-118.522082999999995	-118.522082999999995	33.4658330000000035	33.4658330000000035	\N	\N	\N
CHECE	reef	CHECE	California, USA	CHERRY COVE EAST	\N	point	-118.499367000000007	33.4492329999999995	-118.499367000000007	-118.499367000000007	33.4492329999999995	33.4492329999999995	\N	\N	\N
CHECEL	reef	CHECEL	California, USA	CHERRY COVE EAST LEFT	\N	point	-118.499367000000007	33.4492329999999995	-118.499367000000007	-118.499367000000007	33.4492329999999995	33.4492329999999995	\N	\N	\N
SRW	reef	SRW	California, USA	SHIP ROCK WEST	\N	point	-118.491749999999996	33.4633830000000003	-118.491749999999996	-118.491749999999996	33.4633830000000003	33.4633830000000003	\N	\N	\N
\.


--
-- TOC entry 3466 (class 0 OID 112171)
-- Dependencies: 231
-- Data for Name: ListTaxa; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListTaxa" ("TaxonID", "TaxonomicProviderID", "TaxonRankName", "TaxonRankValue", "CommonName", "LocalID") FROM stdin;
\.


--
-- TOC entry 3467 (class 0 OID 112177)
-- Dependencies: 232
-- Data for Name: ListTaxonomicProviders; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ListTaxonomicProviders" ("ProviderID", "ProviderName", "ProviderURL") FROM stdin;
itis	Integrated Taxonomic Information System	https://itis.gov/
ncbi	National Center for Biotechnology Information	https://www.ncbi.nlm.nih.gov/taxonomy
eol	Encyclopedia of Life	https://eol.org/
col	Catalogue of Life	https://www.catalogueoflife.org/
tropicos	Tropicos	https://www.tropicos.org/
gbif	Global Biodiversity Information Facility	https://www.gbif.org/en/
nbn	National Biodiversity Network	https://nbn.org.uk/
worms	World Register of Marine Species	http://www.marinespecies.org/
natserv	NatureServe	http://explorer.natureserve.org/index.htm
bold	Barcode of Life Data System	http://v3.boldsystems.org/
wiki	Wikispecies	https://species.wikimedia.org/wiki/Main_Page
pow	Kew's Plants of the World	http://www.plantsoftheworldonline.org/
\.


--
-- TOC entry 3468 (class 0 OID 112180)
-- Dependencies: 233
-- Data for Name: boilerplate; Type: TABLE DATA; Schema: mb2eml_r; Owner: %db_owner%
--

COPY mb2eml_r.boilerplate (bp_setting, scope, system, access, distribution, publisher_nameid, contact_nameid, metadata_provider_nameid, project, intellectual_rights, licensed) FROM stdin;
default	knb-lter-sbc	sbc	<access system="https://pasta.lternet.edu" scope="document" order="allowFirst" authSystem="https://pasta.lternet.edu/authentication">\r\n    <allow>\r\n      <principal>uid=BLE,o=LTER,dc=ecoinformatics,dc=org</principal>\r\n      <permission>all</permission>\r\n    </allow>\r\n    <allow>\r\n      <principal>public</principal>\r\n      <permission>read</permission>\r\n    </allow>\r\n  </access>	<distribution>\r\n      <online>\r\n        <url function="information">https://ble.lternet.edu</url>\r\n      </online>\r\n    </distribution>	sbclter	sbclter	sbclter	<project>\r\n      <title>your lter spelled out</title>\r\n      <personnel>\r\n        <individualName>\r\n          <salutation>Dr.</salutation>\r\n          <givenName>PI name</givenName>\r\n          <surName>PI surname</surName>\r\n        </individualName>\r\n        <address> \r\n          <deliveryPoint>PI address1</deliveryPoint>\r\n          <deliveryPoint>PI address2</deliveryPoint>\r\n          <city>PI city</city>\r\n          <administrativeArea>PI state</administrativeArea>\r\n          <postalCode>78758</postalCode>\r\n          <country>United States</country>\r\n        </address>\r\n        <phone phonetype="voice">615-867-5309</phone>\r\n        <electronicMailAddress>PI@abc.edu</electronicMailAddress>\r\n        <role>Principal Investigator</role>\r\n      </personnel>    \r\n      <personnel>\r\n        <individualName>\r\n          <salutation>Dr.</salutation>\r\n          <givenName>Co-PI name</givenName>\r\n          <surName>Co-PI surname</surName>\r\n        </individualName>\r\n        <address> \r\n          <deliveryPoint>Co-PI address1</deliveryPoint>\r\n          <deliveryPoint>Co-PI address2</deliveryPoint>\r\n          <city>Co-PI city</city>\r\n          <administrativeArea>Co-PI state</administrativeArea>\r\n          <postalCode>78758</postalCode>\r\n          <country>United States</country>\r\n        </address>\r\n        <phone phonetype="voice">615-867-5309</phone>\r\n        <electronicMailAddress>Co-PI@abc.edu</electronicMailAddress>\r\n        <role>Co-Principal Investigator</role>\r\n      </personnel>  \r\n           <abstract>\r\n        <section>\r\n          <para>Abstract about your LTER site.</para>\r\n        </section>\r\n      </abstract>\r\n      <funding>\r\n        <section>\r\n          <para>BLE is funded by the National Science Foundation under award 123456.</para>\r\n        </section>\r\n      </funding>\r\n    </project>  	<intellectualRights>\r\n      <para>\r\n  This data package is released to the “public domain” under Creative\r\n  Commons CC0 1.0 “No Rights Reserved”\r\n  (see: https://creativecommons.org/publicdomain/zero/1.0/). It is\r\n  considered professional etiquette to provide attribution of the\r\n  original work if this data package is shared or utilized in whole or\r\n  by individual components. A generic citation is provided for this data\r\n  package on the website of the repository where these data were\r\n  obtained in the summary metadata page.\r\n</para>\r\n      <para>\r\n  Communication (and collaboration) with the creators of this data\r\n  package is recommended to prevent duplicate research or publication.\r\n  The Data User is urged to contact the authors of these data if any\r\n  questions about methodology or results occur. The Data User should\r\n  realize that these data may be actively used by others for ongoing\r\n  research and that coordination may be necessary to prevent duplication\r\n  or inappropriate use. The Data User should realize that\r\n  misinterpretation may occur if data are used outside of the context of\r\n  the original study. The Data User should be aware that periodic\r\n  updates of this data package may be available from the website and it\r\n  is the responsibility of the Data User to check for new versions of\r\n  the data.\r\n</para>\r\n      <para>\r\n  While substantial efforts are made to ensure the accuracy of data and\r\n  associated documentation, complete accuracy cannot be guaranteed. This\r\n  data package (with its components) is made available “as is” and with\r\n  no warranty of accuracy or fitness for use. The creators of this data\r\n  package and the repository where these data were obtained shall not be\r\n  liable for any damages resulting from misinterpretation, use or misuse\r\n  of the data package or its components. Thank you.\r\n</para>\r\n    </intellectualRights>	\N
non-default	knb-lter-sbc	sbc	<access system="https://pasta.lternet.edu" scope="document" order="allowFirst" authSystem="https://pasta.lternet.edu/authentication">\r\n    <allow>\r\n      <principal>uid=BLE,o=LTER,dc=ecoinformatics,dc=org</principal>\r\n      <permission>all</permission>\r\n    </allow>\r\n    <allow>\r\n      <principal>public</principal>\r\n      <permission>read</permission>\r\n    </allow>\r\n  </access>	<distribution>\r\n      <online>\r\n        <url function="information">https://ble.lternet.edu</url>\r\n      </online>\r\n    </distribution>	sbclter	sbclter	sbclter	<project>\r\n      <title>your lter spelled out</title>\r\n      <personnel>\r\n        <individualName>\r\n          <salutation>Dr.</salutation>\r\n          <givenName>PI name</givenName>\r\n          <surName>PI surname</surName>\r\n        </individualName>\r\n        <address> \r\n          <deliveryPoint>PI address1</deliveryPoint>\r\n          <deliveryPoint>PI address2</deliveryPoint>\r\n          <city>PI city</city>\r\n          <administrativeArea>PI state</administrativeArea>\r\n          <postalCode>78758</postalCode>\r\n          <country>United States</country>\r\n        </address>\r\n        <phone phonetype="voice">615-867-5309</phone>\r\n        <electronicMailAddress>PI@abc.edu</electronicMailAddress>\r\n        <role>Principal Investigator</role>\r\n      </personnel>    \r\n      <personnel>\r\n        <individualName>\r\n          <salutation>Dr.</salutation>\r\n          <givenName>Co-PI name</givenName>\r\n          <surName>Co-PI surname</surName>\r\n        </individualName>\r\n        <address> \r\n          <deliveryPoint>Co-PI address1</deliveryPoint>\r\n          <deliveryPoint>Co-PI address2</deliveryPoint>\r\n          <city>Co-PI city</city>\r\n          <administrativeArea>Co-PI state</administrativeArea>\r\n          <postalCode>78758</postalCode>\r\n          <country>United States</country>\r\n        </address>\r\n        <phone phonetype="voice">615-867-5309</phone>\r\n        <electronicMailAddress>Co-PI@abc.edu</electronicMailAddress>\r\n        <role>Co-Principal Investigator</role>\r\n      </personnel>  \r\n           <abstract>\r\n        <section>\r\n          <para>Abstract about your LTER site.</para>\r\n        </section>\r\n      </abstract>\r\n      <funding>\r\n        <section>\r\n          <para>BLE is funded by the National Science Foundation under award 123456.</para>\r\n        </section>\r\n      </funding>\r\n    </project>  	<intellectualRights>\r\n      <para>\r\n  This data package is released to the “public domain” under Creative\r\n  Commons CC0 1.0 “No Rights Reserved”\r\n  (see: https://creativecommons.org/publicdomain/zero/1.0/). It is\r\n  considered professional etiquette to provide attribution of the\r\n  original work if this data package is shared or utilized in whole or\r\n  by individual components. A generic citation is provided for this data\r\n  package on the website of the repository where these data were\r\n  obtained in the summary metadata page.\r\n</para>\r\n      <para>\r\n  Communication (and collaboration) with the creators of this data\r\n  package is recommended to prevent duplicate research or publication.\r\n  The Data User is urged to contact the authors of these data if any\r\n  questions about methodology or results occur. The Data User should\r\n  realize that these data may be actively used by others for ongoing\r\n  research and that coordination may be necessary to prevent duplication\r\n  or inappropriate use. The Data User should realize that\r\n  misinterpretation may occur if data are used outside of the context of\r\n  the original study. The Data User should be aware that periodic\r\n  updates of this data package may be available from the website and it\r\n  is the responsibility of the Data User to check for new versions of\r\n  the data.\r\n</para>\r\n      <para>\r\n  While substantial efforts are made to ensure the accuracy of data and\r\n  associated documentation, complete accuracy cannot be guaranteed. This\r\n  data package (with its components) is made available “as is” and with\r\n  no warranty of accuracy or fitness for use. The creators of this data\r\n  package and the repository where these data were obtained shall not be\r\n  liable for any damages resulting from misinterpretation, use or misuse\r\n  of the data package or its components. Thank you.\r\n</para>\r\n    </intellectualRights>	\N
\.


--
-- TOC entry 3470 (class 0 OID 112283)
-- Dependencies: 253
-- Data for Name: cv_cra; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_cra (cra_id, cra_name) FROM stdin;
pp	Primary Production 
om	Movement of Organic Matter
dp	Disturbance Patterns
pd	Population Dynamics
in	Movement of Inorganic Nutrients 
\.


--
-- TOC entry 3471 (class 0 OID 112286)
-- Dependencies: 254
-- Data for Name: cv_maint_freq; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_maint_freq (eml_maintenance_frequency) FROM stdin;
annually
asNeeded
biannually
continually
daily
irregular
monthly
notPlanned
weekly
unknown
otherMaintenancePeriod
\.


--
-- TOC entry 3472 (class 0 OID 112289)
-- Dependencies: 255
-- Data for Name: cv_mgmt_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_mgmt_type (mgmt_type, definition) FROM stdin;
templated	\N
non_templated	\N
\.


--
-- TOC entry 3473 (class 0 OID 112295)
-- Dependencies: 256
-- Data for Name: cv_network_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_network_type (network_type, definition) FROM stdin;
0	data usage is controlled by a group other than the local LTER
I	data are publicly available
II	data are restricted and available upon request
mix	at least one entity in the dataset is of each type I and II
NA	network types do not apply. this dataset (EML record) does not go to the network, e.g., it's a template.
\.


--
-- TOC entry 3474 (class 0 OID 112301)
-- Dependencies: 257
-- Data for Name: cv_spatial_extent; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatial_extent (spatial_extent, definition) FROM stdin;
lab	data are from an experiment conducted in the lab. organisms were probably collected in the field.
LTER_site_boundary	the entire LTER site, no more, no less
LTER_site_plus	contains at least part of the LTER site, plus other disconnected sites
LTER_site_subset	a subset of the LTER site
region	extends beyond LTER site into adjacent areas
single_point	a single place such as one transect
\.


--
-- TOC entry 3475 (class 0 OID 112307)
-- Dependencies: 258
-- Data for Name: cv_spatial_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatial_type (spatial_type, definition) FROM stdin;
multi_site	more than one location within the LTER site
non_spatial	there is no spatial component to this dataset
one_place_of_a_site_series	one place of a series of places
one_site_of_one	one site and not part of a series of sites
\.


--
-- TOC entry 3476 (class 0 OID 112313)
-- Dependencies: 259
-- Data for Name: cv_spatio_temporal; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatio_temporal (spatiotemporal, definition) FROM stdin;
csct	continuous spatial continuous temporal
csdt	continuous spatial discrete temporal
dsct	discrete spatial continuous temporal
dsdt	discrete spatial discrete temporal
\.


--
-- TOC entry 3477 (class 0 OID 112319)
-- Dependencies: 260
-- Data for Name: cv_status; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_status (status) FROM stdin;
anticipated
backlog
cataloged
catd_meta_antic_data
deprecated
draft
draft0
draft_template
redesign_anticipated
template
\.


--
-- TOC entry 3478 (class 0 OID 112322)
-- Dependencies: 261
-- Data for Name: cv_temporal_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_temporal_type (temporal_type, definition) FROM stdin;
completed_timeseries	
non_temporal	
one_period_of_a_timeseries	
ongoing_timeseries	
short_term_study	
\.


--
-- TOC entry 3469 (class 0 OID 112214)
-- Dependencies: 240
-- Data for Name: maintenance_changehistory; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.maintenance_changehistory ("DataSetID", revision_number, revision_notes, change_scope, change_date, "NameID") FROM stdin;
99021	1	First	Metadata	2019-08-27	mobrien
99021	2	second	Metadata	2019-08-27	mobrien
\.


--
-- TOC entry 3479 (class 0 OID 112328)
-- Dependencies: 262
-- Data for Name: pkg_core_area; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_core_area ("DataSetID", "Core_area") FROM stdin;
99013	dp
99024	pp
99021	om
\.


--
-- TOC entry 3480 (class 0 OID 112331)
-- Dependencies: 263
-- Data for Name: pkg_sort; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_sort ("DataSetID", network_type, is_signature, is_core, temporal_type, spatial_extent, spatiotemporal, is_thesis, is_reference, is_exogenous, spatial_type, management_type, in_pasta, dbupdatetime) FROM stdin;
99024	I	t	t	ongoing_timeseries	LTER_site_subset	dsdt	f	f	f	multi_site	non_templated	t	2019-08-02 14:14:40.677897
99054	I	t	t	completed_timeseries	region	csct	t	f	f	multi_site	non_templated	f	2019-08-02 14:14:40.677897
99013	I	t	t	ongoing_timeseries	LTER_site_subset	dsct	f	f	f	multi_site	non_templated	t	2019-08-02 14:14:40.677897
99021	I	t	t	short_term_study	LTER_site_subset	dsdt	f	f	f	multi_site	non_templated	t	2019-08-02 14:14:40.677897
\.


--
-- TOC entry 3481 (class 0 OID 112335)
-- Dependencies: 264
-- Data for Name: pkg_state; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_state ("DataSetID", dataset_archive_id, rev, nickname, data_receipt_date, status, synth_readiness, staging_dir, eml_draft_path, notes, pub_notes, who2bug, dir_internal_final, dbupdatetime, update_date_catalog) FROM stdin;
99054	knb-lter-sbc.99054	4	Satellite kelp canopy biomass	2013-10-25	deprecated	integration	satellite_kelp_canopy_1	cavanaugh_satellite_kelp_canopy_1/2014_update	test dataset for pasta.	metacat is at rev 3 and pasta at rev 2, docs are the same.	tbell, kcavanaugh	\N	2019-08-02 14:14:40.664528	2012-02-14
99013	knb-lter-sbc.99013	21	Reef bottom water temperature	2017-12-01	cataloged	integration	reef_bottom_temperature	project.13		\N	lkui	research/Reef/Final/Data/Bottom_Temperature/	2020-01-09 13:24:33.236161	2017-12-07
99024	knb-lter-sbc.99024	17	Kelp - algal weights and CHN	2017-12-20	cataloged	integration	reef_kelp_algal_weight_CHN	project.24	replaced method, july 2013	\N	lkui	research/Reef/Final/Data/Kelp_NPP/CHN	2020-01-09 13:24:33.236161	2017-12-20
99021	knb-lter-sbc.99022	11	Beach wrack IV 2005-06	2013-04-05	cataloged	download	beach_wrack_IV	beach_wrack_IV	table #1: wrack, only macrocystis so far. may have other species added table #2 to be added: porewater.	\N	jdugan	\N	2020-01-09 13:24:33.236161	2010-06-14
\.


--
-- TOC entry 3482 (class 0 OID 112341)
-- Dependencies: 265
-- Data for Name: version_tracker_metabase; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) FROM stdin;
0	9	22	2019-08-02 14:14:41.315503	apply 22_version_tracker
0	9	23	2019-08-02 14:14:41.328463	using 23_create_provenance_table.sql
0	9	24	2019-08-02 14:14:41.337056	from 24_method_step_views_and_methodstepID_col_name.sql
0	9	25	2019-08-02 14:14:41.352391	apply 25_drop_deprecated
0	9	27	2019-08-02 14:14:41.356958	applied 27_abstract_text_type.sql
0	9	30	2019-09-09 17:09:37.416947	apply 30_create_boilerplate.sql
0	9	31	2019-09-19 16:35:59.432108	applied 31_add_cols_filesize_cksum.sql
0	9	32	2019-09-19 16:35:59.432108	applied 32_add_position_licensed.sql
1	0	35	2019-10-10 16:54:24.566056	applied 35_bug_fixes.sql
1	0	38	2020-01-09 13:24:33.242279	applied 38_pkg_state_data_archive_id_correction_to_examples.sql
1	0	39	2020-01-09 13:24:43.173911	apply 39_add_docbook_descriptiontype.sql
1	0	40	2020-01-09 13:31:43.632442	applied 40_widen_altitude_unit_limit.sql
1	0	41	2021-03-09 08:33:29.043446	applied 41_consolidate_missing_enumeration_codes.sql
0	9	33	2023-04-05 13:55:13.996013	applied 33_semantic_annotation.sql revision 2019-10-03
1	0	42	2023-04-05 13:57:07.210529	apply 42_add_publications.sql
1	0	43	2023-04-05 13:59:58.643168	apply 43_move_annotation_tables.sql
1	0	44	2023-04-05 14:00:05.445701	apply 44_add_provider_id_taxonomy.sql
1	0	45	2023-05-16 14:31:48.223161	apply 45_add_character_encoding_to_vw.sql
\.


--
-- TOC entry 3091 (class 2606 OID 112831)
-- Name: DataSetAttributes DataSetAttributes_UQ_DataSetID_EntitySortOrder_ColumnPosition; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_UQ_DataSetID_EntitySortOrder_ColumnPosition" UNIQUE ("DataSetID", "EntitySortOrder", "ColumnPosition");


--
-- TOC entry 3089 (class 2606 OID 112395)
-- Name: DataSetAttributeMissingCodes PK_AttributeMissingCodes; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeMissingCodes"
    ADD CONSTRAINT "PK_AttributeMissingCodes" PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID");


--
-- TOC entry 3085 (class 2606 OID 112397)
-- Name: DataSet PK_DataSet; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSet"
    ADD CONSTRAINT "PK_DataSet" PRIMARY KEY ("DataSetID");


--
-- TOC entry 3087 (class 2606 OID 112399)
-- Name: DataSetAttributeEnumeration PK_DataSetAttributeEnumeration; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeEnumeration"
    ADD CONSTRAINT "PK_DataSetAttributeEnumeration" PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName", "CodeID");


--
-- TOC entry 3095 (class 2606 OID 112401)
-- Name: DataSetEntities PK_DataSetEntities; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "PK_DataSetEntities" PRIMARY KEY ("DataSetID", "EntityName");


--
-- TOC entry 3093 (class 2606 OID 112403)
-- Name: DataSetAttributes PK_DataSetID_EntitySortOrder_ColumnName; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "PK_DataSetID_EntitySortOrder_ColumnName" PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName");


--
-- TOC entry 3103 (class 2606 OID 112405)
-- Name: DataSetMethodInstruments PK_DataSetInstrument; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodInstruments"
    ADD CONSTRAINT "PK_DataSetInstrument" PRIMARY KEY ("DataSetID", "InstrumentID");


--
-- TOC entry 3099 (class 2606 OID 112407)
-- Name: DataSetKeywords PK_DataSetKeywords; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "PK_DataSetKeywords" PRIMARY KEY ("Keyword", "DataSetID", "ThesaurusID");


--
-- TOC entry 3107 (class 2606 OID 112409)
-- Name: DataSetMethodProvenance PK_DataSetMethodProvenance; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProvenance"
    ADD CONSTRAINT "PK_DataSetMethodProvenance" PRIMARY KEY ("DataSetID", "SourcePackageID");


--
-- TOC entry 3101 (class 2606 OID 112411)
-- Name: DataSetMethod PK_DataSetMethodSteps; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethod"
    ADD CONSTRAINT "PK_DataSetMethodSteps" PRIMARY KEY ("DataSetID", "MethodStepID");


--
-- TOC entry 3111 (class 2606 OID 112413)
-- Name: DataSetPersonnel PK_DataSetPersonnel; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "PK_DataSetPersonnel" PRIMARY KEY ("DataSetID", "NameID");


--
-- TOC entry 3105 (class 2606 OID 112415)
-- Name: DataSetMethodProtocols PK_DataSetProtocol; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProtocols"
    ADD CONSTRAINT "PK_DataSetProtocol" PRIMARY KEY ("DataSetID", "ProtocolID");


--
-- TOC entry 3113 (class 2606 OID 112417)
-- Name: DataSetSites PK_DataSetSites; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "PK_DataSetSites" PRIMARY KEY ("DataSetID", "SiteID");


--
-- TOC entry 3109 (class 2606 OID 112419)
-- Name: DataSetMethodSoftware PK_DataSetSoftware; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodSoftware"
    ADD CONSTRAINT "PK_DataSetSoftware" PRIMARY KEY ("DataSetID", "SoftwareID");


--
-- TOC entry 3115 (class 2606 OID 112421)
-- Name: DataSetTaxa PK_DataSetTaxa; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
    ADD CONSTRAINT "PK_DataSetTaxa" PRIMARY KEY ("DataSetID", "TaxonID", "TaxonomicProviderID");


--
-- TOC entry 3117 (class 2606 OID 112423)
-- Name: DataSetTemporal PK_DataSetTemporal; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTemporal"
    ADD CONSTRAINT "PK_DataSetTemporal" PRIMARY KEY ("DataSetID", "EntitySortOrder", "BeginDate");


--
-- TOC entry 3121 (class 2606 OID 112425)
-- Name: EMLKeywordTypes PK_EMLKeywordTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLKeywordTypes"
    ADD CONSTRAINT "PK_EMLKeywordTypeList" PRIMARY KEY ("KeywordType");


--
-- TOC entry 3126 (class 2606 OID 112427)
-- Name: EMLMeasurementScales PK_EMLMeasurementScale; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLMeasurementScales"
    ADD CONSTRAINT "PK_EMLMeasurementScale" PRIMARY KEY ("measurementScale");


--
-- TOC entry 3128 (class 2606 OID 112429)
-- Name: EMLNumberTypes PK_EMLNumberType; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLNumberTypes"
    ADD CONSTRAINT "PK_EMLNumberType" PRIMARY KEY ("NumberType");


--
-- TOC entry 3130 (class 2606 OID 112431)
-- Name: EMLStorageTypes PK_EML_NumberTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLStorageTypes"
    ADD CONSTRAINT "PK_EML_NumberTypeList" PRIMARY KEY ("StorageType");


--
-- TOC entry 3132 (class 2606 OID 112433)
-- Name: EMLUnitDictionary PK_EML_UnitDictionary; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitDictionary"
    ADD CONSTRAINT "PK_EML_UnitDictionary" PRIMARY KEY (id);


--
-- TOC entry 3134 (class 2606 OID 112435)
-- Name: EMLUnitTypes PK_EML_UnitTypes; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitTypes"
    ADD CONSTRAINT "PK_EML_UnitTypes" PRIMARY KEY (id);


--
-- TOC entry 3119 (class 2606 OID 112437)
-- Name: EMLFileTypes PK_FileTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLFileTypes"
    ADD CONSTRAINT "PK_FileTypeList" PRIMARY KEY ("FileType");


--
-- TOC entry 3144 (class 2606 OID 112439)
-- Name: ListMethodInstruments PK_InstrumentID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodInstruments"
    ADD CONSTRAINT "PK_InstrumentID" PRIMARY KEY ("InstrumentID");


--
-- TOC entry 3140 (class 2606 OID 112441)
-- Name: ListKeywordThesauri PK_KeywordThesaurus; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListKeywordThesauri"
    ADD CONSTRAINT "PK_KeywordThesaurus" PRIMARY KEY ("ThesaurusID");


--
-- TOC entry 3142 (class 2606 OID 112443)
-- Name: ListKeywords PK_Keywords; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListKeywords"
    ADD CONSTRAINT "PK_Keywords" PRIMARY KEY ("Keyword", "ThesaurusID");


--
-- TOC entry 3166 (class 2606 OID 112445)
-- Name: ListTaxonomicProviders PK_ListTaxonomicProviders; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListTaxonomicProviders"
    ADD CONSTRAINT "PK_ListTaxonomicProviders" PRIMARY KEY ("ProviderID");


--
-- TOC entry 3136 (class 2606 OID 112447)
-- Name: ListCodes PK_MissingCodesList_MissingValueCodeID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListCodes"
    ADD CONSTRAINT "PK_MissingCodesList_MissingValueCodeID" PRIMARY KEY ("CodeID");


--
-- TOC entry 3156 (class 2606 OID 112449)
-- Name: ListPeople PK_People; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListPeople"
    ADD CONSTRAINT "PK_People" PRIMARY KEY ("NameID");


--
-- TOC entry 3158 (class 2606 OID 112451)
-- Name: ListPeopleID PK_Peopleidentification; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListPeopleID"
    ADD CONSTRAINT "PK_Peopleidentification" PRIMARY KEY ("IdentificationID", "NameID");


--
-- TOC entry 3148 (class 2606 OID 112453)
-- Name: ListMethodProtocols PK_ProtocolID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodProtocols"
    ADD CONSTRAINT "PK_ProtocolID" PRIMARY KEY ("ProtocolID");


--
-- TOC entry 3162 (class 2606 OID 112455)
-- Name: ListSites PK_SiteRegister; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListSites"
    ADD CONSTRAINT "PK_SiteRegister" PRIMARY KEY ("SiteID");


--
-- TOC entry 3152 (class 2606 OID 112457)
-- Name: ListMethodSoftware PK_SoftwareID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodSoftware"
    ADD CONSTRAINT "PK_SoftwareID" PRIMARY KEY ("SoftwareID");


--
-- TOC entry 3164 (class 2606 OID 112459)
-- Name: ListTaxa PK_TaxaList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListTaxa"
    ADD CONSTRAINT "PK_TaxaList" PRIMARY KEY ("TaxonID", "TaxonomicProviderID");


--
-- TOC entry 3160 (class 2606 OID 112461)
-- Name: ListPeopleID Peopleidentification_UQ_NameID_IdentificationID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListPeopleID"
    ADD CONSTRAINT "Peopleidentification_UQ_NameID_IdentificationID" UNIQUE ("NameID", "IdentificationID");


--
-- TOC entry 3097 (class 2606 OID 112463)
-- Name: DataSetEntities UQ_DataSet_SortOrder; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "UQ_DataSet_SortOrder" UNIQUE ("DataSetID", "EntitySortOrder");


--
-- TOC entry 3146 (class 2606 OID 112465)
-- Name: ListMethodInstruments UQ_InstrumentDescription; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodInstruments"
    ADD CONSTRAINT "UQ_InstrumentDescription" UNIQUE ("Description");


--
-- TOC entry 3138 (class 2606 OID 112467)
-- Name: ListCodes UQ_ListMissingCodes_Code_Explanation; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListCodes"
    ADD CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" UNIQUE ("Code", "CodeExplanation");


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 3138
-- Name: CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" ON "ListCodes"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" ON lter_metabase."ListCodes" IS 'Needed because the ID could be as simple as an integer and is not inherently connected to the code and explanation.';


--
-- TOC entry 3150 (class 2606 OID 112469)
-- Name: ListMethodProtocols UQ_Protocol_Title; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodProtocols"
    ADD CONSTRAINT "UQ_Protocol_Title" UNIQUE ("Title");


--
-- TOC entry 3154 (class 2606 OID 112471)
-- Name: ListMethodSoftware UQ_SoftwareTitleVersion; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodSoftware"
    ADD CONSTRAINT "UQ_SoftwareTitleVersion" UNIQUE ("Title", "Version");


--
-- TOC entry 3209 (class 2606 OID 112814)
-- Name: DataSetAnnotation pk_DataSetAnnotation_DataSetID_TermID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAnnotation"
    ADD CONSTRAINT "pk_DataSetAnnotation_DataSetID_TermID" PRIMARY KEY ("DataSetID", "TermID");


--
-- TOC entry 3211 (class 2606 OID 112837)
-- Name: DataSetAttributeAnnotation pk_DataSetAttributeAnnotation_DataSetID_TermID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeAnnotation"
    ADD CONSTRAINT "pk_DataSetAttributeAnnotation_DataSetID_TermID" PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnPosition", "TermID");


--
-- TOC entry 3215 (class 2606 OID 112877)
-- Name: DataSetPublications pk_DataSetPublications; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPublications"
    ADD CONSTRAINT "pk_DataSetPublications" PRIMARY KEY ("DataSetID", "PublicationID");


--
-- TOC entry 3205 (class 2606 OID 112805)
-- Name: EMLObjectProperties pk_EMLObjectProperty; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLObjectProperties"
    ADD CONSTRAINT "pk_EMLObjectProperty" PRIMARY KEY ("ObjectPropertyID");


--
-- TOC entry 3213 (class 2606 OID 112871)
-- Name: ListPublications pk_ListPublications; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListPublications"
    ADD CONSTRAINT "pk_ListPublications" PRIMARY KEY ("PublicationID");


--
-- TOC entry 3124 (class 2606 OID 112473)
-- Name: EMLMeasurementScaleDomains pk_MeasurementScaleDomains; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLMeasurementScaleDomains"
    ADD CONSTRAINT "pk_MeasurementScaleDomains" PRIMARY KEY ("MeasurementScaleDomainID");


--
-- TOC entry 3201 (class 2606 OID 112794)
-- Name: ListSemanticAnnotationTerms pk_semantic_annotation_TermID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListSemanticAnnotationTerms"
    ADD CONSTRAINT "pk_semantic_annotation_TermID" PRIMARY KEY ("TermID");


--
-- TOC entry 3207 (class 2606 OID 112807)
-- Name: EMLObjectProperties uq_objectPropertyURI; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLObjectProperties"
    ADD CONSTRAINT "uq_objectPropertyURI" UNIQUE ("ObjectPropertyURI");


--
-- TOC entry 3203 (class 2606 OID 112796)
-- Name: ListSemanticAnnotationTerms uq_semantic_annotation_TermURI; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListSemanticAnnotationTerms"
    ADD CONSTRAINT "uq_semantic_annotation_TermURI" UNIQUE ("TermURI");


--
-- TOC entry 3168 (class 2606 OID 112475)
-- Name: boilerplate pk_boilerplate; Type: CONSTRAINT; Schema: mb2eml_r; Owner: %db_owner%
--

ALTER TABLE ONLY mb2eml_r.boilerplate
    ADD CONSTRAINT pk_boilerplate PRIMARY KEY (bp_setting);


--
-- TOC entry 3174 (class 2606 OID 112477)
-- Name: cv_maint_freq PK_cv_maint_freq; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_maint_freq
    ADD CONSTRAINT "PK_cv_maint_freq" PRIMARY KEY (eml_maintenance_frequency);


--
-- TOC entry 3170 (class 2606 OID 112479)
-- Name: maintenance_changehistory PK_maintenance_changehistory; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.maintenance_changehistory
    ADD CONSTRAINT "PK_maintenance_changehistory" PRIMARY KEY ("DataSetID", revision_number);


--
-- TOC entry 3199 (class 2606 OID 112481)
-- Name: version_tracker_metabase PK_version_tracker_metabase; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.version_tracker_metabase
    ADD CONSTRAINT "PK_version_tracker_metabase" PRIMARY KEY (major_version, minor_version, patch);


--
-- TOC entry 3172 (class 2606 OID 112483)
-- Name: cv_cra cv_cra_pkey; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_cra
    ADD CONSTRAINT cv_cra_pkey PRIMARY KEY (cra_id);


--
-- TOC entry 3176 (class 2606 OID 112485)
-- Name: cv_mgmt_type cv_mgmt_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_mgmt_type
    ADD CONSTRAINT cv_mgmt_type_pk PRIMARY KEY (mgmt_type);


--
-- TOC entry 3178 (class 2606 OID 112487)
-- Name: cv_network_type cv_network_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_network_type
    ADD CONSTRAINT cv_network_type_pk PRIMARY KEY (network_type);


--
-- TOC entry 3180 (class 2606 OID 112489)
-- Name: cv_spatial_extent cv_spatial_extent_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatial_extent
    ADD CONSTRAINT cv_spatial_extent_pk PRIMARY KEY (spatial_extent);


--
-- TOC entry 3182 (class 2606 OID 112491)
-- Name: cv_spatial_type cv_spatial_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatial_type
    ADD CONSTRAINT cv_spatial_type_pk PRIMARY KEY (spatial_type);


--
-- TOC entry 3184 (class 2606 OID 112493)
-- Name: cv_spatio_temporal cv_spatio_temporal_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatio_temporal
    ADD CONSTRAINT cv_spatio_temporal_pk PRIMARY KEY (spatiotemporal);


--
-- TOC entry 3186 (class 2606 OID 112495)
-- Name: cv_status cv_status_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_status
    ADD CONSTRAINT cv_status_pk PRIMARY KEY (status);


--
-- TOC entry 3188 (class 2606 OID 112497)
-- Name: cv_temporal_type cv_temporal_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_temporal_type
    ADD CONSTRAINT cv_temporal_type_pk PRIMARY KEY (temporal_type);


--
-- TOC entry 3190 (class 2606 OID 112499)
-- Name: pkg_core_area pkg_cra_pkey; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT pkg_cra_pkey PRIMARY KEY ("DataSetID", "Core_area");


--
-- TOC entry 3194 (class 2606 OID 112501)
-- Name: pkg_sort pkg_sort_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_pk PRIMARY KEY ("DataSetID");


--
-- TOC entry 3197 (class 2606 OID 112503)
-- Name: pkg_state pkg_state_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_state
    ADD CONSTRAINT pkg_state_pk PRIMARY KEY ("DataSetID");


--
-- TOC entry 3122 (class 1259 OID 112504)
-- Name: fki_MeasurementScaleDomains_FK_MeasurementScale; Type: INDEX; Schema: lter_metabase; Owner: %db_owner%
--

CREATE INDEX "fki_MeasurementScaleDomains_FK_MeasurementScale" ON lter_metabase."EMLMeasurementScaleDomains" USING btree ("MeasurementScale");


--
-- TOC entry 3195 (class 1259 OID 112505)
-- Name: fki_pkg_mgmt_fk_cv_status; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_mgmt_fk_cv_status ON pkg_mgmt.pkg_state USING btree (status);


--
-- TOC entry 3191 (class 1259 OID 112506)
-- Name: fki_pkg_sort_fk_network_type; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_sort_fk_network_type ON pkg_mgmt.pkg_sort USING btree (network_type);


--
-- TOC entry 3192 (class 1259 OID 112507)
-- Name: fki_pkg_sort_fk_spatial_extent; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_sort_fk_spatial_extent ON pkg_mgmt.pkg_sort USING btree (spatial_extent);


--
-- TOC entry 3279 (class 2620 OID 112508)
-- Name: ListPeople people_trig_dbupdatetime; Type: TRIGGER; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TRIGGER people_trig_dbupdatetime BEFORE INSERT OR UPDATE ON lter_metabase."ListPeople" FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3280 (class 2620 OID 112509)
-- Name: pkg_sort pkg_sort_trig_dbudatetime; Type: TRIGGER; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TRIGGER pkg_sort_trig_dbudatetime BEFORE INSERT OR UPDATE ON pkg_mgmt.pkg_sort FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3281 (class 2620 OID 112510)
-- Name: pkg_state pkg_state_trig_dbudatetime; Type: TRIGGER; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TRIGGER pkg_state_trig_dbudatetime BEFORE INSERT OR UPDATE ON pkg_mgmt.pkg_state FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3221 (class 2606 OID 112511)
-- Name: DataSetAttributes DataSetAttributes_FK_DataSetID_EntitySortOrder; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_DataSetID_EntitySortOrder" FOREIGN KEY ("DataSetID", "EntitySortOrder") REFERENCES lter_metabase."DataSetEntities"("DataSetID", "EntitySortOrder") ON UPDATE CASCADE;


--
-- TOC entry 3222 (class 2606 OID 112516)
-- Name: DataSetAttributes DataSetAttributes_FK_MeasurementScaleDomainID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_MeasurementScaleDomainID" FOREIGN KEY ("MeasurementScaleDomainID") REFERENCES lter_metabase."EMLMeasurementScaleDomains"("MeasurementScaleDomainID") ON UPDATE CASCADE;


--
-- TOC entry 3223 (class 2606 OID 112521)
-- Name: DataSetAttributes DataSetAttributes_FK_NumberType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_NumberType" FOREIGN KEY ("NumberType") REFERENCES lter_metabase."EMLNumberTypes"("NumberType") ON UPDATE CASCADE;


--
-- TOC entry 3224 (class 2606 OID 112526)
-- Name: DataSetAttributes DataSetAttributes_FK_StorageType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_StorageType" FOREIGN KEY ("StorageType") REFERENCES lter_metabase."EMLStorageTypes"("StorageType") ON UPDATE CASCADE;


--
-- TOC entry 3225 (class 2606 OID 112531)
-- Name: DataSetAttributes DataSetAttributes_FK_units; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_units" FOREIGN KEY ("Unit") REFERENCES lter_metabase."EMLUnitDictionary"(id) ON UPDATE CASCADE;


--
-- TOC entry 3217 (class 2606 OID 112536)
-- Name: DataSetAttributeEnumeration FK_DataSetAttributeEnumeration_ListCodes; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeEnumeration"
    ADD CONSTRAINT "FK_DataSetAttributeEnumeration_ListCodes" FOREIGN KEY ("CodeID") REFERENCES lter_metabase."ListCodes"("CodeID");


--
-- TOC entry 3226 (class 2606 OID 112541)
-- Name: DataSetEntities FK_DataSetEntities_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "FK_DataSetEntities_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3227 (class 2606 OID 112546)
-- Name: DataSetEntities FK_DataSetEntities_FileType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "FK_DataSetEntities_FileType" FOREIGN KEY ("FileType") REFERENCES lter_metabase."EMLFileTypes"("FileType") ON UPDATE CASCADE;


--
-- TOC entry 3243 (class 2606 OID 112551)
-- Name: DataSetSites FK_DataSetExpSites_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "FK_DataSetExpSites_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3231 (class 2606 OID 112556)
-- Name: DataSetMethodInstruments FK_DataSetInstrument_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodInstruments"
    ADD CONSTRAINT "FK_DataSetInstrument_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3232 (class 2606 OID 112561)
-- Name: DataSetMethodInstruments FK_DataSetInstrument_InstrumentID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodInstruments"
    ADD CONSTRAINT "FK_DataSetInstrument_InstrumentID" FOREIGN KEY ("InstrumentID") REFERENCES lter_metabase."ListMethodInstruments"("InstrumentID") ON UPDATE CASCADE;


--
-- TOC entry 3233 (class 2606 OID 112566)
-- Name: DataSetMethodInstruments FK_DataSetInstrument_MethodStepSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodInstruments"
    ADD CONSTRAINT "FK_DataSetInstrument_MethodStepSet" FOREIGN KEY ("DataSetID", "MethodStepID") REFERENCES lter_metabase."DataSetMethod"("DataSetID", "MethodStepID") ON UPDATE CASCADE;


--
-- TOC entry 3228 (class 2606 OID 112571)
-- Name: DataSetKeywords FK_DataSetKeywords_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "FK_DataSetKeywords_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3229 (class 2606 OID 112576)
-- Name: DataSetKeywords FK_DataSetKeywords_Keyword; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "FK_DataSetKeywords_Keyword" FOREIGN KEY ("Keyword", "ThesaurusID") REFERENCES lter_metabase."ListKeywords"("Keyword", "ThesaurusID") ON UPDATE CASCADE;


--
-- TOC entry 3237 (class 2606 OID 112581)
-- Name: DataSetMethodProvenance FK_DataSetMethodProvenance; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProvenance"
    ADD CONSTRAINT "FK_DataSetMethodProvenance" FOREIGN KEY ("DataSetID", "MethodStepID") REFERENCES lter_metabase."DataSetMethod"("DataSetID", "MethodStepID") ON UPDATE CASCADE;


--
-- TOC entry 3230 (class 2606 OID 112586)
-- Name: DataSetMethod FK_DataSetMethodSteps_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethod"
    ADD CONSTRAINT "FK_DataSetMethodSteps_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID");


--
-- TOC entry 3241 (class 2606 OID 112591)
-- Name: DataSetPersonnel FK_DataSetPersonnel_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "FK_DataSetPersonnel_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3242 (class 2606 OID 112596)
-- Name: DataSetPersonnel FK_DataSetPersonnel_People; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "FK_DataSetPersonnel_People" FOREIGN KEY ("NameID") REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3234 (class 2606 OID 112601)
-- Name: DataSetMethodProtocols FK_DataSetProtocol_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProtocols"
    ADD CONSTRAINT "FK_DataSetProtocol_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3235 (class 2606 OID 112606)
-- Name: DataSetMethodProtocols FK_DataSetProtocol_MethodStepSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProtocols"
    ADD CONSTRAINT "FK_DataSetProtocol_MethodStepSet" FOREIGN KEY ("DataSetID", "MethodStepID") REFERENCES lter_metabase."DataSetMethod"("DataSetID", "MethodStepID") ON UPDATE CASCADE;


--
-- TOC entry 3236 (class 2606 OID 112611)
-- Name: DataSetMethodProtocols FK_DataSetProtocol_ProtocolID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodProtocols"
    ADD CONSTRAINT "FK_DataSetProtocol_ProtocolID" FOREIGN KEY ("ProtocolID") REFERENCES lter_metabase."ListMethodProtocols"("ProtocolID") ON UPDATE CASCADE;


--
-- TOC entry 3244 (class 2606 OID 112616)
-- Name: DataSetSites FK_DataSetSite_SiteCode; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "FK_DataSetSite_SiteCode" FOREIGN KEY ("SiteID") REFERENCES lter_metabase."ListSites"("SiteID") ON UPDATE CASCADE;


--
-- TOC entry 3238 (class 2606 OID 112621)
-- Name: DataSetMethodSoftware FK_DataSetSoftware_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodSoftware"
    ADD CONSTRAINT "FK_DataSetSoftware_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3239 (class 2606 OID 112626)
-- Name: DataSetMethodSoftware FK_DataSetSoftware_MethodStepSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodSoftware"
    ADD CONSTRAINT "FK_DataSetSoftware_MethodStepSet" FOREIGN KEY ("DataSetID", "MethodStepID") REFERENCES lter_metabase."DataSetMethod"("DataSetID", "MethodStepID") ON UPDATE CASCADE;


--
-- TOC entry 3240 (class 2606 OID 112631)
-- Name: DataSetMethodSoftware FK_DataSetSoftware_SoftwareID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethodSoftware"
    ADD CONSTRAINT "FK_DataSetSoftware_SoftwareID" FOREIGN KEY ("SoftwareID") REFERENCES lter_metabase."ListMethodSoftware"("SoftwareID") ON UPDATE CASCADE;


--
-- TOC entry 3245 (class 2606 OID 112636)
-- Name: DataSetTaxa FK_DataSetTaxa_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
    ADD CONSTRAINT "FK_DataSetTaxa_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3246 (class 2606 OID 112641)
-- Name: DataSetTaxa FK_DataSetTaxa_TaxonID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
    ADD CONSTRAINT "FK_DataSetTaxa_TaxonID" FOREIGN KEY ("TaxonID", "TaxonomicProviderID") REFERENCES lter_metabase."ListTaxa"("TaxonID", "TaxonomicProviderID") ON UPDATE CASCADE;


--
-- TOC entry 3247 (class 2606 OID 112646)
-- Name: DataSetTemporal FK_DataSetTemporal_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTemporal"
    ADD CONSTRAINT "FK_DataSetTemporal_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3252 (class 2606 OID 112651)
-- Name: ListMethodProtocols FK_DataSet_NameID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListMethodProtocols"
    ADD CONSTRAINT "FK_DataSet_NameID" FOREIGN KEY ("NameID") REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3218 (class 2606 OID 112656)
-- Name: DataSetAttributeEnumeration FK_DataSet_SortOrder_ColumnName; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeEnumeration"
    ADD CONSTRAINT "FK_DataSet_SortOrder_ColumnName" FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnName") REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnName") ON UPDATE CASCADE;


--
-- TOC entry 3219 (class 2606 OID 112661)
-- Name: DataSetAttributeMissingCodes FK_DataSet_SortOrder_ColumnName; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeMissingCodes"
    ADD CONSTRAINT "FK_DataSet_SortOrder_ColumnName" FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnName") REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnName") ON UPDATE CASCADE;


--
-- TOC entry 3216 (class 2606 OID 112666)
-- Name: DataSet FK_DataSet_UpdateFrequency; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSet"
    ADD CONSTRAINT "FK_DataSet_UpdateFrequency" FOREIGN KEY ("UpdateFrequency") REFERENCES pkg_mgmt.cv_maint_freq(eml_maintenance_frequency) ON UPDATE CASCADE;


--
-- TOC entry 3220 (class 2606 OID 112671)
-- Name: DataSetAttributeMissingCodes FK_DatasetMissingCode_MissingValueCodeID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeMissingCodes"
    ADD CONSTRAINT "FK_DatasetMissingCode_MissingValueCodeID" FOREIGN KEY ("MissingValueCodeID") REFERENCES lter_metabase."ListCodes"("CodeID") ON UPDATE CASCADE;


--
-- TOC entry 3249 (class 2606 OID 112676)
-- Name: EMLUnitDictionary FK_EMLUnitDictionary_EMLUnitTypes; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitDictionary"
    ADD CONSTRAINT "FK_EMLUnitDictionary_EMLUnitTypes" FOREIGN KEY ("unitType") REFERENCES lter_metabase."EMLUnitTypes"(id) ON UPDATE CASCADE;


--
-- TOC entry 3250 (class 2606 OID 112681)
-- Name: ListKeywords FK_Keywords_KeywordType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListKeywords"
    ADD CONSTRAINT "FK_Keywords_KeywordType" FOREIGN KEY ("KeywordType") REFERENCES lter_metabase."EMLKeywordTypes"("KeywordType") ON UPDATE CASCADE;


--
-- TOC entry 3251 (class 2606 OID 112686)
-- Name: ListKeywords FK_Keywords_ThesaurusID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListKeywords"
    ADD CONSTRAINT "FK_Keywords_ThesaurusID" FOREIGN KEY ("ThesaurusID") REFERENCES lter_metabase."ListKeywordThesauri"("ThesaurusID") ON UPDATE CASCADE;


--
-- TOC entry 3255 (class 2606 OID 112691)
-- Name: ListTaxa FK_ListTaxa_ProviderID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListTaxa"
    ADD CONSTRAINT "FK_ListTaxa_ProviderID" FOREIGN KEY ("TaxonomicProviderID") REFERENCES lter_metabase."ListTaxonomicProviders"("ProviderID") ON UPDATE CASCADE;


--
-- TOC entry 3253 (class 2606 OID 112696)
-- Name: ListPeopleID FK_Peopleidentification_People; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListPeopleID"
    ADD CONSTRAINT "FK_Peopleidentification_People" FOREIGN KEY ("NameID") REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3254 (class 2606 OID 112701)
-- Name: ListSites FK_SiteRegister_unit; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ListSites"
    ADD CONSTRAINT "FK_SiteRegister_unit" FOREIGN KEY ("AltitudeUnit") REFERENCES lter_metabase."EMLUnitDictionary"(id) ON UPDATE CASCADE;


--
-- TOC entry 3248 (class 2606 OID 112706)
-- Name: EMLMeasurementScaleDomains MeasurementScaleDomains_FK_MeasurementScale; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLMeasurementScaleDomains"
    ADD CONSTRAINT "MeasurementScaleDomains_FK_MeasurementScale" FOREIGN KEY ("MeasurementScale") REFERENCES lter_metabase."EMLMeasurementScales"("measurementScale") ON UPDATE CASCADE;


--
-- TOC entry 3277 (class 2606 OID 112878)
-- Name: DataSetPublications fk_DataSetPublications_DatasetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPublications"
    ADD CONSTRAINT "fk_DataSetPublications_DatasetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID");


--
-- TOC entry 3278 (class 2606 OID 112883)
-- Name: DataSetPublications fk_DataSetPublications_PublicationID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPublications"
    ADD CONSTRAINT "fk_DataSetPublications_PublicationID" FOREIGN KEY ("PublicationID") REFERENCES lter_metabase."ListPublications"("PublicationID");


--
-- TOC entry 3274 (class 2606 OID 112838)
-- Name: DataSetAttributeAnnotation fk_SAA_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeAnnotation"
    ADD CONSTRAINT "fk_SAA_DataSetID" FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnPosition") REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnPosition") ON UPDATE CASCADE;


--
-- TOC entry 3275 (class 2606 OID 112848)
-- Name: DataSetAttributeAnnotation fk_SAA_ObjPropID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeAnnotation"
    ADD CONSTRAINT "fk_SAA_ObjPropID" FOREIGN KEY ("ObjectPropertyID") REFERENCES lter_metabase."EMLObjectProperties"("ObjectPropertyID") ON UPDATE CASCADE;


--
-- TOC entry 3276 (class 2606 OID 112843)
-- Name: DataSetAttributeAnnotation fk_SAA_TermID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributeAnnotation"
    ADD CONSTRAINT "fk_SAA_TermID" FOREIGN KEY ("TermID") REFERENCES lter_metabase."ListSemanticAnnotationTerms"("TermID") ON UPDATE CASCADE;


--
-- TOC entry 3271 (class 2606 OID 112815)
-- Name: DataSetAnnotation fk_SA_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAnnotation"
    ADD CONSTRAINT "fk_SA_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3272 (class 2606 OID 112825)
-- Name: DataSetAnnotation fk_SA_ObjPropID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAnnotation"
    ADD CONSTRAINT "fk_SA_ObjPropID" FOREIGN KEY ("ObjectPropertyID") REFERENCES lter_metabase."EMLObjectProperties"("ObjectPropertyID") ON UPDATE CASCADE;


--
-- TOC entry 3273 (class 2606 OID 112820)
-- Name: DataSetAnnotation fk_SA_TermID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAnnotation"
    ADD CONSTRAINT "fk_SA_TermID" FOREIGN KEY ("TermID") REFERENCES lter_metabase."ListSemanticAnnotationTerms"("TermID") ON UPDATE CASCADE;


--
-- TOC entry 3256 (class 2606 OID 112711)
-- Name: boilerplate fk_boilerplate_contact_nameid; Type: FK CONSTRAINT; Schema: mb2eml_r; Owner: %db_owner%
--

ALTER TABLE ONLY mb2eml_r.boilerplate
    ADD CONSTRAINT fk_boilerplate_contact_nameid FOREIGN KEY (contact_nameid) REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3257 (class 2606 OID 112716)
-- Name: boilerplate fk_boilerplate_metadata_provider_nameid; Type: FK CONSTRAINT; Schema: mb2eml_r; Owner: %db_owner%
--

ALTER TABLE ONLY mb2eml_r.boilerplate
    ADD CONSTRAINT fk_boilerplate_metadata_provider_nameid FOREIGN KEY (metadata_provider_nameid) REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3258 (class 2606 OID 112721)
-- Name: boilerplate fk_boilerplate_publisher_nameid; Type: FK CONSTRAINT; Schema: mb2eml_r; Owner: %db_owner%
--

ALTER TABLE ONLY mb2eml_r.boilerplate
    ADD CONSTRAINT fk_boilerplate_publisher_nameid FOREIGN KEY (publisher_nameid) REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3261 (class 2606 OID 112726)
-- Name: pkg_core_area FK_cra; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT "FK_cra" FOREIGN KEY ("Core_area") REFERENCES pkg_mgmt.cv_cra(cra_id) ON UPDATE CASCADE;


--
-- TOC entry 3262 (class 2606 OID 112731)
-- Name: pkg_core_area FK_datasetid; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT "FK_datasetid" FOREIGN KEY ("DataSetID") REFERENCES pkg_mgmt.pkg_state("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3259 (class 2606 OID 112736)
-- Name: maintenance_changehistory FK_maintenance_changehistory_DataSetID; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.maintenance_changehistory
    ADD CONSTRAINT "FK_maintenance_changehistory_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3260 (class 2606 OID 112741)
-- Name: maintenance_changehistory FK_maintenance_changehistory_NameID; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.maintenance_changehistory
    ADD CONSTRAINT "FK_maintenance_changehistory_NameID" FOREIGN KEY ("NameID") REFERENCES lter_metabase."ListPeople"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3270 (class 2606 OID 112746)
-- Name: pkg_state pkg_mgmt_fk_cv_status; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_state
    ADD CONSTRAINT pkg_mgmt_fk_cv_status FOREIGN KEY (status) REFERENCES pkg_mgmt.cv_status(status) ON UPDATE CASCADE;


--
-- TOC entry 3263 (class 2606 OID 112751)
-- Name: pkg_sort pkg_sort_fk_mgmt_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_mgmt_type FOREIGN KEY (management_type) REFERENCES pkg_mgmt.cv_mgmt_type(mgmt_type) ON UPDATE CASCADE;


--
-- TOC entry 3264 (class 2606 OID 112756)
-- Name: pkg_sort pkg_sort_fk_network_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_network_type FOREIGN KEY (network_type) REFERENCES pkg_mgmt.cv_network_type(network_type) ON UPDATE CASCADE;


--
-- TOC entry 3265 (class 2606 OID 112761)
-- Name: pkg_sort pkg_sort_fk_pkg_state; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_pkg_state FOREIGN KEY ("DataSetID") REFERENCES pkg_mgmt.pkg_state("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3266 (class 2606 OID 112766)
-- Name: pkg_sort pkg_sort_fk_spatial_extent; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatial_extent FOREIGN KEY (spatial_extent) REFERENCES pkg_mgmt.cv_spatial_extent(spatial_extent) ON UPDATE CASCADE;


--
-- TOC entry 3267 (class 2606 OID 112771)
-- Name: pkg_sort pkg_sort_fk_spatial_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatial_type FOREIGN KEY (spatial_type) REFERENCES pkg_mgmt.cv_spatial_type(spatial_type) ON UPDATE CASCADE;


--
-- TOC entry 3268 (class 2606 OID 112776)
-- Name: pkg_sort pkg_sort_fk_spatio_temporal; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatio_temporal FOREIGN KEY (spatiotemporal) REFERENCES pkg_mgmt.cv_spatio_temporal(spatiotemporal) ON UPDATE CASCADE;


--
-- TOC entry 3269 (class 2606 OID 112781)
-- Name: pkg_sort pkg_sort_fk_temporal_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_temporal_type FOREIGN KEY (temporal_type) REFERENCES pkg_mgmt.cv_temporal_type(temporal_type) ON UPDATE CASCADE;


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA lter_metabase; Type: ACL; Schema: -; Owner: %db_owner%
--

GRANT USAGE ON SCHEMA lter_metabase TO read_write_user;
GRANT USAGE ON SCHEMA lter_metabase TO read_only_user;


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA mb2eml_r; Type: ACL; Schema: -; Owner: %db_owner%
--

GRANT USAGE ON SCHEMA mb2eml_r TO read_write_user;
GRANT USAGE ON SCHEMA mb2eml_r TO read_only_user;


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA pkg_mgmt; Type: ACL; Schema: -; Owner: %db_owner%
--

GRANT USAGE ON SCHEMA pkg_mgmt TO read_write_user;
GRANT USAGE ON SCHEMA pkg_mgmt TO read_only_user;


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE "DataSet"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSet" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSet" TO read_only_user;


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE "DataSetAnnotation"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetAnnotation" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetAnnotation" TO read_only_user;


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE "DataSetAttributeAnnotation"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetAttributeAnnotation" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetAttributeAnnotation" TO read_only_user;


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE "DataSetAttributeEnumeration"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetAttributeEnumeration" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetAttributeEnumeration" TO read_only_user;


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE "DataSetAttributeMissingCodes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT ON TABLE lter_metabase."DataSetAttributeMissingCodes" TO read_only_user;


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE "DataSetAttributes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetAttributes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetAttributes" TO read_only_user;


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE "DataSetEntities"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetEntities" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetEntities" TO read_only_user;


--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE "DataSetKeywords"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetKeywords" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetKeywords" TO read_only_user;


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE "DataSetMethod"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethod" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethod" TO read_only_user;


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE "DataSetMethodInstruments"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethodInstruments" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodInstruments" TO read_only_user;


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE "DataSetMethodProtocols"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethodProtocols" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProtocols" TO read_only_user;


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE "DataSetMethodProvenance"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_only_user;


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE "DataSetMethodSoftware"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethodSoftware" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodSoftware" TO read_only_user;


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE "DataSetPersonnel"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetPersonnel" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetPersonnel" TO read_only_user;


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE "DataSetPublications"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetPublications" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetPublications" TO read_only_user;


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE "DataSetSites"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetSites" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetSites" TO read_only_user;


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "DataSetTaxa"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetTaxa" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetTaxa" TO read_only_user;


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE "DataSetTemporal"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetTemporal" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetTemporal" TO read_only_user;


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "EMLFileTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLFileTypes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLFileTypes" TO read_only_user;


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "EMLKeywordTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLKeywordTypes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLKeywordTypes" TO read_only_user;


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "EMLMeasurementScaleDomains"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLMeasurementScaleDomains" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLMeasurementScaleDomains" TO read_only_user;


--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "EMLMeasurementScales"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLMeasurementScales" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLMeasurementScales" TO read_only_user;


--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "EMLNumberTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLNumberTypes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLNumberTypes" TO read_only_user;


--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE "EMLObjectProperties"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLObjectProperties" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLObjectProperties" TO read_only_user;


--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE "EMLStorageTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLStorageTypes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLStorageTypes" TO read_only_user;


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "EMLUnitDictionary"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLUnitDictionary" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLUnitDictionary" TO read_only_user;


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "EMLUnitTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLUnitTypes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."EMLUnitTypes" TO read_only_user;


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "ListCodes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListCodes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListCodes" TO read_only_user;


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "ListKeywordThesauri"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListKeywordThesauri" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListKeywordThesauri" TO read_only_user;


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "ListKeywords"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListKeywords" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListKeywords" TO read_only_user;


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "ListMethodInstruments"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodInstruments" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodInstruments" TO read_only_user;


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "ListMethodProtocols"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodProtocols" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodProtocols" TO read_only_user;


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE "ListMethodSoftware"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodSoftware" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodSoftware" TO read_only_user;


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE "ListPeople"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListPeople" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListPeople" TO read_only_user;


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "ListPeopleID"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListPeopleID" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListPeopleID" TO read_only_user;


--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE "ListPublications"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListPublications" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListPublications" TO read_only_user;


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE "ListSemanticAnnotationTerms"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListSemanticAnnotationTerms" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListSemanticAnnotationTerms" TO read_only_user;


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE "ListSites"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListSites" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListSites" TO read_only_user;


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE "ListTaxa"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListTaxa" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListTaxa" TO read_only_user;


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "ListTaxonomicProviders"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListTaxonomicProviders" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListTaxonomicProviders" TO read_only_user;


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE boilerplate; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.boilerplate TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.boilerplate TO read_only_user;


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE vw_custom_units; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_custom_units TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_custom_units TO read_only_user;


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE vw_eml_associatedparty; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_associatedparty TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_associatedparty TO read_only_user;


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE vw_eml_attributecodedefinition; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_only_user;


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE vw_eml_attributes; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributes TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributes TO read_only_user;


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE vw_eml_boilerplate; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_boilerplate TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_boilerplate TO read_only_user;


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE vw_eml_bp_people; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_bp_people TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_bp_people TO read_only_user;


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE maintenance_changehistory; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.maintenance_changehistory TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.maintenance_changehistory TO read_only_user;


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE vw_eml_changehistory; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_changehistory TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_changehistory TO read_only_user;


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE vw_eml_creator; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_creator TO read_only_user;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_creator TO read_write_user;


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE vw_eml_dataset; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_only_user;


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE vw_eml_entities; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_entities TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_entities TO read_only_user;


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE vw_eml_geographiccoverage; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_only_user;


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE vw_eml_instruments; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_instruments TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_instruments TO read_only_user;


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE vw_eml_keyword; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_keyword TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_keyword TO read_only_user;


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE vw_eml_methodstep_description; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_methodstep_description TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_methodstep_description TO read_only_user;


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE vw_eml_missingcodes; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_missingcodes TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_missingcodes TO read_only_user;


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE vw_eml_protocols; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_protocols TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_protocols TO read_only_user;


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE vw_eml_provenance; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_provenance TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_provenance TO read_only_user;


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE vw_eml_publications; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_publications TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_publications TO read_only_user;


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE vw_eml_semantic_annotation; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_semantic_annotation TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_semantic_annotation TO read_only_user;


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE vw_eml_software; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT ON TABLE mb2eml_r.vw_eml_software TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_software TO read_only_user;


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE vw_eml_taxonomy; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE vw_eml_temporalcoverage; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_temporalcoverage TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_temporalcoverage TO read_only_user;


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE cv_cra; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_cra TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_cra TO read_only_user;


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE cv_maint_freq; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_maint_freq TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_maint_freq TO read_only_user;


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE cv_mgmt_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_mgmt_type TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_mgmt_type TO read_only_user;


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE cv_network_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_network_type TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_network_type TO read_only_user;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE cv_spatial_extent; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatial_extent TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatial_extent TO read_only_user;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE cv_spatial_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatial_type TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatial_type TO read_only_user;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE cv_spatio_temporal; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatio_temporal TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatio_temporal TO read_only_user;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE cv_status; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_status TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_status TO read_only_user;


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE cv_temporal_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_temporal_type TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_temporal_type TO read_only_user;


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE pkg_core_area; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_core_area TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.pkg_core_area TO read_only_user;


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE pkg_sort; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_sort TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.pkg_sort TO read_only_user;


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE pkg_state; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_state TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.pkg_state TO read_only_user;


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE version_tracker_metabase; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT ON TABLE pkg_mgmt.version_tracker_metabase TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.version_tracker_metabase TO read_only_user;


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE vw_backlog; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_backlog TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_backlog TO read_only_user;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE vw_cataloged; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_cataloged TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_cataloged TO read_only_user;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE vw_draft_anticipated; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_draft_anticipated TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_draft_anticipated TO read_only_user;


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE vw_drafts_bak; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_drafts_bak TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_drafts_bak TO read_only_user;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE vw_im_plan; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_im_plan TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_im_plan TO read_only_user;


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE vw_pub; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_pub TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_pub TO read_only_user;


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE vw_self; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_self TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_self TO read_only_user;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE vw_temporal; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_temporal TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.vw_temporal TO read_only_user;


-- Completed on 2023-05-19 12:04:35

--
-- PostgreSQL database dump complete
--

