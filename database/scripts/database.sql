CREATE DATABASE Spitali; 
GO
USE Spitali; 
GO

-- User-defined data type

CREATE TYPE NumerTelefoni
	FROM CHAR(18) NULL;

GO

-- Enums

CREATE TABLE Gjinia (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(8) NOT NULL
);

CREATE TABLE DiteJave (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(7) NOT NULL
);

CREATE TABLE MetodePagimi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(7) NOT NULL
);

CREATE TABLE RolStafi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(12) NOT NULL
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
    DrejtuesId INT NOT NULL,
    Emri VARCHAR(50) NOT NULL,

	CONSTRAINT EmerUnikDepartamenti UNIQUE(Emri),
);

CREATE TABLE Sherbim (
    Kodi CHAR(5) NOT NULL PRIMARY KEY,
    Emri VARCHAR(55) NOT NULL,
    Pershkrimi VARCHAR(300),
    Cmimi DECIMAL(20,2) NOT NULL,

	CONSTRAINT EmerUnikSherbimi UNIQUE(Emri),
);


CREATE TABLE Person (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR NOT NULL,
    Mbiemri VARCHAR NOT NULL,
    Datelindja DATE NOT NULL,
    NrTelefoni NumerTelefoni NOT NULL,
    GjiniaId TINYINT NOT NULL FOREIGN KEY REFERENCES Gjinia(Id),
);

CREATE INDEX EmriPlotePersonit ON Person (Emri, Mbiemri);

GO

CREATE TABLE Pacient (
    PersonId INT NOT NULL FOREIGN KEY REFERENCES Person(Id),
    NID CHAR(10) NOT NULL,
    DataRegjistrimit DATE NOT NULL DEFAULT GETDATE(),
    GrupiGjakut CHAR(3) NULL,

	PRIMARY KEY (PersonId),
	CONSTRAINT NIDUnik UNIQUE(NID),
	CONSTRAINT VleratGrupitGjakut CHECK (GrupiGjakut IN ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')),
);

GO

CREATE TABLE Adrese (
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    Rruga VARCHAR(50) NOT NULL,
    Qyteti VARCHAR(20) NOT NULL,
    InformacionShtese VARCHAR(100) NULL,

    PRIMARY KEY (PacientId)
);

CREATE TABLE Staf (
    PersonId INT NOT NULL FOREIGN KEY REFERENCES Person(Id),
	PunonjesId CHAR(5) NOT NULL,
    DepartamentId INT NOT NULL FOREIGN KEY REFERENCES Departament(Id),
    RolId TINYINT NOT NULL FOREIGN KEY REFERENCES RolStafi(Id),
    DataPunesimit DATE NOT NULL,
    Rroga DECIMAL(15,4) NOT NULL,
    Specialiteti VARCHAR(50) NULL,

	PRIMARY KEY (PersonId),
	CONSTRAINT PunonjesIdUnik UNIQUE(PunonjesId),
);

CREATE INDEX DepartamentStafi ON Staf (DepartamentId);
CREATE INDEX RolStafi ON Staf (RolId);

ALTER TABLE Departament
	ADD CONSTRAINT FK_Departament_DrejtuesId
	FOREIGN KEY (DrejtuesId) REFERENCES Staf(PersonId);

CREATE INDEX DrejtuesDepartamenti ON Departament (DrejtuesId);

GO

CREATE TABLE Takim (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    DataKrijimit DATETIME NOT NULL DEFAULT GETDATE(),
    DataTakimit DATETIME NOT NULL CHECK (CAST(DataTakimit AS DATE) >= CAST(GETDATE() AS DATE)),
    DoktorId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    InfermierId INT  NULL FOREIGN KEY REFERENCES Staf(PersonId),
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    SherbimId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Sherbim(Kodi),
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
    TakimId INT NOT NULL FOREIGN KEY REFERENCES Takim(Id),
    Cmimi DECIMAL(20,5) NOT NULL,
    DataPagimit DATETIME NULL,
    MetodaPagimitId TINYINT FOREIGN KEY REFERENCES MetodePagimi(Id),

	PRIMARY KEY (TakimId),
);

CREATE INDEX TakimFature ON Fature (TakimId);
CREATE INDEX MetodaPagimitFatures ON Fature (MetodaPagimitId);

GO


CREATE TABLE TurnOrari (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR(55) NOT NULL,
    OraFilluese TIME NOT NULL,
    OraPerfundimtare TIME NOT NULL,

	CONSTRAINT KohezgjatjeMinimale CHECK (DATEDIFF(MINUTE, OraFilluese, OraPerfundimtare) >= 10),
);

GO

CREATE TABLE Orar (
    TurnOrarId INT NOT NULL FOREIGN KEY REFERENCES TurnOrari(Id),
    StafId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),

    PRIMARY KEY (TurnOrarId, StafId),
);

CREATE INDEX TurnPerOrarin ON Orar (TurnOrarId);
CREATE INDEX StafiOrarit ON Orar (StafId);

CREATE TABLE DiteTurni (
    TurnOrarId INT NOT NULL FOREIGN KEY REFERENCES TurnOrari(Id),
    DiteJaveId TINYINT NOT NULL FOREIGN KEY REFERENCES DiteJave(Id),

    PRIMARY KEY (TurnOrarId, DiteJaveId),
);

CREATE INDEX TurniDites ON DiteTurni (TurnOrarId);
CREATE INDEX DitePerTurnin ON DiteTurni (DiteJaveId);

GO


CREATE TABLE AnamnezaFiziologjike (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    DataKrijimit DATETIME NOT NULL DEFAULT GETDATE(),
    SistemiFrymemarrjes VARCHAR(MAX) NULL,
    SistemiGjenitourinar VARCHAR(MAX) NULL,
    SistemiTretes VARCHAR(MAX) NULL,
    SistemiOkular VARCHAR(MAX) NULL,
    SistemiNeurologjik VARCHAR(MAX) NULL,
    SistemiOrl VARCHAR(MAX) NULL,
    SistemiPsikiatrik VARCHAR(MAX) NULL,
    SistemiKardiovaskular VARCHAR(MAX) NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaFiziologjike (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaFiziologjike (StafiPergjegjesId);

CREATE TABLE AnamnezaFamiljare (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    LidhjaFamiljare VARCHAR(50) NOT NULL,
    Datelindja DATE NOT NULL,
    Semundja VARCHAR(50) NOT NULL,
    MoshaDiagnozes TINYINT NULL,
    ShkakuVdekjes VARCHAR(80) NULL,
    DataVdekjes DATE NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaFamiljare (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaFamiljare (StafiPergjegjesId);

CREATE TABLE AnamnezaSemundjes (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    Semundja VARCHAR(50) NOT NULL,
    DataDiagnozes DATE NOT NULL,
    EshteKronike BIT NOT NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaSemundjes (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaSemundjes (StafiPergjegjesId);

CREATE TABLE AnamnezaAbuzimit (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    Substanca VARCHAR(50) NOT NULL,
    Pershkrimi VARCHAR(MAX) NULL,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaAbuzimit (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaAbuzimit (StafiPergjegjesId);

CREATE TABLE AnamnezaFarmakologjike (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    Ilaci VARCHAR(35) NOT NULL,
    Doza VARCHAR(40) NOT NULL,
    Arsyeja VARCHAR(200) NOT NULL,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE NULL,
    MarrePaRecete BIT NOT NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaFarmakologjike (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaFarmakologjike (StafiPergjegjesId);

GO