-- COMP3311 20T3 Assignment 2

-- Q1: students who've studied many courses

create view Q1(unswid,name)
as
SELECT people.unswid, people.name
FROM people
INNER JOIN course_enrolments on course_enrolments.student = people.id  
GROUP BY people.unswid, people.name
HAVING COUNT(course_enrolments.student) > 65;



-- Q2: numbers of students, staff and both

create or replace view Q2(nstudents,nstaff,nboth)
as
SELECT
	(SELECT COUNT(*) as nstudents
	FROM students
	LEFT JOIN staff ON staff.id = students.id
	WHERE staff.id IS NULL), -- When someone is only a student

	(SELECT COUNT(*) as nstaff
	FROM staff
	LEFT JOIN students on students.id = staff.id
	WHERE students.id IS NULL),   -- When someone is only a staff member
	
	(SELECT COUNT(*) as nboth
	FROM students  
	INNER JOIN staff ON staff.id = students.id
	WHERE students.id IS NOT NULL AND staff.id IS NOT NULL); -- When someone is both 

-- Q3: q3Helper
create or replace view Q3HELPER
as 
SELECT course_staff.staff, count(course_staff.role) as ncourses
FROM course_staff
INNER JOIN people ON course_staff.staff = people.id
WHERE course_staff.role = 1870
GROUP BY staff
ORDER BY count(course_staff.role);


-- Q3: prolific Course Convenor(s)

create or replace view Q3(name,ncourses)
as
SELECT name, ncourses
FROM people INNER JOIN Q3HELPER on people.id=Q3HELPER.staff
WHERE ncourses IN (SELECT max(ncourses) from Q3HELPER)
ORDER BY name;

create or replace view Q4AHELPER
as
SELECT student
FROM program_enrolments
WHERE program = 554 AND term = 138;
-- Q4: Comp Sci students in 05s2 and 17s1

create or replace view Q4a(id,name)
as
SELECT unswid as id, name 
from people join Q4AHELPER
on people.id = student;


create or replace view Q4BHELPER
as
SELECT student
FROM program_enrolments
WHERE program = 6788 AND term = 214;

create or replace view Q4b(id,name)
as
SELECT unswid as id, name 
FROM people join Q4BHELPER ON people.id = student;


--Query for committees
-- SELECT name, id, facultyof(id), count(facultyof(id))

create or replace view Q5HELPER
as
SELECT name, id, facultyof(id)
FROM orgunits
WHERE utype = 9; 

-- Query for counts of commitees
create or replace view Q5AHELPER
as
SELECT facultyof, count(facultyof) 
FROM Q5HELPER 
GROUP BY facultyof;

-- Q5: most "committee"d faculty

create or replace view Q5(name)
as
SELECT name
FROM orgunits
INNER JOIN Q5AHELPER on orgunits.id = Q5AHELPER.facultyof
WHERE count IN (SELECT max(count) FROM Q5AHELPER);

-- Q6: nameOf function

create or replace function
   Q6(id integer) returns text
as $$
SELECT people.name as q6
FROM people 
WHERE people.id = $1 OR people.unswid = $1
$$ language sql;

-- Q7: offerings of a subject

create or replace function
   	Q7(subject text)
    returns table (subject text, term text, convenor text)
as $$	
SELECT cast(subjects.code as text), cast(terms.name as text), cast(people.name as text)
FROM courses
INNER JOIN course_staff on courses.id = course_staff.course
INNER JOIN people on people.id = course_staff.staff
INNER JOIN subjects on courses.subject = subjects.id
INNER JOIN terms on courses.term = terms.id

WHERE courses.subject in
    (SELECT subjects.id
     FROM subjects
     WHERE subjects.code = $1)
  	AND course_staff.role = 1870 

$$ language sql;

-- -- Q8: transcript

-- create or replace function
--    Q8(zid integer) returns setof TranscriptRecord
-- as $$
-- ...
-- $$ language plpgsql;

-- -- Q9: members of academic object group

-- create or replace function
--    Q9(gid integer) returns setof AcObjRecord
-- as $$
-- ...
-- $$ language plpgsql;

-- -- Q10: follow-on courses

-- create or replace function
--    Q10(code text) returns setof text
-- as $$
-- ...
-- $$ language plpgsql;
