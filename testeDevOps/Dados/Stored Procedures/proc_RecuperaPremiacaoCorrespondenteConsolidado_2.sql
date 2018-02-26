
/*
	Autor: Windson Santos
	Data Criação: 10/03/2014

	Descrição: 
	
	Última alteração : 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaPremiacaoCorrespondenteConsolidado
	Descrição: Procedimento carrega a lista dos Correspondentes.
		
	Parâmetros de entrada: @Ano , @Mes , @IDTipoCorrespondente 
	
					
	Retorno: Lista do correspondente indicado por mês
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaPremiacaoCorrespondenteConsolidado_2] (@Ano smallint, @Mes tinyint, @IDTipoCorrespondente tinyint, @IDTipoProduto tinyint)
AS


--DECLARE @IDtipoCorrespondente as int, @Ano as int, @Mes as int, @IDTipoProduto as int

--set @IDTipoProduto = 1
--SET @IDtipoCorrespondente = 1
--SET @Ano = 2015
--SET @Mes = 2
   
SELECT                                                                                                                
       C.ID,                                                                                                                                                                                           
       C.[Matricula],                                                                                                                                                                                  
       C.[Nome],                                                                                                                                                                                       
       C.[CPFCNPJ],
       U.Codigo [AgenciaVinculoCorrespondente],                                                                                                                            
       C.[Cidade],                                                                                                                                                                                
       C.[UF],       
       CDB.Banco,    
       CDB.Agencia [AgenciaConta], 
       CDB.[ContaCorrente],
       C.[IDTipoCorrespondente],                                                                                                                                                                         
       COUNT(*) Quantidade,                                                                                                                                                                      
       SUM(PC.ValorCorretagem) [ValorCorretagem],                                                                                                                                  
       Cast(@Ano as varchar(4)) + '-' + RIGHT('0' + Cast(@Mes as varchar(2)),2) + '-' + '01' [DataCompetencia],                
       F.[Codigo] AS CodigoFilialFaturamento,                                                                                                                                      
       F.[Nome] AS NomeFilialFaturamento,                                                                                                                                                 
       PR.[Codigo] AS CodigoProdutor,
       NULL [ItemImportacaoPROTHEUS],
    NULL [DataProcessamento]
FROM Dados.PremiacaoCorrespondente PC                                                                                                                                               
LEFT JOIN Dados.Correspondente C
ON C.ID = PC.IDCorrespondente
LEFT JOIN Dados.Unidade U
ON U.ID = C.IDUnidade
LEFT JOIN Dados.CorrespondenteDadosBancarios CDB
ON CDB.IDCorrespondente = C.ID
left join Dados.Produtor PR on PR.ID = PC.IDProdutor
LEFT JOIN Dados.FilialFaturamento F ON F.ID = PC.IDFilialFaturamento
WHERE C.IDTipoCorrespondente =  @IDTipoCorrespondente --1 = lotérica, 2 = atendente
AND CDB.IDTipoProduto = @IDTipoProduto
AND PC.IDTipoProduto=CDB.IDTipoProduto 
AND YEAR(PC.DataArquivo) = @Ano
AND MONTH(PC.DataArquivo) = @Mes
AND PC.IDOperacao = 1 --Corretagem -> 1001
--------------------------------------------------------------------------------------
--Garante que o ATENDENTE e O LOTÉRICO fiquem registrados onde é devido
AND CASE WHEN @IDtipoCorrespondente = 1 AND (PC.Arquivo LIKE '%SAFAT%' OR PC.Arquivo LIKE '%DC0701_CBN_ATENDENTE%' )THEN 0
        WHEN @IDtipoCorrespondente = 2  AND (PC.Arquivo LIKE '%SAFCBN%' OR PC.Arquivo LIKE '%DC0701_CBN_EMPRESARIO%') THEN 0
            ELSE 1
    END = 1      
--------------------------------------------------------------------------------------
GROUP BY 
       PC.[IDProdutor], 
       PC.[IDCorrespondente],
       PC.[IDFilialFaturamento], 
       C.Cidade, 
       C.UF, 
       C.ID,
       C.[Matricula], 
       C.[Nome], 
       C.[CPFCNPJ], 
       PR.Codigo,
       F.Codigo, 
       F.Nome,
       U.Codigo, 
       CDB.Banco,    
       CDB.Agencia,
       CDB.[ContaCorrente],
       C.[IDTipoCorrespondente]
OPTION (OPTIMIZE FOR (@IDtipoCorrespondente UNKNOWN, @IDTipoProduto UNKNOWN, @Ano UNKNOWN, @Mes UNKNOWN))


