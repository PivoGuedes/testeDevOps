
/*
	Autor: Egler Vieira
	Data Criação: 10/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_AUTOVARIAVEL_TIPO4_SRG1
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_AUTOVARIAVEL_TIPO4_SRG1] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP];
		RAISERROR   (N'A tabela temporária [AUTOVARIAVEL_TIPO4_SRG_TMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
END


CREATE TABLE [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP](
	[Codigo] [bigint] NOT NULL,
	[NomeArquivo] [nvarchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[DataHoraProcessamento] [datetime2](7) NOT NULL,
	[TipoArquivo] [varchar](15) NULL,
	[CodigoVeiculo] [varchar](6) NULL,
	[DescricaoVeiculo] [varchar](60) NULL,
	[CodigoRegiao] [varchar](4) NULL,
	[AnoFabricacao] [varchar](4) NULL,
	[AnoModelo] [varchar](4) NULL,
	[Capacidade] [tinyint] NULL,                                             
	[CodigoBonus] [tinyint] NULL,
	[CodigoSubProduto] [varchar] (6) NULL,
    [CodigoClasseFranquia] [varchar](4) NULL,
	[ClasseFranquia] [varchar](13) NULL,
	[Cobertura] [varchar](1) NULL,
	[DataInicioVigencia] [DATE] NULL,
	[DataFimVigencia] [DATE] NULL,
	[Combustivel] [varchar](8) NULL,
	[PlacaVeiculo] [varchar](8) NULL,
	[CHASSIS] [varchar](20) NULL,
	[NumeroApoliceAnterior] [varchar](21) NULL,
	[QuantidadeParcelas] [varchar](2) NULL,
	[NomeCondutor1] [varchar](100) NULL,
	[EstadoCivilCondutor1] [varchar] (20) NULL,
	[SexoCondutor1] [varchar] (20) NULL,
	[RGCondutor1] [varchar](20) NULL,
	[DataNascimentoCondutor1] [DATE] NULL,
	[CNHCondutor1] [varchar](20) NULL,
	[DataCNHCondutor1] [DATE] NULL,
	[CodigoRelacionamento] [varchar](2) NULL,
	[NomeCondutor2] [varchar] (100) NULL,
	[EstadoCivilCondutor2] [varchar] (20) NULL,
	[SexoCondutor2] [varchar] (20) NULL,
	[RGCondutor2] [varchar] (20) NULL,
	[DataNascimentoCondutor2] [DATE] NULL,
	[CNHCondutor2] [varchar] (20) NULL,
	[DataCNHCondutor2] [DATE] NULL,
	[CodigoRelacionamentoCondutor2] [varchar] (2) NULL,
	[VersaoCalculo] [varchar](4) NULL,
	[CodigoSeguradora] [varchar](5) NULL,
	[CodigoRegiaoVistoriada] [varchar](4) NULL,
	[CodigoTipoSeguro] [varchar](2) NULL,
	[TipoSeguro] [varchar](35) NULL,/*
	[RANK] [bigint] NULL    */
	[TP] [varchar] (50)
) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_AUTOVARIAVEL_TIPO4_SRG_TMP_Codigo ON [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_AUTOVARIAVEL_TIPO4_SRG1'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.AUTOVARIAVEL_TIPO4_SRG_TMP
       ( [Codigo],[NomeArquivo],[DataArquivo],[NumeroProposta],[DataHoraProcessamento],[TipoArquivo]
        ,[CodigoVeiculo],[DescricaoVeiculo],[CodigoRegiao],[AnoFabricacao],[AnoModelo],[Capacidade]
        ,[CodigoBonus],[CodigoSubProduto],[CodigoClasseFranquia],[ClasseFranquia],[Cobertura],[DataInicioVigencia],[DataFimVigencia]
        ,[Combustivel],[PlacaVeiculo],[CHASSIS],[NumeroApoliceAnterior],[QuantidadeParcelas],[NomeCondutor1]
        ,[EstadoCivilCondutor1],[SexoCondutor1],[RGCondutor1],[DataNascimentoCondutor1],[CNHCondutor1]
        ,[DataCNHCondutor1],[CodigoRelacionamento],[NomeCondutor2],[EstadoCivilCondutor2],[SexoCondutor2]
        ,[RGCondutor2],[DataNascimentoCondutor2],[CNHCondutor2],[DataCNHCondutor2],[CodigoRelacionamentoCondutor2]
        ,[VersaoCalculo],[CodigoSeguradora],[CodigoRegiaoVistoriada],[CodigoTipoSeguro],[TipoSeguro], [TP])
     SELECT [Codigo],[NomeArquivo],[DataArquivo],[NumeroProposta],[DataHoraProcessamento],[TipoArquivo]
            ,[CodigoVeiculo],[DescricaoVeiculo],[CodigoRegiao],[AnoFabricacao],[AnoModelo],[Capacidade]
            ,[CodigoBonus],[CodigoSubProduto],[CodigoClasseFranquia],[ClasseFranquia],[Cobertura],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataInicioVigencia])),CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataFimVigencia]))
            ,[Combustivel],[PlacaVeiculo],[CHASSIS],[NumeroApoliceAnterior],[QuantidadeParcelas],[NomeCondutor1]
            ,[EstadoCivilCondutor1],[SexoCondutor1],[RGCondutor1], CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataNascimentoCondutor1])),[CNHCondutor1]
            ,CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataCNHCondutor1])),[CodigoRelacionamento],[NomeCondutor2],[EstadoCivilCondutor2],[SexoCondutor2]
            ,[RGCondutor2],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataNascimentoCondutor2])),[CNHCondutor2],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataCNHCondutor2])),[CodigoRelacionamentoCondutor2]
            ,[VersaoCalculo],[CodigoSeguradora],[CodigoRegiaoVistoriada],[CodigoTipoSeguro],[TipoSeguro], ''SRG1''--,[RANK]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_AUTOVARIAVEL_TIPO4_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.AUTOVARIAVEL_TIPO4_SRG_TMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo


  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_AUTOVARIAVEL_TIPO4_SRG1'
  /*************************************************************************************/
  
 
   
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do AUTO TP4 (PRPSASSE)*/
  /*************************************************************************************/ 
  EXEC Dados.proc_InsereProposta_AUTOVARIAVEL_TIPO4
  /*************************************************************************************/ 
  
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP]
  
  /*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.AUTOVARIAVEL_TIPO4_SRG_TMP
       ( [Codigo],[NomeArquivo],[DataArquivo],[NumeroProposta],[DataHoraProcessamento],[TipoArquivo]
        ,[CodigoVeiculo],[DescricaoVeiculo],[CodigoRegiao],[AnoFabricacao],[AnoModelo],[Capacidade]
        ,[CodigoBonus],[CodigoSubProduto],[CodigoClasseFranquia],[ClasseFranquia],[Cobertura],[DataInicioVigencia],[DataFimVigencia]
        ,[Combustivel],[PlacaVeiculo],[CHASSIS],[NumeroApoliceAnterior],[QuantidadeParcelas],[NomeCondutor1]
        ,[EstadoCivilCondutor1],[SexoCondutor1],[RGCondutor1],[DataNascimentoCondutor1],[CNHCondutor1]
        ,[DataCNHCondutor1],[CodigoRelacionamento],[NomeCondutor2],[EstadoCivilCondutor2],[SexoCondutor2]
        ,[RGCondutor2],[DataNascimentoCondutor2],[CNHCondutor2],[DataCNHCondutor2],[CodigoRelacionamentoCondutor2]
        ,[VersaoCalculo],[CodigoSeguradora],[CodigoRegiaoVistoriada],[CodigoTipoSeguro],[TipoSeguro], [TP])
     SELECT [Codigo],[NomeArquivo],[DataArquivo],[NumeroProposta],[DataHoraProcessamento],[TipoArquivo]
            ,[CodigoVeiculo],[DescricaoVeiculo],[CodigoRegiao],[AnoFabricacao],[AnoModelo],[Capacidade]
            ,[CodigoBonus],[CodigoSubProduto],[CodigoClasseFranquia],[ClasseFranquia],[Cobertura],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataInicioVigencia])),CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataFimVigencia]))
            ,[Combustivel],[PlacaVeiculo],[CHASSIS],[NumeroApoliceAnterior],[QuantidadeParcelas],[NomeCondutor1]
            ,[EstadoCivilCondutor1],[SexoCondutor1],[RGCondutor1], CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataNascimentoCondutor1])),[CNHCondutor1]
            ,CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataCNHCondutor1])),[CodigoRelacionamento],[NomeCondutor2],[EstadoCivilCondutor2],[SexoCondutor2]
            ,[RGCondutor2],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataNascimentoCondutor2])),[CNHCondutor2],CleansingKit.dbo.fn_DataDummy(CleansingKit.dbo.fn_DataValidaouNULL([DataCNHCondutor2])),[CodigoRelacionamentoCondutor2]
            ,[VersaoCalculo],[CodigoSeguradora],[CodigoRegiaoVistoriada],[CodigoTipoSeguro],[TipoSeguro], ''SRG1''--,[RANK]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_AUTOVARIAVEL_TIPO4_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
  EXEC (@COMANDO)

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.AUTOVARIAVEL_TIPO4_SRG_TMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP];


--EXEC [Dados].[proc_InsereProposta_PRPSASSE] 

