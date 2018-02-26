 
/*
	Autor: Egler Vieira
	Data Criação: 09/10/2014

	Descrição: 
	
	Última alteração :
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePropostaEExtrato_PRESTAMISTA_PREMIO
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
						
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	rollback
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePropostaEExtrato_PRESTAMISTA_PREMIO] 
AS

BEGIN TRY		

DECLARE @Produtos AS VARCHAR(8000)
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_PREMIO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRESTAMISTA_PREMIO_TEMP];
--select * from [PRESTAMISTA_PREMIO_TEMP]
CREATE TABLE [dbo].[PRESTAMISTA_PREMIO_TEMP](
	[Codigo] [bigint]  NOT NULL,                             
	[ControleVersao] [decimal](16, 8) NULL,					 
	[NomeArquivo] [varchar](300) NOT NULL,					 
	[DataArquivo] [date] NULL,								 
	[NumeroProduto] [varchar](4) NULL,						 
	[TipoCredito] [char](2) NULL,							 
	[NumeroProposta] [varchar](20) NULL,					 
	[NumeroContrato] [varchar](20) NULL,					 
	[CodigoSubestipulante] INT,                              
	[RendaPactuada] [varchar](10) NULL,						 
	[CodigoESCNEG] [varchar](10) NULL,						 
	[CodigoPV] [smallint] NULL,								 
	[CodigoUnoNum] [varchar](10) NULL,						 
	[CodigoUnoDv] [char](1) NULL,							 
	[NomeSegurado] [varchar](60) NULL,						 
	[DataNascimento] [date] NULL,							 
	[CPFCNPJ] [char](14) NULL,								 
	[DataContrato] [date] NULL,								 
	[DataInclusao] [date] NULL,								 
	[DataAmortizacao] [date] NULL,							 
	[PrazoVigencia] int NULL,								 
	[NumeroOrdemInclusao] [varchar](10) NULL,				 
	[NumeroRI] [varchar](5) NULL,							 
	[IDISMip] tinyint NULL,					 
	[ValorFinanciamento] [numeric](16, 2) NULL,				 
	[PremioMip] [numeric](16, 2) NULL,						 
	[IOFMip] [numeric](16, 2) NULL,							 
	[PremioMipAtrasado] [numeric](16, 2) NULL,				 
	[IOFMipAtrasado] [numeric](16, 2) NULL,					 
	[IDISInad] tinyint NULL,			 
	[PremioInad] [numeric](16, 2) NULL,						 
	[IOFInad] [numeric](16, 2) NULL,						 
	[PremioInadAtrasado] [numeric](16, 2) NULL,				 
	[IOFInadAtrasado] [numeric](16, 2) NULL,				 
	[UF] [char](2) NULL,									 
	[Cidade] [varchar](25) NULL,							 
	[Bairro] [varchar](20) NULL,							 
	[Logradouro] [varchar](40) NULL,						 
	[Complemento] [varchar](25) NULL,						 
	[Numero] [varchar](5) NULL,								 
	[CEP] [varchar](10) NULL,								 
	[CodigoSeguradora] smallint default(1) NOT NULL	 ,
	PropostaUnderline as 'PS000'+substring(numeroproposta,6,len(numeroproposta)-6)+'_' persisted,
	PropostaODS as 'PS000'+substring(numeroproposta,6,len(numeroproposta)) persisted,
	PremioTotal as COALESCE(PremioMip, ABS(PremioMipAtrasado), 0) + ISNULL([IOFMip],0) + ISNULL([PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0) persisted
	
);

CREATE NONCLUSTERED INDEX [IDX_NCL_PRESTAMISTA_PREMIO_TEMP_CodigoSeguradora]
ON [dbo].[PRESTAMISTA_PREMIO_TEMP] ([CodigoSeguradora])
INCLUDE ([NumeroProposta])


 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_PREMIO_TEMP_NumeroProposta ON [dbo].[PRESTAMISTA_PREMIO_TEMP]
( 
	NumeroProposta ASC,
	[DataArquivo] DESC
)

CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_PREMIO_TEMP_NumeroProduto ON [dbo].[PRESTAMISTA_PREMIO_TEMP]
([NumeroProduto])
INCLUDE ([NumeroProposta],[Logradouro])


CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_PREMIO_TEMP_PropostaUnderline ON [dbo].[PRESTAMISTA_PREMIO_TEMP]
(PropostaUnderline,PremioTotal)
INCLUDE ([NumeroProposta])

CREATE NONCLUSTERED INDEX idx_PRESTAMISTA_PREMIO_TEMP_PropostaODS ON [dbo].[PRESTAMISTA_PREMIO_TEMP]
(PropostaODS,PremioTotal)
INCLUDE ([NumeroProposta])


CREATE CLUSTERED INDEX idx_PRESTAMISTA_PREMIO_TEMP_NumeroProposta_TipoEndereco ON [dbo].[PRESTAMISTA_PREMIO_TEMP]
( 
	NumeroProposta ASC,
	Logradouro ASC
)

CREATE NONCLUSTERED INDEX IDX_NCL_PRESTAMISTA_PREMIO_TEMP_CodigoPV
ON [dbo].[PRESTAMISTA_PREMIO_TEMP] ([CodigoPV])



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.propostaPSM') AND type in (N'U') /*ORDER BY NAME*/)
DROP TABLE dbo.propostaPSM
SELECT p.ID,'PS000'+SUBSTRING(NumeroProposta,6,12) AS NumeroPropostaTratado,NumeroProposta,
  DataProposta,
  ISNULL(ValorPremioBrutoEmissao,0) ValorPremioBrutoEmissao,
  CPFCNPJ as CPFCNPJ
INTO  propostaPSM 
FROM Dados.Proposta  p
inner join Dados.PropostaCliente pc on pc.IDProposta = p.ID
WHERE  p.NumeroProposta like 'PS%'


CREATE CLUSTERED INDEX cl_idx_psm ON propostaPSM(NumeroPropostaTratado)

CREATE NONCLUSTERED INDEX [ncl_idx_PrpIDCanalM]
ON [dbo].[propostaPSM] ([ID])
INCLUDE (NumeroPropostaTratado,NumeroProposta)

