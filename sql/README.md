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
- 4_load_sample_sbc_datasets.sql 

