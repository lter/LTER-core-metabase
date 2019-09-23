# Metabase History


![Metabase history](https://github.com/mobb/ucsb_metabase_documentation/blob/master/background/Metabase_history.png)


<table>
<tr>
<th>
&nbsp;
</th>

<th>
GCE metabase
</th>

<th>
SBC, MCR metabase
</th>

<th>
SBC MBON data packages
</th>

<th>
SBC LTER data packages
</th>

</tr>

<tr>
<th>
Uses
</th>

<td>
<ul>
<li>GCE Matlab toolbox, 
<li>drives GCE website (people, biblio, datasets, projects, other)
<li>Annual report contributions

</td>

<td>
<ul>
<li>Initial
<ul>
<li>datasets: holds all content from exant EML
<li>research projects: all content for research projects (lterProject XML exported)
</ul>
<li>Anticipated 
<ol>
<li>drive website (part)
<li>biblio mgmt
<li>GCE Toolbox

</td>

<td>
<ul>
<li>Assemble EML records with R
<li>EML text content in external files
</td>

<td>
<ul>
<li>Assemble EML records with R  
<li>EML text content in external files
<li>Anticipated 
<ol>
<li>drive website (part, TBD)
<li>biblio mgmt
</td>

</tr>



<tr>
<th>
Features
</th>

<td>
<ul>
<li>SQL server (Microsoft)
<li>num schemas: ___
<li>Num tables: ___

</td>

<td>
<ul>
<li>PostgreSQL (open source)
<li>MCR, SBC schemas synchronized
<li>uses built-in XML data type
<li>num schemas: 5
<li>num tables: ___
</td>

<td>
<ul>
<li>PostgreSQL
<li>num schemas: 3
<li>num tables: 22, 6 (10 views)
</td>

<td>
<ul>
<li>PostgreSQL
<li>num schemas: ___
<li>num tables: ___
</td>

</tr>


<tr>
<th>
Activities
</th>

<td>
&nbsp;
</td>

<td>
2011
<ul>
<li>Ported to postgreSQL
<li>populated project schema

</ul>
2013
<ul>
<li>populated tables for datasets (16), concurrently with
<ul><li>14 forks (see forks/gce2ucsb)
<li>added 2 schemas: mb2EML (for export), pkg_mgmt
</ul>
</ul>

</td>

<td>
2015
<ul>
<li>dropped empty tables 
<li>replaced XML-typed fields
<li>tailored views for EML production with R
</td>

<td>
2017
<ul>
<li>copy schema, migrate content
</ul>
2018
<ul>
<li>judicious additions from sbc_metabase, for anticipated uses (above)
</td>

</tr>
</table>


## Further Reading
Gastil-Buhl, M. and M. O'Brien. 2013.
Data Package Inventory Tracking: Slicing and Dicing with SQL.
LTER Spring 2013 Databits.

Kui Li. 2018.
Postgres, EML and R in a data management workflow [EDI webinar](https://environmentaldatainitiative.org/events/training-webinars-workshops/previous-edi-events/postgres-eml-and-r-in-a-data-management-workflow/)

Kui Li and M. O’Brien. 2018.
Postgres, EML and R in a data management workflow.
LTER Spring 2018 Databits.

O'Brien M. and M. Gastil-Buhl. 2013.
Metabase Adoption by SBC and MCR
LTER Spring 2013 Databits.

O'Brien, M. 2011.
The Santa Barbara Coastal (SBC) LTER's implementation of projectDB using Metabase
LTER Fall 2011 Databits.

Sheldon, W.M. Jr., J. F. Chamblee, and R. Cary. 2012. 
Poster: GCE Data Toolbox and Metabase: A
sensor-to-synthesis software pipeline for LTER data management. 2012 LTER All Scientists Meeting,
11-Sep-2012, Estes Park, Colorado.

Sheldon W. and J. Carpenter, 2010. 
Implementing ProjectDB at the Georgia Coastal Ecosystems. 
LTER Fall 2010 Databits.


## Related GitHub Repositories
**Code to read from SBC or MCR metabase, create EML records**: 
https://github.com/mobb/MB2EML

**Code for SBC metabase maintenance (incomplete)**:
https://github.com/mobb/MBmaint

### Models spawned by GCE-metabase
**UCSB LTER metabase (2013, by SBC and MCR LTER)**:
tbd

**created and used by Santa Barbara Channel MBON (SBC MBON)**:
tbd

**SBC LTER modifications**:
tbd

## Core Metabase compared to the full GCE Metabase

LTER-core-metabase isn't a pure subset of Metabase. It combines separate Metabase tables into a single table in some cases, and opts for a single field like instrumentDescription instead of separate tables for instrument model information and calibration and parameters for example. Another example: Metabase allows you to describe individual method steps in a separate table, whereas LTER-core-metabase relies on an external Word document in which you could outline individual method steps if you wanted.  LTER-core-metabase is intended to accommodate basic dataset description needs with a focus on supporting EML generation and leaves other content to be handled by a given site or project.

Metabase supports these broad categories of information while LTER-core-metabase does not (at least not directly):

* Projects, like a DNA sampling project that happened for a few years under your LTER
* Links to species
* Links to publications
* Supplemental info, like data anomalies, materials, dataset usage notes, general comments
* Demographic info for personnel. This was included in Metabase for NSF reporting; however, now that NSF emails project personnel directly to ask for this information, it is not as critical to store demographic details in the database.
* Supervisor and committee member details for personnel
* NSF-funded project list for personnel
* Polygons to represent geographic areas
* More detail on geographic descriptions, like site history, hydrography, geology, etc., and site coordinates in decimal degrees, DMS, and UTM coordinates
* Website supporting materials like web map identifiers, map filenames and formats, personnel profile pages, links to profile pictures


## Do you anticipate needing these features?
These sorts of features (e.g., as in original GCE Metabase) can be added to LTER-core-metabase as extensions. Best practice is to explore what has been done already in your community, and look for ways to adopt common solutions. See the full documentation and issues list for suggested features.