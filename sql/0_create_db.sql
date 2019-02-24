-- Database: lter_core_metabase

-- DROP DATABASE lter_core_metabase;

CREATE DATABASE lter_core_metabase
    WITH 
    OWNER = %db_owner%
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;