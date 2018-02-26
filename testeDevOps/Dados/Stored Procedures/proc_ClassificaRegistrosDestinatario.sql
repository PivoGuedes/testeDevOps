CREATE PROCEDURE Dados.proc_ClassificaRegistrosDestinatario
AS

/*
Desenvolvido por: André Anselmo.
Data: 27/11/2014.

Objetivo: 
Aplicar a regra de negócio para destinar para a
->Bgek "•	70% dos Leads Gerados (Totalidade de Economiarios + restante de Correntistas que completem os 70% dos Leads)"
->Flex "•	30% dos Leads Gerados (Apenas Correntistas)"


Variáveis:
@Total: Total de leads gerados no dia.
@70PC: Calcula 70% dos leads gerados no dia.
@TotalEconomiario: calcula o total de leads de economiários:
@Sobra: calcula a diferença (@70PC - @TotalEconomiario), para completar os 70% dos leads da Bgek.
*/

DECLARE @Total INT
DECLARE @TotalEconomiario INT
DECLARE @70PC AS INT
DECLARE @Sobra AS INT
DECLARE @SQL AS VARCHAR(8000)


SET @Total = (SELECT COUNT(*) FROM [Mailing].[MailingAutoKPN] WHERE DataRefMailing=CAST(GETDATE() AS DATE)) 

SET @70PC = @Total * 0.7

SET @TotalEconomiario = (SELECT COUNT(*) FROM [Mailing].[MailingAutoKPN] WHERE Economiario=1 AND DataRefMailing=CAST(GETDATE() AS DATE))
SET @Sobra = @70PC - @TotalEconomiario

/*
Atualiza para 1, os registros do grupo "70% dos leads da Bgek". 
Os registros que não forem afetados pela atualização, serão considerados "Mailing Flex".
*/
--EXECUTE('
--			WITH CTE AS (
--			SELECT ID FROM [Mailing].[MailingAutoKPN] WHERE Economiario=1 AND DataRefMailing=CAST(GETDATE() AS DATE)
--				UNION ALL
--			SELECT TOP '+@Sobra+' ID FROM [Mailing].[MailingAutoKPN] WHERE Economiario=0 AND DataRefMailing=CAST(GETDATE() AS DATE)
--			)
--			UPDATE [Mailing].[MailingAutoKPN]
--			SET MailingBGek=1 FROM
--			[Mailing].[MailingAutoKPN] AS M
--			INNER JOIN CTE ON M.ID=CTE.ID
--			WHERE DataRefMailing=CAST(GETDATE() AS DATE)'
--		) 



--UPDATE Mailing.MailingAutoKPN SET CodCampanha='AQAUTSID20141124', CodMailing=REPLACE(CodMailing,'AQAUTSIS20130704','AQAUTSID20141124') WHERE DataRefMAILING=CAST(GETDATE() AS DATE) AND ISNULL(MailingBGeK,0)=0			
UPDATE Mailing.MailingAutoKPN SET MailingBGeK=1 WHERE DataRefMAILING=CAST(GETDATE() AS DATE) 




