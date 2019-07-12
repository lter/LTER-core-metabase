-- UPDATE revision and nickname from pkg_mgmt to lter_metabase

-- Exploratory query before migration:
select rev, nickname 
from pkg_mgmt.pkg_state s
JOIN lter_metabase."DataSet" d
ON s."DataSetID"=d."DataSetID"
ORDER BY s."DataSetID"
;
-- if you want to see what datasets are in pkg_mgmt but not in DataSet, do an outer join.
-- The above is just to see prior to runing UPDATE commands.
-- It is normal to have datasets listed in pkg_mgmt that are not in DataSet.

UPDATE lter_metabase."DataSet"
SET "Revision" = s.rev
FROM pkg_mgmt.pkg_state s
WHERE lter_metabase."DataSet"."DataSetID"=s."DataSetID"
;
UPDATE lter_metabase."DataSet"
SET "ShortName" = s.nickname
FROM pkg_mgmt.pkg_state s
WHERE lter_metabase."DataSet"."DataSetID"=s."DataSetID"
