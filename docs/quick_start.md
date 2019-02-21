# LTER Core Metabase quick start guide

## Outline
1. install pg (if needed)
2.  your DB admin's tasks
    1. set up roles/accts
    1. create DB (make you the owner)
3. your tasks, as the DB owner - run scripts in this order
    1. create tables 
    1. set perms 
    1. load controlled content 
    1. load sample datasets (optional)


## Details
### Preconditions:  
This Guide assumes you have postgreSQL installed, either on a remote server (e.g., institutional), or locally. You will also need a mechanism to get content into the database. This could be done with a destop GUI like DBeaver, or by loading text tables from the command line (e.g., psql), or an SQL pane in a GUI. 

### Caveats:
1. There are no instructions here for installing postgreSQL. 
1. Other reference material is available elsewhere in this repository.  

### Steps
#### Talk to your DB administrator
you will need users with these roles set up

  - db_owner (the owner of this database, not necessarily the owner of the database server) ALL privileldges: e.g., CREATE schemas, tables, views, triggers, etc. Runs backups, grants priviledges. INSERT, UPDATE, DELETE content
  - read_write_user: (optional) Intermediate priviledges, UPDATE, INSERT content, typicallly with a script (no DELETE)
  - read_only_user: SELECT only, for export 


#### Customize these sql scripts - edit tokens to account names

- 0_create_db.sql 
- 1_create_schemas_tables.sql
- 2_set_perms.sql

#### Run scripts in this order:
    1. 1_create_schemas_tables.sql 
    1. 2_set_perms.sql 
    1. 3_load_controlled_content.sql (recommended)
    1. 4_load_sample_sbc_datasets.sql (optional)
    
                         
