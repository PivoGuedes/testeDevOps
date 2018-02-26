

/*
	Autor: Egler Vieira
	Data Criação: 17/07/2014

	Descrição: 
	
	Última alteração : 	
	                    

*/
/*******************************************************************************
       Nome: Corporativo.SSD.proc_RecuperaProdutor
       Descrição: Essa procedure vai consultar os dados de produtores (pessoas físicas e jurídicas), disponíveis na tabela
             PRODUTOR. Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
        
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaProdutor]
      
AS
WITH CTE 
AS
(
    SELECT COD_PRODUTOR
         , NOM_PRODUTOR
         , CleansingKit.dbo.fn_TrimNull((CASE
		WHEN 
          
             LEN(Cast(COD_CGCCPF_PRODUTOR as varchar(20)))>11 THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(COD_CGCCPF_PRODUTOR as varchar(20)))
		WHEN LEN(Cast(COD_CGCCPF_PRODUTOR as varchar(20)))< 3 THEN '0' COLLATE SQL_Latin1_General_CP1_CI_AS
        ELSE  CleansingKit.dbo.fn_FormataCPF(Cast(COD_CGCCPF_PRODUTOR as varchar(20))) 
	    END)) AS COD_CGCCPF_PRODUTOR 
         , COD_TIPO_PRODUTOR
         , DES_TIPO_PRODUTOR
         , NUM_MATRICULA
         , COD_FILIAL
         , NOM_FILIAL
    FROM DMDB13.dbo.DM_032_PRODUTOR
--	WHERE COD_TIPO_PRODUTOR IN (0, 1) NOM_PRODUTOR like '%PAR C%'
) 
SELECT *
FROM CTE
