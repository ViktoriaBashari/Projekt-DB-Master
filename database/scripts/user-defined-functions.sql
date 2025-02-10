USE Spitali;
GO

CREATE OR ALTER FUNCTION EshtePacientiNenKujdesinAnetaritStafit
(
	@PacientId INT, 
	@StafPunonjesId CHAR(5)
)
RETURNS BIT
AS BEGIN
	IF EXISTS (
		SELECT 1 
		FROM Takim AS takim
		INNER JOIN Staf AS doc ON takim.DoktorId = doc.PersonId
		INNER JOIN Staf AS inf ON takim.InfermierId = inf.PersonId
		WHERE 
			takim.EshteAnulluar = 0 AND 
			takim.PacientId = @PacientId AND 
			(doc.PunonjesId = @StafPunonjesId OR inf.PunonjesId = @StafPunonjesId))
		RETURN 1;
	
	RETURN 0;
END;

GO

CREATE TYPE UpsertedTakimType AS TABLE(DoktorId INT NOT NULL, InfermierId INT NULL, DataTakimit DATETIME);
GO

CREATE OR ALTER FUNCTION JaneTakimetBrendaOrarit(@Takimet UpsertedTakimType READONLY) 
RETURNS BIT
AS BEGIN
	-- Kontrollo nese takimet jane brenda orarit te doktorit
	IF EXISTS(
		SELECT *
		FROM @Takimet AS i
		INNER JOIN OrariPloteStafit as orari on 
			orari.StafId = i.DoktorId AND
			(
				(CAST(i.DataTakimit AS TIME) not between orari.OraFilluese and orari.OraPerfundimtare) or
				DitaId != DATEPART(dw, i.DataTakimit)
			))
		RETURN 0;

	-- Kontrollo nese takimet jane brenda orarit te infermierit
	IF EXISTS(
		SELECT 1
		FROM @Takimet AS i
		INNER JOIN OrariPloteStafit as orari on 
			orari.StafId = i.InfermierId AND
			(
				(CAST(i.DataTakimit AS TIME) not between orari.OraFilluese and orari.OraPerfundimtare) or
				DitaId != DATEPART(dw, i.DataTakimit)
			))
		RETURN 0;

	RETURN 1;
END;

GO

CREATE OR ALTER FUNCTION ShkaktojneKonfliktOrariTakimet(@Takimet UpsertedTakimType READONLY) 
RETURNS BIT
AS BEGIN
	-- Kontrollo nese takimi bie ne konflikt me takime te tjera ne orarin e doktorit
	IF EXISTS(
		SELECT *
		FROM @Takimet AS i
		INNER JOIN Takim ON i.DoktorId = Takim.DoktorId
		WHERE i.DataTakimit BETWEEN i.DataTakimit AND DATEADD(MINUTE, 90, i.DataTakimit)
		GROUP BY i.DoktorId
		HAVING COUNT(*) > 1)
		RETURN 1;

	-- Kontrollo nese takimi bie ne konflikt me takime te tjera ne orarin e doktorit
	IF EXISTS(
		SELECT 1
		FROM @Takimet AS i
		INNER JOIN Takim ON i.InfermierId = Takim.InfermierId
		WHERE i.DataTakimit BETWEEN i.DataTakimit AND DATEADD(MINUTE, 90, i.DataTakimit)
		GROUP BY i.InfermierId
		HAVING COUNT(*) > 1)
		RETURN 1;

	RETURN 0;
END;

GO

CREATE OR ALTER FUNCTION MerrOrarinStafitPerkates(@StafPersonId INT)
RETURNS TABLE
AS RETURN
	SELECT OraFilluese, OraPerfundimtare, Dita
	FROM OrariPloteStafit
	WHERE StafId  = @StafPersonId;

GO

CREATE OR ALTER FUNCTION KalkuloShumenPapaguarNgaPacienti()
RETURNS DECIMAL
AS
BEGIN
	DECLARE @vleraTotale DECIMAL

	SELECT @vleraTotale = SUM(fature.Cmimi)
	FROM Fature AS fature
	INNER JOIN Takim AS takim ON fature.TakimId = takim.Id
	INNER JOIN Pacient AS pacient ON takim.PacientId = pacient.PersonId
	-- Selekto gjithe faturet jo te anulluara te papaguara te pacientit
	WHERE takim.EshteAnulluar = 0 AND pacient.NID = CURRENT_USER AND fature.DataPagimit IS NULL

	RETURN @vleraTotale
