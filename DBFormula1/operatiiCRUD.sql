use Formula1
go


--validare lungime circuit
CREATE OR ALTER FUNCTION dbo.TestLungime(@lungime BIGINT)
RETURNS BIT
BEGIN
	DECLARE @ret BIT  = 0;
	IF @lungime > 3000 SET @ret = 1;
	RETURN @ret;
END;
GO

--validare varsta
CREATE OR ALTER FUNCTION dbo.TestVarsta(@varsta BIGINT)
RETURNS BIT
BEGIN
	DECLARE @ret BIT = 0;
	IF @varsta > 17 SET @ret = 1;
	RETURN @ret;
END;
GO

select* from Curse
select* from Participare
select* from Masina
GO


--validare participare
CREATE OR ALTER FUNCTION dbo.TestParticipare(@participare CHAR(2))
RETURNS BIT
BEGIN
	DECLARE @ret BIT = 0;
	IF LEN(@participare) = 2 SET @ret = 1;
	RETURN @ret;
END;
GO


--validare id cursa
CREATE OR ALTER FUNCTION dbo.TestIdCursa(@id BIGINT)
RETURNS BIT
BEGIN
	DECLARE @ret BIT = 0;
	IF EXISTS(SELECT id_cursa FROM Curse WHERE id_cursa = @id) SET @ret = 1;
	RETURN @ret;
END;
GO

--validare id sofer
CREATE OR ALTER FUNCTION dbo.TestIdSofer(@id BIGINT)
RETURNS BIT
BEGIN
	DECLARE @ret BIT = 0;
	IF EXISTS(SELECT id_sofer FROM Soferi WHERE id_sofer = @id) SET @ret = 1;
	RETURN @ret;
END;
GO

