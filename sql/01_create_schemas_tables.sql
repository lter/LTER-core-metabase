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