END;

GO

CREATE OR ALTER FUNCTION GjeneroRaportinStafKerkese()
RETURNS DECIMAL
AS BEGIN
	DECLARE @nrStafit INT, @nrPacienteve INT;

	SELECT @nrPacienteve = COUNT(PersonId)
	FROM Pacient;

	IF @nrPacienteve = 0
		RETURN 0;

	SELECT @nrStafit = COUNT(PersonId)
	FROM Staf;

	RETURN @nrStafit / @nrPacienteve;
END;

GO

CREATE OR ALTER FUNCTION KalkuloNormenMesatareTePritjesPerTakim()
RETURNS DECIMAL
AS BEGIN
	DECLARE @nrPacienteve INT, @kohaTotalePritjes INT;
	
	SELECT @nrPacienteve = COUNT(PersonId)
	FROM Pacient;

	IF @nrPacienteve = 0
		RETURN 0;

	SELECT @kohaTotalePritjes = SUM(DATEDIFF(MINUTE, DataKrijimit, DataTakimit))
	FROM Takim;

	RETURN @kohaTotalePritjes / @nrPacienteve;
END;

GO

CREATE OR ALTER FUNCTION KalkuloPerqindjenTakimeveAnulluara
(
	@DataFillimtare DATE = NULL,
	@DataPerfundimtare DATE = NULL
)
RETURNS DECIMAL
AS BEGIN
	IF @DataFillimtare > @DataPerfundimtare
		RETURN CAST('Data fillimtare duhet te jete me e vogel se ajo perfundimtare' AS INT);
	
	DECLARE @nrTotalTakimeve INT, @nrTakimeveAnulluara INT;

	SELECT @nrTotalTakimeve = COUNT(Id)
	FROM Takim
	WHERE 
		(@DataFillimtare IS NULL OR DataTakimit >= @DataFillimtare) AND
		(@DataPerfundimtare IS NULL OR DataTakimit <= @DataPerfundimtare);

	IF @nrTotalTakimeve = 0
		RETURN 0;

	SELECT @nrTakimeveAnulluara = COUNT(Id)
	FROM Takim
	WHERE 
		EshteAnulluar = 1 AND
		(@DataFillimtare IS NULL OR DataTakimit >= @DataFillimtare) AND
		(@DataPerfundimtare IS NULL OR DataTakimit <= @DataPerfundimtare);

	RETURN @nrTakimeveAnulluara / @nrTotalTakimeve;
END;

GO


CREATE OR ALTER FUNCTION GjeneroShpenzimetVjetore(@VitiPerkates INT)
RETURNS DECIMAL
AS BEGIN
	DECLARE @total DECIMAL;

	SELECT @total = SUM(Rroga)
	FROM Staf;

	IF @VitiPerkates < YEAR(GETDATE())
		RETURN @total * 12;
	
	RETURN @total * MONTH(GETDATE());
END;

GO

CREATE OR ALTER FUNCTION GjeneroRaportFitimesh
(
	@VitiFillimtar INT = NULL,
	@VitiPerfundimtar INT = NULL,
	@DistributimMujor BIT -- Shto ndarje mujore ne raport
)
RETURNS TABLE
AS RETURN
	SELECT 
		DATEPART(YEAR, DataPagimit) AS Viti,
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, DataPagimit) END AS Muaji,
		SUM(Cmimi) AS FitimeFature 
	FROM Fature
	WHERE 
		DataPagimit IS NOT NULL AND
		(@VitiFillimtar IS NULL OR DATEPART(YEAR, DataPagimit) >= @VitiFillimtar) AND
		(@VitiPerfundimtar IS NULL OR DATEPART(YEAR, DataPagimit) <= @VitiPerfundimtar)
	GROUP BY 
		DATEPART(YEAR, DataPagimit),
		CASE WHEN @DistributimMujor = 1 THEN DATEPART(MONTH, DataPagimit) END;

GO

CREATE OR ALTER FUNCTION GjeneroOperatingMarginVjetor(@VitiPerkates INT)
RETURNS DECIMAL
AS BEGIN
	DECLARE 
		@fitimet DECIMAL,
		@shpenzimet DECIMAL = dbo.GjeneroShpenzimetVjetore(@VitiPerkates);

	SELECT @fitimet = FitimeFature
	FROM GjeneroRaportFitimesh(@VitiPerkates, @VitiPerkates, 0);

	RETURN IIF(@fitimet = 0, 0, (@fitimet - @shpenzimet) / @fitimet);
