# Set up automated backup on Windows

At BLE-LTER, we have set up a simple Windows batch script to take automated backups of our metabase. Note that we use a locally installed and hosted PostgreSQL instance to implement LTER-core-metabase. If your server is remote, this process might not apply (whoever admins the database cluster might take care of backup and you should go talk to them). In theory however, you should be able to do the same as long as you have access to the database from a client PC.

## Step by step

1. Create folder structure


2. Create two batch files in the same folder

A caller

```batch
:: this calls daily_pg_backup.bat 
:: and outputs the log to a file
@echo off

:: %date% is an environment variable
:: for /f loops through the %date% string
:: and get date components
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
set dow=%%i
set month=%%j
set day=%%k
set year=%%l
)
for /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (
set time=%%a%%b
)
set timestamp=%month%_%day%_%year%_%time%
echo date is %date%
echo time is %TIME%

:: set log file directory and name
set LOG_DIRECTORY= :: set log directory here!!
set LOG_FILE=backup_log_%timestamp%.txt

:: call file. redirect stderr to same file as stdout
call ./backup.bat 1> %LOG_DIRECTORY%\%LOG_FILE% 2>&1
```

A file called backup.bat to actually do the backup

```batch
:: this script uses PostgreSQL's pg_dump command to back up BLE metabase in specified folder

:: turn printing commands off for all commands
@echo off

:: %date% is an environment variable
:: for /f loops through the %date% and %TIME% strings. Time is local time, 24hour format.
:: and get date time components
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
set dow=%%i
set month=%%j
set day=%%k
set year=%%l
)
for /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (
set time=%%a%%b
)
set timestamp=%month%_%day%_%year%_%time%

echo timestamp is %timestamp%

:: set .backup file directories (in this case, both the server and the Box folder) and name
set BACKUP_DIRECTORY_1=\\austin.utexas.edu\disk\engr\research\crwr\Projects\BLE-LTER\Metabase\daily_backups
set BACKUP_DIRECTORY_2=C:\Users\atn893\Documents\Box Sync\BLE_metabase_backups
set BACKUP_FILE=BLE_metabase_%timestamp%.sql

echo backup file name is %BACKUP_FILE%

:: set password for the read-only backup_user. consider making an encrypted password file
SET PGPASSWORD= :: set password here!!!!

echo on
:: execute pg_dump from the Postgres installation bin folder
:: -F p specifies plain-text format
:: -b includes large objects in the dump
:: -v verbose messages
:: -f specifies the backup file name
:: -d specifies the database to backup
:: -U specifies the user to use
"C:\Program Files\PostgreSQL\11\bin\pg_dump" -h localhost -p 5432 -U backup_user -d ble_metabase -F p -b -v -f "%BACKUP_DIRECTORY_1%\%BACKUP_FILE%" 

:: copy over to Box folder
echo f | xcopy /s /f "%BACKUP_DIRECTORY_1%\%BACKUP_FILE%" "%BACKUP_DIRECTORY_2%\%BACKUP_FILE%" 

echo done
```
# Non-automated backup option

Two less technical options: 
 1. use DBeaver or pgAdmin to interactively make a backup. Follow menu options. In pgAdmin this is on the Tools-> Backup menu.
 2. from a bash shell, run the pg_dump command, using the same parameters as described above.
 :: pg_dump" -h localhost -p 5432 -U backup_user -d lter_core_metabase > output_filename
 You may have named lter_core_metabase something like my_special_metabase. Use your database name.
