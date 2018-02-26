

/*
	Autor: Egler Vieira
	Data Criação: 20/07/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: Corporativo.SSD.proc_RecuperaOperacaoContratual
       Descrição: Essa procedure vai consultar os SITUAÇÕES CONTRATUAIS, disponíveis na tabela
             OPERACAO_CONTRATO. Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaOperacaoContratual]
      
AS
WITH CTE 
AS
(
    SELECT 
           Cast(IND_ORIGEM_OPERACAO as varchar(1))+ Cast(COD_GRUPO_OPERACAO as varchar(5)) IDOPERACAO
         , Cast(IND_ORIGEM_OPERACAO as varchar(1))+ Cast(COD_GRUPO_OPERACAO as varchar(5)) + Cast(NUM_OPER_CONTRATO as varchar(5)) [IDSUBOPERACAO]
         , NOM_OPER_CONTRATO
         , NUM_OPER_CONTRATO
         , NOM_GRUPO_OPERACAO
         , COD_GRUPO_OPERACAO
         , CASE WHEN IND_ORIGEM_OPERACAO = 1 THEN 'VIDA'
                WHEN IND_ORIGEM_OPERACAO = 2 THEN 'BILHETE'
                ELSE 'NÃO ESPECIFICADO'
           END ORIGEM_OPERACAO
         , IND_ORIGEM_OPERACAO
    FROM DMDB13.dbo.DM_035_OPERACAO_CONTRATO
--	WHERE COD_TIPO_PRODUTOR IN (0, 1) NOM_PRODUTOR like '%PAR C%'
) 
SELECT     IDOPERACAO
         , [IDSUBOPERACAO]
         , NOM_OPER_CONTRATO NOM_SUB_OPERACAO
         , NOM_GRUPO_OPERACAO NOM_OPERACAO_CONTRATO
         , ORIGEM_OPERACAO
         , IND_ORIGEM_OPERACAO
FROM CTE
ORDER BY [IDSUBOPERACAO]
