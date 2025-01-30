USE Spitali;
GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFamiljare
ON AnamnezaFamiljare
INSTEAD OF INSERT
AS BEGIN
	IF dbo.EshtePacientiNenKujdesinAnetaritStafit((SELECT PacientId FROM INSERTED), CURRENT_USER) = 0
		THROW 401, 'Veprim i paautorizuar', 1;

	INSERT INTO AnamnezaFamiljare(PacientId, StafiPergjegjesId, LidhjaFamiljare, Datelindja, Semundja, MoshaDiagnozes, ShkakuVdekjes, DataVdekjes)
	SELECT i.PacientId, staf.PersonId, i.LidhjaFamiljare, i.Datelindja, i.Semundja, i.MoshaDiagnozes, i.ShkakuVdekjes, i.DataVdekjes
	FROM INSERTED i
	INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFiziologjike
ON AnamnezaFiziologjike
INSTEAD OF INSERT
AS BEGIN
	IF dbo.EshtePacientiNenKujdesinAnetaritStafit((SELECT INSERTED.PacientId FROM INSERTED), CURRENT_USER) = 0
		THROW 401, 'Veprim i paautorizuar', 1;

	INSERT INTO AnamnezaFiziologjike(PacientId, StafiPergjegjesId, SistemiFrymemarrjes, SistemiGjenitourinar, SistemiTretes, SistemiOkular, SistemiNeurologjik, SistemiORL, SistemiKardiovaskular)
	SELECT i.PacientId, staf.PersonId, i.SistemiFrymemarrjes, i.SistemiGjenitourinar, i.SistemiTretes, i.SistemiOkular, i.SistemiNeurologjik, i.SistemiORL, i.SistemiKardiovaskular
	FROM INSERTED i
	INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeSemundjeje
ON AnamnezaSemundjes
INSTEAD OF INSERT
AS BEGIN
	IF dbo.EshtePacientiNenKujdesinAnetaritStafit((SELECT INSERTED.PacientId FROM INSERTED), CURRENT_USER) = 0
		THROW 401, 'Veprim i paautorizuar', 1;

	INSERT INTO AnamnezaSemundjes(PacientId, StafiPergjegjesId, Semundja, DataDiagnozes, EshteKronike)
	SELECT i.PacientId, staf.PersonId, i.Semundja, i.DataDiagnozes, i.EshteKronike
	FROM INSERTED i
	INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeAbuzimi
ON AnamnezaAbuzimit
INSTEAD OF INSERT
AS BEGIN
	IF dbo.EshtePacientiNenKujdesinAnetaritStafit((SELECT INSERTED.PacientId FROM INSERTED), CURRENT_USER) = 0
		THROW 401, 'Veprim i paautorizuar', 1;

	INSERT INTO AnamnezaAbuzimit(PacientId, StafiPergjegjesId, Substanca, Pershkrimi, DataFillimit, DataPerfundimit)
	SELECT i.PacientId, staf.PersonId, i.Substanca, i.Pershkrimi, i.DataFillimit, i.DataPerfundimit
	FROM INSERTED i
	INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFarmakologjike
ON AnamnezaFarmakologjike
INSTEAD OF INSERT
AS BEGIN
	IF dbo.EshtePacientiNenKujdesinAnetaritStafit((SELECT INSERTED.PacientId FROM INSERTED), CURRENT_USER) = 0
		THROW 401, 'Veprim i paautorizuar', 1;

	INSERT INTO AnamnezaFarmakologjike(PacientId, StafiPergjegjesId, Ilaci, Doza, Arsyeja, DataFillimit, DataPerfundimit, MarrePaRecete)
	SELECT i.PacientId, staf.PersonId, i.Ilaci, i.Doza, i.Arsyeja, i.DataFillimit, i.DataPerfundimit, i.MarrePaRecete
	FROM INSERTED i
	INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
END;

GO

