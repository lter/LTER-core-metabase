# README.md
Dir contains the install scripts for LTER-core-metabase. See Quick Start guide. 

- 0_create_db.sql
  - creates database named lter_core_metabase
  - a DB admin must run this script
    
- 1_create_schemas_tables.sql
  - set up three schemas and tables. 
  - example:   `psql -U gastil -h rdb2 -d lter_core_metabase < 1_create_schemas_tables.sql`
- 2_set_perms.sql
  - for three accounts: the %db_owner% (which you will have renamed to an actual user). read_write_user, read_only_user.
- 3_load_controlled_content.sql 
  - content for XX parent tables used by metabase 
    1. file type descriptions
    1. etc.
  - keywordThesaurus - names and descriptions for 8 thesauri (sets of keywords)
    1. Darwin Core Terms
    1. Ecological Archives
    1. Essential Biodiversity Variables
    1. Global Change Master Directory (GCMD) v6.0.0.0.0	
    1. Knowledge Network for Biocomplexity (Parent project for EML)
    1. NBII Biocomplexity
    1. LTER Controlled Vocabulary v1
    1. LTER Core Research Areas
  - keywords *only for*
    1. from LTER Controlled vocabulary and 
    1. LTER Core Research Areas 
- 4_load_sample_sbc_datasets.sql 
  - populates 23 tables with 3 sample SBC LTER datasets. examples' identifiers all start with 99xxx so they can be easily detected.
  - additional keywordThesauri specific to SBC LTER
  - keywords used by SBC LTER from the other 6 vocabularies.

