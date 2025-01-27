USE Spitali;
GO

-- Role
CREATE ROLE Pacient;
CREATE ROLE Doktor;
CREATE ROLE Infermier;
CREATE ROLE Recepsionist;
CREATE ROLE Administrator;

GO

-- Leje

GRANT SELECT, INSERT, UPDATE, DELETE ON MetodePagimi TO Administrator, Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT, INSERT, UPDATE, DELETE ON Gjinia TO Administrator, Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT, INSERT, UPDATE, DELETE ON RolStafi TO Administrator, Recepsionist, Pacient, Doktor, Infermier;
GRANT SELECT, INSERT, UPDATE, DELETE ON DiteJave TO Administrator, Recepsionist, Doktor, Infermier;

GRANT SELECT ON Sherbim TO Pacient, Recepsionist;
GRANT SELECT ON Departament TO Pacient, Doktor, Infermier, Recepsionist;

-- Leje pacienti

GRANT SELECT ON InformacionPersonalPacienti TO Pacient;
GRANT SELECT ON InformacionPublikStafi TO Pacient;

GRANT EXECUTE ON SelektoTakimetPacientit TO Pacient;

GRANT EXECUTE ON SelektoFaturatPacientit TO Pacient;
GRANT EXECUTE ON KalkuloShumenPapaguarNgaPacienti TO Pacient;

-- Leje doktori, infermieri

GRANT SELECT ON PacientetNenKujdesinAnetaritStafit TO Doktor, Infermier;

GRANT SELECT, INSERT ON AnamnezaFamiljare TO Doktor, Infermier; 
GRANT SELECT, INSERT ON AnamnezaFiziologjike TO Doktor, Infermier; 
GRANT SELECT, INSERT ON AnamnezaSemundjes TO Doktor, Infermier;
GRANT SELECT, INSERT ON AnamnezaFarmakologjike TO Doktor, Infermier;
GRANT SELECT, INSERT ON AnamnezaAbuzimit TO Doktor, Infermier;

GRANT SELECT ON InformacionPersonalStafi TO Doktor, Infermier;
GRANT SELECT ON InformacionPublikStafi TO Doktor, Infermier;

GRANT EXECUTE ON SelektoTakimetStafit TO Doktor, Infermier;
GRANT UPDATE(ShqetesimiKryesor, KohezgjatjaShqetesimit, SimptomaTeLidhura, Konkluzioni) ON Takim TO Doktor, Infermier;
GRANT UPDATE(InfermierId) ON Takim TO Doktor;

GRANT SELECT(Kodi, Emri, Pershkrimi) ON Sherbim TO Doktor, Infermier;

GRANT SELECT ON OrariVetjakStafit TO Doktor, Infermier;

-- Leje recepsionisti

GRANT SELECT, INSERT, UPDATE ON Person TO Recepsionist;
GRANT SELECT(PersonId, NID, DataRegjistrimit), INSERT, UPDATE(NID) ON Pacient TO Recepsionist;
GRANT SELECT(PersonId, DepartamentId, RolId, DataPunesimit, Specialiteti) ON Staf TO Recepsionist;

GRANT SELECT, INSERT, UPDATE(Rruga, Qyteti, InformacionShtese), DELETE ON Adrese TO Recepsionist;

GRANT 
	SELECT(Id, DataKrijimit, DataTakimit, DoktorId, PacientId, SherbimId, EshteAnulluar),
	INSERT,	UPDATE(DataTakimit, EshteAnulluar)
ON Takim
TO Recepsionist;

GRANT SELECT, INSERT, UPDATE(DataPagimit, MetodaPagimitId) ON Fature TO Recepsionist;

GRANT SELECT ON Orar TO Recepsionist;
GRANT SELECT ON TurnOrari TO Recepsionist;
GRANT SELECT ON DiteTurni TO Recepsionist;

-- Leje administratori

GRANT SELECT, INSERT, UPDATE, DELETE ON Staf TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON Departament TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON TurnOrari TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orar TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON DiteTurni TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON Sherbim TO Administrator;

GRANT EXECUTE ON GjeneroRaportinStafKerkese TO Administrator;
GRANT SELECT ON GjeneroStafinMeTePerdorur TO Administrator;
GRANT SELECT ON GjeneroPacientetMeTeShpeshte TO Administrator;
GRANT SELECT ON GjeneroProceduratMeTePerdorura TO Administrator;

GRANT EXECUTE ON KalkuloNormenMesatareTePritjesPerTakim TO Administrator;
GRANT EXECUTE ON KalkuloPerqindjenTakimeveAnulluara TO Administrator;
GRANT SELECT ON GjeneroFluksinMujorTeRegjistrimeveTePacienteve TO Administrator;

GRANT EXECUTE ON GjeneroShpenzimetVjetore TO Administrator;
GRANT SELECT ON GjeneroRaportFitimesh TO Administrator;
GRANT EXECUTE ON GjeneroOperatingMarginVjetor TO Administrator;

GRANT EXECUTE ON KalkuloTarifenMesatareVjetoreTeTrajtimit TO Administrator;
GRANT SELECT ON KalkuloTarifenMesatareMujoreTeTrajtimit TO Administrator;

GO