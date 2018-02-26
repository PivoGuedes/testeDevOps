   
/*  
 Autor: Pedro Guedes  
 Data Criação:17/03/2016  
  
 Descrição:   
   
 Última alteração :  Adequação para o Indice UNQ_PROPOSTA_FINANCEIRO na Dados.PropostaFinanceiro
 Fernando Messas
 08/03/2017
*/  
  
/*******************************************************************************  
 Nome: CORPORATIVO.Dados.[proc_InsereProposta_PRESTAMISTA_SIAPX]  
 Descrição: Procedimento que realiza a inserção de propostas no banco de dados.  
    
 Parâmetros de entrada:  
  
  
 Retorno:  
   
  
  
   
*******************************************************************************/  
CREATE PROCEDURE [Dados].[proc_InsereProposta_PRESTAMISTA_SIAPX]   
AS  
  
BEGIN TRY    
--set statistics io off  
DECLARE @Produtos AS VARCHAR(8000)  
DECLARE @PontoDeParada AS VARCHAR(400)  
DECLARE @MaiorCodigo AS BIGINT  
DECLARE @ParmDefinition NVARCHAR(500)  
DECLARE @COMANDO AS NVARCHAR(MAX)   
  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_SIAPX_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)  
 DROP TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP];  
--select * from [PRESTAMISTA_SIAPX_TEMP]  
CREATE TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP](  
 --[Codigo] [bigint]  NOT NULL,                               
 --[ControleVersao] [decimal](16, 8) NULL,        
 --[NomeArquivo] [varchar](300) NOT NULL,        
 --[DataArquivo] [date] NULL,           
 --[NumeroProduto] [varchar](4) NULL,         
 --[TipoCredito] [char](2) NULL,          
 --[NumeroProposta] [varchar](20) NULL,        
 --[NumeroContrato] [varchar](20) NULL,        
 --[CodigoSubestipulante] INT,                                
 --[RendaPactuada] [varchar](10) NULL,         
 --[CodigoESCNEG] [varchar](10) NULL,         
 --[CodigoPV] [smallint] NULL,           
 --[CodigoUnoNum] [varchar](10) NULL,         
 --[CodigoUnoDv] [char](1) NULL,          
 --[NomeSegurado] [varchar](60) NULL,         
 --[DataNascimento] [date] NULL,          
 --[CPFCNPJ] [char](14) NULL,           
 --[DataContrato] [date] NULL,           
 --[DataInclusao] [date] NULL,           
 --[DataAmortizacao] [date] NULL,          
 --[PrazoVigencia] int NULL,           
 --[NumeroOrdemInclusao] [varchar](10) NULL,       
 --[NumeroRI] [varchar](5) NULL,          
 --[IDISMip] tinyint NULL,        
 --[ValorFinanciamento] [numeric](16, 2) NULL,       
 --[PremioMip] [numeric](16, 2) NULL,         
 --[IOFMip] [numeric](16, 2) NULL,          
 --[PremioMipAtrasado] [numeric](16, 2) NULL,       
 --[IOFMipAtrasado] [numeric](16, 2) NULL,        
 --[IDISInad] tinyint NULL,      
 --[PremioInad] [numeric](16, 2) NULL,         
 --[IOFInad] [numeric](16, 2) NULL,         
 --[PremioInadAtrasado] [numeric](16, 2) NULL,       
 --[IOFInadAtrasado] [numeric](16, 2) NULL,       
 --[UF] [char](2) NULL,            
 --[Cidade] [varchar](25) NULL,          
 --[Bairro] [varchar](20) NULL,          
 --[Logradouro] [varchar](40) NULL,         
 --[Complemento] [varchar](25) NULL,         
 --[Numero] [varchar](5) NULL,           
 --[CEP] [varchar](10) NULL,           
 --[CodigoSeguradora] smallint default(1) NOT NULL    
  
 [UF] [VARCHAR](2) NULL,  
 [CEP] [VARCHAR](8) NULL,  
 [DDD] [VARCHAR](4) NULL,  
 [MES_REFERENCIA_MOVIMENTO] [DATE] NULL,  
 [MES_GERACAO_ARQUIVO] [DATE] NULL,  
 [COD_PRODUTO] [VARCHAR](4) NULL,  
 [COD_TIPO_REPASSE] [VARCHAR](1) NULL,  
 [SUREG_CONCESSAO] [VARCHAR](2) NULL,  
 [AGENCIA_CONCESSAO] [VARCHAR](4) NULL,  
 [OPERACAO_APLICACAO] [VARCHAR](4) NULL,  
 [NUM_CONTRATO] [VARCHAR](18) NOT NULL,  
 [NUM_DV_CONTRATO] [VARCHAR](2) NOT NULL,  
 [COD_MODALIDADE_OPER] [VARCHAR](4) NULL,  
 [COD_CANAL] [VARCHAR](2) NULL,  
 [NOME_CANAL] [VARCHAR](30) NULL,  
 [NOME_CLIENTE] [VARCHAR](100) NULL,  
 [DTA_CONCESSAO_CONTR][DATE] NOT NULL,  
 [DTA_TERMINO_CONTR] [DATE]  NOT NULL,  
 [VALOR_CONTRATO] [DECIMAL] (18,2) NULL,  
 [VALOR_SEGURO]  [DECIMAL] (18,2) NULL,  
 [TIPO_PESSOA] [VARCHAR](1) NULL,  
 [NUM_CPF_CGC] [VARCHAR](20) NULL,  
 [TAXA_APLICADA] [DECIMAL](5,2) NULL,  
 [COD_NAT_EMPRESA] [VARCHAR](2) NULL,  
 [EST_CONTRATO_ORIGEM] [VARCHAR](255) NULL,  
 [COD_NAT_PROFISSIONAL] [VARCHAR](255) NULL,  
 [PRZ_VENC_CONTRATO] [VARCHAR](3) NULL,  
 [DT_NASCIMENTO] [DATE] NULL,  
 [IDADE] [VARCHAR](3) NULL,  
 [SEXO] [CHAR](1) NULL,  
 [ESTADO_CIVIL] [VARCHAR](2) NULL,  
 [ENDERECO] [VARCHAR](100) NULL,  
 [COMPL_ENDERECO] [VARCHAR](50) NULL,  
 [CIDADE] [VARCHAR](50) NULL,  
 [TELEFONE] [VARCHAR](9) NULL,  
 [EMAIL] [VARCHAR](100) NULL,  
 [COD_MATRICULA] [VARCHAR](10) NULL,  
 [TIPO_CORRESPONDENTE] [VARCHAR](2) NULL,  
 [COD_CORRESPONDENTE] [VARCHAR](8) NULL,  
 [DV_CORRESPONDENTE] [VARCHAR](2) NULL,  
 [Column 40] [VARCHAR](255) NULL,  
 [NomeArquivo] [VARCHAR](50) NULL,  
 [DataArquivo] [DATETIME] NULL,  
 [ID] [INT] NOT NULL,  
 [AgenciaInt] smallint not null,  
 Contrato  AS SUREG_CONCESSAO+right('0000'+AGENCIA_CONCESSAO,4)+OPERACAO_APLICACAO+right('0000000'+NUM_CONTRATO,7)+NUM_DV_CONTRATO PERSISTED,  
 --[PropostaPS] as 'PS0'+COD_CANAL+AGENCIA_CONCESSAO+RIGHT(NUM_CONTRATO ,6) +'0'+'_' PERSISTED,  
 [PropostaPS] AS 'PS000'/*+COD_CANAL*/+RIGHT('0000'+LTRIM(RTRIM(AGENCIA_CONCESSAO)),4)+RIGHT('000000'+NUM_CONTRATO ,6) +'0'+'_' PERSISTED,  
 --NumeroProposta AS 'PS00_'+AGENCIA_CONCESSAO+RIGHT(NUM_CONTRATO ,6) +'0'+'_' PERSISTED  
 NumeroProposta as RIGHT('0000'+LTRIM(RTRIM(AGENCIA_CONCESSAO)),4) +'77' + RIGHT('000000'+NUM_CONTRATO,6) + '0' PERSISTED,  
 --NumeroPropostaInclusao as [COD_CANAL] + AGENCIA_CONCESSAO +'77' + RIGHT(NUM_CONTRATO,6) + '0' PERSISTED  
 NumeroPropostaInclusao as 'PS0'+RIGHT('00'+COD_CANAL,2)+RIGHT('0000'+LTRIM(RTRIM(AGENCIA_CONCESSAO)),4)+RIGHT('000000'+NUM_CONTRATO ,6) +'0'+'_' PERSISTED  
);  
  
