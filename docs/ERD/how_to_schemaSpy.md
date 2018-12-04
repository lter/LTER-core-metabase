# how to schemaSpy

## Background
SchemaSpy is a tool for creating documentation for relational databases. 
It is a Java-based tool (requires Java 8 or higher) that analyzes the metadata of a schema in 
a database and generates a visual representation in a browser-displayable format. 
It lets you click through the hierarchy of database tables via child and parent table 
relationships as represented by both HTML links and entity-relationship diagrams.

The original project was hosted by 
sourceforge ([http://schemaspy.sourceforge.net](http://schemaspy.sourceforge.net)), and is at 
version 5. These notes apply to version 5. 

As of summer 2018, the most recent verision is V6, ([http://schemaspy.org/](http://schemaspy.org/). 
I have not tried it yet, but I'm sure it's better; let me know. Also see 

- https://github.com/schemaspy/schemaspy
- https://schemaspy.readthedocs.io/en/latest/
- Item


## Mac instructions 
V 5:
### Set up

1. Make sure you have homebrew:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
2. install graphviz (needed for the diagrams, which are dot and png)
``` 
brew install graphviz
```

3. Get schemaSpy (v 5 from sourceforge)
    1. schemaSpy_5.0.0.jar

4. Get Java connectors for databases. I have these
    1. postgresql-9.3-1103.jdbc3.jar
    1. mysql-connector-java-5.1.45-bin.jar

### Run
Example. I admit to throwing it all into the working dir, then moving output around later.
```
java -jar schemaSpy_5.0.0.jar -t pgsql -db bon_data_pkgs -host rdb2 -u read_only_user -p password -o ./bon_data_pkgs/mb2eml_r/ -dp postgresql-9.3-1103.jdbc3.jar -s mb2eml_r -noads -renderer :quartz
```

Options:

|  |  |  | note|
|--|--|--|--|
| -t | type  |  |
| -db | db name | bon_data_pkgs |  
| -host | hostname | rdb2  |  
| -u | username |  |  
| -p | pw | |  
| -o | output directory|  |  
| -dp | path to driver | ./driver.jar |
\ -s | schema | mb2eml_r |
| -noads |  | | maybe no adverts? 
| -renderer | | :quartz |  needed to create dot files with graphviz. not sure why.
