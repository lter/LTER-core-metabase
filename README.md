# LTER-core-metabase
Last updated: June 6th, 2019

## Orientation

LTER-core-metabase is a PostgreSQL-based relational database model designed for the management of ecological metadata. This metadata database model is based on usage patterns by sites in the U.S. Long Term Ecological Research (LTER) Network. See [Metabase history]() for more on the project's development history.

LTER-core-metabase is also oriented towards production of Ecological Metadata Language (EML) documents. This project is tightly coupled with the [`MetaEgress`](https://github.com/BLE-LTER/MetaEgress) R package: use `MetaEgress` to quickly and easily export EML documents from an installed and populated instance of LTER-core-metabase.

This project is in early alpha stages and the database design is still under development. 

## Features

- Perfect for metadata management in LTER sites
  - Designed for earth, environmental, and ecological sciences metadata
  - Reuse information across datasets and projects
  - Database constraints for more compliant and better quality metadata
- Companion R package `MetaEgress` to create EML docs quickly and easily
- (coming) support for EML 2.2
 
## Installation

- [LTER-core-metabase quick start guide](docs/quick_start.md)
- [`MetaEgress`](https://github.com/BLE-LTER/MetaEgress)

## Usage

- [Collect metadata from investigators]()
- [Populate LTER-core-metabase](docs/populate.md)
- [Set up automated backups in Windows](docs/backup.md)
- [Create EML from LTER-core-metabase](https://github.com/BLE-LTER/MetaEgress/blob/master/docs/articles/usage_example.md)
