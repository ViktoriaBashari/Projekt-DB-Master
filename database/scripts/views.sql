USE Spitali;
GO

CREATE OR ALTER VIEW InformacionDepartament AS
	SELECT 
   	Departament.Id, Departament.Emri, 
   	Departament.DrejtuesId, PersonStaf.Emri AS DrejtuesEmri, PersonStaf.Mbiemri as DrejtuesMbiemri
	FROM Departament
	LEFT JOIN PersonStaf ON PersonStaf.Id = Departament.DrejtuesId;

GO

CREATE OR ALTER VIEW TakimetRecepsionist AS
	SELECT Id, DataKrijimit, DataTakimit, DoktorId, InfermierId, PacientId, SherbimId, EshteAnulluar
	FROM Takim;

GO

CREATE OR ALTER VIEW PersonPacient AS
	SELECT Person.* FROM Person 
	INNER JOIN Pacient ON Id = PersonId;

GO

CREATE OR ALTER VIEW PersonStaf AS 
	SELECT Person.* FROM Person 
	INNER JOIN Staf ON Id = PersonId;

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

CREATE OR ALTER VIEW InformacionDetajuarStafi AS
	SELECT
		p.Id, p.Emri, p.Mbiemri, p.Datelindja, p.NrTelefoni, gj.Id AS GjiniaId, gj.Emertimi AS GjiniaEmertimi,
		s.PunonjesId, s.DataPunesimit, s.Rroga, s.Specialiteti,
		s.RolId, rs.Emertimi AS RolEmertimi,
		s.DepartamentId, d.Emri AS DepartamentEmri
	FROM Staf AS s
	INNER JOIN Person AS p ON s.PersonId = p.Id
	INNER JOIN Gjinia AS gj ON p.GjiniaId = gj.Id
	INNER JOIN RolStafi AS rs ON rs.Id = s.RolId
	INNER JOIN Departament AS d ON d.Id = s.DepartamentId;

GO

CREATE OR ALTER VIEW InformacionPersonalStafi AS
	SELECT *
	FROM InformacionDetajuarStafi
	WHERE PunonjesId = CURRENT_USER;

GO

CREATE OR ALTER VIEW PacientetNenKujdesinAnetaritStafit WITH SCHEMABINDING AS
	SELECT person.Id, person.Emri, person.Mbiemri, person.Datelindja, person.GjiniaId, pacient.GrupiGjakut
	FROM dbo.Pacient AS pacient
	INNER JOIN dbo.Person AS person ON pacient.PersonId = person.Id;

GO

CREATE OR ALTER VIEW OrariPloteStafit AS
	SELECT 
		Orar.StafId, PunonjesId, 
		turn.Id AS TurnId, turn.Emri AS EmriTurnit, turn.OraFilluese, turn.OraPerfundimtare,
		DiteJaveId AS DitaId, dite_jave.Emertimi AS Dita
	FROM Orar
	INNER JOIN TurnOrari AS turn ON Orar.TurnOrarId = turn.Id
	INNER JOIN DiteTurni AS dite_turni ON turn.Id = dite_turni.TurnOrarId
	INNER JOIN DiteJave AS dite_jave ON dite_turni.DiteJaveId = dite_jave.Id
	INNER JOIN Staf ON Orar.StafId = Staf.PersonId;

GO

CREATE OR ALTER VIEW OrariPersonalStafit AS
	SELECT OraFilluese, OraPerfundimtare, Dita
	FROM OrariPloteStafit
	WHERE PunonjesId = CURRENT_USER;

GO