END;

GO

CREATE OR ALTER FUNCTION KalkuloTarifenMesatareVjetoreTeTrajtimit
(
	@VitiFillimtar INT = NULL,
	@VitiPerfundimtar INT = NULL
)
RETURNS DECIMAL
AS BEGIN
	DECLARE @fitimetSherbimeve DECIMAL, @nrTrajtimeve INT;

	SELECT @nrTrajtimeve = COUNT(Id)
	FROM Takim
	WHERE 
		EshteAnulluar = 0 AND
		DataTakimit < GETDATE() AND
		(@VitiFillimtar IS NULL OR DATEPART(YEAR, DataTakimit) >= @VitiFillimtar) AND
		(@VitiPerfundimtar IS NULL OR DATEPART(YEAR, DataTakimit) <= @VitiPerfundimtar);

	IF @nrTrajtimeve = 0
		RETURN 0;

	SELECT @fitimetSherbimeve = FitimeFature
	FROM GjeneroRaportFitimesh(@VitiFillimtar, @VitiPerfundimtar, 0);

	RETURN @fitimetSherbimeve / @nrTrajtimeve;
END;

GO

CREATE OR ALTER FUNCTION KalkuloTarifenMesatareMujoreTeTrajtimit
(
	@VitiFillimtar INT = NULL,
	@VitiPerfundimtar INT = NULL
)
RETURNS @rezultati TABLE(Viti INT, Muaji INT, TarifaMesatareTrajtimit DECIMAL)
AS BEGIN
	DECLARE @tabelaAgregatesMujoreTeTakimeve TABLE(Viti INT, Muaji INT, NrTakimeve INT);
	DECLARE @tabelaFitimeveMujoreNgaSherbimet TABLE(Viti INT, Muaji INT, FitimeFature DECIMAL);

	INSERT INTO @tabelaAgregatesMujoreTeTakimeve
	SELECT
		DATEPART(YEAR, DataTakimit) AS Viti, 
		DATEPART(MONTH, DataTakimit) AS Muaji,
		COUNT(Id) AS NrTakimeve
	FROM Takim
	WHERE EshteAnulluar = 0 AND DataTakimit < GETDATE()
	GROUP BY DATEPART(YEAR, DataTakimit), DATEPART(MONTH, DataTakimit);

	INSERT INTO @tabelaFitimeveMujoreNgaSherbimet 
	SELECT * FROM GjeneroRaportFitimesh(@VitiFillimtar, @VitiPerfundimtar, 1);

	INSERT INTO @rezultati 
	SELECT 
		nrTakimeve.Viti, nrTakimeve.Muaji, 
		IIF(NrTakimeve = 0, 0, FitimeFature / NrTakimeve) AS TarifaMesatareTrajtimit
	FROM @tabelaAgregatesMujoreTeTakimeve AS nrTakimeve
	INNER JOIN @tabelaFitimeveMujoreNgaSherbimet AS fitimet ON nrTakimeve.Viti = fitimet.Viti AND nrTakimeve.Muaji = fitimet.Muaji;

	RETURN;
END;

GO

-- Funksione specifike per aplikacionin

CREATE OR ALTER FUNCTION VerifikoFjalekaliminPerdoruesit(@Username VARCHAR(MAX), @Fjalekalimi VARCHAR(MAX))
RETURNS BIT
AS BEGIN
	RETURN IIF(
		EXISTS(SELECT *
			FROM sys.sql_logins AS logins
			WHERE logins.name = @Username AND PWDCOMPARE(@Fjalekalimi, logins.password_hash) = 1),
		1, 0);
END;

GO

CREATE OR ALTER FUNCTION MerrRolinPerdoruesit(@Username VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS BEGIN
	DECLARE @roli VARCHAR(MAX);

	SELECT @roli = r.name
	FROM sys.database_role_members rm
	JOIN sys.database_principals r 
       ON rm.role_principal_id = r.principal_id
	  JOIN sys.database_principals m 
		   ON rm.member_principal_id = m.principal_id
	 WHERE r.type = 'R' AND m.name = @Username;

	 RETURN @roli;
END;

GO