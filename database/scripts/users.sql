USE Spitali;
GO

CREATE LOGIN AdminBaze WITH PASSWORD='admin';
CREATE USER AdminBaze;
ALTER ROLE Administrator ADD MEMBER AdminBaze;

GO