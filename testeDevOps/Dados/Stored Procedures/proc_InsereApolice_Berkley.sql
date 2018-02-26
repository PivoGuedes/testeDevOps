
/*
	Autor: Pedro Guedes
	Data Criação: 15/09/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereApolice_Berkley
	Descrição: Procedimento que realiza a inserção de contratos ou apolices no banco de dados.
		
	Parâmetros de entrada:
	rollback
					
	Retorno: 


*******************************************************************************/
-- Número da Apolice é igual ao Número do Contrato
CREATE PROCEDURE [Dados].[proc_InsereApolice_Berkley]
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_BERKLEY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[APOLICE_BERKLEY_TEMP];

CREATE TABLE [dbo].[APOLICE_BERKLEY_TEMP](

[ID] int NOT null,
[Ramo] [VARCHAR](2) NULL,
[NumeroProposta] [VARCHAR](15) NULL,
[Apolice] [VARCHAR](15) NULL,
[DataEmissao] [DATE] NULL,
[InicioVigencia] [DATE] NULL,
[FimVigencia] [Date] NULL,
[QuantidadeParcelas] [VARCHAR](3) NULL,
[DataVencimentoPrimeiraParcela] [Date] NULL,
[ComissaoAntecipada] [VARCHAR](1) NULL,
[ComissaoInicideSobreAdicional] [VARCHAR](1) NULL,
[PremioLiquido] [decimal] (18,6)NULL,
[Adicional] [decimal] (18,6) NULL,
[CustoDeApolice] [decimal] (18,6) NULL,
[ValorIOF] [decimal] (18,6) NULL,
[PremioTotal] [decimal] (18,6) NULL,
[PercentualDeComissao] [decimal] (18,6) NULL,
[ValorComissao] [VARCHAR](14) NULL,
[ApoliceRenovada] [VARCHAR](15) NULL,
[NumeroPropostaCorretor] [VARCHAR](7) NULL,
[NomeUsuario] [VARCHAR](50) NULL,
[MatriculaProdutorPAR] [VARCHAR](10) NULL,
[NomeCliente] [VARCHAR](50) NULL,
[Endereco] [VARCHAR](50) NULL,
[Bairro] [VARCHAR](30) NULL,
[Cidade] [VARCHAR](30) NULL,
[UF] [VARCHAR](2) NULL,
[CEP] [VARCHAR](8) NULL,
[TipoPessoa] [VARCHAR](1) NULL,
[CPFCNPJ] [VARCHAR](18) NULL,
[DDD] [VARCHAR](4) NULL,
[Telefone] [VARCHAR](12) NULL,
[NomeArquivo] [varchar] (50) not null,
[DataArquivo] [date]  not null,
[CodigoComercializado] [varchar] (2) NULL,
[Descricao] [varchar] (100) NULL
);

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX IDX_APOLICE_Berkley_TEMP_ID ON [dbo].[APOLICE_BERKLEY_TEMP]
( 
  ID ASC
)   

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX IDX_APOLICE_Berkley_TEMP_Proposta ON [dbo].[APOLICE_BERKLEY_TEMP]
( 
  NumeroProposta ASC
)   

CREATE NONCLUSTERED INDEX IDX_APOLICE_Berkley_TEMP_Apolice ON [dbo].[APOLICE_BERKLEY_TEMP]
( 
  Apolice ASC
)   