----------------------------------------------------------------------
--Recupera Produtos PrestaMista 
-- A variável @Produtos, alimentada aqui, será enviada como parâmetro para a proc de recuperação
-- ([Fenae].[Corporativo].[proc_RecuperaFinanceiroPrestamista_PREMIO]) para que apenas os produtos prestamista sejam recuperados
----------------------------------------------------------------------
;WITH CTE
AS
(
	SELECT top 1 Cast(A.CodigoComercializado AS VARCHAR(8000)) CodigoComercializado, Cast(A.Ordem as int) Ordem
	FROM ConfiguracaoDados.ImportaPrestamistaExtratoFinanceiro A
	UNION ALL
	SELECT CHAR(39) + CTE.CodigoComercializado + CHAR(39) + ' , ' + CHAR(39) + Cast(B.CodigoComercializado AS VARCHAR(8000)) + CHAR(39) CodigoComercializado,  Cast(B.Ordem as int) Ordem
	FROM ConfiguracaoDados.ImportaPrestamistaExtratoFinanceiro B
	INNER JOIN CTE
	ON B.Ordem = CTE.Ordem + 1
)
SELECT TOP 1 @Produtos = REPLACE(REPLACE(CodigoComercializado, CHAR(39) + CHAR(39), CHAR(39)), CHAR(39), '#') --CodigoComercializado
FROM CTE
ORDER BY Ordem DESC
----------------------------------------------------------------------

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PRESTAMISTA_PREMIO'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
SET @COMANDO =
    N'  INSERT INTO dbo.PRESTAMISTA_PREMIO_TEMP
      (
	     [Codigo],                                                              
		 [ControleVersao],                                                      
		 [NomeArquivo],                                                         
		 [DataArquivo],                                                         
		 [NumeroProduto],                                                       
		 [TipoCredito],                                                         
		 [NumeroProposta],                                                      
		 [NumeroContrato],                                                      
		 [CodigoSubestipulante],                                               
		 [RendaPactuada],                                                      
		 [CodigoESCNEG],                                                       
		 [CodigoPV],                                                           
		 [CodigoUnoNum],                                                       
		 [CodigoUnoDv],                                                        
		 [NomeSegurado],                                                       
		 [DataNascimento],                                                     
		 [CPFCNPJ],                                                            
		 [DataContrato],                                                       
		 [DataInclusao],                                                       
		 [DataAmortizacao],                                                    
		 [PrazoVigencia],                                                      
		 [NumeroOrdemInclusao],                                                
		 [NumeroRI],                                                           
		 [IDISMip],                                                 
		 [ValorFinanciamento],                                                 
		 [PremioMip],                                                          
		 [IOFMip],                                                             
		 [PremioMipAtrasado],                                                  
		 [IOFMipAtrasado],                                                     
		 [IDISInad],                                                
		 [PremioInad],                                                         
		 [IOFInad],                                                            
		 [PremioInadAtrasado],                                                 
		 [IOFInadAtrasado],                                                    
		 [UF],                                                               
		 [Cidade],                                                             
		 [Bairro],                                                             
		 [Logradouro],                                                         
		 [Complemento],                                                        
		 [Numero],                                                             
		 [CEP]
	  )
       SELECT 
	     [Codigo],                                                              
		 [ControleVersao],                                                      
		 [NomeArquivo],                                                         
		 [DataArquivo],                                                         
		 [NumeroProduto],                                                       
		 [TipoCredito],                                                         
		 [NumeroProposta],                                                      
		 [NumeroContrato],                                                      
		 [CodigoSubestipulante],                                               
		 [RendaPactuada],                                                      
		 [CodigoESCNEG],                                                       
		 [CodigoPV],                                                           
		 [CodigoUnoNum],                                                       
		 [CodigoUnoDv],                                                        
		 [NomeSegurado],                                                       
		 [DataNascimento],                                                     
		 [CPFCNPJ],                                                            
		 [DataContrato],                                                       
		 [DataInclusao],                                                       
		 [DataAmortizacao],                                                    
		 [PrazoVigencia],                                                      
		 [NumeroOrdemInclusao],                                                
		 [NumeroRI],                                                           
		 [IDISMip],                                                 
		 [ValorFinanciamento],                                                 
		 [PremioMip],                                                          
		 [IOFMip],                                                             
		 [PremioMipAtrasado],                                                  
		 [IOFMipAtrasado],                                                     
		 [IDISInad],                                                
		 [PremioInad],                                                         
		 [IOFInad],                                                            
		 [PremioInadAtrasado],                                                 
		 [IOFInadAtrasado],                                                    
		 [UF],                                                               
		 [Cidade],                                                             
		 [Bairro],                                                             
		 [Logradouro],                                                         
		 [Complemento],                                                        
		 [Numero],                                                             
		 [CEP]               
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaFinanceiroPrestamista_PREMIO] ''''' + @PontoDeParada + ''''', ''' + char(39) + @Produtos + char(39) + ''''' ) PRP
         '
	exec sp_executesql  @tsql  = @COMANDO

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo
--rollback
	
  /*********************************************************************************************************************/
  --SELECT * FROM PRESTAMISTA_PREMIO_TEMP where numeroproduto = '1408'

	--------------------------------------------------------------------------------------------------------------
	--Converte os produtos de presta mista com outros números para os códigos corretos
	--------------------------------------------------------------------------------------------------------------
	UPDATE dbo.PRESTAMISTA_PREMIO_TEMP SET NumeroProduto = COALESCE(IPEF.CodigoProdutoMip, IPEF.CodigoComercializado) 
	FROM ConfiguracaoDados.ImportaPrestamistaExtratoFinanceiro IPEF
	INNER JOIN  dbo.PRESTAMISTA_PREMIO_TEMP PRP 
	ON IPEF.CodigoComercializado = PRP.NumeroProduto
	--------------------------------------------------------------------------------------------------------------

	/***********************************************************************
		   Carregar as agencias desconhecidas
	***********************************************************************/
	/*INSERE PVs NÃO LOCALIZADOS*/
	;INSERT INTO Dados.Unidade(Codigo)
	SELECT DISTINCT CAD.CodigoPV
	FROM dbo.[PRESTAMISTA_PREMIO_TEMP] CAD
	WHERE  CAD.CodigoPV IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.CodigoPV);

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'PRPSASSE' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					'PRPSASSE' [Arquivo]

	FROM dbo.[PRESTAMISTA_PREMIO_TEMP] EM
	INNER JOIN Dados.Unidade U
	ON EM.CodigoPV = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 
	--BEGIN TRAN
		      --     SELECT @@TRANCOUNT
			  --rollback
     /***********************************************************************
       Carrega os dados da Proposta
     ***********************************************************************/             
    ;MERGE INTO Dados.Proposta AS T
		USING (
		       SELECT *
			   FROM
			   (
				SELECT DISTINCT  ps.NumeroPropostatratado,
				coalesce(pp2.ID,pp1.ID) IDProposta,
				coalesce(pp1.NumeroProposta,pp2.NumeroProposta) NumeroPRopostaODS
					 , SUBSTRING(PRP.NumeroProposta,1,LEN(PRP.NumeroProposta)-1) + '_' as NumeroProposta
					 , PRP.NumeroProposta as NumeroPropostaOriginal   
					 ,PropostaODS                                                                                            
					 , SGD.ID [IDSeguradora]																					           
					 , PRD.ID [IDProduto]																						
					 , SIG.ID [IDProdutoSIGPF]																					           
					 , pp.ID [IDPeriodicidadePagamento]																			
					 , PRP.DataContrato DataProposta																			           
					 , Cast(CleansingKit.dbo.fn_decimalNull(COALESCE(PRP.PremioMip, ABS(PRP.PremioMipAtrasado), 0) + ISNULL([IOFMip],0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0)) as numeric(16,2)) ValorPagoSICOB												
					 , PRP.RendaPactuada																							                   
					 , U.ID [IDAgenciaVenda]																						                   
					 , PRP.DataArquivo																								--[CodigoPV],                         
					 , PRP.[NomeArquivo] TipoDado																					--[CodigoUnoNum],                     
					 , PRP.Codigo																									--[CodigoUnoDv],                      
					 , PRP.DataInclusao
					 , Cast(PRP.PrazoVigencia as int) PrazoVigencia																											                     
					 , Cast(CleansingKit.dbo.fn_decimalNull(COALESCE(PRP.PremioMip, ABS(PRP.PremioMipAtrasado), 0) + ISNULL([IOFMip],0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0)) as numeric(16,2)) [ValorPremioBrutoEmissao]																		                   
					 , Cast(CleansingKit.dbo.fn_decimalNull(COALESCE(PRP.PremioMip, ABS(PRP.PremioMipAtrasado), 0) + ISNULL([IOFMip],0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0)) as numeric(16,2)) [ValorPremioTotal]																				                   
					 , Cast(CleansingKit.dbo.fn_decimalNull(COALESCE(PRP.PremioMip, ABS(PRP.PremioMipAtrasado), 0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([PremioInad],0)) as numeric(16,2)) [ValorPremioLiquidoEmissao]															          
					 , PRP.[DataInclusao] [DataAutenticacaoSICOB]															                  
					 , PRP.CodigoSubestipulante SubGrupo    																               
					 , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta ORDER BY  Cast(CleansingKit.dbo.fn_decimalNull(ISNULL(PRP.PremioMip,0) + ISNULL([IOFMip],0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0)) as numeric(16,2)) DESC, PRP.Codigo ASC) [RANK]	                 
								    
				FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
				  INNER JOIN Dados.Seguradora SGD
				  ON SGD.Codigo = PRP.CodigoSeguradora
				  LEFT OUTER JOIN Dados.Produto PRD
				  ON PRD.CodigoComercializado = PRP.[NumeroProduto]
				  --LEFT JOIN Dados.ProdutoDesmembramento PD
				  --ON PRD.IDProduto = PD.IDProdutoDfi
				  LEFT JOIN Dados.ProdutoSIGPF SIG
				  ON SIG.ID = PRD.IDProdutoSIGPF
				  LEFT OUTER JOIN Dados.PeriodoPagamento PP
				  ON PP.ID = PRD.IDPeriodoPagamento 
				  LEFT OUTER JOIN Dados.Unidade U
				  ON U.Codigo = PRP.CodigoPV
				LEFT JOIN dbo.PropostaPSM ps on ps.NumeroPropostaTratado like PRP.PropostaUnderline   and (PS.ValorPremioBrutoEmissao = PRP.PremioTotal or ps.CPFCNPJ = PRP.CPFCNPJ)
				left join Dados.Proposta pp1 on pp1.ID = ps.ID 
				left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroProposta 
				  --LEFT OUTER JOIN Dados.SituacaoProposta SP
				  --ON SP.Sigla = PRP.SituacaoProposta
				 -- LEFT OUTER JOIN Dados.TipoMotivo TM
				 -- ON TM.Codigo = PRP.MotivoSituacao
				 ---- LEFT OUTER JOIN Dados.SituacaoCobranca SB
				 --PropostaUnderline
				 --PropostaODS as 'P
				 -- ON SB.Sigla = PRP.SituacaoCobranca
				 -- LEFT OUTER JOIN Dados.Funcionario F
				 -- ON F.[Matricula] = PRP.[MatriculaVendedor]
				 -- AND F.IDEmpresa = 1
				 --WHERE p.ID = 67336401
				 --where PRP.NumeroProposta like 'PS006152000057101'
				) A
				WHERE A.RANK = 1
				  --AND A.NumeroProposta = 'PS003415800899601'
          ) AS X
    ON  x.IDPRoposta = T.ID
	--(X.NumeroProposta = T.NumeroProposta OR X.NumeroPropostaOriginal = T.NumeroProposta)
 --  AND X.IDSeguradora = T.IDSeguradora
    WHEN MATCHED
			    THEN UPDATE
				     SET 																				           
					   [IDProduto] = COALESCE(T.[IDProduto], X.[IDProduto])																						
					 , [IDProdutoSIGPF]	= COALESCE(T.[IDProdutoSIGPF], X.[IDProdutoSIGPF])																					           
					 , IDPeriodicidadePagamento = COALESCE(T.[IDPeriodicidadePagamento], X.[IDPeriodicidadePagamento])																			
					 , DataProposta	= CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
					                       WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
										   ELSE COALESCE (X.DataProposta, T.DataProposta)
									  END																		           
					 , Valor = COALESCE(T.Valor, X.ValorPagoSICOB)	 --ValorPagoSICOB												
					 --, PRP.RendaPactuada																							                   
					 , [IDAgenciaVenda]	= COALESCE(T.[IDAgenciaVenda], X.[IDAgenciaVenda])																						
					 , DataArquivo = CASE WHEN  X.DataArquivo IS NOT NULL AND T.DataArquivo IS NOT NULL THEN IIF(T.DataArquivo > X.DataArquivo, X.DataArquivo, T.DataArquivo)
					                      ELSE COALESCE(T.DataArquivo, X.DataArquivo)
									 END																							                     
					 , TipoDado	= COALESCE(T.TipoDado, X.TipoDado)																					                                
					 --, PRP.Codigo																							                     
					 --, PRP.Codigo																							                     
					 , DataInicioVigencia = COALESCE(CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
														WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
														ELSE COALESCE (X.DataProposta, T.DataProposta)
													END, T.DataInicioVigencia)
					 , DataFimVigencia = COALESCE(DATEADD(mm, X.PrazoVigencia, CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
																				WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
																				ELSE COALESCE (X.DataProposta, T.DataProposta)
																			END), T.DataFimVigencia)																			                   
					 , [ValorPremioTotal] = COALESCE(T.[ValorPremioTotal], X.[ValorPremioTotal])																					                   
					 , [ValorPremioLiquidoEmissao]	= COALESCE(X.[ValorPremioLiquidoEmissao], T.[ValorPremioLiquidoEmissao])															          
					 , [DataAutenticacaoSICOB] = COALESCE(T.[DataAutenticacaoSICOB], X.[DataAutenticacaoSICOB])																                  
					 , SubGrupo = COALESCE(T.SubGrupo, X.SubGrupo)	 
					 , NumeroProposta = NumeroPropostaOriginal  						
    WHEN NOT MATCHED
			    THEN INSERT          
              (         NumeroProposta                                                                                                
					 , [IDSeguradora]																					           
					 , [IDProduto]																						
					 , [IDProdutoSIGPF]																					           
					 , [IDPeriodicidadePagamento]																			
					 , DataProposta																			           
					 , Valor --ValorPagoSICOB												
					 --, PRP.RDataFimVigencia = COALESCE(T.DataFimVigencia, DATEADD(mm, X.DataPrazoVigencia, X.DataInclusao))endaPactuada																							                   
					 , [IDAgenciaVenda]																						
					 , DataArquivo																						                     
					 , TipoDado																					                                
					 --, PRP.Codigo																						    
					 , [ValorPremioBrutoEmissao]																		                   
					 , [ValorPremioTotal]																				                   
					 , [ValorPremioLiquidoEmissao]															          
					 , [DataAutenticacaoSICOB]															                  
					 , SubGrupo    	
					 , DataInicioVigencia
					 , DataFimVigencia				 									       
             )
          VALUES (X.NumeroPropostaOriginal                       
                 ,X.[IDSeguradora]						
				 ,X.[IDProduto]							
                 ,X.[IDProdutoSIGPF]						
                 ,X.[IDPeriodicidadePagamento]			
                 ,X.DataProposta							
                 ,X.ValorPagoSICOB				
                 --, PRP.RendaPactuada					
                 ,X.[IDAgenciaVenda]						
                 ,X.DataArquivo						
                 ,X.TipoDado	
                 ,X.[ValorPremioBrutoEmissao]			      
                 ,X.[ValorPremioTotal]					
                 ,X.[ValorPremioLiquidoEmissao]			   
				 ,X.[DataAutenticacaoSICOB]		
				 ,X.SubGrupo	
				 ,X.DataInclusao
				 ,DATEADD(mm, X.PrazoVigencia, X.DataInclusao)	
				 );            				 																												                     
				--select * from dados.proposta where ID = 67318039
                 --67336401
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
				SELECT *
				FROM
				(
				SELECT  DISTINCT
						    PRP1.ID [IDProposta]
						   -- Cliente
						  , [NomeSegurado] [Nome]
						  , [DataNascimento]
						  , [CPFCNPJ]
						  , 'Pessoa Física' TipoPessoa		     
						  , PRP.DataArquivo																								--[CodigoPV],                         
					      , PRP.[NomeArquivo] TipoDado	            
						  , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
				FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
				  ON PRP.NumeroProposta = PRP1.NumeroProposta
				  INNER JOIN Dados.Seguradora SGD
				  ON SGD.Codigo = PRP.CodigoSeguradora
				 AND PRP1.IDSeguradora = SGD.ID
				) A
				WHERE [RANK] = 1
          ) AS X
    ON X.IDProposta = T.IDProposta
       WHEN MATCHED
			    THEN UPDATE
		     SET CPFCNPJ = COALESCE(T.[CPFCNPJ], X.[CPFCNPJ])
               , Nome = COALESCE(X.[Nome], T.[Nome])
               , DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento])
               , TipoPessoa  = COALESCE(X.[TipoPessoa ], T.[TipoPessoa])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])	
    WHEN NOT MATCHED
			    THEN INSERT          
             ( IDProposta
			  , CPFCNPJ
			  , Nome
			  , DataNascimento
			  , TipoPessoa
              , TipoDado, DataArquivo
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
              );
      /***********************************************************************/
        

    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
	/*Egler - Data: 23/09/2013 */
    UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP1.ID
							FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
							  INNER JOIN Dados.Proposta PRP1
							  ON PRP.NumeroProposta = PRP1.NumeroProposta
							  INNER JOIN Dados.Seguradora SGD
							  ON SGD.Codigo = PRP.CodigoSeguradora
							 AND PRP1.IDSeguradora = SGD.ID							 
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
		  -- AND PS.IDProposta = 12585836

		   --TODO --ARRUMAR PARA GARANTIR QUE SEMPRE HAVERÁ UM REGISTRO COM LASTVALUE = 1 
    

	--SET NOCOUNT ON ;                       
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaEndereco AS T
		USING (
				SELECT 
					 A. [IDProposta]
					,A.[IDTipoEndereco]
					,A.[Endereco]        
					,A.Bairro              
					,A.Cidade       
					,A.[UF]      
					,A.CEP    
					
					--,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco ORDER BY A.DataArquivo DESC) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
					--						ELSE 0
					--	END) LastValue
					, 0 LastValue
					, A.[TipoDado]           
					, A.DataArquivo		
				FROM
				(
					SELECT   
						 PRP.ID [IDProposta]
						,2 [IDTipoEndereco] --Correspondecia
						,PRT.Logradouro [Endereco]       
						,PRT.Bairro Bairro             
						,PRT.Cidade Cidade       
						,PRT.[UF]       
						,PRT.CEP CEP   
						--CASE WHEN  
						,'PREMIO - EF0310B' [TipoDado]           
						,PRT.DataArquivo DataArquivo
						,ROW_NUMBER() OVER (PARTITION BY PRP.ID /*IDProposta*/, PRT.Logradouro ORDER BY PRT.DataArquivo DESC) NUMERADOR	   								
					 FROM dbo.PRESTAMISTA_PREMIO_TEMP PRT
						INNER JOIN Dados.Proposta PRP
						ON PRT.NumeroProposta = PRP.NumeroProposta
						INNER JOIN Dados.Seguradora SGD
						ON SGD.Codigo = PRT.CodigoSeguradora
						AND PRP.IDSeguradora = SGD.ID	
			        WHERE
					 PRT.Logradouro IS NOT NULL

					-- AND PRP.ID = 12585836
				) A 	
				WHERE [NUMERADOR] = 1--PRP_T.NumeroProposta = 012984710001812			

          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
		      UPDATE
				SET 
                 Endereco = COALESCE(X.[Endereco], T.[Endereco])
               , Bairro = COALESCE(X.[Bairro], T.[Bairro])
               , Cidade = COALESCE(X.[Cidade], T.[Cidade])
               , UF = COALESCE(X.[UF], T.[UF])
               , CEP = COALESCE(X.[CEP], T.[CEP])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
			   , DataArquivo = X.DataArquivo
			   , LastValue = X.LastValue
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, IDTipoEndereco, Endereco, Bairro                                                                
              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                            
          VALUES (
                  X.[IDProposta]   
                 ,X.[IDTipoEndereco]                                                
                 ,X.[Endereco]  
                 ,X.[Bairro]   
                 ,X.[Cidade]      
                 ,X.[UF] 
                 ,X.[CEP]            
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]
				 ,X.LastValue   
                 );
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										 SELECT PRP1.ID
										 FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
											INNER JOIN Dados.Proposta PRP1
											ON PRP.NumeroProposta = PRP1.NumeroProposta
											INNER JOIN Dados.Seguradora SGD
											ON SGD.Codigo = PRP.CodigoSeguradora
											AND PRP1.IDSeguradora = SGD.ID	
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1		

	 --SELECT *
	 --delete FROM Dados.PropostaFinanceiro 
	 --WHERE IDProposta = 50811637 AND NumeroContratoVinculado = '3415800899601' and dataarquivo = '2014-06-30'
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do PRESTAMINSTA*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaFinanceiro AS T
		USING (       
            SELECT *
            FROM
            (
				SELECT 
				   PRP.[Codigo]                                                     
				,  PRP.[ControleVersao]                                             
				,  PRP.[NomeArquivo] [Arquivo]                                                
				,  PRP.[DataArquivo]                           
				,  PRP1.ID [IDProposta]                    
				,  PRP.[NumeroProposta] [NumeroProposta]                                            
				,  PRP.[NumeroContrato] [NumeroContratoVinculado]  
				,  NULL Complemento                                           
				,  TipoCredito [IDTipoCredito]

			  	, [NumeroRI]          
				, [IDISMip]
				, [ValorFinanciamento]
				, [DataContrato]
				, [DataInclusao]
				, [PrazoVigencia]
				, [NumeroOrdemInclusao]
				, [RendaPactuada]
				, [CodigoESCNEG] 

				, ROW_NUMBER() OVER(PARTITION BY PRP1.ID, NumeroContrato ORDER BY PRP.[DataArquivo] , PRP.[Codigo] DESC)  [ORDER]
				FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
				INNER JOIN Dados.Proposta PRP1
				ON PRP.NumeroProposta = PRP1.NumeroProposta
				INNER JOIN Dados.Seguradora SGD
				ON SGD.Codigo = PRP.CodigoSeguradora
				AND PRP1.IDSeguradora = SGD.ID			       
            ) A
            WHERE A.[ORDER] = 1
			--AND A.IDProposta = 50811637
			--and a.numerocontratovinculado = '3415800899601'

            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[NumeroContratoVinculado] = T.[NumeroContratoVinculado]
    WHEN MATCHED
			    THEN UPDATE       
				     SET          --'3415800899601'
						  [IDTipoCredito] = COALESCE(X.[IDTipoCredito], T.[IDTipoCredito])
						, [NumeroContratoVinculado] = COALESCE(X.[NumeroContratoVinculado], T.[NumeroContratoVinculado])
						, [Complemento] = COALESCE(X.[Complemento], T.[Complemento])
						 
						, [NumeroRI] = COALESCE(X.[NumeroRI], T.[NumeroRI])         
						, [IDISMip] = COALESCE(X.[IDISMip], T.[IDISMip])
						, [ValorFinanciamento] = COALESCE(X.[ValorFinanciamento], T.[ValorFinanciamento])
						, [DataContrato] = CASE WHEN T.[DataContrato] IS NOT NULL AND T.[DataContrato] < X.[DataContrato] THEN T.[DataContrato]
											    WHEN X.[DataContrato] IS NOT NULL AND X.[DataContrato] < T.[DataContrato] THEN X.[DataContrato]
											    ELSE COALESCE (X.[DataContrato], T.[DataContrato])
										   END
						, [DataInclusao] = COALESCE(X.[DataInclusao], T.[DataInclusao])
						, [PrazoVigencia] = COALESCE(X.[PrazoVigencia], T.[PrazoVigencia])
						, [NumeroOrdemInclusao] = COALESCE(X.[NumeroOrdemInclusao], T.[NumeroOrdemInclusao])
						, [RendaPactuada] = COALESCE(X.[RendaPactuada], T.[RendaPactuada])
						
						, [CodigoESCNEG] = COALESCE(X.[CodigoESCNEG], T.[CodigoESCNEG])
						 
						, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
						, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])	
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDTipoCredito]
                , [NumeroContratoVinculado]
                , [Complemento]   			    
				, [NumeroRI]          
				, [IDISMip]
				, [ValorFinanciamento]
				, [DataContrato]
				, [DataInclusao]
				, [PrazoVigencia]
				, [NumeroOrdemInclusao]
				, [RendaPactuada]				 
				, [CodigoESCNEG] 

              --, [NumeroProdutoAVGestao]
				, [DataArquivo]
				, [Arquivo])
          VALUES (   
                  X.[IDProposta] 
                , X.[IDTipoCredito]                                                                
                , X.[NumeroContratoVinculado]			                                         
                , X.[Complemento] 						                             
									                      
				, X.[NumeroRI]          				                        
				, X.[IDISMip]				    
				, X.[ValorFinanciamento]				                                           
				, X.[DataContrato]						  
				, X.[DataInclusao]						 
				, X.[PrazoVigencia]						          
				, X.[NumeroOrdemInclusao]				 
				, X.[RendaPactuada]		 
				, X.[CodigoESCNEG] 						 
														 
				, X.[DataArquivo]						 
				, X.[Arquivo]							 
            ); 											  
     
	--delete FROM Dados.PropostaCliente  where idproposta in (select idproposta from Dados.PropostaFinanceiro where arquivo not like '%MJUNMOV%' AND  arquivo not like '%MVPROP%')
  /*************************************************************************************/ 
 -- ALTER INDEX [IDX_CSI_FinanceiroExtrato] ON [Dados].[FinanceiroExtrato] DISABLE;


  /*TODO: ADICIONAR A INSERÇÃO NA TABELA DE EXTRATO*/
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro do "EXTRATO" do prestamista*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.FinanceiroExtrato AS T
		USING (       
            SELECT *
            FROM
            (
				SELECT 
				  PRP.ID [IDProposta]     
				, PRD.ID IDProduto 
				, PRT.[PremioMip]     
				, PRT.[IOFMip]         
				, PRT.[PremioMipAtrasado]   
				, PRT.[IOFMipAtrasado]      
				, PRT.[IDISInad]                      
				, PRT.[PremioInad]          
				, PRT.[IOFInad]             
				, PRT.[PremioInadAtrasado]  
				, PRT.[IOFInadAtrasado]     
			  	, PRT.[DataAmortizacao]    
				, PRT.[DataArquivo]		
 				, PRT.[NomeArquivo] [Arquivo]		
				, PRT.[DataInclusao]
				, PRT.[NumeroOrdemInclusao]
				, ROW_NUMBER() OVER(PARTITION BY PRP.ID, PRT.NumeroContrato, PRT.[DataArquivo], PRD.ID ORDER BY PRT.[Codigo] DESC)  [ORDER]
				FROM dbo.PRESTAMISTA_PREMIO_TEMP PRT
				INNER JOIN Dados.Proposta PRP
				ON PRT.NumeroProposta = PRP.NumeroProposta
				INNER JOIN Dados.Seguradora SGD
				ON SGD.Codigo = PRT.CodigoSeguradora
				AND PRP.IDSeguradora = SGD.ID	        
				INNER JOIN Dados.Produto PRD
				ON PRD.CodigoComercializado = PRT.NumeroProduto  
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[IDProduto] = T.[IDProduto]
    WHEN MATCHED
			THEN UPDATE
				    SET          
					  [PremioMip] = COALESCE(X.[PremioMip], T.[PremioMip])
					, [IOFMip] = COALESCE(X.[IOFMip], T.[IOFMip])
					, [PremioMipAtrasado] = COALESCE(X.[PremioMipAtrasado], T.[PremioMipAtrasado])						 
					, [IOFMipAtrasado] = COALESCE(X.[IOFMipAtrasado], T.[IOFMipAtrasado])         
					, [DataInclusao] = COALESCE(X.[DataInclusao], T.[DataInclusao])
					, [NumeroOrdemInclusao] = COALESCE(X.[NumeroOrdemInclusao], T.[NumeroOrdemInclusao])
					, [IDISInad] = COALESCE(X.[IDISInad], T.[IDISInad])
					, [PremioInad] = COALESCE(X.[PremioInad], T.[PremioInad])
					, [IOFInad] = COALESCE(X.[IOFInad], T.[IOFInad])
					, [PremioInadAtrasado] = COALESCE(X.[PremioInadAtrasado], T.[PremioInadAtrasado])
					, [IOFInadAtrasado] = COALESCE(X.[IOFInadAtrasado], T.[IOFInadAtrasado])
					, [DataAmortizacao] = COALESCE(X.[DataAmortizacao], T.[DataAmortizacao])	
					, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
					, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])		
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]  
			  	, [IDProduto]
                , [PremioMip]
                , [IOFMip]
                , [PremioMipAtrasado]     
				, [IOFMipAtrasado]        
				, [IDISInad]   
				, [PremioInad]            
				, [IOFInad]               
				, [PremioInadAtrasado]    
				, [IOFInadAtrasado]     
				, [DataAmortizacao]    
				, [DataArquivo]			
				, [Arquivo]		
				, [DataInclusao]
				, [NumeroOrdemInclusao]
               )
          VALUES (   
		             X.[IDProposta]
				   , X.[IDProduto]
		  		   , X.[PremioMip]
				   , X.[IOFMip]
				   , X.[PremioMipAtrasado]                
				   , X.[IOFMipAtrasado]                   
				   , X.[IDISInad]              
				   , X.[PremioInad]                       
				   , X.[IOFInad]                          
				   , X.[PremioInadAtrasado]               
				   , X.[IOFInadAtrasado]     
				   , X.[DataAmortizacao]    
				   , X.[DataArquivo]						 
				   , X.[Arquivo]		 
				   , X.[DataInclusao]
				   , X.[NumeroOrdemInclusao]
            ); 											  
     
               
			  -- select * from Dados.FinanceiroExtrato
				  --Extrato
           

    ------------------------------------------------------------------------------------------------------------------
	--INSERIDO PARA FORCAR A ALIMENTACAO DO PRODUTO E DO CONTRATO PARA AS PROPOSTAS "DUPLICADAS"
	-- EGLER 
	-- DATA: 28-10-2014
	------------------------------------------------------------------------------------------------------------------
	;WITH CTE
	AS
	(
	SELECT ID, NumeroProposta, 5134234 IDContrato, 101 IDProduto
	FROM Dados.Proposta PRP
	WHERE  PRP.IDProdutoSIGPF = 42
	AND PRP.NumeroProposta LIKE '02%'
	AND PRP.IDContrato IS NULL
	)
	UPDATE Dados.Proposta SET IDContrato = 5134234, IDProduto = 101
	FROM CTE
	INNER JOIN Dados.Proposta P
	ON CTE.ID = P.ID
	------------------------------------------------------------------------------------------------------------------
                         
