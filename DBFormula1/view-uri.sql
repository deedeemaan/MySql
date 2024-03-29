use Formula1
go
create view view1 as
	select nume_sofer,echipa,varsta from Soferi;
go

create view view2 as
	select s.nume_sofer, c.pozitie_sofer, c.puncte_sofer
	from Campionat_Soferi c inner join Soferi s on c.id_camp_soferi = s.id_camp_soferi;
go

create VIEW view3 as
	SELECT COUNT(id_sofer) as 'participanti la curse' ,Cl.nume_circuit
	FROM Soferi S
	INNER JOIN ParticipareT P ON
	P.id_soferi_foreign=S.id_sofer
	INNER JOIN CurseT C ON
	C.id_cursa=P.id_curse_foreign
	INNER JOIN CalendarT Cl ON
	Cl.id_calendar=C.id_calendar
	WHERE P.participare='Da'
	GROUP BY C.id_cursa, Cl.nume_circuit
go

select * from view1
select * from view2
select * from view3

insert into Views (Name) values('view1'),('view2'),('view3')
select * from Views

insert into Tables (Name) values('ParticipareT'),('CurseT'),('CalendarT')
select * from Tables

INSERT INTO Tests (Name)
VALUES	('DI_CalendarT_View1'),
		('DI_CurseT_View2'),
		('DI_ParticipareT_View3');

update Tests set Name='DI_ParticipareT_View3' where TestID=3
SELECT * FROM Tests;
GO

INSERT INTO TestTables (TestID, TableID, NoOfRows, Position)
VALUES	(1, 4, 100, 1),
		(2, 4, 50, 1),
		(2, 2, 50, 2),
		(3, 4, 100, 1),
		(3, 2, 100, 2),
		(3, 1, 100, 3);
select * from TestTables

INSERT INTO TestViews (TestID, ViewID)
VALUES	(1, 1),
		(2, 2),
		(3, 3);


SELECT * FROM TestViews;
GO

CREATE PROCEDURE insertCalendarT @NoOfRows INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @oras VARCHAR(50);
	DECLARE @nume VARCHAR(50);
	DECLARE @data VARCHAR(50);
	DECLARE @n INT = 1;
	DECLARE @current_id INT = 1;

	WHILE @n <= @NoOfRows
	BEGIN
		
		SET @oras = 'Oras' + CONVERT(VARCHAR(10), @current_id);
		SET @nume = 'Nume' + CONVERT(VARCHAR(10), @current_id);
		SET @oras = 'Data' + CONVERT(VARCHAR(10), @current_id);
		INSERT INTO CalendarT(id_calendar,oras,nume_circuit,data_cursa)
		VALUES (@current_id,@oras,@nume,@data);
		SET @current_id = @current_id + 1;
		SET @n = @n + 1;
	END

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' date in calendar'; 
END
GO
exec insertCalendarT 100
go

CREATE PROCEDURE insertCurseT @NoOfRows INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @fk INT = 
			(SELECT MAX(c.id_calendar) FROM CalendarT c);
	DECLARE @lungime bigint;
	DECLARE @castigator VARCHAR(50);
	DECLARE @prima_pozitie VARCHAR(50);
	DECLARE @n INT = 1;
	DECLARE @current_id INT = 1;
	WHILE @n <= @NoOfRows
	BEGIN
		SET @lungime = 5000;
		SET @castigator = 'castigator' + CONVERT(VARCHAR(10), @current_id);
		SET @prima_pozitie = 'prima_pozitie' + CONVERT(VARCHAR(10), @current_id);
		INSERT INTO CurseT(id_cursa, lungime_circuit,id_calendar,castigator,prima_pozitie)
		VALUES (@current_id, @lungime, @fk, @castigator, @prima_pozitie);
		SET @current_id = @current_id + 1;
		SET @n = @n + 1;
	END

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' curse';
END
GO
exec insertCurseT 100
go

CREATE OR ALTER PROCEDURE insertParticipareT @NoOfRows INT 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @n INT = 0;
	DECLARE @fk1 INT;
	--INSERT INTO Soferi(id_sofer,nume_sofer,echipa,id_camp_soferi,varsta,id_masina) VALUES 
	--(25,'Test','Test',1,99,999);
	DECLARE @fk2 INT = 25
	DECLARE	@participare char(2);
	
	DECLARE cursorCurse CURSOR FAST_FORWARD FOR
	SELECT f.id_cursa FROM CurseT f WHERE f.castigator LIKE 'castigator%';
	
	OPEN cursorCurse;
	
	FETCH NEXT FROM cursorCurse INTO @fk1;
	WHILE (@n < @NoOfRows) AND (@@FETCH_STATUS = 0)
	BEGIN
		SET @participare = 'Da';
		INSERT INTO ParticipareT(id_soferi_foreign, id_curse_foreign, participare)
		VALUES (@fk2, @fk1, @participare);
		SET @n = @n + 1;
		FETCH NEXT FROM cursorCurse INTO @fk1;
	END

	CLOSE cursorCurse;
	DEALLOCATE cursorCurse

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @n) + ' participari';
END
GO
exec insertParticipareT 100
go

select* from Masina

select* from Soferi

delete from Soferi where id_sofer=25
delete from ParticipareT

select* from ParticipareT
go

