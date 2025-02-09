bulk insert [dbo].[Person]
FROM 'database\tables_data_csv\person.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Person

bulk insert [dbo].[Sherbim]
FROM 'database\tables_data_csv\sherbim.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Sherbim

bulk insert [dbo].[Staf]
FROM 'database\tables_data_csv\staf.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Staf

bulk insert [dbo].[Departament]
FROM 'database\tables_data_csv\departament.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Departament

bulk insert [dbo].[Adrese]
FROM 'database\tables_data_csv\adrese.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Adrese

bulk insert [dbo].[DiteTurni]
FROM 'database\tables_data_csv\dite_turni.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from DiteTurni

bulk insert [dbo].[Pacient]
FROM 'database\tables_data_csv\pacient.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Pacient

bulk insert [dbo].[Takim]
FROM 'database\tables_data_csv\takim_cleaned.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);

use Spitali;
select * from Takim

bulk insert [dbo].[TurnOrari]
FROM 'database\tables_data_csv\turn_orari.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from TurnOrari

bulk insert [dbo].[Orar]
FROM 'database\tables_data_csv\orar.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Orar

bulk insert [dbo].[fature]
FROM 'database\tables_data_csv\fature.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from Fature


bulk insert [dbo].[AnamnezaAbuzimit]
FROM 'database\tables_data_csv\anamneza_abuzimit.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from AnamnezaAbuzimit

bulk insert [dbo].[AnamnezaFarmakologjike]
FROM 'database\tables_data_csv\anamneza_farmakologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from AnamnezaFarmakologjike

bulk insert [dbo].[AnamnezaSemundjes]
FROM 'database\tables_data_csv\anamneza_semundjes.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from AnamnezaSemundjes

bulk insert [dbo].[AnamnezaFamiljare]
FROM 'database\tables_data_csv\anamneza_familjare.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from AnamnezaFamiljare

bulk insert [dbo].[AnamnezaFiziologjike]
FROM 'database\tables_data_csv\anamneza_fiziologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- The delimiter used in your CSV file
    ROWTERMINATOR = '\n',   -- The line break character
    FIRSTROW = 2           -- If your CSV file has headers, start from the second row
);
select * from AnamnezaFiziologjike