/*   select into statements for migration. 
 * 
 * Tables related to normalizing multiple missing value codes for one attribute.
 *
 * (in postgres, select into is actually insert from select. Same thing.)
 * 
 * Only for migration purposes, the old DataSetAttributes column MissingValueCode and "Explanation 
 * were left behind in their 1-to-1 way. 
 * The metabase user should opt either all one or all the other way, not mix 1-1 and n-n.
 * Either use the normalized tables and not populate the deprecated columns,
 * or use only the deprecated columns.
 * 
*/

-- Exploratory queries

select "DataSetID", "EntitySortOrder", "ColumnPosition", 
 "MissingValueCode", "MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 ORDER BY "MissingValueCode", "DataSetID", "EntitySortOrder", "ColumnPosition"
 ;
 
 select "DataSetID", "EntitySortOrder", "ColumnName", 
 "MissingValueCode", "MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 ORDER BY "MissingValueCode", "DataSetID", "EntitySortOrder", "ColumnPosition"
 ;
 
 -- summarize re-use of mv codes
 
 select count(*) as times_used, 
	count(distinct "DataSetID") as ds_using, -- "EntitySortOrder", "ColumnPosition", 
 "MissingValueCode", "MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 GROUP BY "MissingValueCode", "MissingValueCodeExplanation"
 ORDER BY "MissingValueCode", "MissingValueCodeExplanation"
 ;
 
 select "MissingValueCode" as "MissingValueCodeID", 
 "MissingValueCode", "MissingValueCodeExplanation"
 from lter_metabase."DataSetAttributes" a
 ORDER BY "MissingValueCode"
 ;
 -- mini_sbclter has explainations of length up to 59 char. Need to expand varchar 
 -- if using code||explaination as the ID. Otherwise, how to give ID?
 -- Same code is often used with several explainations.
 select count(*), 
 "MissingValueCode", "missingValueCodeExplanation", LENGTH("missingValueCodeExplanation")
 from lter_metabase."DataSetAttributes" a
 GROUP BY "MissingValueCode", "missingValueCodeExplanation"
 ORDER BY "MissingValueCode", "missingValueCodeExplanation"
 ;
 select count(*), 
 "MissingValueCode", "missingValueCodeExplanation", LENGTH("missingValueCodeExplanation")
 from lter_metabase."DataSetAttributes" a
 GROUP BY "MissingValueCode", "missingValueCodeExplanation"
 ORDER BY LENGTH("missingValueCodeExplanation"), "MissingValueCode", "missingValueCodeExplanation"
 ;
 select count(*), 
 "MissingValueCode", "missingValueCodeExplanation", LENGTH("missingValueCodeExplanation")
 from lter_metabase."DataSetAttributes" a
 GROUP BY "MissingValueCode", "missingValueCodeExplanation"
 ORDER BY "missingValueCodeExplanation", "MissingValueCode"
 ;
 