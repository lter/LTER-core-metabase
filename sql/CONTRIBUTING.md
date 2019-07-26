
## Contributing guide to LTER-core-metabase

### Repo organization

This repository has two concurrent branches to avoid confusion for new users. `master` is meant for new users looking for a complete new installation. `master/sql` contains only two files, one to make a new DB and one to make a complete installation (we call this "onebigfile.sql"). `migration` contains incremental changes to existing installations. 

### Step-by-step guide

ALWAYS follow these steps at the beginning of a coding session.

1. Make sure the `master` branch is checked out.
2. Make a new empty DB, install the newest 