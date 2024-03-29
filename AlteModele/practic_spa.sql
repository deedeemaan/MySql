create database Spa
use Spa
go

create table orase
(
	id int primary key identity(1,1),
	nume varchar(50)
)

insert into orase values('baia mare'),('cluj'),('bistrita')
select* from orase

create table centre
(	
	id int primary key identity(1,1),
	nume varchar(50),
	site_web varchar(50),
	id_oras int,
	constraint fk_oras foreign key(id_oras) references orase(id)
)
insert into centre values('drurelax','dru.com',1),('seneca','seneca.com',2),('nympheea','nym.com',3),('relax','relax.com',2)
select* from centre


create table servicii
(
	id int primary key identity(1,1),
	nume varchar(50),
	descriere varchar(100),
	pret int,
	recomandare varchar(100),
	id_centru int,
	constraint fk_centru foreign key(id_centru) references centre(id)
)
insert into servicii values('masaj','cu ventuze',150,'spate',1),('tratament cu pesti','exfoliere',100,'picioare',2),('facial','curatare',200,'fata',2)
insert into servicii values('sauna',null,50,'respiratie',3)
insert into servicii(nume,pret,recomandare,id_centru) values('sauna',50,'respiratie',3)
insert into servicii values('sauna','',50,'respiratie',3)

select* from servicii

create table clienti
(
	id int primary key identity(1,1),
	nume varchar(50),
	prenume varchar(50),
	ocupatie varchar(50)
)
insert into clienti values('pop','ana','profesoara'),('gica','hagi','fotbalist'),('lando','norris','sofer f1')

create table servicii_clienti
(
	id_serviciu int,
	id_client int,
	nota int,
	constraint pk_serv_clienti primary key(id_serviciu, id_client),
	constraint fk_serv foreign key(id_serviciu) references servicii(id),
	constraint fk_client foreign key(id_client) references clienti(id)
)
go

insert into servicii_clienti(id_serviciu,id_client,nota) values(1,1,10),(1,2,8),(2,1,7),(3,3,10),(2,3,8)
select* from servicii_clienti
go

create or alter procedure adauga_serviciu_client
	@id_serviciu int,
	@id_client int,
	@nota int
as
begin
	if exists(select * from servicii_clienti where id_serviciu=@id_serviciu and id_client=id_client)
	begin
	update servicii_clienti set nota=@nota where id_serviciu=@id_serviciu and id_client=@id_client;
	end;
	else
	begin
	insert into servicii_clienti(id_serviciu,id_client,nota) values (@id_serviciu,@id_client,@nota)
	end
end;
go
exec adauga_serviciu_client 2,3,9
go

create or alter function Afisare()
returns table as
return select c.nume as nume_centru, s.nume as nume_serviciu, s.descriere, sc.nota,cl.nume as nume_client
from centre c 
inner join servicii s on
s.id_centru=c.id
inner join servicii_clienti sc on
sc.id_serviciu=s.id
inner join clienti cl on
cl.id=sc.id_client
where s.descriere is not null

select * from dbo.Afisare()