---BEGIN TRAN
						 
	;WITH CTE
	AS
	(
		SELECT PRP.ID [IDProposta], PRP.NumeroProposta, PRP.DataProposta, IDAgenciaVenda, PRT.CPFCNPJ, PRP.Valor
		FROM 	
		 dbo.PRESTAMISTA_PREMIO_TEMP PRT
		INNER JOIN Dados.Proposta PRP
		ON PRT.NumeroProposta = PRP.NumeroProposta
		INNER JOIN Dados.Seguradora SGD
		ON SGD.Codigo = PRT.CodigoSeguradora
		AND PRP.IDSeguradora = SGD.ID		
		INNER JOIN Dados.ProdutoSIGPF PG
		ON PG.ID = PRP.IDProdutoSIGPF
		INNER JOIN Dados.PropostaCliente PC
		ON PRP.ID = PC.IDProposta
		WHERE PRP.IDProdutoSIGPF = 42
			AND PRP.NumeroProposta LIKE '02%'  
			--AND PRP.DataArquivo > '2014-01-01'
	)
	,
	CTE1
	AS
	(
	SELECT CASE WHEN RIGHT(CTE.NumeroProposta, 7) = LEFT(RIGHT(C.NumeroPropoSta, 8), 7) 
					AND  LEFT(CTE.NumeroProposta,5) = SUBSTRING(C.NumeroProposta, 4, 5)
			 
					THEN CTE.IDProposta ELSE NULL END IDPropostaOriginal,
			CASE WHEN RIGHT(CTE.NumeroProposta, 7) = LEFT(RIGHT(C.NumeroPropoSta, 8), 7) 
					AND  LEFT(CTE.NumeroProposta,5) = SUBSTRING(C.NumeroProposta, 4, 5)			 
					THEN C.ID ELSE NULL END [IDProposta]
	-- , *
	FROM CTE
	CROSS APPLY (SELECT PRP1.ID, PRP1.NumeroProposta, PRP1.DataProposta
				FROM Dados.Proposta PRP1
				INNER JOIN Dados.PropostaCliente PC1
				ON PRP1.ID = PC1.IDProposta
				AND CTE.IDProposta = PRP1.ID
				WHERE PRP1.IDProdutoSIGPF = PRP1.IDProdutoSIGPF
				--AND CTE.DataProposta = prp1.DataProposta | removido em 28/10/2014 para elevar o número de MATCH
				AND CTE.IDAgenciaVenda = PRP1.IDAgenciaVenda	
				AND CTE.CPFCNPJ = PC1.CPFCNPJ
				AND CTE.Valor = PRP1.Valor			
				) C
	LEFT JOIN Dados.Unidade U
	ON U.ID = CTE.IDAgenciaVenda
	WHERE CTE.NumeroProposta <> c.NumeroProposta
	--ORDER BY c.NumeroProposta 
	)
	UPDATE Dados.Proposta SET IDPropostaM = CTE1.IDPropostaOriginal
	FROM Dados.Proposta P
	INNER JOIN CTE1
	ON CTE1.IDProposta = P.ID
	WHERE P.IDPropostaM IS NULL
	OPTION (MAXDOP 5)


	--SELECT * FROM PRESTAMISTA_PREMIO_TEMP

	/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    ;WITH CTE
	AS
	(
		SELECT PRP1.ID, PRP.DataArquivo--, prp.PremioMipAtrasado, prp.IOFMipAtrasado, prp.PremioInadAtrasado, Prp.PremioInad, prp.PremioMip, prp1.valor
        FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
		INNER JOIN Dados.Proposta PRP1
		ON PRP.NumeroProposta = PRP1.NumeroProposta
		INNER JOIN Dados.Seguradora SGD
		ON SGD.Codigo = PRP.CodigoSeguradora
		AND PRP1.IDSeguradora = SGD.ID
	)
	UPDATE Dados.PropostaSituacao SET LastValue = 0
    --SELECT *
    FROM Dados.PropostaSituacao PS
	INNER JOIN CTE 
	ON CTE.ID = PS.IDProposta 
	WHERE PS.DataInicioSituacao < CTE.DataArquivo	
	  AND PS.LastValue = 1
               
