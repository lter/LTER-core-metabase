
## Contributing guide to LTER-core-metabase

### Repo organization

A collaborative database design project poses challenges when it comes to version-control and collaborative development. Developers must take care to make sure their development databases are up to date, for example. 

This repository has two concurrent branches to avoid confusion for new users. `master` is meant for new users looking for a complete new installation. `master/sql` contains only two files, one to make a new DB and one to make a complete installation (we call this "onebigfile.sql"). Onebigfiles are dumps of the database

`migration` contains incremental changes to existing installations. 

### Step-by-step guide

You might want to git CHECK OUT the two branches `master` and `migration` in different directories.

ALWAYS follow these steps at the beginning of a coding session.

1. Make sure the `master` branch is checked out.
2. Obtain the patch number incorporated into the current onebigfile. This might be recorded in the latest commit message to `onebigfile.sql`. For example, onebigfile 24 would contain all patches from 1-24. 
3. Edit the GRANT statements in `onebigfile.sql`. For development purposes, we recommend making two users named `read_write_user` and `read_only_user` in your Postgres installation. Then find-and-replace all occurrences of `%db_owner` with the role you are using. DO NOT SAVE this edited file. `Save as` a local copy.
3. Make a new empty database. Name it whatever you want. Set the owner to the role you are using. 
4. Execute your local edited copy of onebigfile on this database. It should execute with no errors (or only one about the owner of the language plpsql). At this point you should have a working live database with the latest version of LTER-core-metabase. 
5. Make your changes to the database live. You can do this in a GUI like DBeaver and IMPORTANTLY cache the SQL executed in a separate text, or write your SQL in a text editor and execute it on the development DB.
6. Once testing is done, add a row or execute an INSERT statement to the version tracker following this template. Substitute appropriate version numbers, your patch number, and comment.
```
INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(0, 9, 22, now(), 'apply 22_version_tracker');
```
6. Once testing is done, make a new file and put in the exact SQL needed to make the changes you want. Name this file in this pattern: (the next integer up from the onebigfile patch number)-(underscore)-(brief description of what this patch does). For example, if you installed OBF 24 and created a new table to model the quality control EML tree, name your patch "25_create_quality_control_tables.sql". 
7. Commit this patch to the `sql` folder in the `migration` branch. 
8. Make a dump of your test DB, complete with changes and new row in version tracker. An example `pg_dump` command would be: 
```
-d <DB name> -F p -b -h localhost -p 5432 -U an -f <file path to dump to>
```
Reverse find-and-replace in GRANT statements. Replace your role with `%db_owner`. Make sure `read_write_user` is granted SELECT, UPDATE, INSERT to all tables, `read_only_user` SELECT.
Rename the dump to `onebigfile.sql` and commit it to the master branch in the `sql` folder. Make sure to include your patch number in the commit message.