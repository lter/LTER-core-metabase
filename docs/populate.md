# Populate LTER-core-metabase

Last updated: June 7th 2019

See [installation here](docs/quick_start.md).

This guide walks you through populating LTER-core-metabase, and addresses frequently encountered problems.

## What to do with each schema

The overall database design contains these schemas. They are designed for separate purposes and are loosely self-contained within each of those tasks. 

- `lter_metabase`: contains tables with metadata for EML document generation. You might choose to only populate this schema. TODO: this is true only if An's inplementation of maintenance tracker is accepted. As of now, two tiny pieces of information still come from `pkg_mgmt`: the pkg ID and revision number.

- `mb2eml_r`: contains views for use in exporting to EML docs via `MetaEgress`. Views are auto-generated and updated whenever the parent tables are updated. 

- `pkg_mgmt`: intended for internal metadata management by LTER information managers. 

#### Schema `lter_metabase`

Generally, you will only need to populate controlled-vocabulary parent tables (tables starting with EML) once at the beginning. You might need to update site-specific parent tables (tables ending with List) periodically. You will need to update dataset-specific tables (the rest) with every new dataset or new revision to old datasets.

#### Schema `pkg_mgmt`

TODO

## How to update datasets

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

1. Update corresponding tables with new metadata. E.g. add a new row in **DataSetAttribute** if there's a new column in data, but update the old row if the column name has changed.
2. Increment the version number. Note, you don't add a new row for the new version in the **pkg_state** table.
3. Update the published date in **pkg_state**.


## Confused what goes where?
TODO 

### Project information
boilerplate


## Known wonkinesses and workarounds

#### Issues specific to DBeaver

The pilcrow/paragraph symbol/backwards P. Not sure how these materialize in DBeaver but they do. If present, exported metadata doesn't look any different, but if present in "filename" type columns, files cannot be located. Cannot be deleted by itself, so re-enter the whole field. 

Blanks in DBeaver are NOT the same as NULLs. Be careful when copying and pasting. Constraints/conditions that require NULLs will not work correctly. If pasting whole columns from Excel, need to right-click/Edit/Set to NULL in DBeaver manually.

#### General issues

Remove all hyperlinks in Word documents linked to in abstracts and methods documents.

Note that the m-dash (long) is not valid in numeric fields, as opposed to the n-dash (short) which denotes negative numbers. Not sure how these materialize but they do. 

Any attribute/column with defined codes/categories need to be either nominalEnum or ordinalEnum in MeasurementScaleDomainID. Either of those will be converted into "EnumeratedDomain" in VIEW. If an attribute is not "EnumeratedDomain" then even if there are code-defintion pairs listed for it, the EML::set_attributes() function in EML R package will not import them into EML doc. 