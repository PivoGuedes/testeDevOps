
CREATE PROCEDURE [Dados].[proc_InsereProvisaoComissao] (

	@CodigoBU varchar(100) = NULL
   ,@CodigoProdutor varchar(200) = NULL
   ,@CodigoProduto varchar(100) = NULL
   ,@DataCalculo varchar(100) = NULL
   ,@DataCompetencia Date,@CodigoOperacao varchar(20) = null
   ,@DataLancamentoPositivo Date
   ,@DataLancamentoNegativo date = null
)
													
AS 
BEGIN

declare @NumeroRecibo varchar(10)
declare @Comando nvarchar(max)
--set @CodigoBU = '00003'
if @CodigoBU is not null
begin
	create table #TableBU (CodigoBU varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AI)
	--declare @TableBU table (CodigoBU varchar(4))
	insert into #TableBU -- @TableBU
	SELECT items collate SQL_Latin1_General_CP1_CI_AI from CleansingKit.dbo.fn_Split(@CodigoBU,',')
	create clustered index cl_idx_bu_temp on #TableBU(CodigoBU)
end

--set @CodigoProdutor = '6'
if @CodigoProdutor is not null
begin
	create table  #TableProdutor (CodigoProdutor varchar(10))
	insert into #TableProdutor
	SELECT items    from CleansingKit.dbo.fn_Split(@CodigoProdutor,',')
end


--set @CodigoProduto = '3175,3179,3176,3180'
if @CodigoProduto is not null
begin
	create table #TableProduto (CodigoProduto varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AI)
	insert into #TableProduto
	SELECT items COLLATE SQL_Latin1_General_CP1_CI_AI from CleansingKit.dbo.fn_Split(@CodigoProduto,',')
	create clustered index cl_idx_PRD_temp on #TableProduto(CodigoProduto)
end

--set @CodigoOperacao = '1003,1001'
if @CodigoOperacao is not null
begin
	create table  #TableOperacao (CodigoOperacao varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AI)
	insert into #TableOperacao
	SELECT items COLLATE SQL_Latin1_General_CP1_CI_AI from CleansingKit.dbo.fn_Split(@CodigoOperacao,',')
end

if @DataCalculo is not null
begin
	create table  #TableDataCalculo (DataCalculo varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AI)
	insert into #TableDataCalculo
	SELECT items COLLATE SQL_Latin1_General_CP1_CI_AI from CleansingKit.dbo.fn_Split(@DataCalculo,',')
end

--set @DataLancamentoPositivo = '2017-06-02'
--select * from #TableBU
--select * from #TableProduto
--select * from #TableProdutor
--select * from #TableDataCalculo
--exec tempdb..sp_help #TableDataCalculo

--select * from #tableBU


--LANCAMENTO POSITIVO
set @NumeroRecibo  = LEFT(REPLACE(CAST(@DataCompetencia as varchar),'-',''),4)+'0000'+REPLACE(REPLACE(@CodigoBU,'0',''),',','')
set @Comando = '

INSERT INTO Dados.Comissao_partitioned
(
      [IDRamo]
      ,[PercentualCorretagem]
      ,[ValorCorretagem]  
      ,[ValorBase]  
      ,[ValorComissaoPAR]  
      ,[ValorRepasse]  
      ,[DataCompetencia]
      ,[DataRecibo]
      ,[NumeroRecibo]
      ,[NumeroEndosso]
      ,[NumeroParcela]
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
      ,[TipoCorretagem]
      ,[IDContrato]
      ,[IDCertificado]
      ,[IDOperacao]
      ,[IDProdutor]
      ,[IDFilialFaturamento]
      ,[CodigoSubgrupoRamoVida]
      ,[IDProduto]
      ,[IDUnidadeVenda]
      ,[IDProposta]
      ,[IDCanalVendaPAR]
      ,[NumeroProposta]
      ,[CodigoProduto]
      ,[LancamentoManual]
      ,[Repasse]
      ,[Arquivo]
      ,[DataArquivo]
      ,[IDEmpresa]
      ,[IDSeguradora]
      ,[NumeroReciboOriginal]
	  ,[LancamentoProvisao]
)

