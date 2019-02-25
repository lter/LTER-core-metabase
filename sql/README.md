# README.md
Dir contains the install scripts for LTER-core-metabase. See  [Quick Start guide](../docs/quick_start.md). 

- **0_create_db.sql**
  - creates database named lter_core_metabase
  - a DB admin must run this script
    
- **1_create_schemas_tables.sql**
  - set up three schemas and tables. 
  - example:   `psql -U gastil -h rdb2 -d lter_core_metabase < 1_create_schemas_tables.sql`
- **2_set_perms.sql**
  - for three accounts: the %db_owner% (which you will have renamed to an actual user). read_write_user, read_only_user.
- **3_load_controlled_content.sql** 
  - content for parent tables 
    1. 8 tables for schema pkg_mgmt
    1. 10 tables for schema lter_metabase 
       1. structural EML terms (e.g., measurementScale, storage type)
       1. common file type descriptionss
       1. EML unit dictionary (as used by MCR, SBC LTER)
       1. keywordThesaurus - names and descriptions for 8 commonly used thesauri (sets of keywords)
       1. LTER Controlled vocabulary and LTER Core Research Areas
     
- **4_load_sample_sbc_datasets.sql** 
  - populates 23 tables with 3 sample SBC LTER datasets (lter_metabase). examples' identifiers all start with 99xxx so they can be easily detected.
  - additional keywordThesauri and keywords used by SBC LTER (see below)
  - populates 2 tables in pkg_mgmt (pkg_state and pkg_sort)  
  - Recommendation on [using examples](../docs/example_info.md)

        
        