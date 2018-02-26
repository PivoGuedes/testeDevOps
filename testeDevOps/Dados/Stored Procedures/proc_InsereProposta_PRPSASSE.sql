 
/*
	Autor: Egler Vieira
	Data Criação: 09/11/2012

	Descrição: 
	
	Última alteração : Gustavo 27/11/2013 -> Inclusão de MERGE para validar as faixas renda
	individual e familiar existentes e inserir as novas.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_PRPSASSE
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_PRPSASSE] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPSASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPSASSE_TEMP];

CREATE TABLE [dbo].[PRPSASSE_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[CPFCNPJ] [varchar](18) NULL,
	[Nome] [varchar](8000) NOT NULL,
	[DataNascimento] [date] NULL,
	[TipoPessoa] [varchar](15) NULL,
	[CodigoSeguradora] [int] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroProdutoSIGPF] [varchar](2) NULL,
	[AgenciaVenda] [varchar](5) NULL,
	[DataProposta] [date] NULL,
	[CodigoFormaPagamento] [char](1) NULL,
	[FormaPagamento] [varchar](17) NULL,
	[AgenciaDebitoConta] [varchar](20) NULL,
	[OperacaoDebitoConta] [varchar](20) NULL,
	[ContaCorrenteDebitoConta] [varchar](20) NULL,
	[MatriculaVendedor] [varchar](20) NULL,
	[ValorPremioTotal] [numeric](16, 2) NULL,
	[DeclaracaoSaudeTitular] [varchar](7) NULL,
	[DeclaracaoSaudeConjuge] [varchar](7) NULL,
	[AposentadoriaInvalidez] [varchar](1) NULL,
	[RenovacaoAutomatica] [varchar](1) NULL,
	[DiaPagamento] [varchar](2) NULL,
	[PercentualDesconto] [numeric](5, 2) NULL,
	[EmpresaConvenente] [varchar](40) NULL,
	[MatriculaConvenente] [varchar](8) NULL,
	[SituacaoProposta] [varchar](3) NULL,
	[SituacaoCobranca] [varchar](3) NULL, /*CRIAR A TABELA DE DOMÍNIO*/
	[MotivoSituacao] [varchar](3) NULL, /*ASSOCIAR COM A TABELA TIPO MOTIVO*/
	[OpcaoCobertura] [varchar](1) NULL,
	[CodigoPlano] [varchar](4) NULL,
	[DataAutenticacaoSICOB] [date] NULL,
	[ValorPagoSICOB] [numeric](15, 2) NULL,
	[AgenciaPagamentoSICOB] [varchar](4) NULL,
	[TarifaCobrancaSICOB] [numeric](15, 2) NULL,
	[DataCreditoSASSESICOB] [date] NULL,
	[ValorComissaoSICOB] [numeric](15, 2) NULL,
	[PeriodicidadePagamento] [varchar](2) NULL,
	[OpcaoConjuge] [varchar](1) NULL,
	[OrigemProposta] [varchar](2) NULL,
	[SequencialArquivo] [varchar](6) NULL,
	[SequencialRegistro] [varchar](6) NULL,
	[Identidade] [varchar](15) NULL,
	[OrgaoExpedidor] [varchar](5) NULL,
	[UFOrgaoExpedidor] [varchar](2) NULL,
	[DataExpedicaoRG] [date] NULL,
	[EstadoCivil] [tinyint] NULL,
	[Sexo] [varchar](9) NULL,
	[DDDComercial] [varchar](3) NULL,
	[TelefoneComercial] [varchar](9) NULL,
	[DDDFax] [varchar](3) NULL,
	[TelefoneFax] [varchar](9) NULL,
	[DDDResidencial] [varchar](3) NULL,
	[TelefoneResidencial] [varchar](9) NULL,
	[Email] [varchar](50) NULL,
	[CodigoProfissao] [varchar](3) NULL,
	[Profissao] [varchar](40) NULL,
	[CodigoSegmento] [varchar](4) NULL,
	[RendaFamiliar] [varchar](2) NULL,
	[RendaIndividual] [varchar](2) NULL,
	[NomeConjuge] [varchar](40) NULL,
	[DataNascimentoConjuge] [date] NULL,
	[ProfissaoConjuge] [varchar](40) NULL,
	[TipoArquivo] [varchar](30) NOT NULL,
	[RANK] [bigint] NULL,
	[TipoEndereco] [smallint] NULL,
	[Endereco] [varchar](80) NULL,
	[Bairro]   [varchar](80) NULL,
	[Cidade]   [varchar](80) NULL,
	[SiglaUF]  [varchar](16) NULL,
	[CEP]      [varchar](9) NULL
);

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PRPSASSE_TEMP_NumeroPropost ON [dbo].[PRPSASSE_TEMP]
( 
	NumeroProposta ASC,
	[DataArquivo] DESC
)

CREATE NONCLUSTERED INDEX idx_PRPSASSE_TEMP_MotivoSituacao ON [dbo].[PRPSASSE_TEMP] 
([MotivoSituacao])


