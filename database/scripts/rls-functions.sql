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
		CASE WHEN IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1 THEN
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
	SELECT 1 AS SecurityPredicateResult
	FROM dbo.Takim AS t
	INNER JOIN dbo.Pacient ON t.PacientId = Pacient.PersonId
	INNER JOIN dbo.Staf AS doc ON t.DoktorId = doc.PersonId
	INNER JOIN dbo.Staf AS inf ON t.InfermierId = inf.PersonId
	WHERE
		IS_ROLEMEMBER('Recepsionist', CURRENT_USER) = 1 OR
		IS_ROLEMEMBER('Administrator', CURRENT_USER) = 1 OR
		(IS_ROLEMEMBER('Pacient', CURRENT_USER) = 1 AND Pacient.NID = CURRENT_USER) OR
		(IS_ROLEMEMBER('Doktor', CURRENT_USER) = 1 AND doc.PunonjesId = CURRENT_USER ) OR
		(IS_ROLEMEMBER('Infermier', CURRENT_USER) = 1 AND inf.PunonjesId = CURRENT_USER);

GO

CREATE SECURITY POLICY FilterPerTakimet
	ADD FILTER PREDICATE Security.fn_SecurityPredicate_Takimet()
	ON dbo.Takim
WITH (STATE = ON);

GO