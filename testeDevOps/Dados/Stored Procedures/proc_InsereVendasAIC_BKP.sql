

/*
	Autor: André Anselmo
	Data Criação: 2016-05-12

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereVendasAIC_BKP
	Descrição: Procedimento que realiza a inserção dos registros de vendas do AIC no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereVendasAIC_BKP] as
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDASAIC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VENDASAIC_TEMP];

CREATE TABLE [dbo].[VENDASAIC_TEMP](
	PRODUTO	varchar(100)
	,DT_VENDA	date
	,Hora_VENDA	time
	,NumeroProposta	varchar(15)
	,COD_AGENCIA	varchar(10)
	,COD_MATRICULA	varchar(50)
	,VALOR_PREMIO	decimal(19,2)
	,VALOR_CONT_GRAVIDEZ	decimal(19,2)
	,APORTE_INICIAL	decimal(19,2)
	,CONTRIBUICAO_MENSAL	decimal(19,2)
	,CONTRIBUICAO_PPC	decimal(19,2)
	,CONTRIBUICAO_PECULIO	decimal(19,2)
	,TIPO_PAGAMENTO	varchar(5)
	,NOM_BU_PRODUTO	varchar(50)
	,NOME	varchar(100)
	,NOME_SR	varchar(100)
	,NOME_FILIAL	varchar(100)
	,SUAT	varchar(10)
	,SUP_REDE	varchar(100)
	,CONSULTOR	varchar(100)
	,ASVEN	varchar(5)
	,ID_MAT	varchar(100)
	,SO_DATA	date
	,MES	varchar(50)
	,COD_PRODUTO_AIC	varchar(100)
	,COD_CANAL_AIC	varchar(100)
	,CANAL	varchar(50)
	,COD_TP_CONTRIBUICAO	varchar(100)
	,IND_PERID_CONTRIBUICAO	varchar(100)
	,COD_TIPO_PESSOA	varchar(100)
	,DES_TIPO_PESSOA	varchar(10)
	,MatriculaIndicador	varchar(8)
	,NomeArquivo	varchar(200)
	,DataArquivo DATE
	,Codigo	int
)  

 /*Cria alguns índices para facilitar a busca*/  

CREATE NONCLUSTERED INDEX IDX_NCL_VENDASAIC_TEMP_TIPO_PAGAMENTO
ON [dbo].[VENDASAIC_TEMP] ([TIPO_PAGAMENTO]);


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'VENDASAIC'

--select @PontoDeParada = 10936557

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[VENDASAIC_TEMP] 
                       (	PRODUTO
							,DT_VENDA
							,Hora_VENDA
							,NumeroProposta
							,COD_AGENCIA
							,COD_MATRICULA
							,VALOR_PREMIO
							,VALOR_CONT_GRAVIDEZ
							,APORTE_INICIAL
							,CONTRIBUICAO_MENSAL
							,CONTRIBUICAO_PPC
							,CONTRIBUICAO_PECULIO
							,TIPO_PAGAMENTO
							,NOM_BU_PRODUTO
							,NOME
							,NOME_SR
							,NOME_FILIAL
							,SUAT
							,SUP_REDE
							,CONSULTOR
							,ASVEN
							,ID_MAT
							,SO_DATA
							,MES
							,COD_PRODUTO_AIC
							,COD_CANAL_AIC
							,CANAL
							,COD_TP_CONTRIBUICAO
							,IND_PERID_CONTRIBUICAO
							,COD_TIPO_PESSOA
							,DES_TIPO_PESSOA
							,MatriculaIndicador
							,NomeArquivo
							,DataArquivo
							,Codigo )
                SELECT  DISTINCT
							PRODUTO
							,DT_VENDA
							,Hora_VENDA
							,NumeroProposta
							,COD_AGENCIA
							,COD_MATRICULA
							,VALOR_PREMIO
							,VALOR_CONT_GRAVIDEZ
							,APORTE_INICIAL
							,CONTRIBUICAO_MENSAL
							,CONTRIBUICAO_PPC
							,CONTRIBUICAO_PECULIO
							,TIPO_PAGAMENTO
							,NOM_BU_PRODUTO
							,NOME
							,NOME_SR
							,NOME_FILIAL
							,SUAT
							,SUP_REDE
							,CONSULTOR
							,ASVEN
							,ID_MAT
							,SO_DATA
							,MES
							,COD_PRODUTO_AIC
							,COD_CANAL_AIC
							,CANAL
							,COD_TP_CONTRIBUICAO
							,IND_PERID_CONTRIBUICAO
							,COD_TIPO_PESSOA
							,DES_TIPO_PESSOA
							,MatriculaIndicador
							,NomeArquivo
							,DataArquivo
							,Codigo 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaVendas_AIC] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     
                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].VENDASAIC_TEMP PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--CodigoProduto	Descricao
