CREATE DATABASE Spitali; 
GO
USE Spitali; 
GO

-- User-defined data type

CREATE TYPE NumerTelefoni FROM CHAR(18) NOT NULL;
GO

CREATE RULE Rregull_NumerTelefoni
AS
	@value LIKE '+[1-9]%' AND 
	LEN(@value) >= 8 AND
	SUBSTRING(@value, 3, LEN(@value)-2) NOT LIKE '%[^0-9]%';

GO

EXEC sp_bindrule 'Rregull_NumerTelefoni', 'NumerTelefoni';
GO

-- Enums

CREATE TABLE Gjinia (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(8) UNIQUE NOT NULL
);

CREATE TABLE DiteJave (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(7) UNIQUE NOT NULL
);

CREATE TABLE MetodePagimi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(7) UNIQUE NOT NULL
);

CREATE TABLE RolStafi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(12) UNIQUE NOT NULL
);

GO

INSERT INTO Gjinia
VALUES (1, 'Femer'), (2, 'Mashkull');

INSERT INTO MetodePagimi
VALUES (1, 'Dorezim'), (2, 'Karte');

INSERT INTO RolStafi
VALUES (1, 'Doktor'), (2, 'Infermier');

INSERT INTO DiteJave
VALUES
	(1, 'Hene'),
	(2, 'Marte'),
	(3, 'Merkure'),
	(4, 'Enjte'),
	(5, 'Premte'),
	(6, 'Shtune'),
	(7, 'Diele');

GO


-- Entitetet

