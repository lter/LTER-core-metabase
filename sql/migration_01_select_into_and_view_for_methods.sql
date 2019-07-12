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
 
 
 
 -- Maybe easier for the R code if a separate view for using method external .doc files than combining? If so...
   
CREATE VIEW mb2eml_r.vw_eml_method_document AS
 SELECT m."DataSetID" as datasetid,
    m."MethodStepSet" as methodstep_position,
    --m."DescriptionType" as content_type,
    m."Description" as "methodDocument"
    FROM lter_metabase."DataSetMethodSteps" m
     -- to do: join to sw, instr, proto