---1	NÃO IDENTIFICADO

     /**********************************************************************
       Carrega os PRODUTOS SIGPF desconhecidos
     ***********************************************************************/             
      ;MERGE INTO Dados.ProdutoSIGPF AS T
	      USING (SELECT DISTINCT ISNULL(P.CodigoProdutoSIVPF,-1) [CodigoProduto], isnull(p.NomeProduto,'NÃO IDENTIFICADO') AS Descricao
               FROM dbo.[VENDASAIC_TEMP] VAC
			   OUTER APPLY (SELECT TOP 1 CodigoProdutoSIVPF, NomeProduto FROM Dados.ParametroProdutoAIC AS PP WHERE PP.CodigoProduto=VAC.Cod_produto_AIC) AS P 
              ) X
         ON T.CodigoProduto = X.CodigoProduto 
       WHEN NOT MATCHED
		          THEN INSERT (CodigoProduto, Descricao)
		               VALUES (X.[CodigoProduto], X.[Descricao]);
                                                      
     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT VAC.NumeroProposta, 
		  --'1' AS [IDSeguradora], 
			(CASE WHEN NOM_BU_PRODUTO = 'Previdência' THEN '4'
			WHEN NOM_BU_PRODUTO = 'Capitalização' THEN '3'
			WHEN NOM_BU_PRODUTO = 'Consórcio' THEN '5'
			ELSE '1' END) as [IDSeguradora],			
		  VAC.NomeArquivo, VAC.DataArquivo
            FROM [dbo].[VENDASAIC_TEMP] VAC
            WHERE VAC.NumeroProposta IS NOT NULL
              ) X
        ON T.NumeroProposta = X.NumeroProposta
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.[NomeArquivo], X.DataArquivo);		               

     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir tipo de pagamento AIC
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.TipoPagamentoAIC AS T
	      USING (SELECT DISTINCT TIPO_PAGAMENTO AS Descricao
					FROM [dbo].[VENDASAIC_TEMP] 
					WHERE TIPO_PAGAMENTO IS NOT NULL AND TIPO_PAGAMENTO <> ''
              ) X
        ON T.Descricao = X.Descricao
       WHEN NOT MATCHED
		          THEN INSERT (Descricao)
		               VALUES (X.Descricao);		               

	-----------------------------------------------------------------------------------------------------------------------
	--Comando para inserir EVENTUAIS Agências que não existirem na tabela de Unidades 
	-----------------------------------------------------------------------------------------------------------------------
	INSERT INTO Dados.Unidade(Codigo)
	SELECT DISTINCT CAST(Cod_Agencia AS INT) AS CodigoUnidade 
	FROM [dbo].[VENDASAIC_TEMP] AS VAC 
	WHERE 
		not exists (
	SELECT     *
	FROM         Dados.Unidade U
	WHERE U.Codigo = CAST(VAC.Cod_Agencia AS INT))
	
  
	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], MAX(Cod_Agencia ) [CodigoNaFonte], 'VENDASAIC' [TipoDado], MAX(EM.DataArquivo) [DataArquivo], MAX(NomeArquivo) [Arquivo]
	FROM [dbo].[VENDASAIC_TEMP] EM
	INNER JOIN Dados.Unidade U
	ON EM.Cod_Agencia = U.Codigo
	WHERE 
		not exists (
					SELECT     *
					FROM         Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)
	GROUP BY U.ID 
   
     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir tipo de contribuição AIC
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.TipoContribuicao AS T
	      USING (SELECT DISTINCT COD_TP_Contribuicao AS Codigo
					FROM [dbo].[VENDASAIC_TEMP] 
					WHERE COD_TP_Contribuicao IS NOT NULL AND COD_TP_Contribuicao <> ''
              ) X
        ON T.Codigo = X.Codigo
       WHEN NOT MATCHED
		          THEN INSERT (Codigo)
		               VALUES (X.Codigo);		               

     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir período de contribuição AIC
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.PeriodoContribuicao AS T
	      USING (SELECT DISTINCT IND_PERID_Contribuicao AS Descricao
					FROM [dbo].[VENDASAIC_TEMP] 
					WHERE IND_PERID_Contribuicao IS NOT NULL AND IND_PERID_Contribuicao <> ''
              ) X
        ON T.Descricao = X.Descricao
       WHEN NOT MATCHED
		          THEN INSERT (Descricao)
		               VALUES (X.Descricao);		               
     
