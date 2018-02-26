CREATE PROCEDURE [Dados].[proc_InsereConsorcio_Contrato_Tipo3] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Contrato_Tipo3_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Contrato_Tipo3_Temp];

CREATE TABLE [dbo].[Cliente_Contrato_Tipo3_Temp](
	NUMERO_GRUPO	int	
	,NUMERO_COTA	int	
	,NUMERO_VERSAO	int	
	,BRANCOS	varchar(20)
	,DATA_ALOCACAO	date
	,NUMERO_DO_PRODUTO	int	
	,AGENCIA_VENDA	int	
	,DIA_VENCIMENTO	tinyint	
	,TIPO_PAGAMENTO	tinyint	
	,AGENCIA	int	
	,OPERACAO	int	
	,CONTA	bigint	
	,DIGITO	tinyint	
	,MATRICULA_VENDEDOR	VARCHAR(20)
	,ORIGEM_VENDA	int	
	,DATA_PAGAMENTO_PRIMEIRA_PARCELA	date	
	,DATA_INICIO_VIGENCIA_COTA	date	
	,DATA_FINAL_VIGENCIA_COTA	date	
	,PRAZO_GRUPO_MESES	smallint	
	,PRAZO_COTA_MESES	smallint	
	,VALOR_DATA_VENDA	decimal(19,2)	
	,VALOR_CREDITO_ATUALIZADO	decimal(19,2)
	,DATA_CONTEMPLACAO	date	
	,DATA_CONFIRMACAO	date	
	,ORIGEM	smallint	
	,BRANCOS_B	varchar(200)
	,Codigo	int	
	,TipoRegistro	char(2)
	,NomeArquivo	varchar(200)
	,Chave	varchar(90)
	,DataArquivo	date	
	,NumeroProposta	varchar(24)
);


/* SELECIONA O ÚLTIMO PONTO DE PARADA */
--SELECT *
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Consorcio_Contrato_Tipo3'


--select * from ControleDados.PontoParada



/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--    DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Contrato_Tipo3_Temp]
           (NUMERO_GRUPO,NUMERO_COTA,NUMERO_VERSAO,BRANCOS,DATA_ALOCACAO,NUMERO_DO_PRODUTO,AGENCIA_VENDA,DIA_VENCIMENTO,TIPO_PAGAMENTO,AGENCIA
			,OPERACAO,CONTA,DIGITO,MATRICULA_VENDEDOR,ORIGEM_VENDA,DATA_PAGAMENTO_PRIMEIRA_PARCELA,DATA_INICIO_VIGENCIA_COTA,DATA_FINAL_VIGENCIA_COTA
			,PRAZO_GRUPO_MESES,PRAZO_COTA_MESES,VALOR_DATA_VENDA,VALOR_CREDITO_ATUALIZADO,DATA_CONTEMPLACAO,DATA_CONFIRMACAO,ORIGEM,BRANCOS_B
			,Codigo,NomeArquivo,Chave,DataArquivo,NumeroProposta )
		   SELECT  NUMERO_GRUPO,NUMERO_COTA,NUMERO_VERSAO,BRANCOS,DATA_ALOCACAO,NUMERO_DO_PRODUTO,AGENCIA_VENDA,DIA_VENCIMENTO,TIPO_PAGAMENTO,AGENCIA
			,OPERACAO,CONTA,DIGITO,MATRICULA_VENDEDOR,ORIGEM_VENDA,DATA_PAGAMENTO_PRIMEIRA_PARCELA,DATA_INICIO_VIGENCIA_COTA,DATA_FINAL_VIGENCIA_COTA
			,PRAZO_GRUPO_MESES,PRAZO_COTA_MESES,VALOR_DATA_VENDA,VALOR_CREDITO_ATUALIZADO,DATA_CONTEMPLACAO,DATA_CONFIRMACAO,ORIGEM,BRANCOS_B
			,Codigo,NomeArquivo,Chave,DataArquivo,NumeroProposta
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Contrato_Tipo3] ''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Cliente_Contrato_Tipo3_Temp PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**********************************************************************
       Carrega os PRODUTOS desconhecidos