SELECT  
       [IDRamo]
      ,[PercentualCorretagem]
      ,[ValorCorretagem]  [ValorCorretagem]
      ,[ValorBase]  [ValorBase]
      ,[ValorComissaoPAR]  [ValorComissaoPAR]
      ,[ValorRepasse]  [ValorRepasse]
      ,cast('''+ cast(@DataLancamentoPositivo as varchar) + '''  as varchar) as [DataCompetencia]
      ,[DataRecibo]
      , '''+ @NumeroRecibo + ''' as [NumeroRecibo]
      ,[NumeroEndosso]
      ,[NumeroParcela]
      ,cp.[DataCalculo]
      ,[DataQuitacaoParcela]
      ,[TipoCorretagem]
      ,[IDContrato]
      ,[IDCertificado]
      ,[IDOperacao]
      ,[IDProdutor]
      ,cp.[IDFilialFaturamento]
      ,[CodigoSubgrupoRamoVida]
      ,[IDProduto]
      ,[IDUnidadeVenda]
      ,[IDProposta]
      ,[IDCanalVendaPAR]
      ,[NumeroProposta]
      ,cp.[CodigoProduto]
      ,cp.[LancamentoManual]
      ,[Repasse]
      ,[Arquivo]
      ,cp.[DataArquivo]
      ,[IDEmpresa]
      ,cp.[IDSeguradora]
      ,[NumeroReciboOriginal]
	  ,cast(''1''  as bit) as LancamentoProvisao
	  --into pqp
FROM Dados.Comissao Cp
'
If @CodigoBU is not null
begin
	set @Comando = @Comando + '
	inner join  #TableBU on  SUBSTRING(cp.ARQUIVO,46,5)  =  #TableBU.CodigoBU  '
end
 
 if @CodigoProduto is not null
begin
	set @comando = @Comando + '
	inner join  #TableProduto on  cp.CodigoProduto  =  #TableProduto.CodigoProduto  '
end

if @CodigoProdutor is not null
begin
set @comando = @Comando + '
inner join Dados.Produtor pd on pd.ID = cp.IDProdutor
inner join  #TableProdutor on  pd.Codigo  =  #TableProdutor.CodigoProdutor  '
end

 if @DataCalculo is not null
begin
	set @comando = @Comando + '
	inner join  #TableDataCalculo on  cp.DataCalculo  =  #TableDataCalculo.DataCalculo  '
end

if @CodigoOperacao is not null
begin
	set @comando = @Comando + '
	inner join Dados.ComissaoOperacao co on co.ID = cp.IDOperacao
	inner join  #TableOperacao on  co.Codigo =  #TableOperacao.CodigoOperacao  '
