	--------------------------------------------------------------------------------------------------------
	---                                         SI JOB OVERVIEW                                          ---
	--                                              REQUETE                                              ---
	--------------------------------------------------------------------------------------------------------

	--- NB : Il faut ex�cuter les blocs d'instruction en entier !
	---		 un bloc est d�limit� par 2 commentaires Identifi�  : --1, --2, etc
	--- 

	-- 1.3.3. Logique m�tier

	-- 1. Proc�dure de cr�ation d'un t�che de production
	-- L'ID des t�ches sont en auto-incr�ments

	create procedure usp_CreationTacheProd  @Avancement int, @PrevisionInitiale int, 
	@DureePrevue int = 0, @EstimationTempsRestant int = 0, @DateDebut date = getdate,
	@DateFin Date = null, @Activite_Code nvarchar(20),@Version_IdUnique nvarchar(20), @Module_CodeId nvarchar(20)
	as
	begin
		insert jo.Production(Avancement,PrevisionInitiale,DureePrevue,EstimationTempsRestant,
		DateDebut,DateFin,Activite_Code,Versio_IdUnique, Module_CodeId)
		values(@Avancement, @PrevisionInitiale, @DureePrevue, @EstimationTempsRestant, @DateDebut,
		 @DateFin, @Activite_Code, @Version_IdUnique, @Module_CodeId)
	end
	go
	
	drop procedure usp_CreationTacheProd 
	go
	-- 1.


	-- 2. Proc�dure de cr�ation d'une t�che annexe
	
	create procedure usp_CreationTacheAnnexe @Id int, @ActiviteAnnexe_Code nvarchar(20)
	as
	begin
		insert jo.Annexe(Id,ActiviteAnnexe_Code)
		values(@Id, @ActiviteAnnexe_Code)
	end
	go
	
	drop procedure usp_CreationTacheAnnexe
	go
	-- 2.
	

	-- 3. Proc�dure de saisi de temps sur une t�che. G�rer une erreur si le temps d�passe de 8H.
	-- Cr�ation de l'erreur du temps d�passant les 8H
	
	exec sp_addmessage @msgnum = 50001, @severity = 12,
		@msgText = 'Total task time id between 0 and 8 hours.', @lang = 'us_english'
		
	exec sp_addmessage @msgnum = 50001, @severity = 12,
		@msgText = 'Le temps total d''une tache est compris entre 0 et 8 heures', @lang = 'french'
	go

	-- On renseigne la personne qui r�alise la tache et l'ID de la tache d�j� existante
	-- On renseigne ensuite sa dur�e et la date du jour

	create procedure usp_SaisieTempsTache @Id int, @Personne_Ident nvarchar(20), @Duree decimal, @Date date
	as
	begin
		-- V�rification que la tache et que la personne existe
		if exists(select * from jo.Tache T, jo.Personne P where T.Id = @Id and P.Ident = @Personne_Ident)
		begin
			-- V�rification que la dur�e de la tache soit comprise entre 0 et 8
			-- Renvoie une erreur dans le cas contraire
			if @Duree between 0 and 8
			begin
				update jo.TempsPasse
				set Duree = @Duree, Jour = @Date
				from jo.Tache
			end
			else
			begin
				RAISERROR (50001, 12, 1)
				return
			end
		end
		else 
			print 'Veuillez renseigner un Id de personne existant et une tache existante.'
	end
	go
	
		drop procedure usp_SaisieTempsTache
	go
	-- 3.


	-- 4. Vues permettant le remplissage des listes d�roulantes 
	-- des fen�tres de saisie de temps
	-- Fen�tres T�che de production

	Create View vwTacheProd (Logiciel, [Version], Module, Activit�, Tache, [Date Tache], [Dur�e Tache], [Dur�e Pr�vu], [Estimation Temps Restant])
	as Select L.Libelle, V.Numero, M.Libelle, A.Libelle, T.Libelle, TP.Jour, TP.Duree, P.DureePrevue, P.EstimationTempsRestant
	From jo.Logiciel L
	inner join jo.Module M on L.Code = M.Logiciel_Code
	inner join jo.Versio V on L.Code = V.Logiciel_Code
	inner join jo.Production P on V.IdUnique = P.Versio_IdUnique
	inner join jo.Activite A on P.Activite_Code = A.Code
	inner join jo.Tache T on P.Id = T.Id
	inner join jo.TempsPasse TP on T.Id = TP.Tache_Id
	go
	
	drop view vwTacheProd
	go


	--Fen�tres T�che annexe

	Create View vwTacheAnnexe (Activit�, Tache, [Date], [Temps Pass� (H)])
	as Select AA.Libelle, T.Libelle, TP.Jour, TP.Duree
	From jo.TempsPasse TP
	inner join jo.Tache T on TP.Tache_Id = T.Id
	inner join jo.Annexe A on T.Id = A.Id
	inner join jo.ActiviteAnnexe AA on A.ActiviteAnnexe_Code = AA.Code
	go
		
	drop View vwTacheAnnexe 
	go
	-- 4.
	

	-- 5. Permettre au manager de v�rifier si les personnes de son �quipe 
	-- ont bien saisi tous leurs temps, c�est � dire 8h par jour
	-- Renvoi les personnes qui n'ont pas saisi leurs 8H
	
	Select E.Id As Equipe, Pers.Ident Personne ,TP.Jour, sum(TP.Duree) TpsTravail
	From jo.Equipe E
	inner join jo.Productivit� P on E.Id = P.Equipe_Id
	inner join jo.Personne Pers on P.Personne_Ident = Pers.Ident
	inner join jo.TempsPasse TP on Pers.Ident = TP.Personne_Ident
	Group by E.Id,Pers.Ident ,TP.Jour
	Having SUM(TP.Duree) < 8
	go
	--5.
	

	-- 6. La suppression de toutes les donn�es qui sont li�es � une version d�un logiciel
	-- Proc�dure de delete de masse avec en param�tre le num�ro de version et le code du logiciel

	Create procedure usp_SupprDonn�eVersion @CodeLogiciel nvarchar(20), @Num�roVersion nvarchar(20)
	as
	begin
		-- Cr�ation d'une table interm�diaire
		declare @Matable table
		(
			IdTache int
		)
		insert @MaTable
		select P.Id
		from jo.Versio V
		inner join jo.Releas R on V.IdUnique = R.Versio_IdUnique
		inner join jo.Production P on V.IdUnique = P.Versio_IdUnique
		
		-- Suppresion des donn�es
		delete from jo.TempsPasse where Tache_Id in (select IdTache from @Matable)
		delete from jo.Production where Id in (select IdTache from @Matable)
		delete from jo.Tache where Id in (select IdTache from @Matable)
		delete from jo.Releas where Versio_IdUnique = @Num�roVersion
		delete from jo.Versio where IdUnique = @Num�roVersion and Logiciel_Code = @CodeLogiciel
	end
	go
	
	drop procedure usp_SupprDonn�eVersion
	go
	-- 6.