CREATE DATABASE Spitali;
USE Spitali;

CREATE TABLE Gjinia (
    Id TINYINT NOT NULL,
    Emertimi CHAR(8) NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE DiteJave (
    Id TINYINT NOT NULL,
    Emertimi CHAR(7) NOT NULL
);


CREATE TABLE MetodePagimi (
    Id TINYINT NOT NULL,
    Emertimi CHAR(6) NOT NULL
);


CREATE TABLE Pacient (
    PersonId INTEGER NOT NULL,
    Nid CHAR(10) NOT NULL,
    DataRegjistrimit DATE NOT NULL,
    Profesioni NVARCHAR,
    Vendbanimi NVARCHAR,
    GrupiGjakut CHAR(3),
    PRIMARY KEY (personid)
);

ALTER TABLE Pacient
    ADD UNIQUE (nid);


CREATE TABLE staf (
    PersonId INTEGER NOT NULL,
    Departamentid INTEGER NOT NULL,
    RolId TINYINT NOT NULL,
    DataPunesimit DATE NOT NULL,
    Rroga NUMERIC(15,4) NOT NULL,
    Specialiteti NVARCHAR,
    PRIMARY KEY (personid)
);

CREATE INDEX ON staf
    (departamentid);
CREATE INDEX ON staf
    (rolid);


CREATE TABLE Person (
    Id INTEGER NOT NULL,
    Emri NVARCHAR NOT NULL,
    Mbiemri NVARCHAR NOT NULL,
    Datelindja DATE NOT NULL,
    NrTelefoni NUMERTELEFONI NOT NULL,
    GjiniaId TINYINT NOT NULL,
    DataKrijimit DATETIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON person
    (gjiniaid);


CREATE TABLE Takim (
    Id INTEGER NOT NULL,
    DataKrijimit DATETIME NOT NULL,
    DataTakimit DATETIME NOT NULL,
    DoktorId INTEGER NOT NULL,
    InfermierId INTEGER,
    PacientId INTEGER NOT NULL,
    RecepsionistiId INTEGER NOT NULL,
    ProcedureId CHAR(5) NOT NULL,
    ShqetesimiKryesor NVARCHAR,
    KohezgjatjaShqetesimit NVARCHAR,
    SimptomaTeLidhura NVARCHAR,
    Konkluzioni NVARCHAR,
    EshteAnulluar boolean NOT NULL,
    Column1  NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE Takim
    ADD UNIQUE (datatakimit, doktorid);

CREATE INDEX ON takim
    (infermierid);
CREATE INDEX ON takim
    (pacientid);
CREATE INDEX ON takim
    (recepsionistiid);
CREATE INDEX ON takim
    (procedureid);


CREATE TABLE TurnOrari (
    Id INTEGER NOT NULL,
    Emri NVARCHAR NOT NULL,
    OraFilluese time without time zone NOT NULL,
    OraPerfundimtare time without time zone NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE DiteTurni (
    TurnOrarId INTEGER NOT NULL,
    DiteJaveId TINYINT NOT NULL,
    PRIMARY KEY (turnorarid, ditejaveid)
);


CREATE TABLE Orar (
    TurnOrarId INTEGER NOT NULL,
    StafId INTEGER NOT NULL,
    PRIMARY KEY (turnorarid, stafid)
);


CREATE TABLE Departament (
    Id INTEGER NOT NULL,
    DrejtuesId INTEGER NOT NULL,
    Emri NVARCHAR NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE Departament
    ADD UNIQUE (emri);

CREATE INDEX ON Departament
    (drejtuesid);


CREATE TABLE AnamnezaFiziologjike (
    Id INTEGER NOT NULL,
    PacientId INTEGER NOT NULL,
    StafiPergjigjesId INTEGER NOT NULL,
    DataKrijimit DATETIME NOT NULL,
    SistemiFrymemarrjes NVARCHAR,
    SistemiGjenitourinar NVARCHAR,
    SistemiTretes NVARCHAR,
    SistemiOkular NVARCHAR,
    SistemiNeurologjik NVARCHAR,
    SistemiOrl NVARCHAR,
    SistemiPsikiatrik NVARCHAR,
    SistemiKardiovaskular NVARCHAR NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON AnamnezaFiziologjike
    (PacientId);
CREATE INDEX ON AnamnezaFiziologjike
    (StafiPergjigjesId);


CREATE TABLE Anamnezafamiljare (
    Id INTEGER NOT NULL,
    PacientId INTEGER NOT NULL,
    StafiPergjigjesId INTEGER NOT NULL,
    LidhjaFamiljare NVARCHAR NOT NULL,
    Datelindja DATE NOT NULL,
    Semundja NVARCHAR NOT NULL,
    MoshaDiagnozes TINYINT,
    ShkakuVdekjes NVARCHAR,
    DataVdekjes DATE,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezafamiljare
    (pacientid);
CREATE INDEX ON anamnezafamiljare
    (stafipergjigjesid);


CREATE TABLE AnamnezaSemundjes (
    Id INTEGER NOT NULL,
    PacientId INTEGER NOT NULL,
    StafiPergjigjesId INTEGER NOT NULL,
    Semundja NVARCHAR NOT NULL,
    DataDiagnozes DATE NOT NULL,
    EshteKronike boolean NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezasemundjes
    (pacientid);
CREATE INDEX ON anamnezasemundjes
    (stafipergjigjesid);


CREATE TABLE AnamnezaAbuzimit (
    Id INTEGER NOT NULL,
    PacientId INTEGER NOT NULL,
    StafiPergjigjesId INTEGER NOT NULL,
    Substanca NVARCHAR NOT NULL,
    Pershkrimi NVARCHAR,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezaabuzimit
    (pacientid);
CREATE INDEX ON anamnezaabuzimit
    (stafipergjigjesid);


CREATE TABLE AnamnezaFarmakologjike (
    Id INTEGER NOT NULL,
    PacientId INTEGER NOT NULL,
    StafiPergjigjesId INTEGER NOT NULL,
    Ilaci NVARCHAR NOT NULL,
    Doza NVARCHAR NOT NULL,
    Arsyeja NVARCHAR NOT NULL,
    DataFillimit DATE NOT NULL,
    DataPerfundimit DATE,
    MarrePaRecete boolean NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezafarmakologjike
    (pacientid);
CREATE INDEX ON anamnezafarmakologjike
    (stafipergjigjesid);


CREATE TABLE procedure (
    Kodi CHAR(5) NOT NULL,
    Emri NVARCHAR NOT NULL,
    Pershkrimi NVARCHAR,
    Cmimi NUMERIC(20,2) NOT NULL,
    PRIMARY KEY (kodi)
);


CREATE TABLE fature (
    Id INTEGER NOT NULL,
    Takimiid INTEGER NOT NULL,
    KodProcedure CHAR(5) NOT NULL,
    Cmimi NUMERIC(20,5) NOT NULL,
    DataSherbimit DATE NOT NULL,
    DataPagimit DATETIME,
    MetodaPagimitId TINYINT,
    PRIMARY KEY (id)
);

CREATE INDEX ON fature
    (takimiid);
CREATE INDEX ON fature
    (kodprocedure);
CREATE INDEX ON fature
    (metodapagimitid);


CREATE TABLE rolstafi (
    Id TINYINT NOT NULL,
    Emri NVARCHAR NOT NULL
);


CREATE TABLE Adrese (
    PacientId INTEGER NOT NULL,
    Rruga NVARCHAR NOT NULL,
    Qyteti NVARCHAR NOT NULL,
    InformacionShtese NVARCHAR,
    PRIMARY KEY (pacientid)
);