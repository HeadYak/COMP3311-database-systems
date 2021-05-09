-- COMP3311 20T3 Final Exam
-- Q1: longest album(s)

-- ... helper views (if any) go here ...



create or replace view q1("group",album,year)
as
select groups.name, albums.title, albums.year
from  albums join songs on albums.id = songs.on_album
join groups on groups.id = albums.made_by
group by albums.id, groups.name
order by sum(songs.length) desc
limit 1;


