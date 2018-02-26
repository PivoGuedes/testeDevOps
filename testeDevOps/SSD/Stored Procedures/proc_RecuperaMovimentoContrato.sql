
/*
	Autor: Egler Vieira
	Data Criação: 25/07/2014

	Descrição: 
	
	Última alteração : 	

*/
/*******************************************************************************
       Nome: CORPORATIVO.SSD.proc_RecuperaMovimentoContrato
       Descrição: Essa procedure vai consultar os dados de moviementações Contratuais (pessoas físicas e jurídicas).
        Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaMovimentoContrato](@PontoDeParada varchar(300))
AS
--declare @PontoDeParada varchar(300)
--set @PontoDeParada = '1944-01-01;0'
DECLARE @DataModificacao date
DECLARE @Contrato int

SET @DataModificacao = LEFT(@PontoDeParada, CHARINDEX(';',@PontoDeParada)-1)
--select @DataModificacao
SET @Contrato = RIGHT(@PontoDeParada, LEN(@PontoDeParada) - CHARINDEX(';',@PontoDeParada))
--SELECT @Contrato
--SELECT  
--FROM CleansingKit.dbo.[fn_Split](@PontoDeParada,';')  

;WITH CTE 
AS
(
 
    SELECT  
        CV.[SUK_CONTRATO_VIDA]
      , MC.DTH_MOVIMENTO
      , MC.DTH_OPERACAO
      , MC.NUM_OCORRENCIA
      , MC.DTH_ATUALIZACAO
      , MC.VLR_PREMIO
      , MC.VLR_IS
      , MC.QTD_VIDAS
      -------------------------------------CONTRATO----------------------------------------------------------
	  , CV.NUM_BIL_CERTIF
	  , CV.NUM_APOLICE
	  , CASE WHEN CV.NUM_PROPOSTA_SIVPF IS NULL AND   (CV.NUM_APOLICE IN ('109300000559','109300002344','97010000889')) THEN CV.NUM_BIL_CERTIF ELSE CV.NUM_PROPOSTA_SIVPF END AS NUM_PROPOSTA_SIVPF
	  , CV.NUM_CONTRATO
      , CV.IND_ORIGEM_REGISTRO 
	  , CASE WHEN CV.[STA_ANTECIPACAO] = 'S' THEN 1 WHEN CV.[STA_ANTECIPACAO] = 'N' THEN 0 END AS [STA_ANTECIPACAO]
	  , CASE WHEN CV.[STA_MUDANCA_PLANO] = 'S' THEN 1 WHEN CV.[STA_MUDANCA_PLANO] = 'N' THEN 0 END AS [STA_MUDANCA_PLANO]
      -------------------------------------PRODUTO----------------------------------------------------------
      , PU.COD_PRODUTO_SIAS
      , PU.COD_PRODUTO_SIVPF
      , PU.COD_RAMO_EMISSOR
      , PU.COD_EMPRESA_SIAS
      ---------------------------------------OPERACAO----------------------------------------------------
      , Cast(OC.IND_ORIGEM_OPERACAO as varchar(1))+ Cast(OC.COD_GRUPO_OPERACAO as varchar(5)) + Cast(OC.NUM_OPER_CONTRATO as varchar(5)) [IDSUBOPERACAO]
      --------------------------------------SUB ESTIPULANTE------------------------------------------------
  --  INTO A
    FROM (SELECT TOP 1500
                    CV.SUK_CONTRATO_VIDA
				  , CV.NUM_BIL_CERTIF
				  , CV.NUM_APOLICE
				  , CV.NUM_PROPOSTA_SIVPF
				  , CV.NUM_CONTRATO
				  , CV.IND_ORIGEM_REGISTRO 
				  , CV.[STA_ANTECIPACAO]
				  , CV.[STA_MUDANCA_PLANO]
          FROM DMDB13.dbo.DM_030_CONTRATO_VIDA CV
          WHERE CV.SUK_CONTRATO_VIDA > @Contrato --AND MC.DTH_ATUALIZACAO >= @DataModificacao    		  
		  AND EXISTS (SELECT * FROM DMDB13.dbo.DM_037_FATO_MOV_CONTRATO_VIDA M WHERE M.SUK_CONTRATO_VIDA = CV.SUK_CONTRATO_VIDA)    
		  --AND CV.NUM_APOLICE = '109300000559'
          ORDER BY cv.SUK_CONTRATO_VIDA -- MC.DTH_ATUALIZACAO, MC.SUK_CONTRATO_VIDA ASC
		  ) CV
    INNER JOIN DMDB13.dbo.DM_037_FATO_MOV_CONTRATO_VIDA MC 
    ON MC.SUK_CONTRATO_VIDA = CV.SUK_CONTRATO_VIDA
    INNER JOIN DMDB13.dbo.DM_026_PRODUTO_UNIFICADO PU
    ON PU.SUK_PRODUTO_UNIFICADO = MC.SUK_PRODUTO_UNIFICADO
    INNER JOIN DMDB13.dbo.DM_035_OPERACAO_CONTRATO OC
    ON MC.SUK_OPER_CONTRATO = OC.SUK_OPER_CONTRATO
) 
SELECT *
FROM CTE
OPTION (MAXDOP 4)
