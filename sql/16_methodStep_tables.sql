/*  2019-07-10 redesign of mb tables for eml methods tree */ 

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
GRANT ALL ON TABLE lter_metabase."MethodSoftware" TO %db_owner%;



