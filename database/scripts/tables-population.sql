USE Spitali;

BULK INSERT [dbo].[Sherbim]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\sherbim.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM Sherbim

BULK INSERT [dbo].[Departament]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\departament.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	KEEPIDENTITY
);
SELECT * FROM Departament



BULK INSERT [dbo].[Person]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\person.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	KEEPIDENTITY,
	CHECK_CONSTRAINTS
);
SELECT * FROM Person

BULK INSERT [dbo].[Staf]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\staf.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);
SELECT * FROM Staf

BULK INSERT [dbo].[Pacient]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\pacient.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM Pacient

BULK INSERT [dbo].[Adrese]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\adrese.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM Adrese



BULK INSERT [dbo].[Takim]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\takim.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	KEEPIDENTITY
);
SELECT * FROM Takim

BULK INSERT [dbo].[Fature]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\fature.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM Fature



BULK INSERT [dbo].[TurnOrari]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\turn_orari.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	KEEPIDENTITY,
	CHECK_CONSTRAINTS
);
SELECT * FROM TurnOrari

BULK INSERT [dbo].[Orar]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\orar.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM Orar

BULK INSERT [dbo].[DiteTurni]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\dite_turni.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM DiteTurni



BULK INSERT [dbo].[AnamnezaAbuzimit]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\anamneza_abuzimit.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2, 
	CHECK_CONSTRAINTS
);
SELECT * FROM AnamnezaAbuzimit;

BULK INSERT [dbo].[AnamnezaFarmakologjike]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\anamneza_farmakologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM AnamnezaFarmakologjike

BULK INSERT [dbo].[AnamnezaSemundjes]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\anamneza_semundjes.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM AnamnezaSemundjes

BULK INSERT [dbo].[AnamnezaFamiljare]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\anamneza_familjare.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM AnamnezaFamiljare

BULK INSERT [dbo].[AnamnezaFiziologjike]
FROM 'C:\Users\DELL\Documents\GitHub\Projekt-DB-Master\database\dummy_data\anamneza_fiziologjike.csv'
WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,           
	CHECK_CONSTRAINTS
);
SELECT * FROM AnamnezaFiziologjike