CREATE OR ALTER TRIGGER ValidoShtiminTakimit
ON Takim
FOR INSERT
AS BEGIN
	DECLARE @dataTakimit DATETIME = (SELECT DataTakimit FROM INSERTED);
	DECLARE @doktorId INT = (SELECT DoktorId FROM INSERTED),
		@infermierId INT = (SELECT InfermierId FROM INSERTED);

	IF CAST(@dataTakimit AS DATE) < CAST(GETDATE() AS DATE)
	BEGIN
		RAISERROR('Nuk mund te krijohet nje takim ne te kaluaren', 16, -1);
		ROLLBACK TRANSACTION;
	END

	-- Kontrollo nese takimi eshte brenda orarit te stafit
	IF NOT EXISTS(
		SELECT 1
		FROM OrariPloteStafit
		WHERE 
			StafId = @doktorId AND
			(CAST(@dataTakimit AS TIME) between OraFilluese and OraPerfundimtare) AND 
			DitaId = DATEPART(dw, @dataTakimit))
		BEGIN
			RAISERROR('Nuk mund te krijohet nje takim jashte orarit te doktorit perkates', 16, -1);
			ROLLBACK TRANSACTION;
		END

	IF 
		@infermierId IS NOT NULL AND
		NOT EXISTS(
			SELECT 1
			FROM OrariPloteStafit
			WHERE 
				StafId = @infermierId AND
				(CAST(@dataTakimit AS TIME) BETWEEN OraFilluese AND OraPerfundimtare) AND 
				DitaId = DATEPART(dw, @dataTakimit))
		BEGIN
			RAISERROR('Nuk mund te krijohet nje takim jashte orarit te infermierit perkates', 16, -1);
			ROLLBACK TRANSACTION;
		END

	-- check if it conflicts with other meetings, te pakten 1 ore per cdo takim
	IF EXISTS(
		SELECT *
		FROM takim
		WHERE 
			(@dataTakimit BETWEEN DataTakimit AND DATEADD(MINUTE, 90, DataTakimit)) AND
			DoktorId = @infermierId)
		BEGIN
			RAISERROR('Ekzistojne takime per kete afat kohor per doktorin perkates', 16, -1);
			ROLLBACK TRANSACTION;
		END

	IF 
		@infermierId IS NOT NULL AND
		EXISTS(
			SELECT *
			FROM takim
			WHERE 
				(@dataTakimit BETWEEN DataTakimit AND DATEADD(MINUTE, 90, DataTakimit)) AND
				DoktorId = @infermierId)
		BEGIN
			RAISERROR('Ekzistojne takime per kete afat kohor per doktorin perkates', 16, -1);
			ROLLBACK TRANSACTION;
		END
END;

GO

CREATE OR ALTER TRIGGER ValidoPerditesiminTakimit
ON Takim
FOR UPDATE
AS BEGIN
	IF IS_ROLEMEMBER('Receptionist', CURRENT_USER) = 1
		BEGIN
			IF (SELECT DataTakimit FROM DELETED) < GETDATE()
				BEGIN
					RAISERROR('Perditesimi nuk lejohet pas ores se takimit', 16, -1);
					ROLLBACK TRANSACTION;
				END
		END
	ELSE
		BEGIN
			DECLARE @PersonIdAktual VARCHAR(MAX);

			SELECT @PersonIdAktual = PersonId
			FROM Staf
			WHERE PunonjesId = CURRENT_USER;

			IF (SELECT DoktorId FROM DELETED) != @PersonIdAktual OR (SELECT InfermierId FROM DELETED) != @PersonIdAktual
				BEGIN
					RAISERROR('Veprim i paautorizuar', 16, -1);
					ROLLBACK TRANSACTION;
				END

			IF (SELECT EshteAnulluar FROM DELETED) = 1
				BEGIN
					RAISERROR('Nuk mund te perditesohet nje takim i anulluar', 16, -1);
					ROLLBACK TRANSACTION;
				END
 
			IF
				((SELECT ShqetesimiKryesor FROM INSERTED) IS NOT NULL OR 
				(SELECT KohezgjatjaShqetesimit FROM INSERTED) IS NOT NULL OR 
				(SELECT SimptomaTeLidhura FROM INSERTED) IS NOT NULL OR 
				(SELECT Konkluzioni FROM INSERTED) IS NOT NULL)
				AND
				((SELECT ShqetesimiKryesor FROM DELETED) IS NOT NULL OR 
				(SELECT KohezgjatjaShqetesimit FROM DELETED) IS NOT NULL OR 
				(SELECT SimptomaTeLidhura FROM DELETED) IS NOT NULL OR 
				(SELECT Konkluzioni FROM DELETED) IS NOT NULL)
				BEGIN
					RAISERROR('Nuk mund te perditesohet informacioni mjekesor i takimit', 16, -1);
					ROLLBACK TRANSACTION;
				END
		END
