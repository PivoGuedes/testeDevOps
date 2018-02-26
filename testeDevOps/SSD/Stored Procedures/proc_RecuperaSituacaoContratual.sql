

/*
	Autor: Egler Vieira
	Data Criação: 18/07/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: Corporativo.SSD.proc_RecuperaSituacaoContratual
       Descrição: Essa procedure vai consultar os SITUAÇÕES CONTRATUAIS, disponíveis na tabela
             SITUACAO_CONTRATO. Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaSituacaoContratual]
      
AS
WITH CTE 
AS
(
    SELECT 
           Cast(IND_ORIGEM_SITUACAO as varchar(1))+ Cast(NUM_SITUACAO_CONTRATO as varchar(5)) IDSITUACAO
         , Cast(IND_ORIGEM_SITUACAO as varchar(1))+ Cast(NUM_SITUACAO_CONTRATO as varchar(5)) + Cast(NUM_SUB_SITUACAO as varchar(5)) [IDSUBSITUACAO]
         , NOM_SITUACAO_CONTRATO
         , NUM_SITUACAO_CONTRATO
         , NOM_SUB_SITUACAO
         , NUM_SUB_SITUACAO
         , CASE WHEN IND_ORIGEM_SITUACAO = 1 THEN 'Declinios e Cancelamentos Vida (origem: DEVOLUCAO_VIDAZUL)'
                WHEN IND_ORIGEM_SITUACAO = 2 THEN 'Carga Fria VIDA'
                WHEN IND_ORIGEM_SITUACAO = 3 THEN 'Carga Fria Bilhete'
                ELSE 'NÃO ESPECIFICADO'
           END ORIGEM_SITUACAO
         , IND_ORIGEM_SITUACAO
    FROM DMDB13.dbo.DM_036_SITUACAO_CONTRATO
--	WHERE COD_TIPO_PRODUTOR IN (0, 1) NOM_PRODUTOR like '%PAR C%'
) 
SELECT     IDSITUACAO
         , [IDSUBSITUACAO]
         ,  NOM_SITUACAO_CONTRATO
         , NOM_SUB_SITUACAO
         , ORIGEM_SITUACAO
         , IND_ORIGEM_SITUACAO
FROM CTE
ORDER BY [IDSUBSITUACAO]
