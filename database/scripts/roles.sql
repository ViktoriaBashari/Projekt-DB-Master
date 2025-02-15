USE Spitali;
GO

-- Role
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals 
    WHERE name = 'Pacient' AND type = 'R')
	CREATE ROLE Pacient;

IF NOT EXISTS (
	SELECT 1 FROM sys.database_principals 
	WHERE name = 'Doktor' AND type = 'R')
CREATE ROLE Doktor;

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals 
    WHERE name = 'Infermier' AND type = 'R')
CREATE ROLE Infermier;

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals 
    WHERE name = 'Recepsionist' AND type = 'R')
CREATE ROLE Recepsionist;

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals 
    WHERE name = 'Administrator' AND type = 'R')
CREATE ROLE Administrator;

GO

-- Tabelat

GRANT SELECT ON MetodePagimi TO Administrator, Recepsionist, Pacient;
GRANT SELECT ON Gjinia TO Administrator, Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT ON RolStafi TO Administrator, Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT ON DiteJave TO Administrator, Recepsionist, Doktor, Infermier;

GRANT INSERT, UPDATE, DELETE ON MetodePagimi TO Administrator;
GRANT INSERT, UPDATE, DELETE ON Gjinia TO Administrator;
GRANT INSERT, UPDATE, DELETE ON RolStafi TO Administrator;
GRANT INSERT, UPDATE, DELETE ON DiteJave TO Administrator;


GRANT SELECT ON Sherbim TO Pacient, Recepsionist, Administrator;
GRANT SELECT(Kodi, Emri, Pershkrimi) ON Sherbim TO Doktor, Infermier;
GRANT INSERT, UPDATE, DELETE ON Sherbim to Administrator;


GRANT SELECT ON Departament TO Pacient, Doktor, Infermier, Recepsionist, Administrator;
GRANT INSERT, UPDATE, DELETE ON Departament TO Administrator;


GRANT SELECT ON Fature TO Recepsionist, Pacient;
GRANT UPDATE(DataPagimit, MetodaPagimitId) ON Fature TO Recepsionist;


GRANT SELECT(Id, DataKrijimit, DataTakimit, DoktorId, PacientId, SherbimId) ON Takim TO Pacient;
GRANT SELECT(Id, DataKrijimit, DataTakimit, DoktorId, InfermierId, SherbimId, EshteAnulluar) ON Takim TO Administrator;

GRANT 
	SELECT, 
	UPDATE(ShqetesimiKryesor, KohezgjatjaShqetesimit, SimptomaTeLidhura, Konkluzioni) 
ON Takim TO Doktor, Infermier;

GRANT SELECT, INSERT, UPDATE(DoktorId, InfermierId, DataTakimit, EshteAnulluar) ON TakimetRecepsionist TO Recepsionist;


GRANT SELECT, UPDATE, DELETE ON Adrese TO Recepsionist;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pacient TO Recepsionist;

GRANT SELECT(PersonId, DepartamentId, RolId, Specialiteti) ON Staf TO Recepsionist;
GRANT SELECT, INSERT, UPDATE, DELETE ON Staf TO Administrator;


GRANT SELECT ON TurnOrari TO Recepsionist, Doktor, Infermier, Administrator;
GRANT INSERT, UPDATE, DELETE ON TurnOrari TO Administrator;

GRANT SELECT ON DiteTurni TO Recepsionist, Doktor, Infermier, Administrator;
GRANT INSERT, UPDATE, DELETE ON DiteTurni TO Administrator;

GRANT SELECT ON Orar TO Recepsionist, Doktor, Infermier, Administrator;
GRANT INSERT, UPDATE, DELETE ON Orar TO Administrator;


GRANT SELECT, INSERT ON AnamnezaFamiljare TO Doktor, Infermier; 
GRANT SELECT, INSERT ON AnamnezaFiziologjike TO Doktor, Infermier; 
GRANT SELECT, INSERT ON AnamnezaSemundjes TO Doktor, Infermier;
GRANT SELECT, INSERT ON AnamnezaFarmakologjike TO Doktor, Infermier;
GRANT SELECT, INSERT ON AnamnezaAbuzimit TO Doktor, Infermier;

-- Views

GRANT SELECT, INSERT, UPDATE ON PersonPacient TO Recepsionist;
GRANT SELECT, INSERT, UPDATE ON PersonStaf TO Administrator;

GRANT SELECT ON InformacionDepartament TO Administrator;

GRANT SELECT ON InformacionPublikStafi TO Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT ON InformacionPersonalStafi TO Doktor, Infermier;
GRANT SELECT ON InformacionDetajuarStafi TO Administrator;

GRANT SELECT ON InformacionPersonalPacienti TO Pacient;
GRANT SELECT ON PacientetNenKujdesinAnetaritStafit TO Doktor, Infermier;

GRANT SELECT ON OrariPersonalStafit TO Doktor, Infermier;
GRANT SELECT(StafId, TurnId, EmriTurnit, OraFilluese, OraPerfundimtare, DitaId, Dita) ON OrariPloteStafit TO Administrator;

-- Funksione

GRANT SELECT ON dbo.MerrOrarinStafitPerkates TO Recepsionist;

GRANT EXECUTE ON dbo.KalkuloShumenPapaguarNgaPacienti TO Pacient, Recepsionist;

GRANT EXECUTE ON dbo.GjeneroRaportinStafKerkese TO Administrator;
GRANT EXECUTE ON dbo.KalkuloNormenMesatareTePritjesPerTakim TO Administrator;
GRANT EXECUTE ON dbo.KalkuloPerqindjenTakimeveAnulluara TO Administrator;
GRANT EXECUTE ON dbo.GjeneroShpenzimetVjetore TO Administrator;
GRANT SELECT ON dbo.GjeneroRaportFitimesh TO Administrator;
GRANT EXECUTE ON dbo.GjeneroOperatingMarginVjetor TO Administrator;
GRANT EXECUTE ON dbo.KalkuloTarifenMesatareVjetoreTeTrajtimit TO Administrator;
GRANT SELECT ON dbo.KalkuloTarifenMesatareMujoreTeTrajtimit TO Administrator;

-- Procedura

GRANT EXECUTE ON dbo.GjeneroFluksinRegjistrimeveTePacienteve TO Administrator;
GRANT EXECUTE ON dbo.GjeneroProceduratMeTePerdorura TO Administrator;
GRANT EXECUTE ON dbo.GjeneroStafinMeTePerdorur TO Administrator;
GRANT EXECUTE ON dbo.GjeneroPacientetMeTeShpeshte TO Recepsionist;

GRANT EXECUTE ON dbo.SelektoTakimetPacientit TO Recepsionist, Pacient;
GRANT EXECUTE ON dbo.SelektoFaturatPacientit TO Recepsionist, Pacient;
GRANT EXECUTE ON dbo.SelektoTakimetStafit TO Doktor, Infermier;

GRANT EXECUTE ON dbo.FshiDepartament TO Administrator;

GRANT EXECUTE ON dbo.ShtoStafAdministratues TO Administrator;
GRANT EXECUTE ON dbo.FshiStafAdministratues TO Administrator;