CREATE CLUSTERED INDEX idx_PRPSASSE_TEMP_NumeroPropost_TipoEndereco ON [dbo].[PRPSASSE_TEMP]
( 
	NumeroProposta ASC,
	TipoEndereco ASC,
	Endereco ASC
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PRPSASSE_TEMP_SituacaoProposta ON [dbo].[PRPSASSE_TEMP]
( 
	SituacaoProposta
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PRPSASSE_TEMP_MatriculaVendedor ON [dbo].[PRPSASSE_TEMP]
( 
	MatriculaVendedor
)

CREATE NONCLUSTERED INDEX IDX_PRPSASSE_TEMP_CodigoFormaPagamento ON [dbo].[PRPSASSE_TEMP]
(
	CodigoFormaPagamento
)

CREATE NONCLUSTERED INDEX IDX_PRPSASSE_TEMP_RendaIndividual	ON [dbo].[PRPSASSE_TEMP] 
(
	[RendaIndividual]
)


CREATE NONCLUSTERED INDEX IDX_PRPSASSE_TEMP_RendaFamiliar ON [dbo].[PRPSASSE_TEMP] 
(
	[RendaFamiliar]
)

CREATE NONCLUSTERED INDEX IDX_PRPSASSE_TEMP_AgenciaVenda ON [dbo].[PRPSASSE_TEMP] 
(
	[AgenciaVenda]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_PRPSASSE'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.PRPSASSE_TEMP
       ( [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[CPFCNPJ],[Nome],[DataNascimento]
        ,[TipoPessoa],[CodigoSeguradora],[NumeroProposta],[NumeroProdutoSIGPF],[AgenciaVenda]
        ,[DataProposta],[CodigoFormaPagamento],[FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta]
        ,[ContaCorrenteDebitoConta],[MatriculaVendedor],[ValorPremioTotal],[DeclaracaoSaudeTitular]
        ,[DeclaracaoSaudeConjuge],[AposentadoriaInvalidez],[RenovacaoAutomatica],[DiaPagamento]
        ,[PercentualDesconto],[EmpresaConvenente],[MatriculaConvenente],[SituacaoProposta]
        ,[SituacaoCobranca],[MotivoSituacao],[OpcaoCobertura],[CodigoPlano],[DataAutenticacaoSICOB]
        ,[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[DataCreditoSASSESICOB]
        ,[ValorComissaoSICOB],[PeriodicidadePagamento],[OpcaoConjuge],[OrigemProposta],[SequencialArquivo]
        ,[SequencialRegistro],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
        ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
        ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
        ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoArquivo],[RANK]
		,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
		)
       SELECT  [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[CPFCNPJ],[Nome],[DataNascimento]
              ,[TipoPessoa],[CodigoSeguradora],[NumeroProposta],[NumeroProdutoSIGPF],[AgenciaVenda]
              ,[DataProposta],[CodigoFormaPagamento],[FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta]
              ,[ContaCorrenteDebitoConta],[MatriculaVendedor],[ValorPremioTotal],[DeclaracaoSaudeTitular]
              ,[DeclaracaoSaudeConjuge],[AposentadoriaInvalidez],[RenovacaoAutomatica],[DiaPagamento]
              ,[PercentualDesconto],[EmpresaConvenente],[MatriculaConvenente],[SituacaoProposta]
              ,[SituacaoCobranca],[MotivoSituacao],[OpcaoCobertura],[CodigoPlano],[DataAutenticacaoSICOB]
              ,[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[DataCreditoSASSESICOB]
              ,[ValorComissaoSICOB],[PeriodicidadePagamento],[OpcaoConjuge],[OrigemProposta],[SequencialArquivo]
              ,[SequencialRegistro],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
              ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
              ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
              ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoArquivo],[RANK]
			  ,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPSASSE]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRPSASSE_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo


     /**********************************************************************
       Carrega os PRODUTOS SIGPF desconhecidos
     ***********************************************************************/             
      ;MERGE INTO Dados.ProdutoSIGPF AS T
	      USING (SELECT DISTINCT PRP.[NumeroProdutoSIGPF] [CodigoProduto], '' [Descricao]
               FROM dbo.[PRPSASSE_TEMP] PRP
              ) X
         ON T.CodigoProduto = X.CodigoProduto 
       WHEN NOT MATCHED
		          THEN INSERT (CodigoProduto, Descricao)
		               VALUES (X.[CodigoProduto], X.[Descricao]);
     /********************************************************************/   
     
     /***********************************************************************
       Carregar as SITUAÇÕES de proposta desconhecidas
     ***********************************************************************/
      ;MERGE INTO Dados.SituacaoProposta AS T
	      USING (SELECT DISTINCT PRP.SituacaoProposta [Sigla], '' [Descricao]
               FROM dbo.[PRPSASSE_TEMP] PRP
               WHERE PRP.SituacaoProposta IS NOT NULL
              ) X
         ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.[Descricao]);
     /***********************************************************************/
                 
     /***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
     ***********************************************************************/
     ;MERGE INTO Dados.Funcionario AS T
	     USING (           
              SELECT DISTINCT PRP.[MatriculaVendedor] [Matricula], 1 [IDEmpresa] -- Caixa Econômica                
              FROM dbo.PRPSASSE_TEMP PRP 
              WHERE PRP.[MatriculaVendedor] IS NOT NULL
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.IDEmpresa = X.[IDEmpresa]
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], IDEmpresa);  
					   									  	
	 /***********************************************************************              
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
     ***********************************************************************/
	 MERGE INTO  Dados.TipoMotivo AS T
       USING (SELECT DISTINCT [MotivoSituacao] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM PRPSASSE_TEMP PGTO 
          WHERE PGTO.[MotivoSituacao] IS NOT NULL     
            ) X
       ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]);     


	/***********************************************************************
		   Carrega tabela FaixaRenda não inseridas (RendaIndividual)
	***********************************************************************/
	  ;MERGE INTO Dados.FaixaRenda AS T
			 USING (           
				  SELECT DISTINCT PRP.[RendaIndividual]                
				  FROM dbo.[PRPSASSE_TEMP] PRP 
				  WHERE PRP.[RendaIndividual] IS NOT NULL
				  ) X
		   ON T.[ID] = X.[RendaIndividual] 
		   WHEN NOT MATCHED
					  THEN INSERT ([ID])
						   VALUES (X.[RendaIndividual]);  


	/***********************************************************************
		   Carrega tabela FaixaRenda não inseridas (RendaFamiliar)
	***********************************************************************/
	  ;MERGE INTO Dados.FaixaRenda AS T
			 USING (           
				  SELECT DISTINCT PRP.[RendaFamiliar]                
				  FROM dbo.[PRPSASSE_TEMP] PRP 
				  WHERE PRP.[RendaFamiliar] IS NOT NULL
				  ) X
		   ON T.[ID] = X.[RendaFamiliar] 
		   WHEN NOT MATCHED
					  THEN INSERT ([ID])
						   VALUES (X.[RendaFamiliar]); 

	/***********************************************************************
		   Carregar as agencias desconhecidas
	***********************************************************************/

	/*INSERE PVs NÃO LOCALIZADOS*/
	;INSERT INTO Dados.Unidade(Codigo)

	SELECT DISTINCT CAD.AgenciaVenda
	FROM dbo.[PRPSASSE_TEMP] CAD
	WHERE  CAD.AgenciaVenda IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.AgenciaVenda)                                                                        

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'PRPSASSE' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					'PRPSASSE' [Arquivo]

	FROM dbo.[PRPSASSE_TEMP] EM
	INNER JOIN Dados.Unidade U
	ON EM.AgenciaVenda = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 
        
		           
     /***********************************************************************
       Carrega os dados da Proposta
     ***********************************************************************/             
    ;MERGE INTO Dados.Proposta AS T
		USING (
        SELECT DISTINCT 
		       PRP.NumeroProposta, SGD.ID [IDSeguradora], PRD.ID [IDProdutoSIGPF], pp.ID [IDPeriodicidadePagamento]
             , PRP.DataProposta, F.ID [IDFuncionario],  PRP.ValorPagoSICOB
             , PRP.RendaIndividual, PRP.RendaFamiliar, U.ID [IDAgenciaVenda]
             , SP.ID [IDSituacaoProposta], PRP.DataArquivo, PRP.[TipoArquivo] TipoDado, PRP.Codigo

             , PRP.[ValorPremioTotal], PRP.[RenovacaoAutomatica], PRP.[PercentualDesconto]
             , PRP.[EmpresaConvenente], PRP.[MatriculaConvenente], SB.ID [IDSituacaoCobranca]
             , TM.ID [IDTipoMotivo], PRP.[OpcaoCobertura], PRP.[CodigoPlano], PRP.[DataAutenticacaoSICOB]
             , PRP.[AgenciaPagamentoSICOB], PRP.[TarifaCobrancaSICOB], PRP.[DataCreditoSASSESICOB]
             , PRP.[ValorComissaoSICOB], PRP.[PeriodicidadePagamento], PRP.[OpcaoConjuge]
             , PRP.[OrigemProposta], PRP.[DeclaracaoSaudeTitular], PRP.[DeclaracaoSaudeConjuge]
             , PRP.[AposentadoriaInvalidez], PRP.[CodigoSegmento]             
        FROM dbo.PRPSASSE_TEMP PRP
          INNER JOIN Dados.Seguradora SGD
          ON SGD.Codigo = PRP.CodigoSeguradora
          LEFT OUTER JOIN Dados.ProdutoSIGPF PRD
          ON PRD.CodigoProduto= PRP.NumeroProdutoSIGPF
          LEFT OUTER JOIN Dados.PeriodoPagamento PP
          ON PP.Codigo = PRP.PeriodicidadePagamento 
          LEFT OUTER JOIN Dados.Unidade U
          ON U.Codigo = PRP.AgenciaVenda
          LEFT OUTER JOIN Dados.SituacaoProposta SP
          ON SP.Sigla = PRP.SituacaoProposta
          LEFT OUTER JOIN Dados.TipoMotivo TM
          ON TM.Codigo = PRP.MotivoSituacao
          LEFT OUTER JOIN Dados.SituacaoCobranca SB
          ON SB.Sigla = PRP.SituacaoCobranca
          LEFT OUTER JOIN Dados.Funcionario F
          ON F.[Matricula] = PRP.[MatriculaVendedor]
		  AND F.IDEmpresa = 1
        WHERE [RANK] = 1
          ) AS X
    ON X.NumeroProposta = T.NumeroProposta  
   AND X.IDSeguradora = T.IDSeguradora
    WHEN MATCHED
			    THEN UPDATE
				     SET IDPeriodicidadePagamento = COALESCE(T.[IDPeriodicidadePagamento], X.[IDPeriodicidadePagamento])
               , DataProposta = COALESCE(T.[DataProposta], X.[DataProposta])
               , IDFuncionario = COALESCE(X.[IDFuncionario], T.[IDFuncionario])
               , Valor = COALESCE(X.[ValorPagoSICOB], T.[Valor])
               --, IDUnidade = COALESCE(X.[IDUnidade], T.[IDUnidade])
               , RendaIndividual = COALESCE(X.[RendaIndividual], T.[RendaIndividual])
               , RendaFamiliar = COALESCE(X.[RendaFamiliar], T.[RendaFamiliar])
               , IDAgenciaVenda = COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda])
               , IDSituacaoProposta = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])	
               , IDProdutoSIGPF =  COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF])
               , DataSituacao = COALESCE(X.DataArquivo, T.DataSituacao)                    
               
               ,[ValorPremioTotal]  =  COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
               ,[RenovacaoAutomatica]  =  COALESCE(X.[RenovacaoAutomatica], T.[RenovacaoAutomatica])
               ,[PercentualDesconto]  =  COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
               ,[EmpresaConvenente]  =  COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente])
               ,[MatriculaConvenente]  =  COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente])
               ,[IDSituacaoCobranca]  =  COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
               ,[IDTipoMotivo]  =  COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo])
               ,[OpcaoCobertura]  =  COALESCE(X.[OpcaoCobertura], T.[OpcaoCobertura])
               ,[CodigoPlano]  =  COALESCE(X.[CodigoPlano], T.[CodigoPlano])
               ,[DataAutenticacaoSICOB]  =  COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB])
               ,[AgenciaPagamentoSICOB]  =  COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB])
               ,[TarifaCobrancaSICOB]  =  COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB])
               ,[DataCreditoSASSESICOB]  =  COALESCE(X.[DataCreditoSASSESICOB], T.[DataCreditoSASSESICOB])
               ,[ValorComissaoSICOB]  =  COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB])
               ,[PeriodicidadePagamento]  =  COALESCE(X.[PeriodicidadePagamento], T.[PeriodicidadePagamento])
               ,[OpcaoConjuge]  =  COALESCE(X.[OpcaoConjuge], T.[OpcaoConjuge])
               ,[OrigemProposta]  =  COALESCE(X.[OrigemProposta], T.[OrigemProposta])
               ,[DeclaracaoSaudeTitular]  =  COALESCE(X.[DeclaracaoSaudeTitular], T.[DeclaracaoSaudeTitular])
               ,[DeclaracaoSaudeConjuge]  =  COALESCE(X.[DeclaracaoSaudeConjuge], T.[DeclaracaoSaudeConjuge])
               ,[AposentadoriaInvalidez]  =  COALESCE(X.[AposentadoriaInvalidez], T.[AposentadoriaInvalidez])
               ,[CodigoSegmento]  =  COALESCE(X.[CodigoSegmento], T.[CodigoSegmento])
    WHEN NOT MATCHED
			    THEN INSERT          
              (NumeroProposta, IDSeguradora, IDProduto, IDProdutoSIGPF, IDPeriodicidadePagamento
             , DataProposta, IDFuncionario, Valor--, IDUnidade
             , RendaIndividual, RendaFamiliar, IDAgenciaVenda
             , IDSituacaoProposta, TipoDado, DataArquivo 
             , DataSituacao
             , [ValorPremioTotal], [RenovacaoAutomatica], [PercentualDesconto] 
             , [EmpresaConvenente], [MatriculaConvenente], [IDSituacaoCobranca]
             , [IDTipoMotivo], [OpcaoCobertura], [CodigoPlano], [DataAutenticacaoSICOB]
             , [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB], [DataCreditoSASSESICOB]
             , [ValorComissaoSICOB], [PeriodicidadePagamento], [OpcaoConjuge], [OrigemProposta]
             , [DeclaracaoSaudeTitular], [DeclaracaoSaudeConjuge], [AposentadoriaInvalidez]
             , [CodigoSegmento]             
             )
          VALUES (X.[NumeroProposta]
                 ,X.[IDSeguradora]
				 ,-1--Produto
                 ,X.[IDProdutoSIGPF]
                 ,X.[IDPeriodicidadePagamento]
                 ,X.[DataProposta]
                 ,X.[IDFuncionario]
                 ,X.[ValorPagoSICOB]
                 --,X.[IDUnidade]
                 ,X.RendaIndividual
                 ,X.[RendaFamiliar]
                 ,X.[IDAgenciaVenda]
                 ,X.[IDSituacaoProposta]
                 ,X.[TipoDado]
                 ,X.[DataArquivo]                     
                 ,X.[DataArquivo] --Data da situação
                 ,X.[ValorPremioTotal]
                 ,X.[RenovacaoAutomatica]
                 ,X.[PercentualDesconto]
                 ,X.[EmpresaConvenente]
                 ,X.[MatriculaConvenente]
                 ,X.[IDSituacaoCobranca]
                 ,X.[IDTipoMotivo]
                 ,X.[OpcaoCobertura]
                 ,X.[CodigoPlano]
                 ,X.[DataAutenticacaoSICOB]
                 ,X.[AgenciaPagamentoSICOB]
                 ,X.[TarifaCobrancaSICOB]
                 ,X.[DataCreditoSASSESICOB]
                 ,X.[ValorComissaoSICOB]
                 ,X.[PeriodicidadePagamento]
                 ,X.[OpcaoConjuge]
                 ,X.[OrigemProposta]
                 ,X.[DeclaracaoSaudeTitular]
                 ,X.[DeclaracaoSaudeConjuge]
                 ,X.[AposentadoriaInvalidez]
                 ,X.[CodigoSegmento]
                 );    
  
                 
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
        SELECT  DISTINCT
		          PRP1.ID [IDProposta]
                 ,PRP.CPFCNPJ           
                 ,PRP.Nome              
                 ,PRP.DataNascimento    
                 ,PRP.TipoPessoa        
                 ,PRP.Sexo [IDSexo]              
                 ,PRP.EstadoCivil [IDEstadoCivil]       
                 ,PRP.Identidade        
                 ,PRP.OrgaoExpedidor    
                 ,PRP.UFOrgaoExpedidor  
                 ,PRP.DataExpedicaoRG   
                 ,PRP.DDDComercial      
                 ,PRP.TelefoneComercial 
                 ,PRP.DDDFax            
                 ,PRP.TelefoneFax       
                 ,PRP.DDDResidencial    
                 ,PRP.TelefoneResidencial
                 ,PRP.Email             
                 ,PRP.CodigoProfissao   
                 ,PRP.Profissao         
                 ,PRP.NomeConjuge       
                 ,PRP.ProfissaoConjuge                   
                 ,PRP.TipoArquivo [TipoDado]           
                 ,PRP.DataArquivo
        FROM dbo.PRPSASSE_TEMP PRP
          INNER JOIN Dados.Proposta PRP1
          ON PRP.NumeroProposta = PRP1.NumeroProposta
         AND PRP.CodigoSeguradora = PRP1.IDSeguradora
        WHERE [RANK] = 1 --and PRP1.ID = 65129294
          ) AS X
    ON X.IDProposta = T.IDProposta
       WHEN MATCHED
			    THEN UPDATE
				     SET CPFCNPJ = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
               , Nome = COALESCE(X.[Nome], T.[Nome])
               , DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento])
               , TipoPessoa  = COALESCE(X.[TipoPessoa ], T.[TipoPessoa])
               , IDSexo = COALESCE(X.[IDSexo], T.[IDSexo])
               , IDEstadoCivil = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil])
               , Identidade = COALESCE(X.[Identidade], T.[Identidade])
               , OrgaoExpedidor = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor])
               , UFOrgaoExpedidor = COALESCE(X.[UFOrgaoExpedidor], T.[UFOrgaoExpedidor])
               , DataExpedicaoRG = COALESCE(X.[DataExpedicaoRG], T.[DataExpedicaoRG])
               , DDDComercial = COALESCE(X.[DDDComercial], T.[DDDComercial])
               , TelefoneComercial = COALESCE(X.[TelefoneComercial], T.[TelefoneComercial])
               , DDDFax = COALESCE(X.[DDDFax], T.[DDDFax])
               , TelefoneFax  = COALESCE(X.[TelefoneFax ], T.[TelefoneFax])
               , DDDResidencial = COALESCE(X.[DDDResidencial], T.[DDDResidencial])
               , TelefoneResidencial = COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial])
               , Email = COALESCE(X.[Email], T.[Email])
               , CodigoProfissao = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao])
               , Profissao = COALESCE(X.[Profissao], T.[Profissao])
               , NomeConjuge = COALESCE(X.[NomeConjuge], T.[NomeConjuge])
               , ProfissaoConjuge = COALESCE(X.[ProfissaoConjuge], T.[ProfissaoConjuge])
               --, Profissao = COALESCE(X.[Profissao], T.[Profissao])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])	
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, CPFCNPJ, Nome, DataNascimento, TipoPessoa        
              , IDSexo, IDEstadoCivil, Identidade, OrgaoExpedidor, UFOrgaoExpedidor  
              , DataExpedicaoRG, DDDComercial, TelefoneComercial 
              , DDDFax, TelefoneFax, DDDResidencial, TelefoneResidencial
              , Email, CodigoProfissao, Profissao, NomeConjuge, ProfissaoConjuge                   
              , TipoDado, DataArquivo)
          VALUES (X.IDProposta        
                 ,X.CPFCNPJ           
                 ,X.Nome              
                 ,X.DataNascimento    
                 ,X.TipoPessoa        
                 ,X.IDSexo              
                 ,X.IDEstadoCivil       
                 ,X.Identidade        
                 ,X.OrgaoExpedidor    
                 ,X.UFOrgaoExpedidor  
                 ,X.DataExpedicaoRG   
                 ,X.DDDComercial      
                 ,X.TelefoneComercial 
                 ,X.DDDFax            
                 ,X.TelefoneFax       
                 ,X.DDDResidencial    
                 ,X.TelefoneResidencial
                 ,X.Email             
                 ,X.CodigoProfissao   
                 ,X.Profissao         
                 ,X.NomeConjuge       
                 ,X.ProfissaoConjuge                   
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
	                        SELECT PRP.ID
                            FROM dbo.PRPSASSE_TEMP PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							 WHERE [Rank] = 1
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
					,A.Endereco        
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
					,ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco, Endereco ORDER BY A.DataArquivo DESC) NUMERADOR

				FROM
				(
					SELECT   
							PRP.ID [IDProposta]
						,TipoEndereco [IDTipoEndereco]
						,PRP_T.Endereco        
						,MAX(PRP_T.Bairro) Bairro             
						,MAX(PRP_T.Cidade) Cidade       
						,MAX(PRP_T.SiglaUF)  [UF]      
						,MAX(PRP_T.CEP) CEP   
						--CASE WHEN  
						,'TIPO - 2' [TipoDado]           
						,MAX(PRP_T.DataArquivo) DataArquivo	   								
					FROM dbo.PRPSASSE_TEMP PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
						AND PRP.IDSeguradora = 1
					WHERE  [RANK] = 1--PRP_T.NumeroProposta = 012984710001812
					and PRP_T.Endereco IS NOT NULL
					and PRP_T.TIPOENDERECO <> 0
					-- AND PRP.ID = 12585836
					GROUP BY PRP.ID 
							,PRP_T.TipoEndereco 
							,PRP_T.Endereco        
	
				) A 				

          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
	AND NUMERADOR = 1 --Garante uma única ocorrência do mesmo endereço.
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
	/*Egler - Data: 23/09/2013 */		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM dbo.PRPSASSE_TEMP PRP_T
										  INNER JOIN Dados.Proposta PRP
										  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
										 AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1				  

