USE Spitali;
GO

CREATE OR ALTER VIEW InformacionPublikStafi AS
	SELECT s.PersonId, p.Emri, p.Mbiemri, s.RolId, s.Specialiteti, s.DepartamentId
	FROM Staf AS s
	INNER JOIN Person AS p ON s.PersonId = p.Id;

GO

CREATE OR ALTER VIEW InformacionPersonalPacienti AS
	SELECT 
		person.Id, person.Emri, person.Mbiemri, person.Datelindja, person.NrTelefoni, gjinia.Emertimi,
		pacient.NID, pacient.DataRegjistrimit, pacient.GrupiGjakut,
		addr.Rruga, addr.Qyteti, addr.InformacionShtese
	FROM Pacient AS pacient
	INNER JOIN Person AS person ON pacient.PersonId = person.Id
	INNER JOIN Gjinia AS gjinia ON person.GjiniaId = gjinia.Id
	INNER JOIN Adrese AS addr ON addr.PacientId = pacient.PersonId
	WHERE pacient.NID = CURRENT_USER;

GO

CREATE OR ALTER VIEW InformacionPersonalStafi AS
	SELECT
		person.Id, person.Emri, person.Mbiemri, person.Datelindja, person.NrTelefoni, gjinia.Emertimi,
		staf.DepartamentId, staf.RolId, staf.DataPunesimit, staf.Rroga, staf.Specialiteti
	FROM Staf AS staf
	INNER JOIN Person AS person ON staf.PersonId = person.Id
	INNER JOIN Gjinia AS gjinia ON person.GjiniaId = gjinia.Id
	WHERE staf.PunonjesId = CURRENT_USER;

GO

CREATE OR ALTER VIEW PacientetNenKujdesinAnetaritStafit WITH SCHEMABINDING AS
	SELECT person.Id, person.Emri, person.Mbiemri, person.Datelindja, person.GjiniaId, pacient.GrupiGjakut
	FROM dbo.Pacient AS pacient
	INNER JOIN dbo.Person AS person ON pacient.PersonId = person.Id;
	--INNER JOIN Takim AS takim ON pacient.PersonId = takim.PacientId
	--INNER JOIN Staf AS staf ON takim.DoktorId = staf.PersonId OR takim.InfermierId = staf.PersonId
	--WHERE takim.EshteAnulluar = 0; -- AND staf.PunonjesId = CURRENT_USER;

GO

--CREATE OR ALTER VIEW AnamnezaFamiljarePacientit AS
--	SELECT DISTINCT an.*
--	FROM AnamnezaFamiljare AS an
--	INNER JOIN Takim AS takim ON takim.PacientId = an.PacientId
--	INNER JOIN Staf AS doc ON doc.PersonId = takim.DoktorId
--	INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
--	WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER
--;

--GO

--CREATE OR ALTER VIEW AnamnezaFiziologjikePacientit AS
--	SELECT an.*
--	FROM AnamnezaFiziologjike AS an
--	INNER JOIN Takim AS takim ON takim.PacientId = an.PacientId
--	INNER JOIN Staf AS doc ON doc.PersonId = takim.DoktorId
--	INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
--	WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER
--;

--GO

--CREATE OR ALTER VIEW AnamnezaSemundjesPacientit AS
--	SELECT an.*
--	FROM AnamnezaSemundjes AS an
--	INNER JOIN Takim AS takim ON takim.PacientId = an.PacientId
--	INNER JOIN Staf AS doc ON doc.PersonId = takim.DoktorId
--	INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
--	WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER
--;

--GO

--CREATE OR ALTER VIEW AnamnezaAbuzimitPacientit AS
--	SELECT an.*
--	FROM AnamnezaAbuzimit AS an
--	INNER JOIN Takim AS takim ON takim.PacientId = an.PacientId
--	INNER JOIN Staf AS doc ON doc.PersonId = takim.DoktorId
--	INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
--	WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER
--;

--GO

--CREATE OR ALTER VIEW AnamnezaFarmakologjikePacientit AS
--	SELECT an.*
--	FROM AnamnezaFarmakologjike AS an
--	INNER JOIN Takim AS takim ON takim.PacientId = an.PacientId
--	INNER JOIN Staf AS doc ON doc.PersonId = takim.DoktorId
--	INNER JOIN Staf AS inf ON inf.PersonId = takim.InfermierId
--	WHERE doc.PunonjesId = CURRENT_USER OR inf.PunonjesId = CURRENT_USER
--;

--GO

CREATE OR ALTER VIEW OrariVetjakStafit AS
	SELECT turn.*, dite_jave.Emertimi
	FROM Orar AS orar
	INNER JOIN TurnOrari AS turn ON orar.TurnOrarId = turn.Id
	INNER JOIN DiteTurni AS dite_turni ON turn.Id = dite_turni.TurnOrarId
	INNER JOIN DiteJave AS dite_jave ON dite_turni.DiteJaveId = dite_jave.Id
	INNER JOIN Staf AS staf ON orar.StafId = staf.PersonId
	WHERE staf.PunonjesId = CURRENT_USER;

GO