create database Friends;

use  Friends;

create table Friends(
id integer primary key auto_increment,
name text,
birthday date);

insert into Friends(id, name, birthday)
values
(1, 'Rohan', '2002-10-10'),
(2, 'suhas', '1999-04-02'),
(3, 'shobhan', '1997-06-08');

select * from Friends;


-- add a record name john doe whose birthday 1996-08-30.

insert into Friends(id, name, birthday)
values
(4, 'john doe', '1996-08-30');

-- view the table using select.

select * from Friends;

-- Now add two of your friends you like.

insert into Friends(id, name, birthday)
values
(5, 'Bhart', '1995-10-10'),
(6, 'Prem kumar', '1996-05-03');

-- change the name of the first friend called 'john doe' to 'Luis Johnson'

update  Friends
set name = 'Luis Johnson'
where id = 4;

-- add a new column called email

alter table Friends
add column email varchar(50) not null;

-- Update the email address for everyone in your table. Luis email is luis@gmail.com

update Friends
set email = 'Rohan@gmail.com'
where id = 1;

update Friends
set email = 'Suhas@gmail.com'
where id = 2;

update Friends
set email = 'Shobhan@gmail.com'
where id = 3;

update Friends
set email = 'luis@gmail.com'
where id = 4;

update Friends
set email = 'Bharath@gmail.com'
where id = 5;

update Friends
set email = 'prem@gmail.com'
where id = 6;

select * from friends;

-- remove Luis from friends

delete from Friends
where id = 4;

-- view complete table using select

select * from Friends;








