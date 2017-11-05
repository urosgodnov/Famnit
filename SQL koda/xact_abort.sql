create table dbo.demoInsert (something int primary key)

begin tran
insert into dbo.demoInsert (something) values(1)
insert into dbo.demoInsert (something) values(2)
commit tran

select *
from dbo.demoInsert


begin tran
insert into dbo.demoInsert (something) values(2)
insert into dbo.demoInsert (something) values(3)
commit tran

select *
from dbo.demoInsert

set xact_abort on
begin tran
insert into dbo.demoInsert (something) values(3)
insert into dbo.demoInsert (something) values(4)
commit tran
set xact_abort off

select *
from dbo.demoInsert