ALTER TABLE if exists semantic_annotation."DataSetAnnotation"
    SET SCHEMA lter_metabase;

ALTER TABLE IF EXISTS semantic_annotation."DataSetAttributeAnnotation"
    SET SCHEMA lter_metabase;

ALTER TABLE IF EXISTS semantic_annotation."EMLObjectProperties"
    SET SCHEMA lter_metabase;

ALTER TABLE IF EXISTS semantic_annotation."EMLSemanticAnnotationTerms"
    SET SCHEMA lter_metabase;

ALTER TABLE IF EXISTS lter_metabase."EMLSemanticAnnotationTerms" RENAME TO "ListSemanticAnnotationTerms";

ALTER VIEW IF EXISTS semantic_annotation.vw_eml_semantic_annotation SET SCHEMA mb2eml_r;

DROP SCHEMA semantic_annotation;

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(1, 0, 43, now(), 'apply 43_move_annotation_tables.sql');