--CREATE NONCLUSTERED INDEX [IDX_NCL_PRESTAMISTA_SIAPX_TEMP_CodigoSeguradora]  
--ON [dbo].[PRESTAMISTA_SIAPX_TEMP] ([CodigoSeguradora])  
--INCLUDE ([NumeroProposta])  
  
  
-- /*Cria alguns índices para facilitar a busca*/    
CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_SIAPX_TEMP_NumeroProposta ON [dbo].[PRESTAMISTA_SIAPX_TEMP]  
(   
 NumeroProposta ASC,  
 [DataArquivo] DESC  
)  
  
--CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_SIAPX_TEMP_NumeroProduto ON [dbo].[PRESTAMISTA_SIAPX_TEMP]  
--([NumeroProduto])  
--INCLUDE ([NumeroProposta],[Logradouro])  
  
  
CREATE CLUSTERED INDEX idx_PRESTAMISTA_SIAPX_TEMP_NumeroProposta_AgenciaInt ON [dbo].[PRESTAMISTA_SIAPX_TEMP]   
(   
 NumeroProposta ASC,  
 [AgenciaInt] ASC  
)  
  
CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_SIAPX_TEMP_NumeroProposta2 ON [dbo].[PRESTAMISTA_SIAPX_TEMP]  
(   
 NumeroProposta ASC  
)  
  
CREATE NONCLUSTERED INDEX [ncl_idx_PropostaInclusao_SIAPX_TEMP]  
ON [dbo].[PRESTAMISTA_SIAPX_TEMP] ([NumeroPropostaInclusao])  
INCLUDE ([DTA_CONCESSAO_CONTR],[VALOR_CONTRATO],[PRZ_VENC_CONTRATO],[NomeArquivo],[DataArquivo],[Contrato],[NumeroProposta])  
  
  
--CREATE NONCLUSTERED INDEX IDX_NCL_PRESTAMISTA_SIAPX_TEMP_CodigoPV  
--ON [dbo].[PRESTAMISTA_SIAPX_TEMP] ([CodigoPV])  
--SELECT @@TRANCOUNT  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.propostaPS') AND type in (N'U') /*ORDER BY NAME*/)  
DROP TABLE dbo.propostaPS  
SELECT --count(*)  
 NumeroProposta,p.ID,--,DataProposta,DataInicioVigencia,ID,ValorPremioLiquidoEmissao,  
