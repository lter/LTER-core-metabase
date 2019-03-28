-- Note: FIRST: edit %db_owner% to the account name of the DB owner 

-- View: mb2eml_r.vw_eml_associatedparty

-- DROP VIEW mb2eml_r.vw_eml_associatedparty;

CREATE OR REPLACE VIEW mb2eml_r.vw_eml_associatedparty AS
 SELECT d."DataSetID" AS datasetid, d."AuthorshipOrder" AS authorshiporder, 
    d."NameID" AS nameid, p."GivenName"::text AS givenname, 
    p."MiddleName" AS givenname2, p."SurName" AS surname, 
    p."Organization" AS organization, p."Address1" AS address1, 
    p."Address2" AS address2, p."Address3" AS address3, p."City" AS city, 
    p."State" AS state, p."Country" AS country, p."ZipCode" AS zipcode, 
    p."Phone1" AS phone1, p."Phone2" AS phone2, p."FAX" AS fax, 
    p."Email" AS email, p."WebPage" AS onlineurl, d."AuthorshipRole" AS role
   FROM lter_metabase."DataSetPersonnel" d
   LEFT JOIN lter_metabase."People" p ON d."NameID"::text = p."NameID"::text
  WHERE d."AuthorshipRole"::text <> ALL (ARRAY['creator'::text, 'metadataProvider'::text, 'contact'::text, 'publisher'::text])
  ORDER BY d."DataSetID", d."AuthorshipOrder";

ALTER TABLE mb2eml_r.vw_eml_associatedparty
    OWNER TO %db_owner%;



