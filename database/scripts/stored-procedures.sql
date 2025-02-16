USE Spitali;
GO

CREATE OR ALTER PROCEDURE GjeneroFluksinRegjistrimeveTePacienteve
(
	@VitiFillimtar INT = NULL,
	@VitiPerfundimtar INT = NULL,
	@DistributimMujor BIT -- Shto ndarje mujore ne raport
)
AS BEGIN
	SET NOCOUNT ON;

	SELECT 
		DATEPART(YEAR, DataRegjistrimit) AS Viti, 
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, DataRegjistrimit) END AS Muaji,
		COUNT(PersonId) AS NrPacienteve
	FROM Pacient
	WHERE 
		(@VitiFillimtar IS NULL OR DATEPART(YEAR, DataRegjistrimit) >= @VitiFillimtar) AND
		(@VitiPerfundimtar IS NULL OR DATEPART(YEAR, DataRegjistrimit) <= @VitiPerfundimtar)
	GROUP BY 
		DATEPART(YEAR, DataRegjistrimit), 
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, DataRegjistrimit) END;
END;

GO

CREATE OR ALTER PROCEDURE GjeneroSherbimetMeTePerdorura
(
	@DistributimMujor BIT, -- Shto ndarje mujore ne raport
	@VitiPerkates INT = NULL
)
AS BEGIN
	SET NOCOUNT ON;

	SELECT 
		TOP 15
		DATEPART(YEAR, Takim.DataTakimit) AS Viti,
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, Takim.DataTakimit) END AS Muaji,
		sherb.Kodi, sherb.Emri, 
		COUNT(Takim.Id) AS NrTakimeve
	FROM Sherbim AS sherb
	INNER JOIN Takim ON Takim.SherbimId = sherb.Kodi
	WHERE
		Takim.EshteAnulluar = 0 AND 
		(@VitiPerkates IS NULL OR DATEPART(YEAR, Takim.DataTakimit) = @VitiPerkates)
	GROUP BY 
		sherb.Kodi,
		sherb.Emri,
		DATEPART(YEAR, Takim.DataTakimit),
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, Takim.DataTakimit) END
	ORDER BY COUNT(Takim.Id) DESC;
END;

GO

CREATE OR ALTER PROCEDURE GjeneroStafinMeTePerdorur
(
	@RolId INT,
	@VitiPerkates INT = NULL
)
AS BEGIN 
	SET NOCOUNT ON;
	SELECT 
		TOP 15
		person.Id, person.Emri, person.Mbiemri, COUNT(takim.Id) AS NrTakimeve
	FROM Takim
	INNER JOIN Staf ON Staf.PersonId = Takim.DoktorId OR Staf.PersonId = Takim.InfermierId
	INNER JOIN Person ON Person.Id = Staf.PersonId
	WHERE 
		takim.EshteAnulluar = 0 AND 
		(@VitiPerkates IS NULL OR DATEPART(YEAR, takim.DataTakimit) = @VitiPerkates) AND
		staf.RolId = @RolId
	GROUP BY person.Id, person.Emri, person.Mbiemri
	ORDER BY COUNT(takim.Id) DESC;
END;

GO

CREATE OR ALTER PROCEDURE GjeneroPacientetMeTeShpeshte
(
	@VitiPerkates INT,
	@MuajiPerkates INT = NULL
)
AS BEGIN
	SET NOCOUNT ON;
	SELECT 
		TOP 15
		person.Id, person.Emri, person.Mbiemri, COUNT(takim.Id) AS NrTakimeve
	FROM Pacient AS pacient
	INNER JOIN Person AS person ON pacient.PersonId = person.Id
	INNER JOIN Takim AS takim ON takim.PacientId = pacient.PersonId
	WHERE 
		takim.EshteAnulluar = 0 AND
		DATEPART(YEAR, takim.DataTakimit) = @VitiPerkates AND
		(@MuajiPerkates IS NULL OR DATEPART(MONTH, takim.DataTakimit) = @MuajiPerkates)
	GROUP BY person.Id, person.Emri, person.Mbiemri
	ORDER BY COUNT(takim.Id) DESC;
END;

GO