/*
ATUALIZAÇÃO DE PROPOSTAS QUE FICARAM SEM LASTVALUE MARCADO NA PRIMEIRA CARGA
UPDATE DADOS.PROPOSTAENDERECO SET LastValue	= 1
WHERE ID IN(

SELECT MAX(ID)
FROM DADOS.PROPOSTAENDERECO
WHERE IDPROPOSTA IN
(

SELECT IDPROPOSTA
FROM DADOS.PROPOSTAENDERECO	P0
WHERE LASTVALUE = 0
AND NOT EXISTS (
				SELECT  *
				FROM DADOS.PROPOSTAENDERECO	P1
				WHERE LASTVALUE = 1
				AND P0.IDPROPOSTA = P1.IDPROPOSTA
				)
GROUP BY IDPROPOSTA


)
group by IDProposta

 )

*/


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Formas de pagamento não existentes
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.FormaPagamento AS T
	      USING (SELECT DISTINCT PRP.CodigoFormaPagamento [IDFormaPagamento], '' Descricao
            FROM dbo.PRPSASSE_TEMP PRP
            WHERE PRP.CodigoFormaPagamento IS NOT NULL
              ) X
        ON T.ID = X.[IDFormaPagamento]
       WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.[IDFormaPagamento], X.[Descricao]);
		-----------------------------------------------------------------------------------------------------------------------               
		                 

    /***********************************************************************
       Carrega os dados da Forma de Pagamento da Proposta
    ***********************************************************************/          	         
    MERGE INTO Dados.MeioPagamento AS T
	    USING (
		    SELECT *
		    FROM
		    (
          SELECT DISTINCT
              P.ID [IDProposta], PRP.DataArquivo, PRP.NomeArquivo Arquivo
            , /*PRP.[FormaPagamento],*/ PRP.[CodigoFormaPagamento] [IDFormaPagamento], '104' [Banco]
            , PRP.[AgenciaDebitoConta] [Agencia], PRP.[OperacaoDebitoConta] [Operacao]
            , PRP.[ContaCorrenteDebitoConta] [ContaCorrente], PRP.[DiaPagamento] [DiaVencimento] 
            , ROW_NUMBER() OVER(PARTITION BY PRP.[NumeroProposta] ORDER BY PRP.DataArquivo DESC, PRP.NomeArquivo DESC) [ORDER]
          FROM dbo.PRPSASSE_TEMP PRP
          INNER JOIN Dados.Proposta P
          ON P.NumeroProposta = PRP.[NumeroProposta]
		  AND P.IDSeguradora = PRP.CodigoSeguradora 
          /*INNER JOIN Dados.FormaPagamento FP
          ON FP.ID = PRP.[CodigoFormaPagamento]*/  
        ) A
        WHERE A.[ORDER] = 1
		    ) AS O
	    ON 
		      T.[IDProposta] = O.[IDProposta]
		  AND T.[DataArquivo] = O.[DataArquivo]
		  AND ISNULL(T.IDFormaPagamento,0) = ISNULL(O.[IDFormaPagamento], 0)
		  AND ISNULL(T.Banco,0) = ISNULL(O.Banco, 0)
		  AND ISNULL(T.[Agencia],0) = ISNULL(O.[Agencia], 0)
		  AND ISNULL(T.[Operacao],0) = ISNULL(O.[Operacao], 0)
		  AND ISNULL(T.[ContaCorrente],0) = ISNULL(O.[ContaCorrente], 0)
		  AND ISNULL(T.DiaVencimento,0) = ISNULL(O.DiaVencimento, 0)
	    WHEN MATCHED AND (T.LastValue = 1)
		    THEN UPDATE 
			    SET   
				  T.DataArquivo = O.DataArquivo
			   --T.Operacao = COALESCE(O.Operacao, T.Operacao)
      --       , T.[Agencia] = COALESCE(O.[Agencia], T.[Agencia])
      --       , T.[ContaCorrente] = COALESCE(O.[ContaCorrente], T.[ContaCorrente])
      --       , T.[Banco] = COALESCE(O.[Banco], T.[Banco])
      --       , T.[IDFormaPagamento] = COALESCE(O.[IDFormaPagamento], T.[IDFormaPagamento])
      --       , T.[DiaVencimento] = COALESCE(O.[DiaVencimento], T.[DiaVencimento])
		        
	    WHEN NOT MATCHED
		    THEN INSERT ([IDProposta], [DataArquivo], [Banco], [Agencia], [Operacao], [ContaCorrente], [IDFormaPagamento], [DiaVencimento])
			    VALUES (O.[IDProposta], O.[DataArquivo], O.[Banco], O.[Agencia], O.[Operacao], O.[ContaCorrente], O.[IDFormaPagamento], O.[DiaVencimento]);
	--	select count(*) from dados.meiopagamento
	--  25349153
	
	
	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 17/12/2013 */
    UPDATE Dados.MeioPagamento SET LastValue = 0
   -- SELECT *
    FROM Dados.MeioPagamento MP
    WHERE MP.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.PRPSASSE_TEMP PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND MP.LastValue = 1;	 
			  	
	--/*Limpa os meios de pagamento repetidos*/
	--/*Egler - Data: 17/12/2013 */	
	--DELETE  Dados.MeioPagamento
	--select *
	--FROM  Dados.MeioPagamento b
	--cross apply
	--(
	--	SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.IDFormaPagamento, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
	--	FROM Dados.MeioPagamento PGTO
	--	WHERE b.IDProposta = PGTO.IDProposta
	--) A
	--WHERE 
	--A.ID = B.ID and
	--   A.ordem > 1	
	-- --  OPTION (MAXDOP  8) 
	

	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 17/12/2013 */		 
    UPDATE Dados.MeioPagamento SET LastValue = 1
    FROM Dados.MeioPagamento MP
	CROSS APPLY(
				SELECT TOP 1 *
				FROM Dados.MeioPagamento MP1
				WHERE 
				  MP.IDProposta = MP1.IDProposta
				ORDER BY MP1.IDProposta DESC, MP1.DataArquivo DESC
			   ) A
	 WHERE MP.ID = A.ID 
	   AND EXISTS (SELECT  PRP.ID [IDProposta]
					FROM dbo.PRPSASSE_TEMP PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
						AND PRP.IDSeguradora = 1
						AND MP.IDProposta = PRP.ID
				  )

			 
	/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaSituacao SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaSituacao PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN dbo.PRPSASSE_TEMP PGTO
                                   ON PGTO.NumeroProposta = PRP.NumeroProposta
                                  AND PGTO.CodigoSeguradora = PRP.IDSeguradora  
                                  --AND PS.DataInicioSituacao < PGTO.DataArquivo
                            --WHERE PRP.ID = PS.IDProposta
                            )
      AND PS.LastValue = 1	            


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Status recebidos no arquivo STASASSE - TIPO - 1
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PropostaSituacao AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], TM.ID [IDMotivo], STPRP.ID [IDSituacaoProposta]
             , PGTO.DataArquivo [DataInicioSituacao], MAX(PGTO.DataArquivo) DataArquivo
             , 'TIPO - 3' TipoDado --, PGTO.[Codigo]
        FROM [dbo].PRPSASSE_TEMP PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroProposta = PRP.NumeroProposta
          AND PGTO.CodigoSeguradora = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          INNER JOIN Dados.TipoMotivo TM
          ON PGTO.MotivoSituacao = TM.Codigo
          INNER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla          
