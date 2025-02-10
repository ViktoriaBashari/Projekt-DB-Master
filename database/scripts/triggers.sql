USE Spitali;
GO

CREATE OR ALTER TRIGGER ValidoDrejtuesinDepartamentit
ON Departament
AFTER INSERT, UPDATE
AS BEGIN
	-- Siguro qe drejtuesi eshte doktor
	IF EXISTS (
		SELECT 1
		FROM INSERTED as i
		INNER JOIN Staf ON i.DrejtuesId = Staf.PersonId
		INNER JOIN RolStafi ON RolStafi.Id = Staf.RolId
		WHERE RolStafi.Emertimi = 'Infermier')
		BEGIN
			RAISERROR('Drejtuesit duhet te jene doktore', 16, -1);
			ROLLBACK TRANSACTION;
		END
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFamiljare
ON AnamnezaFamiljare
INSTEAD OF INSERT
AS BEGIN
	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
	BEGIN 
		IF EXISTS(
			SELECT 1
			FROM inserted AS i
			WHERE dbo.EshtePacientiNenKujdesinAnetaritStafit(i.PacientId, CURRENT_USER) = 0)
			THROW 401, 'Veprim i paautorizuar', 1;

		INSERT INTO AnamnezaFamiljare(PacientId, StafiPergjegjesId, LidhjaFamiljare, Datelindja, Semundja, MoshaDiagnozes, ShkakuVdekjes, DataVdekjes)
		SELECT i.PacientId, staf.PersonId, i.LidhjaFamiljare, i.Datelindja, i.Semundja, i.MoshaDiagnozes, i.ShkakuVdekjes, i.DataVdekjes
		FROM INSERTED i
		INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER;
	END
	ELSE
		INSERT INTO AnamnezaFamiljare(PacientId, StafiPergjegjesId, LidhjaFamiljare, Datelindja, Semundja, MoshaDiagnozes, ShkakuVdekjes, DataVdekjes)
		SELECT PacientId, StafiPergjegjesId, LidhjaFamiljare, Datelindja, Semundja, MoshaDiagnozes, ShkakuVdekjes, DataVdekjes
		FROM INSERTED;
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFiziologjike
ON AnamnezaFiziologjike
INSTEAD OF INSERT
AS BEGIN
	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
	BEGIN 
		IF EXISTS(
			SELECT 1
			FROM inserted AS i
			WHERE dbo.EshtePacientiNenKujdesinAnetaritStafit(i.PacientId, CURRENT_USER) = 0)
			THROW 401, 'Veprim i paautorizuar', 1;

		INSERT INTO AnamnezaFiziologjike(PacientId, StafiPergjegjesId, SistemiFrymemarrjes, SistemiGjenitourinar, SistemiTretes, SistemiOkular, SistemiNeurologjik, SistemiORL, SistemiKardiovaskular)
		SELECT i.PacientId, staf.PersonId, i.SistemiFrymemarrjes, i.SistemiGjenitourinar, i.SistemiTretes, i.SistemiOkular, i.SistemiNeurologjik, i.SistemiORL, i.SistemiKardiovaskular
		FROM INSERTED i
		INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER
	END
	ELSE
		INSERT INTO AnamnezaFiziologjike(PacientId, StafiPergjegjesId, SistemiFrymemarrjes, SistemiGjenitourinar, SistemiTretes, SistemiOkular, SistemiNeurologjik, SistemiORL, SistemiKardiovaskular)
		SELECT PacientId, StafiPergjegjesId, SistemiFrymemarrjes, SistemiGjenitourinar, SistemiTretes, SistemiOkular, SistemiNeurologjik, SistemiORL, SistemiKardiovaskular
		FROM INSERTED;
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeSemundjeje
ON AnamnezaSemundjes
INSTEAD OF INSERT
AS BEGIN
	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
	BEGIN 
		IF EXISTS(
			SELECT 1
			FROM inserted AS i
			WHERE dbo.EshtePacientiNenKujdesinAnetaritStafit(i.PacientId, CURRENT_USER) = 0)
			THROW 401, 'Veprim i paautorizuar', 1;

		INSERT INTO AnamnezaSemundjes(PacientId, StafiPergjegjesId, Semundja, DataDiagnozes, EshteKronike)
		SELECT i.PacientId, staf.PersonId, i.Semundja, i.DataDiagnozes, i.EshteKronike
		FROM INSERTED i
		INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER;
	END
	ELSE
		INSERT INTO AnamnezaSemundjes(PacientId, StafiPergjegjesId, Semundja, DataDiagnozes, EshteKronike)
		SELECT PacientId, StafiPergjegjesId, Semundja, DataDiagnozes, EshteKronike
		FROM INSERTED;
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeAbuzimi
ON AnamnezaAbuzimit
INSTEAD OF INSERT
AS BEGIN
	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
	BEGIN 
		IF EXISTS(
			SELECT 1
			FROM inserted AS i
			WHERE dbo.EshtePacientiNenKujdesinAnetaritStafit(i.PacientId, CURRENT_USER) = 0)
			THROW 401, 'Veprim i paautorizuar', 1;

		INSERT INTO AnamnezaAbuzimit(PacientId, StafiPergjegjesId, Substanca, Pershkrimi, DataFillimit, DataPerfundimit)
		SELECT i.PacientId, staf.PersonId, i.Substanca, i.Pershkrimi, i.DataFillimit, i.DataPerfundimit
		FROM INSERTED i
		INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER;
	END
	ELSE
		INSERT INTO AnamnezaAbuzimit(PacientId, StafiPergjegjesId, Substanca, Pershkrimi, DataFillimit, DataPerfundimit)
		SELECT PacientId, StafiPergjegjesId, Substanca, Pershkrimi, DataFillimit, DataPerfundimit
		FROM INSERTED;