END;

GO

CREATE OR ALTER TRIGGER ValidoPerditesiminFatures
ON Fature
FOR UPDATE
AS BEGIN
	IF (SELECT DataPagimit FROM DELETED) IS NOT NULL OR (SELECT MetodaPagimitId FROM DELETED) IS NOT NULL
		BEGIN
			RAISERROR('Nuk mund te ndryshohen data dhe metoda e pagimit', 16, -1);
			ROLLBACK TRANSACTION;
		END

	IF (SELECT DataPagimit FROM INSERTED) IS NULL OR (SELECT MetodaPagimitId FROM INSERTED) IS NULL
		BEGIN
			RAISERROR('Data dhe metoda e pagimit duhen suportuar', 16, -1);
			ROLLBACK TRANSACTION;
		END
END;

GO

CREATE OR ALTER TRIGGER ShtoFaturePerTakim
ON Takim
AFTER INSERT, UPDATE
AS BEGIN
	IF EXISTS(SELECT * FROM DELETED) -- Nese eshte perditesuar
		BEGIN
			-- Fshije faturen e takimit nese eshte anulluar
			IF UPDATE(EshteAnulluar) AND (SELECT EshteAnulluar FROM INSERTED) = 1
				BEGIN
					DELETE FROM Fature WHERE TakimId = (SELECT Id FROM INSERTED);
					RETURN;
				END
		END
	
	-- Shto fature nese shtohet takim ose takimit i eshte hequr anullimi
	INSERT INTO Fature(TakimId, Cmimi)
	SELECT i.Id, sherbim.Cmimi
	FROM INSERTED AS i
	INNER JOIN Sherbim AS sherbim ON i.SherbimId = sherbim.Kodi;
END;

GO

CREATE OR ALTER TRIGGER ShtoUserPasRegjistrimPacienti
ON Pacient
AFTER INSERT
AS BEGIN
	DECLARE @NID VARCHAR(MAX) = (SELECT NID FROM INSERTED);
	DECLARE @loginCommand VARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@NID),
		@userCommand VARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@NID),
		@roleCommand VARCHAR(MAX) = 'ALTER ROLE Pacient ADD MEMBER ' + QUOTENAME(@NID);

	EXEC(@loginCommand);
	EXEC(@userCommand);
	EXEC(@roleCommand);
END;

GO

CREATE OR ALTER TRIGGER ShtoUserPasRegjistrimStafi
ON Staf
AFTER INSERT
AS BEGIN
	DECLARE @punonjesId VARCHAR(MAX) = (SELECT PunonjesId FROM INSERTED),
			@roli VARCHAR(MAX) = (SELECT Emertimi FROM RolStafi WHERE Id = (SELECT RolId FROM INSERTED));

	DECLARE @loginCommand VARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@punonjesId),
			@userCommand VARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@punonjesId),
			@roleCommand VARCHAR(MAX) = 'ALTER ROLE ' + @roli + ' ADD MEMBER ' + QUOTENAME(@punonjesId);

	EXEC(@loginCommand);
	EXEC(@userCommand);
	EXEC(@roleCommand);
END;

GO

CREATE OR ALTER TRIGGER FshiUserPasFshirjesStafit
ON Staf
AFTER DELETE
AS BEGIN
	DECLARE @punonjesId INT = (SELECT PunonjesId FROM DELETED);
	DECLARE @loginCommand VARCHAR(MAX) = 'DROP LOGIN ' + QUOTENAME(@punonjesId),
			@userCommand VARCHAR(MAX) = 'DROP USER ' + QUOTENAME(@punonjesId);

	EXEC(@loginCommand);
	EXEC(@userCommand);
END;

GO