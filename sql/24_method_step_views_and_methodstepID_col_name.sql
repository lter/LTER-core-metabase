-- Adds views for items that go in methodStep trees
-- includes GRANTs

-- Rename columns to match convention

ALTER TABLE lter_metabase."DataSetMethodProtocols" RENAME "MethodStepSet"  TO "MethodStepID";
ALTER TABLE lter_metabase."DataSetMethodInstruments" RENAME "MethodStepSet"  TO "MethodStepID";
ALTER TABLE lter_metabase."DataSetMethodSoftware" RENAME "MethodStepSet"  TO "MethodStepID";


CREATE OR REPLACE VIEW mb2eml2.vw_eml_protocols AS
SELECT m."DataSetID" AS dataset_id,
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
 * When the content is used in business logic, not content, such as dataset_id and methodstep_id,
 * then sname case names such as methodstep_id or data_source_packageId are used.
 */
 
CREATE OR REPLACE VIEW mb2eml2.vw_eml_instruments AS
SELECT m."DataSetID" AS dataset_id,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	l."Description" AS "instrument"
FROM lter_metabase."DataSetMethodInstruments" m
JOIN lter_metabase."ListMethodInstruments" l
ON m."InstrumentID"=l."InstrumentID"
;
/* EML element <instrument> is string type. No child elements.
 * The description goes directly into the instrument element. 
 */
 
CREATE OR REPLACE VIEW mb2eml2.vw_eml_software AS
SELECT m."DataSetID" AS dataset_id,
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

CREATE OR REPLACE VIEW mb2eml2.vw_eml_provenance AS
SELECT m."DataSetID" AS dataset_id,
	m."MethodStepID" AS methodstep_id, -- collects and sorts sets of method items
	m."SourcePackageID" AS "data_source_packageId"
FROM lter_metabase."DataSetMethodProvenance" m
;
/* Comments on above view:
 * The eml-writing code will get provenance xml from pasta via a curl call using the data_source_packageId.
 * That view column name is NOT an eml element and is not used directly into the eml.
 * That is why it is snake case.
 */
 
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

-- for when an external Word doc holds methodStep text
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_method_document AS 
SELECT m."DataSetID" AS datasetid, 
    m."MethodStepID" AS methodstep_position, 
    m."Description" AS "methodDocument"
   FROM lter_metabase."DataSetMethodSteps" m
   WHERE m."DescriptionType" like 'file';
   
/* That view was already created in patch 19_ but is moved here since it belongs with these items
 * and needed its WHERE clause.
 */

-- for when methodStep/description/para is plaintext. Goes into a <para>, thus the column name.
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_method_plaintext AS 
SELECT m."DataSetID" AS datasetid, 
    m."MethodStepID" AS methodstep_position, 
    m."Description" AS "para"
   FROM lter_metabase."DataSetMethodSteps" m
   WHERE m."DescriptionType" like 'plaintext';
   
   -- for when methodStep/description is markdown which can contain title, para(s) and other textType elements.
CREATE OR REPLACE VIEW mb2eml_r.vw_eml_method_markdown AS 
SELECT m."DataSetID" AS datasetid, 
    m."MethodStepID" AS methodstep_position, 
    m."Description" AS "description"
   FROM lter_metabase."DataSetMethodSteps" m
   WHERE m."DescriptionType" like 'md';
   
ALTER TABLE mb2eml_r.vw_eml_method_document OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_document TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_document TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_method_document TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_method_plaintext OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_plaintext TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_plaintext TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_method_plaintext TO %db_owner%;

ALTER TABLE mb2eml_r.vw_eml_method_markdown OWNER TO %db_owner%;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_markdown TO read_write_user;
GRANT SELECT ON TABLE mb2eml_r.vw_eml_method_markdown TO read_only_user;
GRANT ALL ON TABLE mb2eml_r.vw_eml_method_markdown TO %db_owner%;

-- record this patch has been applied
INSERT INTO pkg_mgmt.version_tracker_metabase (major_version, minor_version, patch, date_installed, comment) 
VALUES (0,9,24,now(),'from 24_method_step_views_and_methodstepID_col_name.sql');