SELECT @PontoDeParada = PontoParada
FROM  ControleDados.PontoParada
WHERE NomeEntidade = 'Contrato_Berkley'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/ 
/*********************************************************************************************************************/
 --DECLARE @COMANDO AS NVARCHAR(MAX) 
 --DECLARE @PontoDeParada AS VARCHAR(400) set @PontoDeParada = 0               
 SET @COMANDO =
		'  INSERT INTO dbo.[APOLICE_BERKLEY_TEMP]
				(    [ID]
					  ,[Ramo]
					  ,[NumeroProposta]
					  ,[Apolice]
					  ,[DataEmissao]
					  ,[InicioVigencia]
					  ,[FimVigencia]
					  ,[QuantidadeParcelas]
					  ,[DataVencimentoPrimeiraParcela]
					  ,[ComissaoAntecipada]
					  ,[ComissaoInicideSobreAdicional]
					  ,[PremioLiquido]
					  ,[Adicional]
					  ,[CustoDeApolice]
					  ,[ValorIOF]
					  ,[PremioTotal]
					  ,[PercentualDeComissao]
					  ,[ValorComissao]
					  ,[ApoliceRenovada]
					  ,[NumeroPropostaCorretor]
					  ,[NomeUsuario]
					  ,[MatriculaProdutorPAR]
					  ,[NomeCliente]
					  ,[Endereco]
					  ,[Bairro]
					  ,[Cidade]
					  ,[UF]
					  ,[CEP]
					  ,[TipoPessoa]
					  ,[CPFCNPJ]
					  ,[DDD]
					  ,[Telefone]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[CodigoComercializado]
					  ,[Descricao]
				 
				  )
			SELECT 
				[ID]
					  ,[Ramo]
					  ,[NumeroProposta]
					  ,[Apolice]
					  ,[DataEmissao]
					  ,[InicioVigencia]
					  ,[FimVigencia]
					  ,[QuantidadeParcelas]
					  ,[DataVencimentoPrimeiraParcela]
					  ,[ComissaoAntecipada]
					  ,[ComissaoInicideSobreAdicional]
					  ,[PremioLiquido]
					  ,[Adicional]
					  ,[CustoDeApolice]
					  ,[ValorIOF]
					  ,[PremioTotal]
					  ,[PercentualDeComissao]
					  ,[ValorComissao]
					  ,[ApoliceRenovada]
					  ,[NumeroPropostaCorretor]
					  ,[NomeUsuario]
					  ,[MatriculaProdutorPAR]
					  ,[NomeCliente]
					  ,[Endereco]
					  ,[Bairro]
					  ,[Cidade]
					  ,[UF]
					  ,[CEP]
					  ,[TipoPessoa]
					  ,[CPFCNPJ]
					  ,[DDD]
					  ,[Telefone]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[CodigoComercializado]
					  ,[Descricao]
					
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceBerkley] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

SELECT @MaiorCodigo= MAX(PRP.ID)
FROM dbo.[APOLICE_BERKLEY_TEMP] PRP  

/**************************************************************************************************
		INSERE OS PRODUTOS begin tran select @@trancount
**************************************************************************************************/
SET @COMANDO = '' 

;WHILE @MaiorCodigo IS NOT NULL
BEGIN

;MERGE INTO [Dados].[Produto] T
	USING ( SELECT DISTINCT CodigoComercializado,Descricao,1158 as IDSeguradora from [dbo].[APOLICE_BERKLEY_TEMP]
	
		) as S
	on s.CodigoComercializado = T.CodigoComercializado and S.IDSeguradora = T.IDSeguradora
	WHEN NOT MATCHED THEN INSERT (CodigoComercializado,Descricao,IDSeguradora)
		Values (S.CodigoComercializado,S.Descricao,S.IDSeguradora);

		--select * from Dados.Produto where IDSeguradora = 1158
		
/**************************************************************************************************
		INSERE AS APOLICES OU CONTRATOS NÃO CADASTRADOS 
**************************************************************************************************/
 --begin tran select top 300 * from Dados.Proposta order by ID desc
 --rollback   select top 300 * from Dados.Contrato order by ID desc
 --select @@trancount