CASE WHEN LEFT(NumeroProposta,2) = 'PS' THEN SUBSTRING(REPLACE(NumeroProposta,'PS0',''),3,4) +'77' + SUBSTRING(Numeroproposta,10,LEN(NumeroProposta)-10)  
--ELSE   
--SUBSTRING(NumeroProposta,3,4) + SUBSTRING(NumeroProposta,9,7) END PropostaSem77,  
--SUBSTRING(NumeroProposta,3,LEN(NumeroProposta) -2)  PropostaSemCanal,  
else right(NumeroProposta,len(numeroProposta)-2)  
--,len(left(NumeroProposta,len(numeroProposta)-3))-2)  
 end PropostaSemCanal,  
 'PS000'+SUBSTRING(NumeroProposta,6,12) AS NumeroPropostaTratado,  
  DataProposta,  
  ValorPremioBrutoEmissao,  
  replace(CPFCNPJ,'.','') as CPFCNPJ  
INTO  propostaPS   
FROM Dados.Proposta  p  
inner join Dados.PropostaCliente pc on pc.IDProposta = p.ID  
WHERE  p.NumeroProposta like 'PS%'  
  
CREATE CLUSTERED INDEX cl_idx_ps ON propostaPS(NumeroPropostaTratado)  
  
CREATE NONCLUSTERED INDEX [ncl_idx_PrpIDCanal]  
ON [dbo].[propostaPS] ([ID])  
INCLUDE (NumeroPropostaTratado,[PropostaSemCanal],NumeroProposta)  
  
----------------------------------------------------------------------  
SELECT @PontoDeParada = PontoParada  
FROM  ControleDados.PontoParada    
WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'  
--SET @PontoDeParada = '0'  
  
