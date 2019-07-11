
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
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_geographiccoverage TO read_write_user;