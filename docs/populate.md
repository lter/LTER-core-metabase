# Populate LTER-core-metabase for generating EML

Last updated: September 26th 2019

See [installation here](docs/quick_start.md).

This guide walks you through populating LTER-core-metabase for generating EML, and addresses frequently encountered problems.

## What to do with each schema

The overall database design contains these schemas. They are designed for separate purposes and are mostly self-contained for each of those tasks. 

- `lter_metabase`: contains tables with metadata for EML document generation. You might choose to only populate this schema and  be able to generate EML. This guide covers only this schema.

- `mb2eml_r`: contains views for use in exporting to EML docs via `MetaEgress`. Views are read-only, auto-generated and updated whenever the parent tables are updated. 

- `pkg_mgmt`: intended for internal metadata management, data package inventory and tracking by LTER information managers. 

# Schema `lter_metabase`

There are three broad types of tables in `lter_metabase`:

- `EML`-prefixed tables: contain controlled vocabularies specified by the EML schema, or network-level CVs to which sites rarely add, such as units.

- `List`-prefixed tables: contain controlled vocabularies specific to a site such as personnel and sampling sites.

- `DataSet`-prefixed tables: contain information used to create or update specific datasets.

Tables that start with `Method` are analogous to tables that start with DataSet. See the section on Methods to see several ways to populate the methods.

## How to document datasets in `lter_metabase`

Generally, you will only need to populate tables starting with EML once at the beginning and/or use the pre-loaded CVs that come with LTER-core-metabase. You might need to update tables starting with List or site-specific CVs periodically. You will need to update dataset-specific tables (the rest, starting with DataSet) with every new dataset or new revision to old datasets.

## How to update datasets

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

Two cases:
1. Routine time series update (format of data remains the same; new data is appended to pre-existing tables)
2. Dataset redesign (format of data changes: different rows or adding a table)

Case 1: Routine time series update
- In table `DataSetTemporal`, increase column `EndDate`.
- In table `DataSetEntities`, 
	- increase column `EntityRecords` NOTE
	- update column `FileName`
	- increase column `FileSize` NOTE
	- update column `Checksum` NOTE
	
NOTE: If using MetaEgress or another external program which examines data files and inserts file-related metadata directly into the EML, you may choose to skip storing that metadata in metabase.

Case 2: Dataset redesign or non-routine changes
- New dataTable(s) or otherEntities go in table `DataSetEntities` as a new row
- New or modified rows in dataTables go in rows of table `DataSetAttributes`
- New or modified taxonomy goes in `DataSetTaxa` if using pre-defined taxa, or `ListTaxa` if new.
- New or modified geographicCoverage goes in table `DataSetSites` if pre-defined, or `ListSites` if new.
- Or message one of the friendly Metabasers on slack since there's lots of ways a dataset can evolve!

In either case, 
1. Increment `DataSet.Revision`
1. Update `DataSet.pubDate`

## Confused what goes where?
Most of the time tables and column names make it pretty clear where different pieces of metadata is supposed to go. We have als pepper the database with comments on columns where we think there might be confusion. However, for certain pieces it's not so obvious.

### Where does this go?

- PubDate: `DataSet.PubDate`

- Revision: `DataSet.Revision`

- Package ID scope: see boilerplate section below 

- Project information: see boilerplate section below

### What is this table column meant for? Does it populate an EML element?

- `SortOrder` type columns: to make your entities, or coverage elements to sort in a certain order. NOTE: not yet implemented in `MetaEgress`. Authorship order is preserved as put down in metabase. 

- DataSetTemporal.EntitySortOrder and DataSetSites.EntitySortOrder: `coverage`-type elements can be applied to many levels in EML. Most commonly we specify dataset-wide geographic, temporal, and taxonomic coverage. However, if datasets span a large geographical area with wide-spread clusters of sampling, a blanket bounding box might not be informative. In these cases, it might be better to specify coverage at the entity level. However, modeling for that possibility means much added complexity to metabase. We have adopted the following convention: the default for EntitySortOrder is 0, which denotes dataset-level coverage. Anything other than 0 in that column will denote coverage for that entity number. Note that `MetaEgress` does not currently support this convention; it might however in the future.
	