--select *
--FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
--where codigo in (3004077,3001599,3004385)

--select *
--FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
--where codigo in (8672561)

   --------------------------------------------------------------------------------
   ;MERGE INTO Dados.PropostaSituacao T
     USING
	     ( 
		    SELECT *
            FROM
            (
				SELECT 
				   PRP.[Codigo]                                                     
				,  PRP.[ControleVersao]                                             
				,  REPLACE(PRP.[NomeArquivo],'SSIS_','') [Arquivo]                                                
				,  PRP.[DataArquivo]       
				,  PRP.[DataArquivo]  [DataInicioSituacao]                    
				,  PRP1.ID [IDProposta]                    
				,  CASE WHEN PremioMip > 0 and PremioMipAtrasado > 0 THEN 39 -- Situação Desconhecida
					  WHEN PremioMip > 0 and PremioMipAtrasado = 0 THEN 1 -- Emitida
					  WHEN PremioMipAtrasado < 0 and PremioMip = 0 THEN 5 -- Cancelada
					  WHEN PremioMip < 0 THEN 5 -- Cancelada
					  WHEN PremioMipAtrasado > 0 and PremioMip = 0 THEN 37 --Aguardando retorno CS
					  WHEN PremioMip = 0 AND PremioMipAtrasado = 0 AND PremioInad = 0 AND PremioInadAtrasado = 0 THEN 39 
					  WHEN PremioMipAtrasado < 0 and PremioMip <> 0 THEN 26 -- Não pago
				   END IDSituacaoProposta
				, -1 IDMotivo
                , 'FN311B' TipoDado 
				, ROW_NUMBER() OVER(PARTITION BY PRP1.ID, NumeroContrato, PRP.[DataArquivo] ORDER BY PRP.[DataArquivo] DESC, PRP.[Codigo] DESC)  [ORDER]
				FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
				  ON PRP.NumeroProposta = PRP1.NumeroProposta
				 AND PRP.CodigoSeguradora = PRP1.IDSeguradora     
            ) A
            WHERE A.[ORDER] = 1
		--	and idsituacaoproposta is null
	      ) X
    ON  X.IDProposta = T.IDProposta
	AND X.[DataInicioSituacao] = T.[DataInicioSituacao]
    AND X.[IDSituacaoProposta] = T.[IDSituacaoProposta]
    AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
	WHEN MATCHED
			    THEN UPDATE
				     SET [IDMotivo] = COALESCE(X.[IDMotivo],T.[IDMotivo])
					   , [DataArquivo] = X.[DataArquivo]
					   , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDSituacaoProposta] 
             , [DataArquivo], [DataInicioSituacao], [TipoDado]
             , LastValue             )
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDSituacaoProposta]
                 ,X.[DataArquivo]       
                 ,X.[DataInicioSituacao]    
                 ,X.[TipoDado]
                 ,0
                 ); 
    ----------------------------------------------------------------------------------------------------
	WITH CTE 
    AS 
    (
      SELECT DISTINCT PRP1.ID [IDProposta], PRP.DataArquivo DataSituacao
	  FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
		INNER JOIN Dados.Proposta PRP1
		ON PRP.NumeroProposta = PRP1.NumeroProposta
		INNER JOIN Dados.Seguradora SGD
		ON SGD.Codigo = PRP.CodigoSeguradora
		AND PRP1.IDSeguradora = SGD.ID 
    ) 
	
	/*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
    --SELECT *
	FROM  CTE
    CROSS APPLY (
                SELECT TOP 1 ID
                 FROM Dados.PropostaSituacao PS1
                 WHERE PS1.IDProposta =  CTE.IDProposta
                 AND ISNULL(PS1.DataInicioSituacao, '0001-01-01') >= ISNULL(CTE.DataSituacao, '0001-01-01') --Garante que a última situação seja a mais recente
                 ORDER BY [IDProposta] ASC,
	                        [DataInicioSituacao] DESC,
	                        [IDSituacaoProposta] 
                 ) LASTVALUE 
    INNER JOIN Dados.PropostaSituacao PS
    ON PS.ID = LASTVALUE.ID;


	 --##############################################################################
	 /*ATUALIZA A PROPOSTA COM O ÚLTIMO STATUS RECEBIDO
	 Autor: Egler Vieira
	 */   
	 --############################################################################## 
	;WITH CTE
	AS
	(
		SELECT PRP1.ID
		FROM dbo.PRESTAMISTA_PREMIO_TEMP P
		INNER JOIN Dados.Proposta PRP1
		ON P.NumeroProposta = PRP1.NumeroProposta
		INNER JOIN Dados.Seguradora SGD
		ON SGD.Codigo = P.CodigoSeguradora
		AND PRP1.IDSeguradora = SGD.ID 		
	)
	UPDATE Dados.Proposta SET IDSituacaoProposta = PS.IDSituacaoProposta, 
						   DataSituacao = PS.DataInicioSituacao, 
						   IDTipoMotivo = PS.IDMotivo
							   --,DataArquivo = PRP.DataArquivo   
	-- SELECT *
	FROM Dados.Proposta PRP
	INNER JOIN CTE 
	ON CTE.ID = PRP.ID
	INNER JOIN Dados.PropostaSituacao PS
	ON PS.IDProposta = PRP.ID   
	--CROSS APPLY (SELECT TOP 1 * 
	--             FROM Dados.FinanceiroExtrato FE                
	--			 WHERE PS.LastValue = 1
	--			 AND FE.IDProposta = PRP.ID				 
	--			)	F	   				
				
  /*TODO: Neste ponto, inserir os dados de PropostaSeguro*/  



  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'PRESTAMISTA_PREMIO'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRESTAMISTA_PREMIO_TEMP]
  
  /*********************************************************************************************************************/
           
