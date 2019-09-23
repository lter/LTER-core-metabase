# Guide to DBeaver

DBeaver is a database manager.  DBeaver lets you add rows in its GUI without writing any SQL. This guide walks you through a number of basic tasks commonly encountered in managing LTER-core-metabase.

## Installation

1. Install Postgres for Windows using the **EnterpriseDB installer**.
2. Install **DBeaver**. 
3. Run DBeaver and connect to your Postgres instance.

## Backup a database to SQL file

1. In DBeaver, right-click the database and click **Tools > Backup**.
2. Select schemas to include and click **Next**.
3. For Format, choose **Plain**.


**Optional:** You might choose to make the backup **without ownership or privilege statements**. This makes it easier to restore to a different server. However, note that the user restoring the database from SQL backup will become the new owner.

3.5. Place a check next to these boxes:
    1. Do not backup privileges (GRANT/REVOKE)
    2. Discard objects owner

4. Click **Start**.

## Restore a database from a SQL export

Use these steps to restore a database from a database backup saved as a SQL file, i.e., from a SQL export.

1. Make a new database: right-click on an existing one and click **Create New Database**.
2. Right-click the database and click **Tools > Execute script**.
3. Select the SQL file and click **Start**.
4. You may need to restart DBeaver to see the schemas and tables.

## Import data to a table from CSV

1. Navigate to a table, right-click on it, then click **Import Data**.
2. With **CSV** selected, click **Next**.
3. For Input files, in the Source column, click **<none>** to open a file browser.
4. Browse to the CSV file and click **Open**.
5. Click **Next** and preview the data if desired.
6. Click **Next**, **Next**, and **Finish**.
7. Open the table (or refresh the window if the table was already open) to see the data.

