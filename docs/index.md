# LTER-core-metabase

LTER_core-metabase is a relational database model (Postgres), based on the GCE LTER Metabase, with adaptations by UCSB LTER sites. The "core" part of the name has two meanings: (1) A shared base of code designed to avoid divergence of versions at LTER sites and (2) the part of the original Metabase which pertains to EML metadata.

## Table of Contents

- [Quick Start](quick_start.md) Installation Guide
- Order to [Populate Tables](populate.md)
- [Create EML from LTER-core-metabase](https://github.com/BLE-LTER/MetaEgress/blob/master/docs/articles/usage_example.md)
- [History of LTER metabase designs](history.md)
- [Guide on using DBeaver for common metabase tasks](dbeaver.md)
- [Backing up the database](backup.md)

Interactive [visualization using schemaSpy](http://sbc.lternet.edu/external/InformationManagement/LTER_IMC/tmp_lter_core_metabase/schemaSpy_docs/): (temporary page)
(To build your own view of the database, try [SchemaSpy](ERD/how_to_schemaSpy).)

# Miscellanea not covered by other docs (yet):

## How Do I Describe X

### ORCID

ORCIDs go in the **ListPeopleID** table. The **IdentificationSystem** is `ORCID` and the **IdentificationURL** is the ORCID, e.g., `https://orcid.org/0000-0002-1940-4158`.

## What To Change for a New Dataset Version

See also [populate](populate.md).

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

1. Increment the revision number in **DataSet**, and update the published date, PubDate.
1. Note, do not add a new row for the new version in the **pkg_state** table (in schema pkg_mgmt.)
1. Update the published date, update_date_catalog, in **pkg_state** after uploading the dataset to the
   archive.
1. See more complete list in [populate](populate.md).

## Files That Are Not Tabular Data

Other data types, such as R scripts or netCDF files, are recorded in the **DataSetEntities** table with an **EntityType** value of `otherEntity`.

## Limitations

### Only the Most Recent Dataset Version

The current system is only designed to describe the most recent version of the
dataset.  Values in tables describing a given dataset are overwritten as needed
for a new version of the dataset.  If recording provenance is desired, you can
author revision notes in the **maintenance_changehistory** table in the pkg_mgmt
schema.

### No Polygons in DataSetSites

**DataSetSites** can store rectangles in geographic coordinates or points, but not polygons of arbitrary shape.  If required, you can archive a shapefile or other geospatial dataset with your data tables and mark it with an **EntityType** value of `otherEntity`.

### EML2.2

New tables and columns to support EML2.2 are already being added but as of Version1.0, metabase does not yet support all the new features. (Sneak preview: a schema for semantic_annotation is submitted and in review by our own in house expert, aka MOB.)
