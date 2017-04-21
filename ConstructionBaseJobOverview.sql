
-----------------------------------------------------------------------
---					Drop des clés étrangères						---
-----------------------------------------------------------------------

if exists (select 1 from sys.all_objects where name = 'Annexe_ActiviteAnnexe_FK')
	ALTER TABLE jo.Annexe DROP CONSTRAINT Annexe_ActiviteAnnexe_FK
GO
if exists (select 1 from sys.all_objects where name = 'Annexe_Tache_FK')
	ALTER TABLE jo.Annexe DROP CONSTRAINT Annexe_Tache_FK
GO
if exists (select 1 from sys.all_objects where name = 'Equipe_Filière_FK')
	ALTER TABLE jo.Equipe DROP CONSTRAINT Equipe_Filière_FK
GO
if exists (select 1 from sys.all_objects where name = 'Equipe_Servic_FK')
	ALTER TABLE jo.Equipe DROP CONSTRAINT Equipe_Servic_FK
GO
if exists (select 1 from sys.all_objects where name = 'Logiciel_Filière_FK')
	ALTER TABLE jo.Logiciel DROP CONSTRAINT Logiciel_Filière_FK
GO
if exists (select 1 from sys.all_objects where name = 'FK_ASS_6')
	ALTER TABLE jo.MetierActivite DROP CONSTRAINT FK_ASS_6
GO
if exists (select 1 from sys.all_objects where name = 'FK_ASS_5')
	ALTER TABLE jo.MetierActivite DROP CONSTRAINT FK_ASS_5
GO
if exists (select 1 from sys.all_objects where name = 'Module_Module_FK')
	ALTER TABLE jo.Module DROP CONSTRAINT Module_Module_FK
GO
if exists (select 1 from sys.all_objects where name = 'Module_Logiciel_FK')
	ALTER TABLE jo.Module DROP CONSTRAINT Module_Logiciel_FK
GO
if exists (select 1 from sys.all_objects where name = 'Personne_Métier_FK')
	ALTER TABLE jo.Personne DROP CONSTRAINT Personne_Métier_FK
GO
if exists (select 1 from sys.all_objects where name = 'Personne_Personne_FK')
	ALTER TABLE jo.Personne DROP CONSTRAINT Personne_Personne_FK
GO
if exists (select 1 from sys.all_objects where name = 'Production_Versio_FK')
	ALTER TABLE jo.Production DROP CONSTRAINT Production_Versio_FK
GO
if exists (select 1 from sys.all_objects where name = 'Production_Activite_FK')
	ALTER TABLE jo.Production DROP CONSTRAINT Production_Activite_FK
GO
if exists (select 1 from sys.all_objects where name = 'Production_Module_FK')
	ALTER TABLE jo.Production DROP CONSTRAINT Production_Module_FK
GO
if exists (select 1 from sys.all_objects where name = 'Production_Tache_FK')
	ALTER TABLE jo.Production DROP CONSTRAINT Production_Tache_FK
GO
if exists (select 1 from sys.all_objects where name = 'FK_ASS_7')
	ALTER TABLE jo.Productivité DROP CONSTRAINT FK_ASS_7
GO
if exists (select 1 from sys.all_objects where name = 'FK_ASS_8')
	ALTER TABLE jo.Productivité DROP CONSTRAINT FK_ASS_8
GO
if exists (select 1 from sys.all_objects where name = 'Releas_Versio_FK')
	ALTER TABLE jo.Releas DROP CONSTRAINT Releas_Versio_FK
GO
if exists (select 1 from sys.all_objects where name = 'TempsPasse_Tache_FK')
	ALTER TABLE jo.TempsPasse DROP CONSTRAINT TempsPasse_Tache_FK
GO
if exists (select 1 from sys.all_objects where name = 'TempsPasse_Personne_FK')
	ALTER TABLE jo.TempsPasse DROP CONSTRAINT TempsPasse_Personne_FK
GO
if exists (select 1 from sys.all_objects where name = 'Versio_Logiciel_FK')
	ALTER TABLE jo.Versio DROP CONSTRAINT Versio_Logiciel_FK
GO


