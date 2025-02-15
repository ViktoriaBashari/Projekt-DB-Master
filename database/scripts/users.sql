USE Spitali;
GO

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

CREATE LOGIN DoktorBaze WITH PASSWORD='doktor';
CREATE USER DoktorBaze;
ALTER ROLE Doktor ADD MEMBER DoktorBaze;

CREATE LOGIN InfermierBaze WITH PASSWORD='infermier';
CREATE USER InfermierBaze;
ALTER ROLE Infermier ADD MEMBER InfermierBaze;

CREATE LOGIN PacientBaze WITH PASSWORD='pacient';
CREATE USER PacientBaze;
ALTER ROLE Pacient ADD MEMBER PacientBaze;