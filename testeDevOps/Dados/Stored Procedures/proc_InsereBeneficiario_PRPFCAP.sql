
CREATE PROCEDURE [Dados].[proc_InsereBeneficiario_PRPFCAP] 
AS
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_PRPFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_PRPFCAP_TEMP];

CREATE TABLE [dbo].[Beneficiario_PRPFCAP_TEMP]
(
	[Codigo] [int] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[TipoArquivo] [varchar](15) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado] AS CAST(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) AS VARCHAR(20)) PERSISTED,
	[NomeBeneficiario] [varchar](40) NULL,
	[DataNascimentoBeneficiario] [date] NULL,
	[CPFCNPJBeneficiario] [varchar](8000) NULL,
	[TipoPessoaBeneficiario] [varchar](8000) NULL,
	[EstadoCivil] [varchar](1) NULL,
	[EstadoCivilBeneficiario] [varchar](8) NULL,
	[Sexo] [varchar](1) NULL,
	[DescricaoSexoBeneficiario] [varchar](9) NULL,
	[CodigoParentesco] [varchar](1) NULL,
	[Parentesco] [varchar](11) NULL,
	[PercentualFGB] [numeric](5, 0) NULL,
	[PercentualPeculio] [numeric](5, 0) NULL,
	[PercentualPensao] [numeric](5, 0) NULL,
	[PercentualParticipacao] [numeric](5, 0) NULL,
	[QtdeTitulos] [varchar](8000) NOT NULL,
	[NumeroOrdemTitular] [char](2) NULL
)

 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_Beneficiario_PRPFPREV_TEMP ON [dbo].[Beneficiario_PRPFCAP_TEMP] (Codigo ASC)         

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Beneficiario_PRPFCAP'

--SELECT @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = 0 
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)
SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_PRPFCAP_TEMP] (
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos],
						[NumeroOrdemTitular]

	                    )  
                SELECT  
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],
	                    [TipoArquivo],                                            
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos],
						[NumeroOrdemTitular] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[Beneficiario_PRPFCAP_TEMP] PRP

/****************************************************************************/
/****************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
            
/*Inserção de Propostas não Localizadas - Por Numero de Proposta*/
MERGE INTO Dados.Proposta AS T
USING (
		SELECT  EM.[NumeroPropostaTratado], 
		        3 AS [IDSeguradora],
	            MAX(TipoArquivo) [TipoDado], 
				MAX(DataArquivo) [DataArquivo]
        FROM [Beneficiario_PRPFCAP_TEMP] EM
        WHERE EM.NumeroPropostaTratado IS NOT NULL
        GROUP BY EM.[NumeroPropostaTratado]
      ) X
ON T.NumeroProposta = X.NumeroPropostaTratado
AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
    VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               		               
		               

/*Inserção de Propostas de Clientes não Localizadas - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING (
		SELECT  PRP.ID [IDProposta], 
				3 AS [IDSeguradora], 
				'Cliente Desconhecido - Proposta não Recebida' [NomeCliente], 
				MAX(TipoArquivo) [TipoDado], 
				MAX(EM.[DataArquivo]) [DataArquivo]
		FROM [Beneficiario_PRPFCAP_TEMP] EM
		INNER JOIN Dados.Proposta PRP
		ON PRP.NumeroProposta = EM.NumeroPropostaTratado
		AND PRP.IDSeguradora = 3
		WHERE EM.NumeroPropostaTratado IS NOT NULL
		GROUP BY PRP.ID
      ) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	VALUES (X.IDProposta, X.TipoDado, X.[NomeCliente], X.[DataArquivo]);


/*Carga de Parentescos*/		               
MERGE INTO Dados.Parentesco AS T
USING (
		SELECT DISTINCT EM.CodigoParentesco, 
					    '' [Descricao] 
        FROM [Beneficiario_PRPFCAP_TEMP] EM
        WHERE EM.CodigoParentesco IS NOT NULL
      ) X
ON T.[ID] = X.CodigoParentesco 
WHEN NOT MATCHED THEN 
	INSERT (ID, Descricao)
	VALUES (X.CodigoParentesco, X.[Descricao]);

                    
/*Carga do EstadoCivil*/		               
MERGE INTO Dados.EstadoCivil AS T
USING (
		SELECT DISTINCT EM.EstadoCivil, 
						'' [Descricao] 
        FROM [Beneficiario_PRPFCAP_TEMP] EM
        WHERE EM.CodigoParentesco IS NOT NULL
      ) X
ON T.[ID] = X.EstadoCivil 
WHEN NOT MATCHED THEN
	INSERT (ID, Descricao)
	VALUES (X.EstadoCivil, X.[Descricao]);

/***********************************************************************
    Carrega os dados de sexo do cliente não cadastrados
***********************************************************************/

;MERGE INTO [Dados].[Sexo] T
	USING (
			SELECT DISTINCT em.Sexo, 
							em.DescricaoSexoBeneficiario AS descricao
			FROM [dbo].[Beneficiario_PRPFCAP_TEMP] EM
			WHERE em.Sexo IS NOT NULL
			) X
		ON T.ID = X.Sexo
			WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.Sexo, X.descricao);
	



