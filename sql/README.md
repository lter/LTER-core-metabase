# README.md
Dir contains the install script for LTER-core-metabase. See also [Quick Start guide](../docs/quick_start.md). 

- **0_create_db.sql**
  - creates database named lter_core_metabase
  - a DB admin must run this script
    
- **onebigfile.sql**
  - set up three schemas and their tables. 
  - example:   `psql -U joesmith -h dbhostname -d lter_core_metabase < onebigfile.sql`


        
        
