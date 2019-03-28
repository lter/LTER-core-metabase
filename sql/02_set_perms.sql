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