-----------------------------------------------------------------------
---							Drop des tables							---
-----------------------------------------------------------------------


if exists (select 1 from sys.all_objects where name = 'Activite')
	DROP TABLE jo.Activite
GO
if exists (select 1 from sys.all_objects where name = 'ActiviteAnnexe')
	DROP TABLE jo.ActiviteAnnexe
GO
if exists (select 1 from sys.all_objects where name = 'Annexe')
	DROP TABLE jo.Annexe
GO
if exists (select 1 from sys.all_objects where name = 'Equipe')
	DROP TABLE jo.Equipe
GO
if exists (select 1 from sys.all_objects where name = 'Filière')
	DROP TABLE jo.Filière
GO
if exists (select 1 from sys.all_objects where name = 'Logiciel')
	DROP TABLE jo.Logiciel
GO
if exists (select 1 from sys.all_objects where name = 'Métier')
	DROP TABLE jo.Métier
GO
if exists (select 1 from sys.all_objects where name = 'MetierActivite')
	DROP TABLE jo.MetierActivite
GO
if exists (select 1 from sys.all_objects where name = 'Module')
	DROP TABLE jo.Module
GO
if exists (select 1 from sys.all_objects where name = 'Personne')
	DROP TABLE jo.Personne
GO
if exists (select 1 from sys.all_objects where name = 'Production')
	DROP TABLE jo.Production
GO
if exists (select 1 from sys.all_objects where name = 'Productivité')
	DROP TABLE jo.Productivité
GO
if exists (select 1 from sys.all_objects where name = 'Releas')
	DROP TABLE jo.Releas
GO
if exists (select 1 from sys.all_objects where name = 'Servic')
	DROP TABLE jo.Servic
GO
if exists (select 1 from sys.all_objects where name = 'Tache')
	DROP TABLE jo.Tache
GO
if exists (select 1 from sys.all_objects where name = 'TempsPasse')
	DROP TABLE jo.TempsPasse
GO
if exists (select 1 from sys.all_objects where name = 'Versio')	
	DROP TABLE jo.Versio
GO


-----------------------------------------------------------------------
---					Test création/drop du schéma					---
-----------------------------------------------------------------------

go
if exists (select 1 from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME= 'jo')
	drop SCHEMA jo
go

go
	CREATE SCHEMA jo
go



-----------------------------------------------------------------------
---				Créations des tables et clés primaires				---
-----------------------------------------------------------------------


