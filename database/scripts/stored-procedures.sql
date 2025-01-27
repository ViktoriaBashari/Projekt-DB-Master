USE Spitali;
GO

CREATE OR ALTER PROCEDURE SelektoTakimetPacientit
(
	@DataFillimit DATE,
	@DataPerfundimit DATE = NULL
)
AS
	SELECT 
		t.Id, t.DataKrijimit, t.DataTakimit, t.EshteAnulluar,
		t.DoktorId, t.InfermierId, t.SherbimId
	FROM Takim AS t
	INNER JOIN Pacient AS pacient ON t.PacientId = pacient.PersonId
	WHERE 
		pacient.NID = CURRENT_USER AND 
		t.DataTakimit >= @DataFillimit AND 
		(@DataPerfundimit IS NULL OR t.DataTakimit <= @DataPerfundimit)
	ORDER BY t.DataTakimit DESC;

GO

CREATE OR ALTER PROCEDURE SelektoFaturatPacientit
(
	@FiltroNgaPagesa BIT = NULL -- 0 per faturat e papaguara, 1 per faturat e paguara
	-- TODO shto parameter per kohen, merr sipas particionimit
)
AS
	SELECT fature.TakimId, fature.TakimId, takim.DataTakimit, sherb.Emri, fature.Cmimi, fature.DataPagimit, met_pag.Emertimi AS MetodaPagimit
	FROM Fature AS fature
	INNER JOIN Takim AS takim ON fature.TakimId = takim.Id
	INNER JOIN Pacient AS pacient ON takim.PacientId = pacient.PersonId
	INNER JOIN Sherbim AS sherb ON takim.SherbimId = sherb.Kodi
	INNER JOIN MetodePagimi AS met_pag ON fature.MetodaPagimitId = met_pag.Id
	WHERE 
		pacient.NID = CURRENT_USER AND 
		((@FiltroNgaPagesa = 1 AND fature.DataPagimit IS NOT NULL) OR
		(@FiltroNgaPagesa = 0 AND fature.DataPagimit IS NULL));

GO

CREATE OR ALTER PROCEDURE SelektoTakimetStafit
(
	@DataFillimit DATE,
	@DataPerfundimit DATE = NULL
)
AS
	SELECT t.*
	FROM Takim AS t
	INNER JOIN Staf AS doc ON t.DoktorId = doc.PersonId
	INNER JOIN Staf AS inf ON t.InfermierId = inf.PersonId
	WHERE 
		(doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER) AND 
		t.DataTakimit >= @DataFillimit AND 
		(@DataPerfundimit IS NULL OR t.DataTakimit <= @DataPerfundimit)
	ORDER BY t.DataTakimit DESC;

GO