--validare string
CREATE OR ALTER FUNCTION dbo.TestString(@str VARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @ret BIT = 0;
	IF LEN(@str) > 0 SET @ret = 1;
	RETURN @ret;
END;
GO

-------------CRUD Curse
CREATE OR ALTER PROCEDURE CreateCurse
	@id BIGINT,
	@lungime_circuit BIGINT,
	@id_calendar BIGINT,
	@castigator VARCHAR(100),
	@prima_pozitie VARCHAR(100),
	@id_oras BIGINT
AS
BEGIN
	IF(dbo.TestString(@castigator) = 1 AND dbo.TestString(@prima_pozitie) = 1 
	AND dbo.TestLungime(@lungime_circuit) = 1)
	BEGIN
		INSERT INTO Curse(id_cursa, lungime_circuit,id_calendar,castigator,prima_pozitie,id_oras)
		VALUES (@id, @lungime_circuit,@id_calendar,@castigator,@prima_pozitie,@id_oras);

		PRINT 'Inserarea a fost realizata cu succes'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiei pe tabela Cursa'
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE ReadCurse
AS
BEGIN
		SELECT * FROM Curse;
END;
GO

CREATE OR ALTER PROCEDURE UpdateCursa
	@id BIGINT,
	@lungime_noua VARCHAR(100)
AS
BEGIN
	IF(dbo.TestLungime(@lungime_noua) = 1)
	BEGIN
		UPDATE Curse SET lungime_circuit = @lungime_noua
		WHERE id_cursa = @id;

		PRINT 'Update realizat cu succes';
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiei pe tabela Cursa'
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE DeleteCursa
	@id BIGINT
AS
BEGIN
	IF(dbo.TestIdCursa(@id) = 1)
	BEGIN
		DELETE FROM Curse
		WHERE id_cursa = @id;

		PRINT 'Stergerea a fost realizata cu succes'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiei pe tabela Cursa'
		RETURN;
	END;
END;
GO

EXEC CreateCurse 15,3555,1,'Charles Leclerc','Max Verstappen',1;
EXEC ReadCurse;
EXEC UpdateCursa 15,3333;
EXEC DeleteCursa 15;
go

-----------CRUD Soferi
CREATE OR ALTER PROCEDURE CreateSofer
	@id BIGINT,
	@nume VARCHAR(100),
	@echipa VARCHAR(100),
	@id_camp BIGINT,
	@varsta BIGINT,
	@id_masina BIGINT
AS
BEGIN
	print (@id_masina)
	IF(dbo.TestVarsta(@varsta) = 1 AND dbo.TestString(@nume)=1 and dbo.TestString(@echipa) =1)
	BEGIN
		INSERT INTO	Soferi(id_sofer,nume_sofer,echipa,id_camp_soferi,varsta,id_masina)
		VALUES(@id,@nume,@echipa,@id_camp,@varsta,@id_masina)
		PRINT 'Crearea efectuata cu succes'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Soferi';
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE ReadSoferi
AS
BEGIN
	SELECT * FROM Soferi;
END;
GO

CREATE OR ALTER PROCEDURE UpdateSofer
	@id BIGINT,
	@echipa_noua VARCHAR(100)
AS
BEGIN
	IF(dbo.TestString(@echipa_noua) = 1 and dbo.TestIdSofer(@id) =1)
	BEGIN
		UPDATE Soferi SET echipa = @echipa_noua
		WHERE id_sofer = @id;
		PRINT 'Update ul efectual cu succes'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Soferi';
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE DeleteSofer
	@id BIGINT
AS
BEGIN
	IF(dbo.TestIdSofer(@id) = 1)
	BEGIN
		DELETE FROM Soferi
		WHERE id_sofer = @id;

		PRINT 'Stergere efectuata cu succes'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Soferi';
		RETURN;
	END;
END;
GO

EXEC ReadSoferi;
EXEC CreateSofer 28,'Sofer','echipa',2,25,33;
EXEC UpdateSofer 28,'echipanoua';
EXEC DeleteSofer 28;
GO

---------CRUD Participare
CREATE OR ALTER PROCEDURE CreateParticipare
	@id_sofer bigint,
	@id_cursa bigint,
	@part CHAR(2)
AS
BEGIN
	IF(dbo.TestParticipare(@part) = 1 and dbo.TestIdCursa(@id_cursa) = 1 and dbo.TestIdSofer(@id_sofer) = 1)
	BEGIN
		INSERT INTO Participare(id_soferi_foreign,id_curse_foreign,participare)
		VALUES (@id_sofer,@id_cursa,@part);
		PRINT 'inserare realizata cu succes';
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Participare';
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE ReadParticipare
AS
BEGIN
	SELECT * FROM Participare;
END;
GO

CREATE OR ALTER PROCEDURE UpdateParticipare
	@id_sofer bigint,
	@id_cursa bigint,
	@part_noua CHAR(2)
AS
BEGIN
	IF(dbo.TestParticipare(@part_noua) = 1 and dbo.TestIdCursa(@id_cursa) = 1 and dbo.TestIdSofer(@id_sofer) = 1)
	BEGIN
		UPDATE Participare SET participare = @part_noua
		WHERE id_soferi_foreign=@id_sofer and id_curse_foreign=@id_cursa;

		PRINT 'inserare realizata cu succes';
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Participare';
		RETURN;
	END;
END;
GO

CREATE OR ALTER PROCEDURE DeleteParticipare
	@id_sofer bigint,
	@id_cursa bigint,
	@part CHAR(2)
AS BEGIN
	IF(dbo.TestParticipare(@part) = 1 and dbo.TestIdCursa(@id_cursa) = 1 and dbo.TestIdSofer(@id_sofer) = 1)
	BEGIN
		DELETE FROM Participare
		WHERE id_soferi_foreign = @id_sofer and participare=@part;

		PRINT 'stergerea pentru tabelul Participare efectuata'
	END
	ELSE
	BEGIN
		PRINT 'Eroare la efectuarea operatiilor CRUD pentru tabelul Participare';
		RETURN;
	END;
END;
GO

select * from Soferi ORDER BY varsta
select * from Curse
EXEC ReadParticipare;
EXEC CreateParticipare 25,14,'Da';
EXEC UpdateParticipare 25,14,'Nu';
EXEC DeleteParticipare 25,14,'Nu';
go

------------------Views-------------------------

CREATE OR ALTER VIEW SoferiView
AS
	SELECT varsta, count(*) as 'Nr Soferi' FROM Soferi
	group by varsta
GO

SELECT * FROM SoferiView

IF EXISTS(SELECT NAME FROM sys.indexes WHERE name = 'N_idx_soferi_varsta')
DROP INDEX N_idx_soferi_varsta ON Soferi
CREATE NONCLUSTERED INDEX N_idx_soferi_varsta ON Soferi(varsta);
go


CREATE OR ALTER VIEW ParticipariView
AS
	SELECT COUNT(id_sofer) as 'participari la curse' ,Cl.nume_circuit
	FROM Soferi S
	INNER JOIN Participare P ON
	P.id_soferi_foreign=S.id_sofer
	INNER JOIN Curse C ON
	C.id_cursa=P.id_curse_foreign
	INNER JOIN Calendar Cl ON
	Cl.id_calendar=C.id_calendar
	WHERE P.participare='Da'
	GROUP BY C.id_cursa, Cl.nume_circuit HAVING COUNT(id_sofer)>16
go

select* from ParticipariView

IF EXISTS(SELECT NAME FROM sys.indexes WHERE name = 'N_idx_participare')
DROP INDEX N_idx_participare ON Participare
CREATE NONCLUSTERED INDEX N_idx_participare ON Participare(participare);
go