;MERGE INTO [Dados].[Contrato] AS T
  USING	
		( SELECT * FROM (
							SELECT  Apolice as NumeroContrato, DataArquivo, NomeArquivo Arquivo,1158 as IDSeguradora,DataEmissao,InicioVigencia as DataInicioVigencia
											,FimVigencia as DataFimVigencia,QuantidadeParcelas,PremioLiquido as ValorPremioLiquido,[PremioTotal] as ValorPremioTotal,
											ROW_NUMBER() OVER(PARTITION BY Apolice ORDER BY Apolice, DataArquivo DESC )  [ORDER]

							FROM dbo.[APOLICE_BERKLEY_TEMP]
							WHERE Apolice IS NOT NULL
						) A
				where a.[order] = 1
		) X
	 ON T.NumeroContrato = X.NumeroContrato
		AND T.IDSeguradora = X.IDSeguradora
  WHEN NOT MATCHED
          THEN INSERT (NumeroContrato, IDSeguradora, DataArquivo, Arquivo,DataEmissao,DataInicioVigencia,DataFimVigencia,QuantidadeParcelas,ValorPremioLiquido,ValorPremioTotal)
               VALUES (X.NumeroContrato, IDSeguradora, X.DataArquivo, X.Arquivo,X.DataEmissao,X.DataInicioVigencia,X.DataFimVigencia,X.QuantidadeParcelas,X.ValorPremioLiquido,X.ValorPremioTotal );

/**************************************************************************************************
		INSERE AS PROPOSTAS NÃO CADASTRADAS 
		
**************************************************************************************************/

;MERGE INTO [Dados].[Proposta] AS T
  USING	
		( SELECT * FROM (
							SELECT  t.NumeroProposta, t.DataArquivo, NomeArquivo TipoDado,1158 as IDSeguradora,t.DataEmissao,InicioVigencia as DataInicioVigencia
											,FimVigencia as DataFimVigencia,t.QuantidadeParcelas,PremioLiquido as ValorPremioLiquido,c.ID as IDContrato
											,PremioLiquido as Valor,p.ID as IDProduto,1 as IDSituacaoProposta,-1 as IDCanalVendaPAR,-1 as IDAgenciaVenda,-1 as IDTipoMotivo
											,ROW_NUMBER() OVER(PARTITION BY Apolice,NumeroProposta ORDER BY Apolice,NumeroProposta,  t.DataArquivo DESC )  [ORDER]

							FROM dbo.[APOLICE_BERKLEY_TEMP] t
							INNER JOIN Dados.Contrato c on c.NumeroContrato = t.Apolice and c.IDSeguradora = 1158
							INNER JOIN Dados.Produto p on p.CodigoComercializado = t.CodigoComercializado and p.IDSeguradora = c.IDSeguradora 							
							WHERE Apolice IS NOT NULL
						) A
				where a.[order] = 1
		) X
		ON T.NumeroProposta = X.NumeroProposta
		AND T.IDSeguradora = X.IDSeguradora
		WHEN NOT MATCHED THEN INSERT (IDContrato,NumeroProposta,DataArquivo,IDSeguradora,DataEmissao,DataInicioVigencia,DataFimVigencia,QuantidadeParcelas,ValorPremioLiquidoEmissao,Valor,IDProduto,TipoDado,IDSituacaoProposta,IDCanalVendaPAR,IDAgenciaVenda,IDTipoMotivo)
		Values (X.IDContrato,X.NumeroProposta,X.DataArquivo,X.IDSeguradora,X.DataEmissao,X.DataInicioVigencia,X.DataFimVigencia,X.QuantidadeParcelas,X.ValorPremioLiquido,X.Valor,X.IDProduto,X.TipoDado,X.IDSituacaoProposta,X.IDCanalVendaPAR,X.IDAgenciaVenda,X.IDTipoMotivo);
		--WHEN MATCHED
		--	    THEN UPDATE
		--		     SET IDContrato = COALESCE(T.IDContrato, X.IDContrato) --Carrega o Contrato somento quando este for NULL
		--			   , [SubGrupo] = X.SubGrupo; --Carrega o subgrupo


/**************************************************************************************************
		ATUALIZA O CAMPO IDProposta na Tabela Contrato 
**************************************************************************************************/
;MERGE INTO [Dados].[Contrato] AS T
  USING	(SELECT IDPROPOSTA,IDContrato
         FROM 
				(SELECT 
						P.ID AS IDPROPOSTA,c.ID as IDContrato,	ROW_NUMBER() OVER (PARTITION BY Apolice ORDER BY t.dataArquivo desc ) NUMERADOR
					FROM dbo.[APOLICE_BERKLEY_TEMP] T
					INNER JOIN [Dados].[Contrato] C
						ON T.Apolice = C.NumeroContrato
							AND c.IDSeguradora = 1158
					INNER JOIN [Dados].[Proposta] P
						ON T.NumeroProposta = P.NumeroProposta
							AND p.IDSeguradora = 1158
				) X
				 
			WHERE X.NUMERADOR = 1 --and
		-- A.Numeroapolice_TEMP in('108210738491', '109300000452')
			) B
		ON T.ID = B.IDContrato
	   
	WHEN MATCHED AND T.IDPROPOSTA IS NULL
			THEN UPDATE
				 SET IDProposta = B.IDProposta;

					
				