CREATE TABLE Departament (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    DrejtuesId INT NULL,
    Emri VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Sherbim (
    Kodi CHAR(5) NOT NULL PRIMARY KEY,
    Emri VARCHAR(55) UNIQUE NOT NULL,
    Pershkrimi VARCHAR(300) NULL,
    Cmimi DECIMAL(20,2) NOT NULL
);


CREATE TABLE Person (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR(30) NOT NULL,
    Mbiemri VARCHAR(30) NOT NULL,
    Datelindja DATE NOT NULL,
    NrTelefoni NumerTelefoni NOT NULL,
    GjiniaId TINYINT NOT NULL 
		FOREIGN KEY REFERENCES Gjinia(Id) 
		ON DELETE NO ACTION 
		ON UPDATE CASCADE,
);

CREATE INDEX EmriPlotePersonit ON Person (Emri, Mbiemri);
CREATE INDEX GjiniPersoni ON Person (GjiniaId);

GO

CREATE TABLE Pacient (
    PersonId INT NOT NULL 
		FOREIGN KEY REFERENCES Person(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    NID CHAR(10) UNIQUE NOT NULL,
    DataRegjistrimit DATE NOT NULL DEFAULT GETDATE(),
    GrupiGjakut CHAR(3) NULL,

	PRIMARY KEY (PersonId),
	CONSTRAINT VleratGrupitGjakut CHECK 
		(GrupiGjakut IN ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')),
);

GO

CREATE TABLE Adrese (
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    Rruga VARCHAR(50) NOT NULL,
    Qyteti VARCHAR(20) NOT NULL,
    InformacionShtese VARCHAR(100) NULL,

    PRIMARY KEY (PacientId)
);

GO

CREATE TABLE Staf (
    PersonId INT NOT NULL 
		FOREIGN KEY REFERENCES Person(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	PunonjesId CHAR(5) UNIQUE NOT NULL,
    DepartamentId INT NOT NULL 
		FOREIGN KEY REFERENCES Departament(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    RolId TINYINT NOT NULL 
		FOREIGN KEY REFERENCES RolStafi(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    DataPunesimit DATE NOT NULL,
    Rroga DECIMAL(15,4) NOT NULL,
    Specialiteti VARCHAR(50) NULL,

	PRIMARY KEY (PersonId)
);

CREATE INDEX DepartamentStafi ON Staf (DepartamentId);
CREATE INDEX RolStafi ON Staf (RolId);

GO

ALTER TABLE Departament
	ADD CONSTRAINT FK_Departament_DrejtuesId
	FOREIGN KEY (DrejtuesId) REFERENCES Staf(PersonId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION;

CREATE INDEX DrejtuesDepartamenti ON Departament (DrejtuesId);

GO

CREATE TABLE Takim (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    DataKrijimit DATETIME NOT NULL DEFAULT GETDATE(),
    DataTakimit DATETIME NOT NULL CHECK (CAST(DataTakimit AS DATE) >= CAST(GETDATE() AS DATE)),
    DoktorId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    InfermierId INT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    SherbimId CHAR(5) NOT NULL 
		FOREIGN KEY REFERENCES Sherbim(Kodi)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    ShqetesimiKryesor VARCHAR(MAX) NULL,
    KohezgjatjaShqetesimit VARCHAR(100) NULL,
    SimptomaTeLidhura VARCHAR(MAX) NULL,
    Konkluzioni VARCHAR(MAX) NULL,
    EshteAnulluar BIT NOT NULL DEFAULT 0,

	CONSTRAINT OrarStafiUnik UNIQUE(DataTakimit, DoktorId),
);

CREATE INDEX DoktorTakimi ON Takim (DoktorId);
CREATE INDEX InfermierTakimi ON Takim (InfermierId);
CREATE INDEX PacientTakimi ON Takim (PacientId);
CREATE INDEX SherbimTakimi ON Takim (SherbimId);

GO

CREATE TABLE Fature (
    TakimId INT NOT NULL 
		FOREIGN KEY REFERENCES Takim(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    Cmimi DECIMAL(20,5) NOT NULL,
    DataPagimit DATETIME NULL,
    MetodaPagimitId TINYINT NULL
		FOREIGN KEY REFERENCES MetodePagimi(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,

	PRIMARY KEY (TakimId),
);

CREATE INDEX MetodaPagimitFatures ON Fature (MetodaPagimitId);

GO

CREATE TABLE TurnOrari (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR(55) UNIQUE NOT NULL,
    OraFilluese TIME NOT NULL,
    OraPerfundimtare TIME NOT NULL,

	CONSTRAINT KohezgjatjeMinimale CHECK (DATEDIFF(MINUTE, OraFilluese, OraPerfundimtare) >= 20),
);

GO

CREATE TABLE Orar (
    TurnOrarId INT NOT NULL 
		FOREIGN KEY REFERENCES TurnOrari(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,

    PRIMARY KEY (TurnOrarId, StafId),
);

GO

CREATE TABLE DiteTurni (
    TurnOrarId INT NOT NULL 
		FOREIGN KEY REFERENCES TurnOrari(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    DiteJaveId TINYINT NOT NULL 
		FOREIGN KEY REFERENCES DiteJave(Id)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,

    PRIMARY KEY (TurnOrarId, DiteJaveId),
);

GO

CREATE TABLE AnamnezaFiziologjike (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafiPergjegjesId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    DataKrijimit DATETIME NOT NULL DEFAULT GETDATE(),
    SistemiFrymemarrjes VARCHAR(MAX) NULL,
    SistemiGjenitourinar VARCHAR(MAX) NULL,
    SistemiTretes VARCHAR(MAX) NULL,
    SistemiOkular VARCHAR(MAX) NULL,
    SistemiNeurologjik VARCHAR(MAX) NULL,
    SistemiOrl VARCHAR(MAX) NULL,
    SistemiPsikiatrik VARCHAR(MAX) NULL,
    SistemiKardiovaskular VARCHAR(MAX) NULL,

	CONSTRAINT PlotesimiMinimalSistemeve CHECK (
		SistemiFrymemarrjes IS NOT NULL OR
		SistemiGjenitourinar IS NOT NULL OR
		SistemiTretes IS NOT NULL OR
		SistemiOkular IS NOT NULL OR
		SistemiNeurologjik IS NOT NULL OR
		SistemiOrl IS NOT NULL OR
		SistemiPsikiatrik IS NOT NULL OR
		SistemiKardiovaskular IS NOT NULL)
);

CREATE INDEX AnamnezaFiziologjike_Pacient ON AnamnezaFiziologjike (PacientId);
CREATE INDEX AnamnezaFiziologjike_Staf ON AnamnezaFiziologjike (StafiPergjegjesId);

GO

CREATE TABLE AnamnezaFamiljare (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafiPergjegjesId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    LidhjaFamiljare VARCHAR(50) NOT NULL,
    Datelindja DATE NOT NULL CHECK (Datelindja <= GETDATE()),
    Semundja VARCHAR(50) NOT NULL,
    MoshaDiagnozes TINYINT NULL,
    ShkakuVdekjes VARCHAR(80) NULL,
    DataVdekjes DATE NULL,
);

CREATE INDEX AnamnezaFamiljare_Pacient ON AnamnezaFamiljare (PacientId);
CREATE INDEX AnamnezaFamiljare_Staf ON AnamnezaFamiljare (StafiPergjegjesId);

GO

CREATE TABLE AnamnezaSemundjes (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafiPergjegjesId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    Semundja VARCHAR(50) NOT NULL,
    DataDiagnozes DATE NOT NULL CHECK (DataDiagnozes <= GETDATE()),
    EshteKronike BIT NOT NULL,
);

CREATE INDEX AnamnezaSemundjes_Pacient ON AnamnezaSemundjes (PacientId);
CREATE INDEX AnamnezaSemundjes_Staf ON AnamnezaSemundjes (StafiPergjegjesId);

GO

CREATE TABLE AnamnezaAbuzimit (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafiPergjegjesId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    Substanca VARCHAR(50) NOT NULL,
    Pershkrimi VARCHAR(MAX) NULL,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE NULL,
	CHECK (DataPerfundimit IS NULL OR DataPerfundimit >= DataFillimit),
);

CREATE INDEX AnamnezaAbuzimit_Pacient ON AnamnezaAbuzimit (PacientId);
CREATE INDEX AnamnezaAbuzimit_Staf ON AnamnezaAbuzimit (StafiPergjegjesId);

GO

CREATE TABLE AnamnezaFarmakologjike (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL 
		FOREIGN KEY REFERENCES Pacient(PersonId)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    StafiPergjegjesId INT NOT NULL 
		FOREIGN KEY REFERENCES Staf(PersonId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    Ilaci VARCHAR(35) NOT NULL,
    Doza VARCHAR(40) NOT NULL,
    Arsyeja VARCHAR(200) NOT NULL,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE NULL,
    MarrePaRecete BIT NOT NULL,
	CHECK (DataPerfundimit IS NULL OR DataPerfundimit >= DataFillimit),
);

CREATE INDEX AnamnezaFarmakologjike_Pacient ON AnamnezaFarmakologjike (PacientId);
CREATE INDEX AnamnezaFarmakologjike_Staf ON AnamnezaFarmakologjike (StafiPergjegjesId);

GO