--WHERE PRP.ID =         9027754 /*TODO - FAZER UM PIVOT E ALIMENTAR MAIS UMA COLUNA DE MOTIVO QUANDO FOR NO MESMO DIA*/
        GROUP BY PRP.ID, TM.ID, STPRP.ID
               , PGTO.DataArquivo	   
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
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
                 

    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
   -- SELECT *
	FROM Dados.PropostaSituacao	PS
	INNER JOIN 
			(SELECT  PS1.ID, ROW_NUMBER() OVER (PARTITION BY PS1.IDProposta ORDER BY PS1.DataInicioSituacao DESC, PS1.ID DESC) ORDEM
                 FROM Dados.PropostaSituacao PS1
				 INNER JOIN Dados.Proposta PRP
				 ON PS1.IDProposta = PRP.ID                      
				 INNER JOIN dbo.PRPSASSE_TEMP PGTO
				 ON PGTO.NumeroProposta = PRP.NumeroProposta
                 AND PGTO.CodigoSeguradora = PRP.IDSeguradora  
             ) A  
	 ON A.ID = PS.ID 
	 AND A.ORDEM = 1	
                        
						
         	               	
	 --##############################################################################
	 /*ATUALIZA A PROPOSTA COM O ÚLTIMO STATUS RECEBIDO
	 Autor: Egler Vieira
	 Data: 2013-10-28*/   
	 --############################################################################## 
	 UPDATE Dados.Proposta SET IDSituacaoProposta = PS.IDSituacaoProposta, 
							   DataSituacao = PS.DataInicioSituacao, 
							   IDTipoMotivo = PS.IDMotivo
							   --,DataArquivo = PRP.DataArquivo   
	 --SELECT *
	 FROM Dados.Proposta PRP
	 INNER JOIN Dados.PropostaSituacao PS
	 ON PS.IDProposta = PRP.ID                      
	 WHERE PS.LastValue = 1
	 AND EXISTS (SELECT *
	             FROM dbo.PRPSASSE_TEMP PGTO
                 WHERE PGTO.NumeroProposta = PRP.NumeroProposta
                   AND PGTO.CodigoSeguradora = PRP.IDSeguradora)  
    --##############################################################################               
	                                
                         
  /*TODO: Neste ponto, inserir os dados de PropostaSeguro*/
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_PRPSASSE'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRPSASSE_TEMP]
  
  /*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.PRPSASSE_TEMP
       ( [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[CPFCNPJ],[Nome],[DataNascimento]
        ,[TipoPessoa],[CodigoSeguradora],[NumeroProposta],[NumeroProdutoSIGPF],[AgenciaVenda]
        ,[DataProposta],[CodigoFormaPagamento],[FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta]
        ,[ContaCorrenteDebitoConta],[MatriculaVendedor],[ValorPremioTotal],[DeclaracaoSaudeTitular]
        ,[DeclaracaoSaudeConjuge],[AposentadoriaInvalidez],[RenovacaoAutomatica],[DiaPagamento]
        ,[PercentualDesconto],[EmpresaConvenente],[MatriculaConvenente],[SituacaoProposta]
        ,[SituacaoCobranca],[MotivoSituacao],[OpcaoCobertura],[CodigoPlano],[DataAutenticacaoSICOB]
        ,[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[DataCreditoSASSESICOB]
        ,[ValorComissaoSICOB],[PeriodicidadePagamento],[OpcaoConjuge],[OrigemProposta],[SequencialArquivo]
        ,[SequencialRegistro],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
        ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
        ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
        ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoArquivo],[RANK]
		,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]   
		)
       SELECT  [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[CPFCNPJ],[Nome],[DataNascimento]
              ,[TipoPessoa],[CodigoSeguradora],[NumeroProposta],[NumeroProdutoSIGPF],[AgenciaVenda]
              ,[DataProposta],[CodigoFormaPagamento],[FormaPagamento],[AgenciaDebitoConta],[OperacaoDebitoConta]
              ,[ContaCorrenteDebitoConta],[MatriculaVendedor],[ValorPremioTotal],[DeclaracaoSaudeTitular]
              ,[DeclaracaoSaudeConjuge],[AposentadoriaInvalidez],[RenovacaoAutomatica],[DiaPagamento]
              ,[PercentualDesconto],[EmpresaConvenente],[MatriculaConvenente],[SituacaoProposta]
              ,[SituacaoCobranca],[MotivoSituacao],[OpcaoCobertura],[CodigoPlano],[DataAutenticacaoSICOB]
              ,[ValorPagoSICOB],[AgenciaPagamentoSICOB],[TarifaCobrancaSICOB],[DataCreditoSASSESICOB]
              ,[ValorComissaoSICOB],[PeriodicidadePagamento],[OpcaoConjuge],[OrigemProposta],[SequencialArquivo]
              ,[SequencialRegistro],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
              ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
              ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
              ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge],[TipoArquivo],[RANK]
			  ,[TipoEndereco], [Endereco], [Bairro], [Cidade], [SiglaUF], [CEP]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPSASSE] ''''' + @PontoDeParada + ''''''') PRP
         '
  EXEC (@COMANDO)
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PRPSASSE_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPSASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPSASSE_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereProposta_PRPSASSE] 

