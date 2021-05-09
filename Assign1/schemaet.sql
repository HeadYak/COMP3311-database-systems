-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by INSERT YOUR NAME HERE

-- Types

create type AccessibilityType as enum ('read-write','read-only','none');
create type InviteStatus as enum ('invited','accepted','declined');
create type Visibility as enum ('public','private');
create type Status as enum ('invited','accepted','declined');
create type Days as enum ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
-- add more types/domains if you want

-- Tables

create table Users (
	id          serial,
	email       text not null unique,
	name       text not null,
	is_admin    boolean not null,       
	passwd      text not null,
	primary key (id)

);

create table Groups (
	id          serial,
	name        text not null,
    owner       serial not null,
	primary key (id),
    foreign key (owner) references Users(id)
);

create table Members (
    user_id     serial references Users(id),
    groups_id   serial references Groups(id),
    primary key(user_id, groups_id)
);

create table Calendars (
	id          serial not null,
	name        text not null,
    colour      text not null,
    owner       serial not null,
    default_access AccessibilityType not null,
	primary key (id),
    foreign key (owner) references Users(id)
);

create table Accessibility (
    user_id     serial references Users(id),
    calendar_id serial references Calendars(id),
    access      AccessibilityType not null,
    primary key(user_id, calendar_id)
);

create table Subscribed (
    user_id     serial references Users(id),
    calendar_id serial references Calendars(id),
    colour      text,
    primary key(user_id, calendar_id)
);

create table Events (
	id          serial not null,
	title       text not null,
    visibility  Visibility not null,
    location    text,
    start_time  time,
    end_time    time,
    part_of     serial not null,
    created_by  serial not null,
	primary key (id),
    foreign key(part_of) references calendars(id),
    foreign key(created_by) references calendars(id)
);

create table invited (
    user_id     serial references Users(id),
    events_id   serial references Events(id),
    status      Status not null,
    primary key(user_id, events_id)
);

create table Alarms (
    events_id   serial,
    alarm_time  integer not null,
    foreign key (events_id) references Events(id)
);

create table one_day_event (
    events_id      serial not null,
    date    date not null,
    primary key (events_id),
    foreign key (events_id) references Events(id)
);

create table spanning_event (
    events_id     serial not null,
    start_date  date not null,
    end_date    date not null,
    primary key (events_id),
    foreign key (events_id) references Events(id)
);

create table recurring_event (
    events_id    serial not null,
    start_date  date not null,
    end_date    date,
    ntimes      integer check (ntimes > 1),
    primary key (events_id),
    foreign key (events_id) references Events(id)
);

create table weekly_event (
    recurring_event_id serial not null,
    day_of_week Days not null,
    frequency   integer not null check (frequency >= 1),
    primary key (recurring_event_id),
    foreign key (recurring_event_id) references recurring_event(events_id)
);

create table monthly_by_day_event (
    recurring_event_id serial not null,
    day_of_week Days not null,
    week_in_month integer not null check (1 <= week_in_month AND week_in_month <= 5),
    primary key (recurring_event_id),
    foreign key (recurring_event_id) references recurring_event(events_id)
);

create table monthly_by_date_event (
    recurring_event_id serial not null,
    date_in_month integer not null check (1 <= date_in_month AND date_in_month <= 31),
    primary key (recurring_event_id),
    foreign key (recurring_event_id) references recurring_event(events_id)
);

create table annual_event (
    recurring_event_id serial not null,
    date        date not null,
    primary key (recurring_event_id),
    foreign key (recurring_event_id) references recurring_event(events_id)
)