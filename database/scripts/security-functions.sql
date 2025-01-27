USE Spitali;
GO

CREATE SCHEMA Security;
GO

CREATE OR ALTER FUNCTION Security.fn_SecurityPredicate_InformacioniPacienteveTeStafitPerkates()
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 as SecurityPredicateResult
	FROM dbo.Takim AS takim 
	INNER JOIN dbo.Staf AS staf ON takim.DoktorId = staf.PersonId OR takim.InfermierId = staf.PersonId
	--INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
	WHERE staf.PunonjesId = CURRENT_USER AND takim.EshteAnulluar = 0;

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