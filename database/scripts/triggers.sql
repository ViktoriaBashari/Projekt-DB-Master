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

CREATE OR ALTER TRIGGER ValidoShtiminFatures
ON Fature
FOR INSERT
AS BEGIN
	IF (SELECT DataPagimit FROM INSERTED) IS NULL OR (SELECT MetodaPagimitId FROM INSERTED) IS NULL
		BEGIN
			RAISERROR('Data dhe metoda e pagimit duhen suportuar', 16, -1);
			ROLLBACK TRANSACTION;
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
		END

	IF (SELECT DataPagimit FROM INSERTED) IS NULL OR (SELECT MetodaPagimitId FROM INSERTED) IS NULL
		BEGIN
			RAISERROR('Data dhe metoda e pagimit duhen suportuar', 16, -1);
		END
END;

GO

CREATE OR ALTER TRIGGER ShtoUserPasRegjistrimPacienti
ON Pacient
AFTER INSERT
AS BEGIN
	EXEC('CREATE OR ALTER LOGIN [NID]')
	EXEC('CREATE OR ALTER USER [NID]')
	EXEC('ALTER ROLE Pacient ADD MEMBER [NID]')
	SELECT i.NID
	FROM INSERTED AS i
END;

GO

CREATE OR ALTER TRIGGER ShtoUserPasRegjistrimStaf
ON Staf
AFTER INSERT
AS BEGIN
	EXEC('CREATE OR ALTER LOGIN [PunonjesId]')
	EXEC('CREATE OR ALTER USER [PunonjesId]')
	EXEC('ALTER ROLE Pacient ADD MEMBER [PunonjesId]')
	SELECT i.PunonjesId
	FROM INSERTED AS i
END;

GO

CREATE OR ALTER TRIGGER ShtoFaturePerTakim
ON Takim
AFTER INSERT, UPDATE
AS BEGIN
	-- Nese eshte perditesuar
	IF EXISTS(SELECT * FROM DELETED)
		BEGIN
			IF UPDATE(EshteAnulluar)
				BEGIN
					-- Fshije faturen e takimit nese eshte anulluar
					IF (SELECT EshteAnulluar FROM INSERTED) = 1
						DELETE FROM Fature WHERE TakimId = (SELECT Id FROM INSERTED);
					-- Shtoje faturen e takimit nese eshte hequr anullimi
					ELSE
						INSERT INTO Fature(TakimId, Cmimi)
						SELECT i.Id, sherbim.Cmimi
						FROM inserted as i
						INNER JOIN Sherbim AS sherbim ON i.SherbimId = sherbim.Kodi;
				END
		END
	ELSE
		INSERT INTO Fature (TakimId, Cmimi)
		SELECT i.Id, sherbim.Cmimi
		FROM INSERTED AS i
		INNER JOIN Sherbim AS sherbim ON i.SherbimId = sherbim.Kodi;
END;

GO