END;

GO

CREATE OR ALTER TRIGGER ShtoAnamnezeFarmakologjike
ON AnamnezaFarmakologjike
INSTEAD OF INSERT
AS BEGIN
	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
	BEGIN 
		IF EXISTS(
			SELECT 1
			FROM inserted AS i
			WHERE dbo.EshtePacientiNenKujdesinAnetaritStafit(i.PacientId, CURRENT_USER) = 0)
			THROW 401, 'Veprim i paautorizuar', 1;

		INSERT INTO AnamnezaFarmakologjike(PacientId, StafiPergjegjesId, Ilaci, Doza, Arsyeja, DataFillimit, DataPerfundimit, MarrePaRecete)
		SELECT i.PacientId, staf.PersonId, i.Ilaci, i.Doza, i.Arsyeja, i.DataFillimit, i.DataPerfundimit, i.MarrePaRecete
		FROM INSERTED i
		INNER JOIN Staf AS staf ON staf.PunonjesId = CURRENT_USER;
	END
	ELSE
		INSERT INTO AnamnezaFarmakologjike(PacientId, StafiPergjegjesId, Ilaci, Doza, Arsyeja, DataFillimit, DataPerfundimit, MarrePaRecete)
		SELECT PacientId, StafiPergjegjesId, Ilaci, Doza, Arsyeja, DataFillimit, DataPerfundimit, MarrePaRecete
		FROM INSERTED;
END;

GO