/*Carga dos Beneficiários*/		               
MERGE INTO Dados.PropostaBeneficiario AS T
	USING 
		(             
			SELECT
				PRP.ID [IDProposta],  
				MAX(A.[Arquivo]) [Arquivo],
				MAX(A.[DataArquivo]) [DataArquivo],
				A.NumeroPropostaTratado AS NumeroProposta,
				A.[Nome],
				A.[DataNascimento],
				A.[CPFCNPJ],
				A.[IDEstadoCivil],
				A.[IDSexo],
				A.[IDParentesco],
				SUM(A.[PercentualFGB]) [PercentualFGB],
				SUM(A.[PercentualPeculio]) [PercentualPeculio],
				SUM(A.[PercentualPensao]) [PercentualPensao],
				SUM(A.[PercentualParticipacao]) [PercentualParticipacao],
				SUM(CAST(A.[QuantidadeTitulos] AS INT)) [QuantidadeTitulos],
				CAST(NumeroOrdemTitular AS INT) AS NumeroOrdemTitular
		FROM
		   (
			SELECT 	
				BEN.Codigo,       
				BEN.[NomeArquivo] [Arquivo],
				BEN.[DataArquivo],
				BEN.NumeroPropostaTratado,
				BEN.[NomeBeneficiario] [Nome],
				BEN.[DataNascimentoBeneficiario] [DataNascimento],
				BEN.[CPFCNPJBeneficiario] [CPFCNPJ],
				[TipoPessoaBeneficiario],
				BEN.[EstadoCivil] [IDEstadoCivil],
				BEN.[Sexo] [IDSexo],
				BEN.CodigoParentesco [IDParentesco],
				ISNULL(BEN.[Parentesco], '') [Parentesco],
				BEN.[PercentualFGB] [PercentualFGB],
				BEN.[PercentualPeculio] [PercentualPeculio],
				BEN.[PercentualPensao] [PercentualPensao] ,
				BEN.[PercentualParticipacao] [PercentualParticipacao],
				BEN.[QtdeTitulos] [QuantidadeTitulos],
				BEN.NumeroOrdemTitular,
				ROW_NUMBER() OVER(PARTITION BY /*BEN.Codigo,*/ NumeroProposta, [NomeBeneficiario], ISNULL([Parentesco], '') ORDER BY Codigo DESC) [Order]
			FROM [Beneficiario_PRPFCAP_TEMP] BEN
			WHERE NomeBeneficiario IS NOT NULL /*IS NULL*/
			) A
			LEFT JOIN Dados.Proposta PRP
			ON PRP.NumeroProposta = A.NumeroPropostaTratado
				AND PRP.IDSeguradora = 3
			WHERE A.[Order] = 1
			GROUP BY PRP.[ID],  
				A.NumeroPropostaTratado,
				A.[Nome],
				A.[DataNascimento],
				A.[CPFCNPJ],
				A.[IDEstadoCivil],
				A.[IDSexo],
				A.[IDParentesco],
				A.NumeroOrdemTitular
			) AS O
	ON      T.IDProposta = O.IDProposta
		AND T.Nome = O.Nome
		AND T.[IDParentesco] = O.[IDParentesco]
	WHEN MATCHED THEN 
			UPDATE
				SET T.CPFCNPJ = COALESCE(O.CPFCNPJ, T.CPFCNPJ),
					T.DataNascimento = COALESCE(O.DataNascimento, T.DataNascimento),
					T.IDEstadoCivil = COALESCE(O.IDEstadoCivil, T.IDEstadoCivil),
					T.IDSexo = COALESCE(O.IDSexo, T.IDSexo),
					T.DataArquivo = COALESCE(O.DataArquivo, T.DataArquivo),
					T.Arquivo = COALESCE(O.Arquivo, T.Arquivo),
					T.IDParentesco = COALESCE(O.IDParentesco, T.IDParentesco),
					T.PercentualFGB = COALESCE(O.PercentualFGB, T.PercentualFGB),
					T.PercentualPeculio = COALESCE(O.PercentualPeculio, T.PercentualPeculio),
					T.PercentualPensao = COALESCE(O.PercentualPensao, T.PercentualPensao),
					T.PercentualParticipacao = COALESCE(O.PercentualParticipacao, T.PercentualParticipacao),
					T.QuantidadeTitulos = COALESCE(O.QuantidadeTitulos, T.QuantidadeTitulos),
					T.NumeroOrdemTitular = COALESCE(O.NumeroOrdemTitular, T.NumeroOrdemTitular)
		WHEN NOT MATCHED THEN 
			INSERT (IDProposta,Nome,CPFCNPJ,DataNascimento,IDSexo,IDEstadoCivil,[IDParentesco],
					PercentualFGB,PercentualPeculio,PercentualPensao,PercentualParticipacao,
					QuantidadeTitulos, DataArquivo, Arquivo, NumeroOrdemTitular)
			VALUES (O.IDProposta,O.Nome,O.CPFCNPJ,O.DataNascimento,O.IDSexo,O.IDEstadoCivil,O.[IDParentesco],
					O.PercentualFGB,O.PercentualPeculio,O.PercentualPensao,O.PercentualParticipacao,
					O.QuantidadeTitulos, O.DataArquivo, O.Arquivo, O.NumeroOrdemTitular);
    
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Beneficiario_PRPFCAP'

TRUNCATE TABLE [dbo].[Beneficiario_PRPFCAP_TEMP]

/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_PRPFCAP_TEMP] (
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos],
						[NumeroOrdemTitular]

	                    )  
                SELECT  
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],
	                    [TipoArquivo],                                            
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos],
						[NumeroOrdemTitular] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)                       

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[Beneficiario_PRPFCAP_TEMP] PRP
                    
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_PRPFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_PRPFCAP_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
