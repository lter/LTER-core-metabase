# LTER-core-metabase

LTER_core-metabase is a relational database model (Postgres), based on the GCE LTER Metabase, with adaptations by UCSB LTER sites.

For the history, see wiki:
https://github.com/lter/LTER-core-metabase/wiki/Metabase-history

## Order To Populate Tables

Populate parent tables first. Here is one example; your workflow may vary depending on the nature of the dataset you are describing.

1. People
2. Keywords
3. DataSet
4. DataSetKeywords and DataSetPersonnel
5. DataSetEntities
6. DataSetAttributes, DataSetMethods, DataSetSites, and DataSetTemporal.

A note on **EMLAttributeDictionary**: This is a placeholder for the EML 2.2 ontology part where to map your measurement to vocabulary sources such as Darwin Core.

## How Do I Describe X

### ORCID

ORCIDs go in the **Peopleidentification** table. The **Identificationtype** is `ORCID` and the **Identificationlink** is the ORCID, e.g., `0000-0002-1940-4158`.

## What To Change for a New Dataset Version

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

1. Increment the version number. Note, you don't add an new row for the new version in the **pkg_state** table.
2. Update the published date in **pkg_state**.
3. Update the file name in **DataSetEntities** if it has changed.

## Files That Are Not Tabular Data

Other data types, such as R scripts or netCDF files, are recorded in the **DataSetEntities** table with an **EntityType** value of `otherEntity`.

## Limitations

### Only the Most Recent Dataset Version

The current system doesn't record provenance across dataset versions or the history of dataset versions. It is only designed to describe the most recent version of the dataset.

### No Polygons in DataSetSites

DataSetSites can store rectangles in geographic coordinates or points, but not polygons of arbitrary shape.  If required, you can archive a shapefile or other geospatial dataset with your data tables and mark it with an **EntityType** value of `otherEntity`.

### Only One Missing Value Code

**MissingValueCode** is an attribute in **DataSetAttributes** which indicates the missing value code in your data. It assumes you only have one missing value code.