CREATE PROCEDURE insertTable @idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) =
			(SELECT t.Name FROM Tests t WHERE t.TestID = @idTest);
	DECLARE @numeTabel NVARCHAR(50);
	DECLARE @NoOfRows INT;
	DECLARE @procedura VARCHAR(50);

	DECLARE cursorTabele CURSOR FORWARD_ONLY FOR
	SELECT ta.Name, te.NoOfRows 
	FROM TestTables te INNER JOIN Tables ta ON te.TableID = ta.TableID
	WHERE te.TestID = @idTest
	ORDER BY te.Position;

	OPEN cursorTabele;

	FETCH NEXT FROM cursorTabele INTO @numeTabel, @NoOfRows;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @procedura = 'insert' + @numeTabel;
		EXEC @procedura @NoOfRows;
		FETCH NEXT FROM cursorTabele INTO @numeTabel, @NoOfRows;
	END

	CLOSE cursorTabele;
	DEALLOCATE cursorTabele;
END
GO

CREATE PROCEDURE deleteCalendarT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM CalendarT;

	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' date din calendar';
END
GO
exec deleteCalendarT
go

CREATE PROCEDURE deleteCurseT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM CurseT;

	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' curse';
END
GO
exec deleteCurseT
go

CREATE OR ALTER PROCEDURE deleteParticipareT
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM ParticipareT;

	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' participari';
END
GO
EXEC deleteParticipareT
go
drop procedure deleteParticipareT
go

CREATE PROCEDURE deleteTable @idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) =
			(SELECT t.Name FROM Tests t WHERE t.TestID = @idTest);
	DECLARE @numeTabel NVARCHAR(50);
	DECLARE @procedura VARCHAR(50);

	DECLARE cursorTabele CURSOR FORWARD_ONLY FOR
	SELECT ta.Name 
	FROM TestTables te INNER JOIN Tables ta ON te.TableID = ta.TableID
	WHERE te.TestID = @idTest
	ORDER BY te.Position DESC;

	OPEN cursorTabele;

	FETCH NEXT FROM cursorTabele INTO @numeTabel;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @procedura = 'delete' + @numeTabel;
		EXEC @procedura;
		FETCH NEXT FROM cursorTabele INTO @numeTabel;
	END

	CLOSE cursorTabele;
	DEALLOCATE cursorTabele;
END
GO

CREATE PROCEDURE selectView @idTest INT
AS
BEGIN
	DECLARE @viewName NVARCHAR(50) =
			(SELECT v.Name FROM Views v INNER JOIN TestViews tv on tv.ViewID = v.ViewID
			 WHERE tv.TestID = @idTest);
	DECLARE @select VARCHAR(50) = 'SELECT * FROM ' + @viewName;

	EXEC (@select);
END
GO
SELECT v.Name FROM Views v INNER JOIN TestViews tv on tv.ViewID = v.ViewID
			 WHERE tv.TestID = 1
go

CREATE or ALTER PROCEDURE runTest2
AS
BEGIN
	DECLARE @ds DATETIME;
	DECLARE @de DATETIME;
	DECLARE @dsAll DATETIME = NULL;
	DECLARE @idTest INT = 1;
	DECLARE @tableID INT;
	DECLARE @viewID INT;

	INSERT INTO TestRuns (Description, StartAt, EndAt)
	VALUES ('Test Database', null, null);

	DECLARE @testRunID INT =
			(SELECT MAX(tr.TestRunID) FROM TestRuns tr);

	WHILE @idTest < 4
	BEGIN
		SET @ds = GETDATE();
		IF(@dsAll is NULL)
		BEGIN
			SET @dsAll = @ds;
		END;

		EXEC deleteTable @idTest;
		EXEC insertTable @idTest;

		SET @de = GETDATE();

		SET @tableID =
			(SELECT ta.TableID FROM Tests te
			INNER JOIN TestTables tt ON tt.TestID = te.TestID
			INNER JOIN Tables ta ON ta.TableID = tt.TableID
			WHERE tt.TestID = @idTest AND
			te.Name LIKE 'DI_' + ta.Name + '_%');
	
		INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt)
		VALUES (@testRunID, @tableID, @ds, @de);

		SET @idTest = @idTest + 1;
	END

	UPDATE TestRuns SET StartAt = @dsAll WHERE TestRunID = @testRunID;

	SET @idTest = 1;
	WHILE @idTest < 4
	BEGIN
		SET @ds = GETDATE();

		EXEC selectView @idTest;

		SET @de = GETDATE();

		SET @viewID =
			(SELECT v.ViewID FROM Views v
			INNER JOIN TestViews tv ON tv.ViewID = v.ViewID
			WHERE tv.TestID = @idTest);
	
		INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt)
		VALUES (@testRunID, @viewID, @ds, @de);

		SET @idTest = @idTest + 1;
	END

	UPDATE TestRuns SET EndAt = @de WHERE TestRunID = @testRunID;	

	PRINT 'Testul a rulat pentru ' + CONVERT(VARCHAR(10), DATEDIFF(millisecond, @de, @dsAll)) + ' milisecunde';
END
GO

USE Formula1

EXEC runTest2;
GO

DELETE FROM TestRuns
select * from TestRuns
select* from TestRunTables
select* from TestRunViews