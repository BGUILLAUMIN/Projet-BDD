INSERT jo.Activite(Code, Libelle) VALUES
('DBE', 'Définition des besoins'),
('ARF', 'Architecture fonctionnelle'),
('ANF', 'Analyse fonctionnelle'),
('DES', 'Design'),
('INF', 'Infographie'),
('ART', 'Architecture technique'),
('ANT', 'Analyse technique'),
('DEV', 'Développement'),
('RPT', 'Rédaction de plan de test'),
('TES', 'Test')
GO

INSERT jo.Métier(Code, Libelle) VALUES
('ANA','Analyste'),
('CDP','Chef de projet'),
('DEV','Développeur'),
('DES','Designer'),
('TES','Testeur')
GO

INSERT jo.MetierActivite(Activite_Code, Métier_Code) VALUES
('DBE','ANA'),
('ARF','ANA'),
('ANF','ANA'),
('ARF','CDP'),
('ANF','CDP'),
('ART','CDP'),
('TES','CDP'),
('ANF','DEV'),
('ART','DEV'),
('ANT','DEV'),
('DEV','DEV'),
('TES','DEV'),
('ANF','DES'),
('DES','DES'),
('INF','DES'),
('RPT','TES'),
('TES','TES')
GO

INSERT jo.Personne (Ident, Métier_Code, Nom, Prenom, Manager) VALUES 
('GLECLERCK', 'ANA', 'LECLERCQ', 'Geneviève','RFISHER'),
('AFERRAND', 'ANA', 'FERRAND', 'Angèle','RBEAUMONT'),
('BNORMAND', 'CDP', 'NORMAND', 'Balthazar','RFISHER'),
('RFISHER', 'DEV', 'FISHER', 'Raymond',NULL),
('LBUTLER', 'DEV', 'BUTLER', 'Lucien','RFISHER'),
('RBEAUMONT', 'DEV', 'BEAUMONT', 'Roseline',NULL),
('MWEBER', 'DEV', 'WEBER', 'Marguerite','RFISHER'),
('HKLEIN', 'TES', 'KLEIN', 'Hilaire','RBEAUMONT'),
('NPALMER', 'TES', 'PALMER', 'Nino','RBEAUMONT')
GO

INSERT jo.Tache(Libelle) VALUES
('Construction du modèles conceptuel de donnée'),
('Adressage des requêtes serveur'),
('Debug logiciel'),
('Beta test du logiciel'),
('Echange d''idée autour d''un café'),
('Partie de flechette le midi'),
('Chasse aux crevette sous le soleil')
GO

INSERT jo.ActiviteAnnexe(Code, Libelle) VALUES
('GL','Glandouille')
GO

INSERT jo.Annexe(Id, ActiviteAnnexe_Code) VALUES
(5,'GL'),
(6,'GL'),
(7,'GL')
GO

INSERT jo.Filière(Id, Libelle) VALUES
('BIOH','Biologie humaine'),
('BIOV','Biologie végétale')
GO

INSERT jo.Servic(Id, Libelle) VALUES
(1,'Juridique'),
(2,'Comptabilité')
GO

INSERT jo.Equipe(Id, Filière_Id, Libelle, Servic_Id) VALUES
(1,'BIOH','Les dragons',1),
(2,'BIOV','Les faisants',1),
(3,'BIOV','Chouquettes',2)
GO

INSERT jo.Logiciel(Code, Libelle, Filière_Id) VALUES
('WIN','WINDOWS','BIOV')
GO

INSERT jo.Module(CodeId, Libelle, Logiciel_Code) VALUES
('SM','SERPENT MANCHOT','WIN'),
('PM','BREBIS GALEUSE','WIN')
GO

INSERT jo.Versio(IdUnique, Logiciel_Code, Numero, Millesime, DateOuverture, DateSortiePrevu, DateSortieReelle) VALUES
('10101010','WIN','2.02','2016','1997-10-24','1999-02-03','1999-04-17')
GO

INSERT jo.Production (ID, Activite_Code, Avancement, Module_CodeId, PrevisionInitiale,
Versio_IdUnique, Logiciel_Code) VALUES
(1,'DEV',0,'SM',15,'10101010','WIN'),
(2,'DEV',0,'PM',15,'10101010','WIN')
GO

INSERT jo.Productivité(Equipe_Id, Personne_Ident, DateArrivée, Taux) VALUES
(1,'AFERRAND','1987-10-21',100),
(2,'GLECLERCK','1987-10-21',100),
(2,'BNORMAND','1987-10-21',10),
(2,'RFISHER','1987-10-21',100),
(1,'LBUTLER','1987-10-21',100),
(1,'RBEAUMONT','1987-10-21',100),
(2,'MWEBER','1987-10-21',100),
(1,'HKLEIN','1987-10-21',100),
(1,'NPALMER','1987-10-21',80)
GO

INSERT jo.Releas (Numero,Versio_IdUnique, Logiciel_Code , DateCreation) VALUES
(1,'10101010','WIN','1996-03-04'),
(2,'10101010','WIN','1997-03-04'),
(3,'10101010','WIN','1998-03-04'),
(4,'10101010','WIN','1999-03-04')


GO

INSERT jo.TempsPasse (Tache_Id, Personne_Ident, Duree, Jour) VALUES
(2,'AFERRAND',6,'2001-01-01'),
(1,'GLECLERCK',4,'2000-01-01'),
(2,'AFERRAND',2,'2000-01-02'),
(3,'BNORMAND',3,'2000-01-03'),
(1,'LBUTLER',4,'2000-01-04'),
(5,'MWEBER',5,'2000-01-05'),
(6,'HKLEIN',6,'2000-01-06'),
(7,'NPALMER',7,'2000-01-07')


GO
