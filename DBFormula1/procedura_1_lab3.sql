ALTER PROCEDURE SchimbaTipul
AS
BEGIN
ALTER TABLE Participare ALTER COLUMN participare varchar(2)
END;

EXEC SchimbaTipul

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE SchimbaTipulUndo
AS
BEGIN
ALTER TABLE Participare ALTER COLUMN participare char(2)
END;

EXEC SchimbaTipulUndo

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE AdaugaConstrangereDefault
AS
BEGIN
ALTER TABLE Soferi 
ADD CONSTRAINT df_varsta_min DEFAULT 18 FOR varsta
END;

EXEC AdaugaConstrangereDefault;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE AdaugaConstrangereDefaultUndo
AS
BEGIN
ALTER TABLE Soferi DROP CONSTRAINT df_varsta_min
END;

EXEC AdaugaConstrangereDefaultUndo;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11

CREATE PROCEDURE CreeazaTabela
AS
BEGIN
CREATE TABLE Soferi_de_rezerva
(
id_sof_rez int primary key
);
END;

EXEC CreeazaTabela;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE StergeTablea
AS
BEGIN
DROP TABLE Soferi_de_rezerva
END;

EXEC StergeTablea;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE AdaugaCampNou
AS
BEGIN
ALTER TABLE Pneuri
ADD durabilitate varchar(100)
END;

EXEC AdaugaCampNou;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE PROCEDURE StergeCamp
AS
BEGIN
ALTER TABLE Pneuri
DROP COLUMN durabilitate
END;

EXEC StergeCamp;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALTER PROCEDURE CreeazaConstrangereCheieStraina
AS
BEGIN
ALTER TABLE Calendar
ADD CONSTRAINT FK_Sofer FOREIGN KEY(id_sofer_foreign) REFERENCES Soferi(id_sofer)
END;

EXEC CreeazaConstrangereCheieStraina;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE PROCEDURE StergeConstrangereCheieStraina
AS
BEGIN
ALTER TABLE Calendar
DROP CONSTRAINT FK_Sofer
END;

EXEC StergeConstrangereCheieStraina;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE PROCEDURE ExecutaVersiuneCrescator @versiune INT
AS
BEGIN
		IF @versiune=1
			EXEC SchimbaTipul;
		ELSE IF @versiune=2
			EXEC AdaugaConstrangereDefault;
		ELSE IF @versiune=3
			EXEC CreeazaTabela;
		ELSE IF @versiune=4
			EXEC AdaugaCampNou;
		ELSE IF @versiune=5
			EXEC CreeazaConstrangereCheieStraina;
END;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE PROCEDURE ExecutaVersiuneDescrescator @versiune INT
AS
BEGIN
		IF @versiune=0
			EXEC SchimbaTipulUndo;
		ELSE IF @versiune=1
			EXEC AdaugaConstrangereDefaultUndo;
		ELSE IF @versiune=2
			EXEC StergeTablea;
		ELSE IF @versiune=3
			EXEC StergeCamp;
		ELSE IF @versiune=4
			EXEC StergeConstrangereCheieStraina;
END;

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- Crează procedura stocată pentru actualizarea versiunii bazei de date
ALTER PROCEDURE ActualizeazaVersiunea
    @versiunea_noua INT
AS
BEGIN
	IF @versiunea_noua > 5 OR @versiunea_noua < 0
	BEGIN
		PRINT 'Versiunea introdusa nu este corecta!';
		RETURN;
	END
    DECLARE @versiunea_actuala INT;

    SELECT @versiunea_actuala = versiunea_curenta FROM versiuni;

    IF @versiunea_noua > @versiunea_actuala
    BEGIN
        WHILE @versiunea_actuala <> @versiunea_noua
		BEGIN
			SET @versiunea_actuala=@versiunea_actuala+1
			EXEC ExecutaVersiuneCrescator @versiune=@versiunea_actuala
		END
        PRINT 'Baza de date actualizată cu succes!';
    END
    ELSE IF @versiunea_noua < @versiunea_actuala
    BEGIN
        WHILE @versiunea_actuala <> @versiunea_noua
		BEGIN
			SET @versiunea_actuala=@versiunea_actuala-1
			EXEC ExecutaVersiuneDescrescator @versiune=@versiunea_actuala
		END
        PRINT 'Baza de date actualizată cu succes!';
    END
	UPDATE versiuni SET versiunea_curenta=@versiunea_noua;
END;

UPDATE versiuni SET versiunea_curenta = 0;
EXEC ActualizeazaVersiunea @versiunea_noua=-5;

select * from INFORMATION_SCHEMA.COLUMNS;
select * from versiuni

EXEC SchimbaTipulUndo;
EXEC AdaugaConstrangereDefaultUndo;
EXEC StergeTablea;
EXEC StergeCamp;
EXEC StergeConstrangereCheieStraina;

EXEC SchimbaTipul;
EXEC AdaugaConstrangereDefault;
EXEC CreeazaTabela;
EXEC AdaugaCampNou;
EXEC CreeazaConstrangereCheieStraina;