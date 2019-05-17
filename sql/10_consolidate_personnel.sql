-- Note: FIRST: edit %db_owner% to the account name of the DB owner 
-- Note: Execute the DROP commands as owner of the view(s)

DROP VIEW IF EXISTS vw_eml_creator;
DROP VIEW IF EXISTS vw_eml_associatedparty;


CREATE OR REPLACE VIEW mb2eml_r.vw_eml_personnel AS
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

ALTER TABLE mb2eml_r.vw_eml_personnel OWNER to %db_owner%;

REVOKE ALL ON TABLE mb2eml_r.vw_eml_personnel FROM PUBLIC;
REVOKE ALL ON TABLE mb2eml_r.vw_eml_personnel FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE mb2eml_r.vw_eml_personnel TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_personnel TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_personnel TO %db_owner%;