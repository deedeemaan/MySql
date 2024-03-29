USE Formula1

CREATE TABLE Unitati_De_Putere
( id_unitate_putere BIGINT,
cai_putere BIGINT,
tip_unitate_putere BIGINT,
PRIMARY KEY(id_unitate_putere)
);

CREATE TABLE Constructori
( id_constructor BIGINT,
nume_constructor VARCHAR(100),
culoare VARCHAR(100),
PRIMARY KEY(id_constructor)
);

CREATE TABLE Masina
( id_masina BIGINT,
sofer BIGINT NOT NULL UNIQUE,
unitate_de_putere BIGINT,
constructor BIGINT,
CONSTRAINT FK_UnitateDePutere FOREIGN KEY(unitate_de_putere) REFERENCES Unitati_De_Putere(id_unitate_putere), --one to many
CONSTRAINT FK_Constructori FOREIGN KEY(constructor) REFERENCES Constructori(id_constructor), --one to many
);

CREATE TABLE Soferi
( id_sofer BIGINT,
puncte BIGINT,
nume_sofer VARCHAR(100),
echipa VARCHAR(100),
PRIMARY KEY(id_sofer)
);

CREATE TABLE Pneuri
(id_pneuri BIGINT,
tip_pneuri VARCHAR(100),
compozitie VARCHAR(100),
PRIMARY KEY(id_pneuri)
);

CREATE TABLE Campionat_Soferi
(id_camp_soferi BIGINT,
puncte_sofer BIGINT,
PRIMARY KEY(id_camp_soferi)
);

CREATE TABLE Curse
( id_cursa BIGINT,
oras VARCHAR(100),
lungime_circuit BIGINT,
nume_cursa VARCHAR(100),
pole_position BIGINT,
PRIMARY KEY(id_cursa)
);

CREATE TABLE Participare --many to many
(id_soferi_foreign BIGINT,
id_curse_foreign BIGINT,
participare CHAR(2),
CONSTRAINT PK_Participare PRIMARY KEY(id_soferi_foreign, id_curse_foreign), 
CONSTRAINT FK_Soferi FOREIGN KEY(id_soferi_foreign) REFERENCES Soferi(id_sofer),
CONSTRAINT FK_Curse FOREIGN KEY(id_curse_foreign) REFERENCES Curse(id_cursa)
);

CREATE TABLE Campionat_Constructori
(id_camp_constructori BIGINT,
PRIMARY KEY(id_camp_constructori)
);

CREATE TABLE Calendar
(id_calendar BIGINT,
PRIMARY KEY(id_calendar)
);



ALTER TABLE Masina
ADD id_masina BIGINT IDENTITY

ALTER TABLE Masina
ADD CONSTRAINT PK_masina PRIMARY KEY(id_masina);

ALTER TABLE Pneuri
ADD id_masina BIGINT;

ALTER TABLE Pneuri
ADD CONSTRAINT FK_Masina FOREIGN KEY(id_masina) REFERENCES Masina(id_masina);

ALTER TABLE Soferi
ADD id_camp_soferi BIGINT;

ALTER TABLE Soferi
ADD CONSTRAINT FK_Camp_soferi FOREIGN KEY(id_camp_soferi) REFERENCES Campionat_Soferi(id_camp_soferi);

ALTER TABLE Curse
ADD id_calendar BIGINT;

ALTER TABLE Curse
ADD CONSTRAINT FK_Calendar FOREIGN KEY(id_calendar) REFERENCES Calendar(id_calendar);

ALTER TABLE Constructori
ADD id_camp_constructori BIGINT;

ALTER TABLE Constructori
ADD CONSTRAINT FK_Camp_Constructori FOREIGN KEY(id_camp_constructori) REFERENCES Campionat_Constructori(id_camp_constructori);

ALTER TABLE Soferi
ADD id_masina BIGINT;


ALTER TABLE Soferi
ADD CONSTRAINT FK_Masina_ FOREIGN KEY (id_sofer) REFERENCES Masina(id_masina);


ALTER TABLE Calendar
ADD oras VARCHAR(100);

ALTER TABLE Calendar
ADD nume_circuit VARCHAR(100);

ALTER TABLE Calendar
ADD data_cursa VARCHAR(100);

ALTER TABLE Campionat_Constructori
ADD pozitie_clasament BIGINT;

ALTER TABLE Campionat_Constructori
ADD punctaj BIGINT;

ALTER TABLE Campionat_Soferi
ADD pozitie_sofer BIGINT;

ALTER TABLE Campionat_Soferi
ADD nume VARCHAR(100);

ALTER TABLE Constructori
ADD director_echipa VARCHAR(100);

ALTER TABLE Constructori
ADD sponsor_principal VARCHAR(100);

ALTER TABLE Curse
ADD castigator VARCHAR(100);

ALTER TABLE Curse
ADD prima_pozitie VARCHAR(100);

ALTER TABLE Masina
ADD culoare VARCHAR(100);

ALTER TABLE Soferi
ADD varsta BIGINT;