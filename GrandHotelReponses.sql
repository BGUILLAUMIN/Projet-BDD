---------------------------------------------------------------------------
---					Requ�tage sur la base Grand-H�tel					---
---------------------------------------------------------------------------

---
--- NB : Il faut ex�cuter les blocs d'instruction en entier !
---		un bloc est d�limit� par 2 commentaires Identifi�  : --A, --B, etc
---


--------------- 		   Clients et coordonn�es	    	---------------

	--A.	Clients pour lesquels on n�a pas de num�ro de portable (id, nom) 

	select C.CLI_ID,CLI_NOM from CLIENT C
	inner join TELEPHONE T on C.CLI_ID = T.CLI_ID
	where TEL_NUMERO is null
	--A

	--B.	Clients pour lesquels on a au moins un N� de portable ou une adresse mail

	select distinct C.CLI_ID,CLI_NOM from CLIENT C
	inner join TELEPHONE T on C.CLI_ID = T.CLI_ID
	inner join EMAIL E on C.CLI_ID = E.CLI_ID
	where T.TYP_CODE = 'GSM' or E.EML_ADRESSE is not null
	--B

	--C.	Mettre � jour les num�ros de t�l�phone pour qu�ils soient au format 
	--		� +33XXXXXXXXX � au lieu de � 0X-XX-XX-XX-XX � 

	UPDATE TELEPHONE set
		TEL_NUMERO = (select '+33'+SUBSTRING(REPLACE(TEL_NUMERO,'-',''),2,9) 
						from TELEPHONE T where TELEPHONE.TEL_ID = T.TEL_ID)
	--C

	--D.	Clients qui ont pay� avec au moins deux moyens de paiement diff�rents 
	--		au cours d�un m�me mois (id, nom)

	Select Distinct C.CLI_ID,CLI_NOM from CLIENT C
	inner join FACTURE F on C.CLI_ID = F.CLI_ID
	group by C.CLI_ID,CLI_NOM
	Having COUNT(Distinct PMCODE) > 1
	--D

	--E.	Clients de la m�me ville qui se sont d�j� retrouv�s en m�me temps � l�h�tel

	Create view vw_AdresseToChambPlanning (CLI_NOM ,CLI_ID, ADR_VILLE, PLN_JOUR)
	as Select
	C.CLI_NOM ,A.CLI_ID, A.ADR_VILLE, CH.PLN_JOUR from ADRESSE A
	inner join CLIENT C on A.CLI_ID = C.CLI_ID
	inner join CHB_PLN_CLI CH on C.CLI_ID = CH.CLI_ID
GO


	select Distinct CLI_NOM, ATP.ADR_VILLE from(
	select V.ADR_VILLE,V.PLN_JOUR from (
		select CLI_ID, ADR_VILLE, PLN_JOUR 
		from vw_AdresseToChambPlanning
		group by CLI_ID, ADR_VILLE, PLN_JOUR) V
	group by V.ADR_VILLE, V.PLN_JOUR
	Having COUNT(*) >1) C
	inner join vw_AdresseToChambPlanning ATP on C.ADR_VILLE = ATP.ADR_VILLE 
		and C.PLN_JOUR = ATP.PLN_JOUR
	order by ATP.ADR_VILLE

	drop view vw_AdresseToChambPlanning
	--E


--------------- 			   Fr�quentation		    	---------------


	-- A.	Taux moyen d�occupation de l�h�tel par mois-ann�e.
	--		Autrement dit, pour chaque mois-ann�e valeur moyenne 
	--		sur les chambres du ratio (nombre de jours d'occupation dans le mois / nombre de jours du mois)

	-- Cr�ation d'une table temporaire pour stocker les donn�es n�cessaires aux calculs et l'affichage

	CREATE TABLE #TempOccupChambre (
	CHB_ID int,
	Mois int,
	Annee int,
	Occup int,
	);
GO
	-- Remplissage de la table temporaire avec les valeurs ad�quates
	insert into #TempOccupChambre 
	select CHB_ID, MONTH(PLN_JOUR) Mois,YEAR(PLN_JOUR) An, COUNT(DAY(PLN_JOUR)) Occ from CHB_PLN_CLI
	group by MONTH(PLN_JOUR),YEAR(PLN_JOUR),CHB_ID
	order by YEAR(PLN_JOUR),MONTH(PLN_JOUR)

	-- Transformation du champs Occup en pourcentage d'occupation par chambre, mois et ann�e
	UPDATE #TempOccupChambre set Occup = 
		Case 
		   when #TempOccupChambre.Mois = 2 THEN (100*Occup)/28
		   when #TempOccupChambre.Mois in (4,6,9,11) THEN (100*Occup)/30
		   ELSE (100*Occup)/31
		   END

	-- Moyenne et affichage des r�sultats attendu : Taux moyen d�occupation de l�h�tel par mois-ann�e.
	select convert(nvarchar,AVG(Occup))+'%' as Taux ,Mois,Annee from #TempOccupChambre
	group by Mois,Annee
	order by 3,2

	-- Drop de la table temporaire : lib�ration de la m�moire
	drop table #TempOccupChambre
	--A


	--B.	Taux moyen d�occupation de chaque �tage par ann�e

	-- /!\ Si jamais une somme de pourcentage n'atteind pas 100% c'est a cause des arrondis /!\
	-- Cr�ation d'une table temporaire pour stocker les donn�es n�cessaires aux calculs et l'affichage
	
	CREATE TABLE #TempOccupEtage (
	CHB_ETAGE Char(3),
	Annee int,
	Occup DECIMAL
	);
