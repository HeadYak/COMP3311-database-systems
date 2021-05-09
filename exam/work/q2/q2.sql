-- COMP3311 20T3 Final Exam
-- Q2: group(s) with no albums

-- ... helper views (if any) go here ...

create or replace view q2("group")
as
select groups.name as group
from groups LEFT JOIN albums on groups.id = albums.made_by
WHERE albums.made_by is null
;