/*********************************************************************************************************************/                 
/*Recupeara maior Código do retorno*/  
/*********************************************************************************************************************/  
SET @COMANDO =  
    N'  INSERT INTO dbo.PRESTAMISTA_SIAPX_TEMP  
      (  
      [UF]  
      ,[CEP]  
      ,[DDD]  
      ,[MES_REFERENCIA_MOVIMENTO]  
      ,[MES_GERACAO_ARQUIVO]  
      ,[COD_PRODUTO]  
      ,[COD_TIPO_REPASSE]  
      ,[SUREG_CONCESSAO]  
      ,[AGENCIA_CONCESSAO]  
      ,[OPERACAO_APLICACAO]  
      ,[NUM_CONTRATO]  
      ,[NUM_DV_CONTRATO]  
      ,[COD_MODALIDADE_OPER]  
      ,[COD_CANAL]  
      ,[NOME_CANAL]  
      ,[NOME_CLIENTE]  
      ,[DTA_CONCESSAO_CONTR]  
      ,[DTA_TERMINO_CONTR]  
      ,[VALOR_CONTRATO]  
      ,[VALOR_SEGURO]  
      ,[TIPO_PESSOA]  
      ,[NUM_CPF_CGC]  
      ,[TAXA_APLICADA]  
      ,[COD_NAT_EMPRESA]  
      ,[EST_CONTRATO_ORIGEM]  
      ,[COD_NAT_PROFISSIONAL]  
      ,[PRZ_VENC_CONTRATO]  
      ,[DT_NASCIMENTO]  
      ,[IDADE]  
      ,[SEXO]  
      ,[ESTADO_CIVIL]  
      ,[ENDERECO]  
      ,[COMPL_ENDERECO]  
      ,[CIDADE]  
      ,[TELEFONE]  
      ,[EMAIL]  
      ,[COD_MATRICULA]  
      ,[TIPO_CORRESPONDENTE]  
      ,[COD_CORRESPONDENTE]  
      ,[DV_CORRESPONDENTE]  
      ,[Column 40]  
      ,[NomeArquivo]  
      ,[DataArquivo]  
      ,[ID]  
   ,[AgenciaInt]  
   )  
       SELECT   
     [UF]  
      ,[CEP]  
      ,[DDD]  
      ,[MES_REFERENCIA_MOVIMENTO]  
      ,[MES_GERACAO_ARQUIVO]  
      ,[COD_PRODUTO]  
      ,[COD_TIPO_REPASSE]  
      ,[SUREG_CONCESSAO]  
      ,[AGENCIA_CONCESSAO]  
      ,[OPERACAO_APLICACAO]  
      ,[NUM_CONTRATO]  
      ,[NUM_DV_CONTRATO]  
      ,[COD_MODALIDADE_OPER]  
      ,[COD_CANAL]  
      ,[NOME_CANAL]  
      ,[NOME_CLIENTE]  
      ,[DTA_CONCESSAO_CONTR]  
      ,[DTA_TERMINO_CONTR]  
      ,[VALOR_CONTRATO]  
      ,[VALOR_SEGURO]  
      ,[TIPO_PESSOA]  
      ,[NUM_CPF_CGC]  
      ,[TAXA_APLICADA]  
      ,[COD_NAT_EMPRESA]  
      ,[EST_CONTRATO_ORIGEM]  
      ,[COD_NAT_PROFISSIONAL]  
      ,[PRZ_VENC_CONTRATO]  
      ,[DT_NASCIMENTO]  
      ,[IDADE]  
      ,[SEXO]  
      ,[ESTADO_CIVIL]  
      ,[ENDERECO]  
      ,[COMPL_ENDERECO]  
      ,[CIDADE]  
      ,[TELEFONE]  
      ,[EMAIL]  
      ,[COD_MATRICULA]  
      ,[TIPO_CORRESPONDENTE]  
      ,[COD_CORRESPONDENTE]  
      ,[DV_CORRESPONDENTE]  
      ,[Column 40]  
      ,[NomeArquivo]  
      ,[DataArquivo]  
      ,[ID]  
   ,[AgenciaInt]  
       FROM OPENQUERY ([OBERON],   
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPrestamistaSIAPX] ''''' + @PontoDeParada + ''''''') PRP  
         '  
   --print @COMANDO  
 exec sp_executesql  @tsql  = @COMANDO  
  
SELECT @MaiorCodigo= MAX(PRP.ID)  
FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP                      
  
/*********************************************************************************************************************/  
                             
SET @COMANDO = ''   
  
WHILE @MaiorCodigo IS NOT NULL  
BEGIN  
  
  
--SELECT * FROM Dados.Proposta WHERE NumeroProposta LIKE 'PS%' AND TipoDado LIKE '%CXRELAT%'  
   
  /*********************************************************************************************************************/  
    
 --------------------------------------------------------------------------------------------------------------  
 --Converte os produtos de presta mista com outros números para os códigos corretos  
 --------------------------------------------------------------------------------------------------------------  
   
  
 /***********************************************************************  
     Carregar as agencias desconhecidas  
 ***********************************************************************/  
 /*INSERE PVs NÃO LOCALIZADOS*/  
 ;INSERT INTO Dados.Unidade(Codigo)  
 SELECT DISTINCT CAD.AGENCIA_CONCESSAO AS CodigoPV  
 FROM dbo.[PRESTAMISTA_SIAPX_TEMP] CAD  
 WHERE  CAD.AGENCIA_CONCESSAO IS NOT NULL   
   AND NOT EXISTS (  
       SELECT     *  
       FROM  Dados.Unidade U  
       WHERE U.Codigo = CAD.AGENCIA_CONCESSAO);  
  
 INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)  
 SELECT DISTINCT U.ID,   
     'UNIDADE COM DADOS INCOMPLETOS' [Unidade],   
     -1 [CodigoNaFonte],   
     'PRPSASSE' [TipoDado],   
     MAX(EM.DataArquivo) [DataArquivo],   
     'PRPSASSE' [Arquivo]  
  
 FROM dbo.[PRESTAMISTA_SIAPX_TEMP] EM  
 INNER JOIN Dados.Unidade U  
 ON EM.AGENCIA_CONCESSAO = U.Codigo  
 WHERE   
  NOT EXISTS (  
     SELECT     *  
     FROM Dados.UnidadeHistorico UH  
     WHERE UH.IDUnidade = U.ID)      
 GROUP BY U.ID   
   
     /***********************************************************************  
       Carrega os dados da Proposta   
    **********************************************************************/               
   
    
    ;MERGE INTO Dados.Proposta AS T  
  USING (  
       select *   
    from (    
      SELECT   *,ROW_NUMBER() OVER (PARTITION BY NumeroPropostaInclusao order by IDProposta desc,DataARquivo desc) linha  
         FROM  
         (  
       SELECT  --COUNT(*)  
       --numeropropostainclusao,count(numeropropostainclusao) select @@trancount  
         coalesce(pp2.ID,pp.id) as IDProposta,prd.ID AS IDProduto,PRP.NumeroProposta,PRP.DTA_CONCESSAO_CONTR AS DataProposta,PRP.VALOR_SEGURO AS ValorPremioBrutoEmissao,  
         PRP.VALOR_SEGURO-(VALOR_SEGURO*0.038) as ValorPremioLiquido,  
        u.ID AS IDUnidade,SIG.ID AS IDProdutoSIGPF,1 AS IDSeguradora,prp.DTA_CONCESSAO_CONTR AS DataInicioVigencia,  
         prp.DTA_TERMINO_CONTR AS DataFimVigencia,prp.NUM_CPF_CGC,--prp.NumeroProposta ORDER BY PRP.DataArquivo DESC) linha,  
        PRP.DataArquivo,PRP.NomeArquivo,NumeroPropostaInclusao,FU.ID as IDFuncionario--pp.DataProposta AS DAtaTeste,*          
        --NumeroPropostaInclusao,count(NumeroPropostaInclusao)  
       
     FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
     INNER  JOIN Dados.Produto PRD  
     ON PRD.CodigoComercializado = PRP.COD_PRODUTO  
     INNER JOIN Dados.ProdutoSIGPF SIG  
     ON SIG.ID = PRD.IDProdutoSIGPF  
       
     INNER JOIN Dados.Unidade U  
     ON U.Codigo = PRP.AgenciaInt  
     OUTER APPLY(SELECT top 1 ID from  Dados.Funcionario FU where FU.Matricula = RIGHT('00000000'+replace(PRP.[COD_MATRICULA],'C',''),8)  order by DAtaArquivo desc) FU  
       
     LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and (ps.CPFCNPJ = PRP.NUM_CPF_CGC OR PS.CPFCNPJ is null) -- and PS.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
     left join Dados.Proposta pp on pp.ID = ps.ID   
     left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroPropostaInclusao   
     --where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'  
--     SELECT * FROM propostaPS WHERE ID IN (67291370  
--WHERE PRP.ID = 407404  
--,66690729)  
  
       
     ) A  
   )b  
     WHERE LINHA = 1  --and IDProposta = 52049746  
       
     
          ) AS X  
    ON  T.ID = X.IDProposta  
   --AND X.IDSeguradora = T.IDSeguradora  
    WHEN MATCHED  
       THEN UPDATE  
         SET                                  
      IDProduto = COALESCE(T.IDProduto,X.IDProduto),  
      --NumeroProposta = COALESCE(T.NumeroProposta,X.NumeroProposta),  
      DataProposta = COALESCE(T.DataProposta,X.DataProposta),  
      ValorPremioBrutoEmissao = COALESCE(T.ValorPremioBrutoEmissao,X.ValorPremioBrutoEmissao) ,  
      --IDProposta = COALESCE(T.IDProposta,X.IDProposta),  
      IDAgenciaVenda = COALESCE(T.IDAgenciaVenda,X.IDUnidade),  
      IDProdutoSIGPF = COALESCE(T.IDProdutoSIGPF,X.IDProdutoSIGPF) ,  
      IDSeguradora = COALESCE(T.IDSeguradora,X.IDSeguradora),  
      DataInicioVigencia = COALESCE(T.DataInicioVigencia,X.DataInicioVigencia),  
      DataFimVigencia = COALESCE(T.DataFimVigencia,X.DataFimVigencia) ,  
      DataArquivo = coalesce(T.DataArquivo,X.DataArquivo),  
      TipoDado  = COALESCE(T.TipoDado,X.NomeArquivo),  
      IDFuncionario = COALESCE(T.IDFuncionario,X.IDFuncionario)  
      --NumeroPropostaOriginal = X.NumeroPropostaInclusao  
    WHEN NOT MATCHED  
       THEN INSERT            
              (       IDProduto,  
      NumeroProposta,  
      DataProposta,  
      ValorPremioBrutoEmissao,  
      ValorPremioLiquidoEmissao,  
      IDAgenciaVenda,  
      IDProdutoSIGPF,  
      IDSeguradora,  
      DataInicioVigencia,  
      DataFimVigencia,  
      DataArquivo,  
      TipoDado,  
      Valor,   
      IDFuncionario                    
             )  
          VALUES ( X.IDProduto,  
      X.NumeroPropostaInclusao,  
      X.DataProposta,  
      X.ValorPremioBrutoEmissao,  
      X.ValorPremioLiquido,  
      X.IDUnidade,  
      X.IDProdutoSIGPF,  
      X.IDSeguradora,  
      X.DataInicioVigencia,  
      X.DataFimVigencia,   
      X.DataArquivo,  
      X.NomeArquivo,  
      X.ValorPremioBrutoEmissao,  
      X.IDFuncionario           
     );                                                                    
      
     /***********************************************************************  
       Carrega os dados do Cliente da proposta BEGIN TRAN   
     ***********************************************************************/                   
    ;MERGE INTO Dados.PropostaCliente AS T  
  USING (  
    SELECT *  
    FROM  
    (  
    SELECT    
         COALESCE(PP2.ID, Pp.ID) [IDProposta]  
         -- Cliente  
        , prp.NOME_CLIENTE AS Nome  
        , prp.DT_NASCIMENTO AS [DataNascimento]  
        , cleansingkit.dbo.fn_formatacpf(replace(prp.NUM_CPF_CGC,'-','')) AS [CPFCNPJ]  
        , CASE WHEN prp.TIPO_PESSOA = 'F' THEN 'Pessoa Física' ELSE 'Pessoa Jurídica' END AS TipoPessoa  
        , PRP.DataArquivo                        --[CodigoPV],                           
           , PRP.[NomeArquivo] TipoDado               
        , CASE WHEN PRP.SEXO = 'F' THEN 2 WHEN PRP.SEXO = 'M' THEN 1 ELSE 0 end as IDSexo            
        , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroPropostaInclusao ORDER BY PRP.DataArquivo DESC) [RANK]     
        
       
     FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
          
     LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and (ps.CPFCNPJ = PRP.NUM_CPF_CGC OR PS.CPFCNPJ is null) AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
     left join Dados.Proposta pp on pp.ID = ps.ID   
     left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroPropostaInclusao   
     --left join Dados.PropostaCliente pc on pc.IDProposta = pp.ID  
     --where pp.ID = 67399930  
      --where prp.ID = 407404  
       
    ) A  
    WHERE [RANK] = 1 and IDProposta is not null  
          ) AS X  
    ON X.IDProposta = T.IDProposta  
       WHEN MATCHED  
       THEN UPDATE  
       SET CPFCNPJ = COALESCE(T.[CPFCNPJ], X.[CPFCNPJ])  
               , Nome = COALESCE(T.[Nome], X.[Nome])  
               , DataNascimento = COALESCE(T.[DataNascimento], X.[DataNascimento])  
               , TipoPessoa  = COALESCE(T.[TipoPessoa ], X.[TipoPessoa])  
               , TipoDado = COALESCE(T.[TipoDado], X.[TipoDado])  
               , DataArquivo = COALESCE(T.[DataArquivo], X.[DataArquivo])   
      , IDSexo = COALESCE(T.IDSexo, X.IDSexo)   
    WHEN NOT MATCHED  
       THEN INSERT            
             ( IDProposta  
     , CPFCNPJ  
     , Nome  
     , DataNascimento  
     , TipoPessoa  
              , TipoDado  
     , DataArquivo  
     , IDSexo  
    )  
          VALUES   
        (  
            X.IDProposta          
                 ,X.CPFCNPJ             
                 ,X.Nome                
                 ,X.DataNascimento      
                 ,X.TipoPessoa     
                 ,X.TipoDado            
                 ,X.DataArquivo  
     ,X.IDSexo  
              );  
      /***********************************************************************/  
          
 UPDATE Dados.PropostaEndereco SET LastValue = 0  
   -- SELECT *  
    FROM Dados.PropostaEndereco PS  
    WHERE PS.IDProposta IN (   
                        select IDProposta from ( SELECT  coalesce(pp2.ID,pp.id) as IDProposta,ROW_NUMBER() OVER ( PARTITION BY coalesce(pp.ID,pp2.id) ORDER BY PRP.DATAARQUIVO DESC,coalesce(pe1.DataArquivo,pe2.DataArquivo) desc ) [rank]  
       FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
       LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and (ps.CPFCNPJ = PRP.NUM_CPF_CGC OR PS.CPFCNPJ is null) AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
       left join Dados.Proposta pp on pp.ID = ps.ID and pp.IDseguradora = 1  
       left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroPropostaInclusao and pp2.IDseguradora = 1  
       left join Dados.PropostaEndereco pe1 on pe1.IDProposta = pp.ID  
       left join DAdos.PropostaEndereco pe2 on pe2.IDProposta = pp2.ID  
       --where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'  
        
        ) x  where [rank] = 1  
       
  
                           )  
           AND PS.LastValue = 1  
      
                        
     /***********************************************************************  
       Carrega os dados do Cliente da proposta  
     ***********************************************************************/                   
    ;MERGE INTO Dados.PropostaEndereco AS T  
  USING (  
    SELECT   
      A. [IDProposta]  
     ,A.[IDTipoEndereco]  
     ,A.[Endereco]          
     --,A.Bairro                
     ,A.Cidade         
     ,A.[UF]        
     ,A.CEP      
     , 0 LastValue  
     , A.[TipoDado]             
     , A.DataArquivo    
    FROM  
    (  
     SELECT     
       coalesce(pP2.ID,pp.id) [IDProposta]  
      ,2 [IDTipoEndereco] --Correspondecia  
      ,RTRIM(PRP.ENDERECO) + ' '  +  LTRIM(PRP.COMPL_ENDERECO) AS Endereco      
      --,PRT.COMPL_ENDERECO  
      ,PRP.CIDADE Cidade         
      ,PRP.UF         
      ,PRP.CEP CEP     
      --CASE WHEN    
      ,NomeArquivo [TipoDado]             
      ,PRP.DataArquivo DataArquivo  
      ,ROW_NUMBER() OVER (PARTITION BY PRP.NumeroPropostaInclusao /*IDProposta*/  ORDER BY PRP.DataArquivo DESC) NUMERADOR              
      FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
     left JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and ps.CPFCNPJ = PRP.NUM_CPF_CGC --OR PS.CPFCNPJ is null)  
      AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
     left join Dados.Proposta Pp on pp.ID = ps.ID and pp.IDSeguradora = 1  
     left join Dados.Proposta Pp2 on  pp2.NumeroProposta = prp.NumeroPropostaInclusao and pp2.IDSeguradora = 1  
     --where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'  
       
  
    ) A    
    WHERE [NUMERADOR] = 1 and IDProposta is not null --AND IDPROPOSTA = 66708503--PRP_T.NumeroProposta = 012984710001812     
  
          ) AS X  
    ON  X.IDProposta = T.IDProposta  
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]  
    --AND X.[DataArquivo] >= T.[DataArquivo]  
 AND X.[Endereco] = T.[Endereco]  
       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN    
        UPDATE  
    SET   
                 Endereco = COALESCE(X.[Endereco], T.[Endereco])  
               --, Bairro = COALESCE(X.[Bairro], T.[Bairro])  
               , Cidade = COALESCE(X.[Cidade], T.[Cidade])  
               , UF = COALESCE(X.[UF], T.[UF])  
               , CEP = COALESCE(X.[CEP], T.[CEP])  
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])  
      , DataArquivo = X.DataArquivo  
      , LastValue = X.LastValue  
    WHEN NOT MATCHED  
       THEN INSERT            
              ( IDProposta, IDTipoEndereco, Endereco                                                                  
              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                              
          VALUES (  
                  X.[IDProposta]     
                 ,X.[IDTipoEndereco]                                                  
                 ,X.[Endereco]    
                 --,X.[Bairro]     
                 ,X.[Cidade]        
                 ,X.[UF]   
                 ,X.[CEP]              
                 ,X.[TipoDado]                          ,X.[DataArquivo]  
     ,X.LastValue     
                 );  
     
 /*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/   
    UPDATE Dados.PropostaEndereco SET LastValue = 1  
    FROM Dados.PropostaEndereco PE  
 INNER JOIN (   
    SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC) [ORDEM]  
    FROM Dados.PropostaEndereco PS  
    WHERE PS.IDProposta IN (  
            
                        select IDProposta from ( SELECT  coalesce(pp2.ID,pp.id) as IDProposta,ROW_NUMBER() OVER ( PARTITION BY coalesce(pp.ID,pp2.id) ORDER BY PRP.DATAARQUIVO DESC ) [rank]  
       FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
       LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and (ps.CPFCNPJ = PRP.NUM_CPF_CGC OR PS.CPFCNPJ is null) AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
       left join Dados.Proposta pp on pp.ID = ps.ID and pp.IDseguradora = 1  
       left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroPropostaInclusao and pp2.IDseguradora = 1  
       --where pp.ID = 52049746 or pp2.ID = 52049746  
       --where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'  
         
        ) x  where [rank] = 1  
           
                           )   
        
     ) A   
  ON A.ID = PE.ID and IDTipoEndereco = 2 and A.ORDEM = 1  
  /*************************************************************************************/  
  /*Chama a PROC que roda a importação registro a registro dos detalhes do PRESTAMINSTA*/   
  /*************************************************************************************/   
    ;MERGE INTO Dados.PropostaFinanceiro AS T  
  USING (         
            SELECT * FROM  
            (  
    SELECT --top 10    
        PRP.[NomeArquivo] [Arquivo]                                                  
    ,  PRP.[DataArquivo]                             
    ,  coalesce(PRP2.ID,prp1.ID) [IDProposta]                      
    ,  PRP.[NumeroProposta] [NumeroProposta]                                              
    ,  PRP.CONTRATO AS [NumeroContratoVinculado]    
    ,  PRP.DTA_CONCESSAO_CONTR AS DataContrato  
    ,  PRP.DTA_CONCESSAO_CONTR AS DataInclusao  
    ,  PRP.VALOR_CONTRATO AS [ValorFinanciamento]  
    ,  PRP.PRZ_VENC_CONTRATO AS PrazoVigencia  
    , prp.NumeroPropostaInclusao  
     
    , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta  ORDER BY PRP.[DataArquivo] DESC)  [ORDER]  
   FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
      
     left JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and ps.CPFCNPJ = PRP.NUM_CPF_CGC --OR PS.CPFCNPJ is null)-- AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
     left join Dados.Proposta PRP1 on PRP1.ID = ps.ID   
     left join Dados.Proposta PRP2 on  prp2.NumeroProposta = prp.NumeroPropostaInclusao  
     --left join Dados.PropostaCliente pc on pc.IDProposta = PRP1.ID  
    --INNER JOIN Dados.Proposta PRP1  
    --ON PRP.NumeroPropostaInclusao like PRP1.NumeroProposta  
    left JOIN Dados.Seguradora SGD  
    ON   PRP1.IDSeguradora = SGD.ID    
    --where prp1.ID = 67399930  
    --where NUM_CPF_CGC = '059794471-72'  
    --LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and (ps.CPFCNPJ = PRP.NUM_CPF_CGC OR PS.CPFCNPJ is null) AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
    -- left join Dados.Proposta pp on pp.ID = ps.ID   
           
            ) A  
   --left join dados.propostafinanceiro pf on pf.idproposta = a.idproposta  
            WHERE A.[ORDER] = 1 --and IDProposta is null  
   --AND A.IDProposta = 50811637  
   --and a.numerocontratovinculado = '3415800899601'  
  
            /*LEFT JOIN Dados.Contrato CNT  
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */  
          ) AS X  
    ON  X.[IDProposta] = T.[IDProposta]  
	AND X.DataArquivo=T.DataArquivo
	AND X.NumeroContratoVinculado=T.NumeroContratoVinculado
     WHEN NOT MATCHED    
       THEN INSERT            
              (   Arquivo                                              
    ,DataArquivo               
    ,IDProposta             
    ,NumeroContratoVinculado          
    ,DataContrato   
    ,DataInclusao   
    ,ValorFinanciamento                        
    ,PrazoVigencia   
             )  
          VALUES (     
                   X.Arquivo                                              
    ,X.DataArquivo               
    ,X.IDProposta             
    ,X.NumeroContratoVinculado          
    ,X.DataContrato   
    ,X.DataInclusao   
    ,X.ValorFinanciamento                        
    ,X.PrazoVigencia          
            )  
 WHEN MATCHED THEN UPDATE SET NumeroContratoVinculado = COALESCE(X.NumeroContratoVinculado,T.NumeroContratoVinculado);                
       
  
  
   
  /*************************************************************************************/  
  /*  Grava os dados na tabela PropostaFinanceiro           */  
  /*************************************************************************************/   
    ;MERGE INTO Dados.FinanceiroExtrato AS T  
  USING (         
          select * from (  SELECT *,ROW_NUMBER() OVER(PARTITION BY IDProposta  ORDER BY DataArquivo DESC)  [ORDER]  
            FROM  
            (  
    SELECT --top 10   
      COALESCE(pp.ID ,PP2.ID ) as [IDProposta]    
    , prd.ID IDProduto   
    ,PRP.NumeroPropostaInclusao  
    ,pp.NumeroProposta  
    , PRP.VALOR_SEGURO AS PremioMip  
    ,PRP.DTA_CONCESSAO_CONTR AS DataInclusao  
     
    , PRP.[DataArquivo]    
     , PRP.[NomeArquivo] [Arquivo]  
      
    FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP  
    INNER  JOIN Dados.Produto PRD  
    ON PRD.CodigoComercializado = PRP.COD_PRODUTO  
       
     LEFT JOIN dbo.PropostaPS ps on ps.NumeroPropostaTratado like PRP.[PropostaPS] and ps.CPFCNPJ = PRP.NUM_CPF_CGC  AND ps.ValorPremioBrutoEmissao = PRP.VALOR_SEGURO  
     left join Dados.Proposta pp on pp.ID = ps.ID   
     left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroPropostaInclusao  
     --where prp.DTA_CONCESSAO_CONTR >= '2016-05-06' or prp.ID = 407404    
       
            ) A  
  )b   
            WHERE [ORDER] = 1  and idproposta is not null  
              
          ) AS X  
    ON  X.[IDProposta] = T.[IDProposta]  
    --AND X.[DataArquivo] = T.[DataArquivo]  
 AND X.[IDProduto] = T.[IDProduto]  
   
    WHEN NOT MATCHED    
       THEN INSERT            
              (   [IDProposta]    
      , [IDProduto]  
                , [PremioMip]  
     
    , [DataArquivo]     
    , [Arquivo]    
    , [DataInclusao]  
   
               )  
          VALUES (     
               X.[IDProposta]  
       , X.[IDProduto]  
         , X.[PremioMip]  
       , X.[DataArquivo]         
       , X.[Arquivo]     
       , X.[DataInclusao]  
      
            );                
       
    
 /*************************************************************************************/  
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/  
  /*************************************************************************************/  
  SET @PontoDeParada = @MaiorCodigo  
    
  UPDATE ControleDados.PontoParada   
  SET PontoParada = @PontoDeParada  
  WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'  
  /*************************************************************************************/  
    
  
  /*********************************************************************************************************************/  
  TRUNCATE TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP]  
    
  /*********************************************************************************************************************/  
             
SET @COMANDO =  
    N'  INSERT INTO dbo.PRESTAMISTA_SIAPX_TEMP  
      (  
      [UF]  
      ,[CEP]  
      ,[DDD]  
      ,[MES_REFERENCIA_MOVIMENTO]  
      ,[MES_GERACAO_ARQUIVO]  
      ,[COD_PRODUTO]  
      ,[COD_TIPO_REPASSE]  
      ,[SUREG_CONCESSAO]  
      ,[AGENCIA_CONCESSAO]  
      ,[OPERACAO_APLICACAO]  
      ,[NUM_CONTRATO]  
      ,[NUM_DV_CONTRATO]  
      ,[COD_MODALIDADE_OPER]  
      ,[COD_CANAL]  
      ,[NOME_CANAL]  
      ,[NOME_CLIENTE]  
      ,[DTA_CONCESSAO_CONTR]  
      ,[DTA_TERMINO_CONTR]  
      ,[VALOR_CONTRATO]  
      ,[VALOR_SEGURO]  
      ,[TIPO_PESSOA]  
      ,[NUM_CPF_CGC]  
      ,[TAXA_APLICADA]  
      ,[COD_NAT_EMPRESA]  
      ,[EST_CONTRATO_ORIGEM]  
      ,[COD_NAT_PROFISSIONAL]  
      ,[PRZ_VENC_CONTRATO]  
      ,[DT_NASCIMENTO]  
      ,[IDADE]  
      ,[SEXO]  
      ,[ESTADO_CIVIL]  
      ,[ENDERECO]  
      ,[COMPL_ENDERECO]  
      ,[CIDADE]  
      ,[TELEFONE]  
      ,[EMAIL]  
      ,[COD_MATRICULA]  
      ,[TIPO_CORRESPONDENTE]  
      ,[COD_CORRESPONDENTE]  
      ,[DV_CORRESPONDENTE]  
      ,[Column 40]  
      ,[NomeArquivo]  
      ,[DataArquivo]  
      ,[ID]  
   ,[AgenciaInt]  
   )  
       SELECT   
     [UF]  
      ,[CEP]  
      ,[DDD]  
      ,[MES_REFERENCIA_MOVIMENTO]  
      ,[MES_GERACAO_ARQUIVO]  
      ,[COD_PRODUTO]  
      ,[COD_TIPO_REPASSE]  
      ,[SUREG_CONCESSAO]  
      ,[AGENCIA_CONCESSAO]  
      ,[OPERACAO_APLICACAO]  
      ,[NUM_CONTRATO]  
      ,[NUM_DV_CONTRATO]  
      ,[COD_MODALIDADE_OPER]  
      ,[COD_CANAL]  
      ,[NOME_CANAL]  
      ,[NOME_CLIENTE]  
      ,[DTA_CONCESSAO_CONTR]  
      ,[DTA_TERMINO_CONTR]  
      ,[VALOR_CONTRATO]  
      ,[VALOR_SEGURO]  
      ,[TIPO_PESSOA]  
      ,[NUM_CPF_CGC]  
      ,[TAXA_APLICADA]  
      ,[COD_NAT_EMPRESA]  
      ,[EST_CONTRATO_ORIGEM]  
      ,[COD_NAT_PROFISSIONAL]  
      ,[PRZ_VENC_CONTRATO]  
      ,[DT_NASCIMENTO]  
      ,[IDADE]  
      ,[SEXO]  
      ,[ESTADO_CIVIL]  
      ,[ENDERECO]  
      ,[COMPL_ENDERECO]  
      ,[CIDADE]  
      ,[TELEFONE]  
      ,[EMAIL]  
      ,[COD_MATRICULA]  
      ,[TIPO_CORRESPONDENTE]  
      ,[COD_CORRESPONDENTE]  
      ,[DV_CORRESPONDENTE]  
      ,[Column 40]  
      ,[NomeArquivo]  
      ,[DataArquivo]  
      ,[ID]  
   ,[AgenciaInt]  
       FROM OPENQUERY ([OBERON],   
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPrestamistaSIAPX] ''''' + @PontoDeParada + ''''''') PRP  
         '  
   --print @COMANDO  
          
 exec sp_executesql  @tsql  = @COMANDO  
  
   SELECT @MaiorCodigo= MAX(PRP.ID)  
   FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP      
                      