CREATE TABLE jo.Activite
  (
    Code NVARCHAR (20) NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Activite ADD CONSTRAINT Activite_PK PRIMARY KEY CLUSTERED (Code)
GO

CREATE TABLE jo.ActiviteAnnexe
  (
    Code NVARCHAR (20) NOT NULL,
    Libelle NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.ActiviteAnnexe ADD CONSTRAINT ActiviteAnnexe_PK PRIMARY KEY CLUSTERED (Code)
GO

CREATE TABLE jo.Annexe
  (
    Id INTEGER NOT NULL ,
    ActiviteAnnexe_Code NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.Annexe ADD CONSTRAINT Annexe_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.Equipe
  (
    Id INTEGER NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL ,
    Servic_Id  INTEGER NOT NULL ,
    Filière_Id NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.Equipe ADD CONSTRAINT Equipe_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.Filière
  (
    Id NVARCHAR (20) NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Filière ADD CONSTRAINT Filière_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.Logiciel
  (
    Code NVARCHAR (20) NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL ,
    Filière_Id NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.Logiciel ADD CONSTRAINT Logiciel_PK PRIMARY KEY CLUSTERED (Code)
GO

CREATE TABLE jo.MetierActivite
  (
    Métier_Code NVARCHAR (20) NOT NULL ,
    Activite_Code NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.MetierActivite ADD CONSTRAINT MetierActivite_PK PRIMARY KEY CLUSTERED (Métier_Code, Activite_Code)
GO

CREATE TABLE jo.Module
  (
    CodeId NVARCHAR (20) NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL ,
    Logiciel_Code NVARCHAR (20) NOT NULL ,
    Module_CodeId NVARCHAR (20)
  )
GO
ALTER TABLE jo.Module ADD CONSTRAINT Module_PK PRIMARY KEY CLUSTERED (CodeId)
GO

CREATE TABLE jo.Métier
  (
    Code NVARCHAR (20) NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Métier ADD CONSTRAINT Métier_PK PRIMARY KEY CLUSTERED (Code)
GO

CREATE TABLE jo.Personne
  (
    Ident NVARCHAR (20) NOT NULL ,
    Nom NVARCHAR (50) NOT NULL ,
    Prenom NVARCHAR (50) NOT NULL ,
    Manager NVARCHAR (20) ,
    Métier_Code NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.Personne ADD CONSTRAINT Personne_PK PRIMARY KEY CLUSTERED (Ident)
GO

CREATE TABLE jo.Production
  (
    Id                     INTEGER NOT NULL ,
    Avancement             INTEGER NOT NULL ,
    PrevisionInitiale      INTEGER NOT NULL ,
    DureePrevue            INTEGER ,
    EstimationTempsRestant INTEGER ,
    DateDebut              DATE ,
    DateFin                DATE ,
    Activite_Code NVARCHAR (20) NOT NULL ,
    Module_CodeId NVARCHAR (20) NOT NULL ,
    Versio_IdUnique NVARCHAR (20) NOT NULL,
    Logiciel_Code NVARCHAR (20) NOT NULL
  )
GO
ALTER TABLE jo.Production ADD CONSTRAINT Production_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.Productivité
  (
    Equipe_Id INTEGER NOT NULL ,
    Personne_Ident NVARCHAR (20) NOT NULL ,
    DateArrivée DATE NOT NULL ,
    Taux        INTEGER NOT NULL
  )
  
GO
ALTER TABLE jo.Productivité ADD CONSTRAINT Productivité_PK PRIMARY KEY CLUSTERED (Equipe_Id, Personne_Ident)
GO

CREATE TABLE jo.Releas
  (
    Id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION ,
    Numero SMALLINT NOT NULL,
    Versio_IdUnique NVARCHAR (20) NOT NULL ,
    Logiciel_Code NVARCHAR (20) NOT NULL ,
    DateCreation DATE NOT NULL
  )
GO
ALTER TABLE jo.Releas ADD CHECK ( Numero BETWEEN 1 AND 999 )
GO
ALTER TABLE jo.Releas ADD CONSTRAINT Releas_PK PRIMARY KEY CLUSTERED (Id,Versio_IdUnique)
GO

CREATE TABLE jo.Servic
  (
    Id INTEGER NOT NULL ,
    Libelle NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Servic ADD CONSTRAINT Servic_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.Tache
  (
    Id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION ,
    Libelle NVARCHAR (50) NOT NULL ,
    Descript NVARCHAR (50)
  )  
GO
ALTER TABLE jo.Tache ADD CONSTRAINT Tache_PK PRIMARY KEY CLUSTERED (Id)
GO

CREATE TABLE jo.TempsPasse
  (
    Tache_Id INTEGER NOT NULL ,
    Personne_Ident NVARCHAR (20) NOT NULL,
    Duree    DECIMAL ,
    Jour 	 DATE NOT NULL
  ) 
GO
ALTER TABLE jo.TempsPasse ADD CHECK ( Duree BETWEEN 0 AND 8)
GO
ALTER TABLE jo.TempsPasse ADD CONSTRAINT TempsPasse_PK PRIMARY KEY CLUSTERED (Tache_Id,Jour)
GO

CREATE TABLE jo.Versio
  (
    IdUnique NVARCHAR (20) NOT NULL ,
    Logiciel_Code NVARCHAR (20) NOT NULL ,
    Numero NVARCHAR (20) NOT NULL ,
    Millesime NVARCHAR (50) NOT NULL ,
    DateOuverture    DATE NOT NULL ,
    DateSortiePrevu  DATE NOT NULL ,
    DateSortieReelle DATE
  ) 
GO
ALTER TABLE jo.Versio ADD CONSTRAINT Versio_PK PRIMARY KEY CLUSTERED (IdUnique,Logiciel_Code)
GO


-----------------------------------------------------------------------
---				Création contrainte de clé étrangères				---
-----------------------------------------------------------------------


ALTER TABLE jo.Annexe
ADD CONSTRAINT Annexe_ActiviteAnnexe_FK FOREIGN KEY(ActiviteAnnexe_Code)
REFERENCES jo.ActiviteAnnexe(Code)
GO

ALTER TABLE jo.Annexe
ADD CONSTRAINT Annexe_Tache_FK FOREIGN KEY(Id)
REFERENCES jo.Tache(Id)
GO

ALTER TABLE jo.Equipe
ADD CONSTRAINT Equipe_Filière_FK FOREIGN KEY(Filière_Id)
REFERENCES jo.Filière(Id)
GO

ALTER TABLE jo.Equipe
ADD CONSTRAINT Equipe_Servic_FK FOREIGN KEY(Servic_Id)
REFERENCES jo.Servic(Id)
GO

ALTER TABLE jo.MetierActivite
ADD CONSTRAINT FK_ASS_5 FOREIGN KEY(Métier_Code)
REFERENCES jo.Métier(Code)
GO

ALTER TABLE jo.MetierActivite
ADD CONSTRAINT FK_ASS_6 FOREIGN KEY(Activite_Code)
REFERENCES jo.Activite(Code)
GO

ALTER TABLE jo.Productivité
ADD CONSTRAINT FK_ASS_7 FOREIGN KEY(Equipe_Id)
REFERENCES jo.Equipe(Id)
GO

ALTER TABLE jo.Productivité
ADD CONSTRAINT FK_ASS_8 FOREIGN KEY(Personne_Ident)
REFERENCES jo.Personne(Ident)
GO

ALTER TABLE jo.Logiciel
ADD CONSTRAINT Logiciel_Filière_FK FOREIGN KEY(Filière_Id)
REFERENCES jo.Filière(Id)
GO

ALTER TABLE jo.Module
ADD CONSTRAINT Module_Logiciel_FK FOREIGN KEY(Logiciel_Code)
REFERENCES jo.Logiciel(Code)
GO

ALTER TABLE jo.Module
ADD CONSTRAINT Module_Module_FK FOREIGN KEY(Module_CodeId)
REFERENCES jo.Module(CodeId)
GO

ALTER TABLE jo.Personne
ADD CONSTRAINT Personne_Métier_FK FOREIGN KEY(Métier_Code)
REFERENCES jo.Métier(Code)
GO

ALTER TABLE jo.Personne
ADD CONSTRAINT Personne_Personne_FK FOREIGN KEY(Manager)
REFERENCES jo.Personne(Ident)
GO

ALTER TABLE jo.Production
ADD CONSTRAINT Production_Activite_FK FOREIGN KEY(Activite_Code)
REFERENCES jo.Activite(Code)
GO

ALTER TABLE jo.Production
ADD CONSTRAINT Production_Module_FK FOREIGN KEY(Module_CodeId)
REFERENCES jo.Module(CodeId)
GO

ALTER TABLE jo.Production
ADD CONSTRAINT Production_Tache_FK FOREIGN KEY(Id)
REFERENCES jo.Tache(Id)
GO

ALTER TABLE jo.Production
ADD CONSTRAINT Production_Versio_FK FOREIGN KEY(Versio_IdUnique,Logiciel_Code)
REFERENCES jo.Versio(IdUnique ,Logiciel_Code)
GO

ALTER TABLE jo.Releas
ADD CONSTRAINT Releas_Versio_FK FOREIGN KEY(Versio_IdUnique,Logiciel_Code)
REFERENCES jo.Versio(IdUnique ,Logiciel_Code)
GO

ALTER TABLE jo.TempsPasse
ADD CONSTRAINT TempsPasse_Tache_FK FOREIGN KEY(Tache_Id)
REFERENCES jo.Tache(Id)
GO

ALTER TABLE jo.TempsPasse
ADD CONSTRAINT TempsPasse_Personne_FK FOREIGN KEY(Personne_Ident)
REFERENCES jo.Personne(Ident)
GO

ALTER TABLE jo.Versio
ADD CONSTRAINT Versio_Logiciel_FK FOREIGN KEY(Logiciel_Code)
REFERENCES jo.Logiciel(Code)
GO