### Boilerplate information

Boilerplate refers information specific to your site reused across almost all if not all of a project's or LTER site's datasets. They include:

 - packageId scope (in `knb-lter-ble.1.1`, `knb-lter-ble` is the scope)
 - the `eml/dataset/contact`, `eml/dataset/metadataProvider`, and `eml/dataset/publisher` trees
 - the `eml/dataset/project` tree, including project abstract, personnel, funding information (both `funding` (freeform text) and `award` (structured element, newly introduced in EML 2.2))
 - the `eml/dataset/intellectualRights` (freeform text) and `eml/dataset/licensed` (structured element, newly introduced in EML 2.2) trees

In previous metabase versions, boilerplate information was stored in a table. As of LTER-core-metabase version 0.9, this information is stored in a flat .xml file (see example boilerplate.xml). We plan to eventually model boilerplate information in LTER-core-metabase; this might entail storing the above pieces in several places especially considering upcoming funding structure in EML 2.2. Update September 24th 2019: boilerplate is now modelled in LTER-core-metabase 1.0 in the table `mb2eml_r.boilerplate`. 

Fill out these trees as applicable to your LTER site or project. Refer
to the [EML best practices
v3](https://environmentaldatainitiative.files.wordpress.com/2017/11/emlbestpractices-v3.pdf)
document. Scope is required. Note that `contact`, `metadata provider`, and `publisher` utilize metabase name IDs, which are controlled in the table `ListPeople`. The corresponding view `mb2eml_r.vw_eml_bp_people` joins the two source tables to return information on personnel, and thus updates when you update `ListPeople`. We thought about implementing the same treatment for personnel within the project tree; however, this requires modeling the project tree, which we thought was a bit overkill. Tell us if you think otherwise.

**NOTE:** `MetaEgress` will not read in other fields not listed above.

### Dataset methods

Note that method-tree-related tables are in active development. Generally, we plan to fully normalize the instrument, software, protocol trees. `DataSetMethods` and `ListProtocols` are two deprecated tables. Update September 24th 2019: these trees are now fully modelled.

Meanwhile, there are two ways to populate an EML methods section from metabase:

- Document-only: only populate the table `DataSetMethodSteps` with a method document filename or plain text, meant to go into /dataset/methods/description. Note that the VIEWs abstraction layer and `MetaEgress` only supports this option as of LTER-core-metabase version 0.9. Update September 24th 2019: VIEWs and `MetaEgress` now support both approaches (minimal, document-only, and normalized, modelled)
- Normalized with content inserted into EML `MethodSteps`: populate `ListMethods*` tables and `DataSetMethod*` tables. Tie them all together in `DataSetMethodSteps`. 

## Known wonkinesses and workarounds

#### Issues specific to DBeaver

The pilcrow/paragraph symbol/backwards P. Not sure how these materialize in DBeaver but they do. If present, exported metadata doesn't look any different, but if present in "filename" type columns, files cannot be located. Cannot be deleted by itself, so re-enter the whole field. 

Blanks in DBeaver are NOT the same as NULLs. Be careful when copying and pasting. Constraints/conditions that require NULLs will not work correctly. If pasting whole columns from Excel, need to right-click/Edit/Set to NULL in DBeaver manually.

#### General notes

Remove all hyperlinks in Word documents linked to in abstracts and methods documents.

Note that the m-dash (long) is not valid in numeric fields, as opposed to the n-dash (short) which denotes negative numbers. Not sure how these materialize but they do. 

Any attribute/column with defined codes/categories need to be either nominalEnum or ordinalEnum in MeasurementScaleDomainID. Either of those will be converted into "EnumeratedDomain" in VIEW. If an attribute is not "EnumeratedDomain" then even if there are code-defintion pairs listed for it, the EML::set_attributes() function in EML R package will not import them into EML doc. 