--update ControleDados.PontoParada  set PontoParada = @MaiorCodigo  
--WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'  
  
  /*********************************************************************************************************************/  
    
END  
  
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_SIAPX_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)  
 DROP TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP];  
  
END TRY                  
BEGIN CATCH  
   
  EXEC CleansingKit.dbo.proc_RethrowError   
 -- RETURN @@ERROR   
END CATCH       
--SELECT * FROM PRESTAMISTA_SIAPX_TEMP WHERE CONTRATO = '04000511034791190'  
--SELECT * FROM DADOS.PROPOSTA P INNER JOIN DADOS.PROPOSTACLIENTE PC ON PC.IDProposta = P.id WHERE PC.CPFCNPJ = '030.362.981-93'      
--  
--with prp as (  
--select * from dados.proposta P   
--where numeroproposta like 'ps%' and p.tipodado like '%CXRELAT%' and dataproposta >= '2016-01-01'  
--)select pf.NumeroContratoVinculado,cc.Contrato,* from prp p  
--INNER JOIn dados.propostafinanceiro pf on pf.IDPRoposta =  p.ID   
--inner join dados.propostacliente pc on pc.IDProposta = p.ID  
--left join Dados.ContratoConsignado cc on cc.contrato = pf.NumeroContratoVinculado  
------where pc.CPFCNPJ = '144.546.294-04'  
  
  
  
--select max(DataProposta) from Dados.Proposta where TipoDado like '%CXRELAT%'  
  