CREATE OR ALTER TRIGGER ValidoShtiminTakimit
ON Takim
FOR INSERT
AS BEGIN
	IF EXISTS(
		SELECT 1 FROM INSERTED 
		WHERE CAST(DataTakimit AS DATE) < CAST(GETDATE() AS DATE))
		BEGIN
			RAISERROR('Nuk mund te krijohet nje takim ne te kaluaren', 16, -1);
			ROLLBACK TRANSACTION;
		END

	DECLARE @takimet UpsertedTakimType;
	
	INSERT INTO @takimet
	SELECT DoktorId, InfermierId, DataTakimit FROM INSERTED;

	IF dbo.JaneTakimetBrendaOrarit(@takimet) = 0
		BEGIN
			RAISERROR('Nuk mund te krijohet nje takim jashte orarit te doktorit dhe/ose infermierit perkates', 16, -1);
			ROLLBACK TRANSACTION;
		END

	IF dbo.ShkaktojneKonfliktOrariTakimet(@takimet) = 1
		BEGIN
			RAISERROR('Ekzistojne takime per kete afat kohor per doktorin dhe/ose infermierin perkates', 16, -1);
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
			IF EXISTS(SELECT 1 FROM DELETED WHERE DataTakimit < GETDATE())
				BEGIN
					RAISERROR('Nuk lejohet perditesimi i takimit pas ores se takimit', 16, -1);
					ROLLBACK TRANSACTION;
				END

			IF UPDATE(DataTakimit)
				BEGIN
					DECLARE @takimet UpsertedTakimType;
					
					INSERT INTO @takimet 
					SELECT DoktorId, InfermierId, DataTakimit FROM INSERTED;

					IF dbo.JaneTakimetBrendaOrarit(@takimet) = 0
						BEGIN
							RAISERROR('Nuk mund te krijohet nje takim jashte orarit te doktorit dhe/ose infermierit perkates', 16, -1);
							ROLLBACK TRANSACTION;
						END

					IF dbo.ShkaktojneKonfliktOrariTakimet(@takimet) = 1
						BEGIN
							RAISERROR('Ekzistojne takime per kete afat kohor per doktorin dhe/ose infermierin perkates', 16, -1);
							ROLLBACK TRANSACTION;
						END
				END
		END

	IF IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 OR IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1
		BEGIN
			DECLARE @PersonIdAktual VARCHAR(MAX);

			SELECT @PersonIdAktual = PersonId
			FROM Staf
			WHERE PunonjesId = CURRENT_USER;

			IF EXISTS(SELECT 1 FROM DELETED WHERE DoktorId != @PersonIdAktual OR InfermierId != @PersonIdAktual)
				BEGIN
					RAISERROR('Veprim i paautorizuar', 16, -1);
					ROLLBACK TRANSACTION;
				END

			IF EXISTS(SELECT 1 FROM DELETED WHERE EshteAnulluar = 1)
				BEGIN
					RAISERROR('Nuk mund te perditesohet nje takim i anulluar', 16, -1);
					ROLLBACK TRANSACTION;
				END
 
			IF
				UPDATE(ShqetesimiKryesor) OR
				UPDATE(KohezgjatjaShqetesimit) OR
				UPDATE(SimptomaTeLidhura) OR
				UPDATE(Konkluzioni)
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
	IF 
    (UPDATE(DataPagimit) OR UPDATE(MetodaPagimitId)) AND
    EXISTS(SELECT 1 FROM DELETED WHERE DataPagimit IS NOT NULL OR MetodaPagimitId IS NOT NULL)
		BEGIN
			RAISERROR('Nuk mund te ndryshohen data dhe metoda e pagimit pasi jane populluar', 16, -1);
			ROLLBACK TRANSACTION;
		END

	IF EXISTS(SELECT 1 FROM INSERTED WHERE DataPagimit IS NULL OR MetodaPagimitId IS NULL)
		BEGIN
			RAISERROR('Data dhe metoda e pagimit duhen populluar', 16, -1);
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
			IF UPDATE(EshteAnulluar)
				BEGIN
					DELETE f FROM Fature AS f
					INNER JOIN INSERTED AS i ON i.Id = f.TakimId
					WHERE i.EshteAnulluar = 1;
          
					RETURN;
				END
		END
	ELSE
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
	DECLARE @NID varchar(MAX);

	DECLARE nid_cursor CURSOR FOR
		SELECT NID FROM INSERTED;

	OPEN nid_cursor
	FETCH NEXT FROM nid_cursor INTO @NID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @loginCommand VARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@NID) + ' WITH PASSWORD = ' + QUOTENAME(NEWID(), ''''),
			@userCommand VARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@NID) + ' FOR LOGIN ' + QUOTENAME(@NID),
			@roleCommand VARCHAR(MAX) = 'ALTER ROLE Pacient ADD MEMBER ' + QUOTENAME(@NID);

		EXEC(@loginCommand);
		EXEC(@userCommand);
		EXEC(@roleCommand);

		FETCH NEXT FROM nid_cursor INTO @NID
	END

	CLOSE nid_cursor;
	DEALLOCATE nid_cursor;
END;

GO

CREATE OR ALTER TRIGGER ShtoUserPasRegjistrimStafi
ON Staf
AFTER INSERT
AS BEGIN
	DECLARE @punonjesId VARCHAR(MAX), @roli VARCHAR(MAX);

	DECLARE pid_cursor CURSOR FOR
		SELECT PunonjesId, Emertimi
		FROM INSERTED
		INNER JOIN RolStafi ON RolStafi.Id = RolId;

	OPEN pid_cursor
	FETCH NEXT FROM pid_cursor INTO @punonjesId, @roli
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @loginCommand VARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@punonjesId) + ' WITH PASSWORD = ' + QUOTENAME(NEWID(), ''''),
				@userCommand VARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@punonjesId) + ' FOR LOGIN ' + QUOTENAME(@punonjesId),
				@roleCommand VARCHAR(MAX) = 'ALTER ROLE ' + QUOTENAME(@roli) + ' ADD MEMBER ' + QUOTENAME(@punonjesId);

		EXEC(@loginCommand);
		EXEC(@userCommand);
		EXEC(@roleCommand);
		
		FETCH NEXT FROM pid_cursor INTO @punonjesId, @roli
	END

	CLOSE pid_cursor;
	DEALLOCATE pid_cursor;
END;

GO

CREATE OR ALTER TRIGGER FshiUserPasFshirjesStafit
ON Staf
AFTER DELETE
AS BEGIN
	DECLARE @punonjesId VARCHAR(MAX);

	DECLARE pid_cursor CURSOR FOR
		SELECT PunonjesId
		FROM INSERTED;

	OPEN pid_cursor
	FETCH NEXT FROM pid_cursor INTO @punonjesId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @loginCommand VARCHAR(MAX) = 'DROP LOGIN ' + QUOTENAME(@punonjesId),
				@userCommand VARCHAR(MAX) = 'DROP USER ' + QUOTENAME(@punonjesId);

		EXEC(@loginCommand);
		EXEC(@userCommand);
	END

	CLOSE pid_cursor;
	DEALLOCATE pid_cursor;
END;

GO