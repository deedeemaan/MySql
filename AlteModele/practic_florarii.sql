create database Florarii
use Florarii
go

create table florarii
(
	id int identity(1,1) primary key,
	nume varchar(50),
	tel varchar(15),
	adresa varchar(100)
)

create table categorii
(
	id int identity(1,1) primary key,
	nume varchar(50)
)

create table aranjamente
(
	id int identity(1,1) primary key,
	nume varchar(50),
	pret int,
	descriere varchar(50),
	inaltime int,
	id_flo int,
	id_cat int,
	constraint fk_florarii foreign key(id_flo) references florarii(id),
	constraint fk_categorii foreign key(id_cat) references categorii(id),
)

create table plante
(
	id int identity(1,1) primary key,
	nume varchar(50),
	descriere varchar(50)
)

create table aranj_plante
(
	id_aranj int,
	id_planta int,
	constraint pk_aranj_plante primary key(id_aranj,id_planta),
	constraint fk_aranj foreign key(id_aranj) references aranjamente(id),
	constraint fk_planta foreign key(id_planta) references plante(id)
)
alter table aranj_plante
add nr_flori int

insert into florarii(nume,tel,adresa) values('Petunia','0764984153','str.Mihai Viteazu nr.15')
insert into florarii(nume,tel,adresa) values('Rosse','0745357654','str.Buciu nr.87')
insert into florarii(nume,tel,adresa) values('Tulpinita','0723456789','str.Tatar nr.87')
go
select * from florarii

insert into categorii(nume) values('primavara')
insert into categorii(nume) values('vara')
insert into categorii(nume) values('cosulete')
insert into categorii(nume) values('coroane')
select* from categorii
go
insert into aranjamente(nume,pret,descriere,inaltime,id_flo, id_cat) values('Regina verii',300,'culori vii si aprinse',50,1,2)
insert into aranjamente(nume,pret,descriere,inaltime,id_flo, id_cat) values('Copilas dragalas',150,'micuti ca si ei',20,2,3)
insert into aranjamente(nume,pret,descriere,inaltime,id_flo, id_cat) values('Buchet 21 ani',600,'21 de trandafiri superbi',80,2,1)
insert into aranjamente(nume,pret,descriere,inaltime,id_flo, id_cat) values('Omagiu',200,'coniferi naturali',120,3,4)
select * from aranjamente

insert into plante(nume,descriere) values('trandafir','rosu')
insert into plante(nume,descriere) values('trandafir','alb')
insert into plante(nume,descriere) values('trandafir','galben')
insert into plante(nume,descriere) values('lalea','rosie')
insert into plante(nume,descriere) values('lalea','portocalie')
insert into plante(nume,descriere) values('garoafa','alba')
insert into plante(nume,descriere) values('garoafa','roz')
insert into plante(nume,descriere) values('crin regal','alb')
insert into plante(nume,descriere) values('orhidee','roz')
select* from plante

insert into aranj_plante(id_aranj,id_planta,nr_flori) values(1,4,5)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(1,5,3)

insert into aranj_plante(id_aranj,id_planta,nr_flori) values(2,1,1)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(2,2,3)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(2,3,3)

insert into aranj_plante(id_aranj,id_planta,nr_flori) values(3,1,7)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(3,2,7)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(3,3,7)

insert into aranj_plante(id_aranj,id_planta,nr_flori) values(4,6,6)
insert into aranj_plante(id_aranj,id_planta,nr_flori) values(4,7,6)
select* from aranj_plante
go

create or alter procedure adauga_planta
	@id_aranj int,
	@id_planta int,
	@numar int
as
begin
	if exists(select id_aranj,id_planta from aranj_plante where id_aranj=@id_aranj and id_planta=@id_planta) 
	begin
	update aranj_plante set nr_flori=nr_flori + @numar where id_aranj=@id_aranj and id_planta=@id_planta;
	end;
	else
	begin
	insert into aranj_plante(id_aranj,id_planta,nr_flori) values(@id_aranj,@id_planta,@numar)
	end;
end;

exec adauga_planta 1,8,1
go

create or alter view view1 as
select f.nume as nume_florarii,a.nume as nume_aranjament ,a.pret,ap.nr_flori, p.nume as nume_planta 
from florarii f
inner join aranjamente a on
a.id_flo=f.id
inner join aranj_plante ap on
ap.id_aranj=a.id
inner join plante p on
p.id=ap.id_planta
where f.nume not like 'R%'

select * from view1