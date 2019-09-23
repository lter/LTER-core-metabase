# LTER-core-metabase quick installation guide

## Outline
1. install PostgreSQL (if needed)
2.  your DB admin's tasks
    1. set up roles
    1. create DB (make you the owner)
3. your tasks, as the DB owner - run scripts in this order
    1. create tables 
    1. set privileges
    1. load controlled content (recommended)
    1. load sample datasets (optional)
    1. We offer an one-stop-stop script to do the above called "onebigfile.sql". 


## Step-by-step
### Pre-requisites  
This guide assumes you have postgreSQL installed, either on a remote server (e.g., institutional), or locally. You (and your adminstrator) will also need a mechanism to run SQL commands. This could be done from the command line (e.g., psql), or an SQL pane in a GUI. We use either pgAdmin or DBeaver (see [our guide](dbeaver.md) to essential DB admin task in DBeaver).

### Steps
#### 1. Create users and assign privileges
You will need PostgreSQL accounts to fill these roles. On some institutional server setups, only DB administrators can create role; talk to your DB admin if this is the case. 


| Role | Description | Recommendation |  SQL priviledges |
|--|--|--|--|
| db_owner | the owner of this database (not necessarily the admin of the database server). Creates/deletes schemas, tables, views, triggers, etc. Runs backups, grants priviledges.  |  The DB owner should be a person who aready knows posgreSQL, so most likely, an existing account. All scripts transfers ownership to the owner acct.  | ALL (DB-level)  |
| read_write_user | Optional intermediate user. Updates row-level content, typicallly with a script. You may not need this role until you have scripts/forms for adding content. | create a new acct named "read_write_user" | SELECT, UPDATE, INSERT (no DELETE) |
| read_only_user | export, e.g, via script to create EML, or display on a website | create a new acct named "read_only_user" | SELECT  |

#### 2. Customize SQL scripts 
##### 2.1 Edit role names
Installation SQL scripts for LTER-core-metabase already include commands to grant the above tiers of privileges to corresponding tokenized role names. You cannot run these SQL scripts directly; first they must reference existing role names. You will have to set these roles -- definitely for the db_owner account, since it is tokenized as `%db_owner%` in our scripts, but not for the non-tokenized `read_write_user` and `read_only_user` if you follow our recommendations and create accounts with these names. Simply find-and-replace (via script or text editor) with your own role names in all scripts you intend to run. 

Scripts are best for this, since DB extensions that appear in this repository will use the account-tokens, and you'll have to reset those for every new piece of SQL. E.g., in a linux system, you could use sed (with your own directory names instead of my git-clone and local): 

`sed 's/%db_owner%/gastil/g' git-clone/0_create_db.sql > local/create_db.sql`

##### 2.2 Rename the DB (optional)
The `0_create_db.sql` script names the database `lter_core_metabase`. You may prefer a different name.

#### 3. DB Administrator: create the local database
- 0_create_db.sql

#### 4. DB owner: run install scripts

New, from-scratch install:
- onebigfile.sql
- ii_description.sql (where ii is the patch number +1 from the last number in onebigfile's version (major.minor.patch)

Alternatively, you could build metabase by running all sequentially numbered patches. This would be tedious.
    
### 5. Install scenarios. 

1. institutional/central server 
    1. dbadmin acct that is not the db_owner acct (they may/may not be the same person) 
    2. different accts (people) run different scripts
    3. at least some accounts probably already exist (because the db_owner is likely to have access to other databases)
    4. there may be a sandbox db and a production db (eg, sandbox has example content loaded, production does not)

2. desktop install 
    1. dbadmin and owner are probably the the same person  
    2. multiple ways to install
          - use a gui with an sql pane and run scripts as for a central server
          - concat the scripts together and run them as you would a restore (keep in mind that the typical order of a DB dump-restore is not the order of operations in these scripts)
    4. keep in mind that it is almost impossible to share work this way, which might obviate the use of postgres altogether 

3. optional: notes for install on different OS's (probably orthogonal to the above)
             
