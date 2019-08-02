-- Database: lter_core_metabase

-- DROP DATABASE lter_core_metabase;

CREATE DATABASE lter_core_metabase
    WITH 
    OWNER = %db_owner%
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-10 10:25:18 PST


/* Instructions
 * preconditions
 * 1. before running this script, these roles were established
 * db_owner: CREATE schemas, tables, views, triggers, etc. runs backups, grants priveledges, INSERT, UPDATE, DELETE content
 * read_write_user: (optional) Intermediate priveledges, UPDATE, INSERT content, typicallly with a script (no DELETE)
 * read_only_user: SELECT only, for export 
 * 
 * 2. optional - to use an existing postgres account, edit this file to contain appropriate user names for:
 * db_owner - e.g., if db owner already has an account and wants to use it
 *  */ 


/*  Note: 
 * commented out several config settings so defaults can prevail. 
 * turn them on if needed.
 */

SET statement_timeout = 0;
-- SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
-- SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 130192)
-- Name: lter_metabase; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA lter_metabase;


ALTER SCHEMA lter_metabase OWNER TO %db_owner%;

--
-- TOC entry 3208 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA lter_metabase; Type: COMMENT; Schema: -; Owner: %db_owner%
--

COMMENT ON SCHEMA lter_metabase IS 'Schema holds portions of metabase, as needed by SBC LTER.';


--
-- TOC entry 8 (class 2615 OID 130193)
-- Name: mb2eml_r; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA mb2eml_r;


ALTER SCHEMA mb2eml_r OWNER TO %db_owner%;

--
-- TOC entry 9 (class 2615 OID 130194)
-- Name: pkg_mgmt; Type: SCHEMA; Schema: -; Owner: %db_owner%
--

CREATE SCHEMA pkg_mgmt;


ALTER SCHEMA pkg_mgmt OWNER TO %db_owner%;

--
-- TOC entry 1 (class 3079 OID 12595)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 237 (class 1255 OID 130195)
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
-- TOC entry 178 (class 1259 OID 130221)
-- Name: DataSet; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSet" (
    "DataSetID" integer NOT NULL,
    "Accession" character varying(16),
    "Title" character varying(300) NOT NULL,
    "Investigator" character varying(20) NOT NULL,
    "DataSetType" character varying(10),
    "Georeferences" boolean DEFAULT false NOT NULL,
    "SubmitDate" timestamp without time zone DEFAULT now(),
    "Abstract" character varying(5000) NOT NULL,
    "Status" character varying(50) DEFAULT 'New Submission'::character varying,
    "ProjectRelease" timestamp without time zone,
    "PublicRelease" timestamp without time zone,
    "geographicDescription" character varying(500)
);


ALTER TABLE lter_metabase."DataSet" OWNER TO %db_owner%;

--
-- TOC entry 179 (class 1259 OID 130230)
-- Name: DataSetAttributes; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetAttributes" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnPosition" smallint NOT NULL,
    "ColumnName" character varying(200) NOT NULL,
    "AttributeID" character varying(200) NOT NULL,
    "AttributeLabel" character varying(200) NOT NULL,
    "Description" character varying(2000) DEFAULT 'none'::character varying,
    "StorageType" character varying(30),
    "MeasurementScaleDomainID" character varying(12),
    "FormatString" character varying(40),
    "PrecisionDateTime" character varying(40),
    "TextPatternDefinition" character varying(500),
    "Unit" character varying(100),
    "PrecisionNumeric" double precision,
    "NumberType" character varying(30),
    "MissingValueCode" character varying(30),
    "missingValueCodeExplanation" character varying(200),
    minimum character varying(100),
    maximum character varying(100),
    CONSTRAINT "DataSetAttributes_CK_FormatString" CHECK (((("FormatString" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ 'dateTime'::text)) OR (("FormatString" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ 'dateTime'::text)))),
    CONSTRAINT "DataSetAttributes_CK_NumberType" CHECK (((("NumberType" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("NumberType" IS NOT NULL) AND (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text]))))),
    CONSTRAINT "DataSetAttributes_CK_PrecisionDateTime" CHECK (((("PrecisionDateTime" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ 'dateTime'::text)) OR (("PrecisionDateTime" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ 'dateTime'::text)))),
    CONSTRAINT "DataSetAttributes_CK_PrecisionNumeric" CHECK (((("PrecisionNumeric" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])))),
    CONSTRAINT "DataSetAttributes_CK_TextPatternDefinition" CHECK (((("TextPatternDefinition" IS NULL) AND (("MeasurementScaleDomainID")::text !~~ '%Text'::text)) OR (("TextPatternDefinition" IS NOT NULL) AND (("MeasurementScaleDomainID")::text ~~ '%Text'::text)))),
    CONSTRAINT "DataSetAttributes_CK_unit" CHECK (((("Unit" IS NULL) AND (("MeasurementScaleDomainID")::text <> ALL (ARRAY['ratio'::text, 'interval'::text]))) OR (("Unit" IS NOT NULL) AND (("MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])))))
);


ALTER TABLE lter_metabase."DataSetAttributes" OWNER TO %db_owner%;

--
-- TOC entry 180 (class 1259 OID 130243)
-- Name: DataSetEntities; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetEntities" (
    "DataSetID" integer NOT NULL,
    "SortOrder" integer NOT NULL,
    "EntityName" character varying(100) NOT NULL,
    "EntityType" character varying(50) NOT NULL,
    "EntityDescription" character varying(1000) NOT NULL,
    "EntityRecords" integer,
    "FileType" character varying(10),
    "Urlhead" character varying(1024),
    "Subpath" character varying(1024),
    "FileName" character varying(200),
    "DataAnomalies" character varying(7000)
);


ALTER TABLE lter_metabase."DataSetEntities" OWNER TO %db_owner%;

--
-- TOC entry 181 (class 1259 OID 130249)
-- Name: DataSetKeywords; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetKeywords" (
    "DataSetID" integer NOT NULL,
    "Keyword" character varying(100) NOT NULL,
    "ThesaurusID" character varying(1024) DEFAULT 'foo'::character varying NOT NULL
);


ALTER TABLE lter_metabase."DataSetKeywords" OWNER TO %db_owner%;

--
-- TOC entry 182 (class 1259 OID 130256)
-- Name: DataSetMethods; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetMethods" (
    "MethodID" integer NOT NULL,
    "DataSetID" integer NOT NULL,
    "effectiveRange" integer NOT NULL,
    "methodDocument" character varying(100),
    "protocolID" integer,
    "instrumentTitle" character varying(1024),
    "instrumentOwner" character varying(100),
    "instrumentDescription" character varying(1024),
    "softwareTitle" character varying(1024),
    "softwareOwner" character varying(100),
    "softwareDescription" character varying(1000),
    "softwareVersion" character varying(10)
);


ALTER TABLE lter_metabase."DataSetMethods" OWNER TO %db_owner%;

--
-- TOC entry 183 (class 1259 OID 130262)
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
-- TOC entry 184 (class 1259 OID 130265)
-- Name: DataSetSites; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetSites" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "SiteCode" character varying(50) NOT NULL,
    "GeoCoverageSortOrder" integer DEFAULT 1 NOT NULL
);


ALTER TABLE lter_metabase."DataSetSites" OWNER TO %db_owner%;

--
-- TOC entry 185 (class 1259 OID 130269)
-- Name: DataSetTemporal; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."DataSetTemporal" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "BeginDate" date NOT NULL,
    "EndDate" date NOT NULL,
    "UseOnlyYear" boolean
);


ALTER TABLE lter_metabase."DataSetTemporal" OWNER TO %db_owner%;

--
-- TOC entry 186 (class 1259 OID 130272)
-- Name: EMLAttributeCodeDefinition; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLAttributeCodeDefinition" (
    "DataSetID" integer NOT NULL,
    "EntitySortOrder" integer NOT NULL,
    "ColumnName" character varying(200) NOT NULL,
    code character varying(200) NOT NULL,
    definition character varying(1024) NOT NULL
);


ALTER TABLE lter_metabase."EMLAttributeCodeDefinition" OWNER TO %db_owner%;

--
-- TOC entry 187 (class 1259 OID 130278)
-- Name: EMLKeywordTypeList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLKeywordTypeList" (
    "KeywordType" character varying(20) NOT NULL,
    "TypeDefinition" character varying(500)
);


ALTER TABLE lter_metabase."EMLKeywordTypeList" OWNER TO %db_owner%;

--
-- TOC entry 188 (class 1259 OID 130284)
-- Name: EMLMeasurementScaleList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLMeasurementScaleList" (
    "measurementScale" character varying(20) NOT NULL
);


ALTER TABLE lter_metabase."EMLMeasurementScaleList" OWNER TO %db_owner%;

--
-- TOC entry 189 (class 1259 OID 130287)
-- Name: EMLNumberTypeList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLNumberTypeList" (
    "NumberType" character varying(30) NOT NULL
);


ALTER TABLE lter_metabase."EMLNumberTypeList" OWNER TO %db_owner%;

--
-- TOC entry 190 (class 1259 OID 130290)
-- Name: EMLStorageTypeList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."EMLStorageTypeList" (
    "StorageType" character varying(30) NOT NULL,
    "typeSystem" character varying(200)
);


ALTER TABLE lter_metabase."EMLStorageTypeList" OWNER TO %db_owner%;

--
-- TOC entry 3227 (class 0 OID 0)
-- Dependencies: 190
-- Name: COLUMN "EMLStorageTypeList"."typeSystem"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."EMLStorageTypeList"."typeSystem" IS 'include the entire url if it is a url';


--
-- TOC entry 191 (class 1259 OID 130293)
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
-- TOC entry 192 (class 1259 OID 130300)
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
-- TOC entry 193 (class 1259 OID 130303)
-- Name: FileTypeList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."FileTypeList" (
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


ALTER TABLE lter_metabase."FileTypeList" OWNER TO %db_owner%;

--
-- TOC entry 194 (class 1259 OID 130311)
-- Name: KeywordThesaurus; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."KeywordThesaurus" (
    "ThesaurusID" character varying(50) NOT NULL,
    "ThesaurusLabel" character varying(250),
    "ThesaurusUrl" character varying(250),
    "UseInMetadata" boolean DEFAULT true NOT NULL,
    "ThesaurusSortOrder" integer
);


ALTER TABLE lter_metabase."KeywordThesaurus" OWNER TO %db_owner%;

--
-- TOC entry 195 (class 1259 OID 130318)
-- Name: Keywords; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."Keywords" (
    "Keyword" character varying(50) NOT NULL,
    "ThesaurusID" character varying(50) NOT NULL,
    "KeywordType" character varying(20) DEFAULT 'theme'::character varying NOT NULL
);


ALTER TABLE lter_metabase."Keywords" OWNER TO %db_owner%;

--
-- TOC entry 196 (class 1259 OID 130322)
-- Name: MeasurementScaleDomains; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."MeasurementScaleDomains" (
    "EMLDomainType" character varying(17) NOT NULL,
    "MeasurementScale" character varying(8) NOT NULL,
    "NonNumericDomain" character varying(17),
    "MeasurementScaleDomainID" character varying(12) NOT NULL
);


ALTER TABLE lter_metabase."MeasurementScaleDomains" OWNER TO %db_owner%;

--
-- TOC entry 176 (class 1259 OID 130212)
-- Name: People; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."People" (
    "NameID" character varying(20) NOT NULL,
    "Honorific" character varying(10),
    "GivenName" character varying(30) NOT NULL,
    "MiddleName" character varying(30),
    "SurName" character varying(50) NOT NULL,
    "FriendlyName" character varying(50),
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
    "Phone1" character varying(50),
    "Phone2" character varying(50),
    "FAX" character varying(50),
    dbupdatetime timestamp without time zone
);


ALTER TABLE lter_metabase."People" OWNER TO %db_owner%;

--
-- TOC entry 177 (class 1259 OID 130218)
-- Name: Peopleidentification; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."Peopleidentification" (
    "NameID" character varying(20) NOT NULL,
    "IdentificationID" smallint NOT NULL,
    "Identificationtype" character varying(30),
    "Identificationlink" character varying(200)
);


ALTER TABLE lter_metabase."Peopleidentification" OWNER TO %db_owner%;

--
-- TOC entry 197 (class 1259 OID 130325)
-- Name: ProtocolList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."ProtocolList" (
    "protocolID" integer NOT NULL,
    author character varying(16),
    title character varying(300),
    url character varying(1024) NOT NULL
);


ALTER TABLE lter_metabase."ProtocolList" OWNER TO %db_owner%;

--
-- TOC entry 198 (class 1259 OID 130331)
-- Name: SiteList; Type: TABLE; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TABLE lter_metabase."SiteList" (
    "SiteCode" character varying(50) NOT NULL,
    "SiteType" character varying(10) NOT NULL,
    "SiteName" character varying(100) NOT NULL,
    "SiteLocation" character varying(100) DEFAULT 'California, USA'::character varying NOT NULL,
    "SiteDesc" character varying(1000),
    "Ownership" character varying(100),
    "ShapeType" character varying(20) NOT NULL,
    "CenterLon" character varying(100),
    "CenterLat" character varying(100),
    "WBoundLon" character varying(100),
    "EBoundLon" character varying(100),
    "SBoundLat" character varying(100),
    "NBoundLat" character varying(100),
    "AltitudeMin" character varying(100),
    "AltitudeMax" character varying(100),
    unit character varying(10),
    CONSTRAINT "CK_SiteRegister_ShapeType" CHECK ((("ShapeType")::text = ANY (ARRAY[('point'::character varying)::text, ('rectangle'::character varying)::text, ('polygon'::character varying)::text, ('polyline'::character varying)::text, ('vector'::character varying)::text]))),
    CONSTRAINT "CK_SiteRegister_SiteType" CHECK ((("SiteType")::text = ANY (ARRAY[('beach'::character varying)::text, ('intertidal'::character varying)::text, ('land'::character varying)::text, ('nearshore'::character varying)::text, ('offshore'::character varying)::text, ('other'::character varying)::text, ('pier'::character varying)::text, ('reef'::character varying)::text])))
);


ALTER TABLE lter_metabase."SiteList" OWNER TO %db_owner%;

--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 198
-- Name: COLUMN "SiteList"."SiteType"; Type: COMMENT; Schema: lter_metabase; Owner: %db_owner%
--

COMMENT ON COLUMN lter_metabase."SiteList"."SiteType" IS 'Beach (beach site. may overlap with land); intertidal (intertidal. usually rocky, may overlap beach, land); land (land based sampling site); nearshore (nearshore ocean. overlaps with reef); offshore (offshore ocean. may overlap with nearshore); other (unspecified); pier (pier or wharf, in the ocean but attached to shore); reef (reef based sampling site)';


--
-- TOC entry 199 (class 1259 OID 130340)
-- Name: vw_custom_units; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_custom_units AS
SELECT v."DataSetID" AS datasetid, v."Unit" AS id, u."unitType", u.abbreviation, u."multiplierToSI", u."parentSI", u."constantToSI", u.description FROM (lter_metabase."DataSetAttributes" v JOIN lter_metabase."EMLUnitDictionary" u ON (((v."Unit")::text = (u.name)::text))) GROUP BY v."DataSetID", v."Unit", u."unitType", u.abbreviation, u."multiplierToSI", u."parentSI", u."constantToSI", u.description ORDER BY v."DataSetID";


ALTER TABLE mb2eml_r.vw_custom_units OWNER TO %db_owner%;

--
-- TOC entry 200 (class 1259 OID 130345)
-- Name: vw_eml_attributecodedefinition; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_attributecodedefinition AS
SELECT d."DataSetID" AS datasetid, d."EntitySortOrder" AS entity_position, d."ColumnName" AS "attributeName", d.code, d.definition FROM lter_metabase."EMLAttributeCodeDefinition" d ORDER BY d."DataSetID", d."EntitySortOrder";


ALTER TABLE mb2eml_r.vw_eml_attributecodedefinition OWNER TO %db_owner%;

--
-- TOC entry 201 (class 1259 OID 130349)
-- Name: vw_eml_attributes; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_attributes AS
SELECT d."DataSetID" AS datasetid, d."EntitySortOrder" AS entity_position, d."ColumnName" AS "attributeName", d."AttributeLabel" AS "attributeLabel", d."Description" AS "attributeDefinition", CASE WHEN ((d."MeasurementScaleDomainID")::text ~~ 'nominal%'::text) THEN 'nominal'::character varying WHEN ((d."MeasurementScaleDomainID")::text ~~ 'ordinal%'::text) THEN 'ordinal'::character varying ELSE d."MeasurementScaleDomainID" END AS "measurementScale", CASE WHEN ((d."MeasurementScaleDomainID")::text ~~ '%Enum'::text) THEN 'enumeratedDomain'::text WHEN ((d."MeasurementScaleDomainID")::text ~~ '%Text'::text) THEN 'textDomain'::text WHEN ((d."MeasurementScaleDomainID")::text = ANY (ARRAY['ratio'::text, 'interval'::text])) THEN 'numericDomain'::text WHEN ((d."MeasurementScaleDomainID")::text = 'dateTime'::text) THEN 'dateTimeDomain'::text ELSE NULL::text END AS domain, d."StorageType" AS "storageType", d."FormatString" AS "formatString", d."PrecisionDateTime" AS "dateTimePrecision", d."TextPatternDefinition" AS definition, d."Unit" AS unit, d."PrecisionNumeric" AS "precision", d."NumberType" AS "numberType", d."MissingValueCode" AS "missingValueCode", d."missingValueCodeExplanation", d.minimum, d.maximum FROM lter_metabase."DataSetAttributes" d ORDER BY d."DataSetID", d."EntitySortOrder", d."ColumnPosition";


ALTER TABLE mb2eml_r.vw_eml_attributes OWNER TO %db_owner%;

--
-- TOC entry 202 (class 1259 OID 130354)
-- Name: vw_eml_creator; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_creator AS
SELECT d."DataSetID" AS datasetid, d."AuthorshipOrder" AS authorshiporder, d."AuthorshipRole" AS authorshiprole, d."NameID" AS nameid, (p."GivenName")::text AS givenname, p."MiddleName" AS givenname2, p."SurName" AS surname, p."Organization" AS organization, p."Address1" AS address1, p."Address2" AS address2, p."Address3" AS address3, p."City" AS city, p."State" AS state, p."Country" AS country, p."ZipCode" AS zipcode, p."Phone1" AS phone1, p."Phone2" AS phone2, p."FAX" AS fax, p."Email" AS email, i."Identificationlink" AS orcid FROM ((lter_metabase."DataSetPersonnel" d LEFT JOIN lter_metabase."People" p ON (((d."NameID")::text = (p."NameID")::text))) LEFT JOIN lter_metabase."Peopleidentification" i ON (((d."NameID")::text = (i."NameID")::text))) WHERE (((d."AuthorshipRole")::text = 'creator'::text) OR ((d."AuthorshipRole")::text = 'organization'::text)) ORDER BY d."DataSetID", d."AuthorshipOrder";


ALTER TABLE mb2eml_r.vw_eml_creator OWNER TO %db_owner%;

--
-- TOC entry 175 (class 1259 OID 130206)
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
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 175
-- Name: TABLE pkg_state; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_state IS 'aka wordy';


--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.dataset_archive_id; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dataset_archive_id IS 'ie knb-lter-mcr.1234 or if not assigned a real id yet then what';


--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.rev; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.rev IS 'revision is needed for showDraft. By definition, rev for draft0 is 0. Rev for cataloged make null so latest rev is shown.';


--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.nickname; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.nickname IS 'ie fish_survey or flume or par. This is NOT the eml shortName except perhaps by coincidence.  shortName is stored elsewhere. This is not the staging directory except by coincidence.';


--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.status; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.status IS 'anticipated, draft0, cataloged, backlog or anticipated, draft then back to cataloged';


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.synth_readiness; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.synth_readiness IS 'One of metadata_only, download, integration, annotated.  These are levels of readiness for synthesis. Each builds on the lower levels.';


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.staging_dir; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.staging_dir IS 'The subdirectory where the IMs work on data files after receiving in final_dir and prior to posting in external_dir. Root portion of path is a different constant for MCR than SBC.';


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.eml_draft_path; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.eml_draft_path IS 'For most pkgs this is merely ''mcr/''. For RAPID datasets this is ''mcr/RAPID/''. For drafts split out into a named dir this might be ''mcr/core/optical/EML/''';


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.notes; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.notes IS 'what needs doing. what the holdup is. issues.';


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.pub_notes; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.pub_notes IS 'Reason for being in this state, ie why it is metadata-only currently or Type II.  Such as grad student data or pending publication. May apply to status, network_type, synthesis_readiness.';


--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.who2bug; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.who2bug IS 'often not the creator rather the tech or whoever we need to pester';


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.dir_internal_final; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dir_internal_final IS 'directory where submitted so-called final data is staged for inspection.  where to look for new data.';


--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.dbupdatetime; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.dbupdatetime IS 'automatically updates itself.';


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN pkg_state.update_date_catalog; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_state.update_date_catalog IS 'Date package last updated in catalog (same as pathquery updatedate)';


--
-- TOC entry 203 (class 1259 OID 130359)
-- Name: vw_eml_dataset; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_dataset AS
SELECT d."DataSetID" AS datasetid, k.dataset_archive_id AS alternatedid, pg_catalog.concat(k.dataset_archive_id, '.', k.rev) AS edinum, d."Title" AS title, d."Abstract" AS abstract, k.data_receipt_date AS projdate, k.update_date_catalog AS pubdate, k.nickname AS shortname FROM (lter_metabase."DataSet" d LEFT JOIN pkg_mgmt.pkg_state k ON ((d."DataSetID" = k."DataSetID"))) ORDER BY d."DataSetID";


ALTER TABLE mb2eml_r.vw_eml_dataset OWNER TO %db_owner%;

--
-- TOC entry 204 (class 1259 OID 130364)
-- Name: vw_eml_datasetmethod; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_datasetmethod AS
SELECT d."DataSetID" AS datasetid, d."effectiveRange", d."methodDocument", k."SurName" AS "protocolOwner", p.title AS "protocolTitle", p.url AS "protocolDescription", d."instrumentTitle", d."instrumentOwner", d."instrumentDescription", d."softwareTitle", d."softwareOwner", d."softwareDescription", d."softwareVersion" FROM ((lter_metabase."DataSetMethods" d LEFT JOIN lter_metabase."ProtocolList" p ON (((d."protocolID")::text = (p."protocolID")::text))) LEFT JOIN lter_metabase."People" k ON (((p.author)::text = (k."NameID")::text))) ORDER BY d."DataSetID", d."methodDocument";


ALTER TABLE mb2eml_r.vw_eml_datasetmethod OWNER TO %db_owner%;

--
-- TOC entry 205 (class 1259 OID 130369)
-- Name: vw_eml_entities; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_entities AS
SELECT e."DataSetID" AS datasetid, e."SortOrder" AS entity_position, e."EntityType" AS entitytype, e."EntityName" AS entityname, e."EntityDescription" AS entitydescription, pg_catalog.concat(e."Urlhead", e."Subpath") AS urlpath, e."FileName" AS filename, e."EntityRecords" AS entityrecords, k."FileFormat" AS fileformat, k."EML_FormatType" AS formattype, k."RecordDelimiter" AS recorddelimiter, k."NumHeaderLines" AS headerlines, k."NumFooterLines" AS footerlines, k."FieldDelimiter" AS fielddlimiter, k."externallyDefinedFormat_formatName" AS formatname, k."QuoteCharacter" AS quotecharacter, k."CollapseDelimiters" AS collapsedelimiter  FROM (lter_metabase."DataSetEntities" e LEFT JOIN lter_metabase."FileTypeList" k ON (((e."FileType")::text = (k."FileType")::text))) ORDER BY e."DataSetID", e."SortOrder";


ALTER TABLE mb2eml_r.vw_eml_entities OWNER TO %db_owner%;

--
-- TOC entry 206 (class 1259 OID 130374)
-- Name: vw_eml_geographiccoverage; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_geographiccoverage AS
SELECT d."DataSetID" AS datasetid, d."EntitySortOrder" AS entity_position, d."GeoCoverageSortOrder" AS geocoverage_sort_order, d."SiteCode" AS id, ((s."SiteName")::text || COALESCE(': '::text || (s."SiteDesc")::text, '')) AS geographicdescription, s."NBoundLat" AS northboundingcoordinate, s."SBoundLat" AS southboundingcoordinate, s."EBoundLon" AS eastboundingcoordinate, s."WBoundLon" AS westboundingcoordinate, s."AltitudeMin" AS altitudeminimum, s."AltitudeMax" AS altitudemaximum, s.unit AS altitudeunits FROM (lter_metabase."DataSetSites" d LEFT JOIN lter_metabase."SiteList" s ON (((d."SiteCode")::text = (s."SiteCode")::text))) ORDER BY d."DataSetID", d."GeoCoverageSortOrder", d."SiteCode";


ALTER TABLE mb2eml_r.vw_eml_geographiccoverage OWNER TO %db_owner%;

--
-- TOC entry 207 (class 1259 OID 130379)
-- Name: vw_eml_keyword; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_keyword AS
SELECT d."DataSetID" AS datasetid, t."ThesaurusSortOrder" AS thesaurus_sort_order, d."Keyword" AS keyword, COALESCE(t."ThesaurusLabel", 'none'::character varying) AS keyword_thesaurus, k."KeywordType" AS keywordtype FROM ((lter_metabase."DataSetKeywords" d LEFT JOIN lter_metabase."Keywords" k ON (((d."Keyword")::text = (k."Keyword")::text))) JOIN lter_metabase."KeywordThesaurus" t ON (((k."ThesaurusID")::text = (t."ThesaurusID")::text))) GROUP BY d."DataSetID", t."ThesaurusSortOrder", d."Keyword", t."ThesaurusLabel", k."KeywordType" ORDER BY d."DataSetID", t."ThesaurusSortOrder", d."Keyword";


ALTER TABLE mb2eml_r.vw_eml_keyword OWNER TO %db_owner%;

--
-- TOC entry 208 (class 1259 OID 130383)
-- Name: vw_eml_temporalcoverage; Type: VIEW; Schema: mb2eml_r; Owner: %db_owner%
--

CREATE VIEW mb2eml_r.vw_eml_temporalcoverage AS
SELECT "DataSetTemporal"."DataSetID" AS datasetid, "DataSetTemporal"."EntitySortOrder" AS entity_position, CASE "DataSetTemporal"."UseOnlyYear" WHEN true THEN to_char(("DataSetTemporal"."BeginDate")::timestamp with time zone, 'YYYY'::text) ELSE to_char(("DataSetTemporal"."BeginDate")::timestamp with time zone, 'YYYY-MM-DD'::text) END AS begindate, CASE "DataSetTemporal"."UseOnlyYear" WHEN true THEN to_char(("DataSetTemporal"."EndDate")::timestamp with time zone, 'YYYY'::text) ELSE to_char(("DataSetTemporal"."EndDate")::timestamp with time zone, 'YYYY-MM-DD'::text) END AS enddate FROM lter_metabase."DataSetTemporal" ORDER BY "DataSetTemporal"."DataSetID", "DataSetTemporal"."EntitySortOrder";


ALTER TABLE mb2eml_r.vw_eml_temporalcoverage OWNER TO %db_owner%;

--
-- TOC entry 172 (class 1259 OID 130196)
-- Name: cv_cra; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_cra (
    cra_id character varying(10) NOT NULL,
    cra_name character varying(100) NOT NULL
);


ALTER TABLE pkg_mgmt.cv_cra OWNER TO %db_owner%;

--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 172
-- Name: TABLE cv_cra; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.cv_cra IS 'core study area';


--
-- TOC entry 209 (class 1259 OID 130387)
-- Name: cv_mgmt_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_mgmt_type (
    mgmt_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_mgmt_type OWNER TO %db_owner%;

--
-- TOC entry 210 (class 1259 OID 130393)
-- Name: cv_network_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_network_type (
    network_type character varying(3) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_network_type OWNER TO %db_owner%;

--
-- TOC entry 211 (class 1259 OID 130399)
-- Name: cv_spatial_extent; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatial_extent (
    spatial_extent character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatial_extent OWNER TO %db_owner%;

--
-- TOC entry 212 (class 1259 OID 130405)
-- Name: cv_spatial_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatial_type (
    spatial_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatial_type OWNER TO %db_owner%;

--
-- TOC entry 213 (class 1259 OID 130411)
-- Name: cv_spatio_temporal; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_spatio_temporal (
    spatiotemporal character(4) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_spatio_temporal OWNER TO %db_owner%;

--
-- TOC entry 214 (class 1259 OID 130417)
-- Name: cv_status; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_status (
    status character varying(20) NOT NULL
);


ALTER TABLE pkg_mgmt.cv_status OWNER TO %db_owner%;

--
-- TOC entry 215 (class 1259 OID 130420)
-- Name: cv_temporal_type; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.cv_temporal_type (
    temporal_type character varying(32) NOT NULL,
    definition character varying(1024)
);


ALTER TABLE pkg_mgmt.cv_temporal_type OWNER TO %db_owner%;

--
-- TOC entry 173 (class 1259 OID 130199)
-- Name: pkg_core_area; Type: TABLE; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TABLE pkg_mgmt.pkg_core_area (
    "DataSetID" integer NOT NULL,
    "Core_area" character varying(10) NOT NULL
);


ALTER TABLE pkg_mgmt.pkg_core_area OWNER TO %db_owner%;

--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 173
-- Name: TABLE pkg_core_area; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_core_area IS 'core study area';


--
-- TOC entry 174 (class 1259 OID 130202)
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
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 174
-- Name: TABLE pkg_sort; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON TABLE pkg_mgmt.pkg_sort IS 'pkg_state is wordy and pkg_sort is terse. Instead of one really wide table.  Just easier to edit.';


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 174
-- Name: COLUMN pkg_sort.network_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.network_type IS 'Two values have been defined by the LTER network: Type I and Type II
if neither applies, NULL.';


--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 174
-- Name: COLUMN pkg_sort.is_signature; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.is_signature IS 'defined at discretion of site or PI';


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 174
-- Name: COLUMN pkg_sort.spatial_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.spatial_type IS 'choices: multi-site, one site of one, one place of a site series, non-spatial.';


--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 174
-- Name: COLUMN pkg_sort.management_type; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.management_type IS 'template vs non_templated. The way the metadata is generated.';


--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 174
-- Name: COLUMN pkg_sort.in_pasta; Type: COMMENT; Schema: pkg_mgmt; Owner: %db_owner%
--

COMMENT ON COLUMN pkg_mgmt.pkg_sort.in_pasta IS 'This package ID is in production pasta. No implications re access restrictions. Merely passing evaluate does not mean in_pasta is true. column synth_readiness is for that property.';


--
-- TOC entry 216 (class 1259 OID 130426)
-- Name: vw_backlog; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_backlog AS
SELECT s.dataset_archive_id AS dataset_id, CASE WHEN ((s.status)::text = 'draft0'::text) THEN 0 ELSE s.rev END AS rev, s.eml_draft_path, s.nickname, s.data_receipt_date AS "data received", replace((s.status)::text, '_'::text, ' '::text) AS status, o.network_type AS "network type", replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type", t."Title" AS title, CASE WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying ELSE s.who2bug END AS "who to bug", s.update_date_catalog AS "catalog last updated", to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated" FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" t ON (((s."DataSetID")::text = (t."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) WHERE ((s.data_receipt_date > s.update_date_catalog) OR ((s.status)::text ~~ 'backlog'::text)) ORDER BY s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_backlog OWNER TO %db_owner%;

--
-- TOC entry 217 (class 1259 OID 130431)
-- Name: vw_cataloged; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_cataloged AS
SELECT pkg_state.dataset_archive_id AS dataset_id, pkg_state.nickname, pkg_sort.temporal_type, pkg_sort.management_type, pkg_sort.network_type, pkg_state.update_date_catalog, pkg_state.notes FROM (pkg_mgmt.pkg_state JOIN pkg_mgmt.pkg_sort ON (((pkg_state."DataSetID")::text = (pkg_sort."DataSetID")::text))) WHERE ((pkg_state.status)::text = 'cataloged'::text) ORDER BY pkg_sort.temporal_type, pkg_state.nickname;


ALTER TABLE pkg_mgmt.vw_cataloged OWNER TO %db_owner%;

--
-- TOC entry 218 (class 1259 OID 130436)
-- Name: vw_draft_anticipated; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_draft_anticipated AS
SELECT pkg_state.dataset_archive_id AS dataset_id, pkg_state.nickname, pkg_sort.temporal_type, pkg_sort.management_type, pkg_sort.network_type, pkg_state.status, pkg_state.notes FROM (pkg_mgmt.pkg_state JOIN pkg_mgmt.pkg_sort ON (((pkg_state."DataSetID")::text = (pkg_sort."DataSetID")::text))) WHERE (((pkg_state.status)::text = 'draft0'::text) OR ((pkg_state.status)::text = 'anticipated'::text)) ORDER BY pkg_state.status DESC, pkg_sort.temporal_type, pkg_state.nickname;


ALTER TABLE pkg_mgmt.vw_draft_anticipated OWNER TO %db_owner%;

--
-- TOC entry 219 (class 1259 OID 130441)
-- Name: vw_drafts_bak; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_drafts_bak AS
SELECT s.dataset_archive_id AS dataset_id, CASE WHEN ((s.status)::text = 'draft0'::text) THEN 0 ELSE s.rev END AS rev, s.eml_draft_path, s.nickname, s.data_receipt_date AS "data received", replace((s.status)::text, '_'::text, ' '::text) AS status, o.network_type AS "network type", replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type", m."Title" AS title, CASE WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying ELSE s.who2bug END AS "who to bug", s.update_date_catalog AS "catalog last updated", to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated" FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) WHERE (((s.data_receipt_date > s.update_date_catalog) OR ((s.status)::text ~~ 'backlog'::text)) OR ((s.status)::text ~~ 'draft%'::text)) ORDER BY s.eml_draft_path, s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_drafts_bak OWNER TO %db_owner%;

--
-- TOC entry 220 (class 1259 OID 130446)
-- Name: vw_dump; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_dump AS
SELECT s.dataset_archive_id AS dataset_id, s.rev, s.nickname, s.data_receipt_date, s.status, s.synth_readiness, s.staging_dir, s.eml_draft_path, s.notes, s.pub_notes, s.who2bug, s.dir_internal_final, s.dbupdatetime, s.update_date_catalog, o."DataSetID" AS dataset_id_, o.network_type, o.is_signature, o.is_core, o.temporal_type, o.spatial_extent, o.spatiotemporal, o.is_thesis, o.is_reference, o.is_exogenous, o.spatial_type, o.dbupdatetime AS dbupdatetime_, o.management_type FROM (pkg_mgmt.pkg_state s LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) ORDER BY split_part(replace((s.dataset_archive_id)::text, 'X'::text, '9'::text), '.'::text, 2);


ALTER TABLE pkg_mgmt.vw_dump OWNER TO %db_owner%;

--
-- TOC entry 221 (class 1259 OID 130451)
-- Name: vw_im_plan; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_im_plan AS
SELECT replace((o.temporal_type)::text, '_'::text, ' '::text) AS "Temporal type", ((split_part((s.dataset_archive_id)::text, '.'::text, 1) || '.'::text) || split_part((s.dataset_archive_id)::text, '.'::text, 2)) AS "Dataset ID", s.nickname AS "Short Name", o.network_type AS "Network type", o.management_type AS "Management type", to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "Catalog update date", s.notes AS "Notes", replace(replace((s.status)::text, '_'::text, ' '::text), 'draft'::text, 'revision pending'::text) AS status FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) WHERE ((s.status)::text = ANY (ARRAY[('cataloged'::character varying)::text, ('backlog'::character varying)::text, ('redesign_anticipated'::character varying)::text, ('draft'::character varying)::text])) ORDER BY o.temporal_type, s.nickname, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_im_plan OWNER TO %db_owner%;

--
-- TOC entry 222 (class 1259 OID 130456)
-- Name: vw_pub; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_pub AS
SELECT s.dataset_archive_id AS dataset_id, o.network_type AS "network type", replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type", o.is_signature AS "is signature", o.is_core AS "is core", o.is_thesis AS "is thesis", o.is_reference AS "is reference", o.is_exogenous AS "is exogenous", m."Title" AS title, to_char((s.data_receipt_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "data last received", to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "catalog updated", replace(replace((s.status)::text, '_'::text, ' '::text), 'draft'::text, 'revision pending'::text) AS status, s.nickname FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) WHERE ((s.status)::text = ANY (ARRAY[('cataloged'::character varying)::text, ('backlog'::character varying)::text, ('redesign_anticipated'::character varying)::text, ('draft'::character varying)::text])) ORDER BY o.is_signature DESC, o.is_core DESC, o.temporal_type, o.is_thesis, o.is_reference, o.is_exogenous, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_pub OWNER TO %db_owner%;

--
-- TOC entry 223 (class 1259 OID 130461)
-- Name: vw_self; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_self AS
SELECT s.dataset_archive_id AS dataset_id, CASE WHEN ((s.status)::text = 'draft0'::text) THEN 0 ELSE s.rev END AS rev, s.eml_draft_path, s.nickname, s.data_receipt_date AS "data received", replace((s.status)::text, '_'::text, ' '::text) AS status, o.network_type AS "network type", replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type", m."Title" AS title, CASE WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying ELSE s.who2bug END AS "who to bug", s.update_date_catalog AS "catalog last updated", to_date((s.dbupdatetime)::text, 'YYYY-MM-DD'::text) AS "status updated" FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) ORDER BY s.status, s.who2bug, split_part((s.dataset_archive_id)::text, '.'::text, 2);


ALTER TABLE pkg_mgmt.vw_self OWNER TO %db_owner%;

--
-- TOC entry 224 (class 1259 OID 130466)
-- Name: vw_temporal; Type: VIEW; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE VIEW pkg_mgmt.vw_temporal AS
SELECT s.dataset_archive_id AS dataset_id, CASE WHEN ((s.status)::text = 'draft0'::text) THEN 0 ELSE s.rev END AS rev, s.eml_draft_path, s.nickname, to_char((s.data_receipt_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "data received", to_char((s.update_date_catalog)::timestamp with time zone, 'YYYY-MM-DD'::text) AS "catalog updated", to_char((s.dbupdatetime)::timestamp with time zone, 'YYYY-MM-DD'::text) AS db_updated, replace((s.status)::text, '_'::text, ' '::text) AS status, o.network_type AS "network type", replace((o.temporal_type)::text, '_'::text, ' '::text) AS "temporal type", m."Title" AS title, CASE WHEN ((o.temporal_type)::text ~~ 'terminated%'::text) THEN ''::character varying ELSE s.who2bug END AS "who to bug" FROM ((pkg_mgmt.pkg_state s LEFT JOIN lter_metabase."DataSet" m ON (((s."DataSetID")::text = (m."DataSetID")::text))) LEFT JOIN pkg_mgmt.pkg_sort o ON (((s."DataSetID")::text = (o."DataSetID")::text))) ORDER BY s.who2bug, s.dataset_archive_id;


ALTER TABLE pkg_mgmt.vw_temporal OWNER TO %db_owner%;



--
-- TOC entry 2945 (class 2606 OID 130472)
-- Name: DataSet IX_DataSet_Accession; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSet"
    ADD CONSTRAINT "IX_DataSet_Accession" UNIQUE ("Accession");


--
-- TOC entry 2947 (class 2606 OID 130474)
-- Name: DataSet PK_DataSet; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSet"
    ADD CONSTRAINT "PK_DataSet" PRIMARY KEY ("DataSetID");


--
-- TOC entry 2951 (class 2606 OID 130476)
-- Name: DataSetEntities PK_DataSetEntities; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "PK_DataSetEntities" PRIMARY KEY ("DataSetID", "EntityName");


--
-- TOC entry 2949 (class 2606 OID 130478)
-- Name: DataSetAttributes PK_DataSetID_EntitySortOrder_ColumnName; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "PK_DataSetID_EntitySortOrder_ColumnName" PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName");


--
-- TOC entry 2955 (class 2606 OID 130480)
-- Name: DataSetKeywords PK_DataSetKeywords; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "PK_DataSetKeywords" PRIMARY KEY ("Keyword", "DataSetID", "ThesaurusID");


--
-- TOC entry 2959 (class 2606 OID 130482)
-- Name: DataSetPersonnel PK_DataSetPersonnel; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "PK_DataSetPersonnel" PRIMARY KEY ("DataSetID", "NameID");


--
-- TOC entry 2961 (class 2606 OID 130484)
-- Name: DataSetSites PK_DataSetSites; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "PK_DataSetSites" PRIMARY KEY ("DataSetID", "SiteCode");


--
-- TOC entry 2963 (class 2606 OID 130486)
-- Name: DataSetTemporal PK_DataSetTemporal; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTemporal"
    ADD CONSTRAINT "PK_DataSetTemporal" PRIMARY KEY ("DataSetID", "EntitySortOrder", "BeginDate");


--
-- TOC entry 2967 (class 2606 OID 130488)
-- Name: EMLKeywordTypeList PK_EMLKeywordTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLKeywordTypeList"
    ADD CONSTRAINT "PK_EMLKeywordTypeList" PRIMARY KEY ("KeywordType");


--
-- TOC entry 2969 (class 2606 OID 130490)
-- Name: EMLMeasurementScaleList PK_EMLMeasurementScale; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLMeasurementScaleList"
    ADD CONSTRAINT "PK_EMLMeasurementScale" PRIMARY KEY ("measurementScale");


--
-- TOC entry 2971 (class 2606 OID 130492)
-- Name: EMLNumberTypeList PK_EMLNumberType; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLNumberTypeList"
    ADD CONSTRAINT "PK_EMLNumberType" PRIMARY KEY ("NumberType");


--
-- TOC entry 2973 (class 2606 OID 130494)
-- Name: EMLStorageTypeList PK_EML_NumberTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLStorageTypeList"
    ADD CONSTRAINT "PK_EML_NumberTypeList" PRIMARY KEY ("StorageType");


--
-- TOC entry 2975 (class 2606 OID 130496)
-- Name: EMLUnitDictionary PK_EML_UnitDictionary; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitDictionary"
    ADD CONSTRAINT "PK_EML_UnitDictionary" PRIMARY KEY (id);


--
-- TOC entry 2977 (class 2606 OID 130498)
-- Name: EMLUnitTypes PK_EML_UnitTypes; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitTypes"
    ADD CONSTRAINT "PK_EML_UnitTypes" PRIMARY KEY (id);


--
-- TOC entry 2979 (class 2606 OID 130500)
-- Name: FileTypeList PK_FileTypeList; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."FileTypeList"
    ADD CONSTRAINT "PK_FileTypeList" PRIMARY KEY ("FileType");


--
-- TOC entry 2981 (class 2606 OID 130502)
-- Name: KeywordThesaurus PK_KeywordThesaurus; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."KeywordThesaurus"
    ADD CONSTRAINT "PK_KeywordThesaurus" PRIMARY KEY ("ThesaurusID");


--
-- TOC entry 2983 (class 2606 OID 130504)
-- Name: Keywords PK_Keywords; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Keywords"
    ADD CONSTRAINT "PK_Keywords" PRIMARY KEY ("Keyword", "ThesaurusID");


--
-- TOC entry 2957 (class 2606 OID 130506)
-- Name: DataSetMethods PK_MethodID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethods"
    ADD CONSTRAINT "PK_MethodID" PRIMARY KEY ("MethodID");


--
-- TOC entry 2939 (class 2606 OID 130508)
-- Name: People PK_People; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."People"
    ADD CONSTRAINT "PK_People" PRIMARY KEY ("NameID");


--
-- TOC entry 2941 (class 2606 OID 130510)
-- Name: Peopleidentification PK_Peopleidentification; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Peopleidentification"
    ADD CONSTRAINT "PK_Peopleidentification" PRIMARY KEY ("IdentificationID", "NameID");


--
-- TOC entry 2990 (class 2606 OID 130512)
-- Name: SiteList PK_SiteRegister; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."SiteList"
    ADD CONSTRAINT "PK_SiteRegister" PRIMARY KEY ("SiteCode");


--
-- TOC entry 2988 (class 2606 OID 130514)
-- Name: ProtocolList PK_protocolID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ProtocolList"
    ADD CONSTRAINT "PK_protocolID" PRIMARY KEY ("protocolID");


--
-- TOC entry 2943 (class 2606 OID 130516)
-- Name: Peopleidentification Peopleidentification_UQ_NameID_IdentificationID; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Peopleidentification"
    ADD CONSTRAINT "Peopleidentification_UQ_NameID_IdentificationID" UNIQUE ("NameID", "IdentificationID");


--
-- TOC entry 2953 (class 2606 OID 130518)
-- Name: DataSetEntities UQ_DataSet_SortOrder; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "UQ_DataSet_SortOrder" UNIQUE ("DataSetID", "SortOrder");


--
-- TOC entry 2986 (class 2606 OID 130520)
-- Name: MeasurementScaleDomains pk_MeasurementScaleDomains; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."MeasurementScaleDomains"
    ADD CONSTRAINT "pk_MeasurementScaleDomains" PRIMARY KEY ("MeasurementScaleDomainID");


--
-- TOC entry 2965 (class 2606 OID 130522)
-- Name: EMLAttributeCodeDefinition pk_emlattributecodedefinition_pk; Type: CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLAttributeCodeDefinition"
    ADD CONSTRAINT pk_emlattributecodedefinition_pk PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName", code);


--
-- TOC entry 2928 (class 2606 OID 130524)
-- Name: cv_cra cv_cra_pkey; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_cra
    ADD CONSTRAINT cv_cra_pkey PRIMARY KEY (cra_id);


--
-- TOC entry 2992 (class 2606 OID 130526)
-- Name: cv_mgmt_type cv_mgmt_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_mgmt_type
    ADD CONSTRAINT cv_mgmt_type_pk PRIMARY KEY (mgmt_type);


--
-- TOC entry 2994 (class 2606 OID 130528)
-- Name: cv_network_type cv_network_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_network_type
    ADD CONSTRAINT cv_network_type_pk PRIMARY KEY (network_type);


--
-- TOC entry 2996 (class 2606 OID 130530)
-- Name: cv_spatial_extent cv_spatial_extent_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatial_extent
    ADD CONSTRAINT cv_spatial_extent_pk PRIMARY KEY (spatial_extent);


--
-- TOC entry 2998 (class 2606 OID 130532)
-- Name: cv_spatial_type cv_spatial_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatial_type
    ADD CONSTRAINT cv_spatial_type_pk PRIMARY KEY (spatial_type);


--
-- TOC entry 3000 (class 2606 OID 130534)
-- Name: cv_spatio_temporal cv_spatio_temporal_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_spatio_temporal
    ADD CONSTRAINT cv_spatio_temporal_pk PRIMARY KEY (spatiotemporal);


--
-- TOC entry 3002 (class 2606 OID 130536)
-- Name: cv_status cv_status_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_status
    ADD CONSTRAINT cv_status_pk PRIMARY KEY (status);


--
-- TOC entry 3004 (class 2606 OID 130538)
-- Name: cv_temporal_type cv_temporal_type_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.cv_temporal_type
    ADD CONSTRAINT cv_temporal_type_pk PRIMARY KEY (temporal_type);


--
-- TOC entry 2930 (class 2606 OID 130540)
-- Name: pkg_core_area pkg_cra_pkey; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT pkg_cra_pkey PRIMARY KEY ("DataSetID", "Core_area");


--
-- TOC entry 2934 (class 2606 OID 130542)
-- Name: pkg_sort pkg_sort_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_pk PRIMARY KEY ("DataSetID");


--
-- TOC entry 2937 (class 2606 OID 130544)
-- Name: pkg_state pkg_state_pk; Type: CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_state
    ADD CONSTRAINT pkg_state_pk PRIMARY KEY ("DataSetID");


--
-- TOC entry 2984 (class 1259 OID 130545)
-- Name: fki_MeasurementScaleDomains_FK_MeasurementScale; Type: INDEX; Schema: lter_metabase; Owner: %db_owner%
--

CREATE INDEX "fki_MeasurementScaleDomains_FK_MeasurementScale" ON lter_metabase."MeasurementScaleDomains" USING btree ("MeasurementScale");


--
-- TOC entry 2935 (class 1259 OID 130546)
-- Name: fki_pkg_mgmt_fk_cv_status; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_mgmt_fk_cv_status ON pkg_mgmt.pkg_state USING btree (status);


--
-- TOC entry 2931 (class 1259 OID 130547)
-- Name: fki_pkg_sort_fk_network_type; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_sort_fk_network_type ON pkg_mgmt.pkg_sort USING btree (network_type);


--
-- TOC entry 2932 (class 1259 OID 130548)
-- Name: fki_pkg_sort_fk_spatial_extent; Type: INDEX; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE INDEX fki_pkg_sort_fk_spatial_extent ON pkg_mgmt.pkg_sort USING btree (spatial_extent);


--
-- TOC entry 3042 (class 2620 OID 130549)
-- Name: People people_trig_dbupdatetime; Type: TRIGGER; Schema: lter_metabase; Owner: %db_owner%
--

CREATE TRIGGER people_trig_dbupdatetime BEFORE INSERT OR UPDATE ON lter_metabase."People" FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3040 (class 2620 OID 130550)
-- Name: pkg_sort pkg_sort_trig_dbudatetime; Type: TRIGGER; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TRIGGER pkg_sort_trig_dbudatetime BEFORE INSERT OR UPDATE ON pkg_mgmt.pkg_sort FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3041 (class 2620 OID 130551)
-- Name: pkg_state pkg_state_trig_dbudatetime; Type: TRIGGER; Schema: pkg_mgmt; Owner: %db_owner%
--

CREATE TRIGGER pkg_state_trig_dbudatetime BEFORE INSERT OR UPDATE ON pkg_mgmt.pkg_state FOR EACH ROW EXECUTE PROCEDURE pkg_mgmt.update_modified_column();


--
-- TOC entry 3017 (class 2606 OID 130552)
-- Name: DataSetAttributes DataSetAttributes_FK_DataSetID_EntitySortOrder; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_DataSetID_EntitySortOrder" FOREIGN KEY ("DataSetID", "EntitySortOrder") REFERENCES lter_metabase."DataSetEntities"("DataSetID", "SortOrder") ON UPDATE CASCADE;


--
-- TOC entry 3018 (class 2606 OID 130557)
-- Name: DataSetAttributes DataSetAttributes_FK_MeasurementScaleDomainID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_MeasurementScaleDomainID" FOREIGN KEY ("MeasurementScaleDomainID") REFERENCES lter_metabase."MeasurementScaleDomains"("MeasurementScaleDomainID") ON UPDATE CASCADE;


--
-- TOC entry 3019 (class 2606 OID 130562)
-- Name: DataSetAttributes DataSetAttributes_FK_NumberType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_NumberType" FOREIGN KEY ("NumberType") REFERENCES lter_metabase."EMLNumberTypeList"("NumberType") ON UPDATE CASCADE;


--
-- TOC entry 3020 (class 2606 OID 130567)
-- Name: DataSetAttributes DataSetAttributes_FK_StorageType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_StorageType" FOREIGN KEY ("StorageType") REFERENCES lter_metabase."EMLStorageTypeList"("StorageType") ON UPDATE CASCADE;


--
-- TOC entry 3021 (class 2606 OID 130572)
-- Name: DataSetAttributes DataSetAttributes_FK_units; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetAttributes"
    ADD CONSTRAINT "DataSetAttributes_FK_units" FOREIGN KEY ("Unit") REFERENCES lter_metabase."EMLUnitDictionary"(id) ON UPDATE CASCADE;


--
-- TOC entry 3022 (class 2606 OID 130577)
-- Name: DataSetEntities FK_DataSetEntities_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "FK_DataSetEntities_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3023 (class 2606 OID 130582)
-- Name: DataSetEntities FK_DataSetEntities_FileType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetEntities"
    ADD CONSTRAINT "FK_DataSetEntities_FileType" FOREIGN KEY ("FileType") REFERENCES lter_metabase."FileTypeList"("FileType") ON UPDATE CASCADE;


--
-- TOC entry 3030 (class 2606 OID 130587)
-- Name: DataSetSites FK_DataSetExpSites_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "FK_DataSetExpSites_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3024 (class 2606 OID 130592)
-- Name: DataSetKeywords FK_DataSetKeywords_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "FK_DataSetKeywords_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3025 (class 2606 OID 130597)
-- Name: DataSetKeywords FK_DataSetKeywords_Keyword; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetKeywords"
    ADD CONSTRAINT "FK_DataSetKeywords_Keyword" FOREIGN KEY ("Keyword", "ThesaurusID") REFERENCES lter_metabase."Keywords"("Keyword", "ThesaurusID") ON UPDATE CASCADE;


--
-- TOC entry 3026 (class 2606 OID 130602)
-- Name: DataSetMethods FK_DataSetMethod_ProtocolID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethods"
    ADD CONSTRAINT "FK_DataSetMethod_ProtocolID" FOREIGN KEY ("protocolID") REFERENCES lter_metabase."ProtocolList"("protocolID") ON UPDATE CASCADE;


--
-- TOC entry 3027 (class 2606 OID 130607)
-- Name: DataSetMethods FK_DataSetMethods_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetMethods"
    ADD CONSTRAINT "FK_DataSetMethods_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3028 (class 2606 OID 130612)
-- Name: DataSetPersonnel FK_DataSetPersonnel_DataSet; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "FK_DataSetPersonnel_DataSet" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3029 (class 2606 OID 130617)
-- Name: DataSetPersonnel FK_DataSetPersonnel_People; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetPersonnel"
    ADD CONSTRAINT "FK_DataSetPersonnel_People" FOREIGN KEY ("NameID") REFERENCES lter_metabase."People"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3031 (class 2606 OID 130622)
-- Name: DataSetSites FK_DataSetSite_SiteCode; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetSites"
    ADD CONSTRAINT "FK_DataSetSite_SiteCode" FOREIGN KEY ("SiteCode") REFERENCES lter_metabase."SiteList"("SiteCode") ON UPDATE CASCADE;


--
-- TOC entry 3032 (class 2606 OID 130627)
-- Name: DataSetTemporal FK_DataSetTemporal_DataSetID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSetTemporal"
    ADD CONSTRAINT "FK_DataSetTemporal_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet"("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3016 (class 2606 OID 130632)
-- Name: DataSet FK_DataSet_People; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."DataSet"
    ADD CONSTRAINT "FK_DataSet_People" FOREIGN KEY ("Investigator") REFERENCES lter_metabase."People"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3033 (class 2606 OID 130637)
-- Name: EMLAttributeCodeDefinition FK_DataSet_SortOrder_ColumnName; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLAttributeCodeDefinition"
    ADD CONSTRAINT "FK_DataSet_SortOrder_ColumnName" FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnName") REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnName") ON UPDATE CASCADE;


--
-- TOC entry 3038 (class 2606 OID 130642)
-- Name: ProtocolList FK_DataSet_author; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."ProtocolList"
    ADD CONSTRAINT "FK_DataSet_author" FOREIGN KEY (author) REFERENCES lter_metabase."People"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3034 (class 2606 OID 130647)
-- Name: EMLUnitDictionary FK_EMLUnitDictionary_EMLUnitTypes; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."EMLUnitDictionary"
    ADD CONSTRAINT "FK_EMLUnitDictionary_EMLUnitTypes" FOREIGN KEY ("unitType") REFERENCES lter_metabase."EMLUnitTypes"(id) ON UPDATE CASCADE;


--
-- TOC entry 3035 (class 2606 OID 130652)
-- Name: Keywords FK_Keywords_KeywordType; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Keywords"
    ADD CONSTRAINT "FK_Keywords_KeywordType" FOREIGN KEY ("KeywordType") REFERENCES lter_metabase."EMLKeywordTypeList"("KeywordType") ON UPDATE CASCADE;


--
-- TOC entry 3036 (class 2606 OID 130657)
-- Name: Keywords FK_Keywords_ThesaurusID; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Keywords"
    ADD CONSTRAINT "FK_Keywords_ThesaurusID" FOREIGN KEY ("ThesaurusID") REFERENCES lter_metabase."KeywordThesaurus"("ThesaurusID") ON UPDATE CASCADE;


--
-- TOC entry 3015 (class 2606 OID 130662)
-- Name: Peopleidentification FK_Peopleidentification_People; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."Peopleidentification"
    ADD CONSTRAINT "FK_Peopleidentification_People" FOREIGN KEY ("NameID") REFERENCES lter_metabase."People"("NameID") ON UPDATE CASCADE;


--
-- TOC entry 3039 (class 2606 OID 130667)
-- Name: SiteList FK_SiteRegister_unit; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."SiteList"
    ADD CONSTRAINT "FK_SiteRegister_unit" FOREIGN KEY (unit) REFERENCES lter_metabase."EMLUnitDictionary"(id) ON UPDATE CASCADE;


--
-- TOC entry 3037 (class 2606 OID 130672)
-- Name: MeasurementScaleDomains MeasurementScaleDomains_FK_MeasurementScale; Type: FK CONSTRAINT; Schema: lter_metabase; Owner: %db_owner%
--

ALTER TABLE ONLY lter_metabase."MeasurementScaleDomains"
    ADD CONSTRAINT "MeasurementScaleDomains_FK_MeasurementScale" FOREIGN KEY ("MeasurementScale") REFERENCES lter_metabase."EMLMeasurementScaleList"("measurementScale") ON UPDATE CASCADE;


--
-- TOC entry 3005 (class 2606 OID 130677)
-- Name: pkg_core_area FK_cra; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT "FK_cra" FOREIGN KEY ("Core_area") REFERENCES pkg_mgmt.cv_cra(cra_id) ON UPDATE CASCADE;


--
-- TOC entry 3006 (class 2606 OID 130682)
-- Name: pkg_core_area FK_datasetid; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_core_area
    ADD CONSTRAINT "FK_datasetid" FOREIGN KEY ("DataSetID") REFERENCES pkg_mgmt.pkg_state("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3014 (class 2606 OID 130687)
-- Name: pkg_state pkg_mgmt_fk_cv_status; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_state
    ADD CONSTRAINT pkg_mgmt_fk_cv_status FOREIGN KEY (status) REFERENCES pkg_mgmt.cv_status(status) ON UPDATE CASCADE;


--
-- TOC entry 3007 (class 2606 OID 130692)
-- Name: pkg_sort pkg_sort_fk_mgmt_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_mgmt_type FOREIGN KEY (management_type) REFERENCES pkg_mgmt.cv_mgmt_type(mgmt_type) ON UPDATE CASCADE;


--
-- TOC entry 3008 (class 2606 OID 130697)
-- Name: pkg_sort pkg_sort_fk_network_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_network_type FOREIGN KEY (network_type) REFERENCES pkg_mgmt.cv_network_type(network_type) ON UPDATE CASCADE;


--
-- TOC entry 3009 (class 2606 OID 130702)
-- Name: pkg_sort pkg_sort_fk_pkg_state; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_pkg_state FOREIGN KEY ("DataSetID") REFERENCES pkg_mgmt.pkg_state("DataSetID") ON UPDATE CASCADE;


--
-- TOC entry 3010 (class 2606 OID 130707)
-- Name: pkg_sort pkg_sort_fk_spatial_extent; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatial_extent FOREIGN KEY (spatial_extent) REFERENCES pkg_mgmt.cv_spatial_extent(spatial_extent) ON UPDATE CASCADE;


--
-- TOC entry 3011 (class 2606 OID 130712)
-- Name: pkg_sort pkg_sort_fk_spatial_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatial_type FOREIGN KEY (spatial_type) REFERENCES pkg_mgmt.cv_spatial_type(spatial_type) ON UPDATE CASCADE;


--
-- TOC entry 3012 (class 2606 OID 130717)
-- Name: pkg_sort pkg_sort_fk_spatio_temporal; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_spatio_temporal FOREIGN KEY (spatiotemporal) REFERENCES pkg_mgmt.cv_spatio_temporal(spatiotemporal) ON UPDATE CASCADE;


--
-- TOC entry 3013 (class 2606 OID 130722)
-- Name: pkg_sort pkg_sort_fk_temporal_type; Type: FK CONSTRAINT; Schema: pkg_mgmt; Owner: %db_owner%
--

ALTER TABLE ONLY pkg_mgmt.pkg_sort
    ADD CONSTRAINT pkg_sort_fk_temporal_type FOREIGN KEY (temporal_type) REFERENCES pkg_mgmt.cv_temporal_type(temporal_type) ON UPDATE CASCADE;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-10 10:25:18 PST

/* Instructions
 * preconditions
 * 1. before running this script, these roles were established
 * db_owner: CREATE schemas, tables, views, triggers, etc. runs backups, grants priveledges, INSERT, UPDATE, DELETE content
 * read_write_user: (optional) Intermediate priveledges, UPDATE, INSERT content, typicallly with a script (no DELETE)
 * read_only_user: SELECT only, for export 
 * 
 * 2. optional - to use an existing postgres account, edit this file to contain appropriate user names for:
 * db_owner - e.g., if db owner already has an account and wants to use it
 *  */ 


--
-- TOC entry 3209 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA lter_metabase; Type: ACL; Schema: -; Owner: %db_owner%
--

REVOKE ALL ON SCHEMA lter_metabase FROM PUBLIC;
REVOKE ALL ON SCHEMA lter_metabase FROM %db_owner%;
GRANT ALL ON SCHEMA lter_metabase TO %db_owner%;
GRANT USAGE ON SCHEMA lter_metabase TO read_write_user;
GRANT USAGE ON SCHEMA lter_metabase TO read_only_user;


--
-- TOC entry 3210 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA mb2eml_r; Type: ACL; Schema: -; Owner: %db_owner%
--

REVOKE ALL ON SCHEMA mb2eml_r FROM PUBLIC;
REVOKE ALL ON SCHEMA mb2eml_r FROM %db_owner%;
GRANT ALL ON SCHEMA mb2eml_r TO %db_owner%;
GRANT USAGE ON SCHEMA mb2eml_r TO read_write_user;
GRANT USAGE ON SCHEMA mb2eml_r TO read_only_user;


--
-- TOC entry 3211 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA pkg_mgmt; Type: ACL; Schema: -; Owner: %db_owner%
--

REVOKE ALL ON SCHEMA pkg_mgmt FROM PUBLIC;
REVOKE ALL ON SCHEMA pkg_mgmt FROM %db_owner%;
GRANT ALL ON SCHEMA pkg_mgmt TO %db_owner%;
GRANT USAGE ON SCHEMA pkg_mgmt TO read_write_user;
GRANT USAGE ON SCHEMA pkg_mgmt TO read_only_user;


--
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 178
-- Name: TABLE "DataSet"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSet" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSet" FROM %db_owner%;
GRANT ALL ON TABLE lter_metabase."DataSet" TO %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSet" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSet" TO read_only_user;


--
-- TOC entry 3216 (class 0 OID 0)
-- Dependencies: 179
-- Name: TABLE "DataSetAttributes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetAttributes" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetAttributes" FROM %db_owner%;
GRANT ALL ON TABLE lter_metabase."DataSetAttributes" TO %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetAttributes" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetAttributes" TO read_only_user;


--
-- TOC entry 3217 (class 0 OID 0)
-- Dependencies: 180
-- Name: TABLE "DataSetEntities"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetEntities" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetEntities" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetEntities" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetEntities" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetEntities" TO read_only_user;


--
-- TOC entry 3218 (class 0 OID 0)
-- Dependencies: 181
-- Name: TABLE "DataSetKeywords"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetKeywords" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetKeywords" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetKeywords" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetKeywords" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetKeywords" TO read_only_user;


--
-- TOC entry 3219 (class 0 OID 0)
-- Dependencies: 182
-- Name: TABLE "DataSetMethods"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetMethods" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetMethods" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethods" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetMethods" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetMethods" TO read_only_user;


--
-- TOC entry 3220 (class 0 OID 0)
-- Dependencies: 183
-- Name: TABLE "DataSetPersonnel"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetPersonnel" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetPersonnel" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetPersonnel" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetPersonnel" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetPersonnel" TO read_only_user;


--
-- TOC entry 3221 (class 0 OID 0)
-- Dependencies: 184
-- Name: TABLE "DataSetSites"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetSites" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetSites" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetSites" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetSites" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetSites" TO read_only_user;


--
-- TOC entry 3222 (class 0 OID 0)
-- Dependencies: 185
-- Name: TABLE "DataSetTemporal"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."DataSetTemporal" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetTemporal" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetTemporal" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetTemporal" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetTemporal" TO read_only_user;


--
-- TOC entry 3223 (class 0 OID 0)
-- Dependencies: 186
-- Name: TABLE "EMLAttributeCodeDefinition"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLAttributeCodeDefinition" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLAttributeCodeDefinition" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLAttributeCodeDefinition" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLAttributeCodeDefinition" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLAttributeCodeDefinition" TO read_only_user;


--
-- TOC entry 3224 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE "EMLKeywordTypeList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLKeywordTypeList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLKeywordTypeList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLKeywordTypeList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLKeywordTypeList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLKeywordTypeList" TO read_only_user;


--
-- TOC entry 3225 (class 0 OID 0)
-- Dependencies: 188
-- Name: TABLE "EMLMeasurementScaleList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLMeasurementScaleList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLMeasurementScaleList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLMeasurementScaleList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLMeasurementScaleList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLMeasurementScaleList" TO read_only_user;


--
-- TOC entry 3226 (class 0 OID 0)
-- Dependencies: 189
-- Name: TABLE "EMLNumberTypeList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLNumberTypeList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLNumberTypeList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLNumberTypeList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLNumberTypeList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLNumberTypeList" TO read_only_user;


--
-- TOC entry 3228 (class 0 OID 0)
-- Dependencies: 190
-- Name: TABLE "EMLStorageTypeList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLStorageTypeList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLStorageTypeList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLStorageTypeList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLStorageTypeList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLStorageTypeList" TO read_only_user;


--
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 191
-- Name: TABLE "EMLUnitDictionary"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLUnitDictionary" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLUnitDictionary" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLUnitDictionary" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLUnitDictionary" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLUnitDictionary" TO read_only_user;


--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 192
-- Name: TABLE "EMLUnitTypes"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."EMLUnitTypes" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."EMLUnitTypes" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."EMLUnitTypes" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."EMLUnitTypes" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."EMLUnitTypes" TO read_only_user;


--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 193
-- Name: TABLE "FileTypeList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."FileTypeList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."FileTypeList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."FileTypeList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."FileTypeList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."FileTypeList" TO read_only_user;


--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 194
-- Name: TABLE "KeywordThesaurus"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."KeywordThesaurus" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."KeywordThesaurus" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."KeywordThesaurus" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."KeywordThesaurus" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."KeywordThesaurus" TO read_only_user;


--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 195
-- Name: TABLE "Keywords"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."Keywords" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."Keywords" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."Keywords" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."Keywords" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."Keywords" TO read_only_user;


--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE "MeasurementScaleDomains"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."MeasurementScaleDomains" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MeasurementScaleDomains" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MeasurementScaleDomains" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."MeasurementScaleDomains" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."MeasurementScaleDomains" TO read_only_user;


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 176
-- Name: TABLE "People"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."People" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."People" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."People" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."People" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."People" TO read_only_user;


--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 177
-- Name: TABLE "Peopleidentification"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."Peopleidentification" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."Peopleidentification" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."Peopleidentification" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."Peopleidentification" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."Peopleidentification" TO read_only_user;


--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE "ProtocolList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."ProtocolList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ProtocolList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ProtocolList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."ProtocolList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."ProtocolList" TO read_only_user;


--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE "SiteList"; Type: ACL; Schema: lter_metabase; Owner: %db_owner%
--

REVOKE ALL ON TABLE lter_metabase."SiteList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."SiteList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."SiteList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."SiteList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."SiteList" TO read_only_user;


--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE vw_custom_units; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_custom_units FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_custom_units FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_custom_units TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_custom_units TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_custom_units TO %db_owner%;


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE vw_eml_attributecodedefinition; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_attributecodedefinition TO %db_owner%;


--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE vw_eml_attributes; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributes FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_attributes FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_attributes TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_attributes TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_attributes TO %db_owner%;


--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE vw_eml_creator; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_creator FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_creator FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_creator TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_creator TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_creator TO %db_owner%;


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 175
-- Name: TABLE pkg_state; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.pkg_state FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.pkg_state FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_state TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.pkg_state TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.pkg_state TO read_only_user;


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE vw_eml_dataset; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_dataset TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_dataset TO %db_owner%;


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE vw_eml_datasetmethod; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_datasetmethod FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_datasetmethod FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_datasetmethod TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_datasetmethod TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_datasetmethod TO %db_owner%;


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE vw_eml_entities; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_entities FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_entities FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_entities TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_entities TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_entities TO %db_owner%;


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE vw_eml_geographiccoverage; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_geographiccoverage FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_geographiccoverage FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_geographiccoverage TO %db_owner%;


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE vw_eml_keyword; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_keyword FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_keyword FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_keyword TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_keyword TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_keyword TO %db_owner%;


--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE vw_eml_temporalcoverage; Type: ACL; Schema: mb2eml_r; Owner: %db_owner%
--

REVOKE ALL ON TABLE mb2eml_r.vw_eml_temporalcoverage FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_temporalcoverage FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_temporalcoverage TO read_write_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_temporalcoverage TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_temporalcoverage TO read_only_user;


--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 172
-- Name: TABLE cv_cra; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_cra FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_cra FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_cra TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_cra TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_cra TO read_only_user;


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE cv_mgmt_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_mgmt_type FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_mgmt_type FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_mgmt_type TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_mgmt_type TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_mgmt_type TO read_only_user;


--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE cv_network_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_network_type FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_network_type FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_network_type TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_network_type TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_network_type TO read_only_user;


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE cv_spatial_extent; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_spatial_extent FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_spatial_extent FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatial_extent TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_spatial_extent TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatial_extent TO read_only_user;


--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE cv_spatial_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_spatial_type FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_spatial_type FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatial_type TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_spatial_type TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatial_type TO read_only_user;


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE cv_spatio_temporal; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_spatio_temporal FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_spatio_temporal FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_spatio_temporal TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_spatio_temporal TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_spatio_temporal TO read_only_user;


--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE cv_status; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_status FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_status FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_status TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_status TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_status TO read_only_user;


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE cv_temporal_type; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.cv_temporal_type FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_temporal_type FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_temporal_type TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.cv_temporal_type TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.cv_temporal_type TO read_only_user;


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 173
-- Name: TABLE pkg_core_area; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.pkg_core_area FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.pkg_core_area FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_core_area TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.pkg_core_area TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.pkg_core_area TO read_only_user;


--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 174
-- Name: TABLE pkg_sort; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.pkg_sort FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.pkg_sort FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.pkg_sort TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.pkg_sort TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.pkg_sort TO read_only_user;


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE vw_backlog; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_backlog FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_backlog FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_backlog TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_backlog TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_backlog TO read_only_user;


--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE vw_cataloged; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_cataloged FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_cataloged FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_cataloged TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_cataloged TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_cataloged TO read_only_user;


--
-- TOC entry 3285 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE vw_draft_anticipated; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_draft_anticipated FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_draft_anticipated FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_draft_anticipated TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_draft_anticipated TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_draft_anticipated TO read_only_user;


--
-- TOC entry 3286 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE vw_drafts_bak; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_drafts_bak FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_drafts_bak FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_drafts_bak TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_drafts_bak TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_drafts_bak TO read_only_user;


--
-- TOC entry 3287 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE vw_im_plan; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_im_plan FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_im_plan FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_im_plan TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_im_plan TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_im_plan TO read_only_user;


--
-- TOC entry 3288 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE vw_pub; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_pub FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_pub FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_pub TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_pub TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_pub TO read_only_user;


--
-- TOC entry 3289 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE vw_self; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_self FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_self FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_self TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_self TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_self TO read_only_user;


--
-- TOC entry 3290 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE vw_temporal; Type: ACL; Schema: pkg_mgmt; Owner: %db_owner%
--

REVOKE ALL ON TABLE pkg_mgmt.vw_temporal FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.vw_temporal FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.vw_temporal TO read_write_user;
GRANT ALL ON TABLE pkg_mgmt.vw_temporal TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.vw_temporal TO read_only_user;


-- Completed on 2018-11-10 10:25:19 PST

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-10 10:25:18 PST


--
-- TOC entry 3174 (class 0 OID 130221)
-- Dependencies: 178
-- Data for Name: DataSet; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3175 (class 0 OID 130230)
-- Dependencies: 179
-- Data for Name: DataSetAttributes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--



--
-- TOC entry 3176 (class 0 OID 130243)
-- Dependencies: 180
-- Data for Name: DataSetEntities; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3177 (class 0 OID 130249)
-- Dependencies: 181
-- Data for Name: DataSetKeywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3178 (class 0 OID 130256)
-- Dependencies: 182
-- Data for Name: DataSetMethods; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3179 (class 0 OID 130262)
-- Dependencies: 183
-- Data for Name: DataSetPersonnel; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3180 (class 0 OID 130265)
-- Dependencies: 184
-- Data for Name: DataSetSites; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--



--
-- TOC entry 3181 (class 0 OID 130269)
-- Dependencies: 185
-- Data for Name: DataSetTemporal; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3182 (class 0 OID 130272)
-- Dependencies: 186
-- Data for Name: EMLAttributeCodeDefinition; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3183 (class 0 OID 130278)
-- Dependencies: 187
-- Data for Name: EMLKeywordTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLKeywordTypeList" ("KeywordType", "TypeDefinition") FROM stdin;
place	\N
theme	\N
taxonomic	\N
stratum	\N
temporal	\N
\.


--
-- TOC entry 3184 (class 0 OID 130284)
-- Dependencies: 188
-- Data for Name: EMLMeasurementScaleList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLMeasurementScaleList" ("measurementScale") FROM stdin;
dateTime
interval
nominal
ordinal
ratio
\.


--
-- TOC entry 3185 (class 0 OID 130287)
-- Dependencies: 189
-- Data for Name: EMLNumberTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLNumberTypeList" ("NumberType") FROM stdin;
integer
natural
real
whole
\.


--
-- TOC entry 3186 (class 0 OID 130290)
-- Dependencies: 190
-- Data for Name: EMLStorageTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLStorageTypeList" ("StorageType", "typeSystem") FROM stdin;
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
-- TOC entry 3188 (class 0 OID 130300)
-- Dependencies: 192
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
-- TOC entry 3187 (class 0 OID 130293)
-- Dependencies: 191
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
-- TOC entry 3189 (class 0 OID 130303)
-- Dependencies: 193
-- Data for Name: FileTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."FileTypeList" ("FileType", "TypeName", "FileFormat", "Extension", "Description", "Delimiters", "Header", "EML_FormatType", "RecordDelimiter", "NumHeaderLines", "NumFooterLines", "AttributeOrientation", "QuoteCharacter", "FieldDelimiter", "CharacterEncoding", "CollapseDelimiters", "LiteralCharacter", "externallyDefinedFormat_formatName", "externallyDefinedFormat_formatVersion") FROM stdin;
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
-- TOC entry 3190 (class 0 OID 130311)
-- Dependencies: 194
-- Data for Name: KeywordThesaurus; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."KeywordThesaurus" ("ThesaurusID", "ThesaurusLabel", "ThesaurusUrl", "UseInMetadata", "ThesaurusSortOrder") FROM stdin;
dwc	Darwin Core Terms	\N	t	100
ea	Ecological Archives	\N	t	90
ebv	Essential Biodiversity Variables	\N	t	80
gcmd6	Global Change Master Directory (GCMD) v6.0.0.0.0	\N	t	50
knb	Knowledge Network for Biocomplexity	\N	t	60
nbii	NBII Biocomplexity	\N	t	80
none	\N	\N	t	110
lter_cv	LTER Controlled Vocabulary v1	\N	t	20
lter_cv_cra	LTER Core Research Areas	\N	t	10
\.


/* 
 * removed
 * sbclter	SBC-LTER Controlled Vocabulary	\N	t	30
 * sbclter_place	Santa Barbara Coastal LTER Places	\N	t	40
 * 
 */
--
-- TOC entry 3191 (class 0 OID 130318)
-- Dependencies: 195
-- Data for Name: Keywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."Keywords" ("Keyword", "ThesaurusID", "KeywordType") FROM stdin;
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
\.


--
-- TOC entry 3192 (class 0 OID 130322)
-- Dependencies: 196
-- Data for Name: MeasurementScaleDomains; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."MeasurementScaleDomains" ("EMLDomainType", "MeasurementScale", "NonNumericDomain", "MeasurementScaleDomainID") FROM stdin;
dateTimeDomain	dateTime		dateTime
numericDomain	interval		interval
nonNumericDomain	nominal	enumeratedDomain	nominalEnum
nonNumericDomain	nominal	textDomain	nominalText
nonNumericDomain	ordinal	enumeratedDomain	ordinalEnum
nonNumericDomain	ordinal	textDomain	ordinalText
numericDomain	ratio		ratio
\.


--
-- TOC entry 3172 (class 0 OID 130212)
-- Dependencies: 176
-- Data for Name: People; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3173 (class 0 OID 130218)
-- Dependencies: 177
-- Data for Name: Peopleidentification; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3193 (class 0 OID 130325)
-- Dependencies: 197
-- Data for Name: ProtocolList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3194 (class 0 OID 130331)
-- Dependencies: 198
-- Data for Name: SiteList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3168 (class 0 OID 130196)
-- Dependencies: 172
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
-- TOC entry 3195 (class 0 OID 130387)
-- Dependencies: 209
-- Data for Name: cv_mgmt_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_mgmt_type (mgmt_type, definition) FROM stdin;
templated	\N
non_templated	\N
\.


--
-- TOC entry 3196 (class 0 OID 130393)
-- Dependencies: 210
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
-- TOC entry 3197 (class 0 OID 130399)
-- Dependencies: 211
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
-- TOC entry 3198 (class 0 OID 130405)
-- Dependencies: 212
-- Data for Name: cv_spatial_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatial_type (spatial_type, definition) FROM stdin;
multi_site	more than one location within the LTER site
non_spatial	there is no spatial component to this dataset
one_place_of_a_site_series	one place of a series of places
one_site_of_one	one site and not part of a series of sites
\.


--
-- TOC entry 3199 (class 0 OID 130411)
-- Dependencies: 213
-- Data for Name: cv_spatio_temporal; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatio_temporal (spatiotemporal, definition) FROM stdin;
csct	continuous spatial continuous temporal
csdt	continuous spatial discrete temporal
dsct	discrete spatial continuous temporal
dsdt	discrete spatial discrete temporal
\.


--
-- TOC entry 3200 (class 0 OID 130417)
-- Dependencies: 214
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
-- TOC entry 3201 (class 0 OID 130420)
-- Dependencies: 215
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
-- TOC entry 3169 (class 0 OID 130199)
-- Dependencies: 173
-- Data for Name: pkg_core_area; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--


--
-- TOC entry 3170 (class 0 OID 130202)
-- Dependencies: 174
-- Data for Name: pkg_sort; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

--
-- TOC entry 3171 (class 0 OID 130206)
-- Dependencies: 175
-- Data for Name: pkg_state; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-10 10:25:18 PST


--
-- TOC entry 3172 (class 0 OID 130212)
-- Dependencies: 176
-- Data for Name: People; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."People" ("NameID", "Honorific", "GivenName", "MiddleName", "SurName", "FriendlyName", "Organization", "Address1", "Address2", "Address3", "City", "State", "Country", "ZipCode", "Email", "WebPage", "Phone1", "Phone2", "FAX", dbupdatetime) FROM stdin;
dreed	\N	Daniel	C	Reed	Dan Reed	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	dan.reed@lifesci.ucsb.edu	http://sbc.lternet.edu/people/danreed/	805-893-8363	\N	805-893-8062	2011-10-10 17:18:08
sharrer	\N	Shannon	\N	Harrer	Shannon Harrer	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	harrer@msi.ucsb.edu	\N	805-893-7295	\N	\N	\N
kcavanaugh	\N	Kyle	C	Cavanaugh	Kyle Cavanaugh	\N	Department of Geography	University of California	\N	Los Angeles	CA	US	90095	kcavanaugh@geog.ucla.edu	\N	\N	\N	\N	2015-01-07 15:27:47
mobrien	\N	Margaret	C	O'Brien	Margaret O'Brien	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	margaret.obrien@ucsb.edu	\N	805-893-2071	\N	\N	2014-08-20 11:13:13
karkema	\N	Katie	\N	Arkema	Katie Arkema	\N	UCSB	\N	\N	\N	\N	\N	\N	karkema@stanford.edu	\N	\N	\N	\N	2015-10-05 09:39:57
mbrzezinski	\N	Mark	Allen	Brzezinski	Mark Brzezinski	\N	Department of Ecology, Evolution and Marine Biology	University of California	\N	Santa Barbara	CA	US	93106-9620	brzezins@lifesci.ucsb.edu	http://www.lifesci.ucsb.edu/eemb/faculty/brzezinski/	805-893-8605	\N	805-893-8062	2011-09-16 13:52:54
sbclter	\N				\N	Santa Barbara Coastal LTER	Marine Science Institute	University of California	\N	Santa Barbara	CA	USA	93106	sbclter@msi.ucsb.edu	http://sbc.lternet.edu	\N	\N	\N	2013-09-10 08:59:52
dsiegel	Dr	David	A	Siegel	Dave Siegel	\N	Earth Research Institute	University of California	\N	Santa Barbara	CA	US	93106-3060	davey@eri.ucsb.edu	http://www.icess.ucsb.edu/~davey/	805-893-4547	805-893-2578	\N	2015-08-22 15:30:31
arassweiler	\N	Andrew	A	Rassweiler	Andy Rassweiler	\N	Marine Science Institute	University of California	\N	Santa Barbara	CA	US	93106-6150	andrew.rassweiler@lifesci.ucsb.edu	\N	805-893-7823	\N	\N	2015-08-22 15:23:35
\.


--
-- TOC entry 3173 (class 0 OID 130218)
-- Dependencies: 177
-- Data for Name: Peopleidentification; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."Peopleidentification" ("NameID", "IdentificationID", "Identificationtype", "Identificationlink") FROM stdin;
dreed	1	ORCID	0000-0003-3015-8717
dsiegel	1	ORCID	0000-0003-1674-3055
mbrzezinski	1	ORCID	0000-0003-3432-2297
kcavanaugh	1	ORCID	0000-0002-3313-0878
arassweiler	1	ORCID	0000-0002-8760-3888
mobrien	1	ORCID	0000-0002-1693-8322
\.


--
-- TOC entry 3193 (class 0 OID 130325)
-- Dependencies: 197
-- Data for Name: ProtocolList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."ProtocolList" ("protocolID", author, title, url) FROM stdin;
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
-- TOC entry 3194 (class 0 OID 130331)
-- Dependencies: 198
-- Data for Name: SiteList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."SiteList" ("SiteCode", "SiteType", "SiteName", "SiteLocation", "SiteDesc", "Ownership", "ShapeType", "CenterLon", "CenterLat", "WBoundLon", "EBoundLon", "SBoundLat", "NBoundLat", "AltitudeMin", "AltitudeMax", unit) FROM stdin;
046161	other	NEWHALL 5 NW	California, USA	NEWHALL 5 NW	National Weather Service - COOP	point	-118.6	34.4	-118.6	-118.6	34.4	34.4	538	538	meter
046162	other	NEWHALL S FC32CE	California, USA	NEWHALL S FC32CE	National Weather Service - COOP	point	-118.533333	34.383333	-118.533333	-118.533333	34.383333	34.383333	378.9	378.9	meter
046399	other	OJAI	California, USA	OJAI	National Weather Service - COOP	point	-119.25	34.466667	-119.25	-119.25	34.466667	34.466667	216.4	216.4	meter
046569	other	OXNARD	California, USA	OXNARD	National Weather Service - COOP	point	-119.183333	34.2	-119.183333	-119.183333	34.2	34.2	14.9	14.9	meter
046572	other	OXNARD WSFO	California, USA	OXNARD WSFO	National Weather Service - COOP	point	-119.133333	34.216667	-119.133333	-119.133333	34.216667	34.216667	19.2	19.2	meter
046940	other	PIRU 2 ESE	California, USA	PIRU 2 ESE	National Weather Service - COOP	point	-118.75	34.4	-118.75	-118.75	34.4	34.4	222.5	222.5	meter
047735	other	SANDBERG	California, USA	SANDBERG	National Weather Service - COOP	point	-118.716667	34.75	-118.716667	-118.716667	34.75	34.75	1374.6	1374.6	meter
047902	other	SANTA BARBARA	California, USA	SANTA BARBARA	National Weather Service - COOP	point	-119.683333	34.416667	-119.683333	-119.683333	34.416667	34.416667	1.5	1.5	meter
047904	other	Univ. of California - Santa Barbara (Coal Oil Point Reserve)	California, USA	Univ. of California - Santa Barbara (Coal Oil Point Reserve)	National Weather Service - COOP	point	-119.8796	34.41406	-119.8796	-119.8796	34.41406	34.41406	15	15	meter
047905	other	SANTA BARBARA MUNICIPAL AP	California, USA	SANTA BARBARA MUNICIPAL AP	National Weather Service - COOP	point	-119.85	34.433333	-119.85	-119.85	34.433333	34.433333	2.7	2.7	meter
047957	other	SANTA PAULA	California, USA	SANTA PAULA	National Weather Service - COOP	point	-119.133333	34.316667	-119.133333	-119.133333	34.316667	34.316667	72.2	72.2	meter
048014	other	SAUGUS POWER PLANT 1	California, USA	SAUGUS POWER PLANT 1	National Weather Service - COOP	point	-118.45	34.583333	-118.45	-118.45	34.583333	34.583333	641.6	641.6	meter
049285	other	VENTURA	California, USA	VENTURA	National Weather Service - COOP	point	-119.3	34.283333	-119.3	-119.3	34.283333	34.283333	32	32	meter
AB	other	Arroyo Burro	California, USA	Arroyo Burro	SBC	point	-119.74438	34.40017	-119.74438	-119.74438	34.40017	34.40017	\N	\N	\N
ABB	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.74375	34.40305	-119.74375	-119.74375	34.40305	34.40305	\N	\N	\N
ABBA	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.74375	34.40305	-119.74375	-119.74375	34.40305	34.40305	\N	\N	\N
ABUR	other	ABUR	California, USA	Arroyo Burro Reef is located on the Santa Barbara Channel\r\n  near the mouth of Arroyo Burro Creek and Beach. Depth ranges from 5.4 to 7 meters.	\N	point	-119.7445915	34.400275	-119.7445915	-119.7445915	34.400275	34.400275	\N	\N	\N
ABUR1	other	ABUR1	California, USA	Arroyo Burro Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 305 (degree). Transect begins directly offshore of the Arroyo Burro creek mouth. Bedrock and sand substrate has little relief (0-0.5 m). Depth approximately 24-27â. This transect often becomes inundated with sand.	\N	point	-119.744383	34.400117	-119.744383	-119.744383	34.400117	34.400117	-7.62	-7.62	meter
ABUR_1km_box	reef	Arroyo Burro Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.74333	34.46973	-119.74917	-119.7375	34.3895	34.4038	\N	\N	\N
ABUR2	other	ABUR2	California, USA	Arroyo Burro Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 320 (degree). Transect consists of low bedrock ridges (0-0.5m) with areas of sand. The first half of the transect is in deeper sand and the second half runs along a ridge covered in shallow sand. Depth is approximately 22'.	\N	point	-119.7448	34.400433	-119.7448	-119.7448	34.400433	34.400433	-6.71	-6.71	meter
ABUR_reef	reef	Arroyo Burro reef	California, USA	Arroyo Burro Reef is located on the Santa Barbara Channel near the mouth of Arroyo Burro Creek and Beach. Depth ranges from 5.4 to 7 meters.	\N	polygon	-119.822502	34.4138298	-119.822502	-119.822502	34.4138298	34.4138298	\N	\N	\N
AHND	other	AHND	California, USA	Arroyo Hondo Reef is located on the Santa Barbara Channel near the east end of Gaviota State Park, CA. Depth ranges from -4.3m to -6.6 meters.	\N	point	-120.1426165	34.471817	-120.1426165	-120.1426165	34.471817	34.471817	\N	\N	\N
AHND1	other	AHND1	California, USA	Arroyo Hondo Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 105 (degree). From 2003-present this transect has been ~0.5m deep sand, with no exposed reef, but Diopatra beds with epiphytic algae are present . Depth slopes from approximately 16â at the 0 m bolt to 24â at the 40 m bolt.	\N	point	-120.144383	34.471867	-120.144383	-120.144383	34.471867	34.471867	-6.1	-6.1	meter
AHND_1km_box	reef	Arroyo Hondo Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.14333	34.46973	-120.14917	-120.1375	34.4624	34.473	\N	\N	\N
AHND2	other	AHND2	California, USA	Arroyo Hondo Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). This transect is in a boulder field with some relief (0-0.75m) and patchy sand with Diopatra beds. Depth is approximately 25'.	\N	point	-120.14085	34.471767	-120.14085	-120.14085	34.471767	34.471767	-7.62	-7.62	meter
AHND_to_AQUE	reef	Arroyo Hondo to Arroyo Quemado	California, USA	Area between the reefs Arroyo Hondo (AHND) and  Arroyo Quemado (AQUE)	\N	point	-120.135	34.46973	-120.135	-120.135	34.46973	34.46973	\N	\N	\N
AHND_to_AQUE_1km_box	reef	Arroyo Hondo-to-Arroyo Quemado lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.135	34.46973	-120.1375	-120.1325	34.4621	34.473	\N	\N	\N
AHON_reef	reef	Arroyo Hondo Reef	California, USA	Arroyo Hondo Reef is located on the Santa Barbara Channel near the east end of Gaviota State Park, CA. Depth ranges from -4.3m to -6.6 meters. 	\N	polygon	-120.144402	34.4724007	-120.144402	-120.144402	34.4724007	34.4724007	\N	\N	\N
ABUR_ws	land	Arroyo Burro watershed	California, USA	Arroyo Burro watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
ALC	other	Anacapa Island Landing Cove Pier (ALC)	California, USA	North shore of Anacapa Island, Santa Barbara Channel Islands, California.	\N	point	-119.3621	34.0164	-119.3621	-119.3621	34.0164	34.0164	\N	\N	\N
ALE	other	ALE	California, USA	Alegria (ALE) is located offshore from the community of Hollister Ranch, between Gaviota and Pt. Conception. Depth: 15 meters.	\N	point	-120.28998	34.46085	-120.28998	-120.28998	34.46085	34.46085	-16.5	0	meter
ALE_nearsh	nearshore	Alegria nearshore ocean	California, USA	Nearshore ocean area near the community of Hollister Ranch, between Gaviota and Pt. Conception. Depth: 15 meters.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
anacapa	other	Anacapa Island CA	California, USA	Anacapa Island CA	\N	point	-119.362097	34.01681	-119.362097	-119.362097	34.01681	34.01681	\N	\N	\N
ANA_nearsh	nearshore	Anacapa Island, northeast 	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQB	other	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	point	-120.118617	34.470467	-120.118617	-120.118617	34.470467	34.470467	\N	\N	\N
AQBA	other	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	point	-120.118617	34.470467	-120.118617	-120.118617	34.470467	34.470467	\N	\N	\N
AQM	other	station AQM on Arroyo Quemado Reef, Santa Barbara Channel	California, USA	station AQM on Arroyo Quemado Reef, Santa Barbara Channel	\N	point	-120.12005	34.46672	-120.12005	-120.12005	34.46672	34.46672	-11.7	0	meter
AQUE	other	AQUE	California, USA	Arroyo Quemado Reef: Arroyo Quemado Reef depth range from 5.4m to 10.7m. There are 7 permanent transects: Transect I --- Transect VII. Reference on Land is close to US101/Arroyo Quemada Ln.	\N	point	-120.11905	34.46774988	-120.11905	-120.11905	34.46774988	34.46774988	\N	\N	\N
AQUE1	other	AQUE1	California, USA	Arroyo Quemado Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins west of the river mouth, on the backside of one of the larger ridges (1m). Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 24'.	\N	point	-120.121417	34.468783	-120.121417	-120.121417	34.468783	34.468783	-7.32	-7.32	meter
AQUE_1km_box	reef	Arroyo Quemado Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-120.12333	34.46973	-120.1325	-120.11417	34.4579	34.4721	\N	\N	\N
AQUE2	other	AQUE2	California, USA	Arroyo Quemado Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect transverses slightly southeast across the prominent east/west ridges. Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 24'.	\N	point	-120.120783	34.468733	-120.120783	-120.120783	34.468733	34.468733	-7.32	-7.32	meter
AQUE3	other	AQUE3	California, USA	Arroyo Quemado Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 113 (degree). Transect begins at the western edge of the hard substrate, nearly directly offshore of the river mouth (~200 m). Silt covered bedrock and small boulder substrate with little relief (0-0.5 m), some moderate sized areas of deep sand present along with Pterygophora and Diopatra beds. Depth is approximately 30'.	\N	point	-120.119283	34.467933	-120.119283	-120.119283	34.467933	34.467933	-9.14	-9.14	meter
AQUE4	other	AQUE4	California, USA	Arroyo Quemado Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins east of the river mouth. Bedrock with several large boulder outcrops creating some significant relief (0-2.5 m) along transect. Some moderate sized areas of sand (1-5 m). Depth is approximately 23 feet.	\N	point	-120.117183	34.467467	-120.117183	-120.117183	34.467467	34.467467	-7.01	-7.01	meter
AQUE5	other	AQUE5	California, USA	Arroyo Quemado Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 95 (degree). Bedrock substrate, some moderate relief (0-1.5 m), one small overhanging ridge with sand channels and Diopatra beds. Depth is approximately 33 feet.	\N	point	-120.11735	34.46685	-120.11735	-120.11735	34.46685	34.46685	-10.06	-10.06	meter
AQUE6	other	AQUE6	California, USA	Arroyo Quemado Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins slightly west of the river mouth. Sand (1-3cm deep) and bedrock substrate with low relief (0-0.5m). Depth is approximately 33 feet.	\N	point	-120.12085	34.46755	-120.12085	-120.12085	34.46755	34.46755	-10.06	-10.06	meter
AQUE7	other	AQUE7	California, USA	Arroyo Quemado Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 95 (degree). Transect begins east of the river mouth. Bedrock with several large boulder outcrops creating some significant relief (0-2.5 m) along transect. Some moderate sized areas of sand (1-3 m) present along with Diopatra beds. Depth is approximately 25 feet.	\N	point	-120.117783	34.4674	-120.117783	-120.117783	34.4674	34.4674	-7.62	-7.62	meter
AQUE8	other	AQUE8	California, USA	Arroyo Quemado Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Substrate is mostly bedrock with several large boulder outcrops. Some moderate sized areas of sand present. Depth is approximately 30â. Kelp is continually cleared in 2m band on all sides of this transect.	\N	point	-120.117783	34.467283	-120.117783	-120.117783	34.467283	34.467283	-9.1	-9.1	meter
AQUE_reef	reef	Arroyo Quemado Reef	California, USA	Arroyo Quemado Reef is located on the Santa Barbara Channel near the mouth of Arroyo Quemada Creek, Santa Barbara County, CA. Depth ranges from -5.4 to -10.7 meters.	\N	polygon	-120.121498	34.4688301	-120.121498	-120.121498	34.4688301	34.4688301	\N	\N	\N
ARB	other	near Arroyo Burro Beach, instruments removed may 2005, weight and small float remain	California, USA	near Arroyo Burro Beach, instruments removed may 2005, weight and small float remain	\N	point	-119.74447	34.39958	-119.74447	-119.74447	34.39958	34.39958	-7.9	0	meter
ARQ	other	ARQ	California, USA	Arroyo Quemado Reef (ARQ) is located 0.16km from river mouth; estimated depth is 35 feet. This site (ARQ) is about 200m to the SE of a previously sampled site, AQM.	\N	point	-120.11965	34.46495	-120.11965	-120.11965	34.46495	34.46495	\N	\N	\N
Arroyo Burro Beach	other	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	point	-119.74375	34.40305	-119.74375	-119.74375	34.40305	34.40305	\N	\N	\N
AHON_ws	land	Arroyo Hondo watershed	California, USA	Arroyo Hondo watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQUE_beach	beach	Arroyo Quemado Beach	California, USA	Arroyo Quemado Beach	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AQUE_ws	land	Arroyo Quemado watershed	California, USA	Arroyo Quemado watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
AT07	other	Atascadero Creek at Puente Street	California, USA	Atascadero Creek, Atascadero at Puente	\N	point	-119.78414	34.43226	-119.78414	-119.78414	34.43226	34.43226	\N	\N	\N
B0064	other	CDIP Modeled output site B0064	California, USA	CDIP Modeled output site: B0064. Nearest to SBC LTER site(s): CARP5 CARP8	\N	point	-119.5383	34.3895	-119.5383	-119.5383	34.3895	34.3895	\N	\N	\N
B0065	other	CDIP Modeled output site B0065	California, USA	CDIP Modeled output site: B0065. Nearest to SBC LTER site(s): CARP1 CARP10 CARP2 CARP3 CARP4 CARP6 CARP7 CARP9	\N	point	-119.5431	34.3901	-119.5431	-119.5431	34.3901	34.3901	\N	\N	\N
B0263	other	CDIP Modeled output site B0263	California, USA	CDIP Modeled output site: B0263. Nearest to SBC LTER site(s): MOHK2 MOHK3 MOHK4	\N	point	-119.729	34.3935	-119.729	-119.729	34.3935	34.3935	\N	\N	\N
B0264	other	CDIP Modeled output site B0264	California, USA	CDIP Modeled output site: B0264. Nearest to SBC LTER site(s): MOHK1	\N	point	-119.7303	34.394	-119.7303	-119.7303	34.394	34.394	\N	\N	\N
B0278	other	CDIP Modeled output site B0278	California, USA	CDIP Modeled output site: B0278. Nearest to SBC LTER site(s): ABUR1	\N	point	-119.7441	34.3996	-119.7441	-119.7441	34.3996	34.3996	\N	\N	\N
B0279	other	CDIP Modeled output site B0279	California, USA	CDIP Modeled output site: B0279. Nearest to SBC LTER site(s): ABUR2	\N	point	-119.745	34.3997	-119.745	-119.745	34.3997	34.3997	\N	\N	\N
B0354	other	CDIP Modeled output site B0354	California, USA	CDIP Modeled output site: B0354. Nearest to SBC LTER site(s): GOLB1 GOLB2	\N	point	-119.8204	34.4099	-119.8204	-119.8204	34.4099	34.4099	\N	\N	\N
B0394	other	CDIP Modeled output site B0394	California, USA	CDIP Modeled output site: B0394. Nearest to SBC LTER site(s): IVEE1 IVEE2	\N	point	-119.857	34.4022	-119.857	-119.857	34.4022	34.4022	\N	\N	\N
B0492	other	CDIP Modeled output site B0492	California, USA	CDIP Modeled output site: B0492. Nearest to SBC LTER site(s): NAPL1 NAPL2 NAPL3 NAPL4 NAPL5 NAPL6 NAPL7 NAPL8 NAPL9	\N	point	-119.9488	34.431	-119.9488	-119.9488	34.431	34.431	\N	\N	\N
B0494	other	CDIP Modeled output site B0494	California, USA	CDIP Modeled output site: B0494. Nearest to SBC LTER site(s): NAPL10	\N	point	-119.952	34.4316	-119.952	-119.952	34.4316	34.4316	\N	\N	\N
B0662	other	CDIP Modeled output site B0662	California, USA	CDIP Modeled output site: B0662. Nearest to SBC LTER site(s): AQUE4 AQUE5 AQUE7 AQUE8	\N	point	-120.1174	34.4671	-120.1174	-120.1174	34.4671	34.4671	\N	\N	\N
B0664	other	CDIP Modeled output site B0664	California, USA	CDIP Modeled output site: B0664. Nearest to SBC LTER site(s): AQUE3	\N	point	-120.1196	34.4673	-120.1196	-120.1196	34.4673	34.4673	\N	\N	\N
B0665	other	CDIP Modeled output site B0665	California, USA	CDIP Modeled output site: B0665. Nearest to SBC LTER site(s): AQUE6	\N	point	-120.1205	34.4678	-120.1205	-120.1205	34.4678	34.4678	\N	\N	\N
B0666	other	CDIP Modeled output site B0666	California, USA	CDIP Modeled output site: B0666. Nearest to SBC LTER site(s): AQUE1 AQUE2	\N	point	-120.1214	34.4681	-120.1214	-120.1214	34.4681	34.4681	\N	\N	\N
B0685	other	CDIP Modeled output site B0685	California, USA	CDIP Modeled output site: B0685. Nearest to SBC LTER site(s): AHND2	\N	point	-120.1409	34.4706	-120.1409	-120.1409	34.4706	34.4706	\N	\N	\N
B0688	other	CDIP Modeled output site B0688	California, USA	CDIP Modeled output site: B0688. Nearest to SBC LTER site(s): AHND1	\N	point	-120.1439	34.4709	-120.1439	-120.1439	34.4709	34.4709	\N	\N	\N
B0871	other	CDIP Modeled output site B0871	California, USA	CDIP Modeled output site: B0871. Nearest to SBC LTER site(s): BULL1 BULL3 BULL6	\N	point	-120.3319	34.4562	-120.3319	-120.3319	34.4562	34.4562	\N	\N	\N
BaronRanch262	other	Baron Ranch	California, USA	Baron Ranch	\N	point	-120.1291667	34.48333333	-120.1291667	-120.1291667	34.48333333	34.48333333	\N	\N	\N
bc_1	other	BC 1	California, USA	The BC reef is the west side of Platt's Harbor. BC 1 is SE of the main point.	\N	point	-119.7414167	34.05076667	-119.7414167	-119.7414167	34.05076667	34.05076667	-30	-30	Foot_US
bc_2	other	BC 2	California, USA	The BC reef is the west side of Platt's Harbor. BC 2 is NW of the main point.	\N	point	-119.7418167	34.05116667	-119.7418167	-119.7418167	34.05116667	34.05116667	-30	-30	Foot_US
bc_point	other	BC Point	California, USA	The BC reef is the west side of Platt's Harbor. BC Point is  off a small outcrop.	\N	point	-119.7406333	34.05035	-119.7406333	-119.7406333	34.05035	34.05035	-30	-30	Foot_US
BI	other	Bulito Inshore	California, USA	Bulito Inshore	\N	point	-120.3334	34.4589	-120.3334	-120.3334	34.4589	34.4589	\N	\N	\N
BO	other	Bulito Offshore	California, USA	Bulito Offshore	\N	point	-120.3336	34.4582	-120.3336	-120.3336	34.4582	34.4582	\N	\N	\N
BR	other	Bulito Reef	California, USA	Bulito Reef	\N	point	-120.3335	34.4585	-120.3335	-120.3335	34.4585	34.4585	\N	\N	\N
BULL	other	BULL	California, USA	Builto: Bulito has three permanent transect: Transect I, III, VI. Depth Range from -5.5 to -7.3. Reference on land is close to Ranch Real road and Hollister Ranch road crossing section.	\N	point	-120.33349	34.45850533	-120.33349	-120.33349	34.45850533	34.45850533	\N	\N	\N
BULL1	other	BULL1	California, USA	Bulito Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Transect is closest to the river mouth, bedrock and shale substrate with some slight relief (0-1 m) and thick understory algal cover.	\N	point	-120.333433	34.458883	-120.333433	-120.333433	34.458883	34.458883	-5.49	-5.49	meter
BULL3	other	BULL3	California, USA	Bulito Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Bedrock and shale substrate with some sandy areas and slight relief (0-1 m). Thick Pterygophora beds typically present. Depth is approximately 20 feet.	\N	point	-120.333483	34.458483	-120.333483	-120.333483	34.458483	34.458483	-6.1	-6.1	meter
BULL6	other	BULL6	California, USA	Bulito Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock and shale substrate with some sandy areas and slight relief (0-1m). Depth is approximately 24 feet.	\N	point	-120.33355	34.45815	-120.33355	-120.33355	34.45815	34.45815	-7.32	-7.32	meter
BULL_reef	reef	Bulito Reef	California, USA	Bulito Reef is located on the Santa Barbara Channel between Gaviota and Pt. Conception, CA. Depth ranges from -5.5 to -7.3 meters.	\N	polygon	-120.333603	34.4561996	-120.333603	-120.333603	34.4561996	34.4561996	\N	\N	\N
CP201	other	Carpinteria Creek at Veddar's Ranch	California, USA	Carpinteria at Veddar's Ranch	\N	point	-119.48104	34.42374	-119.48104	-119.48104	34.42374	34.42374	\N	\N	\N
cape_evans_mcmurdo	other	Cape Evans, McMurdo Sound, Antarctica	McMurdo Sound, Antarctica	 Cape Evans is located about 20 km north of McMurdo Station, the U.S. Antarctic research center on the south tip of Ross Island, on the shore of McMurdo Sound.	\N	point	166.4159	-77.634617	166.4159	166.4159	-77.634617	-77.634617	\N	\N	\N
frys_3	other	Fry's 3	California, USA	Fry's 3 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.7563	34.05776667	-119.7563	-119.7563	34.05776667	34.05776667	-30	-30	Foot_US
CAR	other	Carpinteria Reef mooring 	California, USA	Carpinteria Reef (CAR) is ofshore of the rock groin near the salt marsh, west of the campground. Depth is estimated at 26 ft.	\N	point	-119.5399	34.39015	-119.5399	-119.5399	34.39015	34.39015	-8.5	0	meter
CARP	other	CARP	California, USA	Carpinteria Reef is located on the Santa Barbara Channel offshore of the Carpinteria Salt Marsh. Depth range is from -2.2 to -8.8 meters	\N	point	-119.5416933	34.3916319	-119.5416933	-119.5416933	34.3916319	34.3916319	\N	\N	\N
CARP1	other	CARP1	California, USA	Carpinteria Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 70 (degree). Transect runs parallel along the significant NE-running reef ridge and has significant relief (up to 3 m) on the northern side. Bedrock substrate with some slight relief (0-1 m). Depth is approximately 8-12 feet.	\N	point	-119.5438	34.392417	-119.5438	-119.5438	34.392417	34.392417	-3.05	-3.05	meter
CARP10	other	CARP10	California, USA	Carpinteria Transect 10: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with moderate relief (0-1.5 m). Depth approximately 24â. Transect heading is ~ 90 degrees. Kelp continually cleared in 2m band on all sides of the transect. Depth is approximately 24 feet.	\N	point	-119.541183	34.391217	-119.541183	-119.541183	34.391217	34.391217	-7.4	-7.4	meter
CARP_1km_box	reef	Carpinteria Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.53917	34.46973	-119.54833	-119.53	34.3851	34.405	\N	\N	\N
CARP2	other	CARP2	California, USA	Carpinteria Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 60 (degree). Generally a mudstone substrate with little relief (0-0.5 m). Depth is approximately 10-13 feet.	\N	point	-119.540367	34.392767	-119.540367	-119.540367	34.392767	34.392767	-3.51	-3.51	meter
CARP3	other	CARP3	California, USA	Carpinteria Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Bedrock substrate with some moderate relief (0-1.5 m), boulders, and some small areas (1-3 m) of silt and sand. Depth is approximately 24 feet.	\N	point	-119.544	34.391517	-119.544	-119.544	34.391517	34.391517	-7.32	-7.32	meter
CARP4	other	CARP4	California, USA	Carpinteria Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand. 0 bolt begins at the crevice between two ridges. Depth is approximately 22 feet.	\N	point	-119.54165	34.391717	-119.54165	-119.54165	34.391717	34.391717	-6.71	-6.71	meter
CARP5	other	CARP5	California, USA	Carpinteria Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Mudstone ridges (1-2m) with areas of shell debris, cobble, and small boulders. Depth is approximately 20 feet.	\N	point	-119.539317	34.391817	-119.539317	-119.539317	34.391817	34.391817	-6.1	-6.1	meter
CARP6	other	CARP6	California, USA	Carpinteria Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand. Depth is approximately 27 feet.	\N	point	-119.544133	34.391117	-119.544133	-119.544133	34.391117	34.391117	-8.23	-8.23	meter
CARP7	other	CARP7	California, USA	Carpinteria Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand and cobble channels. Depth is approximately 27 feet.	\N	point	-119.541833	34.391233	-119.541833	-119.541833	34.391233	34.391233	-8.23	-8.23	meter
CARP8	other	CARP8	California, USA	Carpinteria Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Mudstone substrate with some moderate relief (0-1.5 m) and some small areas of shell debris, cobble, and small boulders. Depth is approximately 27 feet.	\N	point	-119.539533	34.3914	-119.539533	-119.539533	34.3914	34.3914	-8.23	-8.23	meter
CARP9	other	CARP9	California, USA	Carpinteria Transect 9: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with moderate relief (0-1.5 m) and some small areas (1-3 m) of silty sand and cobble channels. Depth is approximately 27 feet.	\N	point	-119.541117	34.391117	-119.541117	-119.541117	34.391117	34.391117	-8.23	-8.23	meter
Carpinteria208	other	Carpinteria Fire Station	California, USA	Carpinteria Fire Station	\N	point	-119.5166667	34.4	-119.5166667	-119.5166667	34.4	34.4	\N	\N	\N
Carpinteria City Beach	other	Carpinteria City Beach	California, USA	Carpinteria City Beach	\N	point	-119.52699	34.39452	-119.52699	-119.52699	34.39452	34.39452	\N	\N	\N
CARP_reef	reef	Carpinteria reef	California, USA	Carpinteria Reef is located on the Santa Barbara Channel offshore of the Carpinteria Salt Marsh. Depth range is from -2.2 to -8.8 meters. 	\N	polygon	-119.539902	34.3902016	-119.539902	-119.539902	34.3902016	34.3902016	\N	\N	\N
CaterWTP229	other	Cater Water Treatment Plant	California, USA	Cater Water Treatment Plant	\N	point	-119.7302778	34.45416667	-119.7302778	-119.7302778	34.45416667	34.45416667	\N	\N	\N
CI	other	Carpinteria Inshore	California, USA	Carpinteria Inshore	\N	point	-119.53925	34.39388	-119.53925	-119.53925	34.39388	34.39388	\N	\N	\N
CO	other	Carpinteria Offshore	California, USA	Carpinteria Offshore	\N	point	-119.54187	34.38387	-119.54187	-119.54187	34.38387	34.38387	\N	\N	\N
ColdSprings210	other	Cold Springs Basin	California, USA	Cold Springs Basin	\N	point	-119.6166667	34.45	-119.6166667	-119.6166667	34.45	34.45	\N	\N	\N
COP	intertidal	Coal Oil Point	California, USA	Coal Oil Point (COP) is located in the rocky intertidal area on the western edge of the University of California, Santa Barbara (UCSB) campus, and is part of the UC Natural Reserve System	\N	point	-119.8782861	34.40685962	-119.8782861	-119.8782861	34.40685962	34.40685962	\N	\N	\N
CP00	other	Carpinteria Creek at 8th St Foot Bridge	California, USA	Carpinteria Creek, 8th St Foot Bridge	\N	point	-119.51413	34.39301245	-119.51413	-119.51413	34.39301245	34.39301245	\N	\N	\N
CR	other	Carpinteria Reef - near mooring site CAR	California, USA	Carpinteria Reef - near mooring site CAR	\N	point	-119.53987	34.39023	-119.53987	-119.53987	34.39023	34.39023	\N	\N	\N
FRYS_reef	reef	Santa Cruz Is, Fry's Cove	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
cruiseTransectA	other	cruiseTransectA	California, USA	Santa Barbara Channel offshore transect cruiseTransectA: from near Pt. Conception, grid station 1 (34.4569,-120.5585 ) approximately SSE to San Miguel Island, grid station 5 (34.1163,-120.3918). This line includes grid stations 1-5.	\N	rectangle	-120.47515	34.2866	-120.5585	-120.3918	34.1163	34.4569	\N	\N	\N
cruiseTransectB	other	cruiseTransectB	California, USA	Santa Barbara Channel offshore transect cruiseTransectB from Sam Miguel Island, grid station 5 (34.1163,-120.3918) approximately NNE to mid-channel near platform Heritage, grid station 8 (34.4065,-120.2308), continuing approximately NE to Arroyo Hondo Reef, grid station 9 (34.4632,-120.1216) .This line includes grid stations 5-9.	\N	rectangle	-120.2567	34.28975	-120.3918	-120.1216	34.1163	34.4632	\N	\N	\N
cruiseTransectC	other	cruiseTransectC	California, USA	Santa Barbara Channel offshore transect cruiseTransectC from Arroyo Hondo Reef, grid station 9 (34.4632,-120.1216) approximately S to Santa Rosa Island, grid station 10 (34.05828,-120.10035 )	\N	rectangle	-120.110975	34.26074167	-120.1216	-120.10035	34.05828333	34.4632	\N	\N	\N
cruiseTransectD	other	cruiseTransectD	California, USA	Santa Barbara Channel offshore transect cruiseTransectD from Santa Rosa Island, grid station 10 (34.05828,-120.10035) approximately NNE to Naples Reef, grid station 14 (34.4097,-119.951 ). This line includes grid stations 10-14	\N	rectangle	-120.025675	34.23399	-120.10035	-119.951	34.4097	34.05828	\N	\N	\N
cruiseTransectE1	other	cruiseTransectE1	California, USA	Santa Barbara Channel offshore transect cruiseTransectE1 from Naples reef, grid station 14 (34.4097,-119.951) approximately SSE to mid-channel near the East Santa Barbara Weather Buoy, grid station 15 (34.2491,-119.9069) continuing approximately SSE to Santa Cruz Island, grid station 16 (34.0665,-119.79). This line includes grid stations 14-16.	\N	rectangle	-119.8705	34.2381	-119.951	-119.79	34.0665	34.4097	\N	\N	\N
cruiseTransectF	other	cruiseTransectF	California, USA	Santa Barbara Channel offshore transect cruiseTransectF from Santa Cruz Island, grid station 16 approximately NE ( 34.0665,-119.79) to Carpinteria reef, grid station 20 (34.3766,-119.5448). This line includes grid stations 16-20.	\N	rectangle	-119.6674	34.22155	-119.79	-119.5448	34.0665	34.3766	\N	\N	\N
cruiseTransectG	other	cruiseTransectG	California, USA	Santa Barbara Channel offshore transect cruiseTransectG from Carpinteria reef (34.3766,-119.5448), grid station 20 approximately SSE to Anacapa Island (34.0256,-119.4394). grid station 21	\N	rectangle	-119.4921	34.2011	-119.5448	-119.4394	34.0256	34.3766	\N	\N	\N
cruiseTransectH	other	cruiseTransectH	California, USA	Santa Barbara Channel offshore transect cruiseTransectH from Anacapa Island, grid station 21 approximately NE (34.0256,-119.4394) to the mouth of the Santa Clara River, grid station 25 (34.2255,-119.2803). This line includes grid stations 21-25.	\N	rectangle	-119.35985	34.12555	-119.4394	-119.2803	34.0256	34.2255	\N	\N	\N
cruiseTransectS	other	cruiseTransectS	California, USA	Santa Barbara Channel along-shore transect cruiseTransect S from the mouth of the Ventura River to Pt. Conception, along the 20 meter isobath. Waypoints follow.	\N	polyline	-119.9184	34.33645	-120.5508	-119.286	34.2223	34.4506	\N	\N	\N
diablo	other	Diablo Pt	California, USA	 Diablo Pt, north shore Santa Cruz Island	\N	point	-119.75745	34.05815	-119.75745	-119.75745	34.05815	34.05815	-30	-30	Foot_US
DosPueblos226	other	Dos Pueblos Ranch	California, USA	Dos Pueblos Ranch	\N	point	-119.9516667	34.44666667	-119.9516667	-119.9516667	34.44666667	34.44666667	\N	\N	\N
DoultonTunnel231	other	Doulton Tunnel	California, USA	Doulton Tunnel	\N	point	-119.5638889	34.45694444	-119.5638889	-119.5638889	34.45694444	34.45694444	\N	\N	\N
DV01	other	Devereaux Creek at Devereaux Slough inflow	California, USA	DV01, Devereaux Creek, Devereaux Creek at Devereaux Slough inflow	\N	point	-119.87406	34.41761	-119.87406	-119.87406	34.41761	34.41761	\N	\N	\N
East UCSB Campus Beach	other	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.84201	34.41076	-119.84201	-119.84201	34.41076	34.41076	\N	\N	\N
EdisonTrail252	other	Edison Trail	California, USA	Edison Trail	\N	point	-119.5077778	34.44277778	-119.5077778	-119.5077778	34.44277778	34.44277778	\N	\N	\N
EL201	other	El Capitan at State Beach	California, USA	El Capitan at State Beach	\N	point	-120.024883	34.462283	-120.024883	-120.024883	34.462283	34.462283	\N	\N	\N
EL202	other	El Capitan at Upper Bill Wallace Trail	California, USA	El Capitan at Upper Bill Wallace Trail	\N	point	-120.00785	34.496117	-120.00785	-120.00785	34.496117	34.496117	\N	\N	\N
El Capitan State Beach	other	El Capitan State Beach	California, USA	El Capitan State Beach	\N	point	-120.02536	34.45877	-120.02536	-120.02536	34.45877	34.45877	\N	\N	\N
ElDeseo255	other	El Deseo	California, USA	El Deseo	\N	point	-119.6958333	34.49166667	-119.6958333	-119.6958333	34.49166667	34.49166667	\N	\N	\N
ELL_nearsh	nearshore	Ellwood	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
EUCB	beach	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.842017	34.410767	-119.842017	-119.842017	34.410767	34.410767	\N	\N	\N
EUCBA	beach	East UCSB Campus Beach	California, USA	East UCSB Campus Beach	\N	point	-119.842017	34.410767	-119.842017	-119.842017	34.410767	34.410767	\N	\N	\N
fbpc	other	Point Cabrillo, Mendocino County CA	California, USA	Point Cabrillo, Mendocino County CA	\N	point	-123.82679	39.35037	-123.82679	-123.82679	39.35037	39.35037	\N	\N	\N
fern_1	other	Fern 1	California, USA	Fern 1 is located on the west edge of a small headland east of Fry's Harbor.	\N	point	-119.7496333	34.05365	-119.7496333	-119.7496333	34.05365	34.05365	-30	-30	Foot_US
fern_o	other	Fern Offshore	California, USA	Fern Offshore is located on the east edge of a small headland east of Fry's Harbor.	\N	point	-119.7470333	34.05291667	-119.7470333	-119.7470333	34.05291667	34.05291667	-30	-30	Foot_US
FERN_reef	reef	Santa Cruz Is, Fern	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
FK00	other	Franklin Creek at Carpinteria Ave	California, USA	Franklin Creek, Carpinteria Ave	\N	point	-119.52145	34.40164787	-119.52145	-119.52145	34.40164787	34.40164787	\N	\N	\N
foster_urchin_sampling_2010	other	Foster et al, Urchin collection site	California, USA	Collection site for Foster et al (2014) Urchin sampling	\N	point	-119.83	34.415	-119.83	-119.83	34.415	34.415	\N	\N	\N
frys_1	other	Fry's 1	California, USA	Fry's 1 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.7551	34.05695	-119.7551	-119.7551	34.05695	34.05695	-30	-30	Foot_US
ELCAP_ws	land	El Capitan Watershed	California, USA	El Capitan Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
frys_2	other	Fry's 2	California, USA	Fry's 2 is north of the Fry's harbor anchorage on the north shore of Santa Cruz Island, CA.	\N	point	-119.7558833	34.05765	-119.7558833	-119.7558833	34.05765	34.05765	-30	-30	Foot_US
gaviota	other	Gaviota Pier, Santa Barbara County CA	California, USA	Gaviota Pier, Santa Barbara County CA	\N	point	-120.22821	34.46978	-120.22821	-120.22821	34.46978	34.46978	\N	\N	\N
Gaviota State Beach	other	Gaviota State Beach	California, USA	Gaviota State Beach	\N	point	-120.22757	34.47109	-120.22757	-120.22757	34.47109	34.47109	\N	\N	\N
GB201	other	Gobernador at Veddar's Ranch	California, USA	Gobernador at Veddar's Ranch	\N	point	-119.47089	34.4245	-119.47089	-119.47089	34.4245	34.4245	\N	\N	\N
geocov_adcp150.ds1101.e4	other	geocov_adcp150.ds1101.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.63105	35.38845	-121.9929	-119.2692	34.0234	36.7535	-495	-23	meter
geocov_adcp150.ds1102.e4	other	geocov_adcp150.ds1102.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92245	34.24445	-120.5635	-119.2814	34.024	34.4649	-495	-23	meter
geocov_adcp150.ds1103.e4	other	geocov_adcp150.ds1103.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6346	35.41695	-121.9878	-119.2814	34.0253	36.8086	-495	-23	meter
geocov_adcp150.ds1104.e4	other	geocov_adcp150.ds1104.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6345	35.4047	-121.9918	-119.2772	34.0247	36.7847	-495	-23	meter
geocov_adcp150.ds1105.e4	other	geocov_adcp150.ds1105.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.83005	35.40805	-122.3775	-119.2826	34.0223	36.7938	-495	-23	meter
geocov_adcp150.ds1106.e4	other	geocov_adcp150.ds1106.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.66185	35.3896	-122.044	-119.2797	34.0234	36.7558	-495	-23	meter
geocov_adcp150.ds1107.e4	other	geocov_adcp150.ds1107.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6366	35.4143	-121.9925	-119.2807	34.0256	36.803	-495	-23	meter
geocov_adcp150.ds1108.e4	other	geocov_adcp150.ds1108.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9394	34.24965	-120.602	-119.2768	34.0222	34.4771	-487	-15	meter
geocov_adcp300.ds1109.e4	other	geocov_adcp300.ds1109.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6194	35.40625	-121.987	-119.2518	34.0248	36.7877	-125	-7	meter
geocov_adcp300.ds1110.e4	other	geocov_adcp300.ds1110.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9319	34.24445	-120.575	-119.2888	34.0244	34.4645	-125	-7	meter
geocov_adcp300.ds1111.e4	other	geocov_adcp300.ds1111.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6415	35.40775	-121.9969	-119.2861	34.023	36.7925	-206	-10	meter
geocov_adcp300.ds1112.e4	other	geocov_adcp300.ds1112.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.94965	34.2454	-120.6118	-119.2875	34.0264	34.4644	-203	-7	meter
geocov_adcp300.ds1113.e4	other	geocov_adcp300.ds1113.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9252	34.24445	-120.57	-119.2804	34.0248	34.4641	-203	-7	meter
geocov_adcp300.ds1114.e4	other	geocov_adcp300.ds1114.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9299	34.24685	-120.579	-119.2808	34.0251	34.4686	-203	-7	meter
geocov_adcp300.ds1115.e4	other	geocov_adcp300.ds1115.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9459	34.25505	-120.6114	-119.2804	34.0267	34.4834	-203	-7	meter
geocov_adcp300.ds1116.e4	other	geocov_adcp300.ds1116.e4	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9247	34.2438	-120.5679	-119.2815	34.0243	34.4633	-203	-7	meter
geocov_adcp75.ds1111.e5	other	geocov_adcp75.ds1111.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-121.4825	35.65685	-121.8328	-121.1322	35.1502	36.1635	-731	-27	meter
geocov_adcp75.ds1112.e5	other	geocov_adcp75.ds1112.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-120.83705	35.51665	-121.9916	-119.6825	34.3721	36.6612	-731	-27	meter
geocov_adcp75.ds1114.e5	other	geocov_adcp75.ds1114.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92955	34.24665	-120.5785	-119.2806	34.0251	34.4682	-731	-27	meter
geocov_adcp75.ds1115.e5	other	geocov_adcp75.ds1115.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.93335	34.2478	-120.5863	-119.2804	34.0267	34.4689	-491	-19	meter
geocov_adcp75.ds1116.e5	other	geocov_adcp75.ds1116.e5	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9244	34.24395	-120.5673	-119.2815	34.0243	34.4636	-491	-19	meter
geocov_ctdbottledata.ds1001.e3	other	geocov_ctdbottledata.ds1001.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9164	34.23645	-120.5512	-119.2816	34.0254	34.4475	-75	0	meter
geocov_ctdbottledata.ds1002.e3	other	geocov_ctdbottledata.ds1002.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92115	34.24395	-120.5608	-119.2815	34.0252	34.4627	-99999	0	meter
geocov_ctdbottledata.ds1003.e3	other	geocov_ctdbottledata.ds1003.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9208	34.24445	-120.5595	-119.2821	34.0262	34.4627	-530	0	meter
geocov_ctdbottledata.ds1004.e3	other	geocov_ctdbottledata.ds1004.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.91765	34.24645	-120.5578	-119.2775	34.0307	34.4622	-550	0	meter
geocov_ctdbottledata.ds1005.e3	other	geocov_ctdbottledata.ds1005.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92285	34.24415	-120.5612	-119.2845	34.0243	34.464	-575	0	meter
geocov_ctdbottledata.ds1006.e3	other	geocov_ctdbottledata.ds1006.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92	34.24415	-120.5595	-119.2805	34.0258	34.4625	-580	0	meter
geocov_ctdbottledata.ds1007.e3	other	geocov_ctdbottledata.ds1007.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9206	34.24365	-120.5592	-119.282	34.0253	34.462	-76	0	meter
geocov_ctdbottledata.ds1008.e3	other	geocov_ctdbottledata.ds1008.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9216	34.24215	-120.562	-119.2812	34.0235	34.4608	-575	0	meter
GAV_ws	land	Gaviota watershed	California, USA	Gaviota watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
geocov_ctdbottledata.ds1009.e3	other	geocov_ctdbottledata.ds1009.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9153	34.24315	-120.5599	-119.2707	34.0254	34.4609	-75	0	meter
geocov_ctdbottledata.ds1010.e3	other	geocov_ctdbottledata.ds1010.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9253	34.24405	-120.5595	-119.2911	34.0247	34.4634	-99999	0	meter
geocov_ctdbottledata.ds1011.e3	other	geocov_ctdbottledata.ds1011.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92265	34.2441	-120.5591	-119.2862	34.0248	34.4634	-75	0	meter
geocov_ctdbottledata.ds1012.e3	other	geocov_ctdbottledata.ds1012.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9236	34.2452	-120.5597	-119.2875	34.0265	34.4639	-75	0	meter
geocov_ctdbottledata.ds1013.e3	other	geocov_ctdbottledata.ds1013.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92085	34.24425	-120.5612	-119.2805	34.025	34.4635	-75	0	meter
geocov_ctdbottledata.ds1014.e3	other	geocov_ctdbottledata.ds1014.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92055	34.24485	-120.5601	-119.281	34.0256	34.4641	-77	0	meter
geocov_ctdbottledata.ds1015.e3	other	geocov_ctdbottledata.ds1015.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9201	34.245	-120.5598	-119.2804	34.0274	34.4626	-75	0	meter
geocov_ctdbottledata.ds1016.e3	other	geocov_ctdbottledata.ds1016.e3	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92075	34.244	-120.56	-119.2815	34.0248	34.4632	-75	0	meter
geocov_ctddowncast.ds1001.e1	other	geocov_ctddowncast.ds1001.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9164	34.23645	-120.5512	-119.2816	34.0254	34.4475	-500.777	0	meter
geocov_ctddowncast.ds1002.e1	other	geocov_ctddowncast.ds1002.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92115	34.24395	-120.5608	-119.2815	34.0252	34.4627	-530.488	0	meter
geocov_ctddowncast.ds1003.e1	other	geocov_ctddowncast.ds1003.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9208	34.24445	-120.5595	-119.2821	34.0262	34.4627	-533.459	0	meter
geocov_ctddowncast.ds1004.e1	other	geocov_ctddowncast.ds1004.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.91765	34.24645	-120.5578	-119.2775	34.0307	34.4622	-577.026	0	meter
geocov_ctddowncast.ds1005.e1	other	geocov_ctddowncast.ds1005.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92285	34.24415	-120.5612	-119.2845	34.0243	34.464	-579.997	0	meter
geocov_ctddowncast.ds1006.e1	other	geocov_ctddowncast.ds1006.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92	34.24415	-120.5595	-119.2805	34.0258	34.4625	-580.987	0	meter
geocov_ctddowncast.ds1007.e1	other	geocov_ctddowncast.ds1007.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9206	34.24365	-120.5592	-119.282	34.0253	34.462	-580.987	0	meter
geocov_ctddowncast.ds1008.e1	other	geocov_ctddowncast.ds1008.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9216	34.24215	-120.562	-119.2812	34.0235	34.4608	-575.046	0	meter
geocov_ctddowncast.ds1009.e1	other	geocov_ctddowncast.ds1009.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9153	34.24315	-120.5599	-119.2707	34.0254	34.4609	-578.017	0	meter
geocov_ctddowncast.ds1010.e1	other	geocov_ctddowncast.ds1010.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9253	34.24405	-120.5595	-119.2911	34.0247	34.4634	-576.036	0	meter
geocov_ctddowncast.ds1011.e1	other	geocov_ctddowncast.ds1011.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92265	34.2441	-120.5591	-119.2862	34.0248	34.4634	-576.036	0	meter
geocov_ctddowncast.ds1012.e1	other	geocov_ctddowncast.ds1012.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9236	34.2452	-120.5597	-119.2875	34.0265	34.4639	-576.036	0	meter
geocov_ctddowncast.ds1013.e1	other	geocov_ctddowncast.ds1013.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92085	34.24425	-120.5612	-119.2805	34.025	34.4635	-575.046	0	meter
geocov_ctddowncast.ds1014.e1	other	geocov_ctddowncast.ds1014.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92055	34.24485	-120.5601	-119.281	34.0256	34.4641	-570.096	0	meter
geocov_ctddowncast.ds1015.e1	other	geocov_ctddowncast.ds1015.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9201	34.245	-120.5598	-119.2804	34.0274	34.4626	-576.036	0	meter
geocov_ctddowncast.ds1016.e1	other	geocov_ctddowncast.ds1016.e1	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92075	34.244	-120.56	-119.2815	34.0248	34.4632	-499.787	0	meter
geocov_ctdtransects.ds1201.e2	other	geocov_ctdtransects.ds1201.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.97095	34.2971	-120.6675	-119.2744	34.0341	34.5601	-119.58	-0.8	meter
geocov_ctdtransects.ds1202.e2	other	geocov_ctdtransects.ds1202.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9211	34.2477	-120.5532	-119.289	34.0314	34.464	-119.68	-0.84	meter
geocov_ctdtransects.ds1203.e2	other	geocov_ctdtransects.ds1203.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9392	34.2443	-120.5623	-119.3161	34.027	34.4616	-118.4	-0.78	meter
geocov_ctdtransects.ds1204.e2	other	geocov_ctdtransects.ds1204.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.94005	34.2442	-120.5567	-119.3234	34.0246	34.4638	-117.28	-0.02	meter
geocov_ctdtransects.ds1205.e2	other	geocov_ctdtransects.ds1205.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9251	34.2432	-120.5656	-119.2846	34.0256	34.4608	-108.39	-0.12	meter
geocov_ctdtransects.ds1206.e2	other	geocov_ctdtransects.ds1206.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92105	34.2443	-120.5562	-119.2859	34.0277	34.4609	-98.5	-0.13	meter
geocov_ctdtransects.ds1207.e2	other	geocov_ctdtransects.ds1207.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92365	34.2459	-120.5596	-119.2877	34.0311	34.4607	-104	-0.42	meter
geocov_ctdtransects.ds1208.e2	other	geocov_ctdtransects.ds1208.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.90635	34.2394	-120.3727	-119.44	34.0284	34.4504	-119.1	-0.47	meter
geocov_ctdtransects.ds1209.e2	other	geocov_ctdtransects.ds1209.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9315	34.24665	-120.5608	-119.3022	34.0313	34.462	-119.65	-1.03	meter
geocov_ctdtransects.ds1210.e2	other	geocov_ctdtransects.ds1210.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.0614	34.4159	-120.3916	-119.7312	34.3785	34.4533	-78.96	-0.25	meter
geocov_ctdtransects.ds1211.e2	other	geocov_ctdtransects.ds1211.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.87785	34.24115	-120.396	-119.3597	34.023	34.4593	-119.69	-0.08	meter
geocov_ctdtransects.ds1212.e2	other	geocov_ctdtransects.ds1212.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.95715	34.2434	-120.563	-119.3513	34.0288	34.458	-119.9	-0.06	meter
geocov_ctdtransects.ds1213.e2	other	geocov_ctdtransects.ds1213.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9545	34.24965	-120.5585	-119.3505	34.0423	34.457	-119.62	-1.54	meter
geocov_ctdtransects.ds1214.e2	other	geocov_ctdtransects.ds1214.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.93315	34.25085	-120.559	-119.3073	34.0386	34.4631	-117.66	-0.18	meter
geocov_ctdtransects.ds1215.e2	other	geocov_ctdtransects.ds1215.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9374	34.2479	-120.5775	-119.2973	34.0261	34.4697	-119.9	-0.12	meter
geocov_ctdtransects.ds1216.e2	other	geocov_ctdtransects.ds1216.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9267	34.24335	-120.5594	-119.294	34.0251	34.4616	-119.69	-0.23	meter
geocov_ctdupcast.ds1001.e2	other	geocov_ctdupcast.ds1001.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9168	34.23625	-120.5518	-119.2818	34.0253	34.4472	-499.787	0	meter
geocov_ctdupcast.ds1002.e2	other	geocov_ctdupcast.ds1002.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9214	34.244	-120.561	-119.2818	34.0251	34.4629	-529.498	0	meter
geocov_ctdupcast.ds1003.e2	other	geocov_ctdupcast.ds1003.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92085	34.2443	-120.5599	-119.2818	34.026	34.4626	-532.469	0	meter
geocov_ctdupcast.ds1004.e2	other	geocov_ctdupcast.ds1004.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.91765	34.24645	-120.5578	-119.2775	34.0307	34.4622	-576.036	0	meter
geocov_ctdupcast.ds1005.e2	other	geocov_ctdupcast.ds1005.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92285	34.24415	-120.5612	-119.2845	34.0243	34.464	-579.007	0	meter
geocov_ctdupcast.ds1006.e2	other	geocov_ctdupcast.ds1006.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92	34.24415	-120.5595	-119.2805	34.0258	34.4625	-579.997	0	meter
geocov_ctdupcast.ds1007.e2	other	geocov_ctdupcast.ds1007.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9206	34.24365	-120.5592	-119.282	34.0253	34.462	-579.997	0	meter
geocov_ctdupcast.ds1008.e2	other	geocov_ctdupcast.ds1008.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9216	34.24215	-120.562	-119.2812	34.0235	34.4608	-574.056	0	meter
geocov_ctdupcast.ds1009.e2	other	geocov_ctdupcast.ds1009.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.91565	34.24295	-120.5603	-119.271	34.0253	34.4606	-577.026	0	meter
geocov_ctdupcast.ds1010.e2	other	geocov_ctdupcast.ds1010.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92745	34.2441	-120.5633	-119.2916	34.0246	34.4636	-575.046	0	meter
geocov_ctdupcast.ds1011.e2	other	geocov_ctdupcast.ds1011.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92315	34.24395	-120.5601	-119.2862	34.0246	34.4633	-575.046	0	meter
geocov_ctdupcast.ds1012.e2	other	geocov_ctdupcast.ds1012.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9242	34.24515	-120.5607	-119.2877	34.027	34.4633	-575.046	0	meter
geocov_ctdupcast.ds1013.e2	other	geocov_ctdupcast.ds1013.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9217	34.24435	-120.5624	-119.281	34.025	34.4637	-574.056	0	meter
geocov_ctdupcast.ds1014.e2	other	geocov_ctdupcast.ds1014.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9214	34.2448	-120.5615	-119.2813	34.0255	34.4641	-569.106	0	meter
geocov_ctdupcast.ds1015.e2	other	geocov_ctdupcast.ds1015.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92095	34.2452	-120.5612	-119.2807	34.0278	34.4626	-575.046	0	meter
geocov_ctdupcast.ds1016.e2	other	geocov_ctdupcast.ds1016.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9214	34.24385	-120.5611	-119.2817	34.0244	34.4633	-498.796	0	meter
geocov_ds101.e1	other	Central California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from TO DO California, USA to the TO DO California.	\N	rectangle	-118.9415206	33.84114025	-120.7536427	-117.1293985	32.50386299	35.1784175	\N	\N	\N
geocov_ds101.e2	other	Southern California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from Purisima Point to San Diego, California USA, including the eight Santa Barbara Channel Isands.	\N	rectangle	-121.78621	36.2520155	-122.7832345	-120.7891884	35.17569034	37.94752509	\N	\N	\N
geocov_ds102.e1	other	Southern California nearshore reefs	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from Point Arguello to San Diego, California USA, including the eight Santa Barbara Channel Isands.	\N	rectangle	-118.9	33.6	-120.6048	-117.247	32.657	34.55619	\N	\N	\N
geocov_ds104.e1	reef	NE Pacific coast	California, USA	Nearshore reefs from Sitka, Alaska, USA to Bahia Tortugas, Baja California Sur, Mexico along the Pacific coast of North America. 	\N	rectangle	0	0	-135.34785	-114.87656	27.65595	57.04173	\N	\N	\N
geocov_ds104.e2	reef	Central California	California, USA	TO DO	\N	rectangle	0	0	-122.16839	-121.88027	36.509	36.986	\N	\N	\N
geocov_ds14	other	data_coverage_ds14	California, USA	The Geographic region of the kelp bed data extends along the California coast, down through the coast of Baja, Mexico: Central California (Halfmoon Bay to Purisima Point), Southern California (Point Arguello to the United States/Mexico border including the Channel Islands) and Baja California (points south of the United States/Mexico border including several offshore islands).	\N	rectangle	-119.795	33.69	-122.44	-117.15	30	37.38	\N	\N	\N
geocov_ds2	other	data_coverage_ds2	California, USA	Stations are located in the coastal watersheds draining into the Santa Barbara Channel, California, USA.	\N	rectangle	-119.84975	34.47702	-120.22861	-119.47089	34.42374	34.5303	\N	\N	\N
geocov_ds5	other	data_coverage_ds5	California, USA	Streamflow data obtained from coastal streams in southern California draining into the Santa Barbara Channel	\N	rectangle	-119.7075	34.365	-120.2261	-119.1889	34.2422	34.4878	\N	\N	\N
geocov_ds54	other	data_coverage_ds54	California, USA	In California, USA, coastal areas along the mainland from Purisima Point (Santa Barbara County) in the north to the US-Mexico border. Coastal areas of the eight Northern and Southern Channel Islands.	\N	rectangle	-118.8841623	33.62544209	-120.6392447	-117.1290799	32.50386299	34.74702119	\N	\N	\N
geocov_ds90	other	California and Baja California Coasts	California, USA and Baja California, Mexico	Shallow coastal waters of the eastern Pacific from northern California, USA to the southern tip of Baja California Sur, Mexico.	\N	rectangle	-116.777	32.03	-124.139999	-109.414344	23.004375	41.055	\N	\N	\N
geocov_udas.ds1101.e2	other	geocov_udas.ds1101.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.61665	35.2258	-121.9602	-119.2731	34.0211	36.4305	-3	-3	meter
grid22	other	grid22	California, USA	Santa Barbara Channel offshore station grid22	\N	point	-119.3917	34.087	-119.3917	-119.3917	34.087	34.087	-227	-227	meter
geocov_udas.ds1102.e2	other	geocov_udas.ds1102.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.92445	34.24415	-120.5645	-119.2844	34.0222	34.4661	-3	-3	meter
geocov_udas.ds1103.e2	other	geocov_udas.ds1103.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6354	35.3742	-121.9848	-119.286	34.0226	36.7258	-3	-3	meter
geocov_udas.ds1104.e2	other	geocov_udas.ds1104.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.6334	35.3527	-121.9888	-119.278	34.0255	36.6799	-3	-3	meter
geocov_udas.ds1105.e2	other	geocov_udas.ds1105.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.63545	35.36045	-121.9874	-119.2835	34.0223	36.6986	-3	-3	meter
geocov_udas.ds1106.e2	other	geocov_udas.ds1106.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.65765	35.38325	-122.0394	-119.2759	34.0217	36.7448	-3	-3	meter
geocov_udas.ds1107.e2	other	geocov_udas.ds1107.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.63365	35.4116	-121.9887	-119.2786	34.0251	36.7981	-3	-3	meter
geocov_udas.ds1108.e2	other	geocov_udas.ds1108.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.5599	35.09695	-121.8398	-119.28	34.0198	36.1741	-3	-3	meter
geocov_udas.ds1109.e2	other	geocov_udas.ds1109.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.90965	34.2436	-120.5647	-119.2546	34.0237	34.4635	-3	-3	meter
geocov_udas.ds1110.e2	other	geocov_udas.ds1110.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.93035	34.24305	-120.5727	-119.288	34.0223	34.4638	-3	-3	meter
geocov_udas.ds1111.e2	other	geocov_udas.ds1111.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.64255	35.3207	-121.9939	-119.2912	34.0255	36.6159	-3	-3	meter
geocov_udas.ds1112.e2	other	geocov_udas.ds1112.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-120.5835	35.1236	-121.8796	-119.2874	34.0234	36.2238	-3	-3	meter
geocov_udas.ds1113.e2	other	geocov_udas.ds1113.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.93415	34.2448	-120.589	-119.2793	34.023	34.4666	-3	-3	meter
geocov_udas.ds1114.e2	other	geocov_udas.ds1114.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9305	34.2435	-120.577	-119.284	34.0204	34.4666	-3	-3	meter
geocov_udas.ds1115.e2	other	geocov_udas.ds1115.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9457	34.2531	-120.6084	-119.283	34.0239	34.4823	-3	-3	meter
geocov_udas.ds1116.e2	other	geocov_udas.ds1116.e2	California, USA	Data table bounding box coordinates	\N	rectangle	-119.9245	34.24285	-120.5673	-119.2817	34.0246	34.4611	-3	-3	meter
GOLB1	other	GOLB1	California, USA	Goleta Bay Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at western edge of existing kelp bed. Mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 18 feet.	\N	point	-119.8224	34.413783	-119.8224	-119.8224	34.413783	34.413783	-5.49	-5.49	meter
GOLB_1km_box	reef	Goleta Bay Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.81958	34.46973	-119.82833	-119.81083	34.4051	34.4156	\N	\N	\N
GOLB2	other	GOLB2	California, USA	Goleta Bay Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect has mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 18 feet.	\N	point	-119.8218	34.41365	-119.8218	-119.8218	34.41365	34.41365	-5.49	-5.49	meter
GoletaRdYard211	other	Santa Barbara County Road Yard	California, USA	Santa Barbara County Road Yard	\N	point	-119.7666667	34.45	-119.7666667	-119.7666667	34.45	34.45	\N	\N	\N
grid1	other	grid1	California, USA	Santa Barbara Channel offshore station grid1	\N	point	-120.5585	34.4569	-120.5585	-120.5585	34.4569	34.4569	-84	-84	meter
grid10	other	grid10	California, USA	Santa Barbara Channel offshore station grid10	\N	point	-120.10035	34.0583	-120.10035	-120.10035	34.0583	34.0583	-56	-56	meter
grid11	other	grid11	California, USA	Santa Barbara Channel offshore station grid11	\N	point	-120.0511	34.1507	-120.0511	-120.0511	34.1507	34.1507	-499	-499	meter
grid12	other	grid12	California, USA	Santa Barbara Channel offshore station grid12	\N	point	-120.025	34.2255	-120.025	-120.025	34.2255	34.2255	-588	-588	meter
grid13	other	grid13	California, USA	Santa Barbara Channel offshore station grid13	\N	point	-119.9913	34.3121	-119.9913	-119.9913	34.3121	34.3121	-533	-533	meter
grid14	other	grid14	California, USA	Santa Barbara Channel offshore station grid14	\N	point	-119.951	34.4097	-119.951	-119.951	34.4097	34.4097	-60	-60	meter
grid15	other	grid15	California, USA	Santa Barbara Channel offshore station grid15	\N	point	-119.9069	34.2491	-119.9069	-119.9069	34.2491	34.2491	-518	-518	meter
grid16	other	grid16	California, USA	Santa Barbara Channel offshore station grid16	\N	point	-119.79	34.0665	-119.79	-119.79	34.0665	34.0665	-75	-75	meter
grid17	other	grid17	California, USA	Santa Barbara Channel offshore station grid17	\N	point	-119.723	34.1515	-119.723	-119.723	34.1515	34.1515	-366	-366	meter
GOLB_reef	reef	Goleta Bay	California, USA	Goleta Bay is located on the Santa Barbara Channel east of Goleta Pier. Depth range is -4.2 to -5 meters.	\N	polygon	-119.822403	34.4137993	-119.822403	-119.822403	34.4137993	34.4137993	\N	\N	\N
GOLB	other	GOLB	California, USA	Goleta Bay is located on the Santa Barbara Channel east of Goleta Pier. Depth range is -4.2 to -5 meters.	\N	point	-119.8721	34.4137165	-119.8221	-119.8221	34.4137165	34.4137165	\N	\N	\N
grid18	other	grid18	California, USA	Santa Barbara Channel offshore station grid18	\N	point	-119.6636	34.2255	-119.6636	-119.6636	34.2255	34.2255	-147	-147	meter
grid19	other	grid19	California, USA	Santa Barbara Channel offshore station grid19	\N	point	-119.6042	34.301	-119.6042	-119.6042	34.301	34.301	-84	-84	meter
grid2	other	grid2	California, USA	Santa Barbara Channel offshore station grid2	\N	point	-120.5221	34.375	-120.5221	-120.5221	34.375	34.375	-262	-262	meter
grid20	other	grid20	California, USA	Santa Barbara Channel offshore station grid20	\N	point	-119.5448	34.3766	-119.5448	-119.5448	34.3766	34.3766	-29	-29	meter
grid21	other	grid21	California, USA	Santa Barbara Channel offshore station grid21	\N	point	-119.4394	34.0256	-119.4394	-119.4394	34.0256	34.0256	-75	-75	meter
grid23	other	grid23	California, USA	Santa Barbara Channel offshore station grid23	\N	point	-119.3583	34.1258	-119.3583	-119.3583	34.1258	34.1258	-180	-180	meter
grid24	other	grid24	California, USA	Santa Barbara Channel offshore station grid24	\N	point	-119.3205	34.1783	-119.3205	-119.3205	34.1783	34.1783	-22	-22	meter
grid25	other	grid25	California, USA	Santa Barbara Channel offshore station grid25	\N	point	-119.2803	34.2255	-119.2803	-119.2803	34.2255	34.2255	-18	-18	meter
grid3	other	grid3	California, USA	Santa Barbara Channel offshore station grid3	\N	point	-120.4738	34.275	-120.4738	-120.4738	34.275	34.275	-442	-442	meter
grid4	other	grid4	California, USA	Santa Barbara Channel offshore station grid4	\N	point	-120.43	34.1935	-120.43	-120.43	34.1935	34.1935	-170	-170	meter
grid5	other	grid5	California, USA	Santa Barbara Channel offshore station grid5	\N	point	-120.39266	34.11714	-120.39266	-120.39266	34.11714	34.11714	-71	-71	meter
grid6	other	grid6	California, USA	Santa Barbara Channel offshore station grid6	\N	point	-120.3334	34.2223	-120.3334	-120.3334	34.2223	34.2223	-470	-470	meter
grid7	other	grid7	California, USA	Santa Barbara Channel offshore station grid7	\N	point	-120.2768	34.3215	-120.2768	-120.2768	34.3215	34.3215	-378	-378	meter
grid8	other	grid8	California, USA	Santa Barbara Channel offshore station grid8	\N	point	-120.2308	34.4065	-120.2308	-120.2308	34.4065	34.4065	-214	-214	meter
grid9	other	grid9	California, USA	Santa Barbara Channel offshore station grid9	\N	point	-120.1216	34.4632	-120.1216	-120.1216	34.4632	34.4632	-29	-29	meter
GV201	other	Gaviota at Hwy 101 N rest stop	California, USA	Gaviota at Hwy 101 N rest stop	\N	point	-120.22917	34.48011	-120.22917	-120.22917	34.48011	34.48011	\N	\N	\N
GV202	other	Gaviota at Las Cruces School	California, USA	Gaviota at Las Cruces School	\N	point	-120.22861	34.50765	-120.22861	-120.22861	34.50765	34.50765	\N	\N	\N
Haskells	other	Haskells Beach	California, USA	Haskells Beach	\N	point	-119.91413	34.42977	-119.91413	-119.91413	34.42977	34.42977	\N	\N	\N
HO00	other	HO00, Arroyo Hondo Creek, Arroyo Hondo at Upstream Side of 101 Bridge	California, USA	HO00, Arroyo Hondo Creek, Arroyo Hondo at Upstream Side of 101 Bridge	\N	point	-120.14122	34.4752858	-120.14122	-120.14122	34.4752858	34.4752858	\N	\N	\N
HO201	other	Arroyo Hondo at East Avocado Orchard	California, USA	Arroyo Hondo at East Avocado Orchard	\N	point	-120.14064	34.47651	-120.14064	-120.14064	34.47651	34.47651	\N	\N	\N
HO202	other	Arroyo Hondo at Upper Outlaw Trail	California, USA	Arroyo Hondo at Upper Outlaw Trail	\N	point	-120.13678	34.49059	-120.13678	-120.13678	34.49059	34.49059	\N	\N	\N
howlands	reef	Howland landing	California, USA	Howland Landing is located on the western end (northern side) of Santa Catalina Island, in the Channel Islands of California, a few miles from the town of Two Harbors.	\N	point	-118.522	33.465	-118.522	-118.522	33.465	33.465	\N	\N	\N
INSERT	other	INSERT TEMPLATE SITE	California, USA	This site is a place holder for a site to be added by code. INSERT DESCRIPTION	\N	point	0	0	0	0	0	0	\N	\N	\N
Isla Vista West Beach	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.87385	34.40928	-119.87385	-119.87385	34.40928	34.40928	\N	\N	\N
IVEE	other	IVEE	California, USA	Isla Vista (IV) Reef is located on the Santa Barbara Channel near the University of California Santa Barbara, CA. Depth range is from -8.2 to -8.8 meters.	\N	point	-119.85755	34.402783	-119.85755	-119.85755	34.402783	34.402783	\N	\N	\N
IVEE1	other	IVEE1	California, USA	Isla Vista Reef Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at western edge of existing eastern kelp bed near Depressions beach; a mudstone and small boulder substrate with some sand channels and slight relief (0-1 m). Depth is approximately 30 feet.	\N	point	-119.857867	34.402833	-119.857867	-119.857867	34.402833	34.402833	-9.14	-9.14	meter
IVEE_1km_box	reef	Isla Vista Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.87208	34.46973	-119.89333	-119.85083	34.3958	34.4189	\N	\N	\N
IVEE2	other	IVEE2	California, USA	IV Reef Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 85 (degree). Transect has a mudstone and sand substrate with several large isolated boulders creating some moderate relief (0-1.5 m). Depth is approximately 30 feet.	\N	point	-119.857233	34.402733	-119.857233	-119.857233	34.402733	34.402733	-9.14	-9.14	meter
IVEE_beach	beach	Isla Vista Beach	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
IVEE_reef	reef	Isla Vista Reef	California, USA	Isla Vista (IV) Reef is located on the Santa Barbara Channel near the University of California Santa Barbara, CA. Depth range is from -8.2 to -8.8 meters	\N	polygon	-119.857803	34.4137993	-119.857803	-119.857803	34.4137993	34.4137993	\N	\N	\N
IVWB	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.87385	34.409283	-119.87385	-119.87385	34.409283	34.409283	\N	\N	\N
IVWBA	other	Isla Vista West Beach	California, USA	Isla Vista West Beach	\N	point	-119.87385	34.409283	-119.87385	-119.87385	34.409283	34.409283	\N	\N	\N
klose_DT1	other	klose_DT1	California, USA	CaÃ±adaLarga. Urban; industrial. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Low dissolved oxygen. Category for this study: Non-reference.	\N	point	-119.29514	34.33705	-119.29514	-119.29514	34.33705	34.33705	\N	\N	\N
klose_DT2	other	klose_DT2	California, USA	San Antonio Creek. Residential, Agricultural; downstream from large horse stable and winery. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: High nitrogen concentrations. Category for this study: Non-reference.	\N	point	-119.30696	34.38095	-119.30696	-119.30696	34.38095	34.38095	\N	\N	\N
klose_REF11	other	klose_REF11	California, USA	Ventura River below NF/Upper Matilija Conf.. Residential, Wildlands. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.2968	34.48312	-119.2968	-119.2968	34.48312	34.48312	\N	\N	\N
klose_REF12	other	klose_REF12	California, USA	North Fork Matilija Creek. Primarily Wildlands; limited upstream development. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.30649	34.49129	-119.30649	-119.30649	34.49129	34.49129	\N	\N	\N
klose_REF13	other	klose_REF13	California, USA	Upper Matilija Creek. Primarily Wildlands; limited upstream development. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Reference.	\N	point	-119.32906	34.49397	-119.32906	-119.32906	34.49397	34.49397	\N	\N	\N
klose_ST1	other	klose_ST1	California, USA	Ventura River Bridge. Urban; below industrial, agricultural areas; surrounded by major roads, bike path, railroad tracks, and bridge. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae, eutrophication. Category for this study: Non-reference.	\N	point	-119.3094	34.27721	-119.3094	-119.3094	34.27721	34.27721	\N	\N	\N
klose_ST10	other	klose_ST10	California, USA	Ventura River Above San Antonio Creek. Residential; rural with low density residential housing. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.30818	34.38144	-119.30818	-119.30818	34.38144	34.38144	\N	\N	\N
klose_ST2	other	klose_ST2	California, USA	Ventura River Reach. Urban; below industrial, agricultural areas; surrounded by major roads, bike path, railroad tracks, and bridge. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae, eutrophication. Category for this study: Non-reference.	\N	point	-119.30907	34.27697	-119.30907	-119.30907	34.27697	34.27697	\N	\N	\N
klose_ST3	other	klose_ST3	California, USA	Main Street (Reach 1). Urban, Agricultural; multiple uses â industrial, agricultural, institutional. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae. Category for this study: Non-reference.	\N	point	-119.3089	34.28273	-119.3089	-119.3089	34.28273	34.28273	\N	\N	\N
klose_ST4	other	klose_ST4	California, USA	Stanley Drain (Reach 2). Agricultural; below industrial, residential, and institutional areas. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: Nuisance algae. Category for this study: Non-reference.	\N	point	-119.3017	34.30439	-119.3017	-119.3017	34.30439	34.30439	\N	\N	\N
klose_ST5	other	klose_ST5	California, USA	Shell Road. Urban; industrial. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.29556	34.31662	-119.29556	-119.29556	34.31662	34.31662	\N	\N	\N
klose_ST6	other	klose_ST6	California, USA	Ventura River Below Ojai Sanitation Plant. Urban; multiple uses â industrial, agricultural, institutional. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.29678	34.33746	-119.29678	-119.29678	34.33746	34.33746	\N	\N	\N
klose_ST7	other	klose_ST7	California, USA	Ventura River Above Ojai Sanitation Plant. Agricultural; below industrial, residential, and institutional areas. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.29913	34.34438	-119.29913	-119.29913	34.34438	34.34438	\N	\N	\N
klose_ST8	other	klose_ST8	California, USA	Foster Park. County Park on one side, undeveloped land on other. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.3092	34.35349	-119.3092	-119.3092	34.35349	34.35349	\N	\N	\N
klose_ST9	other	klose_ST9	California, USA	Ventura River Below San Antonio Creek. Residential; rural with low density residential housing. Listed by Clean Water Act Section 303(d), List of Impaired Bodies as: not listed. Category for this study: Non-reference.	\N	point	-119.30795	34.3797	-119.30795	-119.30795	34.3797	34.3797	\N	\N	\N
KTYD227	other	KTYD	California, USA	KTYD	\N	point	-119.691716	34.422301	-119.691716	-119.691716	34.422301	34.422301	\N	\N	\N
lions_head	reef	Lions Head Point	California, USA	Lion Head Point is located on the western end (northern side) of Catalina Island, in the Channel Islands of California, near the town of Two Harbors.	\N	point	-118.502	33.453	-118.502	-118.502	33.453	33.453	\N	\N	\N
LOL	intertidal	Lompoc Landing	California, USA	Lompoc Landing (LOL) is a rocky intertidal site located on the Vandenberg Air Force Base (VAFB) and is just north of Surf Beach	\N	point	-120.6087994	34.71905679	-120.6087994	-120.6087994	34.71905679	34.71905679	\N	\N	\N
MC06	other	Mission Creek at Rocky Nook, USGS 11119745	California, USA	Mission Creek at Rocky Nook, USGS 11119745	\N	point	-119.71244	34.44072	-119.71244	-119.71244	34.44072	34.44072	\N	\N	\N
mcrlter1_fringing_reef	other	MCR LTER 1 Fringing Reef	Moorea, French Polynesia	Moorea, French MCR LTER 1 Fringing Reef, Moorea, French Polynesia	MCR LTER	rectangle	-149.7989	-17.4803	-149.7989	-149.7989	-17.4803	-17.4803	\N	\N	\N
MENDOCINO	nearshore	Mendocino  	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
MI	other	Mohawk Inshore	California, USA	Mohawk Inshore	\N	point	-119.72917	34.39488	-119.72917	-119.72917	34.39488	34.39488	\N	\N	\N
MK	other	Mohawk Reef	California, USA	Mohawk Reef	\N	point	-119.73012	34.39338	-119.73012	-119.73012	34.39338	34.39338	\N	\N	\N
MK_CS1	other	Mohawk Inshore Cross Shelf 1	California, USA	Mohawk Inshore Cross Shelf 1	\N	point	-119.73012	34.36755	-119.73012	-119.73012	34.36755	34.36755	\N	\N	\N
MK_CS2	other	Mohawk Reef Cross Shelf 2	California, USA	Mohawk Reef Cross Shelf 2	\N	point	-119.73012	34.3758	-119.73012	-119.73012	34.3758	34.3758	\N	\N	\N
MK_CS3	other	Mohawk Reef Cross Shelf 3	California, USA	Mohawk Reef Cross Shelf 3	\N	point	-119.73012	34.385	-119.73012	-119.73012	34.385	34.385	\N	\N	\N
MK_CS4	other	Mohawk Reef Cross Shelf 4	California, USA	Mohawk Reef Cross Shelf 4	\N	point	-119.73012	34.39013	-119.73012	-119.73012	34.39013	34.39013	\N	\N	\N
MK_CS5	other	Mohawk Reef Cross Shelf 5	California, USA	Mohawk Reef Cross Shelf 5	\N	point	-119.73012	34.39338	-119.73012	-119.73012	34.39338	34.39338	\N	\N	\N
MKO	other	MKO	California, USA	MKO is located at Mohawk reef, at the offshore spar buoy. Depth is 10.8 meters.	\N	point	-119.73012	34.39323	-119.73012	-119.73012	34.39323	34.39323	\N	\N	\N
MOHK	other	MOHK	California, USA	Mohawk Reef: Mohawk Reef depth ranges from 4.5m to 6.0 m. Reference on land is Mohawk Rd / Edgewater Way.	\N	point	-119.72957	34.3940708	-119.72957	-119.72957	34.3940708	34.3940708	\N	\N	\N
MOHK1	other	MOHK1	California, USA	Mohawk Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect has a bedrock substrate with some moderate relief (0-1.5 m) and some small (1-2 m) areas of silty sand / shell hash. Transect follows a reef ledge that is ~1-2m off the sand below. Depth is approximately 24 feet.	\N	point	-119.73	34.394333	-119.73	-119.73	34.394333	34.394333	-7.32	-7.32	meter
MOHK_1km_box	reef	Mohawk Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.7325	34.46973	-119.7375	-119.7275	34.3858	34.3995	\N	\N	\N
NI	other	Naples Inshore	California, USA	Naples Inshore	\N	point	-119.95053	34.42772	-119.95053	-119.95053	34.42772	34.42772	\N	\N	\N
NO	other	Naples Offshore	California, USA	Naples Offshore	\N	point	-119.95602	34.41305	-119.95602	-119.95602	34.41305	34.41305	\N	\N	\N
MOHK2	other	MOHK2	California, USA	Mohawk Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small (1-2 m) areas of silty sand. Transect follows a small reef ledge that is ~1m off the sand below. Depth is approximately 24 feet.	\N	point	-119.729367	34.39415	-119.729367	-119.729367	34.39415	34.39415	-7.32	-7.32	meter
MOHK3	other	MOHK3	California, USA	Mohawk Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 55 (degree). Bedrock substrate with some moderate relief (0-1.5 m) and some small (1-3 m) areas of silty sand. Transect follows a small reef ledge that is ~1.5m off the sand below. Depth is approximately 26 feet.	\N	point	-119.729483	34.3938	-119.729483	-119.729483	34.3938	34.3938	-7.92	-7.92	meter
MOHK4	other	MOHK4	California, USA	Mohawk Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 270 (degree). Runs west along bedrock substrate with low relief (0-1.5m) and some areas of silty sand. Depth approximately 25 feet.. Kelp continually cleared in 2m band on all sides of the transect.	\N	point	-119.729417	34.394	-119.729417	-119.729417	34.394	34.394	-7.4	-7.4	meter
MOHK_reef	reef	Mohawk Reef	California, USA	Mohawk Reef is located on the Santa Barbara Channel, east of Arroyo Burro Beach, Santa Barbara, CA. Depth range from 4.5m to 6.0 m	\N	polygon	-119.730003	34.3943291	-119.730003	-119.730003	34.3943291	34.3943291	\N	\N	\N
NAP	other	NAP	California, USA	 The reef is offshore from the community of Naples. Depth: 16.5 meters.	\N	point	-119.95032	34.42388	-119.95032	-119.95032	34.42388	34.42388	-16.5	0	meter
NAPL	other	NAPL	California, USA	Naples Reef is located on the Santa Barbara Channel near the community of Naples and Dos Pueblos Canyon, Santa Barbara County, CA. Depth ranges from -5.9 to -13.4 meters.	\N	point	-119.95154	34.4221216	-119.95154	-119.95154	34.4221216	34.4221216	\N	\N	\N
NAPL1	other	NAPL1	California, USA	Naples Transect 1: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 60 (degree). Transect begins at extreme western edge of Naples main reef. Bedrock substrate with some significant relief (0-2 m). Depth is approximately 25 feet.	\N	point	-119.952933	34.422333	-119.952933	-119.952933	34.422333	34.422333	-7.62	-7.62	meter
NAPL10	other	NAPL10	California, USA	Naples Transect 10: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some significant relief (0-2.5m). Transect crosses several ridges that run ~110-120 degrees. Depth is approximately 30â. Kelp continually cleared in 2m band on all sides of the transect.	\N	point	-119.951217	34.422033	-119.951217	-119.951217	34.422033	34.422033	-9.1	-9.1	meter
NAPL_1km_box	reef	Naples Reef lobster trap survey extent	California, USA	Approximate maximum bounding coordinates for lobster trap survey. Survey area covers a swath parallel to shore, from shoreline to the 15m isobath (approx 1km offshore). 	\N	point	-119.9575	34.46973	-119.96667	-119.94833	34.4233	34.4407	\N	\N	\N
NAPL2	other	NAPL2	California, USA	Naples Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some significant relief (0-2 m). Depth is approximately 25 feet.	\N	point	-119.952317	34.422467	-119.952317	-119.952317	34.422467	34.422467	-7.62	-7.62	meter
NAPL3	other	NAPL3	California, USA	Naples Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 80 (degree). Bedrock substrate with some significant relief (0-2 m). Depth approximately 25'.	\N	point	-119.9517	34.422367	-119.9517	-119.9517	34.422367	34.422367	-7.62	-7.62	meter
NAPL4	other	NAPL4	California, USA	Naples Transect 4: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). âDeep Cobble.â Located approximately 7 m south of the ridges that define the main reef. Depth is approximately 35 feet.	\N	point	-119.9519	34.4223	-119.9519	-119.9519	34.4223	34.4223	-10.67	-10.67	meter
NAPL5	other	NAPL5	California, USA	Naples Transect 5: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 100 (degree). Transect begins at the apex of the âhorseshoeâ on the first flat bench east of deep cobble. Bedrock substrate with some moderate relief (0-1.5 m). Depth is approximately 35 feet.	\N	point	-119.951283	34.421883	-119.951283	-119.951283	34.421883	34.421883	-10.67	-10.67	meter
NAPL6	other	NAPL6	California, USA	Naples Transect 6: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 105 (degree). Bedrock substrate with some significant relief (0-2 m). Depth increases from approximately 33 to 45 feet along transect.	\N	point	-119.950633	34.42195	-119.950633	-119.950633	34.42195	34.42195	-11.89	-11.89	meter
NAPL7	other	NAPL7	California, USA	Naples Transect 7: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Transect begins at the western end of âThree fingersâ where the reef begins to slope from east to west into deeper water. Bedrock substrate with some significant relief (0-2 m). Depth decreases from approximately 36 to 28 feet along transect.	\N	point	-119.951833	34.4219	-119.951833	-119.951833	34.4219	34.4219	-9.75	-9.75	meter
SanMarcosPass212	other	San Marcos Pass USFS Stn	California, USA	San Marcos Pass USFS Stn	\N	point	-119.8238889	34.51111111	-119.8238889	-119.8238889	34.51111111	34.51111111	\N	\N	\N
Santa Claus Lane Beach	other	Santa Claus Lane Beach	California, USA	Santa Claus Lane Beach	\N	point	-119.55158	34.40853	-119.55158	-119.55158	34.40853	34.40853	\N	\N	\N
NAPL8	other	NAPL8	California, USA	Naples Transect 8: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 100 (degree). Located on a prominent ridge (3 m relief). Bedrock substrate with some significant relief (0-2 m). Depth increases from approximately 33 to 45 feet along the transect.	\N	point	-119.950317	34.421833	-119.950317	-119.950317	34.421833	34.421833	-11.89	-11.89	meter
NAPL9	other	NAPL9	California, USA	Naples Transect 9: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 90 (degree). Bedrock substrate with some significant relief (0-2 m). Depth approximately 25 feet.	\N	point	-119.951217	34.42215	-119.951217	-119.951217	34.42215	34.42215	-7.62	-7.62	meter
NAPL_reef	reef	Naples Reef	California, USA	Naples Reef is located on the Santa Barbara Channel near the community of Naples and Dos Pueblos Canyon, Santa Barbara County, CA. Depth ranges from -5.9 to -13.4 meters.	\N	polygon	-119.950302	34.4239006	-119.949997	-119.949997	34.4239006	34.4239006	\N	\N	\N
Nojoqui236	other	Nojoqui Falls Park	California, USA	Nojoqui Falls Park	\N	point	-120.1777778	34.53388889	-120.1777778	-120.1777778	34.53388889	34.53388889	\N	\N	\N
NR	other	Naples Reef - near mooring site NAP	California, USA	Naples Reef - near mooring site NAP	\N	point	-119.95032	34.42385	-119.95032	-119.95032	34.42385	34.42385	\N	\N	\N
ocnbch	other	Ocean Beach, San Diego CA	California, USA	Ocean Beach, San Diego CA	\N	point	-117.25662	32.74914	-117.25662	-117.25662	32.74914	32.74914	\N	\N	\N
ON02	other	ON02, San Onofre Creek, San Onofre Creek at Highway 101 North culvert	California, USA	ON02, San Onofre Creek, San Onofre Creek at Highway 101 North culvert	\N	point	-120.28885	34.472	-120.28885	-120.28885	34.472	34.472	\N	\N	\N
pb1	other	Santa Barbara Channel offshore station pb1	California, USA	Santa Barbara Channel offshore station pb1	\N	point	-119.84067	34.39017	-119.84067	-119.84067	34.39017	34.39017	-55	-55	meter
pb2	other	Santa Barbara Channel offshore station pb2	California, USA	Santa Barbara Channel offshore station pb2	\N	point	-119.86267	34.3435	-119.86267	-119.86267	34.3435	34.3435	-252	-252	meter
pb3	other	Santa Barbara Channel offshore station pb3	California, USA	Santa Barbara Channel offshore station pb3	\N	point	-119.8845	34.29683	-119.8845	-119.8845	34.29683	34.29683	-403	-403	meter
pb4	other	Santa Barbara Channel offshore station pb4	California, USA	Santa Barbara Channel offshore station pb4	\N	point	-119.90633	34.25017	-119.90633	-119.90633	34.25017	34.25017	-522	-522	meter
pb5	other	Santa Barbara Channel offshore station pb5	California, USA	Santa Barbara Channel offshore station pb5	\N	point	-119.92833	34.2035	-119.92833	-119.92833	34.2035	34.2035	-538	-538	meter
pb6	other	Santa Barbara Channel offshore station pb6	California, USA	Santa Barbara Channel offshore station pb6	\N	point	-119.95017	34.15683	-119.95017	-119.95017	34.15683	34.15683	-440	-440	meter
pb7	other	Santa Barbara Channel offshore station pb7	California, USA	Santa Barbara Channel offshore station pb7	\N	point	-120.03333	34.08333	-120.03333	-120.03333	34.08333	34.08333	-83	-83	meter
PRZ	other	Prisoner's Harbor Pier, Santa Cruz Island (PRZ)	California, USA	North shore of Santa Cruz Island, Santa Barbara Channel Islands, California.	\N	point	-119.6843	34.0204	-119.6843	-119.6843	34.0204	34.0204	\N	\N	\N
PUR	nearshore	Purisima Point	California	Purisima (PUR) is located pproximately 3.5 km SSE of Purisima Point, California, USA, in rocky habitat 15 meters below Mean Sea Level (MSL).	\N	point	-120.6276	34.72602	-120.6276	-120.6276	34.72602	34.72602	-15	0	meter
QI	other	Arroyo Quemado Inshore	California, USA	Arroyo Quemado Inshore	\N	point	-120.11933	34.46843	-120.11933	-120.11933	34.46843	34.46843	\N	\N	\N
QM	other	Arroyo Quemado Reef1 - - at pre2005-mooring site AQM	California, USA	Arroyo Quemado Reef1 - - at pre2005-mooring site AQM	\N	point	-120.12057	34.46464	-120.12057	-120.12057	34.46464	34.46464	\N	\N	\N
QO	other	Arroyo Qmemado Offshore	California, USA	Arroyo Qmemado Offshore	\N	point	-120.11937	34.4614	-120.11937	-120.11937	34.4614	34.4614	\N	\N	\N
QR	other	Arroyo Quemado Reef - near pre2005 mooring site AQM	California, USA	Arroyo Quemado Reef - near pre2005 mooring site AQM	\N	point	-120.12005	34.46722	-120.12005	-120.12005	34.46722	34.46722	\N	\N	\N
Refugio State Beach	other	Refugio State Beach	California, USA	Refugio State Beach	\N	point	-120.07075	34.46293	-120.07075	-120.07075	34.46293	34.46293	\N	\N	\N
RG201	other	Refugio at State Park	California, USA	Refugio at State Park	\N	point	-120.076261	34.461853	-120.076261	-120.076261	34.461853	34.461853	\N	\N	\N
RG202	other	Refugio at Lower Aguacitos Ranch	California, USA	Refugio at Lower Aguacitos Ranch	\N	point	-120.07483	34.49122	-120.07483	-120.07483	34.49122	34.49122	\N	\N	\N
RG203	other	Refugio at Upper Aguacitos Ranch	California, USA	Refugio at Upper Aguacitos Ranch	\N	point	-120.07947	34.50856	-120.07947	-120.07947	34.50856	34.50856	\N	\N	\N
RG204	other	Refugio at Rancho La Scherpa	California, USA	Refugio at Rancho La Scherpa	\N	point	-120.05636	34.5303	-120.05636	-120.05636	34.5303	34.5303	\N	\N	\N
RMC	intertidal	Rancho Marino	California, USA	Rancho Marino (RMC) is in the rocky intertidal area near Cambria, CA. It is is part of the Univeristy of California Natural Reserve System	\N	point	-121.0928466	35.54030478	-121.0928466	-121.0928466	35.54030478	35.54030478	\N	\N	\N
RN01	other	Rincon Creek, Hwy 101 Culvert, North	California, USA	Rincon Creek, Hwy 101 Culvert, North	\N	point	-119.47794	34.3773	-119.47794	-119.47794	34.3773	34.3773	\N	\N	\N
RS02	other	RS02, Rattlesnake Creek, Rattlesnake at Las Canoas Bridge	California, USA	RS02, Rattlesnake Creek, Rattlesnake at Las Canoas Bridge	\N	point	-119.69222	34.45761111	-119.69222	-119.69222	34.45761111	34.45761111	\N	\N	\N
RZR	intertidal	Razors	California, USA	Razors (RZR) is in the rocky intertidal near Alegria Beach, located on the Hollister Ranch, between Gaviota and Point Conception	\N	point	-120.278178	34.46713695	-120.278178	-120.278178	34.46713695	34.46713695	\N	\N	\N
SANDIEGO	nearshore	San Diego nearshore ocean	California, USA	San Diego CA, may have multiple piers.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
TroutClub242	other	Trout Club	California, USA	Trout Club	\N	point	-119.8	34.48972222	-119.8	-119.8	34.48972222	34.48972222	\N	\N	\N
RINC_ws	land	Rincon Watershed	California, USA	Rincon Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
sbc-boilerplate-geoCov_SBC	other	Santa Barbara Coastal LTER bounding box	California, USA	The Santa Barbara Coastal LTER research area extends from Point Conception (W) to the mouth of the Santa Clara River (E) and from the Santa Ynez Mountains (N) to the north shores of the Channel Islands (S), California, USA	\N	rectangle	-119.865	34.2655	-120.475	-119.255	34	34.531	\N	\N	\N
sbc_boilerplate-geoCov_SBCHAN	other	Santa Barbara Channel	California, USA	Santa Barbara Channel: SBCHAN: The Channel is roughly defined on the north by the coastline of mainland California, USA, on the east by the outlet of the Santa Clara River, on the south by the Santa Barbara Channel Islands, and on the west by Point Arguello.	\N	rectangle	-120	34.25	-120.8	-119.2	33.9	34.6	-612	0	meter
SB_channel	offshore	Santa Barbara Channel	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
sbell	other	Ellwood Pier, Goleta CA	California, USA	Ellwood Pier, Goleta CA	\N	point	-119.92408	34.43085	-119.92408	-119.92408	34.43085	34.43085	\N	\N	\N
SBEngBldg234	other	Santa Barbara Co. FCD Eng. Bldg.	California, USA	Santa Barbara Co. FCD Eng. Bldg.	\N	point	-119.7	34.41666667	-119.7	-119.7	34.41666667	34.41666667	\N	\N	\N
SB_harbor	nearshore	Santa Barbara Harbor	California, USA	Santa Barbara Harbor is bounded by Stearns Wharf on the east and the harbor breakwater on the wes and south.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SBH_manual1	other	Santa Barbara Harbor Shore Station - approximate location.	California, USA	Santa Barbara Harbor Shore Station - approximate location.	\N	point	-119.687	34.41	-119.687	-119.687	34.41	34.41	\N	\N	\N
sbstwrf	other	Stearns Wharf, Santa Barbara CA	California, USA	Stearns Wharf, Santa Barbara CA	\N	point	-119.68493	34.40934	-119.68493	-119.68493	34.40934	34.40934	\N	\N	\N
SCBC_reef	reef	Santa Cruz Island, BC Point Reef	California, USA	Santa Cruz Island, north shore, Santa Barbara Channel Islands, CA	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCDI2	other	SCDI2	California, USA	Santa Cruz Island Diablo Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 305 (degree). Transect runs along rocky reef with patches of sand/shell debris and several large boulders. Depth is approximately 30 feet.	\N	point	-119.757633	34.058633	-119.757633	-119.757633	34.058633	34.058633	-9.14	-9.14	meter
SCDI3	other	SCDI3	California, USA	Santa Cruz Island Diablo Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 335 (degree). Transect runs along rocky reef with patches of sand/shell debris and several large boulders and ledges. Depth varies from approximately 43 to 50 feet.	\N	point	-119.757633	34.058667	-119.757633	-119.757633	34.058667	34.058667	-14.3	-14.3	meter
SCDI_reef	reef	Santa Cruz Island, Diablo Canyon Reef	California, USA	Diablo Reef is located the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.5 to -15 meters	\N	polygon	-119.7575	34.0587997	-119.7575	-119.7575	34.0587997	34.0587997	\N	\N	\N
SCLA_beach	beach	Santa Claus Lane Beach	California, USA	\N	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCLBA	other	Santa Claus Lane Beach	California, USA	Santa Claus Lane Beach	\N	point	-119.551583	34.408533	-119.551583	-119.551583	34.408533	34.408533	\N	\N	\N
SCTE_reef	reef	Santa Cruz Island, Twin Harbors East reef	California, USA	Twin Harbors East Reef, north shore of Santa Cruz Island, Santa Barbara Channel Islands, CA.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SCTW2	other	SCTW2	California, USA	Santa Cruz Island Twin Harbors West Transect 2: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 330 (degree). Transect 2 lies along rocky reef with large boulders and patches of sand/shell debris. Depth is approximately 20'.	\N	point	-119.715133	34.0444	-119.715133	-119.715133	34.0444	34.0444	-6.1	-6.1	meter
SCTW3	other	SCTW3	California, USA	Santa Cruz Island Twin Harbors West Transect 3: a line starting at the lat-lon coordinates with a length of 40 (meter), and width of 2 (meter) along a heading of 290 (degree). Transect 3 lies along rocky reef with large boulders and patches of sand/shell debris. Depth is approximately 30 feet. At the end of the transect there is a pinnacle about 3-4m tall.	\N	point	-119.715133	34.044467	-119.715133	-119.715133	34.044467	34.044467	-12	-12	meter
SCTW_reef	reef	Santa Cruz Island, Twin Harbor West reef	California, USA	Twin Harbor West Reef is located on the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.0 to -15 meters. Twin Harbor West Reef is located on the north shore of Santa Cruz Island, in the Santa Barbara Channel Islands, CA. Depth ranges from -3.0 to -15 meters. 	\N	polygon	-119.7155	34.0444984	-119.7155	-119.7155	34.0444984	34.0444984	\N	\N	\N
sio	other	Scripps Peir, San Diego CA	California, USA	Scripps Peir, San Diego CA	\N	point	-117.25647	32.85039	-117.25647	-117.25647	32.85039	32.85039	\N	\N	\N
SM01	other	Santa Monica Creek, Via Real	California, USA	Santa Monica Creek, Via Real	\N	point	-119.52869	34.40479765	-119.52869	-119.52869	34.40479765	34.40479765	\N	\N	\N
SM04	other	Santa Monica at Scoop	California, USA	Santa Monica at Scoop	\N	point	-119.52701	34.41898512	-119.52701	-119.52701	34.41898512	34.41898512	\N	\N	\N
SMN	other	San Miguel Island, North (SMN)	California, USA	North shore of San Migule Island, Santa Barbara Channel Islands, California.	\N	point	-120.3455	34.057	-120.3455	-120.3455	34.057	34.057	\N	\N	\N
South UCSB Campus Beach	other	South UCSB Campus Beach	California, USA	South UCSB Campus Beach	\N	point	-119.84603	34.40548	-119.84603	-119.84603	34.40548	34.40548	\N	\N	\N
SP02	other	San Pedro Creek at Stow Canyon Park, , USGS 11120520	California, USA	San Pedro Creek at Stow Canyon Park, , USGS 11120520	\N	point	-119.84028	34.44861	-119.84028	-119.84028	34.44861	34.44861	\N	\N	\N
StanwoodFS228	other	Stanwood Fire Station	California, USA	Stanwood Fire Station	\N	point	-119.6833333	34.45	-119.6833333	-119.6833333	34.45	34.45	\N	\N	\N
TE03	other	Tecolotito Creek, Hollister Road	California, USA	Tecolotito Creek, Hollister Road	\N	point	-119.85762	34.43055	-119.85762	-119.85762	34.43055	34.43055	\N	\N	\N
temp_fk	reef	temp_fk	California, USA	Temporary, so bulk upload can reference it	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
TO02	other	TO02, Tecolote Creek at Vereda Galeria, Goleta	California, USA	TO02, Tecolote Creek at Vereda Galeria, Goleta	\N	point	-119.917915	34.440614	-119.917915	-119.917915	34.440614	34.440614	\N	\N	\N
SCDI	other	SCDI	California, USA	Santa Cruz Island, Diablo	\N	point	-119.75763	34.05865	-119.75763	-119.75763	34.05865	34.05865	\N	\N	\N
SCLB	other	SCLB	California, USA	Santa Claus Lane Beach	\N	point	-119.551583	34.408533	-119.551583	-119.551583	34.408533	34.408533	\N	\N	\N
SCTW	other	SCTW	California, USA	Santa Cruz Island, Twin Harbor West	\N	point	-119.7155	34.0445	-119.71513	-119.71513	34.0444335	34.0444335	\N	\N	\N
twin_e	other	Twin E	California, USA	Twin Harbors, East. North shore, Santa Cruz Island, CA	\N	point	-119.7140833	34.04345	-119.7140833	-119.7140833	34.04345	34.04345	-30	-30	Foot_US
twin_w	other	Twin W	California, USA	Twin Harbors, West. North shore, Santa Cruz Island, CA	\N	point	-119.7151333	34.0444	-119.7151333	-119.7151333	34.0444	34.0444	-30	-30	Foot_US
UCSB200	other	UCSB200	California, USA	UCSB200: Santa Barbara County Public Works Department Flood Control District Site at: Ellison Hall Roof, UC Santa Barbara	\N	point	-119.8461111	34.415	-119.8461111	-119.8461111	34.415	34.415	30.5	30.5	meter
UCSB_beach	beach	UC Santa Barbara Beach	California, USA	Univeristy of California, Santa Barbara. Area sometimes called Campus Point.	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
UCSB_msi	other	UC Santa Barbara, Marine Science Institute	California, USA	Marine Science Institute, Univeristy of California, Santa Barbara	\N	point	-119.842	34.4125	-119.842	-119.842	34.4125	34.4125	\N	\N	\N
geocov_ds74	other	Central and Southern California (USA) 	California, USA	Coastal areas along the mainland from near Año Nuevo (San Mateo County) in the north to San Diego in the south. Coastal areas of the eight Northern and Southern Channel Islands	\N	rectangle	-118	32.5	-122.7832345	-114.04476	32.3750	37.94752509	\N	\N	\N
Carpinteria State Beach	other	Carpinteria State Beach	California, USA	Carpinteria State Beach	\N	point	-119.521236	34.391151	-119.521236	-119.521236	34.391151	34.391151	\N	\N	\N
EBCH	other	East Santa Barbara City Beach	California, USA	East Santa Barbara City Beach	\N	point	-119.674178	34.415751	-119.674178	-119.674178	34.415751	34.415751	\N	\N	\N
PF_B	offshore	Platform B	California, USA	Platform B in Santa Barbara Channel	\N	point	-119.6215	34.3323	-119.6215	-119.6215	34.3323	34.3323	\N	\N	\N
PF_GINA	offshore	Platform Gina	California, USA	Platform Gina in Santa Barbara Channel	\N	point	-119.2762	34.1174	-119.2762	-119.2762	34.1174	34.1174	\N	\N	\N
glider1	other	glide range	California, USA	Santa Barbara Channel	\N	point	-119.73	34.3918	-119.73	-119.73	34.3918	34.3918	\N	\N	\N
glider2	other	glide range	California, USA	Santa Barbara Channel	\N	point	-119.73	34.3541	-119.73	-119.73	34.3541	34.3541	\N	\N	\N
ABUR_beach	beach	Arroyo Burro Beach	California, USA	Arroyo Burro Beach	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
BELL_ws	land	Bell Canyon Creek watershed	California, USA	Bell Canyon Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
CARP_ws	land	Carpinteria watershed	California, USA	Carpinteria watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
FRANK_ws	land	Franklin Creek Watershed	California, USA	Franklin Creek Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
GAV_nearsh	nearshore	Gaviota 	California, USA	Gaviota 	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
MISS_ws	land	Mission Creek watershed	California, USA	Mission Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
REFU_ws	land	Refugio Creek Watershed	California, USA	Refugio Creek Watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SMON_ws	land	Santa Monica Creed watershed	California, USA	Santa Monica Creed watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SPED_ws	land	San Pedro Creek watershed	California, USA	San Pedro Creek watershed	\N	polygon	\N	\N	\N	\N	\N	\N	\N	\N	\N
SPLV	land	SPLV	California, USA	San Pedro /Las Vegas	\N	point	-119.831846	34.435445	-119.831846	-119.831846	34.435445	34.435445	\N	\N	\N
GATE	land	GATE	California, USA	Glen Annie/Tecolotito	\N	point	-119.859153	34.432219	-119.859153	-119.859153	34.432219	34.432219	\N	\N	\N
MISS_rapid	land	MICR	California, USA	Mission Creek watershed	\N	point	-119.6799000	34.4075667	-119.6799000	-119.6799000	34.4075667	34.4075667	\N	\N	\N
AB00	other	AB00	California, USA	Arroyo Burro, Arroyo Burro at Cliff Drive	\N	point	-119.74021	34.40505027	-119.74021	-119.74021	34.40505027	34.40505027	\N	\N	\N
ABURE	land	ABURE	California, USA	Arroyo Burro Estuary	\N	point	-119.742856	34.403974 	-119.742856	-119.742856	34.403974 	34.403974 	\N	\N	\N
ABUR_rapid	land	ABUR	California, USA	Arroyo Burro	\N	point	-119.7434833	34.3965167	-119.7434833	-119.7434833	34.3965167	34.3965167	\N	\N	\N
AHON_reef1	reef	AHND	California, USA	Arroyo Hondo Reef	\N	point	-120.140917 	34.479167	-120.140917 	-120.140917 	34.479167	34.479167	\N	\N	\N
AQUE_reef1	reef	AQUE	California, USA	Arroyo Quemado Reef.	\N	polygon	-120.131667	34.469183	-120.131667	-120.131667	34.469183	34.469183	\N	\N	\N
ATMY	other	ATMY	California, USA	Atascadero Creek, Atascadero	\N	point	-119.810785	34.424719	-119.810785	-119.810785	34.424719	34.424719	\N	\N	\N
GOLB_reef1	reef	GOLB	California, USA	Goleta Bay reef	\N	point	-119.824167	34.408783	-119.824167	-119.824167	34.408783	34.408783	\N	\N	\N
GOSL	reef	GOSL	California, USA	Goleta Slough	\N	point	-119.827594	34.418475	-119.827594	-119.827594	34.418475	34.418475	\N	\N	\N
IVEE_reef1	reef	IVEE	California, USA	Isla Vista (IV) Reef	\N	point	-119.865233	34.403633	-119.865233	-119.865233	34.403633	34.403633	\N	\N	\N
MOHK_rapid	other	MOHK	California, USA	Mohawk	\N	point	-119.7280833	34.3875167	-119.7280833	-119.7280833	34.3875167	34.3875167	\N	\N	\N
REFU_rapid	other	REFU	California, USA	Refugio	\N	point	 -120.0700000	\t34.4572000	 -120.0700000	 -120.0700000	\t34.4572000	\t34.4572000	\N	\N	\N
GV01	other	 Gaviota Creek	California, USA	GV01, Gaviota Creek, Gaviota at Hwy 101 South Rest Stop Exit	\N	point	-120.22917	34.4855	-120.22917	-120.22917	34.4855	34.4855	\N	\N	\N
MC00	other	MC00	California, USA	Mission Creek, Mission at Montecito St	\N	point	-119.69499	34.41307303	-119.69499	-119.69499	34.41307303	34.41307303	\N	\N	\N
RG01	other	RG01	California, USA	Refugio Creek, Refugio at Hwy 101 Bridge	\N	point	-120.06932	34.46573164	-120.06932	-120.06932	34.46573164	34.46573164	\N	\N	\N
BC02	other	BC02	California, USA	Bell Canyon Creek, Bell Canyon Creek at Winchester Canyon Road culvert	\N	point	-119.90563	34.43854	-119.90563	-119.90563	34.43854	34.43854	\N	\N	\N
GV01_rapid	other	GV01	California, USA	Gaviota Creek, Gaviota at Hwy 101 South Rest Stop Exit	\N	point	-120.229285	34.473572	-120.229285	-120.229285	34.473572	34.473572	\N	\N	\N
CHACR	reef	CHACR	California, USA	CHALK CAMP RIGHT	\N	point	-118.490217	33.443967	-118.490217	-118.490217	33.443967	33.443967	\N	\N	\N
CHACL	reef	CHACL	California, USA	CHALK CAMP LEFT	\N	point	-118.490217	33.443967	-118.490217	-118.490217	33.443967	33.443967	\N	\N	\N
BFCSR	reef	BFCSR	California, USA	BIG FISHERMAN COVE SOUTH RIGHT	\N	point	-118.486383	33.444367	-118.486383	-118.486383	33.444367	33.444367	\N	\N	\N
BFCSL	reef	BFCSL	California, USA	BIG FISHERMAN COVE SOUTH LEFT	\N	point	-118.486383	33.444367	-118.486383	-118.486383	33.444367	33.444367	\N	\N	\N
LCR	reef	LCR	California, USA	LULU COVE RIGHT	\N	point	-118.506733	33.454367	-118.506733	-118.506733	33.454367	33.454367	\N	\N	\N
LCL	reef	LCL	California, USA	LULU COVE LEFT	\N	point	-118.5061	33.454317	-118.5061	-118.5061	33.454317	33.454317	\N	\N	\N
IRR	reef	IRR	California, USA	ISTHMUS REEF RIGHT	\N	point	-118.4903	33.447867	-118.4903	-118.4903	33.447867	33.447867	\N	\N	\N
IRL	reef	IRL	California, USA	ISTHMUS REEF LEFT	\N	point	-118.4903	33.447867	-118.4903	-118.4903	33.447867	33.447867	\N	\N	\N
CRACL	reef	CRACL	California, USA	CRACK COVE LEFT	\N	point	-118.50358	33.453417	-118.50358	-118.50358	33.453417	33.453417	\N	\N	\N
CRACR	reef	CRACR	California, USA	CRACK COVE RIGHT	\N	point	-118.50358	33.453417	-118.50358	-118.50358	33.453417	33.453417	\N	\N	\N
LH	reef	LH	California, USA	LION HEAD	\N	point	-118.501583	33.453433	-118.501583	-118.501583	33.453433	33.453433	\N	\N	\N
BRE	reef	BRE	California, USA	BIRD ROCK EAST	\N	point	-118.4865	33.45025	-118.4865	-118.4865	33.45025	33.45025	\N	\N	\N
CHECW	reef	CHECW	California, USA	CHERRY COVE WEST	\N	point	-118.501783	33.453367	-118.501783	-118.501783	33.453367	33.453367	\N	\N	\N
IP	reef	IP	California, USA	INTAKE PIPES	\N	point	-118.4851	33.4469	-118.4851	-118.4851	33.4469	33.4469	\N	\N	\N
IR	reef	IR	California, USA	ISTHMUS REEF	\N	point	-118.4903	33.447867	-118.4903	-118.4903	33.447867	33.447867	\N	\N	\N
PC	reef	PC	California, USA	PUMPERNICKEL COVE	\N	point	-118.479017	33.447916	-118.479017	-118.479017	33.447916	33.447916	\N	\N	\N
SRE	reef	SRE	California, USA	SHIP ROCK EAST	\N	point	-118.49182	33.46285	-118.49182	-118.49182	33.46285	33.46285	\N	\N	\N
CHAC	reef	CHAC	California, USA	CHALK CAMP	\N	point	-118.490217	33.443967	-118.490217	-118.490217	33.443967	33.443967	\N	\N	\N
HP	reef	HP	California, USA	HABITAT REEF	\N	point	-118.487933	33.444767	-118.487933	-118.487933	33.444767	33.444767	\N	\N	\N
IPL	reef	IPL	California, USA	INTAKE PIPES LEFT	\N	point	-118.4851	33.4469	-118.4851	-118.4851	33.4469	33.4469	\N	\N	\N
BFCNR	reef	BFCNR	California, USA	BIG FISHERMAN COVE NORTH RIGHT	\N	point	-118.484733	33.445317	-118.484733	-118.484733	33.445317	33.445317	\N	\N	\N
BFCNL	reef	BFCNL	California, USA	BIG FISHERMAN COVE NORTH LEFT	\N	point	-118.484733	33.445317	-118.484733	-118.484733	33.445317	33.445317	\N	\N	\N
IPR	reef	IPR	California, USA	INTAKE PIPES RIGHT	\N	point	-118.4851	33.4469	-118.4851	-118.4851	33.4469	33.4469	\N	\N	\N
CHECER	reef	CHECER	California, USA	CHERRY COVE EAST RIGHT	\N	point	-118.49955	33.449533	-118.49955	-118.49955	33.449533	33.449533	\N	\N	\N
FJCW	reef	FJCW	California, USA	FOURTH OF JULY COVE WEST	\N	point	-118.499583	33.447917	-118.499583	-118.499583	33.447917	33.447917	\N	\N	\N
FJCER	reef	FJCER	California, USA	FOURTH OF JULY COVE EAST RIGHT	\N	point	-118.49805	33.44595	-118.49805	-118.49805	33.44595	33.44595	\N	\N	\N
FJCEL	reef	FJCEL	California, USA	FOURTH OF JULY COVE EAST LEFT	\N	point	-118.49805	33.44595	-118.49805	-118.49805	33.44595	33.44595	\N	\N	\N
BRWR	reef	BRWR	California, USA	BIRD ROCK WEST RIGHT	\N	point	-118.48805	33.451117	-118.48805	-118.48805	33.451117	33.451117	\N	\N	\N
BRWL	reef	BRWL	California, USA	BIRD ROCK WEST LEFT	\N	point	-118.488	33.451967	-118.488	-118.488	33.451967	33.451967	\N	\N	\N
BRER	reef	BRER	California, USA	BIRD ROCK EAST RIGHT	\N	point	-118.486483	33.450217	-118.486483	-118.486483	33.450217	33.450217	\N	\N	\N
BREL	reef	BREL	California, USA	BIRD ROCK EAST LEFT	\N	point	-118.4865	33.45025	-118.4865	-118.4865	33.45025	33.45025	\N	\N	\N
WR	reef	WR	California, USA	WHALE ROCK	\N	point	-118.605733	33.4792	-118.605733	-118.605733	33.4792	33.4792	\N	\N	\N
GR	reef	GR	California, USA	GREEN ROCK	\N	point	-118.597783	33.477733	-118.597783	-118.597783	33.477733	33.477733	\N	\N	\N
LBR	reef	LBR	California, USA	LORENZO BEACH RIGHT	\N	point	-118.569833	33.476017	-118.569833	-118.569833	33.476017	33.476017	\N	\N	\N
LBL	reef	LBL	California, USA	LORENZO BEACH LEFT	\N	point	-118.56855	33.4755	-118.56855	-118.56855	33.4755	33.4755	\N	\N	\N
AP	reef	AP	California, USA	ARROW POINT	\N	point	-118.538933	33.47675	-118.538933	-118.538933	33.47675	33.47675	\N	\N	\N
PL	reef	PL	California, USA	PARSONS LANDING	\N	point	-118.55475	33.474583	-118.55475	-118.55475	33.474583	33.474583	\N	\N	\N
HL	reef	HL	California, USA	HOWLAND LANDING	\N	point	-118.522083	33.465833	-118.522083	-118.522083	33.465833	33.465833	\N	\N	\N
CHECE	reef	CHECE	California, USA	CHERRY COVE EAST	\N	point	-118.499367	33.449233	-118.499367	-118.499367	33.449233	33.449233	\N	\N	\N
CHECEL	reef	CHECEL	California, USA	CHERRY COVE EAST LEFT	\N	point	-118.499367	33.449233	-118.499367	-118.499367	33.449233	33.449233	\N	\N	\N
SRW	reef	SRW	California, USA	SHIP ROCK WEST	\N	point	-118.49175	33.463383	-118.49175	-118.49175	33.463383	33.463383	\N	\N	\N
\.







--
-- TOC entry 3174 (class 0 OID 130221)
-- Dependencies: 178
-- Data for Name: DataSet; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSet" ("DataSetID", "Accession", "Title", "Investigator", "DataSetType", "Georeferences", "SubmitDate", "Abstract", "Status", "ProjectRelease", "PublicRelease", "geographicDescription") FROM stdin;
99054	\N	SBC LTER: TEST: Giant kelp canopy biomass from Landsat, 1982 - 2011	kcavanaugh	\N	f	\N	abstract.99054.docx	\N	\N	\N	\N
99024	\N	SBC LTER: TEST: kelp CHN	dreed	\N	f	\N	abstract.99024.docx	\N	\N	\N	\N
99013	\N	SBC LTER: TEST: Water temperature at the bottom	dreed	\N	f	\N	abstract.99013.docx	\N	\N	\N	\N
99021	\N	SBC LTER: TEST: NPP dataset with 3 tables	dreed	\N	f	\N	abstract.99021.docx	\N	\N	\N	\N
\.



--
-- TOC entry 3179 (class 0 OID 130262)
-- Dependencies: 183
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
-- TOC entry 3176 (class 0 OID 130243)
-- Dependencies: 180
-- Data for Name: DataSetEntities; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetEntities" ("DataSetID", "SortOrder", "EntityName", "EntityType", "EntityDescription", "EntityRecords", "FileType", "Urlhead", "Subpath", "FileName", "DataAnomalies") FROM stdin;
99054	102	UCSB kelp timeseries video	otherEntity	Movie: time series of kelp canopy distribution near UC Santa Barbara, 1984 - 2009	\N	mov_A	http://sbc.lternet.edu/external/Reef/Data/	kelp_biomass_landsat/	ucsb_kelp_ts.mov	\N
99054	101	Kelp biomass, Landsat	dataTable	Kelp Biomass from Landsat	44930474	csv_A	http://sbc.lternet.edu/external/Reef/Data/	kelp_biomass_landsat/	kelp_biomass_landsat.zip	<para>The text table is 1.6 gb, and has been compressed to 365 mb for download.</para>
99013	1	bottom_temp_all_years_20120626.csv	dataTable	continuous temperature at permanent reef sites	10	csv_D	http://sbc.lternet.edu/external/Reef/Data/Bottom_Temperature/	\N	bottom_temp_all_years_20120626.csv	\N
99021	3	Census_of_fronds_on_marked_plants_20120613.csv	dataTable	Census of fronds on marked plants	20	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	Census_of_fronds_on_marked_plants_20120613.csv	\N
99021	1	M_pyrifera_net_primary_production_and_growth_20120614.csv	dataTable	Macrocystis pyrifera net primary production and growth	30	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	M_pyrifera_net_primary_production_and_growth_20120614.csv	\N
99021	2	M_pyrifera_standing_crop_plant_density_and_loss_rates_20120614.csv	dataTable	Macrocystis pyrifera standing crop, plant density and loss rates	40	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	M_pyrifera_standing_crop_plant_density_and_loss_rates_20120614.csv	\N
99024	1	CHN_all_years.csv	dataTable	Macrocystis pyrifera CHN data	50	csv_D	http://sbc.lternet.edu/external/Reef/Data/Kelp_NPP/	\N	CHN_all_years.csv	\N
\.


--
-- TOC entry 3175 (class 0 OID 130230)
-- Dependencies: 179
-- Data for Name: DataSetAttributes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetAttributes" ("DataSetID", "EntitySortOrder", "ColumnPosition", "ColumnName", "AttributeID", "AttributeLabel", "Description", "StorageType", "MeasurementScaleDomainID", "FormatString", "PrecisionDateTime", "TextPatternDefinition", "Unit", "PrecisionNumeric", "NumberType", "MissingValueCode", "missingValueCodeExplanation", minimum, maximum) FROM stdin;
99021	1	2	year	year	Year	Year of collection	string	dateTime	YYYY	1	\N	\N	\N	\N	-99999	no information available	\N	\N
99054	101	3	date_utc	date_utc	Date UTC	Date of measurement, Universal Time Coordinate	date	dateTime	YYYYMMDD	1	\N	\N	\N	\N	\N	\N	\N	\N
99013	1	1	date	date	Date	date	date	dateTime	MM/DD/YYYY	1	\N	\N	\N	\N	-99999	value not recorded or not available	1/1/2000	1/1/2100
99013	1	2	time	time	time	time	string	dateTime	hh:mm:ss	1	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	3	temp_c	temp_c	Temperature C	water temperature	float	interval	\N	\N	\N	celsius	0.0100000000000000002	real	-99999	value not recorded or not available	5	20
99013	1	4	serial	serial	Serial Number	Serial number of instrument used for observation. Instruments: 32K StowAway TidbiT (-5 deg C to 37 deg C) manufactured by Onset Computer Corporation.	integer	nominalText	\N	\N	integer as text	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	5	site_code	site_code	Site	Name of field site. Depth of temperature logger at each site varies from 4.95 to 8.15 meters. See enumerated list for site-specific depths.	string	nominalEnum	\N	\N	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	6	fake_xsect_code	fake_xsect_code	Fake transect code	this is a fake col to test ordinalenum	string	ordinalEnum	\N	\N	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	7	fake_ord_text	fake_ord_text	Fake ordinal text field	this is a test field	string	ordinalText	\N	\N	any text	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	8	fake-temp	fake-temp	Temperature fake	this is fake	float	ratio	\N	\N	\N	kelvin	0.100000000000000006	real	-99999	value not recorded or not available	273	373
99013	1	9	fake temp	fake temp	asdf	asdf	float	ratio	\N	\N	\N	kelvin	0.100000000000000006	real	\N	\N	\N	\N
99013	1	10	fake_col_w_taxonCov	fake_col_w_taxonCov	Fake taxa	this is a fake col to test this is a fake column. string field	string	nominalText	\N	\N	any text	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	20	Density	Density	Density	For all except MAPY: Average number of individuals present per square meter of transect. For MAPY (M. pyrifera): Average number of fronds present per square meter of transect.	float	ratio	\N	\N	\N	numberPerMeterSquared	0.0100000000000000002	real	-99999	value not recorded or not available	\N	\N
99013	1	21	Cover	Cover	Percent Cover	Percent cover estimated from Uniform Point Contact observations as the fraction of total points at which that species was present out of 80 points x 100.	float	ratio	\N	\N	\N	percent	0.0100000000000000002	real	-99999	value not recorded or not available	\N	\N
99013	1	22	MeanDry	MeanDry	Average Dry Mass	Average dry mass (g per individual) for taxa with abundance reported as density derived from field allometric measurements and lab-derived relationships.	float	ratio	\N	\N	\N	gram	0.0100000000000000002	real	-99999	value not recorded or not available	\N	\N
99013	1	23	OBS_CODE	OBS_CODE	Observer Code	Numeric code indicating the SBCLTER data collector	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N	\N	\N
99013	1	24	NOTES	NOTES	Notes	Text annotations to data observations	string	nominalText	\N	\N	any text	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99013	1	104	frondlength	frondlength	Frond length	Total length of sample frond sample blade is on, in meters (frond = stipe plus all blades)	decimal	ratio	\N	\N	\N	meter	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	109	totalblades	totalblades	Total blades	Total number of blades on the frond	integer	ratio	\N	\N	\N	number	1	integer	\N	\N	\N	\N
99013	1	207	LMA	LMA	Blade wet mass density	Blade wet mass per unit area (mg/cm2)	decimal	ratio	\N	\N	\N	milligramPerCentimeterSquared	0.00100000000000000002	real	\N	\N	\N	\N
99013	1	208	ChA	ChA	Blade Chla content	Blade Chlorophyll a content (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	209	ChC	ChC	Blade Chlc content	Blade Chlorophyll c content (ug/cm2) 	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	210	FX	FX	Blade fucoxanthin content	Blade Fucoxanthin content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	305	frondcondition	frondcondition	Frond condition	Growth stage of plant (TO DO FROND?) from which sample was taken, either growing or terminal	string	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99013	1	307	length	length	Blade length	Total blade length TO DO: Maximum blade length? (per Dan's note)	decimal	ratio	\N	\N	\N	centimeter	0.100000000000000006	real	\N	\N	\N	\N
99013	1	308	width	width	Blade width	Width of sample blade at widest point	decimal	ratio	\N	\N	\N	centimeter	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	309	wetmass	wetmass	Blade wet mass	Area-specific wet mass (g/cm2)	decimal	ratio	\N	\N	\N	gramPerCentimeterSquared	0.00100000000000000002	real	\N	\N	\N	\N
99013	1	3010	drymass	drymass	Blade dry mass	Area specific dry mass (g/cm2)	decimal	ratio	\N	\N	\N	gramPerCentimeterSquared	1.00000000000000006e-09	real	\N	\N	\N	\N
99013	1	3013	ChlC	ChlC	Blade Chlc content	Blade Chlorophyll c content (ug/cm2) 	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	3014	FX_table3	FX_table3	Blade fucoxanthin content	Blade Fucoxanthin content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.0100000000000000002	real	\N	\N	\N	\N
99013	1	3015	carbon	carbon	Blade carbon content	Blade carbon content  (ug/cm2)	decimal	ratio	\N	\N	\N	microgramPerCentimeterSquared	0.100000000000000006	real	\N	\N	\N	\N
99013	1	3044	frondlength_t3	frondlength_t3	Frond length	Total length of sample frond sample blade is on (frond = stipe plus all blades)	decimal	ratio	\N	\N	\N	meter	0.25	real	\N	\N	\N	\N
99021	1	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	-99999	no information available	\N	\N
99021	1	3	season	season	Season	Season (winter, spring, summer and autumn as defined by the winter solstice, spring equinox, summer solstice and autumnal equinox) in which the site is sampled.	string	nominalText	\N	\N	any text	\N	\N	\N	-99999	no information available	\N	\N
99021	1	4	NPP_wet	NPP_wet	NPP Wet	The seasonal rate of M. pyrifera biomass production in units of wet mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	5	NPP_dry	NPP_dry	NPP Dry	The seasonal rate of M. pyrifera biomass production in units of dry mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	6	NPP_carbon	NPP_carbon	NPP Carbon	The seasonal rate of M. pyrifera biomass production in units of carbon mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	7	NPP_nitrogen	NPP_nitrogen	NPP Nitrogen	The seasonal rate of M. pyrifera biomass production in units of nitrogen mass (kg m-2 day-1). This variable is calculated by integrating the instantaneous rate of production during each period and dividing by the number of days (as described in Section I.B Equation 2). Production for all days in each season is averaged.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	8	Growth_rate_wet	Growth_rate_wet	Growth rate, wet	The seasonal growth rate of M. pyrifera wet mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	9	Growth_rate_dry	Growth_rate_dry	Growth rate, dry	The seasonal growth rate of M. pyrifera dry mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	10	Growth_rate_carbon	Growth_rate_carbon	Growth rate, carbon	The seasonal growth rate of M. pyrifera carbon mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	11	Growth_rate_nitrogen	Growth_rate_nitrogen	Growth rate, nitrogen	The seasonal growth rate of M. pyrifera nitrogen mass (day-1). This variable is calculated as the growth rate necessary to explain the observed change in biomass during each period, given the initial biomass and the independently measured loss rates (see Section I.B Equation 1). Growth rates for all days in each season are averaged.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	12	SE_NPP_wet	SE_NPP_wet	Std error, NPP wet	The standard error in our estimate of NPP in units of wet mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	13	SE_NPP_dry	SE_NPP_dry	Ste error, NPP dry	The standard error in our estimate of NPP in units of dry mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	14	SE_NPP_carbon	SE_NPP_carbon	Std error, NPP carbon	The standard error in our estimate of NPP in units of carbon mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	15	SE_NPP_nitrogen	SE_NPP_nitrogen	St error, NPP nitrogen	The standard error in our estimate of NPP in units of nitrogen mass (kg m-2 d-1). This error is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. It incorporates errors in our estimates of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquaredPerDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	16	SE_growth_rate_wet	SE_growth_rate_wet	Std error, growth rate wet	The standard error in our estimate of the growth rate of wet mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	17	SE_growth_rate_dry	SE_growth_rate_dry	Std error, growth rate dry	The standard error in our estimate of the growth rate of dry mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	18	SE_growth_rate_carbon	SE_growth_rate_carbon	Std error, growth rate carbon	The standard error in our estimate of the growth rate of carbon mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	1	19	SE_growth_rate_nitrogen	SE_growth_rate_nitrogen	Std error, growth rate nitrogen	The standard error in our estimate of the growth rate of nitrogen mass (day-1). These data are produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in our estimate of growth incorporates errors in our calculations of biomass, plant loss rates and frond loss rates.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	2	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	-99999	no information available	\N	\N
99021	2	2	date	date	date	Date of collection	string	dateTime	YYYY-MM-DD	1	\N	\N	\N	\N	-99999	no information available	\N	\N
99021	2	3	FSC_wet	FSC_wet	FSC Wet	The wet mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the wet mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total wet mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	integer	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	4	FSC_dry	FSC_dry	FSC Dry	The dry mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the dry mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total dry mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	5	FSC_carbon	FSC_carbon	FSC Carbon	The carbon mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the carbon mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total carbon mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	6	FSC_nitrogen	FSC_nitrogen	FSC Nitrogen	The nitrogen mass of the foliar standing crop of M. pyrifera (kg m-2, excluding sporophylls and holdfast). These data are obtained by first calculating the nitrogen mass of each plant, using methods detailed in Section I.B Measuring standing crop, and then dividing the total nitrogen mass of all plants in the plot by the area of the plot. Plants without at least one frond longer than 1m are excluded.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	7	Frond_density	Frond_density	Frond Density	The density of M. pyrifera fronds in the plot (number m-2).	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	8	Plant_density	Plant_density	Plant Density	The density of M. pyrifera plants in the plot (number m-2). Only plants with at least one frond greater than 1m are counted.mv	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	9	Plant_loss_rate	Plant_loss_rate	Plant Density	The loss rate of M. pyrifera plants during the sampling interval (fraction of plants lost day-1). These data are based on losses of 10 to15 tagged plants, as described in Section I.B Measuring loss rate.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	2	10	Frond_loss_rate	Frond_loss_rate	Frond loss rate	The average loss rate of fronds during the sampling interval (fraction of fronds lost day-1). These data are the mean loss rate of tagged fronds from 10 to15 tagged plants, as described in Section I.B Measuring loss rate. The mean is based on frond loss from plants that survive the period; losses of whole plants are accounted for in the plant loss rate.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	2	11	SE_FSC_wet	SE_FSC_wet	SE FSC Wet	The standard error in our estimate of foliar standing crop in units of wet mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in wet mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass conversion ratio	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	12	SE_FSC_dry	SE_FSC_dry	SE FSC Dry	The standard error in our estimate of foliar standing crop in units of dry mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in section I.B Quantifying Uncertainty. The error in dry mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass and wet-mass:dry-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99054	101	4	biomass	biomass	Biomass	wet weight (kg) of kelp canopy in the pixel (900 meter squared)	float	ratio	\N	\N	\N	kilogram	1	real	-998	no measurement available, satellite view obscured by clouds	\N	\N
99021	2	13	SE_FSC_carbon	SE_FSC_carbon	SE FSC Carbon	The standard error in our estimate of foliar standing crop in units of carbon mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in carbon mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass, wet-mass:dry-mass and dry-mass:carbon-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	14	SE_FSC_nitrogen	SE_FSC_nitrogen	SE FSC Nitrogen	The standard error in our estimate of foliar standing crop in units of nitrogen mass (kg m-2). This estimate is produced using Monte Carlo methods, as described in Section I.B Quantifying Uncertainty. The error in nitrogen mass includes two types of error. Observer error consists of errors made in the number of plants sampled and in the measurement of their size. Regression errors include variability in the allometric relationships used to calculate the size of the three plant sections, as well as uncertainty in the length:wet-mass, wet-mass:dry-mass and dry-mass:nitrogen-mass conversion ratios.	decimal	ratio	\N	\N	\N	kilogramPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	15	SE_Frond_density	SE_Frond_density	SE Frond Density	The standard error in our estimate of M. pyrifera frond density (number m-2). Error in frond density reflects variation in the total number of plants sampled in a plot. This estimate is produced by comparing repeated sampling by different observers of a single plot.	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	16	SE_Plant_density	SE_Plant_density	SE Plant Density	The standard error in our estimate of M. pyrifera plant density (number m-2). Error in plant density reflects variation in the total number of plants sampled in a plot. This estimate is produced by comparing repeated sampling by different observers of a single plot.	decimal	ratio	\N	\N	\N	numberPerMeterSquared	0	real	-99999	not available, or not collected	100000	100000
99021	2	17	SE_Plant_loss_rate	SE_Plant_loss_rate	SE Plant Loss Rate	The standard error in our estimate of M. pyrifera plant loss (day-1). This error is sampling error associated with calculating a mean loss rate for the entire plot based on 10 to15 tagged plants.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	2	18	SE_Frond_loss_rate	SE_Frond_loss_rate	SE Frond Loss Rate	The standard error in the calculated rate of frond loss (day-1). This error is sampling error associated with calculating a mean loss rate for the entire plot based on 10 to15 tagged plants.	decimal	ratio	\N	\N	\N	reciprocalDay	0	real	-99999	not available, or not collected	100000	100000
99021	3	1	Site	Site	Site	code for sampling location	string	nominalEnum	\N	\N	\N	\N	\N	\N	-99999	no information available	\N	\N
99021	3	2	plant_ID	plant_ID	Plant ID	Identifier for tagged plant	string	nominalText	\N	\N	any text	\N	\N	\N	-99999	no information available	\N	\N
99021	3	3	date	date	Date	Date of collection	string	dateTime	YYYY-MM-DD	1	\N	\N	\N	\N	-99999	no information available	\N	\N
99021	3	4	total_fronds	total_fronds	Total Fronds	Total number of fronds greater than 1 m in length on the plant. Includes both tagged fronds remaining from previous sampling and new fronds	integer	ratio	\N	\N	\N	number	1	integer	-99999	not available, or not collected	100000	100000
99021	3	5	new_fronds	new_fronds	New Fronds	Number of untagged fronds greater than 1 m in length on the plant. Assumes that these fronds were either initiated during the previous sampling interval. A value of zero means that no new fronds were counted	integer	ratio	\N	\N	\N	number	1	integer	-99999	not available, or not collected	100000	100000
99024	1	1	CONSEC_	CONSEC_	Sample number	Sample number	integer	nominalText	\N	\N	integer as text	\N	\N	\N	\N	\N	\N	\N
99024	1	2	YEAR	YEAR	Year	Calendar year of data collection	integer	dateTime	YYYY	1	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99024	1	3	MONTH	MONTH	Month	Calendar month of data collection	integer	dateTime	MM	1	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99024	1	4	DATE	DATE	Date	The date the sample was collected in the field	string	dateTime	mm/dd/yyyy	1	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99024	1	5	SITE	SITE	Site Name	The name of the physical location of the reef site where samples were collected.	string	nominalEnum	\N	\N	\N	\N	\N	\N	-99999	value not recorded or not available	\N	\N
99024	1	6	_N	_N	Number of Samples	Number of individual kelp core samples combined to create the composite site sample used for the analysis	integer	ratio	\N	\N	\N	number	1	integer	-99999	value not recorded or not available	\N	\N
99024	1	7	Replicate	Replicate	Replicate	Sample replicate	integer	nominalEnum	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99024	1	8	WET	WET	Wet Weight	Wet weight of he sample measured at time of coring	float	ratio	\N	\N	\N	gram	0.000100000000000000005	real	-99999	value not recorded or not available	\N	\N
99024	1	9	DRY	DRY	Dry Weight	Dry weight of sample measured after drying sample in 60 degree celcius oven for 3-5 days	float	ratio	\N	\N	\N	gram	0.000100000000000000005	real	-99999	value not recorded or not available	\N	\N
99024	1	10	DRY_WET	DRY_WET	Dry Weight / Wet Weight	The ratio of dry to wet weight	float	ratio	\N	\N	\N	gramPerGram	9.99999999999999955e-07	real	-99999	value not recorded or not available	\N	\N
99024	1	11	ANALYTICAL_WT	ANALYTICAL_WT	Analytical Dry Weight	Weight of dry sample used in CHN analysis	float	ratio	\N	\N	\N	microgram	0.100000000000000006	real	-99999	value not recorded or not available	\N	\N
99024	1	12	C	C	% Carbon	Percentage of carbon in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	-99999	value not recorded or not available	\N	\N
99024	1	13	H	H	% Hydrogen	Percentage of hydrogen in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	-99999	value not recorded or not available	\N	\N
99024	1	14	N	N	% Nitrogen	Percentage of nitrogen in the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	-99999	value not recorded or not available	\N	\N
99024	1	15	CN_RATIO	CN_RATIO	%Carbon to %Nitrogen Ratio	Carbon to nitrogen ratio of the sample	float	ratio	\N	\N	\N	number	0.00100000000000000002	real	-99999	value not recorded or not available	\N	\N
99024	1	16	NOTES	NOTES	Notes	Text annotations to data observations	string	nominalText	\N	\N	any text	\N	\N	\N	\N	\N	\N	\N
99054	101	1	latitude	latitude	Latitude	Latitude of center of pixel. Degrees North	float	ratio	\N	\N	\N	degree	1.00000000000000002e-08	real	\N	\N	\N	\N
99054	101	2	longitude	longitude	Longitude	Longitude of center of pixel. Degrees East	float	ratio	\N	\N	\N	degree	1.00000000000000002e-08	real	\N	\N	\N	\N
\.




--
-- TOC entry 3182 (class 0 OID 130272)
-- Dependencies: 186
-- Data for Name: EMLAttributeCodeDefinition; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLAttributeCodeDefinition" ("DataSetID", "EntitySortOrder", "ColumnName", code, definition) FROM stdin;
99013	1	site_code	ABUR	Arroyo Burro
99013	1	site_code	AHND	Arroyo Hondo
99013	1	site_code	AQUE	Arroyo Quemado
99013	1	site_code	BULL	Bulito
99013	1	site_code	CARP	Carpinteria
99013	1	site_code	GOLB	Goleta Bay
99013	1	site_code	IVEE	Isla Vista
99013	1	site_code	MOHK	Mohawk
99013	1	site_code	NAPL	Naples
99013	1	site_code	SCDI	Santa Cruz Island, Diablo 
99013	1	site_code	SCTW	Santa Cruz Island, Twin Harbor West Reef
99013	1	frondcondition	growing	Frond is still growing
99013	1	frondcondition	terminal	Frond has reached terminal size
99021	1	Site	ABUR	Arroyo Burro
99021	1	Site	MOHK	Mohawk
99021	1	Site	AQUE	Arroyo Quemado.
99021	2	Site	ABUR	Arroyo Burro
99021	2	Site	MOHK	Mohawk
99021	2	Site	AQUE	Arroyo Quemado.
99021	3	Site	ABUR	Arroyo Burro
99021	3	Site	MOHK	Mohawk
99021	3	Site	AQUE	Arroyo Quemado.
99024	1	SITE	ABUR	Arroyo Burro
99024	1	SITE	AQUE	Arroyo Quemado
99024	1	SITE	MOHK	Mohawk
99024	1	Replicate	1	Sample replicate 1
99024	1	Replicate	2	Sample replicate 2
\.



--
-- TOC entry 3180 (class 0 OID 130265)
-- Dependencies: 184
-- Data for Name: DataSetSites; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetSites" ("DataSetID", "EntitySortOrder", "SiteCode", "GeoCoverageSortOrder") FROM stdin;
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
-- TOC entry 3181 (class 0 OID 130269)
-- Dependencies: 185
-- Data for Name: DataSetTemporal; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetTemporal" ("DataSetID", "EntitySortOrder", "BeginDate", "EndDate", "UseOnlyYear") FROM stdin;
99054	0	1982-11-24	2011-09-13	f
\.



--
-- TOC entry 3178 (class 0 OID 130256)
-- Dependencies: 182
-- Data for Name: DataSetMethods; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."DataSetMethods" ("MethodID", "DataSetID", "effectiveRange", "methodDocument", "protocolID", "instrumentTitle", "instrumentOwner", "instrumentDescription", "softwareTitle", "softwareOwner", "softwareDescription", "softwareVersion") FROM stdin;
33	99021	0	method.21.10.docx	57	\N	\N	\N	\N	\N	\N	\N
34	99024	0	method.24.10.docx	55	\N	\N	\N	\N	\N	\N	\N
30	99013	0	method.13.10.docx	46	TidbiT with a range of -20 to 30 degrees Celsius, and accuracy of ± 0.20 C at 25 degrees Celsius, manufactured by Onset Computer Corporation 	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 3183 (class 0 OID 130278)
-- Dependencies: 187
-- Data for Name: EMLKeywordTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

/* 
COPY lter_metabase."EMLKeywordTypeList" ("KeywordType", "TypeDefinition") FROM stdin;
place	\N
theme	\N
taxonomic	\N
stratum	\N
temporal	\N
\.
 */

--
-- TOC entry 3184 (class 0 OID 130284)
-- Dependencies: 188
-- Data for Name: EMLMeasurementScaleList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/*
COPY lter_metabase."EMLMeasurementScaleList" ("measurementScale") FROM stdin;
dateTime
interval
nominal
ordinal
ratio
\.
  */

--
-- TOC entry 3185 (class 0 OID 130287)
-- Dependencies: 189
-- Data for Name: EMLNumberTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
COPY lter_metabase."EMLNumberTypeList" ("NumberType") FROM stdin;
integer
natural
real
whole
\.
 */

--
-- TOC entry 3186 (class 0 OID 130290)
-- Dependencies: 190
-- Data for Name: EMLStorageTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
COPY lter_metabase."EMLStorageTypeList" ("StorageType", "typeSystem") FROM stdin;
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
 */

--
-- TOC entry 3187 (class 0 OID 130293)
-- Dependencies: 191
-- Data for Name: EMLUnitDictionary; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
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
 */

--
-- TOC entry 3188 (class 0 OID 130300)
-- Dependencies: 192
-- Data for Name: EMLUnitTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
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
 */

--
-- TOC entry 3189 (class 0 OID 130303)
-- Dependencies: 193
-- Data for Name: FileTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
COPY lter_metabase."FileTypeList" ("FileType", "TypeName", "FileFormat", "Extension", "Description", "Delimiters", "Header", "EML_FormatType", "RecordDelimiter", "NumHeaderLines", "NumFooterLines", "AttributeOrientation", "QuoteCharacter", "FieldDelimiter", "CharacterEncoding", "CollapseDelimiters", "LiteralCharacter", "externallyDefinedFormat_formatName", "externallyDefinedFormat_formatVersion") FROM stdin;
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
 */

--
-- TOC entry 3190 (class 0 OID 130311)
-- Dependencies: 194
-- Data for Name: KeywordThesaurus; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."KeywordThesaurus" ("ThesaurusID", "ThesaurusLabel", "ThesaurusUrl", "UseInMetadata", "ThesaurusSortOrder") FROM stdin;
sbclter	SBC-LTER Controlled Vocabulary	\N	t	30
sbclter_place	Santa Barbara Coastal LTER Places	\N	t	40
\.


--
-- TOC entry 3191 (class 0 OID 130318)
-- Dependencies: 195
-- Data for Name: Keywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."Keywords" ("Keyword", "ThesaurusID", "KeywordType") FROM stdin;
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
-- TOC entry 3177 (class 0 OID 130249)
-- Dependencies: 181
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
-- TOC entry 3192 (class 0 OID 130322)
-- Dependencies: 196
-- Data for Name: MeasurementScaleDomains; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--
/* 
COPY lter_metabase."MeasurementScaleDomains" ("EMLDomainType", "MeasurementScale", "NonNumericDomain", "MeasurementScaleDomainID") FROM stdin;
dateTimeDomain	dateTime		dateTime
numericDomain	interval		interval
nonNumericDomain	nominal	enumeratedDomain	nominalEnum
nonNumericDomain	nominal	textDomain	nominalText
nonNumericDomain	ordinal	enumeratedDomain	ordinalEnum
nonNumericDomain	ordinal	textDomain	ordinalText
numericDomain	ratio		ratio
\.
 */







/* 
 * LOAD DATA FOR PKG-MANAGEMENT SCHEMA
 * 
 * 
 * 
 */

--
-- TOC entry 3168 (class 0 OID 130196)
-- Dependencies: 172
-- Data for Name: cv_cra; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_cra (cra_id, cra_name) FROM stdin;
pp	Primary Production 
om	Movement of Organic Matter
dp	Disturbance Patterns
pd	Population Dynamics
in	Movement of Inorganic Nutrients 
\.
 */

--
-- TOC entry 3195 (class 0 OID 130387)
-- Dependencies: 209
-- Data for Name: cv_mgmt_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_mgmt_type (mgmt_type, definition) FROM stdin;
templated	\N
non_templated	\N
\.
 */

--
-- TOC entry 3196 (class 0 OID 130393)
-- Dependencies: 210
-- Data for Name: cv_network_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_network_type (network_type, definition) FROM stdin;
0	data usage is controlled by a group other than SBC or LTER
I	data are publicly available
II	data are restricted and available upon request
mix	at least one entity in the dataset is of each type I and II
NA	network types do not apply. this dataset (EML record) does not go to the network, e.g., it's a template.
\.
 */

--
-- TOC entry 3197 (class 0 OID 130399)
-- Dependencies: 211
-- Data for Name: cv_spatial_extent; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_spatial_extent (spatial_extent, definition) FROM stdin;
lab	data are from an experiment conducted in the lab. organisms were probably collected in the field.
LTER_site_boundary	the entire LTER site, no more, no less
LTER_site_plus	contains at least part of the LTER site, plus other disconnected sites
LTER_site_subset	a subset of the LTER site
region	extends beyond LTER site into adjacent areas
single_point	a single place such as one transect
\.
 */

--
-- TOC entry 3198 (class 0 OID 130405)
-- Dependencies: 212
-- Data for Name: cv_spatial_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_spatial_type (spatial_type, definition) FROM stdin;
multi_site	more than one location within the LTER site
non_spatial	there is no spatial component to this dataset
one_place_of_a_site_series	one place of a series of places
one_site_of_one	one site and not part of a series of sites
\.
 */

--
-- TOC entry 3199 (class 0 OID 130411)
-- Dependencies: 213
-- Data for Name: cv_spatio_temporal; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_spatio_temporal (spatiotemporal, definition) FROM stdin;
csct	continuous spatial continuous temporal
csdt	continuous spatial discrete temporal
dsct	discrete spatial continuous temporal
dsdt	discrete spatial discrete temporal
\.
 */

--
-- TOC entry 3200 (class 0 OID 130417)
-- Dependencies: 214
-- Data for Name: cv_status; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
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
 */

--
-- TOC entry 3201 (class 0 OID 130420)
-- Dependencies: 215
-- Data for Name: cv_temporal_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
/* 
COPY pkg_mgmt.cv_temporal_type (temporal_type, definition) FROM stdin;
completed_timeseries	
non_temporal	
one_period_of_a_timeseries	
ongoing_timeseries	
short_term_study	
\.
 */



--
-- TOC entry 3171 (class 0 OID 130206)
-- Dependencies: 175
-- Data for Name: pkg_state; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_state ("DataSetID", dataset_archive_id, rev, nickname, data_receipt_date, status, synth_readiness, staging_dir, eml_draft_path, notes, pub_notes, who2bug, dir_internal_final, dbupdatetime, update_date_catalog) FROM stdin;
1	knb-lter-sbc.1	11	NCDC climate	2013-04-05	cataloged	metadata_only	watershed_NCDC_climate	watershed_NCDC_climate	Type 0 points to catalogs of outside data sources	\N	bgoodridge	\N	2015-08-10 11:57:42.753	2012-12-04
100	knb-lter-sbc.100	10	Marks, Assessing methods for controlling invasive S. horneri	2016-09-09	draft	\N	/marks_2016_sargassum_horneri_management	/marks_2016_sargassum_horneri_management	Lindsay needs this by 1 oct, for paper to have ds DOI.	\N	lmarks	\N	2017-05-16 15:12:52.269	2017-04-28
1001	knb-lter-sbc.1001	7	Profiling CTD from cruise LTER01	2013-04-05	cataloged	download	\N	\N	All cruise series were regenerated as EML 2.1 in 2013 (with submission to pasta). pub date remains 2010 however (original). if regenerating from template, upgrade that first, to 2.1.	\N	cgotschalk	\N	2015-09-23 17:39:27.839	2010-06-14
1002	knb-lter-sbc.1002	6	Profiling CTD from cruise LTER02	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1003	knb-lter-sbc.1003	6	Profiling CTD from cruise LTER03	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1004	knb-lter-sbc.1004	6	Profiling CTD from cruise LTER04	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1005	knb-lter-sbc.1005	6	Profiling CTD from cruise LTER05	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1006	knb-lter-sbc.1006	8	Profiling CTD from cruise LTER06	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1007	knb-lter-sbc.1007	6	Profiling CTD from cruise LTER07	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1008	knb-lter-sbc.1008	6	Profiling CTD from cruise LTER08	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1009	knb-lter-sbc.1009	6	Profiling CTD from cruise LTER09	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
101	knb-lter-sbc.101	1	California giant kelp patch definitions 	2016-09-27	draft	\N	castorani_101_kelp_metapops_patch_definitions	castorani_101_kelp_metapops_patch_definitions	2 tables. draft0 in 2016	\N	mcastorani	research/Collaborative_Research/kelp_genetics_metapopulation/Final/Data/101_patch_definitions	2016-12-03 12:33:38.825	2016-10-15
1010	knb-lter-sbc.1010	6	Profiling CTD from cruise LTER10	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1011	knb-lter-sbc.1011	6	Profiling CTD from cruise LTER11	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1012	knb-lter-sbc.1012	6	Profiling CTD from cruise LTER12	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1013	knb-lter-sbc.1013	6	Profiling CTD from cruise LTER13	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1014	knb-lter-sbc.1014	6	Profiling CTD from cruise LTER14	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1015	knb-lter-sbc.1015	6	Profiling CTD from cruise LTER15	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1016	knb-lter-sbc.1016	7	Profiling CTD from cruise LTER16	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
102	knb-lter-sbc.102	1	Castorani 2016, So CA kelp patch biomass and fecundity	2016-09-27	draft	\N	castorani_102_kelp_metapops_biomass_fecundity	castorani_102_kelp_metapops_biomass_fecundity	1 table, draft in 2016	\N	mcastorani	research/Collaborative_Research/kelp_genetics_metapopulation/Final/Data/102_patch_biomass_and_fecundity_time_series	2016-10-11 12:21:02.279	2016-10-15
103	knb-lter-sbc.103	3	Castorani 2016, So. CA kelp patch connectivity matrix	2016-09-27	draft	\N	castorani_103_kelp_metapops_connectivity_mat_soCal	castorani_103_kelp_metapops_connectivity_mat_soCal	1 table, draft in 2016	\N	mcastorani	research/Collaborative_Research/kelp_genetics_metapopulation/Final/Data/103_connectivity_matrix	2016-10-19 11:31:04.687	2016-10-15
104	knb-lter-sbc.104	1	Alberto et al, collab 2016, microsatellite data 	2016-09-27	draft	\N	alberto_etal_104_kelp_metapops_genetics	alberto_etal_104_kelp_metapops_genetics	2 tables, genetics	\N	falberto	research/Collaborative_Research/kelp_genetics_metapopulation/Final/Data/104_genetics	2016-10-11 12:21:07.412	2016-10-15
105	knb-lter-sbc.105	1	Alberto et al, collab 2016, Pterygophora microsatellite data 	2016-09-27	draft	\N	kelp_metapops_alberto_105_pterygophora_genetics	kelp_metapops_alberto_105_pterygophora_genetics	1 table, Pt genetics	\N	falberto	research/Collaborative_Research/kelp_genetics_metapopulation/Final/Data/104_genetics	2017-09-20 17:01:30.386	2016-10-15
107	knb-lter-sbc.107	1	Miller isotopes	\N	draft	\N	miller_isotopes_2017	miller_isotopes_2017	emergency, link to bcodmo	\N	rmiller	\N	2017-07-16 14:51:36.365	\N
11	knb-lter-sbc.11	6	moorings, all monsters	\N	deprecated	\N	\N	\N	\N	non-public	\N	\N	2013-07-02 14:01:07.34	\N
1101	knb-lter-sbc.1101	6	Underway data from cruise LTER01	2013-04-05	cataloged	download	\N	\N	All cruise series were regenerated as EML 2.1 in 2013 (with submission to pasta). pub date remains 2010 however (original). if regenerating from template, upgrade that first, to 2.1.	\N	cgotschalk	\N	2015-09-23 17:39:34.505	2010-06-14
1102	knb-lter-sbc.1102	6	Underway data from cruise LTER02	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1103	knb-lter-sbc.1103	6	Underway data from cruise LTER03	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1104	knb-lter-sbc.1104	6	Underway data from cruise LTER04	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1105	knb-lter-sbc.1105	6	Underway data from cruise LTER05	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1106	knb-lter-sbc.1106	6	Underway data from cruise LTER06	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1107	knb-lter-sbc.1107	6	Underway data from cruise LTER07	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1108	knb-lter-sbc.1108	6	Underway data from cruise LTER08	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1109	knb-lter-sbc.1109	5	Underway data from cruise LTER09	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1110	knb-lter-sbc.1110	5	Underway data from cruise LTER10	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1111	knb-lter-sbc.1111	5	Underway data from cruise LTER11	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1112	knb-lter-sbc.1112	5	Underway data from cruise LTER12	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1113	knb-lter-sbc.1113	5	Underway data from cruise LTER13	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1114	knb-lter-sbc.1114	5	Underway data from cruise LTER14	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1115	knb-lter-sbc.1115	5	Underway data from cruise LTER15	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1116	knb-lter-sbc.1116	5	Underway data from cruise LTER16	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
4006	knb-lter-sbc.4006	7	Precipitation: GV202	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:45.201	2012-03-29
10	knb-lter-sbc.10	22	Monthly seawater chemistry	2014-04-29	cataloged	integration	ocean_nearshore_profiles	ocean_nearshore_profiles	\N	\N	cgotschalk	research/Ocean/Final/Data/Monthly_Water_Sampling	2018-01-17 13:54:35.650206	2018-01-17
3003	knb-lter-sbc.3003	7	Stream Discharge: BC02	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:04.547	2012-03-05
12	knb-lter-sbc.12	9	Stable Isotopes - natural abundance  N and C	2013-04-05	cataloged	download	foodweb_isotopes_2005	foodweb_isotopes_2005	1. Find new table in FINAL. update description.<br /> 2. set to download, a type I. <br /> 3.  EML 2.1.0 <br /> 4. goes with publication page et al, 2008	\N	hpage	\N	2014-05-21 10:35:45.343	2010-06-14
1201	knb-lter-sbc.1201	5	Towed vehicle data from cruise LTER01	2013-04-05	cataloged	download	\N	\N	All cruise series were regenerated as EML 2.1 in 2013 (with submission to pasta). pub date remains 2010 however (original). if regenerating from template, upgrade that first, to 2.1.	\N	cgotschalk	\N	2015-09-23 17:39:43.406	2010-06-14
1202	knb-lter-sbc.1202	5	Towed vehicle data from cruise LTER02	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1203	knb-lter-sbc.1203	5	Towed vehicle data from cruise LTER03	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1204	knb-lter-sbc.1204	5	Towed vehicle data from cruise LTER04	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1205	knb-lter-sbc.1205	5	Towed vehicle data from cruise LTER05	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1206	knb-lter-sbc.1206	5	Towed vehicle data from cruise LTER06	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1207	knb-lter-sbc.1207	5	Towed vehicle data from cruise LTER07	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1208	knb-lter-sbc.1208	5	Towed vehicle data from cruise LTER08	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1209	knb-lter-sbc.1209	5	Towed vehicle data from cruise LTER09	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1210	knb-lter-sbc.1210	5	Towed vehicle data from cruise LTER10	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1211	knb-lter-sbc.1211	5	Towed vehicle data from cruise LTER11	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1212	knb-lter-sbc.1212	5	Towed vehicle data from cruise LTER12	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1213	knb-lter-sbc.1213	5	Towed vehicle data from cruise LTER13	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1214	knb-lter-sbc.1214	5	Towed vehicle data from cruise LTER14	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1215	knb-lter-sbc.1215	5	Towed vehicle data from cruise LTER15	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
1216	knb-lter-sbc.1216	5	Towed vehicle data from cruise LTER16	2013-04-05	cataloged	download	\N	\N	\N	\N	\N	\N	2014-05-21 10:35:45.343	2010-06-14
2	knb-lter-sbc.2	\N	Precipitation SBC - DEPRECATED	2013-04-05	deprecated	\N	watershed_precip_sbc_deprecated	watershed_precip_sbc_deprecated	DEPRECATED and replaced with per-site data pkgs. see the 4000 series.	non-public	bgoodridge	\N	2013-07-02 16:29:23.644	2000-01-01
2001	knb-lter-sbc.2001	15	Mooring AQ inactive - AQM	2013-04-05	cataloged	integration	ocean_mooring_aqm_2000	ocean_mooring_aqm_2000	this is the old station, that was moved to arq. rev 10 removes refs to sbcdata	\N	cgotschalk	\N	2014-05-21 10:35:45.343	2010-11-18
2002	knb-lter-sbc.2002	22	Moored CTD and ADCP: NAP	2014-02-25	cataloged	integration	ocean_mooring_nap	ocean_moorings_monster	removed refs to sbcdata.lternet for this and all other mooring pkgs.	\N	cgotschalk	research/Ocean/Final/Data/Moorings/Matlab_monster_files/nap	2015-09-23 17:22:05.28	2014-02-25
2003	knb-lter-sbc.2003	11	Mooring Arroyo Burro	2007-05-16	cataloged	integration	ocean_mooring_arb	ocean_moorings_arb	arroyo burro	\N	cgotschalk	\N	2014-05-21 10:35:45.343	2010-06-14
2004	knb-lter-sbc.2004	18	Moored CTD and ADCP: CAR	2014-02-25	cataloged	integration	ocean_mooring_car	ocean_moorings_monster	carpinteria	\N	cgotschalk	research/Ocean/Final/Data/Moorings/Matlab_monster_files/car	2015-09-23 17:22:11.424	2014-02-25
2005	knb-lter-sbc.2005	15	Moored CTD and ADCP: ARQ	2014-02-25	cataloged	integration	ocean_mooring_aqr	ocean_moorings_monster	the new arroyo quemado mooring	\N	cgotschalk	research/Ocean/Final/Data/Moorings/Matlab_monster_files/arq	2015-09-23 17:22:15.648	2014-02-25
2007	knb-lter-sbc.2007	8	Moored CTD and ADCP: MKO	2014-02-25	cataloged	integration	ocean_mooring_mko	ocean_moorings_monster	fixed location!	\N	cgotschalk	research/Ocean/Final/Data/Moorings/Matlab_monster_files/mko	2015-09-23 17:22:16.896	2014-02-25
2008	knb-lter-sbc.2008	7	Moored CTD and ADCP: ALE	2013-11-19	cataloged	integration	ocean_mooring_ale	ocean_moorings_monster	\N	\N	cgotschalk	research/Ocean/Final/Data/Moorings/Matlab_monster_files/ale	2015-09-23 17:22:17.928	2013-11-19
23	knb-lter-sbc.23	11	Beach wrack and porewater 2003	2012-02-28	cataloged	download	beach_wrack_porewater_2003	beach_wrack_porewater_2003	table #1: wrack, 10 beaches, plus 5 or 4 others sampled intermittently.<br /> table #2: porewater, to be added<br /> There is a paper in prep which uses some of these data, at least the wrack. the plan will be to copy this dataset when the paper is done, and remove data that doesnt go with the paper.	\N	jdugan	\N	2014-05-21 10:35:45.343	2013-02-06
18	knb-lter-sbc.18	21	KFCD Reef giant kelp	2017-12-01	cataloged	download	reef_community_kelp_size_abundance	project.18	\N		lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Giant Kelp	2018-06-26 12:13:45.498531	2018-06-26
19	knb-lter-sbc.19	24	KFCD Reef quad-swath counts	2017-12-01	cataloged	download	reef_community_quad_swath_counts	project.19	\N	\N	lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Invert and Algae Counts	2018-06-26 12:13:45.500733	2018-06-26
17	knb-lter-sbc.17	32	KFCD Reef fish abundance	2017-12-01	cataloged	download	reef_community_fish_abundance	project.17			lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Fish Abundance	2018-08-14 13:44:21.994109	2018-08-14
15	knb-lter-sbc.15	26	KFCD Reef benthic cover	2017-12-01	cataloged	download	reef_community_benthic_cover	project.15	\N		lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Invert and Algae cover	2018-06-26 12:13:45.492403	2018-06-26
3	knb-lter-sbc.3	12	SBCounty PWD precipitation	2013-04-05	cataloged	download	watershed_SBCounty_PWD_precip_deprecated	watershed_SBCounty_PWD_precip_deprecated	consider redesign. <br />this pkg could be for historical data, and is for inactive loggers. Blair has created table for the active loggers, and these now have their own pkgs (5000 series). <br /> current contents: 2 tables, one each, active and inactive loggers.	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3001	knb-lter-sbc.3001	7	Stream Discharge: AB00	2013-04-05	cataloged	download	\N	\N	Series needs upgrade to EML 2.1 (template)	\N	bgoodridge	\N	2015-09-29 11:04:54.083	2012-03-05
3002	knb-lter-sbc.3002	5	Stream Discharge: AT07	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
99013	knb-lter-sbc.13	21	Reef bottom water temperature	2017-12-01	cataloged	integration	reef_bottom_temperature	project.13		\N	lkui	research/Reef/Final/Data/Bottom_Temperature/	2018-10-22 14:55:09.359446	2017-12-07
99024	knb-lter-sbc.24	17	Kelp - algal weights and CHN	2017-12-20	cataloged	integration	reef_kelp_algal_weight_CHN	project.24	replaced method, july 2013	\N	lkui	research/Reef/Final/Data/Kelp_NPP/CHN	2018-10-22 14:55:09.361894	2017-12-20
3004	knb-lter-sbc.3004	5	Stream Discharge: CP00	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3005	knb-lter-sbc.3005	5	Stream Discharge: DV01	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3006	knb-lter-sbc.3006	6	Stream Discharge: FK00	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2012-03-05
3007	knb-lter-sbc.3007	7	Stream Discharge: GV01	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:09.466	2012-03-05
3008	knb-lter-sbc.3008	7	Stream Discharge: HO00	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:10.506	2012-03-05
3009	knb-lter-sbc.3009	7	Stream Discharge: MC00	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:11.714	2012-03-05
3010	knb-lter-sbc.3010	7	Stream Discharge: ON02	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2012-12-18
3011	knb-lter-sbc.3011	7	Stream Discharge: RG01	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:13.002	2012-03-05
3012	knb-lter-sbc.3012	5	Stream Discharge: RN01	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3013	knb-lter-sbc.3013	7	Stream Discharge: RS02	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-29 11:05:13.866	2012-03-05
3014	knb-lter-sbc.3014	6	Stream Discharge: SM01	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2012-12-18
3015	knb-lter-sbc.3015	5	Stream Discharge: SM04	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3016	knb-lter-sbc.3016	5	Stream Discharge: TE03	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
3017	knb-lter-sbc.3017	3	Stream Discharge: MC06	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2012-03-22
3018	knb-lter-sbc.3018	4	Stream Discharge: SP02	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2012-03-22
32	knb-lter-sbc.32	12	SB harbor water temperature	2011-06-09	backlog	integration	reference_water_temperature_SBharbor	reference_water_temperature_SBharbor	pending new data from SCCOOS	\N	mobrien	research/Ocean/Final/Data/SantaBarbaraHarbor_manualLongTermTemperature	2014-05-21 10:35:45.343	2010-06-14
33	knb-lter-sbc.33	8	Daily precipitation at UCSB (SB County stn 200)	2013-04-05	cataloged	integration	reference_precipitation_UCSB200_daily	reference_precipitation_UCSB200_daily	2013 update, by mob, directly from county flood control website download.	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2013-06-05
37	knb-lter-sbc.37	4	Turf algae primary production	2012-02-28	cataloged	download	miller_pprod_turf_foliose_structure_production	miller_pprod_turf_foliose_structure_production	\N	\N	rmiller	\N	2015-09-23 17:40:32.687	2012-02-29
4001	knb-lter-sbc.4001	7	Precipitation: CP201	2013-04-05	cataloged	download	\N	\N	Series needs upgrade to EML 2.1 (template)	\N	bgoodridge	\N	2015-09-23 17:24:35.026	2012-03-29
4002	knb-lter-sbc.4002	7	Precipitation: EL201	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:39.097	2012-03-29
4003	knb-lter-sbc.4003	6	Precipitation: EL202	2013-04-05	cataloged	download	\N	\N	collection appears to have stopped.	\N	bgoodridge	\N	2015-09-23 17:24:40.865	2010-06-14
4004	knb-lter-sbc.4004	6	Precipitation: GB201	2013-04-05	cataloged	download	\N	\N	Gobernator doesn't appear in Blair's lists. stopped?	\N	bgoodridge	\N	2015-09-23 17:24:42.361	2010-06-14
4005	knb-lter-sbc.4005	6	Precipitation: GV201	2013-04-05	cataloged	download	\N	\N	collection appears to have stopped.	\N	bgoodridge	\N	2015-09-23 17:24:43.513	2010-06-14
31	knb-lter-sbc.31	\N	reef cryptic fish	2013-04-05	deprecated	\N	reef_community_fish_cryptic_DEPRECATED	reef_community_fish_cryptic_DEPRECATED	ARCHIVED. cataloged but non public as of 2009.	\N	lkui	\N	2017-12-20 13:57:41.083117	2000-01-01
35	knb-lter-sbc.35	7	CDIP modeled swell	2013-05-27	cataloged	integration	reference_CDIP_modeled_swell	reference_CDIP_modeled_swell	package might be redesigned. grabbing data with cron	\N	jbyrnes	research/Ocean/Final/Data/CDIP_waveHeight	2018-01-18 10:19:46.114356	2018-01-18
34	knb-lter-sbc.34	14	LTE KR - invert/algal density (quad-swath)	2017-12-19	cataloged	integration	lte_kr_quad_swath	project.34	available	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Invert\\ and\\ Algae\\ Counts	2018-06-26 12:13:45.514132	2018-06-26
30	knb-lter-sbc.30	16	LTE KR - fish abundance	2017-12-19	cataloged	integration	lte_kr_fish_abundance	project.30	\N	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Fish Abundance	2018-06-26 12:13:45.512212	2018-06-26
27	knb-lter-sbc.27	15	LTE KR - allometrics	2013-10-09	cataloged	integration	lte_kr_allometrics	lte_kr_allometrics	\N	no need for update	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Allometric Measurements	2017-12-20 15:08:37.443122	2015-01-15
26	knb-lter-sbc.26	17	LTE KR - urchin size and distribution	2017-12-20	cataloged	integration	lte_kr_urchin_size_distribution	project.26	\N	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Urchin Counts	2018-06-26 12:13:45.505153	2018-06-26
39	knb-lter-sbc.39	5	SCI surfperch and garibaldi	2012-02-07	draft	integration	SCI_selected_fish	SCI_selected_fish	available	consider swith to completed_timeseries category	lkui	research/Reef/Final/Data/SCI_Surfperch_and_Benthic_Biota	2017-12-20 15:48:10.869282	2012-02-28
29	knb-lter-sbc.29	16	LTE KR - giant kelp abundance	2017-12-19	cataloged	integration	lte_kr_kelp_size_abundance	project.29	\N	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Giant Kelp	2018-06-26 12:13:45.509819	2018-06-26
38	knb-lter-sbc.38	5	SCI benthic cover	2013-07-22	draft	integration	SCI_benthic_cover	SCI_benthic_cover	available	consider swith to completed_timeseries category	lkui	research/Reef/Final/Data/SCI_Surfperch_and_Benthic_Biota	2017-12-20 15:48:10.866656	2012-02-28
28	knb-lter-sbc.28	24	LTE KR - benthic cover	2017-12-19	cataloged	integration	lte_kr_benthic_cover	project.28	\N	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Invert and Algae cover	2018-06-26 12:13:45.507982	2018-06-26
25	knb-lter-sbc.25	19	LTE KR - biomass, detritus	2017-12-20	cataloged	integration	lte_kr_detritus_biomass	project.25	\N	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Detritus	2018-06-26 12:13:45.502763	2018-06-26
4007	knb-lter-sbc.4007	7	Precipitation: HO201	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:52.289	2012-03-29
4008	knb-lter-sbc.4008	7	Precipitation: HO202	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:53.545	2012-03-29
4009	knb-lter-sbc.4009	7	Precipitation: RG201	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:54.545	2012-03-29
4010	knb-lter-sbc.4010	7	Precipitation: RG202	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:55.513	2012-03-29
4011	knb-lter-sbc.4011	7	Precipitation: RG203	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:24:56.481	2012-03-29
4012	knb-lter-sbc.4012	7	Precipitation: RG204	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:25:31.807	2012-03-29
45	knb-lter-sbc.45	8	Cross-shelf campaign DOC CTD/Rosette profiles	2013-04-05	cataloged	integration	campaign_cross_shelf_DOC_CTD_profiles	campaign_cross_shelf_DOC_CTD_profiles/	\N	\N	ccarlson1, ewallner	\N	2014-05-21 10:35:45.343	2012-11-13
5	knb-lter-sbc.5	7	USGS Stream Discharge	2013-04-05	cataloged	metadata_only	watershed_USGS_stream_discharge_links	watershed_USGS_stream_discharge_links	catalog of USGS data sources	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
6001	knb-lter-sbc.6001	1	pH, 20-min SeaFET at ALE	2015-07-10	cataloged	integration	\N	pH_series_seafet_moored_20min	\N	\N	cgotschalk	\N	2016-09-06 17:17:11.378	\N
5001	knb-lter-sbc.5001	5	County FCD Precipitation: BaronRanch262	2013-04-05	cataloged	download	\N	\N	series template upgraded to EML 2.1 in 2014	\N	bgoodridge	\N	2015-09-23 17:27:00.729	2010-06-14
5002	knb-lter-sbc.5002	5	County FCD Precipitation: Carpinteria208	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:11.789	2010-06-14
5003	knb-lter-sbc.5003	5	County FCD Precipitation: CaterWTP229	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:10.333	2010-06-14
5004	knb-lter-sbc.5004	5	County FCD Precipitation: ColdSprings210	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:08.869	2010-06-14
5005	knb-lter-sbc.5005	5	County FCD Precipitation: DosPueblos226	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:07.981	2010-06-14
5006	knb-lter-sbc.5006	5	County FCD Precipitation: DoultonTunnel231	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:07.173	2010-06-14
5007	knb-lter-sbc.5007	5	County FCD Precipitation: EdisonTrail252	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:06.261	2010-06-14
5008	knb-lter-sbc.5008	5	County FCD Precipitation: ElDeseo255	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:04.95	2010-06-14
5009	knb-lter-sbc.5009	5	County FCD Precipitation: GoletaRdYard211	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:03.894	2010-06-14
5010	knb-lter-sbc.5010	5	County FCD Precipitation: KTYD227	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:03.126	2010-06-14
5011	knb-lter-sbc.5011	5	County FCD Precipitation: Nojoqui236	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:02.126	2010-06-14
5012	knb-lter-sbc.5012	5	County FCD Precipitation: SanMarcosPass212	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:01.27	2010-06-14
5013	knb-lter-sbc.5013	5	County FCD Precipitation: SBEngBldg234	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:26:00.31	2010-06-14
5014	knb-lter-sbc.5014	5	County FCD Precipitation: StanwoodFS228	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:25:56.03	2010-06-14
5015	knb-lter-sbc.5015	5	County FCD Precipitation: TroutClub242	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:25:55.134	2010-06-14
5016	knb-lter-sbc.5016	5	County FCD Precipitation: UCSB200	2013-04-05	cataloged	download	\N	\N	\N	\N	bgoodridge	\N	2015-09-23 17:25:53.478	2010-06-14
5017	knb-lter-sbc.5017	0	County FCD Precipitation: GaviotaSP301	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:51.694	\N
5018	knb-lter-sbc.5018	0	County FCD Precipitation: RefugioPass429	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:50.646	\N
5019	knb-lter-sbc.5019	0	County FCD Precipitation: TecoloteCanyon280	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:49.55	\N
5020	knb-lter-sbc.5020	0	County FCD Precipitation: GlenAnnieCanyon309	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:47.95	\N
5021	knb-lter-sbc.5021	0	County FCD Precipitation: GoletaFireStation440	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:47.118	\N
5022	knb-lter-sbc.5022	0	County FCD Precipitation: GoletaWaterDistrict334	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:46.11	\N
5023	knb-lter-sbc.5023	0	County FCD Precipitation: SBCaltrans335	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:44.99	\N
5024	knb-lter-sbc.5024	0	County FCD Precipitation: BotanicGarden321	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:43.83	\N
5025	knb-lter-sbc.5025	0	County FCD Precipitation: CarpinteriaUSFS383	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:42.151	\N
41	knb-lter-sbc.41	6	Beach wrack CHN	2013-04-05	catd_meta_antic_data	metadata_only	beach_wrack_CHN	beach_wrack_CHN	on hold, samples are not analyzed yet,deny-pub-read		jdugan	\N	2017-12-20 15:20:11.159209	2000-01-01
42	knb-lter-sbc.42	\N	LTE KR - cryptic fish 	2013-04-05	deprecated	\N	lte_kr_fish_abundance_DEPRECATED	lte_kr_fish_abundance_DEPRECATED	ARCHIVED. cataloged but non pubic as of 2009	\N	lkui	\N	2017-12-20 13:57:41.091422	2000-01-01
44	knb-lter-sbc.44	6	LTE KR transects - depth	2010-10-06	cataloged	integration	transects_lte_kr_sites	transects_lte_kr_sites	reference, neds data for IV transects		lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Physical Properties	2018-06-26 12:13:45.518999	2018-06-26
48	knb-lter-sbc.48	4	SCI kelp frond density	2013-07-22	draft	integration	SCI_kelp_frond_density	SCI_kelp_frond_density	\N	consider swith to completed_timeseries category	lkui	research/Reef/Final/Data/SCI_Surfperch_and_Benthic_Biota	2017-12-20 15:48:10.876418	2012-02-28
43	knb-lter-sbc.43	6	Reef monitoring transects - depth	2010-10-06	cataloged	integration	transects_benthic_monitoring	transects_benthic_monitoring	reference	\N	lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Physical/Properties/Transect_Depths	2018-06-26 12:13:45.516326	2018-06-26
46	knb-lter-sbc.46	4	SCI pycnopodia 	2012-02-07	draft	integration	SCI_pycnopodia	SCI_pycnopodia	protocols and data collection varied. 	consider swith to completed_timeseries category	lkui	research/Reef/Final/Data/SCI_Surfperch_and_Benthic_Biota	2017-12-20 15:48:10.870937	2012-02-28
49	knb-lter-sbc.49	11	LTE KR - biomass, algae	2017-12-19	deprecated	integration	lte_kr_biomass_algae	project.49	the algae biomass data package get removed and add a data package for all species together. 	\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Biomass/Data	2018-06-26 16:43:19.399658	2018-06-26
5026	knb-lter-sbc.5026	0	County FCD Precipitation: Montecito325	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:40.887	\N
5027	knb-lter-sbc.5027	0	County FCD Precipitation: RanchoSJ389	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:39.775	\N
5028	knb-lter-sbc.5028	0	County FCD Precipitation: BuelltonFS233	2015-07-16	cataloged	download	\N	watershed_series_precip_county	\N	\N	bgoodridge	\N	2015-09-23 17:25:35.975	\N
53	knb-lter-sbc.53	4	Microsatellite markers	2013-04-05	cataloged	download	alberto_genetics_microsat_markers_2009	alberto_genetics_microsat_markers_2009	table from paper	\N	falberto	\N	2014-05-21 10:35:45.343	2012-04-20
55	knb-lter-sbc.55	3	Understory and phytoplankton NPP	2013-04-05	cataloged	download	miller_pprod_understory_phyto	miller_pprod_understory_phyto	problem child. what's with that jagged row?	\N	sharrer, cnelson	\N	2015-09-23 17:40:57.555	2012-02-29
56	knb-lter-sbc.56	3	Byrnes kelp forest foodweb	2013-04-05	cataloged	integration	byrnes_kelp_forest_foodweb	byrnes_kelp_forest_foodweb	TBA, may include code, is this 1 package or 2	\N	jbyrnes	\N	2014-05-21 10:35:45.343	2012-02-27
59	knb-lter-sbc.59	3	Byrnes urchin experiment	2013-04-05	draft	metadata_only	byrnes_urchin_exclusion_experiment	byrnes_urchin_exclusion_experiment	current data tables dummied after other reef entities	rev 3 is non-public	jbyrnes	\N	2014-03-21 16:24:05.192	2000-01-01
60	knb-lter-sbc.60	5	SCI aggregated black surfperch and prey	2012-09-17	cataloged	integration	okamoto_surfperch_sci_2012paper	okamoto_surfperch_sci_2012paper	finaized data publication by 26 sep	\N	dokamoto	\N	2014-05-21 10:35:45.343	2012-09-25
6002	knb-lter-sbc.6002	1	pH, 20-min SeaFET at AQR	2015-07-10	cataloged	integration	\N	pH_series_seafet_moored_20min	\N	\N	cgotschalk	\N	2016-09-06 17:17:12.297	\N
6003	knb-lter-sbc.6003	1	pH, 20-min SeaFET at MKO	2015-07-10	cataloged	integration	\N	pH_series_seafet_moored_20min	\N	\N	cgotschalk	\N	2016-09-06 17:17:13.289	\N
6004	knb-lter-sbc.6004	1	pH, 20-min SeaFET at SBH	2015-07-10	cataloged	integration	\N	pH_series_seafet_moored_20min	\N	\N	cgotschalk	\N	2016-09-06 17:17:14.498	\N
62	knb-lter-sbc.62	0	Stream Chemistry - Rain Water Chem	\N	draft0	\N	watershed_stream_chemistry/2021_redesign/62_sbc_rain_water	\N	\N	\N	bgoodridge	\N	2013-12-19 16:41:20.97	\N
63	knb-lter-sbc.63	0	Stream Chemistry - Channel Keepers	\N	draft0	\N	watershed_stream_chemistry/2012_redesign/63_channel_keepers	\N	\N	\N	bgoodridge	\N	2013-12-19 16:41:22.466	\N
64	knb-lter-sbc.64	0	Stream Chemistry - SB city	\N	draft0	\N	watershed_stream_chemistry/2012_redesign/64_sb_city	\N	\N	\N	bgoodridge	\N	2013-12-19 16:41:23.618	\N
65	knb-lter-sbc.65	0	Stream Chemistry - Santa Rosa Island	\N	anticipated	\N	watershed_stream_chemistry/2012_redesign/65x_santa_rosa_island	\N	low priority	\N	bgoodridge, jmelack	\N	2013-12-19 16:41:24.33	\N
66	knb-lter-sbc.66	4	Klose et al - Ventura R nutrients and algae 2008	2013-04-05	cataloged	\N	klose_venturariver_2008	klose_venturariver_2008	data requested by DataONE semantics group. package could have more data added.	\N	kklose	\N	2014-05-21 10:35:45.343	2013-01-15
68	knb-lter-sbc.68	1	Gaviota fire, 2008, max perimeter	2013-04-24	cataloged	integration	watershed_fires_perimeter	watershed_fires_perimeter	\N	\N	mobrien	\N	2014-01-06 10:50:40.128	\N
69	knb-lter-sbc.69	1	Gap fire, 2008, max perimeter	2013-04-24	cataloged	integration	watershed_fires_perimeter	watershed_fires_perimeter	\N	\N	mobrien	\N	2014-01-06 10:50:42.464	\N
7	knb-lter-sbc.7	6	GIS Layers	2013-04-05	cataloged	metadata_only	watershed_GIS_layers_2002	watershed_GIS_layers_2002	our gis data is not described well enough 	\N	bgoodridge	\N	2014-05-21 10:35:45.343	2010-06-14
70	knb-lter-sbc.70	1	Tea fire, 2009, max perimeter	2013-04-24	cataloged	integration	watershed_fires_perimeter	watershed_fires_perimeter	\N	\N	mobrien	\N	2014-01-06 10:50:43.752	\N
7001	knb-lter-sbc.7001	0	TBD: Dar Roberts IDEAS, Coal Oil Point	2015-07-16	anticipated	\N	\N	tbd	\N	\N	bgoodridge	\N	2015-08-10 11:46:20.619	\N
7002	knb-lter-sbc.7002	0	TBD: Dar Roberts IDEAS, Mission Canyon	2015-07-16	anticipated	\N	\N	tbd	\N	\N	bgoodridge	\N	2015-08-10 11:46:22.011	\N
71	knb-lter-sbc.71	1	Jesusita fire, 2009, max perimeter	2013-04-24	cataloged	integration	watershed_fires_perimeter	watershed_fires_perimeter	\N	\N	mobrien	\N	2014-01-06 10:50:44.784	\N
72	knb-lter-sbc.72	0	Climate -- NCDC from Santa Barbara Airport	2012-05-25	draft0	\N	reference_climate	reference_climate	\N	\N	mobrien	\N	2013-07-02 16:46:24.356	\N
73	knb-lter-sbc.73	5	Johansson Kelp Microsatellite Markers, Geospatial 2009	2013-07-10	cataloged	integration	johansson_genetics_microsat_markers_spatial_2013	johansson_genetics_microsat_markers_spatial_2013	see paper notes - this is a test for pasta's treatment of software urls.	d	mjohansson	\N	2016-10-03 16:32:21.96	2013-10-13
61	knb-lter-sbc.61	5	Otter sightings	2017-12-19	cataloged	integration	otter_sightings	project.61	\N	\N	lkui	research/Reef/Final/Data/Non-Core/Sea Otter Abundance	2017-12-20 15:39:18.201697	2017-12-19
58	knb-lter-sbc.58	7	LTE KR - Macroalgal NPP	2015-09-25	draft	integration	lte_kr_algal_NPP	lte_kr_algal_NPP	this one used to be harrer_pprod_algal_NPP_2013. now is a time series.	waiting for Shannon's light data to complete	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/NPP/	2017-12-20 15:53:21.564393	2013-05-27
57	knb-lter-sbc.57	7	Algal P vs. E and biomass	2013-04-05	cataloged	integration	harrer_PE_algal_biomass	harrer_PE_algal_biomass	public as of 2013. Might have new species update later. 	a few species needed to add in the next version but not in a hurry. 	lkui	\N	2017-12-22 11:16:49.296397	2013-05-14
67	knb-lter-sbc.67	0	Algal biomass and diversity	2013-01-08	draft0	\N	\N	\N	krystal trained hannah on this one. needs abstract and entity descriptions from shan.	Shannon and working on it.	lkui	\N	2017-12-20 15:03:41.034736	\N
51	knb-lter-sbc.51	7	Beach - birds and stranded kelp	2018-01-26	cataloged	download	beach_birds_stranded_kelp	project.51	update along with 40, wrack cover. note that birds is aggregated values table. stranded kelp, different dir in final. 	\N	lkui, jdugan	research/Beach/Final/Data/Shorebirds, Stranded_Kelp_Plants (2 dirs)	2018-01-26 14:10:45.457853	2018-01-26
6	knb-lter-sbc.6	15	Stream Chemistry	2012-07-10	cataloged	integration	watershed_stream_chemistry/2012_redesign/6_sbc_stream_chem	watershed_stream_chemistry/	2013: split into several pkgs. see under drafts and in staging dir.	\N	mmeyerhoff	\N	2018-01-17 13:16:22.329515	2018-01-17
75	knb-lter-sbc.75	3	pH time series, water samples	2014-08-29	cataloged	\N	pH_seafet_benchmark	pH_seafet_benchmark	number and locations tbd. water samples for calibration of seafet	\N	jlunden, cgotschalk 	look in the staging dir; its a pisco directory	2018-02-22 11:13:06.15651	2018-02-22
76	knb-lter-sbc.76	0	pH study at Stearns Wharf	2014-08-29	draft0	\N	pH_passow_dickson_study_2013	pH_passow_dickson_study_2013	some data are also in 75, and used for calibration	abandoned?	upassow	\N	2016-10-12 17:07:40.884	2014-10-01
83	knb-lter-sbc.83	1	Foster et al, PeerJ, Diet Effects in the Purple Sea Urchin	2014-10-07	cataloged	\N	foster_urchins_peerj_2014	foster_urchins_peerj_2014	student sr thesis	4 tables, R code.	mfoster	\N	2014-12-18 10:58:21.101	2014-12-10
85	knb-lter-sbc.85	1	Blade turnover dynamics (Rodriguez, 2014)	2014-12-08	cataloged	\N	rodriguez_kelp_frond_turnover	rodriguez_kelp_frond_turnover	Gabe sent, 12/8	\N	grodriguez	Rodriguez_Gabe	2015-08-17 17:00:55.428	2015-01-31
86	knb-lter-sbc.86	10	Okamoto 2015 Urchin fertilization experiment	2015-01-08	cataloged	\N	okamoto_urchin_fertilization_2015	okamoto_urchin_fertilization_2015	Have data now. see notebook, paper. 2015-01-06	\N	dokamoto	research/grad_student_research/Rodriguez_Gabe	2016-06-15 16:34:58.021	2015-12-31
87	knb-lter-sbc.87	1	Goodridge, thesis porewater	2017-05-31	redesign_anticipated	\N	goodridge_beach_pore_water	goodridge_beach_pore_water	see staging dir, 20170531_incoming	\N	bgoodridge	\N	2017-05-31 14:45:12.309	2015-05-01
88	knb-lter-sbc.88	1	kapsenberg curriculum, pH comparison	2015-04-10	cataloged	\N	kapsenberg_cirriculum_ecosystem_pH_comparison	kapsenberg_cirriculum_ecosystem_pH_comparison	waiting till paper is in press.	\N	lkapsenberg	\N	2016-06-15 12:15:07.165	2015-06-01
89	knb-lter-sbc.89	\N	LIDAR - Carp salt marsh	\N	anticipated	\N	\N	\N	data are available in Land/Data/Final. goes with Sadro 2007 paper	\N	gastil	\N	2015-04-10 15:24:32.157	\N
9	knb-lter-sbc.9	10	Local Area Imagery (seawifs)	2003-04-08	cataloged	metadata_only	satellite_local_area_imagery	satellite_local_area_imagery	points to other catalogs	\N	efields	\N	2014-05-21 10:35:45.343	2010-06-14
90	knb-lter-sbc.90	1	Marks, Sargassum horneri occurrence	2015-04-27	cataloged	\N	marks_2015_sargassum_horneri_sightings	marks_2015_sargassum_horneri_sightings	Lindsay needs this by 1 oct, for paper to have ds DOI.	\N	lmarks	\N	2015-10-30 13:46:29.205	2015-10-01
93	knb-lter-sbc.93	10	pH and O2 from Channel Islands (Kapsenberg, 2016)	2016-03-22	cataloged	\N	kapsenberg_CINP_pH_data	kapsenberg_CINP_pH_data	student dissertation	\N	lkapsenberg	\N	2016-06-16 12:24:54.843	2016-03-29
94	knb-lter-sbc.94	\N	Mission Cyn DTM	\N	anticipated	\N	bookhagen_lidar_dtm	\N	eager? supplement?	\N	bbookhagen	\N	2015-08-27 09:02:53.732	\N
95	knb-lter-sbc.95	\N	Mission Cyn classified point cloud	\N	anticipated	\N	bookhagen_lidar_classified_point_cloud	\N	eager? supplement?	\N	bbookhagen	\N	2015-08-27 09:03:02.524	\N
97	knb-lter-sbc.97	1	Okamoto surfperch survival, Ecol. Letters	2015-10-30	cataloged	\N	okamoto_surfperch_survival_elet2015	okamoto_surfperch_survival_elet2015	paper has a doi already.	\N	dokamoto	\N	2016-06-16 15:28:46.474	2016-06-15
98	knb-lter-sbc.98	\N	Hanan, thesis data (veg soil props)	\N	anticipated	\N	hanan_vegetation_soil_props	hanan_vegetation_soil_props	\N	\N	ehanan	\N	2016-01-25 15:58:48.316	\N
99	knb-lter-sbc.99	1	invertebrate biomass relationships	2016-02-28	cataloged	\N	reef_invert_biomass_relationships	reef_invert_biomass_relationships	no draft view till staging dir	\N	cnelson	\N	2016-06-15 16:37:12.775	2016-04-01
99054	knb-lter-sbc.99054	4	Satellite kelp canopy biomass	2013-10-25	deprecated	integration	satellite_kelp_canopy_1	cavanaugh_satellite_kelp_canopy_1/2014_update	test dataset for pasta.	metacat is at rev 3 and pasta at rev 2, docs are the same.	tbell, kcavanaugh	\N	2014-09-08 15:27:17.317	2012-02-14
1100	template_cruise.1100	8	underway data, SBCLTER_cruise-underway_TEMPLATE.1.7.xml	\N	redesign_anticipated	\N	ocean_series_cruises_2001_2006	00_im_assist/ocean_series_cruises_2001_2006	SBCLTER_cruise-underway_TEMPLATE.1.7.xml	\N	mobrien	\N	2014-09-08 15:26:46.935	\N
1200	template_cruise.1200	7	towed ctd, SBCLTER_cruise-towed_TEMPLATE.1.6.xml	\N	redesign_anticipated	\N	ocean_series_cruises_2001_2006	00_im_assist/ocean_series_cruises_2001_2006	SBCLTER_cruise-towed_TEMPLATE.1.6.xml	\N	mobrien	\N	2014-09-08 15:26:48.463	\N
3000	template_dischrg.3000	10	stream discharge, SBCLTER_streamDischarge_TEMPLATE.1.10.xml	\N	redesign_anticipated	\N	\N	watershed_series_stream_discharge	\N	\N	mobrien	\N	2015-08-10 11:59:29.807	\N
4000	template_precip.4000	7	SBC precipitation, SBCLTER_precipitation_TEMPLATE.1.7.xml	\N	redesign_anticipated	\N	\N	watershed_series_precip_SBC	\N	\N	mobrien	\N	2015-08-10 11:59:28.319	\N
5000	template_precip.5000	\N	template for county-collected precip	\N	redesign_anticipated	\N	\N	watershed_series_precip_county	\N	\N	mobrien	\N	2015-08-10 11:59:26.991	\N
100002	x.100002	\N	swell mohawk 	\N	anticipated	\N	TBD_swell_mohawk	TBD_swell_mohawk	hold off on this one. The undergrad-sensors are being used to validate the CDIP model first.	\N	cgotschalk	\N	2014-05-21 16:08:18.473	\N
79	knb-lter-sbc.79	0	LTE KR biomass, fish	2016-03-13	deprecated	\N	lte_kr_biomass_fish	lte_kr_biomass_fish	fish biomass data package should be removed and add in one data package with all-species together	\N	sharrer	\N	2018-06-26 16:46:07.096469	2014-10-01
81	knb-lter-sbc.81	0	KFCD biomass, invertebrates	\N	deprecated	\N	reef_community_biomass_inverts	reef_community_biomass_inverts	invert biomass data package should be removed and add in one data package with all-species together	\N	cnelson	\N	2018-06-26 16:47:00.388858	\N
77	knb-lter-sbc.77	2	lobster abundance and fishing effort	2017-12-19	cataloged	integration	reef_lobsters	project.77	Clint will send latitudes for polygons (table 2). Shan wants to tweak the abstract	\N	lkui	research/Reef/Final/Data/Lobster_Abundance_and_Fishing_Pressure	2017-12-19 15:08:20.059186	2017-12-19
82	knb-lter-sbc.82	0	KFCD biomass, fish	2014-09-04	deprecated	\N	reef_community_biomass_fish	reef_community_biomass_fish	fish biomass data package should be removed and add in one data package with all-species together	\N	sharrer	\N	2018-06-26 16:47:00.391314	2014-10-01
1000	template_cruise.1000	5	ctd and rosette bottle, SBCLTER_cruise-rosette_TEMPLATE.1.4.xml	\N	redesign_anticipated	\N	ocean_series_cruises_2001_2006	00_im_assist/ocean_series_cruises_2001_2006	SBCLTER_cruise-rosette_TEMPLATE.1.4.xml	updating metadata to EML 2.1, 2013	mobrien	\N	2018-06-28 15:46:49.272992	2010-06-14
84	knb-lter-sbc.84	\N	Seastar wasting disease	2014-01-01	anticipated	\N	reef_seastars	reef_seastars	Shan sent, 12/5	\N	sharrer	\N	2017-12-20 15:20:11.180795	2014-10-01
96	knb-lter-sbc.96	1	Glider CTD data	2018-02-01	draft	\N	glider_fernanda	project.96	Fernanda's theses, also info from Dave/Stuart	\N	dseigel, ffreitas, shalewood	\N	2018-02-01 11:35:35.776387	2018-02-02
78	knb-lter-sbc.78	0	Veg-e	2014-09-04	anticipated	\N	\N	\N	dataset for synthesis project	\N	sharrer	\N	2017-12-20 15:20:11.172418	2014-10-01
92	knb-lter-sbc.92	2	isotope composition, sediments and consumers	2013-04-05	cataloged	\N	foodweb_isotopes_timeseries	foodweb_isotopes_timeseries	review keywords for this pkg, and for 12, enhance both	\N	hpage	 	2018-02-21 11:11:16.670871	2018-02-21
6000	PH_INSERT_PLACE	1	pH Time Series	2014-10-27	template	\N	pH_series_seafet_moored_20min	project.6000	\N	This is a template	cgotschalk	\N	2018-08-07 14:36:37.213387	0001-01-01
2000	TEMP_INSERT_PLACE	1	Mooring INSERT_PLACE	\N	template	\N	ocean_moorings_monster	project.2000	\N	\N	cgotschalk	\N	2018-08-07 14:35:19.004591	0001-01-01
100003	x.100003	\N	pH -  MOHK	\N	anticipated	\N	\N	\N	this was Paul Matson's data. might be incorporated into the larger timeseries.	\N	pmatson, erivest	\N	2015-01-06 13:27:22.294	\N
1000032	x.1000032	\N	Wind stress	\N	anticipated	\N	TBD_windstress	TBD_windstress	21 cols U and V	\N	cgotschalk	\N	2014-05-21 16:07:22.518	\N
1000034	x.1000034	\N	Mooring Mohawk inner	\N	anticipated	\N	ocean_mooring_mki	ocean_mooring_mki	not sure - partner with mhk-out? other ceqi data from mohawk too.	\N	cgotschalk	\N	2014-05-21 16:07:26.963	\N
1000035	x.1000035	\N	Biodiversity and productivity	\N	anticipated	\N	campaign_biodiversity_productivity	campaign_biodiversity_productivity	? is there mini grant data? or is this just a project	\N	bcardinale	\N	2014-05-21 16:07:32.205	\N
1000036	x.1000036	\N	Mooring Stearns Wharf	\N	anticipated	\N	TBD_ocean_mooring_stearnswharf 	TBD_ocean_mooring_stearnswharf 	planned. the ctd on the wharf, also supplies real time data.	\N	cgotschalk	\N	2014-05-21 16:07:36.218	\N
1000057	x.1000057	\N	TBD stream flux - watershed	\N	anticipated	\N	watershed_stream_flux	watershed_stream_flux	?? need watershed area to calc from disch and chem, i think.	\N	bgoodridge	\N	2014-05-21 16:07:40.709	\N
1000058	x.1000058	\N	TBD SBC Taxonomy	\N	anticipated	\N	TBD_reef_taxonomy	TBD_reef_taxonomy	TBD, reference	\N	\N	\N	2014-09-04 16:27:39.794	\N
1000066	x.1000066	\N	Cross-shelf campaign bac OTU	\N	anticipated	\N	campaign_cross_shelf_bact_OTU	campaign_cross_shelf_bact_OTU	deprecated for now - not of value without dna sequence, and one table added to docid 45	\N	ewallner	\N	2014-09-08 15:25:54.831	\N
1000077	x.1000077	\N	CEQI NAS	\N	anticipated	\N	CEQI_mooring_NAS	CEQI_mooring_NAS	some material in pre-pub dir already	\N	\N	\N	2014-05-21 16:08:04.921	\N
100008	x.100008	\N	Offshore Primary Production 2001-2006	\N	anticipated	\N	cruises_pprod_analysis	cruises_pprod_analysis	value-added data from cruises. suggest including got's pngs   	\N	mbrzezinski, cgotschalk, lwashburn	\N	2014-05-21 16:08:11.865	\N
1000083	x.1000083	\N	Beach porewater	\N	anticipated	\N	beach_porewater	beach_porewater	have they started any ongoing porewater collection?	\N	jdugan	\N	2014-12-09 09:29:24.945	\N
1000088	x.1000088	\N	Beach wrack porewater gradient 2010	\N	anticipated	\N	beach_wrack_porewater_2010	beach_wrack_porewater_2010	\N	\N	jdugan	\N	2014-12-09 09:29:29.913	\N
1000092	x.1000092	\N	Plumes and Blooms CTD and rosette profiles	\N	anticipated	\N	plumes_blooms_ctd	plumes_blooms_ctd	talk to Dave Court in 2012. collection probably needs its own index page.	 	dsiegel	\N	2014-12-09 09:29:34.369	\N
1000098	x.1000098	\N	ROMS model output	\N	anticipated	\N	\N	\N	big files. maybe post code for a workflow instead	\N	dseigel, lromero	\N	2014-12-09 09:29:50.144	\N
1000099	x.1000099	\N	RAPID AVIRIS	\N	anticipated	\N	\N	\N	pre-post fire RAPID study	\N	droberts	\N	2014-12-09 09:29:55.208	\N
100101	x.100101	\N	Beneitez-Nelson sed trap data	\N	anticipated	\N	\N	\N	might be collab with cce? based on some equipment we bought, maybe shared.	\N	\N	\N	2015-01-06 13:27:47.124	\N
100103	x.100103	\N	O2 sensors paired with seafets. w moorings?	\N	anticipated	\N	\N	\N	possible redesign of 6000 series	\N	lwashburn, cgotschalk	\N	2016-01-25 15:37:52.693	\N
100104	x.100104	\N	pCO2 and TA from water samples, PnB, monthly sites, or both	\N	anticipated	\N	\N	\N	supp funds bought an instrument that is now in Craig's lab. NSF expects some sort of time series.	\N	ccarlson, diglasiasrodriguez	\N	2015-03-10 13:37:54.206	\N
14	knb-lter-sbc.14	13	Reef historical kelp	2007-05-03	cataloged	download	reef_historical_kelp	reef_historical_kelp	1) needs its sites located on google earth, so you can put in metadata. 2) protocol is located in data directory. in 2014, put a copy in /Protocols. too. 	\N	sharrer	research/Reef/Final/Data/Historical_Kelp/	2017-12-20 15:33:08.919653	2010-06-14
109	knb-lter-sbc.109	2	kelp nitrogen uptake	2017-12-18	cataloged	\N	kelp_N_uptake	project.109	\N	\N	jsmith2	\N	2018-04-25 15:19:55.528488	2018-04-25
108	knb-lter-sbc.108	1	reef kelp blade loss	2017-07-03	cataloged	\N	reef_kelp_blade_loss	project.108	\N	\N	lkui	\N	2017-12-19 11:26:11.90866	2017-09-25
36	knb-lter-sbc.36	11	Reef PAR sfc and bottom	2017-12-27	cataloged	integration	PAR_sfc_seafloor	PAR_sfc_seafloor	available		lkui	research/Reef/Final/Data/Continuous/Light/Data/	2017-12-27 14:21:02.634748	2017-12-27
74	knb-lter-sbc.74	10	Kelp biomass from landsat 5, 7, and 8	2017-03-27	cataloged	integration	ts_satellite_kelp_biomass_ongoing	project.74	was a redesign of 54 in 2013 (landsat data), but instead, that data went into a redisgn of 54. see 54's dir for notes.	\N	tom bell	\N	2017-12-13 11:23:29.386444	2017-11-13
47	knb-lter-sbc.47	4	SCI benthic scraping	2013-07-02	draft	integration	SCI_algae_food_resources_scraped	SCI_algae_food_resources_scraped	tables being added, or split.	consider swith to completed_timeseries category	lkui	research/Reef/Final/Data/SCI_Surfperch_and_Benthic_Biota	2017-12-20 15:48:10.873109	2012-02-28
52	knb-lter-sbc.52	6	Larval Settlement	2017-10-25	cataloged	integration	schroeter_larval_settlement	project.52	\N	\N	lkui, sschroeter	research/Reef/Final/Data/Urchin Settlement	2017-12-20 13:57:41.10436	2017-12-11
50	knb-lter-sbc.50	6	Annual - all species biomass	2018-01-26	cataloged	\N	reef_community_biomass_by_taxon	reef_community_biomass_by_taxon	was in use briefly for one type of biomass data. now is id for all time series of biomass for all kelp forest species.	\N	lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Biomass/Data	2018-07-02 17:48:07.907655	2018-06-26
111	knb-lter-sbc.111	1	Watersipora and offshore oil platforms	\N	cataloged	\N	project.111	project.111		\N	hpage		2018-01-04 13:14:18.024433	2018-01-04
113	knb-lter-sbc.113	1	beach wrack consumer distribution	2018-01-18	cataloged	download	project.113	project.113		\N	jdugan		2018-01-18 15:18:25.130171	2018-01-18
21	knb-lter-sbc.21	17	Kelp - NPP	2016-08-04	deprecated	integration	reef_pprod_kelp_NPP	00_im_assist/reef_pprod_kelp_NPP	shan is recoding all this - new tables?	shannon is working on it in	lkui,sharrer	research/Reef/Final/Data/Kelp_NPP	2018-01-26 11:00:24.441877	2016-09-08
91	knb-lter-sbc.91	2	Biomass and counts for beach wrack macroinvertebrates	2018-01-25	cataloged	\N	beach_wrack_consumers	beach_wrack_consumers	add site for carp city beach w rev 2		jdugan	research/Beach/Final/Data/Wrack_consumers	2018-01-26 11:40:54.505546	2018-01-26
114	knb-lter-sbc.114	1	DOC bagged kelp experment	2018-02-09	cataloged	\N	campaign_bagged_kelp	campaign_bagged_kelp	is this ellie or shan? some stu stuff  too.	\N	ewallner, sharrer	\N	2018-02-26 09:47:36.776908	2018-02-21
40	knb-lter-sbc.40	13	Beach wrack cover	2017-12-01	draft	download	beach_wrack_cover	beach_wrack_cover	shan says what's in final not ready. ask in Dec/jan. needs enhancement -- add taxonomy	waiting for Sarah to finish cleaning	lkui, jdugan	research/Beach/Final/Data/Wrack measurements	2018-02-27 13:02:56.170501	2018-02-27
112	knb-lter-sbc.112	2	Kelp - NPP	2018-01-29	cataloged	integration	reef_pprod_kelp_NPP	project.112			sharrer	research/Reef/Final/Data/Kelp_NPP	2018-05-22 11:32:11.860732	2018-05-22
110	knb-lter-sbc.110	1	Annual kelp forest species biomass	\N	deprecated	\N	reef_community_biomass_by_taxon	project.110	similar as dataset 50 but it is a long-term data with 20 m quad resolution	\N	lkui	research/Reef/Final/Data/Kelp_Forest_Community_Dynamics/Biomass\\ Data	2018-06-13 11:30:13.621737	2018-01-10
54	knb-lter-sbc.54	6	landsat5 kelp canopy biomass	2013-10-15	deprecated	integration	ts_satellite_kelp_biomass	ts_satellite_kelp_biomass	1) plans are to reinstate this as ongoing when calib of landsat 8 worked out. could be the same id, or new one. 2) ds has many large tables. could not get into pasta without custom help.	\N	tbell1	\N	2018-01-26 11:00:24.448541	2014-01-14
115	knb-lter-sbc.115	1	frond lifespan	2018-02-26	cataloged	\N	project.115	project.115		\N	rass	\N	2018-02-26 09:47:36.740279	2018-02-26
116	knb-lter-sbc.116	3	Rapid sediment temperature	2018-03-19	cataloged	\N	project.116	project.116		\N	jsmith2	\N	2018-03-22 13:01:51.324881	2018-03-22
117	knb-lter-sbc.117	3	Rapid urea	2018-03-19	cataloged	\N	project.117	project.117		\N	jsmith2	\N	2018-03-22 13:01:51.330051	2018-03-22
118	knb-lter-sbc.118	1	Rapid POM and grain size	2018-03-28	cataloged	\N	project.118	project.118		\N	hpage	\N	2018-03-29 11:07:09.442813	2018-03-29
80	knb-lter-sbc.80	0	KFCD biomass, macroalgae	2014-09-04	deprecated	\N	reef_community_biomass_algae	reef_community_biomass_algae	algae biomass data package should be removed and add in one data package with all-species together	\N	sharrer	\N	2018-06-26 16:47:00.356738	2014-10-01
119	knb-lter-sbc.119	1	LTE KR - all species biomass	2018-06-23	cataloged		project.119	project.119		\N	lkui	research/Reef/Final/Data/Long_Term_Kelp_Removal/Biomass Data	2018-09-19 15:44:54.909865	2018-06-29
120	knb-lter-sbc.120	1	Master spp list	2018-06-28	cataloged		project.120	project.120		\N	lkui	research/Reef/Working/Species and Investigator Codes	2018-09-19 15:44:54.912781	2018-06-29
121	knb-lter-sbc.121	1	Ocean chemistry data	2018-06-29	cataloged		project.121	project.121	Margaret is working on abstract and method	\N	lkui	research/Metadata/EML_2017/project.121	2018-10-15 16:11:38.469898	2018-07-19
122	knb-lter-sbc.122	1	Life history traits of Sargassum horneri	2018-09-19	cataloged	\N	project.122	project.122	\N	\N	\N	\N	2018-10-15 16:11:38.472555	2018-09-20
123	knb-lter-sbc.123	1	kelp frond allometry	2018-10-15	draft	\N	project.123	project.123	\N	\N	\N	\N	2018-10-15 16:12:04.743906	2018-10-16
99021	knb-lter-sbc.22	11	Beach wrack IV 2005-06	2013-04-05	cataloged	download	beach_wrack_IV	beach_wrack_IV	table #1: wrack, only macrocystis so far. may have other species added table #2 to be added: porewater.	\N	jdugan	\N	2018-10-22 14:55:09.353637	2010-06-14
\.






--
-- TOC entry 3169 (class 0 OID 130199)
-- Dependencies: 173
-- Data for Name: pkg_core_area; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_core_area ("DataSetID", "Core_area") FROM stdin;
3	dp
6	in
6	om
6	dp
9	om
10	in
10	om
12	pd
14	pd
15	pd
17	pd
18	pd
19	pd
21	pd
21	pp
23	om
23	in
25	dp
25	om
26	dp
26	pd
27	dp
27	pd
28	dp
28	pd
29	dp
29	pd
30	dp
30	pd
32	in
33	dp
34	dp
34	pd
35	dp
36	dp
36	pp
37	pp
38	pd
39	pd
40	om
41	om
45	in
45	om
45	pd
45	pp
46	pd
47	pd
48	pd
49	dp
49	pd
50	dp
50	pd
51	dp
51	pd
52	pd
53	pd
54	om
55	pd
55	pp
56	pd
57	pp
58	dp
58	pp
59	dp
59	pd
60	pd
61	pd
66	in
66	pd
68	dp
69	dp
70	dp
71	dp
73	pd
74	om
75	dp
77	pd
77	dp
83	pd
85	om
85	pp
86	pd
87	in
88	dp
90	dp
90	pd
91	pd
92	pd
93	dp
97	pd
99	pd
100	dp
100	pd
101	pd
102	pd
103	pd
104	pd
105	pd
107	pd
108	om
108	pp
109	in
110	pd
111	dp
111	pd
112	pp
112	pd
112	om
113	pd
1001	om
1001	in
1001	pp
1002	om
1002	in
1002	pp
1003	om
1003	in
1003	pp
1004	om
1004	in
1004	pp
1006	om
1006	in
1006	pp
1007	om
1007	in
1007	pp
1008	om
1008	in
1008	pp
1009	om
1009	in
1009	pp
1010	om
1010	in
1010	pp
1011	om
1011	in
1011	pp
1012	om
1012	in
1012	pp
1013	om
1013	in
1013	pp
1014	om
1014	in
1014	pp
1015	om
1015	in
1015	pp
1016	om
1016	in
1016	pp
1101	in
1102	in
1103	in
1104	in
1105	in
1106	in
1107	in
1108	in
1109	in
1110	in
1111	in
1112	in
1113	in
1114	in
1115	in
1201	in
1202	in
1203	in
1204	in
1205	in
1206	in
1207	in
1208	in
1209	in
1210	in
1211	in
1212	in
1213	in
1214	in
1215	in
1216	in
2001	in
2002	in
2003	in
2004	in
2005	in
2007	in
2008	in
3001	in
3002	in
3003	in
3004	in
3005	in
3006	in
3007	in
3008	in
3009	in
3010	in
3011	in
3012	in
3013	in
3014	in
3015	in
3016	in
3017	in
3018	in
4001	dp
4002	dp
4003	dp
4004	dp
4005	dp
4006	dp
4007	dp
4008	dp
4009	dp
4010	dp
4011	dp
4012	dp
5001	dp
99013	dp
99024	pp
5002	dp
5003	dp
5004	dp
5005	dp
5006	dp
5007	dp
5008	dp
5009	dp
5010	dp
5011	dp
5012	dp
5013	dp
5014	dp
5015	dp
5016	dp
5017	dp
5018	dp
5019	dp
5020	dp
5021	dp
5022	dp
5023	dp
5024	dp
5025	dp
5026	dp
5027	dp
5028	dp
6001	dp
6002	dp
6003	dp
6004	dp
114	om
115	pp
1116	in
99021	om
\.


--
-- TOC entry 3170 (class 0 OID 130202)
-- Dependencies: 174
-- Data for Name: pkg_sort; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.pkg_sort ("DataSetID", network_type, is_signature, is_core, temporal_type, spatial_extent, spatiotemporal, is_thesis, is_reference, is_exogenous, spatial_type, management_type, in_pasta, dbupdatetime) FROM stdin;
1	\N	\N	\N	non_temporal	\N	\N	\N	\N	t	\N	non_templated	\N	2017-11-30 12:05:51.862288
10	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
100	\N	\N	\N	short_term_study	region	\N	t	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
1001	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1003	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1004	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1005	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1006	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1007	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1008	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1009	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
101	\N	\N	\N	short_term_study	region	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1010	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1011	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1012	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1013	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1014	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1015	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1016	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
102	\N	\N	\N	short_term_study	region	\N	\N	\N	\N	\N	non_templated	\N	2017-11-30 12:05:51.862288
1101	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1102	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1103	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1104	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1105	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1106	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1107	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1108	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1109	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1110	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1111	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1112	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1113	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1114	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1115	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1116	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
12	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1201	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1202	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1203	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1204	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1205	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1206	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1207	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1208	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1209	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1210	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1211	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1212	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1213	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1214	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1215	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
1216	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
14	\N	\N	\N	completed_timeseries	region	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
15	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
17	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
18	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
19	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2001	\N	\N	\N	completed_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2002	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2003	\N	\N	\N	completed_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2004	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2005	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2007	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
2008	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	non_templated	t	2017-11-30 12:05:51.862288
23	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
25	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
26	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
27	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
28	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
29	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
3	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
30	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
3001	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3002	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3003	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3004	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3005	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3006	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3007	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3008	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3009	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
11	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-05 10:52:12.004351
1002	\N	\N	\N	short_term_study	LTER_site_subset	\N	f	\N	f	\N	templated	t	2018-08-27 17:59:16.885405
3010	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3011	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
99024	I	t	t	ongoing_timeseries	LTER_site_subset	dsdt	f	f	f	multi_site	non_templated	t	2018-10-22 15:08:03.022884
3012	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3013	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3014	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3015	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3016	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3017	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
3018	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
32	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	t	\N	non_templated	\N	2017-11-30 12:05:51.862288
33	\N	\N	\N	ongoing_timeseries	\N	\N	\N	t	t	\N	non_templated	\N	2017-11-30 12:05:51.862288
34	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
36	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
37	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
40	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
4001	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4002	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4003	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4004	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4005	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4006	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4007	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4008	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4009	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4010	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4011	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
4012	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
41	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
43	\N	\N	\N	short_term_study	\N	\N	\N	t	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
44	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
49	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
5	\N	\N	\N	non_temporal	\N	\N	\N	\N	t	\N	non_templated	\N	2017-11-30 12:05:51.862288
5001	\N	\N	\N	ongoing_timeseries	single_point	dsct	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5002	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5003	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5004	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5005	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5006	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5007	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5008	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5009	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5010	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5011	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5012	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5013	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5014	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5015	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
5016	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5017	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5018	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5019	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5020	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5021	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5022	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5023	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5024	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5025	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5026	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5027	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
5028	\N	\N	\N	ongoing_timeseries	single_point	\N	\N	\N	f	\N	templated	t	2017-11-30 12:05:51.862288
51	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
52	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
53	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
55	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
56	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
59	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
6	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
6001	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
6002	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
6003	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
6004	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
61	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
62	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
63	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
64	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
65	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
66	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
67	\N	\N	\N	ongoing_timeseries	\N	\N	\N	t	\N	\N	\N	\N	2017-11-30 12:05:51.862288
68	\N	\N	\N	short_term_study	LTER_site_subset	csdt	\N	t	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
39	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:55:38.343898
46	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:55:38.345958
47	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:55:38.347854
48	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:55:38.349863
35	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	t	\N	non_templated	\N	2018-02-21 10:29:22.157033
31	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-05 10:51:01.078244
42	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-05 10:51:01.08122
45	\N	\N	\N	short_term_study	\N	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.263679
50	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-26 11:02:12.927022
57	\N	\N	\N	short_term_study	\N	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.268179
58	\N	\N	\N	ongoing_timeseries	\N	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.270558
60	\N	\N	\N	short_term_study	\N	\N	t	\N	f	\N	non_templated	\N	2018-08-27 17:35:06.50331
69	\N	\N	\N	short_term_study	LTER_site_subset	csdt	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
7	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
70	\N	\N	\N	short_term_study	LTER_site_subset	csdt	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
71	\N	\N	\N	short_term_study	LTER_site_subset	csdt	\N	\N	\N	\N	non_templated	t	2017-11-30 12:05:51.862288
73	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
75	\N	\N	\N	ongoing_timeseries	LTER_site_subset	dsdt	f	f	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
76	\N	\N	\N	short_term_study	single_point	\N	\N	\N	t	\N	non_templated	\N	2017-11-30 12:05:51.862288
77	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	\N	2017-11-30 12:05:51.862288
78	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
79	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
80	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
81	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
82	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
83	\N	\N	\N	short_term_study	lab	\N	t	f	f	\N	non_templated	t	2017-11-30 12:05:51.862288
84	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	\N	2017-11-30 12:05:51.862288
9	\N	\N	\N	non_temporal	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	templated	f	2017-11-30 12:05:51.862288
3000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	templated	f	2017-11-30 12:05:51.862288
4000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	templated	f	2017-11-30 12:05:51.862288
5000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	templated	f	2017-11-30 12:05:51.862288
6000	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	templated	f	2017-11-30 12:05:51.862288
100002	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
100003	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000032	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000034	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000035	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000036	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
1000057	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
1000058	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000066	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000077	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
100008	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
1000083	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000088	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000092	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	templated	\N	2017-11-30 12:05:51.862288
1000098	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
1000099	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2017-11-30 12:05:51.862288
109	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	non_templated	f	2017-12-19 11:08:03.832946
91	\N	\N	\N	ongoing_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2017-12-20 15:29:44.534698
89	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:29:44.540329
118	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-09-19 15:49:39.055607
38	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-20 15:55:38.340903
110	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2017-12-27 14:25:23.400388
92	\N	\N	\N	completed_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2018-01-05 10:50:18.144153
103	\N	\N	\N	completed_timeseries	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2018-01-05 10:50:18.302321
104	\N	\N	\N	short_term_study	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2018-01-05 10:50:18.306589
107	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-05 10:50:18.309912
2	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-05 10:52:12.000801
99	\N	\N	\N	non_temporal	LTER_site_subset	\N	\N	\N	\N	\N	non_templated	t	2018-01-05 10:52:12.008263
1000	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	\N	\N	templated	f	2018-01-05 10:53:12.963094
1100	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	\N	\N	templated	f	2018-01-05 10:53:12.966104
112	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-01-18 14:43:21.621328
21	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	\N	2018-01-18 14:43:44.685832
97	\N	\N	\N	non_temporal	LTER_site_subset	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:35:06.509879
116	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-03-19 10:05:06.241921
117	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-03-19 10:05:06.426606
113	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-03-19 10:05:06.431098
123	\N	\N	\N	short_term_study	\N	\N	\N	\N	f	\N	non_templated	t	2018-10-15 16:12:56.276169
85	\N	\N	\N	short_term_study	LTER_site_subset	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.272455
86	\N	\N	\N	short_term_study	lab	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.27481
87	\N	\N	\N	short_term_study	LTER_site_subset	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.276811
88	\N	\N	\N	short_term_study	LTER_site_plus	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.278705
90	\N	\N	\N	short_term_study	region	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:15:20.280507
93	\N	\N	\N	completed_timeseries	LTER_site_subset	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:35:06.50675
54	\N	\N	\N	completed_timeseries	\N	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:37:17.88442
74	\N	\N	\N	ongoing_timeseries	\N	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:37:17.887056
96	\N	\N	\N	short_term_study	\N	\N	t	\N	f	\N	non_templated	\N	2018-08-27 17:40:31.699908
108	\N	\N	\N	short_term_study	\N	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:59:16.840811
111	\N	\N	\N	short_term_study	\N	\N	t	\N	f	\N	non_templated	\N	2018-08-27 17:59:16.877094
114	\N	\N	\N	short_term_study	\N	\N	t	\N	\N	\N	non_templated	t	2018-08-27 17:59:16.87916
115	\N	\N	\N	completed_timeseries	\N	\N	t	\N	f	\N	non_templated	t	2018-08-27 17:59:16.881229
119	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-09-19 15:49:38.897283
120	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-09-19 15:49:39.045408
121	\N	\N	\N	ongoing_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-09-19 15:49:39.048535
122	\N	\N	\N	completed_timeseries	\N	\N	\N	\N	f	\N	non_templated	t	2018-09-19 15:49:39.052288
99054	I	t	t	completed_timeseries	region	csct	t	f	f	multi_site	non_templated	f	2018-10-22 15:08:03.025768
99013	I	t	t	ongoing_timeseries	LTER_site_subset	dsct	f	f	f	multi_site	non_templated	t	2018-10-22 15:08:03.017427
99021	I	t	t	short_term_study	LTER_site_subset	dsdt	f	f	f	multi_site	non_templated	t	2018-10-22 15:08:03.020822
\.

-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

-- View: mb2eml_r.vw_eml_associatedparty

-- DROP VIEW mb2eml_r.vw_eml_associatedparty;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_associatedparty AS
 SELECT d."DataSetID" AS datasetid, d."AuthorshipOrder" AS authorshiporder, 
    d."AuthorshipRole" AS authorshiprole, d."NameID" AS nameid, 
    p."GivenName"::text AS givenname, p."MiddleName" AS givenname2, 
    p."SurName" AS surname, p."Organization" AS organization, 
    p."Address1" AS address1, p."Address2" AS address2, 
    p."Address3" AS address3, p."City" AS city, p."State" AS state, 
    p."Country" AS country, p."ZipCode" AS zipcode, p."Phone1" AS phone1, 
    p."Phone2" AS phone2, p."FAX" AS fax, p."Email" AS email, 
    i."Identificationlink" AS orcid
   FROM lter_metabase."DataSetPersonnel" d
   LEFT JOIN lter_metabase."People" p ON d."NameID"::text = p."NameID"::text
   LEFT JOIN lter_metabase."Peopleidentification" i ON d."NameID"::text = i."NameID"::text
  WHERE d."AuthorshipRole"::text <> ALL (ARRAY['creator'::text, 'metadataProvider'::text, 'contact'::text, 'publisher'::text])
  ORDER BY d."DataSetID", d."AuthorshipOrder";

ALTER TABLE mb2eml_r.vw_eml_associatedparty
    OWNER TO %db_owner%;



-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE lter_metabase."MissingCodesList" (
	"MissingValueCodeID" character varying(20) NOT NULL,
	"MissingValueCode" character varying(200) NOT NULL,
	"MissingValueCodeExplanation" character varying(1024) NOT NULL
);

ALTER TABLE ONLY lter_metabase."MissingCodesList" 
	ADD CONSTRAINT "PK_MissingCodesList_MissingValueCodeID" 
	PRIMARY KEY("MissingValueCodeID");
	
ALTER TABLE lter_metabase."MissingCodesList"
    OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."MissingCodesList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MissingCodesList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MissingCodesList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."MissingCodesList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."MissingCodesList" TO read_only_user;

CREATE TABLE lter_metabase."AttributeMissingCodes" (
	"DataSetID" integer NOT NULL,
	"EntitySortOrder" integer NOT NULL,
	"ColumnName" character varying(200) NOT NULL,
	"MissingValueCodeID" character varying(20) NOT NULL
);

ALTER TABLE lter_metabase."AttributeMissingCodes"
    OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."AttributeMissingCodes" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."AttributeMissingCodes" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MissingCodesList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."AttributeMissingCodes" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."AttributeMissingCodes" TO read_only_user;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
	ADD CONSTRAINT "FK_DatasetMissingCode_MissingValueCodeID" 
	FOREIGN KEY ("MissingValueCodeID") 
	REFERENCES lter_metabase."MissingCodesList"("MissingValueCodeID") 
	ON UPDATE CASCADE;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
    ADD CONSTRAINT "FK_DataSet_SortOrder_ColumnName" 
	FOREIGN KEY ("DataSetID", "EntitySortOrder", "ColumnName") 
	REFERENCES lter_metabase."DataSetAttributes"("DataSetID", "EntitySortOrder", "ColumnName") 
	ON UPDATE CASCADE;
	
ALTER TABLE ONLY lter_metabase."AttributeMissingCodes"
    ADD CONSTRAINT "PK_AttributeMissingCodes" 
	PRIMARY KEY ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID");
	
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_missingcodes AS
	SELECT 
	d."DataSetID" as datasetid, 
	d."EntitySortOrder" as entity_position, 
	d."ColumnName" as "attributeName", 
	e."MissingValueCode" as code, 
	e."MissingValueCodeExplanation" as definition 
	FROM (lter_metabase."AttributeMissingCodes" d 
	JOIN lter_metabase."MissingCodesList" e 
	ON (((d."MissingValueCodeID")::text = (e."MissingValueCodeID")::text))) 
	ORDER BY d."DataSetID";

ALTER TABLE mb2eml_r.vw_eml_missingcodes OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_missingcodes FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_missingcodes FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_missingcodes TO read_write_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_missingcodes TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_missingcodes TO read_only_user;-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE lter_metabase."TaxaList" (
	"TaxonID" character varying(50) NOT NULL,
	"TaxonomicAuthority" character varying(50) NOT NULL,
	"TaxonRankName" character varying(50),
	"TaxonRankValue" character varying(200),
	"CommonName" character varying(200),
	"LocalID" character varying(50)
);

ALTER TABLE ONLY lter_metabase."TaxaList"
	ADD CONSTRAINT "PK_TaxaList"
	PRIMARY KEY ("TaxonID", "TaxonomicAuthority");

CREATE TABLE lter_metabase."DataSetTaxa" (
	"DataSetID" integer NOT NULL,
	"TaxonID" character varying(50) NOT NULL,
	"TaxonomicAuthority" character varying(50) NOT NULL
);

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "PK_DataSetTaxa"
	PRIMARY KEY ("DataSetID", "TaxonID", "TaxonomicAuthority");

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "FK_DataSetTaxa_DataSetID" 
	FOREIGN KEY("DataSetID") 
	REFERENCES lter_metabase."DataSet"("DataSetID") 
	ON UPDATE CASCADE;

ALTER TABLE ONLY lter_metabase."DataSetTaxa"
	ADD CONSTRAINT "FK_DataSetTaxa_TaxonID" 
	FOREIGN KEY("TaxonID", "TaxonomicAuthority") 
	REFERENCES lter_metabase."TaxaList"("TaxonID", "TaxonomicAuthority") 
	ON UPDATE CASCADE;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_taxonomy AS
	SELECT d."DataSetID" as datasetid, 
	d."TaxonID" as taxonid, 
	d."TaxonomicAuthority" as taxonid_provider, 
	l."TaxonRankName" as taxonrankname, 
	l."TaxonRankValue" as taxonrankvalue,
	l."CommonName" as commonname 
	FROM lter_metabase."DataSetTaxa" d 
	JOIN lter_metabase."TaxaList" l 
	ON (((d."TaxonID")::text = (l."TaxonID")::text)) AND (((d."TaxonomicAuthority")::text = (l."TaxonomicAuthority")::text)) 
	ORDER BY d."DataSetID";
	
ALTER TABLE lter_metabase."TaxaList" OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."TaxaList" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."TaxaList" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."TaxaList" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."TaxaList" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."TaxaList" TO read_only_user;
	
ALTER TABLE lter_metabase."DataSetTaxa" OWNER TO %db_owner%;
	
REVOKE ALL ON TABLE lter_metabase."DataSetTaxa" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetTaxa" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetTaxa" TO read_write_user;
GRANT ALL ON TABLE lter_metabase."DataSetTaxa" TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetTaxa" TO read_only_user;

ALTER TABLE mb2eml_r.vw_eml_taxonomy OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_taxonomy TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;-- Note: FIRST: edit %db_owner% to the account name of the DB owner 
DROP VIEW mb2eml_r.vw_eml_associatedparty;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_associatedparty AS
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
	p."Phone1" AS phone1, 
	p."Phone2" AS phone2, 
	p."FAX" AS fax, 
	p."Email" AS email, 
	i."Identificationtype" as userid_type, 
	i."Identificationlink" AS userid 
	FROM ((lter_metabase."DataSetPersonnel" d 
		LEFT JOIN lter_metabase."People" p 
		ON (((d."NameID")::text = (p."NameID")::text))) 
	LEFT JOIN lter_metabase."Peopleidentification" i 
	ON (((d."NameID")::text = (i."NameID")::text))) 
		ORDER BY d."DataSetID", d."AuthorshipOrder";

ALTER TABLE mb2eml_r.vw_eml_associatedparty OWNER to %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_associatedparty FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_associatedparty FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_associatedparty TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_associatedparty TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_associatedparty TO %db_owner%;

DROP VIEW mb2eml_r.vw_eml_creator;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_creator
AS SELECT d."DataSetID" AS datasetid,
    d."AuthorshipOrder" AS authorshiporder,
    d."AuthorshipRole" AS authorshiprole,
    d."NameID" AS nameid,
    p."GivenName"::text AS givenname,
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
    p."Phone1" AS phone1,
    p."Phone2" AS phone2,
    p."FAX" AS fax,
    p."Email" AS email,
    i."Identificationtype" as userid_type, 
    i."Identificationlink" AS userid 
   FROM lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."People" p ON d."NameID"::text = p."NameID"::text
     LEFT JOIN lter_metabase."Peopleidentification" i ON d."NameID"::text = i."NameID"::text
  WHERE d."AuthorshipRole"::text = 'creator'::text
  ORDER BY d."DataSetID", d."AuthorshipOrder";

ALTER TABLE mb2eml_r.vw_eml_creator OWNER to %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_creator FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_creator FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_creator TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_creator TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_creator TO %db_owner%;-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

CREATE TABLE pkg_mgmt.cv_maint_freq(
	eml_maintenance_frequency character varying(50)
);

ALTER TABLE pkg_mgmt.cv_maint_freq
	ADD CONSTRAINT "PK_cv_maint_freq"
	PRIMARY KEY (eml_maintenance_frequency);

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

ALTER TABLE lter_metabase."DataSet"
	ADD COLUMN "ShortName" character varying(200),
	ADD COLUMN "UpdateFrequency" character varying(50),
	ADD COLUMN "MaintenanceDescription" character varying(500);
	
alter table lter_metabase."DataSet"
	RENAME COLUMN "Accession" TO "Revision";
	
alter table lter_metabase."DataSet"
	ALTER COLUMN "Revision" TYPE int4 USING "Revision"::int4;
	
ALTER TABLE lter_metabase."DataSet"
	ADD CONSTRAINT "FK_DataSet_UpdateFrequency"
	FOREIGN KEY ("UpdateFrequency")
	REFERENCES pkg_mgmt.cv_maint_freq(eml_maintenance_frequency)
	ON UPDATE CASCADE;
	
COMMENT ON COLUMN lter_metabase."DataSet"."ShortName" IS 'Goes into /dataset/shortName.';
	
COMMENT ON COLUMN lter_metabase."DataSet"."UpdateFrequency" IS 'Use controlled vocabulary in pkg_mgmt.cv_maint_freq. goes into /dataset/maintenance/maintenanceUpdateFrequency. ';

COMMENT ON COLUMN lter_metabase."DataSet"."MaintenanceDescription" IS 'Freeform text meant to go into /dataset/maintenance/description/.';
	

CREATE TABLE pkg_mgmt.maintenance_changehistory(
	"DataSetID" integer NOT NULL,
	revision_number integer NOT NULL,
	revision_notes character varying(1024),
	change_scope character varying(50),
	change_date date NOT NULL,
	"NameID" character varying(20) NOT NULL
);

COMMENT ON COLUMN pkg_mgmt.maintenance_changehistory.change_scope IS 'Goes into/dataset/maintenance/changeHistory/changeScope/. E.g.: data, metadata, or data and metadata.';

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "FK_maintenance_changehistory_DataSetID"
	FOREIGN KEY ("DataSetID") 
	REFERENCES lter_metabase."DataSet"("DataSetID")
	ON UPDATE CASCADE;

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "FK_maintenance_changehistory_NameID" 
	FOREIGN KEY ("NameID") 
	REFERENCES lter_metabase."People"("NameID")
	ON UPDATE CASCADE;

ALTER TABLE pkg_mgmt.maintenance_changehistory
	ADD CONSTRAINT "PK_maintenance_changehistory"
	PRIMARY KEY ("DataSetID", revision_number);
	
-- alter dataset view



CREATE OR REPLACE VIEW mb2eml_r.vw_eml_changehistory AS
	SELECT m."DataSetID" AS datasetid, 
		m.revision_number,  
		m.revision_notes,
		m.change_scope,
		m.change_date,
		(p."GivenName")::text AS givenname, 
		p."MiddleName" AS givenname2, 
		p."SurName" AS surname
	FROM (pkg_mgmt.maintenance_changehistory m 
		LEFT JOIN lter_metabase."People" p ON (((m."NameID")::text = (p."NameID")::text))) 
	ORDER BY m."DataSetID", m.revision_number;


ALTER TABLE pkg_mgmt.cv_maint_freq OWNER TO %db_owner%;

REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.cv_maint_freq FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.cv_maint_freq TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.cv_maint_freq TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.cv_maint_freq TO %db_owner%;

ALTER TABLE pkg_mgmt.maintenance_changehistory OWNER TO %db_owner%;

REVOKE ALL ON TABLE pkg_mgmt.maintenance_changehistory FROM PUBLIC;
REVOKE ALL ON TABLE pkg_mgmt.maintenance_changehistory FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE pkg_mgmt.maintenance_changehistory TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.maintenance_changehistory TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.maintenance_changehistory TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_changehistory OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_changehistory FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_changehistory FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_changehistory TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_changehistory TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_changehistory TO %db_owner%;
-- DataSet

ALTER TABLE lter_metabase."DataSet" RENAME COLUMN "SubmitDate" TO "PubDate";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "Investigator";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "DataSetType";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "Georeferences";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "ProjectRelease";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "PublicRelease";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "geographicDescription";
ALTER TABLE lter_metabase."DataSet" DROP COLUMN "Status";

ALTER TABLE lter_metabase."DataSet" ALTER COLUMN "PubDate" TYPE date USING "PubDate"::date;

DROP VIEW mb2eml_r.vw_eml_dataset;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_dataset
AS SELECT d."DataSetID" AS datasetid,
    d."Revision" AS revision_number,
    d."Title" AS title,
    d."Abstract" AS abstract,
    d."ShortName" AS shortname,
    d."UpdateFrequency" AS update_frequency,
    d."MaintenanceDescription" AS maintenance_desc,
    d."PubDate" as pubdate
   FROM lter_metabase."DataSet" d
  ORDER BY d."DataSetID";

ALTER TABLE mb2eml_r.vw_eml_dataset OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_dataset FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_dataset TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_dataset TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_dataset TO %db_owner%;

-- DataSetAttributes

ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN minimum TO "BoundsMinimum";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN maximum TO "BoundsMaximum";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "missingValueCodeExplanation" TO "MissingValueCodeExplanation";

-- DataSet Entities

ALTER TABLE lter_metabase."DataSetEntities" RENAME COLUMN "SortOrder" TO "EntitySortOrder";

-- People

DROP VIEW mb2eml_r.vw_eml_creator;
DROP VIEW mb2eml_r.vw_eml_associatedparty;

ALTER TABLE lter_metabase."People" DROP COLUMN "Honorific";
ALTER TABLE lter_metabase."People" DROP COLUMN "FriendlyName";
ALTER TABLE lter_metabase."People" DROP COLUMN "Phone2";
ALTER TABLE lter_metabase."People" DROP COLUMN "FAX";

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
    p."Phone1" AS phone1,
    p."Email" AS email,
    i."Identificationtype" AS userid_type,
    i."Identificationlink" AS userid
   FROM ((lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."People" p ON (((d."NameID")::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."Peopleidentification" i ON (((d."NameID")::text = (i."NameID")::text)))
  ORDER BY d."DataSetID", d."AuthorshipOrder";


ALTER TABLE mb2eml_r.vw_eml_associatedparty OWNER TO %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_associatedparty TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_associatedparty TO read_only_user;


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
    p."Phone1" AS phone1,
    p."Email" AS email,
    i."Identificationtype" AS userid_type,
    i."Identificationlink" AS userid
   FROM ((lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."People" p ON (((d."NameID")::text = (p."NameID")::text)))
     LEFT JOIN lter_metabase."Peopleidentification" i ON (((d."NameID")::text = (i."NameID")::text)))
  WHERE ((d."AuthorshipRole")::text = 'creator'::text)
  ORDER BY d."DataSetID", d."AuthorshipOrder";


ALTER TABLE mb2eml_r.vw_eml_creator OWNER TO %db_owner%;

GRANT SELECT ON TABLE mb2eml_r.vw_eml_creator TO read_only_user;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_creator TO read_write_user;

-- SiteList

DROP VIEW mb2eml_r.vw_eml_geographiccoverage;

ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "SiteLocation" DROP DEFAULT;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "AltitudeMin" TYPE double precision USING "AltitudeMin"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "AltitudeMax" TYPE double precision USING "AltitudeMax"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "CenterLon" TYPE double precision USING "CenterLon"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "CenterLat" TYPE double precision USING "CenterLat"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "WBoundLon" TYPE double precision USING "WBoundLon"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "EBoundLon" TYPE double precision USING "EBoundLon"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "SBoundLat" TYPE double precision USING "SBoundLat"::double precision;
ALTER TABLE lter_metabase."SiteList" ALTER COLUMN "NBoundLat" TYPE double precision USING "NBoundLat"::double precision;
COMMENT ON COLUMN lter_metabase."SiteList"."SiteType" IS '';

CREATE VIEW mb2eml_r.vw_eml_geographiccoverage AS
 SELECT d."DataSetID" AS datasetid,
    d."EntitySortOrder" AS entity_position,
    d."GeoCoverageSortOrder" AS geocoverage_sort_order,
    d."SiteCode" AS id,
    ((s."SiteName")::text || COALESCE((': '::text || (s."SiteDesc")::text), ''::text)) AS geographicdescription,
    s."NBoundLat" AS northboundingcoordinate,
    s."SBoundLat" AS southboundingcoordinate,
    s."EBoundLon" AS eastboundingcoordinate,
    s."WBoundLon" AS westboundingcoordinate,
    s."AltitudeMin" AS altitudeminimum,
    s."AltitudeMax" AS altitudemaximum,
    s.unit AS altitudeunits
   FROM (lter_metabase."DataSetSites" d
     LEFT JOIN lter_metabase."SiteList" s ON (((d."SiteCode")::text = (s."SiteCode")::text)))
  ORDER BY d."DataSetID", d."GeoCoverageSortOrder", d."SiteCode";


ALTER TABLE mb2eml_r.vw_eml_geographiccoverage OWNER TO %db_owner%;

GRANT SELECT ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_only_user;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_write_user;ALTER TABLE lter_metabase."EMLAttributeCodeDefinition" RENAME TO "DataSetAttributeEnumeration";
ALTER TABLE lter_metabase."AttributeMissingCodes" RENAME TO "DataSetAttributeMissingCodes";
ALTER TABLE lter_metabase."EMLKeywordTypeList" RENAME TO "EMLKeywordTypes";
ALTER TABLE lter_metabase."EMLMeasurementScaleList" RENAME TO "EMLMeasurementScales";
ALTER TABLE lter_metabase."EMLNumberTypeList" RENAME TO "EMLNumberTypes";
ALTER TABLE lter_metabase."EMLStorageTypeList" RENAME TO "EMLStorageTypes";
ALTER TABLE lter_metabase."FileTypeList" RENAME TO "EMLFileTypes";
ALTER TABLE lter_metabase."Peopleidentification" RENAME TO "ListPeopleID";
ALTER TABLE lter_metabase."KeywordThesaurus" RENAME TO "ListKeywordThesauri";
ALTER TABLE lter_metabase."Keywords" RENAME TO "ListKeywords";
ALTER TABLE lter_metabase."MeasurementScaleDomains" RENAME TO "EMLMeasurementScaleDomains";
ALTER TABLE lter_metabase."MissingCodesList" RENAME TO "ListMissingCodes";
ALTER TABLE lter_metabase."People" RENAME TO "ListPeople";
ALTER TABLE lter_metabase."ProtocolList" RENAME TO "ListProtocols";
ALTER TABLE lter_metabase."SiteList" RENAME TO "ListSites";
ALTER TABLE lter_metabase."TaxaList" RENAME TO "ListTaxa";

ALTER TABLE lter_metabase."DataSetAttributeEnumeration" RENAME COLUMN code TO "Code";
ALTER TABLE lter_metabase."DataSetAttributeEnumeration" RENAME COLUMN definition TO "Definition";

ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "PrecisionDateTime" TO "DateTimePrecision";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "PrecisionNumeric" TO "NumericPrecision";
ALTER TABLE lter_metabase."DataSetAttributes" RENAME COLUMN "FormatString" TO "DateTimeFormatString";
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "Description" SET NOT NULL;
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "Description" DROP DEFAULT;
ALTER TABLE lter_metabase."DataSetAttributes" ALTER COLUMN "MeasurementScaleDomainID" SET NOT NULL;


ALTER TABLE lter_metabase."DataSetEntities" RENAME COLUMN "DataAnomalies" TO "AdditionalInfo";


ALTER TABLE lter_metabase."DataSetKeywords" ALTER COLUMN "ThesaurusID" TYPE varchar(50) USING "ThesaurusID"::varchar;
ALTER TABLE lter_metabase."DataSetKeywords" ALTER COLUMN "ThesaurusID" SET DEFAULT 'none'::character varying;


ALTER TABLE lter_metabase."DataSetSites" ALTER COLUMN "EntitySortOrder" SET DEFAULT 0;
ALTER TABLE lter_metabase."DataSetSites" RENAME COLUMN "SiteCode" TO "SiteID";

ALTER TABLE lter_metabase."DataSetTemporal" ALTER COLUMN "EntitySortOrder" SET DEFAULT 0;

ALTER TABLE lter_metabase."ListPeople" RENAME COLUMN "Phone1" TO "Phone";

ALTER TABLE lter_metabase."ListSites" RENAME COLUMN "SiteDesc" TO "SiteDescription";
ALTER TABLE lter_metabase."ListSites" RENAME COLUMN unit TO "AltitudeUnit";
ALTER TABLE lter_metabase."ListSites" RENAME COLUMN "SiteCode" TO "SiteID";

ALTER TABLE lter_metabase."ListSites" DROP CONSTRAINT "CK_SiteRegister_SiteType";

ALTER TABLE lter_metabase."ListPeopleID" RENAME COLUMN "Identificationtype" TO "IdentificationSystem";

ALTER TABLE lter_metabase."ListPeopleID" RENAME COLUMN "Identificationlink" TO "IdentificationURL";

CREATE TABLE lter_metabase."ListTaxonomicProviders" (
	"ProviderID" varchar(20) NOT NULL,
	"ProviderName" varchar(100) NOT NULL,
	"ProviderURL" varchar(250) NULL,
	CONSTRAINT "PK_ListTaxonomicProviders" PRIMARY KEY ("ProviderID")
);

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

ALTER TABLE lter_metabase."ListTaxa" RENAME COLUMN "TaxonomicAuthority" TO "TaxonomicProviderID";

ALTER TABLE lter_metabase."ListTaxa" ALTER COLUMN "TaxonRankValue" SET NOT NULL;

ALTER TABLE lter_metabase."ListTaxa" ADD CONSTRAINT "FK_ListTaxa_ProviderID" FOREIGN KEY ("TaxonomicProviderID") REFERENCES lter_metabase."ListTaxonomicProviders"("ProviderID") ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetTaxa" RENAME COLUMN "TaxonomicAuthority" TO "TaxonomicProviderID";


ALTER TABLE lter_metabase."ListTaxonomicProviders" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListTaxonomicProviders" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListTaxonomicProviders" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListTaxonomicProviders" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListTaxonomicProviders" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListTaxonomicProviders" TO %db_owner%;

DROP VIEW mb2eml_r.vw_eml_taxonomy;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_taxonomy
AS SELECT d."DataSetID" AS datasetid,
    d."TaxonID" AS taxonid,
    p."ProviderName" AS taxonid_provider,
    p."ProviderID" as providerid,
    l."TaxonRankName" AS taxonrankname,
    l."TaxonRankValue" AS taxonrankvalue,
    l."CommonName" AS commonname
   FROM lter_metabase."DataSetTaxa" d
     JOIN lter_metabase."ListTaxa" l ON d."TaxonID"::text = l."TaxonID"::text AND d."TaxonomicProviderID"::text = l."TaxonomicProviderID"::text
     join lter_metabase."ListTaxonomicProviders" p on d."TaxonomicProviderID"::text = p."ProviderID"::text
  ORDER BY d."DataSetID";
 
 ALTER TABLE lter_metabase."ListTaxonomicProviders" OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_taxonomy FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_taxonomy TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_taxonomy TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_taxonomy TO %db_owner%;/*  2019-07-10 redesign of mb tables for eml methods tree */ 

-- DataSetMethodSteps named to allow soft migration path from old DataSetMethods table.
-- ListMethod* prefix to sort together
-- Method* prefix to sort at bottom since optional and less often edited.


-- the three List parent tables

CREATE TABLE lter_metabase."ListMethodSoftware"
(
  "SoftwareID" integer NOT NULL, -- not in EML; used only for xref 
  "Title" character varying(1024), -- required EML methodStep/software/title
  "AuthorSurname" character varying(100), -- methodStep/software/creator/individualName/surName. Repeat allowed in EML but not here. 
  "Description" character varying(5000), -- optional EML additionalInfo
  "Version" character varying(32), -- required EML methodStep/software/version
  "URL" character varying(1024), -- required EML methodStep/software/implementation/distribution/url. 
  CONSTRAINT "PK_SoftwareID" PRIMARY KEY ("SoftwareID"),
  CONSTRAINT "UQ_SoftwareTitleVersion" UNIQUE ("Title","Version") -- because an integer PK is not meaningful.
  );
/* Not using NameID because software author is not necessarily related to your site, so not likely in your ListPeople table.
 * Although EML allows multiple authors, we will only list surname of first author here. Description can say more. 
 * Actually, surname field is plain text so could hack it with an author list. 
 * 
 * Uniq constraint necessary or the SoftwareID is just a flipping autoinc. 
 * 
 * Opted for integer SoftwareId instead of varchar like CPCe13.5.6 or LoggerNet2008a.
 * Would users prefer recognizeable ID?
 */
 
 
--In EML, the instrumentation element is just plain-string type, not even text type. Not like software. 
-- methodStep/instrumentation is a plain string type (not complex text type).
  
ALTER TABLE lter_metabase."ListMethodSoftware" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListMethodSoftware" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListMethodSoftware" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodSoftware" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodSoftware" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListMethodSoftware" TO %db_owner%;


CREATE TABLE lter_metabase."ListMethodInstruments"
(
  "InstrumentID" integer NOT NULL, 
  "Description" character varying(5000) NOT NULL, -- suggest include name, owner, make (brand), model, serial number.
  CONSTRAINT "PK_InstrumentID" PRIMARY KEY ("InstrumentID"),
  CONSTRAINT "UQ_InstrumentDescription" UNIQUE ("Description") -- because an integer PK is not meaningful.
  );

ALTER TABLE lter_metabase."ListMethodInstruments" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListMethodInstruments" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListMethodInstruments" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodInstruments" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodInstruments" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListMethodInstruments" TO %db_owner%;

  
CREATE TABLE lter_metabase."ListMethodProtocols" -- nearly identical to ListProtocols 
(
  "ProtocolID" integer NOT NULL,
  "NameID" character varying(50), -- used to get surname from People table
  "Title" character varying(300),
  "URL" character varying(1024) NOT NULL,
  CONSTRAINT "PK_ProtocolID" PRIMARY KEY ("ProtocolID"),
  CONSTRAINT "FK_DataSet_NameID" FOREIGN KEY ("NameID")
      REFERENCES lter_metabase."ListPeople" ("NameID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "UQ_Protocol_Title" UNIQUE ("Title") -- because an integer PK is not meaningful
);

ALTER TABLE lter_metabase."ListMethodProtocols" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListMethodProtocols" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListMethodProtocols" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListMethodProtocols" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListMethodProtocols" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListMethodProtocols" TO %db_owner%;


-- The main table for Methods

CREATE TABLE lter_metabase."DataSetMethodSteps" -- nearly identical to ListProtocols 
(
    "DataSetID" integer NOT NULL,
    "MethodStepSet" integer NOT NULL,
    "DescriptionType" character varying(10),
    "Description" text,
    "Method_xml" xml, 
   CONSTRAINT "PK_DataSetMethodSteps" PRIMARY KEY ("DataSetID", "MethodStepSet"),
   CONSTRAINT "FK_DataSetMethodSteps_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID"),   
   CONSTRAINT "CK_DataSetMethodSteps_DescriptionType" CHECK ("DescriptionType" IN ('file','md','plaintext')),   
   CONSTRAINT "CK_DataSetMethodSteps_DescriptionHasType" CHECK 
   (("DescriptionType" IS NULL AND "Description" IS NULL) OR ("DescriptionType" IS NOT NULL AND "Description" IS NOT NULL)),
    CONSTRAINT "CK_DataSetMethodSteps_text_or_xml" CHECK ("Description" IS NOT NULL OR "Method_xml" IS NOT NULL)
);

ALTER TABLE lter_metabase."DataSetMethodSteps" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."DataSetMethodSteps" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetMethodSteps" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetMethodSteps" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodSteps" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."DataSetMethodSteps" TO %db_owner%;

-- The three Method* xref tables are all three of the same form.

CREATE TABLE lter_metabase."MethodProtocols"
(
  "DataSetID" integer NOT NULL,
  "MethodStepSet" integer NOT NULL,
  "ProtocolID" integer NOT NULL, 
  CONSTRAINT "PK_DataSetProtocol" PRIMARY KEY ("DataSetID","ProtocolID"),
  CONSTRAINT "FK_DataSetProtocol_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetProtocol_MethodStepSet" FOREIGN KEY ("DataSetID","MethodStepSet") REFERENCES lter_metabase."DataSetMethodSteps" ("DataSetID","MethodStepSet")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetProtocol_ProtocolID" FOREIGN KEY ("ProtocolID") REFERENCES lter_metabase."ListMethodProtocols" ("ProtocolID")
  ON UPDATE CASCADE ON DELETE NO ACTION
  );
  
ALTER TABLE lter_metabase."MethodProtocols" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."MethodProtocols" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MethodProtocols" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MethodProtocols" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."MethodProtocols" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."MethodProtocols" TO %db_owner%;

  CREATE TABLE lter_metabase."MethodSoftware"
(
  "DataSetID" integer NOT NULL,
  "MethodStepSet" integer NOT NULL,
  "SoftwareID" integer NOT NULL, 
  CONSTRAINT "PK_DataSetSoftware" PRIMARY KEY ("DataSetID","SoftwareID"),
  CONSTRAINT "FK_DataSetSoftware_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetSoftware_MethodStepSet" FOREIGN KEY ("DataSetID","MethodStepSet") REFERENCES lter_metabase."DataSetMethodSteps" ("DataSetID","MethodStepSet")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetSoftware_SoftwareID" FOREIGN KEY ("SoftwareID") REFERENCES lter_metabase."ListMethodSoftware" ("SoftwareID")
  ON UPDATE CASCADE ON DELETE NO ACTION
  );

ALTER TABLE lter_metabase."MethodSoftware" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."MethodSoftware" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MethodSoftware" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MethodSoftware" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."MethodSoftware" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."MethodSoftware" TO %db_owner%;

  CREATE TABLE lter_metabase."MethodInstruments"
(
  "DataSetID" integer NOT NULL,
  "MethodStepSet" integer NOT NULL,
  "InstrumentID" integer NOT NULL, 
  CONSTRAINT "PK_DataSetInstrument" PRIMARY KEY ("DataSetID","InstrumentID"),
  CONSTRAINT "FK_DataSetInstrument_DataSetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetInstrument_MethodStepSet" FOREIGN KEY ("DataSetID","MethodStepSet") REFERENCES lter_metabase."DataSetMethodSteps" ("DataSetID","MethodStepSet")
  ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "FK_DataSetInstrument_InstrumentID" FOREIGN KEY  ("InstrumentID") REFERENCES lter_metabase."ListMethodInstruments" ("InstrumentID")
  ON UPDATE CASCADE ON DELETE NO ACTION
  );

ALTER TABLE lter_metabase."MethodInstruments" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."MethodInstruments" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."MethodInstruments" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."MethodInstruments" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."MethodInstruments" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."MethodInstruments" TO %db_owner%;



COMMENT ON SCHEMA lter_metabase IS 'Contains metadata for dataset EML.';
COMMENT ON SCHEMA pkg_mgmt IS 'Contains tables for internal data package inventory and tracking.';
COMMENT ON SCHEMA mb2eml_r IS 'Contains read-only views for exporting to EML via R.';


COMMENT ON COLUMN lter_metabase."DataSetEntities"."EntityType" IS 'One of "dataTable," "spatialVector," "spatialRaster," or "otherEntity."';
COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName. Also used to look up the entity in file system.';

COMMENT ON COLUMN lter_metabase."ListSites"."ShapeType" IS 'one of: point, rectangle, polygon, polyline, vector';

COMMENT ON COLUMN lter_metabase."ListSites"."SiteType" IS 'does not go into EML. this is meant to help LTER sites sort and organize their sampling sites. For example, SBC had "intertidal," "beach," "reef" site types, etc.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteLocation" IS 'does not go into EML. this is meant to help LTER sites organize their sites.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteDescription" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteName" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';
COMMENT ON COLUMN lter_metabase."ListTaxa"."TaxonID" IS 'The taxon ID under the specified taxonomic system (provider).';

COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationURL" IS 'Full URLs under the ID system. E.g: "https://orcid.org/0000-0002-1693-8322"';


COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationSystem" IS 'ID System, e.g. ORCID or LTER LDAP.';

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'Note that if role is not "creator," then the person will go into associatedParty in EML.';
COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipOrder" IS 'This is only relevant for "creator" roles.';

COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName';

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'if not creator, then will go into associatedParty';

COMMENT ON COLUMN lter_metabase."DataSetSites"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';

COMMENT ON COLUMN lter_metabase."DataSetTemporal"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';
-- related to Methods tables, views, and migration

/*  How to migrate from old methods table to new methods tables
 * 
 * 1. load 16_methodStep_tables.sql
 *      this creates the new tables.
 *      Two tables are replacements but have new names so can co-exist with old tables. 
 * 
 * 2. run the select-into scripts to populate the new tables
 * 
 * 3. load the new view for methods
 *      named slightly differently than old view so can co-exist.
 * 
 * 4. test writeEML code (ie MetaEgress). Once it works fine...
 * 
 * 5. drop old view
 * 6. drop old method table and old protocol table
 * 
 *  */
 
 -- migrate content from old DataSetMethods to new tables
 INSERT INTO lter_metabase."DataSetMethodSteps" ("DataSetID", "MethodStepSet", "DescriptionType", "Description")
 (
 SELECT "DataSetID", 
    split_part("methodDocument",'.',3)::integer,
    'file'::character varying(10),
    "methodDocument"
 FROM lter_metabase."DataSetMethods"
 );
 
 INSERT INTO lter_metabase."ListMethodProtocols" ("ProtocolID", "NameID", "Title", "URL")
 (
 SELECT "protocolID", author, title, url
 FROM lter_metabase."ListProtocols" -- or old name "ProtocolList" if mini_sbclter
 
 );
 
 INSERT INTO lter_metabase."MethodProtocols" ("DataSetID", "MethodStepSet", "ProtocolID")
 (
 SELECT "DataSetID", 
    split_part("methodDocument",'.',3)::integer,
    "protocolID"
 FROM lter_metabase."DataSetMethods"
 WHERE "protocolID" IS NOT NULL
 );

 
/* An comments out because version tracker the table isn't created until patch 22
-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,19,now(),'from 19_migration_select_into_and_view_for_methods.sql');
*/-- UPDATE revision and nickname from pkg_mgmt to lter_metabase

-- Exploratory query before migration:
select rev, nickname 
from pkg_mgmt.pkg_state s
JOIN lter_metabase."DataSet" d
ON s."DataSetID"=d."DataSetID"
ORDER BY s."DataSetID"
;
-- if you want to see what datasets are in pkg_mgmt but not in DataSet, do an outer join.
-- The above is just to see prior to runing UPDATE commands.
-- It is normal to have datasets listed in pkg_mgmt that are not in DataSet.

UPDATE lter_metabase."DataSet"
SET "Revision" = s.rev
FROM pkg_mgmt.pkg_state s
WHERE lter_metabase."DataSet"."DataSetID"=s."DataSetID"
;
UPDATE lter_metabase."DataSet"
SET "ShortName" = s.nickname
FROM pkg_mgmt.pkg_state s
WHERE lter_metabase."DataSet"."DataSetID"=s."DataSetID";
/*   select into statements for migration. 
 * 
 * Tables related to normalizing multiple missing value codes for one attribute.
 *
 * (in postgres, select into is actually insert from select. Same thing.)
 * 
 * Only for migration purposes, the old DataSetAttributes column MissingValueCode and "Explanation" 
 * here are used to populate the new ListMissingCodes parent table and 
 * the cross-ref table DataSetAttributeMissingCodes.
 * 
 * At least initially, an integer ID is generated. 
 * The ID field is actually a varchar(20) to allow meaningful strings for human editors, if you so wish.
 * Just edit them in the parent table and the ID will cascade.
 * This is NOT an "autoinc". This is just for initial population.
 * And there is a unique constraint on the other 2 columns so no risk of duplicate tuples.
 * 
*/

-- special for mini_sbclter: m is lowercase in col name "missingValueCodeExplanation"
-- for mini_sbclter, edit this script accordingly.

-- add a uniq constraint to code and explain columns of parent table.
ALTER TABLE lter_metabase."ListMissingCodes"
  ADD CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" UNIQUE ("MissingValueCode", "MissingValueCodeExplanation");
  
COMMENT ON CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" ON lter_metabase."ListMissingCodes"
  IS 'Needed because the ID could be as simple as an integer and is not inherently connected to the code and explanation.';


-- populate parent table

create temporary sequence id_mvc increment by 1 minvalue 1 start with 1 ;

INSERT INTO lter_metabase."ListMissingCodes" ("MissingValueCodeID","MissingValueCode", "MissingValueCodeExplanation")
(
SELECT  
 nextval('id_mvc'), -- gets next integer from sequence  
 "MissingValueCode",
 "MissingValueCodeExplanation" 
 FROM lter_metabase."DataSetAttributes" 
 WHERE "MissingValueCode" is not null
 GROUP BY "MissingValueCode", "MissingValueCodeExplanation"
);

INSERT INTO lter_metabase."DataSetAttributeMissingCodes" ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID")
(
SELECT  "DataSetID", "EntitySortOrder", "ColumnName", c."MissingValueCodeID"
 from lter_metabase."DataSetAttributes" a
 join lter_metabase."ListMissingCodes" c
 on a."MissingValueCode"=c."MissingValueCode" and a."MissingValueCodeExplanation"=c."MissingValueCodeExplanation"
 where a."MissingValueCode" is not null
 );
 
-- Exploratory queries (only run if you just want to see the process)

/*select "DataSetID", "EntitySortOrder", "ColumnName", c."MissingValueCodeID",
 a."MissingValueCode", a."MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 join lter_metabase."ListMissingCodes" c
 on a."MissingValueCode"=c."MissingValueCode" and a."MissingValueCodeExplanation"=c."MissingValueCodeExplanation"
 where a."MissingValueCode" is not null
 ORDER BY a."MissingValueCode", "DataSetID", "EntitySortOrder", "ColumnPosition"
 ;*/
 
-- create metabase version tracker

CREATE TABLE pkg_mgmt.version_tracker_metabase (
	major_version int4 NOT NULL,
	minor_version int4 NOT NULL,
	patch int4 NULL,
	date_installed timestamp NULL,
	"comment" text NULL
);

ALTER TABLE pkg_mgmt.version_tracker_metabase
  ADD CONSTRAINT "PK_version_tracker_metabase" PRIMARY KEY (major_version, minor_version, patch);

 ALTER TABLE pkg_mgmt.version_tracker_metabase OWNER TO %db_owner%;
GRANT SELECT ON TABLE pkg_mgmt.version_tracker_metabase TO read_write_user;
GRANT SELECT ON TABLE pkg_mgmt.version_tracker_metabase TO read_only_user;
GRANT ALL ON TABLE pkg_mgmt.version_tracker_metabase TO %db_owner%;

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(0, 9, 22, now(), 'apply 22_version_tracker');
ALTER TABLE lter_metabase."MethodInstruments" RENAME TO "DataSetMethodInstruments";

ALTER TABLE lter_metabase."MethodProtocols" RENAME TO "DataSetMethodProtocols";

ALTER TABLE lter_metabase."MethodSoftware" RENAME TO "DataSetMethodSoftware";

ALTER TABLE lter_metabase."DataSetMethodSteps" RENAME COLUMN "MethodStepSet" TO "MethodStepID";

CREATE TABLE lter_metabase."DataSetMethodProvenance" (
	"DataSetID" integer NOT NULL,
	"MethodStepID" integer NOT NULL,
	"SourcePackageID" character varying(50)
);

COMMENT ON COLUMN lter_metabase."DataSetMethodProvenance"."SourcePackageID" IS 'packageId of the source data package in the PASTA system. e.g.: knb-lter-ble.1.5';

ALTER TABLE lter_metabase."DataSetMethodProvenance"
	ADD CONSTRAINT "PK_DataSetMethodProvenance"
	PRIMARY KEY ("DataSetID", "SourcePackageID");

ALTER TABLE lter_metabase."DataSetMethodProvenance"
	ADD CONSTRAINT "FK_DataSetMethodProvenance"
	FOREIGN KEY ("DataSetID", "MethodStepID")
	REFERENCES lter_metabase."DataSetMethodSteps" ("DataSetID", "MethodStepID")
	ON UPDATE CASCADE;

ALTER TABLE lter_metabase."DataSetMethodProvenance" OWNER TO %db_owner%;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetMethodProvenance" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."DataSetMethodProvenance" TO %db_owner%;
	
-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,23,now(),'using 23_create_provenance_table.sql');
-- Adds views for items that go in methodStep trees
-- includes GRANTs

-- Rename columns to match convention

ALTER TABLE lter_metabase."DataSetMethodProtocols" RENAME "MethodStepSet"  TO "MethodStepID";
ALTER TABLE lter_metabase."DataSetMethodInstruments" RENAME "MethodStepSet"  TO "MethodStepID";
ALTER TABLE lter_metabase."DataSetMethodSoftware" RENAME "MethodStepSet"  TO "MethodStepID";


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_protocols AS
SELECT m."DataSetID" AS datasetid,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	l."NameID" AS "surName",
	l."Title" AS title,
	l."URL" AS url
FROM lter_metabase."DataSetMethodProtocols" m
JOIN lter_metabase."ListMethodProtocols" l
ON m."ProtocolID"=l."ProtocolID"
;
/*  naming convention here:
 * 
 * These views' output columns are using eml element names such as surName, title, url 
 * for content that goes directly into an element. 
 * When the content is used in business logic, not content, such as datasetid and methodstep_id,
 * then sname case names such as methodstep_id or data_source_packageId are used.
 */
 
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_instruments AS
SELECT m."DataSetID" AS datasetid,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	l."Description" AS "instrument"
FROM lter_metabase."DataSetMethodInstruments" m
JOIN lter_metabase."ListMethodInstruments" l
ON m."InstrumentID"=l."InstrumentID"
;
/* EML element <instrument> is string type. No child elements.
 * The description goes directly into the instrument element. 
 */
 
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_software AS
SELECT m."DataSetID" AS datasetid,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	l."Title" AS "title",
	l."AuthorSurname" AS "surName", -- software/creator/individualName/surName
	l."Description" AS "abstract", -- software/abstract. (optional. rarely used)
	l."URL" AS url, -- software/distribution/online/url
	l."Version" AS version
FROM lter_metabase."DataSetMethodSoftware" m
JOIN lter_metabase."ListMethodSoftware" l
ON m."SoftwareID"=l."SoftwareID"
;
/* About software view above:
 * eml has more xpaths under software than metabase currently supports.
 * software/abstract is not a common xpath.
 */

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_provenance AS
SELECT m."DataSetID" AS datasetid,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	m."SourcePackageID" AS "data_source_packageId"
FROM lter_metabase."DataSetMethodProvenance" m
;
/* Comments on above view:
 * The eml-writing code will get provenance xml from pasta via a curl call using the data_source_packageId.
 * That view column name is NOT an eml element and is not used directly into the eml.
 * That is why it is snake case.
 */

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_methodstep_description AS 
SELECT m."DataSetID" AS datasetid, 
    m."MethodStepID" AS methodstep_id, 
    m."Description" AS description,
    m."DescriptionType" AS description_type
   FROM lter_metabase."DataSetMethodSteps" m; 
 
ALTER TABLE mb2eml_r.vw_eml_protocols OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_protocols TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_protocols TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_protocols TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_instruments OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_instruments TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_instruments TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_instruments TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_software OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_software TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_software TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_software TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_provenance OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_provenance TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_provenance TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_provenance TO %db_owner%;  

   
ALTER TABLE mb2eml_r.vw_eml_methodstep_description OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_methodstep_description TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_methodstep_description TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_methodstep_description TO %db_owner%;

-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,24,now(),'from 24_method_step_views_and_methodstepID_col_name.sql');
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

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(0, 9, 25, now(), 'apply 25_drop_deprecated');
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
