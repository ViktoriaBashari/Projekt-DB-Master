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


CREATE TABLE anamnezafamiljare (
    id INTEGER NOT NULL,
    pacientid INTEGER NOT NULL,
    stafipergjigjesid INTEGER NOT NULL,
    lidhjafamiljare NVARCHAR NOT NULL,
    datelindja DATE NOT NULL,
    semundja NVARCHAR NOT NULL,
    moshadiagnozes TINYINT,
    shkakuvdekjes NVARCHAR,
    datavdekjes DATE,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezafamiljare
    (pacientid);
CREATE INDEX ON anamnezafamiljare
    (stafipergjigjesid);


CREATE TABLE anamnezasemundjes (
    id INTEGER NOT NULL,
    pacientid INTEGER NOT NULL,
    stafipergjigjesid INTEGER NOT NULL,
    semundja NVARCHAR NOT NULL,
    datadiagnozes DATE NOT NULL,
    eshtekronike boolean NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezasemundjes
    (pacientid);
CREATE INDEX ON anamnezasemundjes
    (stafipergjigjesid);


CREATE TABLE anamnezaabuzimit (
    id INTEGER NOT NULL,
    pacientid INTEGER NOT NULL,
    stafipergjigjesid INTEGER NOT NULL,
    substanca NVARCHAR NOT NULL,
    pershkrimi NVARCHAR,
    datafillimit DATE NOT NULL,
    dataperfundimit DATE,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezaabuzimit
    (pacientid);
CREATE INDEX ON anamnezaabuzimit
    (stafipergjigjesid);


CREATE TABLE anamnezafarmakologjike (
    id INTEGER NOT NULL,
    pacientid INTEGER NOT NULL,
    stafipergjigjesid INTEGER NOT NULL,
    ilaci NVARCHAR NOT NULL,
    doza NVARCHAR NOT NULL,
    arsyeja NVARCHAR NOT NULL,
    datafillimit DATE NOT NULL,
    dataperfundimit DATE,
    marreparecete boolean NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezafarmakologjike
    (pacientid);
CREATE INDEX ON anamnezafarmakologjike
    (stafipergjigjesid);


CREATE TABLE procedure (
    kodi CHAR(5) NOT NULL,
    emri NVARCHAR NOT NULL,
    pershkrimi NVARCHAR,
    cmimi NUMERIC(20,2) NOT NULL,
    PRIMARY KEY (kodi)
);


CREATE TABLE fature (
    id INTEGER NOT NULL,
    takimiid INTEGER NOT NULL,
    kodprocedure CHAR(5) NOT NULL,
    cmimi NUMERIC(20,5) NOT NULL,
    datasherbimit DATE NOT NULL,
    datapagimit DATETIME,
    metodapagimitid TINYINT,
    PRIMARY KEY (id)
);

CREATE INDEX ON fature
    (takimiid);
CREATE INDEX ON fature
    (kodprocedure);
CREATE INDEX ON fature
    (metodapagimitid);


CREATE TABLE rolstafi (
    id TINYINT NOT NULL,
    emri NVARCHAR NOT NULL
);


CREATE TABLE adrese (
    pacientid INTEGER NOT NULL,
    rruga NVARCHAR NOT NULL,
    qyteti NVARCHAR NOT NULL,
    informacionshtese NVARCHAR,
    PRIMARY KEY (pacientid)
);