***********************************************************************/
;MERGE INTO Dados.Produto AS T
	USING (
			SELECT DISTINCT CAST(PRP.Numero_do_Produto AS VARCHAR(5)) [CodigoComercializado], 'Consórcio' [Descricao], 5 as IDSeguradora
            FROM dbo.[Cliente_Contrato_Tipo3_Temp] PRP
			WHERE PRP.Numero_do_Produto IS NOT NULL
          ) X
         ON T.[CodigoComercializado] = X.[CodigoComercializado] 
		 AND T.IDSeguradora=X.IDSeguradora
       WHEN NOT MATCHED 
		          THEN INSERT ([CodigoComercializado], Descricao, IDSeguradora)
		               VALUES (X.[CodigoComercializado], X.[Descricao], x.IDSeguradora); 

/***********************************************************************
       Carregar as agencias desconhecidas
***********************************************************************/
/*INSERE PVs NÃO LOCALIZADOS*/
;INSERT INTO Dados.Unidade(Codigo)

SELECT DISTINCT CAD.Agencia_Venda
FROM dbo.[Cliente_Contrato_Tipo3_Temp] CAD
WHERE  CAD.Agencia_Venda IS NOT NULL 
  AND not exists (
                  SELECT     *
                  FROM  Dados.Unidade U
                  WHERE U.Codigo = CAD.Agencia_Venda)                  
                                                        
INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
SELECT DISTINCT U.ID, 
				'UNIDADE NÃO INFORMADA - DADOS INCOMPLETOS' [Unidade], 
				-1 [CodigoNaFonte], 
				'CONSORCIO' [TipoDado], 
				MAX(EM.DataArquivo) [DataArquivo], 
				'CONSORCIO' [Arquivo]

FROM dbo.[Cliente_Contrato_Tipo3_Temp] EM
INNER JOIN Dados.Unidade U
ON EM.Agencia_Venda = U.Codigo
WHERE 
    not exists (
                SELECT     *
                FROM Dados.UnidadeHistorico UH
                WHERE UH.IDUnidade = U.ID)    
GROUP BY U.ID

/**********************************************************************
       Carrega as Origens de venda não cadastradas
***********************************************************************/
;MERGE INTO Dados.OrigemVendaConsorcio AS T
	USING (
			SELECT DISTINCT Origem_Venda AS Codigo, 'Desconhecido' AS Descricao
            FROM dbo.[Cliente_Contrato_Tipo3_Temp] PRP
			WHERE PRP.Origem_Venda IS NOT NULL
          ) X
         ON T.Codigo = X.Codigo
       WHEN NOT MATCHED 
		          THEN INSERT (Codigo, Descricao)
		               VALUES (X.Codigo, X.[Descricao]); 

