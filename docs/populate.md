# Populate LTER-core-metabase for generating EML

Last updated: January 10th, 2020

<!-- MarkdownTOC -->

- [What to do with each schema](#what-to-do-with-each-schema)
- [Schema `lter_metabase`](#schema-lter_metabase)
	- [How to update datasets](#how-to-update-datasets)
	- [How to create new datasets](#how-to-create-new-datasets)
- [Confused what goes where?](#confused-what-goes-where)
		- [Where does this go?](#where-does-this-go)
		- [What is this table column meant for? Does it populate an EML element?](#what-is-this-table-column-meant-for-does-it-populate-an-eml-element)
		- [Boilerplate information](#boilerplate-information)
		- [Dataset methods](#dataset-methods)
- [Schema `mb2eml_r`](#schema-mb2eml_r)
- [Schema `pkg_mgmt`](#schema-pkg_mgmt)
- [Schema `semantic_annotation`](#schema-semantic_annotation)
	- [Known wonkinesses and workarounds](#known-wonkinesses-and-workarounds)
		- [Issues specific to DBeaver](#issues-specific-to-dbeaver)
		- [General notes](#general-notes)

<!-- /MarkdownTOC -->


See [installation here](quick_start.md).

This guide walks you through populating LTER-core-metabase for generating EML, and addresses frequently encountered problems. 

CV means "controlled vocabulary" as in parent table, not as in the LTER Controlled Vocabulary Thesaurus.

<a id="what-to-do-with-each-schema"></a>
## What to do with each schema

The overall database design contains these schemas. They are designed for separate purposes and are mostly self-contained for each of those tasks.

- `lter_metabase`: contains tables with metadata for EML document generation. You might choose to only populate this schema and  be able to generate EML. This guide covers only this schema.

- `mb2eml_r`: contains views for use in exporting to EML docs via `MetaEgress`. Views are read-only, auto-generated and updated whenever the parent tables are updated.

- `pkg_mgmt`: intended for internal metadata management, data package inventory and tracking by LTER information managers.

- `semantic_annotation`: contains tables for annotating datasets and attributes.

<a id="schema-lter_metabase"></a>
# Schema `lter_metabase`

There are four (but really only three) broad types of tables in `lter_metabase`:

- `EML`-prefixed tables: contain controlled vocabularies specified by the EML schema, or network-level CVs to which sites rarely add, such as units. Examples:
  - `EMLFileTypes`
  - `EMLKeywordTypes`
  - `EMLMeasurementScaleDomains`
  - `EMLMeasurementScales`
  - `EMLNumberTypes`
  - `EMLStorageTypes`
  - `EMLUnitDictionary`
  - `EMLUnitTypes`

- `List`-prefixed tables: contain controlled vocabularies specific to a site such as personnel and sampling sites.
  - `ListKeywordThesauri`
  - `ListKeywords`
  - `ListMethodInstruments`
  - `ListMethodProtocols`
  - `ListMethodSoftware`
  - `ListMissingCodes`
  - `ListPeople`
  - `ListSites`
  - `ListTaxa`
  - `ListTaxonomicProviders`

- `DataSet`-prefixed tables: contain information used to create or update specific datasets.
  - (Tables are listed below in population order for new datasets.)

- `DataSetMethod`-prefixed tables pertain to method content. See the section on
  Methods to see several ways to describe methods used to create the ecological
  datasets described by this database.


Generally, you will only need to populate tables starting with EML once at the beginning and/or use the pre-loaded CVs that come with LTER-core-metabase. Tables starting with List contain site-specific CVs which tend to need additions occasionally. You will need to update dataset-specific tables (table names starting with DataSet) to add a new dataset or to revise existing datasets.

<a id="how-to-update-datasets"></a>
### How to update datasets

When describing a new version of a dataset for which a previous version was already described in the database, you overwrite existing values with updated values. In other words, you only store the metadata for the updated/new version. You won't be able to generate EML for the old data and old metadata (unless you change everything back to the old version in your database tables).

Two cases:

1. Routine time series update (format of data remains the same; new data is appended to pre-existing tables)
2. Dataset redesign (format of data changes: different rows or adding a table)

Case 1: Routine time series update

- In table `DataSetTemporal`, increase column `EndDate`.
- In table `DataSetEntities`, update these columns (and see NOTE below):
  - `EntityRecords`
  - `FileName`
  - `FileSize`
  - `Checksum`
  
NOTE: If using MetaEgress or another external program which examines data files and inserts file-related metadata directly into the EML, you may choose to skip storing that metadata in metabase.

Case 2: Dataset redesign or non-routine changes

- New dataTable(s) or otherEntities go in table `DataSetEntities` as a new row
- New or modified rows in dataTables go in rows of table `DataSetAttributes`
- New or modified taxonomy goes in `DataSetTaxa`. Also update `ListTaxa` if taxa
  are not already defined there.
- New or modified geographicCoverage goes in table `DataSetSites` if pre-defined, or `ListSites` if new.
- Or message one of the friendly Metabasers in the Metabase channel on [Slack](https://lter.slack.com) since there are lots of ways a dataset can evolve!

In either case,

1. Increment `DataSet.Revision`
1. Update `DataSet.pubDate`

<a id="how-to-create-new-datasets"></a>
### How to create new datasets

For simplicity, let's assume the parent tables (EMLStuff and ListStuff) are already populated. Most of the DataSetStuff tables are cross-reference tables, selecting an item from a parent table and attaching it to a dataset, or at dataTable of that dataset, or an attribute of a dataTable of that dataset. 

1. `DataSet`: enter one new row for the new dataset. This must be done first. 
1. `DataSetEntities` must be filled before
	1. `DataSetAttributes` which must be filled before these, which are optional and in any order:
		1. `DataSetAttributeEnumeration`
		1. `DataSetAttributeMissingCodes`
1. `DataSetMethodSteps` must be filled before these, which are optional and in any order:
	1. `DataSetMethodInstruments`
	1. `DataSetMethodProtocols`
	1. `DataSetMethodProvenance`
	1. `DataSetMethodSoftware`
1. These may be filled any time after `DataSet`, and in any order:
    1. `DataSetKeywords`
    1. `DataSetPersonnel`
    1. `DataSetSites`
    1. `DataSetTaxa`
    1. `DataSetTemporal`

<a id="confused-what-goes-where"></a>
## Confused what goes where?
Most of the time tables and column names make it pretty clear where different pieces of metadata is supposed to go. We have peppered the database with comments on columns where we think there might be confusion. However, for certain pieces it's not so obvious.

<a id="where-does-this-go"></a>
#### Where does this go?

- Publication date of a dataset: `DataSet.PubDate`

- Revision number of a dataset: `DataSet.Revision`

- Maintenance description and update frequency: `DataSet.MaintenanceDescription` and `DataSet.UpdateFrequency`. Note that the latter is subject to a EML-imposed controlled vocabulary.

- Maintenance change history (i.e. what changes from one revision to the next): `pkg_mgmt.maintenance_changehistory`. 

- Package ID scope: i.e. the "knb-lter-ble" part in a complete valid package ID "knb-lter-ble.2.1". For this see boilerplate section below.

- Project information: see boilerplate section below.

<a id="what-is-this-table-column-meant-for-does-it-populate-an-eml-element"></a>
#### What is this table column meant for? Does it populate an EML element?

- `SortOrder` type columns: to make your entities, or coverage elements to sort in a certain order. NOTE: not yet implemented in `MetaEgress`. Authorship order is preserved as entered in metabase.

- `DataSetTemporal.EntitySortOrder` and `DataSetSites.EntitySortOrder`: In EML, `coverage`-type elements can be applied to many levels. Most commonly we specify dataset-wide geographic, temporal, and taxonomic coverage. However, if datasets span a large geographical area with wide-spread clusters of sampling, a blanket bounding box might not be informative. In these cases, it might be better to specify coverage at the entity level. However, modeling for that possibility means much added complexity to metabase. We have adopted the following convention: the default for EntitySortOrder is 0, which denotes dataset-level coverage. Anything other than 0 in that column will denote coverage for that entity number. Note that `MetaEgress` does not currently support this convention; it might however in the future.

<a id="boilerplate-information"></a>
#### Boilerplate information

Boilerplate refers to information specific to your project or LTER site that is
reused across most if not all of your datasets, including:

- packageId scope (in `knb-lter-ble.1.1` for example, `knb-lter-ble` is the scope)
- the `eml/dataset/contact`, `eml/dataset/metadataProvider`, and `eml/dataset/publisher` trees
- the `eml/dataset/project` tree, including project abstract, personnel, funding information (both `funding` (freeform text) and `award` (structured element, introduced in EML 2.2))
- the `eml/dataset/intellectualRights` (freeform text) and `eml/dataset/licensed` (structured element, introduced in EML 2.2) trees

Boilerplate is modelled in LTER-core-metabase in the table
`mb2eml_r.boilerplate`.  Some columns in that table are of type XML, within
which you would place the EML snippet as appropriate for that column. For
example, in the `licensed` column, you could have:

```xml
<licensed>
  <licenseName>Creative Commons Zero v1.0 Universal</licenseName>
  <url>https://spdx.org/licenses/CC0-1.0.html</url>
  <identifier>CC0-1.0</identifier>
</licensed>
```

Fill out these trees as applicable to your LTER site or project. Refer
to the [EML best practices
v3](https://environmentaldatainitiative.files.wordpress.com/2017/11/emlbestpractices-v3.pdf)
document. Scope is required. Note that `contact`, `metadata provider`, and `publisher` utilize metabase name IDs, which are controlled in the table `ListPeople`. The corresponding view `mb2eml_r.vw_eml_bp_people` joins the two source tables to return information on personnel, and thus updates when you update `ListPeople`. We thought about implementing the same treatment for personnel within the project tree; however, this requires modeling the project tree, which we thought was a bit overkill. Tell us if you think otherwise.

NOTE: `MetaEgress` will not read in other fields not listed above.

<a id="dataset-methods"></a>
#### Dataset methods

Metabase can describe dataset collection and sampling methods, instruments, software, protocols, and
other aspects related to how data were generated. There are two ways to populate an EML methods section from metabase:

- Document-only: only populate the table `DataSetMethodSteps` with a method
  document filename or plain text, meant to go into /dataset/methods/description
  of EML.
- Normalized with content inserted into EML `MethodSteps`: populate `ListMethods*` tables and `DataSetMethod*` tables. Tie them all together in `DataSetMethodSteps`.

Note that the VIEWs abstraction layer and `MetaEgress` support both approaches
(minimal, document-only, and normalized, modelled).

<a id="schema-mb2eml_r"></a>
# Schema `mb2eml_r`

Nothing to do here. The only table is `boilerplate`. See section above. Everything else is VIEWs for `MetaEgress`.

<a id="schema-pkg_mgmt"></a>
# Schema `pkg_mgmt`

There are a lot of tables in this schema; however as of 2020-01-10, we have not critically reviewed these tables for
their usefulness beyond SBC/MCR LTER. 

The only table whose information can be exposed to EML via `MetaEgress` is `pkg_mgmt.maintenance_changehistory`. 

Another table of note is `version_tracker_metabase`. This tracks changes to the schema of your installation of LTER-core-metabase itself. Due to the evolving nature of the schema, any one installation of metabase will eventually need to be updated with patches. It's our team practice to write an INSERT statement to this table in each patch, and so by executing the patches on your installation, this table records the patches and the time installed.

<a id="schema-semantic_annotation"></a>
# Schema `semantic_annotation`

This schema contains tables to annotate your datasets and table attributes with semantic annotations from established ontologies. The same rules of thumb about table prefixes and population order from before apply here, i.e. fill out `EMLAnnotationTerms` and `EMLObjectProperties` first before `DataSetAnnotations` and `DataSetAttributeAnnotations`. 

`EMLAnnotationTerms` are meant to contain terms that are concepts, measurements, etc, e.g. "temperature", "current speed". Recommended ontologies: ESCO, ENVO, SWEET. 

`EMLObjectProperties` are meant to contain terms that denote relationships between terms, e.g. "isAbout" or "containsMeasurementsOf". Recommended ontologies: OBOE.

<a id="known-wonkinesses-and-workarounds"></a>
### Known wonkinesses and workarounds

<a id="issues-specific-to-dbeaver"></a>
#### Issues specific to DBeaver

The pilcrow/paragraph symbol/backwards P. Not sure how these materialize in DBeaver but they do. If present, exported metadata doesn't look any different, but if present in "filename" type columns, files cannot be located. Cannot be deleted by itself, so re-enter the whole field.

Blanks in DBeaver are NOT the same as NULLs. Be careful when copying and
pasting. Constraints/conditions that require NULLs will not work correctly. If
pasting whole columns from Excel, you need to right-click/Edit/Set to NULL in DBeaver manually.

<a id="general-notes"></a>
#### General notes

Remove all hyperlinks in Word documents linked to in abstracts and methods documents.

Note that the m-dash (long) is not valid in numeric fields, as opposed to the n-dash (short) which denotes negative numbers.

Any column with defined codes or categories needs to be either nominalEnum
or ordinalEnum in `MeasurementScaleDomainID`. Either of those will be converted
into "EnumeratedDomain" in VIEW. If an attribute is not "EnumeratedDomain" then
even if there are code-defintion pairs listed for it, the EML::set_attributes()
function in the EML R package will not import them into the EML document.
