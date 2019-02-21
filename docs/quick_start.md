# LTER Core Metabase quick start guide

## Outline
1. install pg (if needed)
2. set up roles (your DB admin)
3. run scripts in this order 
    1. create db 
    1. create tables 
    1. set perms 
    1. load controlled content 
    1. load sample data (optional)


## Preconditions
This guide assumes you have postgreSQL installed, either on a remote server (e.g., institutional), or locally.

1. Talk to your DB administrator; set up these roles
  - db_owner: CREATE schemas, tables, views, triggers, etc. runs backups, grants priveledges, INSERT, UPDATE, DELETE content
  - read_write_user: (optional) Intermediate priveledges, UPDATE, INSERT content, typicallly with a script (no DELETE)
  - read_only_user: SELECT only, for export 
  
