CREATE TABLE lter_metabase."ListPublications"
(
  "PublicationID"  integer,
  "Bibtex"      character varying(2000),
  CONSTRAINT "pk_ListPublications" PRIMARY KEY ("PublicationID"),
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
);


CREATE TABLE lter_metabase."DataSetPublications"
(
  "DataSetID"   integer,
  "Revision" integer,
  "PublicationID"  integer,
  "RelationshipType"      character varying(40),
  CONSTRAINT "pk_DataSetPublications" PRIMARY KEY ("DataSetID","PublicationID"),
  CONSTRAINT "fk_DataSetPublications_DatasetID" FOREIGN KEY ("DataSetID") REFERENCES lter_metabase."DataSet" ("DataSetID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_DataSetPublications_PublicationID" FOREIGN KEY ("PublicationID") REFERENCES lter_metabase."ListPublications" ("PublicationID")
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT "fk_SAA_ObjPropID" CHECK ((("RelationshipType")::text = ANY (ARRAY[('literatureCited'::character varying)::text, 
        ('usageCitation'::character varying)::text, 
        ('referencePublication'::character varying)::text)));
  MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE or replace VIEW lter_metabase.vw_eml_publications
AS
(
    SELECT 
    a."DataSetID" as datasetid, 
    a."Revision" as revision, 
    l."Bibtex" as bibtex,
    d."RelationshipType" as relationship
    FROM lter_metabase."DataSetPublications" d
    INNER JOIN lter_metabase."ListPublications" l
    ON d."PublicationID" = a."PublicationID"
    ORDER BY datasetid
);

ALTER TABLE lter_metabase.vw_eml_publications OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase.vw_eml_publications FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase.vw_eml_publications FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase.vw_eml_publications TO read_write_user;
GRANT SELECT ON TABLE lter_metabase.vw_eml_publications TO read_only_user;
GRANT ALL ON TABLE lter_metabase.vw_eml_publications TO %db_owner%;

ALTER TABLE lter_metabase."ListPublications" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."ListPublications" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."ListPublications" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."ListPublications" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."ListPublications" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."ListPublications" TO %db_owner%;

ALTER TABLE lter_metabase."DataSetPublications" OWNER TO %db_owner%;

REVOKE ALL ON TABLE lter_metabase."DataSetPublications" FROM PUBLIC;
REVOKE ALL ON TABLE lter_metabase."DataSetPublications" FROM %db_owner%;
GRANT SELECT,INSERT,UPDATE ON TABLE lter_metabase."DataSetPublications" TO read_write_user;
GRANT SELECT ON TABLE lter_metabase."DataSetPublications" TO read_only_user;
GRANT ALL ON TABLE lter_metabase."DataSetPublications" TO %db_owner%;

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(1, 0, 42, now(), 'apply 42_add_publications.sql');