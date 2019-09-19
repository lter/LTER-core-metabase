
# add position to personnel-related tables and views
# meant to go into the EML element positionName


ALTER TABLE lter_metabase."ListPeople" ADD "Position" varchar(100) NULL;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_bp_people
AS SELECT b.bp_setting,
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
    p."Position" as position
   FROM lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON b.publisher_nameid::text = p."NameID"::text
     LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID"::text = p."NameID"::text
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
    p."Position" as position
   FROM lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON b.metadata_provider_nameid::text = p."NameID"::text
     LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID"::text = p."NameID"::text
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
    p."Position" as position
   FROM lter_metabase."ListPeople" p
     JOIN mb2eml_r.boilerplate b ON b.contact_nameid::text = p."NameID"::text
     LEFT JOIN lter_metabase."ListPeopleID" i ON i."NameID"::text = p."NameID"::text;


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_associatedparty
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
    p."Phone" AS phone1,
    p."Email" AS email,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Position" as position
   FROM lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."ListPeople" p ON d."NameID"::text = p."NameID"::text
     LEFT JOIN lter_metabase."ListPeopleID" i ON d."NameID"::text = i."NameID"::text
  ORDER BY d."DataSetID", d."AuthorshipOrder";

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
    p."Phone" AS phone1,
    p."Email" AS email,
    i."IdentificationSystem" AS userid_type,
    i."IdentificationURL" AS userid,
    p."Position" as position
   FROM lter_metabase."DataSetPersonnel" d
     LEFT JOIN lter_metabase."ListPeople" p ON d."NameID"::text = p."NameID"::text
     LEFT JOIN lter_metabase."ListPeopleID" i ON d."NameID"::text = i."NameID"::text
  WHERE d."AuthorshipRole"::text = 'creator'::text
  ORDER BY d."DataSetID", d."AuthorshipOrder";




ALTER TABLE mb2eml_r.boilerplate DROP COLUMN license CASCADE;
ALTER TABLE mb2eml_r.boilerplate ADD intellectual_rights xml;
COMMENT ON COLUMN mb2eml_r.boilerplate.intellectual_rights IS 'the old freeform text EML element';
ALTER TABLE mb2eml_r.boilerplate ALTER COLUMN contact_nameid SET NOT NULL;
ALTER TABLE mb2eml_r.boilerplate ADD licensed xml NULL;
COMMENT ON COLUMN mb2eml_r.boilerplate.licensed IS 'the new structured EML 2.2 element';


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_boilerplate AS 
	SELECT bp_setting as bp_setting,
	scope as scope,
	system as system,
	access as access,
	distribution as distribution,
	project as project,
	intellectual_rights as intellectual_rights,
	licensed as licensed
	FROM mb2eml_r.boilerplate;

ALTER TABLE mb2eml_r.vw_eml_boilerplate OWNER TO %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_boilerplate FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_boilerplate FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_boilerplate TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_boilerplate TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_boilerplate TO %db_owner%;

  -- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,32,now(),'applied 31_add_position_licensed.sql');