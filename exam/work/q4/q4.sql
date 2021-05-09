-- COMP3311 20T3 Final Exam
-- Q4: list of long and short songs by each group

-- ... helper views and/or functions (if any) go here ...


create or replace view shortsongs(id, groups)
as
select songs.id, groups.id
from songs
join albums on songs.on_album = albums.id
join groups on albums.made_by = groups.id
where songs.length < 180
order by groups.id;


create or replace view longsongs(id, groups)
as
select songs.id, groups.id
from songs
join albums on songs.on_album = albums.id
join groups on albums.made_by = groups.id
where songs.length > 360
order by groups.id;

drop function if exists q4();
drop type if exists SongCounts;
create type SongCounts as ( "group" text, nshort integer, nlong integer );

create or replace function
	q4() returns setof SongCounts
as $$
declare 
    res SongCounts;
    h groups;
    j shortsongs;
	nShort int;
    k longsongs;
    nLong int;
begin
    for h in
        select * from groups
    loop
        nShort = 0;
        nLong = 0;
        for j in 
            select * from shortsongs where shortsongs.groups = h.id
        loop
            nShort := nShort + 1;
        end loop;
        for k in 
            select * from longsongs where longsongs.groups = h.id
        loop
            nLong := nLong + 1;
        end loop;
        res."group" := h.name;
        res.nshort := nShort;
        res.nlong := nLong;
        return next res;
    end loop;
end;
$$ language plpgsql
;