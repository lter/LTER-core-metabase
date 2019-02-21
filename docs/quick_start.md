# LTER Core Metabase quick start guide

## Outline
1. install pg (if needed)
2.  your DB admin's tasks
    1. set up roles/accts
    1. create db (make you the owner)
3. your tasks, as the DB owner - run scripts in this order
    1. create tables 
    1. set perms 
    1. load controlled content 
    1. load sample data (optional)


## Details
### Preconditions:  
This guide assumes you have postgreSQL installed, either on a remote server (e.g., institutional), or locally. There are no instructions on installing postgreSQL here.

### Talk to your DB administrator
you will need users with these roles set up

  - db_owner (the owner of this database, not necessarily the owner of the database server) ALL privileldges: e.g., CREATE schemas, tables, views, triggers, etc. Runs backups, grants priviledges. INSERT, UPDATE, DELETE content
  - read_write_user: (optional) Intermediate priviledges, UPDATE, INSERT content, typicallly with a script (no DELETE)
  - read_only_user: SELECT only, for export 


customize the psql scripts  - edit tokens to user names

- create_db
- create_tables
- set_perms