SET @COMANDO =
    N'  INSERT INTO dbo.PRESTAMISTA_PREMIO_TEMP
      (
	     [Codigo],                                                              
		 [ControleVersao],                                                      
		 [NomeArquivo],                                                         
		 [DataArquivo],                                                         
		 [NumeroProduto],                                                       
		 [TipoCredito],                                                         
		 [NumeroProposta],                                                      
		 [NumeroContrato],                                                      
		 [CodigoSubestipulante],                                               
		 [RendaPactuada],                                                      
		 [CodigoESCNEG],                                                       
		 [CodigoPV],                                                           
		 [CodigoUnoNum],                                                       
		 [CodigoUnoDv],                                                        
		 [NomeSegurado],                                                       
		 [DataNascimento],                                                     
		 [CPFCNPJ],                                                            
		 [DataContrato],                                                       
		 [DataInclusao],                                                       
		 [DataAmortizacao],                                                    
		 [PrazoVigencia],                                                      
		 [NumeroOrdemInclusao],                                                
		 [NumeroRI],                                                           
		 [IDISMip],                                                 
		 [ValorFinanciamento],                                                 
		 [PremioMip],                                                          
		 [IOFMip],                                                             
		 [PremioMipAtrasado],                                                  
		 [IOFMipAtrasado],                                                     
		 [IDISInad],                                                
		 [PremioInad],                                                         
		 [IOFInad],                                                            
		 [PremioInadAtrasado],                                                 
		 [IOFInadAtrasado],                                                    
		 [UF],                                                               
		 [Cidade],                                                             
		 [Bairro],                                                             
		 [Logradouro],                                                         
		 [Complemento],                                                        
		 [Numero],                                                             
		 [CEP]
		 )
       SELECT 
	   [Codigo],                                                              
		[ControleVersao],                                                      
		[NomeArquivo],                                                         
		[DataArquivo],                                                         
		[NumeroProduto],                                                       
		[TipoCredito],                                                         
		[NumeroProposta],                                                      
		[NumeroContrato],                                                      
		 [CodigoSubestipulante],                                               
		 [RendaPactuada],                                                      
		 [CodigoESCNEG],                                                       
		 [CodigoPV],                                                           
		 [CodigoUnoNum],                                                       
		 [CodigoUnoDv],                                                        
		 [NomeSegurado],                                                       
		 [DataNascimento],                                                     
		 [CPFCNPJ],                                                            
		 [DataContrato],                                                       
		 [DataInclusao],                                                       
		 [DataAmortizacao],                                                    
		 [PrazoVigencia],                                                      
		 [NumeroOrdemInclusao],                                                
		 [NumeroRI],                                                           
		 [IDISMip],                                                 
		 [ValorFinanciamento],                                                 
		 [PremioMip],                                                          
		 [IOFMip],                                                             
		 [PremioMipAtrasado],                                                  
		 [IOFMipAtrasado],                                                     
		 [IDISInad],                                                
		 [PremioInad],                                                         
		 [IOFInad],                                                            
		 [PremioInadAtrasado],                                                 
		 [IOFInadAtrasado],                                                    
		 [UF],                                                               
		 [Cidade],                                                             
		 [Bairro],                                                             
		 [Logradouro],                                                         
		 [Complemento],                                                        
		 [Numero],                                                             
		 [CEP]               
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaFinanceiroPrestamista_PREMIO] ''''' + @PontoDeParada + ''''', ''' + char(39) + @Produtos + char(39) + ''''' ) PRP
         '
	exec sp_executesql  @tsql  = @COMANDO

   SELECT @MaiorCodigo= MAX(PRP.Codigo)
   FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP    
                    
  /*********************************************************************************************************************/
  
