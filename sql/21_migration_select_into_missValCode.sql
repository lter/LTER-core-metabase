/*   select into statements for migration. 
 * 
 * Tables related to normalizing multiple missing value codes for one attribute.
 *
 * (in postgres, select into is actually insert from select. Same thing.)
 * 
 * Only for migration purposes, the old DataSetAttributes column MissingValueCode and "Explanation" 
 * here are used to populate the new ListMissingCodes parent table and 
 * the cross-ref table DataSetAttributeMissingCodes.
 * 
 * At least initially, an integer ID is generated. 
 * The ID field is actually a varchar(20) to allow meaningful strings for human editors, if you so wish.
 * Just edit them in the parent table and the ID will cascade.
 * This is NOT an "autoinc". This is just for initial population.
 * And there is a unique constraint on the other 2 columns so no risk of duplicate tuples.
 * 
*/

-- special for mini_sbclter: m is lowercase in col name "missingValueCodeExplanation"
-- for mini_sbclter, edit this script accordingly.

-- add a uniq constraint to code and explain columns of parent table.
ALTER TABLE lter_metabase."ListMissingCodes"
  ADD CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" UNIQUE ("MissingValueCode", "MissingValueCodeExplanation");
COMMENT ON CONSTRAINT "UQ_ListMissingCodes_Code_Explanation" ON lter_metabase."ListMissingCodes"
  IS 'Needed because the ID could be as simple as an integer and is not inherently connected to the code and explanation.';


-- populate parent table

create temporary sequence id_mvc increment by 1 minvalue 1 start with 1 ;

INSERT INTO lter_metabase."ListMissingCodes" ("MissingValueCodeID","MissingValueCode", "MissingValueCodeExplanation")
(
SELECT  
 nextval('id_mvc'), -- gets next integer from sequence  
 "MissingValueCode",
 "MissingValueCodeExplanation" 
 FROM lter_metabase."DataSetAttributes" 
 WHERE "MissingValueCode" is not null
 GROUP BY "MissingValueCode", "MissingValueCodeExplanation"
);

INSERT INTO lter_metabase."DataSetAttributeMissingCodes" ("DataSetID", "EntitySortOrder", "ColumnName", "MissingValueCodeID")
(
SELECT  "DataSetID", "EntitySortOrder", "ColumnName", c."MissingValueCodeID"
 from lter_metabase."DataSetAttributes" a
 join lter_metabase."ListMissingCodes" c
 on a."MissingValueCode"=c."MissingValueCode" and a."MissingValueCodeExplanation"=c."MissingValueCodeExplanation"
 where a."MissingValueCode" is not null
 );
 
-- Exploratory queries (only run if you just want to see the process)

/*select "DataSetID", "EntitySortOrder", "ColumnName", c."MissingValueCodeID",
 a."MissingValueCode", a."MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 join lter_metabase."ListMissingCodes" c
 on a."MissingValueCode"=c."MissingValueCode" and a."MissingValueCodeExplanation"=c."MissingValueCodeExplanation"
 where a."MissingValueCode" is not null
 ORDER BY a."MissingValueCode", "DataSetID", "EntitySortOrder", "ColumnPosition"
 ;*/
 
