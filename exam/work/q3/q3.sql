-- COMP3311 20T3 Final Exam
-- Q3:  performer(s) who play many instruments

-- ... helper views (if any) go here ...

create or replace view q3b(performer, instrument)
as 
select distinct performers.id, PlaysOn.instrument
from PlaysOn
join performers on performers.id = PlaysOn.performer
group by performers.id, PlaysOn.instrument
order by performers.id;

create or replace view q3c(performer, instrument)
as 
select performer, instrument,
case 
	when instrument like '%guitar%' then 'guitars'
	else instrument
end as instrument1
from q3b;

create or replace view performInstruments(performer, instrument)
as 
select performer, instrument1 from q3c
where instrument1 != 'vocals'
group by performer, instrument1
order by performer;

create or replace view q3d(performer, ninstruments)
as 
select performInstruments.performer, count(performInstruments.performer) from performInstruments
group by performInstruments.performer
having count(performer) > 6
;

create or replace view q3(performer,ninstruments)
as
select performers.name, q3d.ninstruments
from q3d 
join performers on performers.id = q3d.performer
order by ninstruments
;