CREATE OR ALTER PROCEDURE SelektoTakimetPacientit
(
	@DataFillimit DATE,
	@DataPerfundimit DATE = NULL,
	@PacientId INT = NULL
)
AS BEGIN
	SET NOCOUNT ON;

	IF IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1
	BEGIN
		IF @PacientId IS NULL
			RAISERROR('Specifikoni nje klient', 16, -1);
	END;

	SELECT 
		Takim.Id, DataKrijimit, DataTakimit, EshteAnulluar,
		DoktorId, doc.Emri, doc.Mbiemri, 
		SherbimId, Sherbim.Emri
	FROM Takim 
	INNER JOIN Pacient ON PacientId = Pacient.PersonId
	INNER JOIN Staf ON Staf.PersonId = DoktorId
	INNER JOIN Person AS doc ON doc.Id = Staf.PersonId
	INNER JOIN Sherbim ON Takim.SherbimId = Sherbim.Kodi
	WHERE 
		(
			(IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1 AND Pacient.PersonId = @PacientId) OR
			pacient.NID = CURRENT_USER
		) AND 
		DataTakimit >= @DataFillimit AND 
		(@DataPerfundimit IS NULL OR DataTakimit <= @DataPerfundimit)
	ORDER BY DataTakimit DESC;
END;

GO

CREATE OR ALTER PROCEDURE SelektoFaturatPacientit
(
	@FiltroNgaPagesa BIT = NULL, -- 0 per faturat e papaguara, 1 per faturat e paguara
	@PacientId INT = NULL
	-- TODO shto parameter per kohen, merr sipas particionimit
)
AS BEGIN
	SET NOCOUNT ON;

	IF IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1
	BEGIN
		IF @PacientId IS NULL
			RAISERROR('Specifikoni nje klient', 16, -1);
	END;

	SELECT 
		fature.TakimId, takim.DataTakimit, 
		Sherbim.Kodi, Sherbim.Emri AS Sherbim_Emri, 
		fature.Cmimi, fature.DataPagimit, 
		met_pag.Emertimi AS MetodaPagimit
	FROM Fature AS fature
	INNER JOIN Takim AS takim ON fature.TakimId = takim.Id
	INNER JOIN Pacient AS pacient ON takim.PacientId = pacient.PersonId
	INNER JOIN Sherbim ON takim.SherbimId = Sherbim.Kodi
	INNER JOIN MetodePagimi AS met_pag ON fature.MetodaPagimitId = met_pag.Id
	WHERE 
		(
			(IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1 AND Pacient.PersonId = @PacientId) OR
			pacient.NID = CURRENT_USER
		) AND
		(
			@FiltroNgaPagesa IS NULL OR
			(@FiltroNgaPagesa = 1 AND fature.DataPagimit IS NOT NULL) OR
			(@FiltroNgaPagesa = 0 AND fature.DataPagimit IS NULL)
		);
END;

GO

CREATE OR ALTER PROCEDURE SelektoTakimetStafit
(
	@DataFillimit DATE,
	@DataPerfundimit DATE = NULL,
	@StafId INT = NULL
)
AS BEGIN
	SET NOCOUNT ON;
	
	IF IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1
		BEGIN
			IF @StafId IS NULL
				RAISERROR('Specifikoni nje anetar stafi', 16, -1);

			SELECT 
				Takim.Id, DataKrijimit, DataTakimit, 
				DoktorId, doc_p.Emri AS Doktor_Emri, doc_p.Mbiemri AS Doktor_Mbiemri,
				InfermierId, inf_p.Emri AS Infermier_Emri, inf_p.Mbiemri AS Infermier_Mbiemri 
			FROM Takim
			INNER JOIN Staf AS doc ON DoktorId = doc.PersonId
				INNER JOIN Person AS doc_p ON doc_p.Id = doc.PersonId
			INNER JOIN Staf AS inf ON InfermierId = inf.PersonId
				INNER JOIN Person AS inf_p ON inf_p.Id = inf.PersonId
			WHERE 
				DataTakimit >= @DataFillimit AND 
				(@DataPerfundimit IS NULL OR DataTakimit <= @DataPerfundimit)
			ORDER BY DataTakimit DESC;
		END;
	ELSE
		SELECT 
			Takim.Id, DataKrijimit, DataTakimit, 
			ShqetesimiKryesor, KohezgjatjaShqetesimit, SimptomaTeLidhura, Konkluzioni
			DoktorId, doc_p.Emri AS Doktor_Emri, doc_p.Mbiemri AS Doktor_Mbiemri,
			InfermierId, inf_p.Emri AS Infermier_Emri, inf_p.Mbiemri AS Infermier_Mbiemri,
			PacientId, pacient.Emri AS Pacient_Emri, pacient.Mbiemri AS Pacient_Mbiemri,
			SherbimId, Sherbim.Emri
		FROM Takim
		INNER JOIN Staf AS doc ON DoktorId = doc.PersonId
			INNER JOIN Person AS doc_p ON doc_p.Id = doc.PersonId
		INNER JOIN Staf AS inf ON InfermierId = inf.PersonId
			INNER JOIN Person AS inf_p ON inf_p.Id = inf.PersonId
		INNER JOIN Person AS pacient ON pacient.Id = PacientId
		INNER JOIN Sherbim ON SherbimId = Sherbim.Kodi
		WHERE
			(doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER) AND 
			DataTakimit >= @DataFillimit AND 
			(@DataPerfundimit IS NULL OR DataTakimit <= @DataPerfundimit)
		ORDER BY DataTakimit DESC;
