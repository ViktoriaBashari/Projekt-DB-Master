USE Spitali;
GO

CREATE OR ALTER VIEW TakimetRecepsionist AS
	SELECT Id, DataKrijimit, DataTakimit, DoktorId, InfermierId, PacientId, SherbimId, EshteAnulluar
	FROM Takim;

GO

CREATE OR ALTER VIEW PersonPacient AS
	SELECT Person.*
	FROM Pacient
	INNER JOIN Person ON Pacient.PersonId = Person.Id

GO

CREATE OR ALTER VIEW PersonStaf AS 
	SELECT Person.*
	FROM Staf
	INNER JOIN Person ON Person.Id = Staf.PersonId;

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
	SELECT Person.Id, Person.Emri, Person.Mbiemri, Person.Datelindja, Person.GjiniaId, Pacient.GrupiGjakut
	FROM dbo.Pacient
	INNER JOIN dbo.Person ON Pacient.PersonId = Person.Id;

GO

CREATE OR ALTER VIEW InformacionDepartament AS
	SELECT 
   	Departament.Id, Departament.Emri, 
   	Departament.DrejtuesId, PersonStaf.Emri AS DrejtuesEmri, PersonStaf.Mbiemri as DrejtuesMbiemri
	FROM Departament
	LEFT JOIN PersonStaf ON PersonStaf.Id = Departament.DrejtuesId;

GO

CREATE OR ALTER VIEW OrariPloteStafit AS
	SELECT 
		Orar.StafId, PunonjesId, 
		t.Id AS TurnId, t.Emri AS EmriTurnit, t.OraFilluese, t.OraPerfundimtare,
		DiteJaveId AS DitaId, dt_j.Emertimi AS Dita
	FROM Orar
	INNER JOIN TurnOrari AS t ON Orar.TurnOrarId = t.Id
	INNER JOIN Staf ON Orar.StafId = Staf.PersonId
	INNER JOIN DiteTurni AS dt_t ON t.Id = dt_t.TurnOrarId
	INNER JOIN DiteJave AS dt_j ON dt_t.DiteJaveId = dt_j.Id;

GO

CREATE OR ALTER VIEW OrariPersonalStafit AS
	SELECT Dita, OraFilluese, OraPerfundimtare, EmriTurnit
	FROM OrariPloteStafit
	WHERE PunonjesId = CURRENT_USER;

GO