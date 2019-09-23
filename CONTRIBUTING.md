
## Contributing guide to LTER-core-metabase

### Repo organization

A collaborative database design project poses challenges when it comes to version-control and collaborative development. Developers must take care to make sure their development databases are up to date, for example. 

This repository has two concurrent branches to avoid confusion for new users. `master` is meant for new users looking for a complete new installation. `master/sql` contains only two files, one to make a new DB and one to make a complete installation (we call this "onebigfile.sql"). Onebigfiles are dumps of the database

`migration` contains incremental changes to existing installations. 

### Step-by-step guide

You might want to git CHECK OUT the two branches `master` and `migration` in different directories.

ALWAYS follow these steps at the beginning of a coding session.

1. Make sure the `master` branch is checked out.
1. Obtain the patch number incorporated into the current onebigfile. This might be recorded in the latest commit message to `onebigfile.sql`. For example, onebigfile 24 would contain all patches from 1-24. 
1. Edit the GRANT statements in `onebigfile.sql`. For development purposes, we recommend making two users named `read_write_user` and `read_only_user` in your Postgres installation. Then find-and-replace all occurrences of `%db_owner%` with the role you are using. DO NOT COMMIT this edited file. `Save as` a local copy. For example,
```
cat onebigfile.sql | sed 's/%db_owner%/your_username/g' > local_temporary_onebigfile.sql
```
4. Make a new empty database. Name it whatever you want. Set the owner to the role you are using. 
5. Execute your local edited copy of onebigfile on this database. It should execute with no errors (or only one about the owner of the language plpsql). At this point you should have a working live database with the latest version of LTER-core-metabase. How to do this using psql: (If postgres is running on your local desktop, your_db_host is localhost.)
```
psql -U your_username -h your_db_host name_of_db < local_temporary_onebigfile.sql
```
6. Make your changes to the database live. You can do this in a GUI like DBeaver and IMPORTANTLY cache the SQL executed in a separate text, or write your SQL in a text editor and execute it on the development DB.
1. Once testing is done, add a row by executing an INSERT statement to the version tracker table following this template. Substitute appropriate version numbers, your patch number, and comment. Include the INSERT statement at the bottom of the .sql text file.
```
INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(0, 9, 22, now(), 'applied 22_version_tracker');
```
8. Once testing is done, make a new file and put in the exact SQL needed to make the changes you want. Name this file in this pattern: (the next integer up from the onebigfile patch number)-(underscore)-(brief description of what this patch does). For example, if you installed OBF 24 and created a new table to model the quality control EML tree, name your patch "25_create_quality_control_tables.sql". 
1. Commit this patch to the `sql` folder in the `migration` branch. 
1. Make a dump of your test DB, complete with changes and new row in version tracker. An example `pg_dump` command would be: 
```
pg_dump -d <DB name> -F p -b -h your_db_host -p 5432 -U your_username -f <file path to dump to>
```
11. Reverse find-and-replace in GRANT statements. Replace your role with `%db_owner%`. For example, 
```
cat pg_dump_output.sql | sed 's/your_username/%db_owner%/g' > onebigfile.sql
```
12. If you created any new tables or views, make sure `read_write_user` is granted SELECT, UPDATE, INSERT to all tables, `read_only_user` only SELECT.
Rename the dump to `onebigfile.sql` and commit it to the master branch in the `sql` folder. Make sure to include your patch number in the commit message.

1. If you have doubt you have captured the end state of the db, the most safe process is to install the previous onebigfile again, apply the patch file, dump, and diff the two dumps. That is not usually necessary. 
1. Note the onebigfile.sql must be made using pg_dump from the same version of postgres to be comparable to past and future onebigfile commits. As of July 2019 we are using postgres 11 for this. 

## Revisions

Congrats, you have contributed to the LTER-core-metabase project! What if you find a mistake? What if you change your mind on what a column should be called? It happens to us all the time. So what do you do?

- Immediately after committing: never edit the OBF or patch by hand and just commit it. Always execute the change in a live database to validate the SQL. 
- If some time has elapsed: do not go back and edit the patch. Make a new patch for your changes. 