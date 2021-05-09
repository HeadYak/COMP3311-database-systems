-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by Frank Su z5264786

-- Types

create type AccessibilityType as enum ('read-write','read-only','none');
create type InviteStatus as enum ('invited','accepted','declined');
create type EventVisibility as enum ('public','private');
create type ColourType as enum ('red','orange','yellow','green','blue','violet');
create type Days as enum ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
-- add more types/domains if you want

-- Tables

create table Users (
	id     			serial unique,
	email       	text		not null unique,
	name 			text 		not null,
	password 		text 		not null,
	is_admin		boolean not null, --either user is admin or isnt admin no ambiguity
	primary key (id)
);

create table Groups (
	id    			serial unique,
	name        	text not null,
	owner 			integer not null, -- total participation
	foreign key (owner) references Users (id),
	primary key (id)
);

create table Members (
	user_id 		serial references Users(id),	
	group_id 		serial references Groups(id),
	primary key (user_id, group_id)
);


create table Calendars (
	name 			text not null,
	id 				serial unique,
	-- colour		ColourType not null, --Store a set of colours in a enumerated data type
	colour 			text not null, 
	default_access	AccessibilityType not null,
	owner			integer not null, -- total participation
	foreign key (owner) references Users (id),
	primary key (id)

);


create table Accessibility (
	access 			AccessibilityType not null,
	user_id			serial references Users(id),
	calendar_id		serial references Calendars(id),
	primary key (user_id , calendar_id)
);

create table Subscribed (
	-- colour		ColourType not null,
	colour			text ,
	user_id			serial references Users(id),
	calendar_id		serial references Calendars(id),
	primary key (user_id , calendar_id)
);

create table Events (
	id					serial unique,
	title				text not null,
	visibility			EventVisibility not null,
	location			text, 
	start_time			time,
	end_time			time,
	created_by 			integer not null,
	part_of				integer not null,
	foreign key (created_by) references Users(id),
	foreign key (part_of) references Calendars(id),
	primary key (id)
);

create table Alarm (
	event_id			integer references Events(id),
	time				integer check (time >= 0), --integer to represent amount of minutes before the event that the alarm is set to trigger
	primary key	(event_id, time)
);

create table One_day_events (
	event_id			integer primary key,
	date				date not null,
	foreign key (event_id) references Events(id)

);

create table Spanning_events (
	event_id			integer primary key,
	start_date			date not null,
	end_date			date not null,
	foreign key (event_id) references Events(id)

);

create table Recurring_events (
	event_id			integer primary key,
	start_date			date not null,
	end_date			date,
	ntimes				integer check (ntimes > 0),
	foreign key (event_id) references Events(id)

);

create table Weekly_events(
	recurring_event_id 		integer primary key,
	day_Of_Week			Days not null, --Store days of the week in an enumerated data type
	-- day_Of_Week			text not null, --Store days of the week in an enumerated data type
	frequency			integer not null check (frequency > 0),	
	foreign key (recurring_event_id ) references Events(id)
);

create table Monthly_by_day_events(
	recurring_event_id 	integer primary key,
	day_of_Week			Days not null , --Store days of the week in an enumerated data type
	-- day_of_Week			text not null , 
	week_in_Month		integer not null check (week_in_Month > 0 and week_in_Month < 6), --use 1-5 to represent weeks of a month	
	foreign key (recurring_event_id ) references Events(id)
);

create table Monthly_by_date_events(
	recurring_event_id 	integer primary key,
	date_in_Month		integer not null check (date_in_month > 0 and date_in_month < 32), --use 1-31 to represent days of a month
	foreign key (recurring_event_id ) references Events(id)
);


create table Annual_events(
	recurring_event_id 	integer primary key,
	date				date not null,
	foreign key (recurring_event_id ) references Events(id)
);

create table Invited(
	event_id			integer references Events(id),
	user_id				integer references Users(id),
	status				InviteStatus not null,
	primary key (event_id,user_id)
)


-- etc. etc. etc.
