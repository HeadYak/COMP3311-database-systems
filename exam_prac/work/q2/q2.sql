-- COMP3311 20T3 Final Exam
-- Q2: view of amazing goal scorers

-- ... helpers go here ...

create or replace view Q2(player,ngoals)
as
-- ...put your SQL here...
select players.name as player, count(*) as ngoals
from players join goals on goals.scoredby = players.id
where goals.rating = 'amazing'
group by players.name
having count(*) > 1
order by count(*) desc, players.name asc
;