/*	 -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir canal de venda
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.CanalVenda AS T
	      USING (SELECT DISTINCT Canal AS Nome--, IDCanal--, C.IDCanal
					FROM [dbo].[VENDASAIC_TEMP] 
					--OUTER APPLY (SELECT ROW_NUMBER() OVER (ORDER BY MAX(ID) DESC) AS IDCanal
					FROM Dados.CanalVenda) AS C
					WHERE Canal IS NOT NULL AND Canal <> ''
              ) X
        ON T.Nome = X.Nome
       WHEN NOT MATCHED
		          THEN INSERT (Nome, ID)
		               VALUES (X.Nome, X.IDCanal);		               
*/
	
	-----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as vendas recebidas no arquivo VENDAS AIC
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.PropostaAIC AS T
		USING (
		       SELECT *
		       FROM
		       (
					SELECT 
						PROD.IDProdutoSIGPF
						,U.ID AS IDUnidade
						,PROP.ID AS IDProposta
						,PG.ID AS IDTipoPagamento
						,ID_Mat AS IDMatricula
						,C.ID AS IDCanalVenda
						,TC.ID AS IDTipoContribuicao
						,PCC.ID AS IDPeriodoContribuicao
						,DT_Venda AS DataVenda
						,Hora_Venda AS HoraVenda
						,Cod_matricula AS Matricula
						,Valor_Premio AS ValorPremio
						,Aporte_Inicial AS ValorAporteInicial
						,Contribuicao_Mensal AS ValorContribuicaoMensal
						,Contribuicao_PPC AS ValorContribuicaoPPC
						,Contribuicao_Peculio AS ValorContribuicaoPeculio
						,Sup_Rede AS SupRede
						,Consultor AS NomeConsultor
						,Asven
						,SO_Data AS SOData
						,Mes
						,COD_Produto_AIC AS GuidCodigoProdutoAIC
						,COD_Canal_AIC AS GuidCodigoCanalAIC
						,MatriculaIndicador
						,VAC.NomeArquivo
						,VAC.DataArquivo
						,VAC.DES_TIPO_PESSOA
						,ROW_NUMBER() OVER (PARTITION BY VAC.NumeroProposta ORDER BY VAC.NumeroProposta DESC) Linha
					FROM dbo.[VENDASAIC_TEMP] VAC
					INNER JOIN Dados.Unidade AS U
					ON U.Codigo=VAC.Cod_Agencia
					INNER JOIN Dados.Proposta AS PROP
					ON PROP.NumeroProposta=VAC.NumeroProposta
					LEFT OUTER JOIN Dados.TipoPagamentoAIC AS PG
					ON PG.Descricao=VAC.Tipo_Pagamento
					LEFT OUTER JOIN Dados.CanalVenda AS C
					ON C.Nome=VAC.Canal
					LEFT OUTER JOIN Dados.TipoContribuicao AS TC
					ON TC.Codigo=VAC.Cod_TP_Contribuicao
					LEFT OUTER JOIN Dados.PeriodoContribuicao AS PCC
					ON PCC.Descricao=VAC.IND_PERID_Contribuicao
					OUTER APPLY (SELECT TOP 1 PF.ID AS IDProdutoSIGPF 
									FROM  Dados.ParametroProdutoAIC AS PP 
									INNER JOIN Dados.ProdutoSIGPF AS PF
									ON PP.CodigoProdutoSIVPF=PF.CodigoProduto 
									WHERE PP.CodigoProduto=VAC.Cod_produto_AIC
									) AS PROD

           ) A
           WHERE A.Linha = 1
			) AS O
		ON  T.IDProposta = O.IDProposta

		WHEN NOT MATCHED
			THEN INSERT (
						IDProdutoSIGPF
						,IDUnidade
						,IDProposta
						,IDTipoPagamento
						,IDMatricula
						,IDCanalVenda
						,IDTipoContribuicao
						,IDPeriodoContribuicao
						,DataVenda
						,HoraVenda
						,Matricula
						,ValorPremio
						,ValorAporteInicial
						,ValorContribuicaoMensal
						,ValorContribuicaoPPC
						,ValorContribuicaoPeculio
						,SupRede
						,NomeConsultor
						,Asven
						,SOData
						,Mes
						,GuidCodigoProdutoAIC
						,GuidCodigoCanalAIC
						,MatriculaIndicador
						,DescricaoTipoPessoa
						,NomeArquivo
						,DataArquivo
						)
				VALUES (
						 O.IDProdutoSIGPF
						,O.IDUnidade
						,O.IDProposta
						,O.IDTipoPagamento
						,O.IDMatricula
						,O.IDCanalVenda
						,O.IDTipoContribuicao
						,O.IDPeriodoContribuicao
						,O.DataVenda
						,O.HoraVenda
						,O.Matricula
						,O.ValorPremio
						,O.ValorAporteInicial
						,O.ValorContribuicaoMensal
						,O.ValorContribuicaoPPC
						,O.ValorContribuicaoPeculio
						,O.SupRede
						,O.NomeConsultor
						,O.Asven
						,O.SOData
						,O.Mes
						,O.GuidCodigoProdutoAIC
						,O.GuidCodigoCanalAIC
						,O.MatriculaIndicador
						,O.DES_TIPO_PESSOA
						,O.NomeArquivo
						,O.DataArquivo				
				);
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'VENDASAIC'


  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[VENDASAIC_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[VENDASAIC_TEMP] 
                       (	PRODUTO
							,DT_VENDA
							,Hora_VENDA
							,NumeroProposta
							,COD_AGENCIA
							,COD_MATRICULA
							,VALOR_PREMIO
							,VALOR_CONT_GRAVIDEZ
							,APORTE_INICIAL
							,CONTRIBUICAO_MENSAL
							,CONTRIBUICAO_PPC
							,CONTRIBUICAO_PECULIO
							,TIPO_PAGAMENTO
							,NOM_BU_PRODUTO
							,NOME
							,NOME_SR
							,NOME_FILIAL
							,SUAT
							,SUP_REDE
							,CONSULTOR
							,ASVEN
							,ID_MAT
							,SO_DATA
							,MES
							,COD_PRODUTO_AIC
							,COD_CANAL_AIC
							,CANAL
							,COD_TP_CONTRIBUICAO
							,IND_PERID_CONTRIBUICAO
							,COD_TIPO_PESSOA
							,DES_TIPO_PESSOA
							,MatriculaIndicador
							,NomeArquivo
							,DataArquivo
							,Codigo )
                SELECT  DISTINCT
							PRODUTO
							,DT_VENDA
							,Hora_VENDA
							,NumeroProposta
							,COD_AGENCIA
							,COD_MATRICULA
							,VALOR_PREMIO
							,VALOR_CONT_GRAVIDEZ
							,APORTE_INICIAL
							,CONTRIBUICAO_MENSAL
							,CONTRIBUICAO_PPC
							,CONTRIBUICAO_PECULIO
							,TIPO_PAGAMENTO
							,NOM_BU_PRODUTO
							,NOME
							,NOME_SR
							,NOME_FILIAL
							,SUAT
							,SUP_REDE
							,CONSULTOR
							,ASVEN
							,ID_MAT
							,SO_DATA
							,MES
							,COD_PRODUTO_AIC
							,COD_CANAL_AIC
							,CANAL
							,COD_TP_CONTRIBUICAO
							,IND_PERID_CONTRIBUICAO
							,COD_TIPO_PESSOA
							,DES_TIPO_PESSOA
							,MatriculaIndicador
							,NomeArquivo
							,DataArquivo
							,Codigo 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaVendas_AIC] ''''' + @PontoDeParada + ''''''') PRP'


  EXEC (@COMANDO)         

  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[VENDASAIC_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDASAIC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VENDASAIC_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

