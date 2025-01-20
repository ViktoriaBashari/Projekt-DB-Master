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


CREATE TABLE pacient (
    personid INTEGER NOT NULL,
    nid CHAR(10) NOT NULL,
    dataregjistrimit DATE NOT NULL,
    profesioni NVARCHAR,
    vendbanimi NVARCHAR,
    grupigjakut CHAR(3),
    PRIMARY KEY (personid)
);

ALTER TABLE pacient
    ADD UNIQUE (nid);


CREATE TABLE staf (
    personid INTEGER NOT NULL,
    departamentid INTEGER NOT NULL,
    rolid TINYINT NOT NULL,
    datapunesimit DATE NOT NULL,
    rroga NUMERIC(15,4) NOT NULL,
    specialiteti NVARCHAR,
    PRIMARY KEY (personid)
);

CREATE INDEX ON staf
    (departamentid);
CREATE INDEX ON staf
    (rolid);


CREATE TABLE person (
    id INTEGER NOT NULL,
    emri NVARCHAR NOT NULL,
    mbiemri NVARCHAR NOT NULL,
    datelindja DATE NOT NULL,
    nrtelefoni NUMERTELEFONI NOT NULL,
    gjiniaid TINYINT NOT NULL,
    datakrijimit DATETIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON person
    (gjiniaid);


CREATE TABLE takim (
    id INTEGER NOT NULL,
    datakrijimit DATETIME NOT NULL,
    datatakimit DATETIME NOT NULL,
    doktorid INTEGER NOT NULL,
    infermierid INTEGER,
    pacientid INTEGER NOT NULL,
    recepsionistiid INTEGER NOT NULL,
    procedureid CHAR(5) NOT NULL,
    shqetesimikryesor NVARCHAR,
    kohezgjatjashqetesimit NVARCHAR,
    simptomatelidhura NVARCHAR,
    konkluzioni NVARCHAR,
    eshteanulluar boolean NOT NULL,
    column1  NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE takim
    ADD UNIQUE (datatakimit, doktorid);

CREATE INDEX ON takim
    (infermierid);
CREATE INDEX ON takim
    (pacientid);
CREATE INDEX ON takim
    (recepsionistiid);
CREATE INDEX ON takim
    (procedureid);


CREATE TABLE turnorari (
    id INTEGER NOT NULL,
    emri NVARCHAR NOT NULL,
    orafilluese time without time zone NOT NULL,
    oraperfundimtare time without time zone NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE diteturni (
    turnorarid INTEGER NOT NULL,
    ditejaveid TINYINT NOT NULL,
    PRIMARY KEY (turnorarid, ditejaveid)
);


CREATE TABLE orar (
    turnorarid INTEGER NOT NULL,
    stafid INTEGER NOT NULL,
    PRIMARY KEY (turnorarid, stafid)
);


CREATE TABLE departament (
    id INTEGER NOT NULL,
    drejtuesid INTEGER NOT NULL,
    emri NVARCHAR NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE departament
    ADD UNIQUE (emri);

CREATE INDEX ON departament
    (drejtuesid);


CREATE TABLE anamnezafiziologjike (
    id INTEGER NOT NULL,
    pacientid INTEGER NOT NULL,
    stafipergjigjesid INTEGER NOT NULL,
    datakrijimit DATETIME NOT NULL,
    sistemifrymemarrjes NVARCHAR,
    sistemigjenitourinar NVARCHAR,
    sistemitretes NVARCHAR,
    sistemiokular NVARCHAR,
    sistemineurologjik NVARCHAR,
    sistemiorl NVARCHAR,
    sistemipsikiatrik NVARCHAR,
    sistemikardiovaskular NVARCHAR NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON anamnezafiziologjike
    (pacientid);
CREATE INDEX ON anamnezafiziologjike
    (stafipergjigjesid);


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