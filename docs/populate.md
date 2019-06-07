# Populate LTER-core-metabase

Last updated: June 7th 2019

See [installation here](docs/quick_start.md).

## First round after installation

### Source information

Can be many things. 

## General order of population

EML tables + MeasurementScaleDomains + FileTypeList first. Can run CV SQL script, or targetted export from another instance of metabase. Except for EMLUnitDictionary because EMLUnitTypes is needed. Except for EMLAttributeCodeDefinition because that's dataset-specific.

KeywordThesaurus, then Keywords, then DataSetKeywords.

People, then PeopleID, then DataSet, then DataSetPersonnel

DataSetEntities

SiteList, then DataSetSites.
ProtocolList, then DataSetMethods

DataSetTemporal

DataSetAttributes, then EMLAttributeCodeDefinition.

pkg_mgmt.pkg_state, too, at some point.

Before submission, update submission date and package ID.

## How to update packages

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

1. Increment the version number. Note, you don't add an new row for the new version in the **pkg_state** table.
2. Update the published date in **pkg_state**.
3. Update the file name in **DataSetEntities** if it has changed.

## Confused what goes where?
