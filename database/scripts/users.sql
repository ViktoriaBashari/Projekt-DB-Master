USE Spitali;
GO

CREATE LOGIN AdminBaze WITH PASSWORD='admin';
CREATE USER AdminBaze;
ALTER ROLE Administrator ADD MEMBER AdminBaze;

GO

CREATE LOGIN RecepsionistBaze WITH PASSWORD='recepsionist';
CREATE USER RecepsionistBaze;
ALTER ROLE Recepsionist ADD MEMBER RecepsionistBaze;

GO

CREATE LOGIN DoktorBaze WITH PASSWORD='doktor';
CREATE USER DoktorBaze;
ALTER ROLE Doktor ADD MEMBER DoktorBaze;

GO

CREATE LOGIN PacientBaze WITH PASSWORD='pacient';
CREATE USER PacientBaze;
ALTER ROLE Pacient ADD MEMBER PacientBaze;

GO

CREATE LOGIN InfermierBaze WITH PASSWORD='infermier';
CREATE USER InfermierBaze;
ALTER ROLE Infermier ADD MEMBER InfermierBaze;

GO