USE Spitali;

bulk insert [dbo].[Sherbim]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\sherbim.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from Sherbim

bulk insert [dbo].[Departament]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\departament.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	KEEPIDENTITY
);
select * from Departament



bulk insert [dbo].[Person]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\person.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	KEEPIDENTITY,
	CHECK_CONSTRAINTS
);
select * from Person

bulk insert [dbo].[Staf]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\staf.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Staf

bulk insert [dbo].[Pacient]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\pacient.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from Pacient

bulk insert [dbo].[Adrese]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\adrese.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from Adrese



bulk insert [dbo].[Takim]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\takim.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	KEEPIDENTITY
);
select * from Takim

bulk insert [dbo].[Fature]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\fature.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from Fature



bulk insert [dbo].[TurnOrari]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\turn_orari.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	KEEPIDENTITY,
	CHECK_CONSTRAINTS
);
select * from TurnOrari

bulk insert [dbo].[Orar]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\orar.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from Orar

bulk insert [dbo].[DiteTurni]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\dite_turni.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from DiteTurni



bulk insert [dbo].[AnamnezaAbuzimit]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\anamneza_abuzimit.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from AnamnezaAbuzimit;

bulk insert [dbo].[AnamnezaFarmakologjike]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\anamneza_farmakologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from AnamnezaFarmakologjike

bulk insert [dbo].[AnamnezaSemundjes]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\anamneza_semundjes.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from AnamnezaSemundjes

bulk insert [dbo].[AnamnezaFamiljare]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\anamneza_familjare.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from AnamnezaFamiljare

bulk insert [dbo].[AnamnezaFiziologjike]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\tables_data_csv\anamneza_fiziologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2,           -- If your CSV file has headers, start from the second row
	CHECK_CONSTRAINTS
);
select * from AnamnezaFiziologjike