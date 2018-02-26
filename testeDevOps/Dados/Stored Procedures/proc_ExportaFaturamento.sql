
/*
	Autor: Egler Vieira
	Data Criação: 29/01/2013

	Descrição: 
	
	Última alteração :  30/01/2013 - Egler
	                    28/02/2013 - Alteração da consulta para utilização da função 
	                                 que consolida os valores de comissionamento

   	Última alteração :  28/12/2017 - Jorge
	                    28/12/2017 - Incluido parametro de entrada da proc @IDEmpresa 


*/

/*******************************************************************************
	Nome: CONCILIACAO.Dados.proc_ExportaFaturamento
	Descrição: Procedimento que realiza a consolidação e exportação dos dados de
	           comissionamento para o banco de faturamento para integração com o PROTHEUS.
		
	Parâmetros de entrada: @IDEmpresa - IDEmpresa
	
					
	Retorno:

*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_ExportaFaturamento] (@IDEmpresa SMALLINT)
AS
BEGIN TRY

--DECLARE @IDEmpresa SMALLINT = 3
DECLARE @DataRecibo AS DATE = NULL;
DECLARE @NumeroRecibo BIGINT = NULL;
DECLARE @DataCompetencia AS DATE = NULL;
DECLARE @COMANDO AS NVARCHAR(4000);
DECLARE @MaiorCodigo AS DATE;
DECLARE @ParmDefinition NVARCHAR(500); 		      
		      
		      
		      
SELECT  @DataRecibo = DataRecibo, @DataCompetencia = DataCompetencia, @NumeroRecibo = NumeroRecibo--, @IDEmpresa = IDEmpresa
FROM [ControleDados].[ExportacaoFaturamento] EF     
WHERE EF.Autorizado = 1 AND EF.Processado = 0
AND EF.IDEmpresa = @IDEmpresa
ORDER BY DataRecibo ASC, DataCompetencia ASC
		      
    
WHILE @DataRecibo IS NOT NULL AND @DataCompetencia IS NOT NULL AND @NumeroRecibo IS NOT NULL AND @IDEmpresa IS NOT NULL
BEGIN 

/***************************************************************************************************************************************************/
/*ALIMENTA TABELA DE FATURAMENTO COM RESULTADO SINTÉTICO*/
/***************************************************************************************************************************************************/
INSERT INTO Faturamento.Dados.Faturamento 
( IDProduto
, IDRamo
, IDCanalVendaPAR
, IDUnidade
, IDFilialFaturamento
--, IDFilialPARCorretora
, [MetaASVEN]
, [MetaAVCaixa]
, [RunOff]
, VendaNova
, ASVEN
, Repasse
, DataRecibo
, NumeroRecibo
, DataRefFaturamentoInicial
, DataRefFaturamentoFinal
, CompetenciaAnoMes
, ValorPremioLiquido
, ValorComissao
, QuantidadeContratos
, IDSeguradora
)
/*CONSULTA CONSOLIDADORA DO FATURAMENTO POR DATA DE RECIBO*/
SELECT [IDProduto],
       [IDRamo],
      CASE WHEN @IDEmpresa = 52 and IDCanalVendaPAR is null then 450 else IDCanalVendaPAR end as  [IDCanalVendaPAR],
       [IDUnidadeVenda],
       [IDFilialFaturamento], 
       --A.IDFilialPARCorretora,
       [MetaASVEN],
       [MetaAVCaixa],
       [RunOff],
       [VendaNova],
       [COM/SEMASVEN],
       [Repasse],
       [DataCompetencia],    
       [NumeroRecibo],        
       MIN([DataRefInicial]) [DataRefInicial],
       MAX([DataRefFinal]) [DataRefFinal],
       Cast(YEAR(A.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(A.DataCompetencia) AS VARCHAR(2)),2) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/
       SUM([ValorPremioLiquido]) [ValorPremioLiquido],
       SUM([ValorComissao]) ValorComissao,
       SUM([QuantidadeContratos]) QuantidadeContratos,
	   IDSeguradora
FROM
/****************************************************************************************************/
  Dados.fn_RecuperaPreviaPROTHEUS(@DataCompetencia, @DataCompetencia, @IDEmpresa, 0) A
  WHERE A.NumeroRecibo = @NumeroRecibo
  AND A.DataRecibo = @DataRecibo
