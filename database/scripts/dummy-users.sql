USE Spitali;
GO

-- Perdorues administrator
IF NOT EXISTS(
	SELECT 1
	FROM master.sys.sql_logins
	WHERE name = 'AdminBaze')
	CREATE LOGIN AdminBaze WITH PASSWORD = 'admin';

IF NOT EXISTS(
	SELECT 1
	FROM master.sys.database_principals
	WHERE name = 'AdminBaze')
	CREATE USER AdminBaze FOR LOGIN AdminBaze;

ALTER ROLE Administrator ADD MEMBER AdminBaze;

GO


-- Perdorues recepsionist
IF NOT EXISTS(
	SELECT 1
	FROM master.sys.sql_logins
	WHERE name = 'RecepsionistBaze')
	CREATE LOGIN RecepsionistBaze WITH PASSWORD = 'recepsionist';

IF NOT EXISTS(
	SELECT 1
	FROM master.sys.database_principals
	WHERE name = 'RecepsionistBaze')
	CREATE USER RecepsionistBaze FOR LOGIN RecepsionistBaze;

ALTER ROLE Recepsionist ADD MEMBER RecepsionistBaze;

GO


-- Perdorues doktor
IF NOT EXISTS(
	SELECT 1
	FROM master.sys.sql_logins
	WHERE name = 'DD003')
	CREATE LOGIN DD003 WITH PASSWORD='doktor';

IF NOT EXISTS(
	SELECT 1
	FROM master.sys.database_principals
	WHERE name = 'DD003')
	CREATE USER DD003 FOR LOGIN DD003;

ALTER ROLE Doktor ADD MEMBER DD003;


-- Perdorues infermier
IF NOT EXISTS(
	SELECT 1
	FROM master.sys.sql_logins
	WHERE name = 'IO001')
	CREATE LOGIN IO001 WITH PASSWORD='infermier';

IF NOT EXISTS(
	SELECT 1
	FROM master.sys.database_principals
	WHERE name = 'IO001')
	CREATE USER IO001 FOR LOGIN IO001;

ALTER ROLE Infermier ADD MEMBER IO001;



-- Perdorues pacient
IF NOT EXISTS(
	SELECT 1
	FROM master.sys.sql_logins
	WHERE name = 'J12345678R')
	CREATE LOGIN J12345678R WITH PASSWORD='pacient';

IF NOT EXISTS(
	SELECT 1
	FROM master.sys.database_principals
	WHERE name = 'J12345678R')
	CREATE USER J12345678R FOR LOGIN J12345678R;

ALTER ROLE Pacient ADD MEMBER J12345678R;