END

-- Enable (rebuild) the columnstore index.
--ALTER INDEX [IDX_CSI_FinanceiroExtrato] ON [Dados].[FinanceiroExtrato] REBUILD;

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_PREMIO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRESTAMISTA_PREMIO_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InserePropostaEExtrato_PRESTAMISTA_PREMIO] 

--rollback



----select  * from DAdos.Proposta p
------inner join dados.propostacliente pc on pc.IDProposta = p.ID
---- where numeroproposta in (select numeroproposta from dbo.PRESTAMISTA_PREMIO_TEMP PRP) and p.ID = 67580889
---- PS0000982000971_
---- PS00009820009710_
-- select * from propostapsm where NumeroPropostatratado like  'PS00%15200005710%'
---- --select  'PS000'+substring(numeroproposta,6,len(numeroproposta)-7)+'_','PS000'+substring(numeroproposta,6,len(numeroproposta)),* from prestamista_premio_temp where numeroproposta = 'PS007098200097104'
-- select PremioMIP+IOFMip,* from prestamista_premio_temp where numeroproposta = 'PS006152000057101'
---- selec

---- select * from dados.proposta where ID = 67318039

--select ps.* ,*

--FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
--				  INNER JOIN Dados.Seguradora SGD
--				  ON SGD.Codigo = PRP.CodigoSeguradora
--				  LEFT OUTER JOIN Dados.Produto PRD
--				  ON PRD.CodigoComercializado = PRP.[NumeroProduto]
--				  --LEFT JOIN Dados.ProdutoDesmembramento PD
--				  --ON PRD.IDProduto = PD.IDProdutoDfi
--				  LEFT JOIN Dados.ProdutoSIGPF SIG
--				  ON SIG.ID = PRD.IDProdutoSIGPF
--				  LEFT OUTER JOIN Dados.PeriodoPagamento PP
--				  ON PP.ID = PRD.IDPeriodoPagamento 
--				  LEFT OUTER JOIN Dados.Unidade U
--				  ON U.Codigo = PRP.CodigoPV
--				LEFT JOIN dbo.PropostaPSM ps on ps.NumeroPropostaTratado like PRP.PropostaUnderline   and (PS.ValorPremioBrutoEmissao = PRP.PremioTotal or ps.CPFCNPJ = PRP.CPFCNPJ)
--				left join Dados.Proposta pp1 on pp1.ID = ps.ID 
--				left join Dados.Proposta pp2 on pp2.NumeroProposta = PRP.NumeroProposta 
--				where prp.numeroproposta = 'PS006152000057101'