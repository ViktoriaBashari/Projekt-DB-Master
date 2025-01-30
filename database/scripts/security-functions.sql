USE Spitali;
GO

CREATE SCHEMA Security;
GO


CREATE OR ALTER FUNCTION Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN 
	SELECT 1 as SecurityPredicateResult
	FROM dbo.Takim
	INNER JOIN dbo.Staf AS doc ON DoktorId = doc.PersonId
	INNER JOIN dbo.Staf AS inf ON InfermierId = inf.PersonId
	WHERE 
		(doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER) AND 
		takim.EshteAnulluar = 0;

GO

CREATE SECURITY POLICY FilterPerPacientetTeStafitPerkates
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.PacientetNenKujdesinAnetaritStafit,
	-- Anamneza e pacienteve
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.AnamnezaFarmakologjike,
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.AnamnezaAbuzimit,
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.AnamnezaSemundjes,
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.AnamnezaFiziologjike,
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
	ON dbo.AnamnezaFamiljare
WITH (STATE = ON);

GO


CREATE OR ALTER FUNCTION Security.fn_SecurityPredicate_Faturat()
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
	SELECT 
		CASE WHEN IS_ROLEMEMBER('Receptionist', CURRENT_USER) = 1 THEN
			(SELECT 1)
		ELSE
			(SELECT 1 FROM dbo.Takim
			INNER JOIN dbo.Pacient ON PacientId = PersonId
			WHERE NID = CURRENT_USER)
		END AS SecurityPredicateResult;

GO

CREATE SECURITY POLICY FilterPerFaturat
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_Faturat()
	ON dbo.Fature
WITH (STATE = ON);

GO


CREATE OR ALTER FUNCTION Security.fn_SecurityPredicate_Takimet()
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
	SELECT 
		CASE WHEN IS_ROLEMEMBER('Receptionist', CURRENT_USER) = 1 THEN
			(SELECT 1)
		WHEN IS_ROLEMEMBER('Pacient', CURRENT_USER) = 1 THEN
			(SELECT 1 AS SecurityPredicateResult
			FROM dbo.Takim
			INNER JOIN dbo.Pacient ON PacientId = Pacient.PersonId
			WHERE Pacient.NID = CURRENT_USER)
		ELSE
			(SELECT 1 AS SecurityPredicateResult
			FROM dbo.Takim
			INNER JOIN dbo.Staf AS doc ON DoktorId = doc.PersonId
			INNER JOIN dbo.Staf AS inf ON InfermierId = inf.PersonId
			WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER)
		END AS SecurityPredicateResult;

GO

CREATE SECURITY POLICY FilterPerTakimet
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_Takimet()
	ON dbo.Takim
WITH (STATE = ON);

GO