/**********************************************************************
       Carrega os contratos não cadastradas
	   select * from [dbo].[Cliente_Contrato_Tipo3_Temp] where numeroproposta='000003920000001900000000'
SELECT COUNT(*), NumeroContrato FROM #temp group by NumeroContrato having COUNT(*) >1
SELECT * FROM #temp where numerocontrato='000003920000001900000000'

***********************************************************************/
;MERGE INTO Dados.Contrato AS T
		USING (
				SELECT *
				FROM
					(
						SELECT DISTINCT
					    Data_Alocacao AS DataEmissao
						,Data_Inicio_Vigencia_Cota AS DataInicioVigencia
						,Data_Final_Vigencia_Cota AS DataFimVigencia
						,Valor_Data_Venda AS ValorPremioTotal
						,U.ID AS IDAgencia
						,F.ID AS IDIndicador
						,MAX(PRP_TMP.DataArquivo) AS DataArquivo
						,PRP_TMP.NomeArquivo AS Arquivo
						,5 AS IDSeguradora
						--,P.ID AS IDProduto
						,NumeroProposta AS NumeroContrato
						,ROW_NUMBER() OVER (PARTITION BY PRP_TMP.NumeroProposta, PRP_TMP.DataArquivo
						ORDER BY PRP_TMP.NumeroProposta, PRP_TMP.DataArquivo, PRP_TMP.Data_Alocacao DESC) [LastValue]  
						FROM [dbo].[Cliente_Contrato_Tipo3_Temp] PRP_TMP
					    INNER JOIN Dados.Unidade U
						ON U.Codigo = PRP_TMP.Agencia_Venda
					    INNER JOIN Dados.Funcionario AS F
						ON F.Matricula = PRP_TMP.Matricula_Vendedor
						AND F.IDEmpresa=1
						INNER JOIN Dados.Produto AS P
						ON P.CodigoComercializado=PRP_TMP.Numero_do_produto
						AND P.IDSeguradora=5
						--WHERE PRP_TMP.NumeroProposta='000010130000012900000000'
						GROUP BY Data_Alocacao, Data_Inicio_Vigencia_Cota, Data_Final_Vigencia_Cota, Valor_Data_Venda, U.ID, F.ID, PRP_TMP.NomeArquivo, NumeroProposta, PRP_TMP.DataArquivo
					) A
				WHERE A.LastValue = 1
				)X
		ON X.NumeroContrato = T.NumeroContrato
			AND X.IDSeguradora = T.IDSeguradora

			WHEN MATCHED AND X.DataArquivo >= T.DataArquivo
			    THEN UPDATE
							SET
							  DataEmissao = COALESCE(X.DataEmissao, T.DataEmissao)
							  ,DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)
							  ,DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
							  ,ValorPremioTotal = COALESCE(X.ValorPremioTotal, T.ValorPremioTotal)
							  ,IDIndicador = COALESCE(X.IDIndicador, T.IDIndicador)
							  ,DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)
							  ,IDAgencia = COALESCE(X.IDAgencia, T.IDAgencia)
							  ,Arquivo = COALESCE(X.Arquivo, T.Arquivo)
			WHEN NOT MATCHED
			    THEN INSERT (
							  DataEmissao
							  ,DataInicioVigencia
							  ,DataFimVigencia
							  ,ValorPremioTotal
							  ,IDIndicador
							  ,DataArquivo
							  ,IDAgencia
							  ,NumeroContrato
							  ,IDSeguradora 
							  ,Arquivo )
				VALUES(		X.DataEmissao
							  ,X.DataInicioVigencia
							  ,X.DataFimVigencia
							  ,X.ValorPremioTotal
							  ,X.IDIndicador
							  ,X.DataArquivo
							  ,X.IDAgencia
							  ,X.NumeroContrato
							  ,X.IDSeguradora
							  ,X.Arquivo  );
		  					  							

