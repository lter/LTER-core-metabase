# LTER-core-metabase
This README.md was last updated: June 4th, 2021

## Orientation

LTER-core-metabase is a PostgreSQL-based relational database model designed for the management of ecological metadata. This metadata database model is based on usage patterns by sites in the U.S. Long Term Ecological Research (LTER) Network. See [Metabase history](docs/history.md) for more on the project's development history.

LTER-core-metabase is primarily used to produce and maintain Ecological Metadata Language (EML) documents. The [`MetaEgress`](https://github.com/BLE-LTER/MetaEgress) R package is designed for use with LTER-core-metabase. Use `MetaEgress` to quickly and easily export EML documents from an installed and populated instance of LTER-core-metabase.

Although this release is ready for use, the database design team continues active development. We encorage anyone to give it a test drive, but please keep in contact with us for advice prior to installation for use in production. The `master` branch contains installation files for first-time users, while the `migration` branch contains incremental update patches. Check back periodically for update patches on the `migration` branch after installation. 

### Features

Quick [visualization of schema](http://tiny.cc/metabaseSchema).

- Good for metadata management in LTER sites
  - Designed for earth, environmental, and ecological sciences metadata
  - Reuse information across datasets and projects
  - Database constraints for more compliant and better quality metadata
- Companion R package `MetaEgress` to create EML docs quickly and easily
- Supports EML 2.1, (coming) support for EML 2.2

### Known limitations

- LTER-core-metabase design records revision history to the dataset. However, it is only designed to describe the most recent version of the dataset. In other words, updating metadata means overwriting rows, not adding them.

- LTER-core-metabase can store geographic information in rectangles or points, but not polygons of arbitrary shape.  If required, you can archive a shapefile or other geospatial dataset as an `otherEntity` alongside the other data entities in the data package.
 
## Installation

- [LTER-core-metabase quick start guide](docs/quick_start.md)
- [`MetaEgress`](https://github.com/BLE-LTER/MetaEgress)
- Check back periodically for update patches on the `migration` branch after installation.

## Usage

- A number of LTER sites use DBeaver, a GUI-based database manager, to view, populate, and update data in LTER-core-metabase. We have written a [guide on using DBeaver for common DB tasks](docs/dbeaver.md).

- [Populate LTER-core-metabase for EML generation](docs/populate.md)

- [Set up automated backups in Windows](docs/backup.md)

- Use `MetaEgress` to [create EML from LTER-core-metabase](https://github.com/BLE-LTER/MetaEgress/blob/master/docs/articles/usage_example.md)

See the docs folder for a complete list of docs.

A separate project called **EML2MB** takes a collection of pre-existing EML documents, reads the contents from xml and writes in database bulk upload format (similar to a csv). This is for Metabase users who already have many datasets described in EML and want to initially populate a new installatin of Metabase. (This was done in 2013 by SBC and MCR LTER and is being adapted to lter-core-metabase.) When the EML2MB git repo is ready for release, the link will appear here, planned for fall 2019.

## For contributors

See the [contributing guide](CONTRIBUTING.md). 
