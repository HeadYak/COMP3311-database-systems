-- COMP3311 20T3 Final Exam
-- Q5: find genres that groups worked in

-- ... helper views and/or functions go here ...

create or replace view genres(genre, groups)
as
select albums.genre, groups.id
from albums
join groups on groups.id = albums.made_by 
group by groups.id, albums.genre
order by groups.id, albums.genre;

drop function if exists q5();
drop type if exists GroupGenres;

create type GroupGenres as ("group" text, genres text);

create or replace function
    q5() returns setof GroupGenres
as $$
declare 
    result GroupGenres;
    num int;
    counter int;
    genres_list text;
    h groups;
    j genres;
begin
    for h in
        select * from groups
    loop
        genres_list := '';
        counter := 0;



        num := count(*) from genres where genres.groups = h.id;
        for j in 
            select * from genres where genres.groups = h.id
        loop
        
            counter := counter + 1;
            genres_list := genres_list || j.genre;
            if (counter < num) then

                genres_list := genres_list || ',';
            end if;
        end loop;


        result."group" := h.name;
        result.genres := genres_list;
        return next result;



    end loop;
end;
$$ language plpgsql
;