/**************************************************************************************************
		INSERE PROPOSTA CLIENTE SELECT TOP 300 * FROM Dados.PropostaCliente order BY ID DESC
**************************************************************************************************/
;MERGE INTO [Dados].[PropostaCliente] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						1158 AS IDSeguradora,
						t.NomeCliente as Nome,
						CleansingKit.[dbo].[fn_FormataCNPJ](RIGHT(t.CPFCNPJ,14)) as CPFCNPJ,
						TipoPessoa,
						DDD as DDDComercial,
						Telefone as TelefoneComercial,
						t.NomeArquivo as TipoDado,
						t.DataArquivo						 
						,ROW_NUMBER() OVER (PARTITION BY P.ID  ORDER BY t.dataArquivo desc ) NUMERADOR
					FROM dbo.[APOLICE_BERKLEY_TEMP] T
						INNER JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158
				) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 7514588
			) X
		ON T.IDProposta = X.IDProposta
	
	WHEN NOT MATCHED --AND x.DataArquivo >= t.DataArquivo --AND T.IDPROPOSTA IS NULL
			THEN INSERT (IDProposta,Nome,CPFCNPJ,TipoPessoa,DDDComercial,TelefoneComercial,TipoDado,DataArquivo)
			VALUES ( X.IDProposta,X.Nome,X.CPFCNPJ,X.TipoPessoa,X.DDDComercial,X.TelefoneComercial,X.TipoDado,X.DataArquivo);

	
/**************************************************************************************************
		INSERE PROPOSTAENDERECO select top 300 * from Dados.PropostaEndereco order by ID DESC
**************************************************************************************************/

;MERGE INTO [Dados].[PropostaEndereco] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						4 as IDTipoEndereco,
						Endereco,
						Bairro,
						Cidade,
						UF,
						CEP,
						1 as LastValue,
						t.NomeArquivo as TipoDado,
						t.DataArquivo
						,ROW_NUMBER() OVER (PARTITION BY P.ID ORDER BY t.dataArquivo desc ) NUMERADOR
					FROM dbo.[APOLICE_BERKLEY_TEMP] T
						INNER JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158 
							WHERE CEP <> '00000000' AND Endereco <> ''
				) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 7514588
			) X
		ON T.IDProposta = X.IDProposta
	
	WHEN NOT MATCHED --AND x.DataArquivo >= t.DataArquivo --AND T.IDPROPOSTA IS NULL
			THEN INSERT ([IDProposta],[IDTipoEndereco],[Endereco],[Bairro],[Cidade]
							,[UF],[CEP],[LastValue],[TipoDado],[DataArquivo])
			VALUES ( X.[IDProposta],X.[IDTipoEndereco],X.[Endereco],X.[Bairro],X.[Cidade]
							,X.[UF],X.[CEP],X.[LastValue],X.[TipoDado],X.[DataArquivo]);



/**************************************************************************************************
		INSERE ENDOSSO ZERO select top 300 * from Dados.Endosso order by ID DESC ROLLBACK
**************************************************************************************************/