END;

GO

CREATE OR ALTER PROCEDURE FshiDepartament
(
	@DepartamentIdPerFshirje INT,
	@DepartamentIdZevendesues INT
)
AS BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION FshiDepartamentTrans
		BEGIN TRY
			UPDATE Staf 
			SET DepartamentId = @DepartamentIdZevendesues 
			WHERE DepartamentId = @DepartamentIdPerFshirje;
			
			DELETE FROM Departament WHERE Id = @DepartamentIdPerFshirje;

			COMMIT TRANSACTION FshiDepartamentTrans;
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION FshiDepartamentTrans;
		END CATCH
END;

GO

-- Per te krijuar administratore dhe recepsioniste
CREATE OR ALTER PROCEDURE ShtoStafAdministratues
(
	@Username VARCHAR(MAX),
	@Password VARCHAR(MAX),
	@Roli VARCHAR(MAX)
)
AS BEGIN
	SET NOCOUNT ON;

	IF @Roli NOT IN ('Administrator', 'Recepsionist')
		RAISERROR('Specifiko rolin e perdoruesit te ri (Administrator, ose recepsionist)', 16, -1);

	DECLARE @loginCommand VARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@Username) + ' WITH PASSWORD = ' + QUOTENAME(@Password, ''''),
		@userCommand VARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@Username) + ' FOR LOGIN ' + QUOTENAME(@Username),
		@roleCommand VARCHAR(MAX) = 'ALTER ROLE ' + @Roli + ' ADD MEMBER ' + QUOTENAME(@Username);

	BEGIN TRANSACTION ShtoPerdoruesAdminTrans
		BEGIN TRY
			EXECUTE(@loginCommand);
			EXECUTE(@userCommand);
			EXECUTE(@roleCommand);
			COMMIT TRANSACTION ShtoPerdoruesAdminTrans;
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION ShtoPerdoruesAdminTrans;
		END CATCH
END;

GO

CREATE OR ALTER PROCEDURE FshiStafAdministratues
(
	@Username VARCHAR(MAX)
)
AS BEGIN
	SET NOCOUNT ON;

	-- Kontrollo per ekzistencen e perdoruesit per tu fshire
	IF NOT EXISTS(
		SELECT 1
		FROM sys.sql_logins
		WHERE name = @Username)
		RAISERROR('Perdoruesi nuk ekziston', 16, -1);

	-- Kontrollo rolin e perdoruesit te zgjedhur per fshirje
	IF IS_ROLEMEMBER('Administrator', @Username) != 1 OR IS_ROLEMEMBER('Recepsionist', @Username) != 1
		RAISERROR('Perdoruesi nuk ekziston', 16, -1);

	DECLARE @loginCommand VARCHAR(MAX) = 'DROP LOGIN ' + QUOTENAME(@Username),
		@userCommand VARCHAR(MAX) = 'DROP USER ' + QUOTENAME(@Username);

	BEGIN TRANSACTION FshiPerdoruesAdminTrans
		BEGIN TRY
			EXECUTE(@userCommand);
			EXECUTE(@loginCommand);
			COMMIT TRANSACTION FshiPerdoruesAdminTrans;
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION FshiPerdoruesAdminTrans;
		END CATCH
END;

GO