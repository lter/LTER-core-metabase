# LTER Core Metabase quick start guide

## Outline
1. install pg (if needed)
2.  your DB admin's tasks
    1. set up roles/accts
    1. create DB (make you the owner)
3. your tasks, as the DB owner - run scripts in this order
    1. create tables 
    1. set perms 
    1. load controlled content (recommended)
    1. load sample datasets (optional)


## Details
### Preconditions  
This Guide assumes you have postgreSQL installed, either on a remote server (e.g., institutional), or locally. You (and/or your adminstrator) will also need a mechanism to run SQL commands. This could be done from the command line (e.g., psql), or an SQL pane in a GUI. 

### Caveats
1. There are no instructions here for installing or adminstering postgreSQL. 
1. Other material about LTER-core-metabase is available elsewhere in this repository, e.g, table-population order (for loading your own content).  

### Steps
#### 1. Talk to your DB administrator
You will need PostgreSQL accounts to fill these roles.


| Role | Description | Recommendation |  SQL priviledges |
|--|--|--|--|
| db_owner | the owner of this database (not necessarily the owner/admin of the database server). Creates/deletes schemas, tables, views, triggers, etc. Runs backups, grants priviledges.  |  The DB owner should be a person who aready knows posgreSQL, so most likely, an existing account. The create_db script transfers ownership to the owner acct.  | ALL (DB-level)  |
| read_write_user | Optional intermediate user. Updates row-level content, typicallly with a script. You may not need this role until you have scripts/forms for adding content. | create a new acct named "read_write_user" | UPDATE, INSERT (no DELETE) |
| read_only_user | export, e.g, via script to create EML, or display on a website | create a new acct named "read_only_user" | SELECT  |

#### 2. Customize all SQL scripts 
##### 2.1 Edit tokens for db_owner account name
It should be obvious that you cannot run these SQL scripts directly from the clone; first they must reference existing accounts. You will have to set these values -- definitely for the db_owner account, but not for the others if you follow our recommendations. Scripts are best for this, since DB extensions that appear in this repository will use the account-tokens, and you'll have to reset those for every script. 

E.g., in a linux system, at a minimum you could use sed (with your own directory names of course): 

`sed 's/%db_owner%/gastil/g' git-clone/0_create_db.sql > local/create_db.sql`

##### 2.2 Rename the DB (optional)
The `0_create_db.sql` script names the database `lter_core_metabase`. You may prefer a different name.

#### 3. DB Administrator: create the local database
- 0_create_db.sql

#### 4. DB owner: run local scripts in this order:
- 1_create_schemas_tables.sql 
- 2_set_perms.sql 
- 3_load_controlled_content.sql (recommended)
- 4_load_sample_sbc_datasets.sql (optional)
    
       
             
             
