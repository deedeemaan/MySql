create table versiuni(
	cod_v int primary key identity,
	versiunea_curenta int
	);
insert into versiuni (versiunea_curenta) values(0)
select * from versiuni