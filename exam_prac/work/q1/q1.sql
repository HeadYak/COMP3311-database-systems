-- COMP3311 20T3 Final Exam
-- Q1: view of teams and #matches

-- ... helper views (if any) go here ...

create or replace view Q1(team,nmatches)
as
-- ... put your SQL here...
select teams.country, count(*)
from teams JOIN involves on involves.team = teams.id
group by teams.country
;