/**********************************************************************
       Criar e carregar a tabela contratoconsorcio!!!!
***********************************************************************/
;MERGE INTO Dados.ContratoConsorcio AS T
		USING (
				SELECT *
				FROM
					(
						SELECT DISTINCT
						C.ID AS IDContrato
						,NUMERO_GRUPO
						,NUMERO_COTA
						,NUMERO_VERSAO
						,BRANCOS
						,DIA_VENCIMENTO
						,TP.ID AS IDTipoPagamentoConsorcio
						,U.ID AS IDAgencia 
						,OPERACAO
						,CONTA
						,DIGITO
						,F.ID AS IDVendedor
						,OV.ID AS IDOrigemVendaConsorcio
						,DATA_PAGAMENTO_PRIMEIRA_PARCELA
						,PRAZO_GRUPO_MESES
						,PRAZO_COTA_MESES
						,VALOR_DATA_VENDA
						,VALOR_CREDITO_ATUALIZADO
						,DATA_CONTEMPLACAO
						,DATA_CONFIRMACAO
						,ORIGEM
						,BRANCOS_B
						,MAX(PRP.DataArquivo) AS DataArquivo
						,ROW_NUMBER() OVER (PARTITION BY C.ID, PRP.NUMERO_GRUPO, PRP.NUMERO_COTA
						ORDER BY C.ID, PRP.NUMERO_GRUPO, PRP.NUMERO_COTA, PRP.DATA_ALOCACAO DESC) [LastValue]
						FROM [dbo].[Cliente_Contrato_Tipo3_Temp] PRP
					    INNER JOIN Dados.Contrato AS C
						ON C.NumeroContrato=PRP.NumeroProposta
						INNER JOIN Dados.TipoPagamentoConsorcio AS TP
						ON TP.Codigo=PRP.TIPO_PAGAMENTO
						INNER JOIN Dados.OrigemVendaConsorcio AS OV
						ON OV.Codigo=PRP.ORIGEM_VENDA
					    LEFT OUTER JOIN Dados.Funcionario AS F
						ON F.Matricula = PRP.Matricula_Vendedor
						AND F.IDEmpresa=1
						LEFT OUTER JOIN Dados.Unidade AS U
						ON U.Codigo=PRP.AGENCIA
						GROUP BY 
						C.ID
						,NUMERO_GRUPO
						,NUMERO_COTA
						,NUMERO_VERSAO
						,BRANCOS
						,DIA_VENCIMENTO
						,TP.ID
						,U.ID
						,OPERACAO
						,CONTA
						,DIGITO
						,F.ID
						,OV.ID
						,DATA_PAGAMENTO_PRIMEIRA_PARCELA
						,PRAZO_GRUPO_MESES
						,PRAZO_COTA_MESES
						,VALOR_DATA_VENDA
						,VALOR_CREDITO_ATUALIZADO
						,DATA_CONTEMPLACAO
						,DATA_CONFIRMACAO
						,ORIGEM
						,BRANCOS_B
						,PRP.DATA_ALOCACAO
					)A
				WHERE A.LastValue = 1 --AND A.IDContrato = 22175329
			)X
		ON X.IDContrato = T.IDContrato
			WHEN MATCHED
			    THEN UPDATE
							SET
							  NUMERO_GRUPO = COALESCE(X.NUMERO_GRUPO, T.NUMERO_GRUPO)
							  ,NUMERO_COTA = COALESCE(X.NUMERO_COTA, T.NUMERO_COTA)
							  ,NUMERO_VERSAO = COALESCE(X.NUMERO_VERSAO, T.NUMERO_VERSAO)
							  ,BRANCOS = COALESCE(X.BRANCOS, T.BRANCOS)
							  ,DIA_VENCIMENTO = COALESCE(X.DIA_VENCIMENTO, T.DIA_VENCIMENTO)
							  ,IDTipoPagamentoConsorcio = COALESCE(X.IDTipoPagamentoConsorcio, T.IDTipoPagamentoConsorcio)
							  ,IDAgencia = COALESCE(X.IDAgencia, T.IDAgencia)
							  ,OPERACAO = COALESCE(X.OPERACAO, T.OPERACAO)
							  ,CONTA = COALESCE(X.CONTA, T.CONTA)
							  ,DIGITO = COALESCE(X.DIGITO, T.DIGITO)
							  ,IDVendedor = COALESCE(X.IDVendedor, T.IDVendedor)
							  ,IDOrigemVendaConsorcio = COALESCE(X.IDOrigemVendaConsorcio, T.IDOrigemVendaConsorcio)
							  ,DATA_PAGAMENTO_PRIMEIRA_PARCELA = COALESCE(X.DATA_PAGAMENTO_PRIMEIRA_PARCELA, T.DATA_PAGAMENTO_PRIMEIRA_PARCELA)
							  ,PRAZO_GRUPO_MESES = COALESCE(X.PRAZO_GRUPO_MESES, T.PRAZO_GRUPO_MESES)
							  ,VALOR_DATA_VENDA = COALESCE(X.NUMERO_GRUPO, T.NUMERO_GRUPO)
							  ,VALOR_CREDITO_ATUALIZADO = COALESCE(X.VALOR_CREDITO_ATUALIZADO, T.VALOR_CREDITO_ATUALIZADO)
							  ,DATA_CONTEMPLACAO = COALESCE(X.DATA_CONTEMPLACAO, T.DATA_CONTEMPLACAO)
							  ,DATA_CONFIRMACAO = COALESCE(X.DATA_CONFIRMACAO, T.DATA_CONFIRMACAO)
							  ,ORIGEM = COALESCE(X.ORIGEM, T.ORIGEM)
							  ,BRANCOS_B = COALESCE(X.BRANCOS_B, T.BRANCOS_B)
			WHEN NOT MATCHED
			    THEN INSERT (
							   IDContrato
							  ,NUMERO_GRUPO
							  ,NUMERO_COTA
							  ,NUMERO_VERSAO
							  ,BRANCOS
							  ,DIA_VENCIMENTO 
							  ,IDTipoPagamentoConsorcio
							  ,IDAgencia
							  ,OPERACAO
							  ,CONTA
							  ,DIGITO
							  ,IDVendedor
							  ,IDOrigemVendaConsorcio
							  ,DATA_PAGAMENTO_PRIMEIRA_PARCELA
							  ,PRAZO_GRUPO_MESES
							  ,VALOR_DATA_VENDA
							  ,VALOR_CREDITO_ATUALIZADO
							  ,DATA_CONTEMPLACAO
							  ,DATA_CONFIRMACAO
							  ,ORIGEM
							  ,BRANCOS_B )
				VALUES(		X.IDContrato
							  ,X.NUMERO_GRUPO
							  ,X.NUMERO_COTA
							  ,X.NUMERO_VERSAO
							  ,X.BRANCOS
							  ,X.DIA_VENCIMENTO 
							  ,X.IDTipoPagamentoConsorcio
							  ,X.IDAgencia
							  ,X.OPERACAO
							  ,X.CONTA
							  ,X.DIGITO
							  ,X.IDVendedor
							  ,X.IDOrigemVendaConsorcio
							  ,X.DATA_PAGAMENTO_PRIMEIRA_PARCELA
							  ,X.PRAZO_GRUPO_MESES
							  ,X.VALOR_DATA_VENDA
							  ,X.VALOR_CREDITO_ATUALIZADO
							  ,X.DATA_CONTEMPLACAO
							  ,X.DATA_CONFIRMACAO
							  ,X.ORIGEM
							  ,X.BRANCOS_B  );

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Consorcio_Contrato_Tipo3'

 /****************************************************************************************/
  

  TRUNCATE TABLE [dbo].[Cliente_Contrato_Tipo3_Temp]
  
  /**************************************************************************************/

    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Contrato_Tipo3_Temp]
           (NUMERO_GRUPO,NUMERO_COTA,NUMERO_VERSAO,BRANCOS,DATA_ALOCACAO,NUMERO_DO_PRODUTO,AGENCIA_VENDA,DIA_VENCIMENTO,TIPO_PAGAMENTO,AGENCIA
			,OPERACAO,CONTA,DIGITO,MATRICULA_VENDEDOR,ORIGEM_VENDA,DATA_PAGAMENTO_PRIMEIRA_PARCELA,DATA_INICIO_VIGENCIA_COTA,DATA_FINAL_VIGENCIA_COTA
			,PRAZO_GRUPO_MESES,PRAZO_COTA_MESES,VALOR_DATA_VENDA,VALOR_CREDITO_ATUALIZADO,DATA_CONTEMPLACAO,DATA_CONFIRMACAO,ORIGEM,BRANCOS_B
			,Codigo,NomeArquivo,Chave,DataArquivo,NumeroProposta )
		   SELECT  NUMERO_GRUPO,NUMERO_COTA,NUMERO_VERSAO,BRANCOS,DATA_ALOCACAO,NUMERO_DO_PRODUTO,AGENCIA_VENDA,DIA_VENCIMENTO,TIPO_PAGAMENTO,AGENCIA
			,OPERACAO,CONTA,DIGITO,MATRICULA_VENDEDOR,ORIGEM_VENDA,DATA_PAGAMENTO_PRIMEIRA_PARCELA,DATA_INICIO_VIGENCIA_COTA,DATA_FINAL_VIGENCIA_COTA
			,PRAZO_GRUPO_MESES,PRAZO_COTA_MESES,VALOR_DATA_VENDA,VALOR_CREDITO_ATUALIZADO,DATA_CONTEMPLACAO,DATA_CONFIRMACAO,ORIGEM,BRANCOS_B
			,Codigo,NomeArquivo,Chave,DataArquivo,NumeroProposta
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Contrato_Tipo3] ''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.[Cliente_Contrato_Tipo3_Temp] PRP 

  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Contrato_Tipo3_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Contrato_Tipo3_Temp];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     