GO

	-- Remplissage de la table temporaire avec les valeurs ad�quates
	insert into #TempOccupEtage 
	select  CHB_ETAGE, YEAR(PLN_JOUR) An, CAST(COUNT(DAY(PLN_JOUR)) as DECIMAL) Occ from CHB_PLN_CLI CH
	inner join CHAMBRE C on CH.CHB_ID = C.CHB_ID
	group by YEAR(PLN_JOUR), CHB_ETAGE
	order by YEAR(PLN_JOUR), CHB_ETAGE

	-- Transformation du champs Occup en pourcentage d'occupation par �tage et ann�e
	UPDATE #TempOccupEtage set Occup = 
	(100.00*Occup) / (select SUM(Occup) from #TempOccupEtage T 
	where #TempOccupEtage.Annee = T.Annee
	group by Annee)

	-- Affichage des r�sultats attendu : Taux moyen d�occupation de chaque �tage par ann�e.
	select convert(nvarchar,Occup,2)+'%' as Taux ,Annee ,CHB_ETAGE from #TempOccupEtage
	order by Annee, CHB_ETAGE

	-- Drop de la table temporaire : lib�ration de la m�moire
	drop table #TempOccupEtage
	--B

	--C.	Chambre la plus occup�e pour chacune des ann�es
	
	create view vwOccupationAnnee (IdChambre, Ann�e, NbClient)
	As Select CHB_ID AS IdChambre, YEAR(PLN_JOUR) As Ann�e ,COUNT(CLI_ID) As NbClient
	From CHB_PLN_CLI
	group by CHB_ID, YEAR(PLN_JOUR)
GO

	Select R.Ann�e, R2.IdChambre, max(R.NbClient) M
	From vwOccupationAnnee R
	inner join vwOccupationAnnee R2 on R.Ann�e = R2.Ann�e
	where (
	select max(NbClient) 
	From vwOccupationAnnee V 
	where R.Ann�e = V.Ann�e
	group by V.Ann�e)  = R2.NbClient
	Group by  R.Ann�e,  R2.IdChambre
	Order by 1 
	--C
	
	--D.	Taux moyen de r�servation par mois-ann�e
	
	--E.	Clients qui ont pass� au total au moins 7 jours � l�h�tel au cours d�un m�me mois 
	--		(Id, Nom, mois o� ils ont pass� au moins 7 jours).
	
	--F.	Nombre de clients qui sont rest�s � l�h�tel au moins deux jours de suite au cours de l�ann�e 2015
	
	Select isnull(SUM(CHB_PLN_CLI_NB_PERS),0) NbClient
	From CHB_PLN_CLI
	where CHB_PLN_CLI_OCCUPE > 1 and YEAR(PLN_JOUR) = 2015 
	--F
	
	--G.	Clients qui ont fait un s�jour � l�h�tel au moins deux mois de suite
	
	--H.	Nombre quotidien moyen de clients pr�sents dans l�h�tel pour chaque mois de l�ann�e 2016, 
	--		en tenant compte du nombre de personnes dans les chambres
	
	select  MONTH(P.PLN_JOUR) Mois, AVG(P.NbPers) NbQuotMoyen from
	(select SUM(CHB_PLN_CLI_NB_PERS) NbPers, PLN_JOUR from CHB_PLN_CLI CH
	where YEAR(PLN_JOUR) = 2016
	group by PLN_JOUR ) as P
	group by MONTH(P.PLN_JOUR)
	order by 1
	--H
	
	--I.	Clients qui ont r�serv� plusieurs fois la m�me chambre au cours d�un m�me mois, 
	--		mais pas deux jours d�affil�e

