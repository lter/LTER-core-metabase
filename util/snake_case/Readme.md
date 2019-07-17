# snake case

A ruby script to convert the tables in the `lter_metabase` schema from CamelCase
to glorious, easy on the fingers snake_case.

## Usage

Install required gems

```
$ bundle
```

to run as a test in a transaction (nothing actually is changed in the db)
```
$ ruby to_snake_case lter_metabase
```

to apply the  changes
```
$ ruby to_snake_case lter_metabase --production
````
