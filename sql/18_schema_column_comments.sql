COMMENT ON SCHEMA lter_metabase IS 'Contains metadata for dataset EML.';
COMMENT ON SCHEMA pkg_mgmt IS 'Contains tables for internal data package inventory and tracking.';
COMMENT ON SCHEMA mb2eml_r IS 'Contains read-only views for exporting to EML via R.';


COMMENT ON COLUMN lter_metabase."DataSetEntities"."EntityType" IS 'One of "dataTable," "spatialVector," "spatialRaster," or "otherEntity."';
COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName. Also used to look up the entity in file system.';

COMMENT ON COLUMN lter_metabase."ListSites"."ShapeType" IS 'one of: point, rectangle, polygon, polyline, vector';

COMMENT ON COLUMN lter_metabase."ListSites"."SiteType" IS 'does not go into EML. this is meant to help LTER sites sort and organize their sampling sites. For example, SBC had "intertidal," "beach," "reef" site types, etc.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteLocation" IS 'does not go into EML. this is meant to help LTER sites organize their sites.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteDescription" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';
COMMENT ON COLUMN lter_metabase."ListSites"."SiteName" IS 'SiteName and SiteLocation are concatenated to form geographicDescription in EML.';
COMMENT ON COLUMN lter_metabase."ListTaxa"."TaxonID" IS 'The taxon ID under the specified taxonomic system (provider).';

COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationURL" IS 'Full URLs under the ID system. E.g: "https://orcid.org/0000-0002-1693-8322"';


COMMENT ON COLUMN lter_metabase."ListPeopleID"."IdentificationSystem" IS 'ID System, e.g. ORCID or LTER LDAP.';

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'Note that if role is not "creator," then the person will go into associatedParty in EML.';
COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipOrder" IS 'This is only relevant for "creator" roles.';

COMMENT ON COLUMN lter_metabase."DataSetEntities"."FileName" IS 'goes into physical/objectName';

COMMENT ON COLUMN lter_metabase."DataSetPersonnel"."AuthorshipRole" IS 'if not creator, then will go into associatedParty';

COMMENT ON COLUMN lter_metabase."DataSetSites"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';

COMMENT ON COLUMN lter_metabase."DataSetTemporal"."EntitySortOrder" IS 'convention: if not 0, then specifies the entity the coverage goes under';