/****************************************************************************************************/		   		
GROUP BY 
       [IDProduto],
       [IDRamo],
       [IDCanalVendaPAR],
       [IDUnidadeVenda],
       [IDFilialFaturamento], 
       --A.IDFilialPARCorretora,
       [MetaASVEN],
       [MetaAVCaixa],
       [RunOff],
       [VendaNova],
       [COM/SEMASVEN],
       [Repasse],
       [DataCompetencia], 
       [NumeroRecibo],
       Cast(YEAR(A.DataCompetencia) AS VARCHAR(4)) + /*'/' +*/ RIGHT('0' + Cast(MONTH(A.DataCompetencia) AS VARCHAR(2)),2)  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/  ,
	   IDSeguradora

/*		   
UNION ALL

/****************************************************************************************************/		   
/*AJUSTE DO PRESTAMISTA 1.38% DE REPASSE*/
/****************************************************************************************************/		   		
SELECT A.IDProduto,
       A.IDRamo,
       A.IDCanalVendaPAR ,
       A.IDUnidadeVenda,
       A.IDFilialFaturamento, 
       --A.IDFilialPARCorretora,
       
       
       /*
       Cast(CASE WHEN A.NumeroParcela = 1 THEN 1
       ELSE 0
       END as bit) [VendaNova],
       */
       
       [VendaNova],
       1 [Repasse],
       A.DataRecibo,
       
       CASE WHEN CVP.VendaAgencia = 1 THEN CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END ELSE NULL END [COM/SEMASVEN],
       (SELECT MIN(C1.DataCalculo) [DataRefInicial] FROM Corporativo.Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefInicial],
       (SELECT MAX(C1.DataCalculo) [DataRefFinal] FROM Corporativo.Dados.Comissao C1 WHERE C1.DataRecibo = A.DataRecibo) [DataRefFinal],
       Cast(YEAR(MIN(A.DataRecibo)) as  varchar(4)) + Cast(MONTH(MIN(A.DataRecibo)) as varchar(2)) [Competencia],  /*DUVIDA SOBRE O CAMPO A SER USADO NA COMPETENCIA - 29/01/2013*/
       SUM(A.[ValorPremioLiquido]) [ValorPremioLiquido],
       SUM(A.[ValorComissao]) [ValorComissao],
       count(A.IDProposta) [QuantidadeContratos]
FROM
(
  SELECT 
         C.IDProduto,
         C.IDRamo,
         IDCanalVendaPAR,
		     C.IDFilialFaturamento, 
         C.IDUnidadeVenda,
         --C.IDFilialPARCorretora,
         C.ASVEN,
         C.NumeroParcela,
         C.DataRecibo,
         C.ValorBase [ValorPremioLiquido],
         (C.ValorCorretagem * 1.38000) / 6.88000 [ValorComissao],
         C.IDProposta, 
         C.[VendaNova]
  FROM [Dados].[vw_ComissaoAnalitico_DadosBasicos] C

  WHERE C.DataRecibo = @PontoDeParada
  AND C.CodigoComercializado IN ('7705', '7705')
  )  A
  INNER JOIN Dados.CanalVendaPAR CVP
  ON CVP.ID = A.IDCanalVendaPAR
GROUP BY A.IDProduto,
         A.IDRamo,
         A.IDCanalVendaPAR,
         A.IDUnidadeVenda,
         A.IDFilialFaturamento,
         --A.IDFilialPARCorretora,
         A.[VendaNova],
        CASE WHEN CVP.VendaAgencia = 1 THEN 
                                CASE WHEN A.ASVEN = 1 THEN CAST(1 AS BIT) 
                                     ELSE CAST(0 AS BIT) 
                                 END 
              ELSE NULL 
        END,		      
		A.DataRecibo	
*/		   
/****************************************************************************************************/		   
		   
		      
/***************************************************************************************************************************************************/

  /********************************************************************************************/
  /*Atualiza o ponto de parada, indicando que o processamento da data de recibo foi concluído*/
  /********************************************************************************************/

  UPDATE [ControleDados].[ExportacaoFaturamento] SET Processado = 1
  WHERE  DataRecibo = @DataRecibo AND NumeroRecibo = @NumeroRecibo AND DataCompetencia = @DataCompetencia AND IDEmpresa = @IDEmpresa AND Processado = 0  

  /********************************************************************************************/
  
  SET @DataRecibo = NULL
  SET @NumeroRecibo = NULL
  SET @DataCompetencia = NULL

  SELECT TOP 1 @DataRecibo = DataRecibo, @NumeroRecibo = NumeroRecibo, @DataCompetencia = DataCompetencia, @IDEmpresa = IDEmpresa
  FROM [ControleDados].[ExportacaoFaturamento] EF     
  WHERE EF.Autorizado = 1 AND EF.Processado = 0
  AND EF.IDEmpresa = @IDEmpresa
  ORDER BY DataRecibo ASC, DataCompetencia ASC
END
END TRY
BEGIN CATCH
  EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