end
set @Comando = @Comando + ' where DataCompetencia = '''+ cast(@DataCompetencia as varchar(10)) + ''''
iF @DataCalculo IS NOT NULL
PRINT @Comando

--DECLARE @IntVariable int;  
--DECLARE @SQLString nvarchar(500);  
--DECLARE @ParmDefinition nvarchar(500);  
--SET @ParmDefinition = N'@TableBU table, @DataCompetencia date';  

 
EXEC sp_executesql
  @Comando--,@DataCompetencia = @DataCompetencia
  --select top 1 * from controledados.exportacaofaturamento
  set @Comando = 
  'INSERT INTO ControleDados.ExportacaoFaturamento (DataRecibo,NumeroRecibo,DataCompetencia,Autorizado,Processado,DataHoraRegistro,IDEmpresa)
  SELECT DISTINCT DataRecibo,'''+@NumeroRecibo+''',DataCompetencia,0,0,getdate(),IDEmpresa
  FROM Dados.Comissao where DataCompetencia = '''+ cast(@DataLancamentoPositivo as varchar) + '''  AND LancamentoProvisao = 1'
  print @Comando
EXEC sp_executesql
  @Comando
  ---LANCAMENTO NEGATIVO!!!!!!!!!!!!!!!!!!!!!!!!


  set @Comando = '

INSERT INTO Dados.Comissao_partitioned
(
      [IDRamo]
      ,[PercentualCorretagem]
      ,[ValorCorretagem]  
      ,[ValorBase]  
      ,[ValorComissaoPAR]  
      ,[ValorRepasse]  
      ,[DataCompetencia]
      ,[DataRecibo]
      ,[NumeroRecibo]
      ,[NumeroEndosso]
      ,[NumeroParcela]
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
      ,[TipoCorretagem]
      ,[IDContrato]
      ,[IDCertificado]
      ,[IDOperacao]
      ,[IDProdutor]
      ,[IDFilialFaturamento]
      ,[CodigoSubgrupoRamoVida]
      ,[IDProduto]
      ,[IDUnidadeVenda]
      ,[IDProposta]
      ,[IDCanalVendaPAR]
      ,[NumeroProposta]
      ,[CodigoProduto]
      ,[LancamentoManual]
      ,[Repasse]
      ,[Arquivo]
      ,[DataArquivo]
      ,[IDEmpresa]
      ,[IDSeguradora]
      ,[NumeroReciboOriginal]
	  ,[LancamentoProvisao]
)

SELECT  
       [IDRamo]
      ,[PercentualCorretagem]
       ,[ValorCorretagem] * -1 [ValorCorretagem]
      ,[ValorBase] * -1 [ValorBase]
      ,[ValorComissaoPAR] * -1 [ValorComissaoPAR]
      ,[ValorRepasse] * -1 [ValorRepasse]
      ,cast('''+ cast(@DataLancamentoNegativo as varchar) + '''  as varchar) as [DataCompetencia]
      ,[DataRecibo]
      , '''+ @NumeroRecibo + ''' as [NumeroRecibo]
      ,[NumeroEndosso]
      ,[NumeroParcela]
      ,cp.[DataCalculo]
      ,[DataQuitacaoParcela]
      ,[TipoCorretagem]
      ,[IDContrato]
      ,[IDCertificado]
      ,[IDOperacao]
      ,[IDProdutor]
      ,cp.[IDFilialFaturamento]
      ,[CodigoSubgrupoRamoVida]
      ,[IDProduto]
      ,[IDUnidadeVenda]
      ,[IDProposta]
      ,[IDCanalVendaPAR]
      ,[NumeroProposta]
      ,cp.[CodigoProduto]
      ,cp.[LancamentoManual]
      ,[Repasse]
      ,[Arquivo]
      ,cp.[DataArquivo]
      ,[IDEmpresa]
      ,cp.[IDSeguradora]
      ,[NumeroReciboOriginal]
	  ,cast(''1''  as bit) as LancamentoProvisao
	  --into pqp
FROM Dados.Comissao Cp
'
If @CodigoBU is not null
begin
	set @Comando = @Comando + '
	inner join  #TableBU on  SUBSTRING(cp.ARQUIVO,46,5)  =  #TableBU.CodigoBU  '
end
 
 if @CodigoProduto is not null
begin
	set @comando = @Comando + '
	inner join  #TableProduto on  cp.CodigoProduto  =  #TableProduto.CodigoProduto  '
end

if @CodigoProdutor is not null
begin
set @comando = @Comando + '
inner join Dados.Produtor pd on pd.ID = cp.IDProdutor
inner join  #TableProdutor on  pd.Codigo  =  #TableProdutor.CodigoProdutor  '
end

 if @DataCalculo is not null
begin
	set @comando = @Comando + '
	inner join  #TableDataCalculo on  cp.DataCalculo  =  #TableDataCalculo.DataCalculo  '
end

if @CodigoOperacao is not null
begin
	set @comando = @Comando + '
	inner join Dados.ComissaoOperacao co on co.ID = cp.IDOperacao
	inner join  #TableOperacao on  co.Codigo =  #TableOperacao.CodigoOperacao  '
end
set @Comando = @Comando + ' where DataCompetencia = '''+ cast(@DataCompetencia as varchar(10)) + ''''
iF @DataCalculo IS NOT NULL
PRINT @Comando

 
EXEC sp_executesql
@Comando


  set @Comando = 
  'INSERT INTO ControleDados.ExportacaoFaturamento (DataRecibo,NumeroRecibo,DataCompetencia,Autorizado,Processado,DataHoraRegistro,IDEmpresa)
	SELECT DISTINCT DataRecibo,'''+@NumeroRecibo+''',DataCompetencia,0,0,getdate(),IDEmpresa
   FROM Dados.Comissao where DataCompetencia = '''+ cast(@DataLancamentoNegativo as varchar) + '''  AND LancamentoProvisao = 1'
  print @Comando
EXEC sp_executesql
  @Comando
END



