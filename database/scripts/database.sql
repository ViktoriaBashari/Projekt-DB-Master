CREATE DATABASE Spitali;
USE Spitali;

-- User-defined data type

CREATE TYPE NumerTelefoni
	FROM CHAR(18);


-- Enums

CREATE TABLE Gjinia (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(8) NOT NULL
);

INSERT INTO Gjinia
VALUES (1, 'Femer'), (2, 'Mashkull');

CREATE TABLE DiteJave (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(7) NOT NULL
);

INSERT INTO DiteJave
VALUES
	(1, 'Hene'),
	(2, 'Marte'),
	(3, 'Merkure'),
	(4, 'Enjte'),
	(5, 'Premte'),
	(6, 'Shtune'),
	(7, 'Diele');

CREATE TABLE MetodePagimi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(6) NOT NULL
);

INSERT INTO MetodePagimi
VALUES (1, 'Dorezim'), (2, 'Karte');

CREATE TABLE RolStafi (
    Id TINYINT NOT NULL PRIMARY KEY,
    Emertimi CHAR(12) NOT NULL
);

INSERT INTO RolStafi
VALUES (1, 'Doktor'), (2, 'Infermier');


-- Entitetet

CREATE TABLE Departament (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    DrejtuesId INT NOT NULL,
    Emri VARCHAR(50) NOT NULL,

	CONSTRAINT EmerUnik UNIQUE(Emri),
);

CREATE TABLE Sherbim (
    Kodi CHAR(5) NOT NULL PRIMARY KEY,
    Emri VARCHAR(55) NOT NULL,
    Pershkrimi VARCHAR(300),
    Cmimi DECIMAL(20,2) NOT NULL,

	CONSTRAINT EmerUnik UNIQUE(Emri),
);


CREATE TABLE Person (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR NOT NULL,
    Mbiemri VARCHAR NOT NULL,
    Datelindja DATE NOT NULL,
    NrTelefoni NUMERTELEFONI NOT NULL,
    GjiniaId TINYINT NOT NULL FOREIGN KEY REFERENCES Gjinia(Id),
);

CREATE INDEX EmriPlotePersonit ON Person (Emri, Mbiemri);

CREATE TABLE Pacient (
    PersonId INT NOT NULL FOREIGN KEY REFERENCES Person(Id),
    NID CHAR(10) NOT NULL,
    DataRegjistrimit DATE NOT NULL,
    GrupiGjakut CHAR(3),

	PRIMARY KEY (PersonId),
	CONSTRAINT NIDUnik UNIQUE(NID),
	CONSTRAINT VleratGrupitGjakut CHECK (GrupiGjakut IN ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')),
);

CREATE TABLE Adrese (
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    Rruga VARCHAR(50) NOT NULL,
    Qyteti VARCHAR(20) NOT NULL,
    InformacionShtese VARCHAR(100),

    PRIMARY KEY (PacientId)
);

CREATE TABLE Staf (
    PersonId INT NOT NULL PRIMARY KEY,
	PunonjesId CHAR(5) NOT NULL,
    DepartamentId INT NOT NULL FOREIGN KEY REFERENCES Departament(Id),
    RolId TINYINT NOT NULL FOREIGN KEY REFERENCES RolStafi(Id),
    DataPunesimit DATE NOT NULL,
    Rroga DECIMAL(15,4) NOT NULL,
    Specialiteti VARCHAR(50),

	FOREIGN KEY (PersonId) REFERENCES Person(Id),
	CONSTRAINT PunonjesIdUnik UNIQUE(PunonjesId),
);

CREATE INDEX DepartamentStafi ON Staf (DepartamentId);
CREATE INDEX RolStafi ON Staf (RolId);

ALTER TABLE Spitali.Departament
	ADD CONSTRAINT FK_Departament_DrejtuesId
	FOREIGN KEY REFERENCES Staf(PersonId);

CREATE INDEX DrejtuesDepartamenti ON Departament (DrejtuesId);

CREATE TABLE Takim (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    DataKrijimit DATETIME NOT NULL,
    DataTakimit DATETIME NOT NULL,
    DoktorId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    InfermierId INT FOREIGN KEY REFERENCES Staf(PersonId),
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    SherbimId CHAR(5) NOT NULL FOREIGN KEY REFERENCES Sherbim(Kodi),
    ShqetesimiKryesor VARCHAR(MAX),
    KohezgjatjaShqetesimit VARCHAR(100),
    SimptomaTeLidhura VARCHAR(MAX),
    Konkluzioni VARCHAR(MAX),
    EshteAnulluar BIT NOT NULL DEFAULT 0,

	CONSTRAINT OrarStafiUnik UNIQUE(DataTakimit, DoktorId),
);

CREATE INDEX DoktorTakimi ON Takim (DoktorId);
CREATE INDEX InfermierTakimi ON Takim (InfermierId);
CREATE INDEX PacientTakimi ON Takim (PacientId);
CREATE INDEX SherbimTakimi ON Takim (SherbimId);

CREATE TABLE Fature (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    TakimId INT NOT NULL FOREIGN KEY REFERENCES Takim(Id),
    Cmimi DECIMAL(20,5) NOT NULL,
    DataPagimit DATETIME,
    MetodaPagimitId TINYINT FOREIGN KEY REFERENCES MetodePagimi(Id),
);

CREATE INDEX TakimFature ON Fature (TakimId);
CREATE INDEX MetodaPagimitFatures ON Fature (MetodaPagimitId);


CREATE TABLE TurnOrari (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    Emri VARCHAR(55) NOT NULL,
    OraFilluese TIME NOT NULL,
    OraPerfundimtare TIME NOT NULL,

	CONSTRAINT KohezgjatjeMinimale CHECK (DATEDIFF(MINUTE, OraFilluese, OraPerfundimtare) >= 10),
);

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


CREATE TABLE AnamnezaFiziologjike (
    Id INT NOT NULL IDENTITY PRIMARY KEY,
    PacientId INT NOT NULL FOREIGN KEY REFERENCES Pacient(PersonId),
    StafiPergjegjesId INT NOT NULL FOREIGN KEY REFERENCES Staf(PersonId),
    DataKrijimit DATETIME NOT NULL,
    SistemiFrymemarrjes VARCHAR(MAX),
    SistemiGjenitourinar VARCHAR(MAX),
    SistemiTretes VARCHAR(MAX),
    SistemiOkular VARCHAR(MAX),
    SistemiNeurologjik VARCHAR(MAX),
    SistemiOrl VARCHAR(MAX),
    SistemiPsikiatrik VARCHAR(MAX),
    SistemiKardiovaskular VARCHAR(MAX),
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
    MoshaDiagnozes TINYINT,
    ShkakuVdekjes VARCHAR(80),
    DataVdekjes DATE,
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
    Pershkrimi VARCHAR(MAX),
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE,
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
    DataPerfundimit DATE,
    MarrePaRecete BIT NOT NULL,
);

CREATE INDEX AnamnezaPacientit ON AnamnezaFarmakologjike (PacientId);
CREATE INDEX StafiAnamnezes ON AnamnezaFarmakologjike (StafiPergjegjesId);