--------------- 			  Chiffre d'affaire		    	---------------

	--A.	Valeur absolue et pourcentage d�augmentation du tarif de chaque chambre sur l�ensemble de la p�riode
	
	Select C.CHB_ID,(MAX(T.TRF_CHB_PRIX) - MIN(T.TRF_CHB_PRIX)) Absolu,
	((MAX(T.TRF_CHB_PRIX) - MIN(T.TRF_CHB_PRIX))*100) / (MIN(T.TRF_CHB_PRIX)) Pourcentage
	from CHAMBRE C
	inner join TRF_CHB T on T.CHB_ID = C.CHB_ID
	group by C.CHB_ID
	--A
	
	--B.	Chiffre d'affaire de l�h�tel par trimestre de chaque ann�e
	
	Select DATEPART(q,F.FAC_DATE) Trimestre,YEAR(F.FAC_DATE) Ann�e,
	round(Sum(((((isnull(LIF_MONTANT,0)*isnull(LIF_QTE,0))*(1+(isnull(LIF_TAUX_TVA,0)/100)))
	*(1-(isnull(LIF_REMISE_POURCENT,0)/100)))-isnull(LIF_REMISE_MONTANT,0)) ),2) CA
	From FACTURE F
	inner join LIGNE_FACTURE L on F.FAC_ID = L.FAC_ID
	group by DATEPART(q,F.FAC_DATE),YEAR(F.FAC_DATE)
	order by YEAR(F.FAC_DATE),DATEPART(q,F.FAC_DATE)
	--B
	
	--C.	Chiffre d'affaire de l�h�tel par mode de paiement et par an, 
	--		avec les modes de paiement en colonne et les ann�es en ligne.
		
	SELECT p.Annee, p.CB, p.CHQ, p.ESP
	FROM(
	select DATEPART(YEAR,FAC_DATE) Annee,PMCODE Paiement, ((((isnull(LIF_MONTANT,0)*isnull(LIF_QTE,0))*(1+(isnull(LIF_TAUX_TVA,0)/100)))
	*(1-(isnull(LIF_REMISE_POURCENT,0)/100)))-isnull(LIF_REMISE_MONTANT,0)) CA
	from FACTURE F
	inner join LIGNE_FACTURE L on F.FAC_ID = L.FAC_ID ) AS source
	PIVOT(
	SUM(CA) 
	FOR
	Paiement IN ([CB], [CHQ], [ESP])) as p	
	--C
	
	--D.	D�lai moyen de paiement des factures par ann�e et par mode de paiement, 
	--		avec les modes de paiement en colonne et les ann�es en ligne.
	
	SELECT p.Annee, p.CB, p.CHQ, p.ESP
	FROM
    (select DATEPART(YEAR,FAC_DATE) Annee,PMCODE Paiement, DATEDIFF(DAY,FAC_DATE,FAC_PMDATE) MoyenneDelai 
	from FACTURE) AS source
	PIVOT(
    AVG(MoyenneDelai) 
	FOR
	Paiement IN ([CB], [CHQ], [ESP])) as p
	--D
	
	--E.	Compter le nombre de clients dans chaque tranche de 5000 F de chiffre d�affaire total g�n�r�, 
	--		en partant de 20000 F jusqu�� + de 45 000 F. 
	
select IdClient ,case
			When R.CA < 20000 then '- de 20K�'
			When R.CA > 20000 and R.CA < 25000 then '20 - 25 K�'
			When R.CA > 25000 and R.CA < 30000 then '25 - 30 K�'
			When R.CA > 30000 and R.CA < 35000 then '30 - 35 K�'
			When R.CA > 35000 and R.CA < 40000 then '35 - 40 K�'
			When R.CA > 40000 and R.CA < 45000 then '40 - 45 K�'
			When R.CA > 45000 then '+ de 45K�'
		end as Tranche 
from(
	-- Sous requ�te calculant le chiffre d'affaire g�n�r� par chaque client
	Select F.CLI_ID As IdClient, round(Sum(((((isnull(LIF_MONTANT,0)*isnull(LIF_QTE,0))*(1+(isnull(LIF_TAUX_TVA,0)/100)))
	*(1-(isnull(LIF_REMISE_POURCENT,0)/100)))-isnull(LIF_REMISE_MONTANT,0)) ),2) CA
	From LIGNE_FACTURE LF
	inner join FACTURE F on LF.FAC_ID = F.FAC_ID
	group by F.CLI_ID
	)As R
Order by 2 
	--E
	
	--F.	A partir du 01/09/2017, augmenter les tarifs des chambres du rez-de-chauss�e de 5%, 
	--		celles du 1er �tage de 4% et celles du 2d �tage de 2%.

	update TRF_CHB set TRF_CHB_PRIX = (
		case
			-- Cas du rez-de-chauss�e
			when DATEDIFF(DAY, '2017-09-01', TC.TRF_DATE_DEBUT) >= 0 and
			C.CHB_ETAGE = 'RDC' then TC.TRF_CHB_PRIX * 1.05
			-- Cas du 1er �tage
			when DATEDIFF(DAY, '2017-09-01', TC.TRF_DATE_DEBUT) >= 0 and
			C.CHB_ETAGE = '1er' then TC.TRF_CHB_PRIX * 1.04
			-- Cas du 2e �tage
			when DATEDIFF(DAY, '2017-09-01', TC.TRF_DATE_DEBUT) >= 0 and
			C.CHB_ETAGE = '2e' then TC.TRF_CHB_PRIX * 1.02
			else  TC.TRF_CHB_PRIX
		end
			)
	from TRF_CHB TC
	inner join CHAMBRE C on TC.CHB_ID = C.CHB_ID 
	--F