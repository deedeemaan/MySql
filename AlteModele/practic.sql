create database Competitie
go
use Competitie
go

create table ingrediente
(
	id int identity(1,1) primary key,
	nume varchar(50),
	descriere varchar(50),
	mentiune varchar(30),
)
insert into ingrediente(nume,descriere,mentiune)values
('ciocolata','neagra','nu e alergen'),
('mousse de vanilie','dulce','alergen'),
('mousse de fructe','acrisor','nu e alergen'),
('caramel','sarat','alergen')
select* from ingrediente

create table tipuri
(	
	id int identity(1,1) primary key,
	denumire varchar(100)
)
insert into tipuri(denumire) values
('prajitura cu ciocolata'),
('prajitura cu vanilie'),
('prajitura cu mousse'),
('prajitura cu nuca'),
('prajitura cu caramel')
select* from tipuri
update tipuri set denumire='prajitura cu mousse de fructe' where id=3

create table prajituri
(
	id int identity(1,1) primary key,
	nume varchar(50),
	descriere varchar(100),
	nr_cal int,
	gramaj int,
	mentiune varchar(50),
	id_tip int,
	id_ingredient int,
	constraint fk_tip foreign key(id_tip) references tipuri(id),
	constraint fk_ingredient foreign key(id_ingredient) references ingrediente(id)
)
insert into prajituri(nume,descriere,nr_cal,gramaj,mentiune,id_tip,id_ingredient) values
('Lava cake','are si inghetata',300,100,'nu e vegana',1,1),
('Vanilicios','buna de tot',250,200,'vegana',2,2),
('Fructoasa','dulce acrisoara',150,250,'nu e vegana',3,3),
('Caramelizata','caramelul e sarat',300,400,'vegana',5,4)
select* from prajituri

create table concurenti
(
	id int identity(1,1) primary key,
	nume varchar(50),
	email varchar(50),
	tara varchar(20),
	data_nasterii date not null, 
)
insert into concurenti(nume,email,tara,data_nasterii) values
('John','johhnynebunu@yahoo.com','America','2000-11-14'),
('Marie','mariemarie@gamil.com','Franta','2002-04-01'),
('Vivi','kulikvivi08@gamil.com','Romania','2003-08-14')
select* from concurenti

create table concurenti_prajituri
(
	id_concurenti int,
	id_prajituri int,
	constraint pk_concurenti_prajituri primary key(id_concurenti,id_prajituri),
	constraint fk_concurenti foreign key(id_concurenti) references concurenti(id),
	constraint fk_prajituri foreign key(id_prajituri) references prajituri(id)
)
go

insert into concurenti_prajituri(id_concurenti,id_prajituri,cantitate) values
(1,2,2),
(1,3,1),
(2,1,2),
(2,4,2),
(2,2,1),
(3,1,4),
(3,2,2),
(4,2,1),
(4,3,2)
select* from concurenti_prajituri
go

alter table concurenti_prajituri
add cantitate int
go

create or alter procedure adauga_prajitura_concurent
	@id_concurent int,
	@id_prajitura int,
	@cantitate int
as
begin
	if exists(select id_concurenti,id_prajituri from concurenti_prajituri where id_concurenti=@id_concurent and id_prajituri=@id_prajitura)
	begin
	update concurenti_prajituri set cantitate=@cantitate where id_concurenti=@id_concurent and id_prajituri=@id_prajitura;
	end;
	else
	begin
	insert into concurenti_prajituri(id_concurenti,id_prajituri,cantitate) values(@id_concurent,@id_prajitura,@cantitate)
	end;
end;
go

exec adauga_prajitura_concurent 1,4,2
select* from concurenti_prajituri
go

create or alter view view1 as
select distinct c.nume as nume_concurent, c.email from concurenti c
inner join concurenti_prajituri cp on
cp.id_concurenti=c.id
inner join prajituri p on
p.id=cp.id_prajituri
inner join ingrediente i on
i.id=p.id_ingredient
where i.id=3 and i.id<>2

select* from view1