;MERGE INTO [Dados].[Endosso] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						p.IDContrato,
						p.IDProduto,
						'0' as NumeroEndosso,
						t.DataEmissao,
						t.InicioVigencia as DataInicioVigencia,
						t.FimVigencia as DataFimVigencia,
						t.PremioTotal as ValorPremioTotal,
						t.PremioLiquido as ValorPremioLiquido,
						0 as IDTipoEndosso,
						t.NomeArquivo as Arquivo,
						t.DataArquivo,
						t.QuantidadeParcelas,
						t.ValorIOF,
						ROW_NUMBER() OVER (PARTITION BY P.ID ORDER BY t.dataArquivo desc ) NUMERADOR
					FROM dbo.[APOLICE_BERKLEY_TEMP] T
						INNER JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158
				) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 7514588
			) X
		ON T.IDProposta = X.IDProposta
	
	WHEN NOT MATCHED --AND x.DataArquivo >= t.DataArquivo --AND T.IDPROPOSTA IS NULL
			THEN INSERT ([IDContrato],[IDProduto],[IDProposta],[NumeroEndosso],[DataEmissao],[DataInicioVigencia],[DataFimVigencia],[ValorPremioTotal]
      ,[ValorPremioLiquido],[IDTipoEndosso],[QuantidadeParcelas],[DataArquivo],[Arquivo],[ValorIOF])
			VALUES (x.[IDContrato],x.[IDProduto],x.[IDProposta],x.[NumeroEndosso],x.[DataEmissao],x.[DataInicioVigencia],x.[DataFimVigencia],x.[ValorPremioTotal]
      ,x.[ValorPremioLiquido],x.[IDTipoEndosso],x.[QuantidadeParcelas],x.[DataArquivo],x.[Arquivo],x.[ValorIOF]);



/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Contrato_Berkley'

/****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[APOLICE_BERKLEY_TEMP]
  
/**************************************************************************************/
   
SET @COMANDO =
		'  INSERT INTO dbo.[APOLICE_BERKLEY_TEMP]
				(    [ID]
					  ,[Ramo]
					  ,[NumeroProposta]
					  ,[Apolice]
					  ,[DataEmissao]
					  ,[InicioVigencia]
					  ,[FimVigencia]
					  ,[QuantidadeParcelas]
					  ,[DataVencimentoPrimeiraParcela]
					  ,[ComissaoAntecipada]
					  ,[ComissaoInicideSobreAdicional]
					  ,[PremioLiquido]
					  ,[Adicional]
					  ,[CustoDeApolice]
					  ,[ValorIOF]
					  ,[PremioTotal]
					  ,[PercentualDeComissao]
					  ,[ValorComissao]
					  ,[ApoliceRenovada]
					  ,[NumeroPropostaCorretor]
					  ,[NomeUsuario]
					  ,[MatriculaProdutorPAR]
					  ,[NomeCliente]
					  ,[Endereco]
					  ,[Bairro]
					  ,[Cidade]
					  ,[UF]
					  ,[CEP]
					  ,[TipoPessoa]
					  ,[CPFCNPJ]
					  ,[DDD]
					  ,[Telefone]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[CodigoComercializado]
					  ,[Descricao]
				 
				  )
			SELECT 
				[ID]
					  ,[Ramo]
					  ,[NumeroProposta]
					  ,[Apolice]
					  ,[DataEmissao]
					  ,[InicioVigencia]
					  ,[FimVigencia]
					  ,[QuantidadeParcelas]
					  ,[DataVencimentoPrimeiraParcela]
					  ,[ComissaoAntecipada]
					  ,[ComissaoInicideSobreAdicional]
					  ,[PremioLiquido]
					  ,[Adicional]
					  ,[CustoDeApolice]
					  ,[ValorIOF]
					  ,[PremioTotal]
					  ,[PercentualDeComissao]
					  ,[ValorComissao]
					  ,[ApoliceRenovada]
					  ,[NumeroPropostaCorretor]
					  ,[NomeUsuario]
					  ,[MatriculaProdutorPAR]
					  ,[NomeCliente]
					  ,[Endereco]
					  ,[Bairro]
					  ,[Cidade]
					  ,[UF]
					  ,[CEP]
					  ,[TipoPessoa]
					  ,[CPFCNPJ]
					  ,[DDD]
					  ,[Telefone]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[CodigoComercializado]
					  ,[Descricao]
					
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceBerkley] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 


SELECT @MaiorCodigo= MAX(PRP.ID)
FROM dbo.[APOLICE_BERKLEY_TEMP] PRP  

/*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_BERKLEY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[APOLICE_BERKLEY_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




