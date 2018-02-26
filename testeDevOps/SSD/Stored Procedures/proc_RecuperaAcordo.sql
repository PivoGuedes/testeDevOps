
/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 	

*/
/*******************************************************************************
       Nome: CORPORATIVO.SSD.[proc_RecuperaAcordo]
       Descrição: Essa procedure vai consultar os dados de acordos de  Contratos (pessoas físicas e jurídicas).
        Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
            
       Retorno:
     
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaAcordo](@PontoDeParada varchar(300))
AS
--declare @PontoDeParada varchar(300)
--set @PontoDeParada = '1944-01-01;17000000'
--DECLARE @DataModificacao date
DECLARE @Contrato int

--SET @DataModificacao = LEFT(@PontoDeParada, CHARINDEX(';',@PontoDeParada)-1)
----select @DataModificacao
SET @Contrato = RIGHT(@PontoDeParada, LEN(@PontoDeParada) - CHARINDEX(';',@PontoDeParada))
--SELECT @Contrato
--SELECT  
--FROM CleansingKit.dbo.[fn_Split](@PontoDeParada,';')  

;WITH CTE 
AS
(
 
 

   SELECT	TOP 3000
   	-------------------------------------CONTRATO----------------------------------------------------------
                    MOV.SUK_CONTRATO_VIDA
				  , CV.NUM_BIL_CERTIF
				  , CV.NUM_APOLICE
				  , CASE WHEN CV.NUM_PROPOSTA_SIVPF IS NULL AND CV.NUM_APOLICE = '109300000559'	THEN CV.NUM_BIL_CERTIF ELSE CV.NUM_PROPOSTA_SIVPF END AS NUM_PROPOSTA_SIVPF
				  , CV.NUM_CONTRATO
				  , CV.IND_ORIGEM_REGISTRO 
				  , CV.NUM_MATRICULA_ECONOM
				  , CASE WHEN CV.[STA_ANTECIPACAO] = 'S' THEN 1 WHEN CV.[STA_ANTECIPACAO] = 'N' THEN 0 END AS [STA_ANTECIPACAO]
				  , CASE WHEN CV.[STA_MUDANCA_PLANO] = 'S' THEN 1 WHEN CV.[STA_MUDANCA_PLANO] = 'N' THEN 0 END AS [STA_MUDANCA_PLANO]
				 -------------------------------------ACORDO----------------------------------------------------------
				  , MOV.DTH_ATUALIZACAO
				  , MOV.DTH_INI_VIGENCIA
				  , MOV.DTH_FIM_VIGENCIA
				  , MOV.DTH_VENDA
				  , MOV.PCT_COM_CORRETOR
				  , MOV.PCT_PART_CORRETOR
				  , MOV.SUK_PRODUTOR 
				   -------------------------------------PRODUTOR----------------------------------------------------------
				  , prd.COD_PRODUTOR
   --       FROM DMDB13.dbo.DM_030_CONTRATO_VIDA CV   
		 -- 	INNER JOIN DMDB13.dbo.DM_040_FATO_MOV_VENDA_VIDA MOV ON MOV.SUK_CONTRATO_VIDA = CV.SUK_CONTRATO_VIDA
			--INNER JOIN DMDB13.dbo.DM_032_PRODUTOR prd on PRD.SUK_PRODUTOR = MOV.SUK_PRODUTOR
	    FROM DMDB13.dbo.DM_040_FATO_MOV_VENDA_VIDA MOV
		LEFT JOIN DMDB13.dbo.DM_030_CONTRATO_VIDA CV  ON MOV.SUK_CONTRATO_VIDA = CV.SUK_CONTRATO_VIDA
		LEFT JOIN DMDB13.dbo.DM_032_PRODUTOR prd on PRD.SUK_PRODUTOR = MOV.SUK_PRODUTOR
         -- ORDER BY cv.SUK_CONTRATO_VIDA -- MC.DTH_ATUALIZACAO, MC.SUK_CONTRATO_VIDA ASC
		--
		WHERE MOV.SUK_CONTRATO_VIDA > @Contrato
		--	AND CV.NUM_APOLICE = '109300000559'	
		-- WHERE NUM_CONTRATO = 000010021759217
		 ORDER BY CV.SUK_CONTRATO_VIDA 
	--INNER JOIN DMDB13.dbo.DM_040_FATO_MOV_VENDA_VIDA MOV ON MOV.SUK_CONTRATO_VIDA = CV.SUK_CONTRATO_VIDA
	--INNER JOIN DMDB13.dbo.DM_032_PRODUTOR prd on PRD.SUK_PRODUTOR = MOV.SUK_PRODUTOR
) 
SELECT *
FROM CTE

OPTION (MAXDOP 4)
