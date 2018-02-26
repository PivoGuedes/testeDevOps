
/*
	Autor: Egler Vieira
	Data Criação: 09/11/2012

	Descrição: 
	
	Última alteração : Gustavo 27/11/2013 -> Inclusão de MERGE para validar as faixas renda
	individual e familiar existentes.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_PRPFPREV
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_PRPFPREV] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPFPREV_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPFPREV_TEMP];

CREATE TABLE [dbo].[PRPFPREV_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](100) NULL,
	[DataArquivo] [date] NULL,
	[CPFCNPJ] [varchar](18) NULL,
	[Nome] [varchar](140) NULL,
	[DataNascimento] [date] NULL,
	[TipoPessoa] [varchar](15) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado] as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[CodigoSeguradora] [varchar](6) DEFAULT('4'),
	[NumeroProdutoSIGPF] [char](2) NULL,
	[AgenciaVenda] [varchar](5) NULL,
	[TipoAposentadoria] [smallint] NULL,
	[DataProposta] [date] NULL,
	[CodigoFormaPagamento] [tinyint] NULL,
	[FormaPagamento] [varchar](17) NULL,
	[AgenciaDebitoConta] [varchar](20) NULL,
	[OperacaoDebitoConta] [varchar](20) NULL,
	[ContaCorrenteDebitoConta] [varchar](20) NULL,
	[MatriculaVendedor] [varchar](20) NULL,
	[PrazoPercepcao] [tinyint] NULL,
	[PrazoDiferimento] [tinyint] NULL,
	[TipoContribuicao] [char](1) NULL,
	[DiaVencimento] [varchar] (2) NULL,
	[IndicadorSimulacao] [varchar](1) NULL,
	[ValorContribuicao] [decimal](19, 2) NULL,
	[ValorReservaInicial] [decimal](19, 2) NULL,
	[NumeroPropostaEmpresarial] [varchar](20) NULL,
	[PercentualDesconto] [decimal](5, 2) NULL,
	[EmpresaConvenente] [varchar](100) NULL,
	[CNPJEmpresaConvenente] [char](18) NULL,
	[MatriculaConvenente] [varchar](20) NULL,
	[SituacaoProposta] [char](3) NOT NULL,
	[SituacaoCobranca] [varchar](3) NULL,
	[MotivoSituacao] [varchar](100) NULL,
	[DataAutenticacaoSICOB] [date] NULL,
	[ValorPagoSICOB] [decimal](19, 2) NULL,
	[AgenciaPagamentoSICOB] [varchar](5) NULL,
	[TarifaCobrancaSICOB] [decimal](19, 2) NULL,
	[DataCreditoFederalPrevSICOB] [date] NULL,
	[ValorComissaoSICOB] [decimal](19, 2) NULL,
	[CodigoFundo] [varchar](2) NULL,
	[PercentualReversao] [decimal](11, 6) NULL,
	[IndicadorReservaInicial] [varchar](1) NULL,
	[AposentadoriaInvalidez] [char](1) NULL,
	[OrigemProposta] [char](2) NULL,
	[SequencialArquivo] [varchar](6) NULL,
	[SequencialRegistro] [varchar](6) NULL,
	[DeclaracaoSaude] [varchar](7) NULL,
	[TipoArquivo] [varchar] (30),
	
	[Identidade] [varchar](15) NULL,
	[OrgaoExpedidor] [varchar](5) NULL,
	[UFOrgaoExpedidor] [varchar](2) NULL,
	[DataExpedicaoRG] [date] NULL,
	[EstadoCivil] [tinyint] NULL,
	[Sexo] [tinyint] NULL,
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
) ;

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PRPFPREV_TEMP_Codigo ON [dbo].[PRPFPREV_TEMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_PRPFPREV'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
    
        
    SET @COMANDO =
    '  INSERT INTO dbo.PRPFPREV_TEMP
        ( [Codigo],                                                     
	        [ControleVersao],                                             
	        [NomeArquivo],                                                
	        [DataArquivo],                                                
	        [CPFCNPJ],                                                    
	        [Nome],                                                       
	        [DataNascimento],                                             
	        [TipoPessoa],                                                 
	        [NumeroProposta],                                             
	        [NumeroProdutoSIGPF],                                         
	        [AgenciaVenda],                                               
	        [TipoAposentadoria],                                          
	        [DataProposta],  
	        [CodigoFormaPagamento],                                             
	        [FormaPagamento],                                             
	        [AgenciaDebitoConta],                                         
	        [OperacaoDebitoConta],                                        
	        [ContaCorrenteDebitoConta],                                   
	        [MatriculaVendedor],                                          
	        [PrazoPercepcao],                                             
	        [PrazoDiferimento],                                           
	        [TipoContribuicao],                                           
	        [DiaVencimento],                                              
	        [IndicadorSimulacao],                                         
	        [ValorContribuicao],                                          
	        [ValorReservaInicial],                                        
	        [NumeroPropostaEmpresarial],                                  
	        [PercentualDesconto],                                         
	        [EmpresaConvenente],                                          
	        [CNPJEmpresaConvenente],                                      
	        [MatriculaConvenente],                                        
	        [SituacaoProposta],                                           
	        [SituacaoCobranca],                                           
	        [MotivoSituacao],                                             
	        [DataAutenticacaoSICOB],                                      
	        [ValorPagoSICOB],                                             
	        [AgenciaPagamentoSICOB],                                      
	        [TarifaCobrancaSICOB],                                        
	        [DataCreditoFederalPrevSICOB],                                
	        [ValorComissaoSICOB],                                         
	        [CodigoFundo],                                                
	        [PercentualReversao],                                         
	        [IndicadorReservaInicial],                                    
	        [AposentadoriaInvalidez],                                     
	        [OrigemProposta],                                             
	        [SequencialArquivo],                                          
	        [SequencialRegistro],                                         
	        [DeclaracaoSaude],
	        [TipoArquivo],
	        
	        [Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
         ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
         ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
         ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge])
       SELECT [Codigo],                                                     
	            [ControleVersao],                                             
	            [NomeArquivo],                                                
	            [DataArquivo],                                                
	            [CPFCNPJ],                                                    
	            [Nome],                                                       
	            [DataNascimento],                                             
	            [TipoPessoa],                                                 
	            [NumeroProposta],                                             
	            [NumeroProdutoSIGPF],                                         
	            [AgenciaVenda],                                               
	            [TipoAposentadoria],                                          
	            [DataProposta],  
	            [CodigoFormaPagamento],                                             
	            [FormaPagamento],                                             
	            [AgenciaDebitoConta],                                         
	            [OperacaoDebitoConta],                                        
	            [ContaCorrenteDebitoConta],                                   
	            [MatriculaVendedor],                                          
	            [PrazoPercepcao],                                             
	            [PrazoDiferimento],                                           
	            [TipoContribuicao],                                           
	            [DiaVencimento],                                              
	            [IndicadorSimulacao],                                         
	            [ValorContribuicao],                                          
	            [ValorReservaInicial],                                        
	            [NumeroPropostaEmpresarial],                                  
	            [PercentualDesconto],                                         
	            [EmpresaConvenente],                                          
	            [CNPJEmpresaConvenente],                                      
	            [MatriculaConvenente],                                        
	            [SituacaoProposta],                                           
	            [SituacaoCobranca],                                           
	            [MotivoSituacao],                                             
	            [DataAutenticacaoSICOB],                                      
	            [ValorPagoSICOB],                                             
	            [AgenciaPagamentoSICOB],                                      
	            [TarifaCobrancaSICOB],                                        
	            [DataCreditoFederalPrevSICOB],                                
	            [ValorComissaoSICOB],                                         
	            [CodigoFundo],                                                
	            [PercentualReversao],                                         
	            [IndicadorReservaInicial],                                    
	            [AposentadoriaInvalidez],                                     
	            [OrigemProposta],                                             
	            [SequencialArquivo],                                          
	            [SequencialRegistro],                                         
	            [DeclaracaoSaude],
	            [TipoArquivo],
	            
	            [Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
            , [EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
            , [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
            , [RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPFPREV] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRPFPREV_TEMP PRP                    

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
               FROM dbo.[PRPFPREV_TEMP] PRP
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
               FROM dbo.[PRPFPREV_TEMP] PRP
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
              FROM dbo.PRPFPREV_TEMP PRP 
              WHERE PRP.[MatriculaVendedor] IS NOT NULL
			  
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   AND T.IDEmpresa = X.IDEmpresa
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula], IDEmpresa)
		               VALUES (X.[Matricula], IDEmpresa); 	

	 /***********************************************************************              
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
     ***********************************************************************/
	 MERGE INTO  Dados.TipoMotivo AS T
       USING (SELECT DISTINCT [MotivoSituacao] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM PRPFPREV_TEMP PGTO 
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
              FROM dbo.PRPFPREV_TEMP PRP 
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
              FROM dbo.PRPFPREV_TEMP PRP 
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
	FROM dbo.[PRPFPREV_TEMP] CAD
	WHERE  CAD.AgenciaVenda IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.AgenciaVenda)                                                                        

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'PRPFPREV' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					'PRPFPREV' [Arquivo]

	FROM dbo.[PRPFPREV_TEMP] EM
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
		      SELECT *
		      FROM
		      (
          SELECT PRP.Codigo, PRP.DataArquivo, PRP.TipoArquivo [TipoDado]
               , PRP.[NumeroPropostaTratado], SGD.ID [IDSeguradora], PRD.ID [IDProdutoSIGPF], PP.ID [IDPeriodicidadePagamento]
               , PRP.DataProposta, F.ID [IDFuncionario],  PRP.ValorPagoSICOB
               , PRP.RendaIndividual, PRP.RendaFamiliar, U.ID [IDAgenciaVenda], SP.ID [IDSituacaoProposta]
               
               /*, PRP.[ValorPremioTotal]*/, /*PRP.[RenovacaoAutomatica],*/ PRP.[PercentualDesconto]
               , PRP.[EmpresaConvenente], PRP.[MatriculaConvenente], SB.ID [IDSituacaoCobranca]
               , TM.ID [IDTipoMotivo], /*PRP.[OpcaoCobertura], PRP.[CodigoPlano],*/ PRP.[DataAutenticacaoSICOB]
               , PRP.[AgenciaPagamentoSICOB], PRP.[TarifaCobrancaSICOB], PRP.DataCreditoFederalPrevSICOB [DataCreditoSASSESICOB]
               , PRP.[ValorComissaoSICOB], PRP.[TipoContribuicao] [PeriodicidadePagamento]/*, PRP.[OpcaoConjuge]*/
               , PRP.[OrigemProposta], PRP.[DeclaracaoSaude] [DeclaracaoSaudeTitular]--, PRP.[DeclaracaoSaudeConjuge]
               , PRP.[AposentadoriaInvalidez], PRP.[CodigoSegmento]             
               , RANK() OVER (PARTITION BY PRP.[NumeroPropostaTratado] ORDER BY  PRP.DataArquivo DESC, PRP.Codigo DESC) [RANK]
          FROM dbo.PRPFPREV_TEMP PRP
            INNER JOIN Dados.Seguradora SGD
            ON SGD.Codigo = PRP.CodigoSeguradora
            LEFT OUTER JOIN Dados.ProdutoSIGPF PRD
            ON PRD.CodigoProduto= PRP.NumeroProdutoSIGPF
            LEFT OUTER JOIN Dados.PeriodoPagamento PP
            ON PP.Codigo = PRP.TipoContribuicao
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
            )A
            WHERE A.[RANK] = 1
          ) AS X
    ON X.[NumeroPropostaTratado] = T.NumeroProposta  
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
               
               --,[ValorPremioTotal]  =  COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
               --,[RenovacaoAutomatica]  =  COALESCE(X.[RenovacaoAutomatica], T.[RenovacaoAutomatica])
               ,[PercentualDesconto]  =  COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
               ,[EmpresaConvenente]  =  COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente])
               ,[MatriculaConvenente]  =  COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente])
               ,[IDSituacaoCobranca]  =  COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
               ,[IDTipoMotivo]  =  COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo])
               --,[OpcaoCobertura]  =  COALESCE(X.[OpcaoCobertura], T.[OpcaoCobertura])
               --,[CodigoPlano]  =  COALESCE(X.[CodigoPlano], T.[CodigoPlano])
               ,[DataAutenticacaoSICOB]  =  COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB])
               ,[AgenciaPagamentoSICOB]  =  COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB])
               ,[TarifaCobrancaSICOB]  =  COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB])
               ,[DataCreditoSASSESICOB]  =  COALESCE(X.[DataCreditoSASSESICOB], T.[DataCreditoSASSESICOB])
               ,[ValorComissaoSICOB]  =  COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB])
               ,[PeriodicidadePagamento]  =  COALESCE(X.[PeriodicidadePagamento], T.[PeriodicidadePagamento])
               --,[OpcaoConjuge]  =  COALESCE(X.[OpcaoConjuge], T.[OpcaoConjuge])
               ,[OrigemProposta]  =  COALESCE(X.[OrigemProposta], T.[OrigemProposta])
               ,[DeclaracaoSaudeTitular]  =  COALESCE(X.[DeclaracaoSaudeTitular], T.[DeclaracaoSaudeTitular])
               --,[DeclaracaoSaudeConjuge]  =  COALESCE(X.[DeclaracaoSaudeConjuge], T.[DeclaracaoSaudeConjuge])
               ,[AposentadoriaInvalidez]  =  COALESCE(X.[AposentadoriaInvalidez], T.[AposentadoriaInvalidez])
               ,[CodigoSegmento]  =  COALESCE(X.[CodigoSegmento], T.[CodigoSegmento])
    WHEN NOT MATCHED
			    THEN INSERT          
              (NumeroProposta, IDSeguradora, IDProdutoSIGPF, IDPeriodicidadePagamento
             , DataProposta, IDFuncionario, Valor--, IDUnidade
             , RendaIndividual, RendaFamiliar, IDAgenciaVenda
             , IDSituacaoProposta, TipoDado, DataArquivo               
             
             /*, [ValorPremioTotal], [RenovacaoAutomatica]*/, [PercentualDesconto] 
             , [EmpresaConvenente], [MatriculaConvenente], [IDSituacaoCobranca]
             , [IDTipoMotivo]/*, [OpcaoCobertura], [CodigoPlano]*/, [DataAutenticacaoSICOB]
             , [AgenciaPagamentoSICOB], [TarifaCobrancaSICOB], [DataCreditoSASSESICOB]
             , [ValorComissaoSICOB], [PeriodicidadePagamento], /*[OpcaoConjuge],*/ [OrigemProposta]
             , [DeclaracaoSaudeTitular], /*[DeclaracaoSaudeConjuge],*/ [AposentadoriaInvalidez]
             , [CodigoSegmento]             
             )
          VALUES (X.[NumeroPropostaTratado]
                 ,X.[IDSeguradora]
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
                 
                 --,X.[ValorPremioTotal]
                 --,X.[RenovacaoAutomatica]
                 ,X.[PercentualDesconto]
                 ,X.[EmpresaConvenente]
                 ,X.[MatriculaConvenente]
                 ,X.[IDSituacaoCobranca]
                 ,X.[IDTipoMotivo]
                 --,X.[OpcaoCobertura]
                 --,X.[CodigoPlano]
                 ,X.[DataAutenticacaoSICOB]
                 ,X.[AgenciaPagamentoSICOB]
                 ,X.[TarifaCobrancaSICOB]
                 ,X.[DataCreditoSASSESICOB]
                 ,X.[ValorComissaoSICOB]
                 ,X.[PeriodicidadePagamento]
                 --,X.[OpcaoConjuge]
                 ,X.[OrigemProposta]
                 ,X.[DeclaracaoSaudeTitular]
                 --,X.[DeclaracaoSaudeConjuge]
                 ,X.[AposentadoriaInvalidez]
                 ,X.[CodigoSegmento]

                 ); 
  
     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Formas de pagamento não existentes
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.FormaPagamento AS T
	      USING (SELECT DISTINCT PRP.CodigoFormaPagamento [IDFormaPagamento], '' Descricao
            FROM dbo.PRPFPREV_TEMP PRP
            WHERE PRP.CodigoFormaPagamento IS NOT NULL
              ) X
        ON T.ID = X.[IDFormaPagamento]
       WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.[IDFormaPagamento], X.[Descricao]);
	      
-----------------------------------------------------------------------------------------------------------------------               
		                 
	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */
    UPDATE Dados.MeioPagamento SET LastValue = 0
   -- SELECT *
    FROM Dados.MeioPagamento MP
    WHERE MP.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.PRPFPREV_TEMP PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroPropostaTratado] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND MP.LastValue = 1 
		             
    /***********************************************************************
       Carrega os dados da Forma de Pagamento da Proposta
    ***********************************************************************/          	         
    MERGE INTO Dados.MeioPagamento AS T
	    USING (
		    SELECT *
		    FROM
		    (
          SELECT 
              P.ID [IDProposta], PRP.DataArquivo, PRP.NomeArquivo Arquivo
            , /*PRP.[FormaPagamento],*/ PRP.[CodigoFormaPagamento] [IDFormaPagamento], '104' [Banco]
            , PRP.[AgenciaDebitoConta] [Agencia], PRP.[OperacaoDebitoConta] [Operacao]
            , PRP.[ContaCorrenteDebitoConta] [ContaCorrente], PRP.[DiaVencimento] 
            , ROW_NUMBER() OVER(PARTITION BY [NumeroPropostaTratado] ORDER BY PRP.DataArquivo DESC, PRP.NomeArquivo DESC) [ORDER]
          FROM dbo.PRPFPREV_TEMP PRP
          INNER JOIN Dados.Proposta P
          ON P.NumeroProposta = PRP.[NumeroPropostaTratado] 
          /*INNER JOIN Dados.FormaPagamento FP
          ON FP.ID = PRP.[CodigoFormaPagamento]*/  
        ) A
        WHERE A.[ORDER] = 1
		    ) AS O
	    ON 
		      T.[IDProposta] = O.[IDProposta]
		  AND T.[DataArquivo] = O.[DataArquivo]
	    WHEN MATCHED
		    THEN UPDATE 
			    SET  T.Operacao = COALESCE(O.Operacao, T.Operacao)
             , T.[Agencia] = COALESCE(O.[Agencia], T.[Agencia])
             , T.[ContaCorrente] = COALESCE(O.[ContaCorrente], T.[ContaCorrente])
             , T.[Banco] = COALESCE(O.[Banco], T.[Banco])
             , T.[IDFormaPagamento] = COALESCE(O.[IDFormaPagamento], T.[IDFormaPagamento])
             , T.[DiaVencimento] = COALESCE(O.[DiaVencimento], T.[DiaVencimento])
	    WHEN NOT MATCHED
		    THEN INSERT ([IDProposta], [DataArquivo], [Banco], [Agencia], [Operacao], [ContaCorrente], [IDFormaPagamento], [DiaVencimento])
			    VALUES (O.[IDProposta], O.[DataArquivo], O.[Banco], O.[Agencia], O.[Operacao], O.[ContaCorrente], O.[IDFormaPagamento], O.[DiaVencimento]);
			    
		--SELECT * FROM Dados.MeioPagamento	  

	/*Limpa os meios de pagamento repetidos*/
	/*Diego - Data: 17/12/2013 */	
	DELETE  Dados.MeioPagamento
	FROM  Dados.MeioPagamento b
	INNER JOIN
	(
		SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
		FROM Dados.MeioPagamento PGTO
			INNER JOIN
			dbo.PRPFPREV_TEMP PRP
			INNER JOIN Dados.Proposta P
			ON P.NumeroProposta = PRP.[NumeroPropostaTratado]
			AND P.IDSeguradora = 1 
			ON PGTO.IDProposta = P.ID	 
	) A
	ON   A.IDProposta = B.IDProposta
	AND A.DataArquivo = B.DataArquivo
	AND A.ordem > 1	 	
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */		 
    UPDATE Dados.MeioPagamento SET LastValue = 1
    FROM Dados.MeioPagamento MP
	CROSS APPLY(
				SELECT TOP 1 *
				FROM Dados.MeioPagamento MP1
				WHERE 
				  MP.IDProposta = MP1.IDProposta
				ORDER BY MP1.IDProposta DESC, MP1.DataArquivo DESC
			   ) A
	 WHERE MP.IDProposta = A.IDProposta 	
 	   AND MP.DataArquivo = A.DataArquivo 
	   AND EXISTS (SELECT  PRP.ID [IDProposta]
					FROM dbo.PRPFPREV_TEMP PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
						AND PRP.IDSeguradora = 1
						AND MP.IDProposta = PRP.ID
				  )
                 


     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
		       SELECT *
		       FROM
		       (
              SELECT    PRP1.ID [IDProposta]
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
                       , ROW_NUMBER() OVER(PARTITION BY [NumeroPropostaTratado] ORDER BY PRP.DataArquivo DESC, PRP.NomeArquivo DESC) [ORDER]
              FROM dbo.PRPFPREV_TEMP PRP
                INNER JOIN Dados.Proposta PRP1
                ON PRP.NumeroPropostaTratado = PRP1.NumeroProposta
               AND PRP.CodigoSeguradora = PRP1.IDSeguradora
            ) A
            WHERE A.[ORDER] = 1
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
                
                
   
     /***********************************************************************
       Carrega os dados do Proposta da Previdência
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaPrevidencia AS T
		USING (
		       SELECT *
		       FROM
		       (
              SELECT PRP1.ID [IDProposta]
                   , PRP.TipoAposentadoria
                   , PRP.IndicadorSimulacao
                   , PRP.PrazoPercepcao
                   , PRP.PrazoDiferimento
                   , PRP.TipoContribuicao
                   , PRP.ValorContribuicao
                   , PRP.ValorReservaInicial
                   , PRP.NumeroPropostaEmpresarial
                   , PRP.DiaVencimento
                   , PRP.PercentualDesconto
                   , PRP.DataCreditoFederalPrevSICOB
                   , PRP.CodigoFundo
                   , PRP.PercentualReversao
                   , PRP.IndicadorReservaInicial
                   , PRP.OrigemProposta
                   , PRP.DataArquivo
                   , PRP.TipoArquivo [TipoDado]
                   , ROW_NUMBER() OVER(PARTITION BY [NumeroPropostaTratado] ORDER BY PRP.DataArquivo DESC, PRP.TipoArquivo DESC) [ORDER]
              FROM dbo.PRPFPREV_TEMP PRP
                    INNER JOIN Dados.Proposta PRP1
                ON PRP.NumeroPropostaTratado = PRP1.NumeroProposta
               AND PRP.CodigoSeguradora = PRP1.IDSeguradora
            ) A
            WHERE A.[ORDER] = 1
          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.DataArquivo = T.DataArquivo
       WHEN MATCHED
			    THEN UPDATE
				     SET                                                       
                 [TipoAposentadoria]           = COALESCE(X.[TipoAposentadoria], T.[TipoAposentadoria])
               , [IndicadorSimulacao]          = COALESCE(X.[IndicadorSimulacao], T.[IndicadorSimulacao])
               , [PrazoPercepcao]              = COALESCE(X.[PrazoPercepcao], T.[PrazoPercepcao])
               , [PrazoDiferimento]            = COALESCE(X.[PrazoDiferimento], T.[PrazoDiferimento])
               , [TipoContribuicao]            = COALESCE(X.[TipoContribuicao], T.[TipoContribuicao])
               , [ValorContribuicao]           = COALESCE(X.[ValorContribuicao], T.[ValorContribuicao])
               , [ValorReservaInicial]         = COALESCE(X.[ValorReservaInicial], T.[ValorReservaInicial])
               , [NumeroPropostaEmpresarial]   = COALESCE(X.[NumeroPropostaEmpresarial], T.[NumeroPropostaEmpresarial])
               , [DiaVencimento]               = COALESCE(X.[DiaVencimento], T.[DiaVencimento])
               , [PercentualDesconto]          = COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
               , [DataCreditoFederalPrevSICOB] = COALESCE(X.[DataCreditoFederalPrevSICOB], T.[DataCreditoFederalPrevSICOB])
               , [CodigoFundo]                 = COALESCE(X.[CodigoFundo], T.[CodigoFundo])
               , [PercentualReversao]          = COALESCE(X.[PercentualReversao], T.[PercentualReversao])
               , [IndicadorReservaInicial]     = COALESCE(X.[IndicadorReservaInicial], T.[IndicadorReservaInicial])
               , [OrigemProposta]              = COALESCE(X.[OrigemProposta], T.[OrigemProposta])
               , [TipoDado]                    = COALESCE(X.[TipoDado], T.[TipoDado])
               , [DataArquivo]                 = COALESCE(X.[DataArquivo], T.[DataArquivo])	
    WHEN NOT MATCHED
			    THEN INSERT          
              (
               [IDProposta],                 
               [TipoAposentadoria],          
               [IndicadorSimulacao],         
               [PrazoPercepcao],             
               [PrazoDiferimento],           
               [TipoContribuicao],           
               [ValorContribuicao],          
               [ValorReservaInicial],        
               [NumeroPropostaEmpresarial],  
               [DiaVencimento],              
               [PercentualDesconto],         
               [DataCreditoFederalPrevSICOB],
               [CodigoFundo],                
               [PercentualReversao],         
               [IndicadorReservaInicial],    
               [OrigemProposta],
               [TipoDado],
               [DataArquivo])
          VALUES (                         
                  X.[IDProposta]                 
                 ,X.[TipoAposentadoria]          
                 ,X.[IndicadorSimulacao]         
                 ,X.[PrazoPercepcao]             
                 ,X.[PrazoDiferimento]           
                 ,X.[TipoContribuicao]           
                 ,X.[ValorContribuicao]          
                 ,X.[ValorReservaInicial]        
                 ,X.[NumeroPropostaEmpresarial]  
                 ,X.[DiaVencimento]              
                 ,X.[PercentualDesconto]         
                 ,X.[DataCreditoFederalPrevSICOB]
                 ,X.[CodigoFundo]                
                 ,X.[PercentualReversao]         
                 ,X.[IndicadorReservaInicial]    
                 ,X.[OrigemProposta]
                 ,X.[TipoDado]
                 ,X.[DataArquivo]
                 );
      /***********************************************************************/
	    
              
			  
			  
/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaSituacao SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaSituacao PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN dbo.PRPFPREV_TEMP PGTO
                                   ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
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
        FROM [dbo].PRPFPREV_TEMP PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
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
                 	   --SELECT * FROM dbo.PRPFPREV_TEMP PGTO

    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
   -- SELECT *
	FROM Dados.PropostaSituacao	PS
	INNER JOIN 
			(SELECT  PS1.ID, ROW_NUMBER() OVER (PARTITION BY PS1.IDProposta ORDER BY  COALESCE(PRP.DataSituacao, PGTO.DataArquivo) DESC, PS1.ID DESC) ORDEM
                 FROM Dados.PropostaSituacao PS1
				 INNER JOIN Dados.Proposta PRP
				 ON PS1.IDProposta = PRP.ID                      
				 INNER JOIN dbo.PRPFPREV_TEMP PGTO
				 ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
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
	             FROM dbo.PRPFPREV_TEMP PGTO
                 WHERE PGTO.NumeroPropostaTratado = PRP.NumeroProposta
                   AND PGTO.CodigoSeguradora = PRP.IDSeguradora)  
    --##############################################################################  
	           
  /*TODO: Neste ponto, inserir os dados de PropostaSeguro*/
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_PRPFPREV'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRPFPREV_TEMP]
  
  /*********************************************************************************************************************/
                
     SET @COMANDO =
    '  INSERT INTO dbo.PRPFPREV_TEMP
        ( [Codigo],                                                     
	        [ControleVersao],                                             
	        [NomeArquivo],                                                
	        [DataArquivo],                                                
	        [CPFCNPJ],                                                    
	        [Nome],                                                       
	        [DataNascimento],                                             
	        [TipoPessoa],                                                 
	        [NumeroProposta],                                             
	        [NumeroProdutoSIGPF],                                         
	        [AgenciaVenda],                                               
	        [TipoAposentadoria],                                          
	        [DataProposta],  
	        [CodigoFormaPagamento],                                             
	        [FormaPagamento],                                             
	        [AgenciaDebitoConta],                                         
	        [OperacaoDebitoConta],                                        
	        [ContaCorrenteDebitoConta],                                   
	        [MatriculaVendedor],                                          
	        [PrazoPercepcao],                                             
	        [PrazoDiferimento],                                           
	        [TipoContribuicao],                                           
	        [DiaVencimento],                                              
	        [IndicadorSimulacao],                                         
	        [ValorContribuicao],                                          
	        [ValorReservaInicial],                                        
	        [NumeroPropostaEmpresarial],                                  
	        [PercentualDesconto],                                         
	        [EmpresaConvenente],                                          
	        [CNPJEmpresaConvenente],                                      
	        [MatriculaConvenente],                                        
	        [SituacaoProposta],                                           
	        [SituacaoCobranca],                                           
	        [MotivoSituacao],                                             
	        [DataAutenticacaoSICOB],                                      
	        [ValorPagoSICOB],                                             
	        [AgenciaPagamentoSICOB],                                      
	        [TarifaCobrancaSICOB],                                        
	        [DataCreditoFederalPrevSICOB],                                
	        [ValorComissaoSICOB],                                         
	        [CodigoFundo],                                                
	        [PercentualReversao],                                         
	        [IndicadorReservaInicial],                                    
	        [AposentadoriaInvalidez],                                     
	        [OrigemProposta],                                             
	        [SequencialArquivo],                                          
	        [SequencialRegistro],                                         
	        [DeclaracaoSaude],
	        [TipoArquivo],
	        
	        [Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
         ,[EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
         ,[TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
         ,[RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge])
       SELECT [Codigo],                                                     
	            [ControleVersao],                                             
	            [NomeArquivo],                                                
	            [DataArquivo],                                                
	            [CPFCNPJ],                                                    
	            [Nome],                                                       
	            [DataNascimento],                                             
	            [TipoPessoa],                                                 
	            [NumeroProposta],                                             
	            [NumeroProdutoSIGPF],                                         
	            [AgenciaVenda],                                               
	            [TipoAposentadoria],                                          
	            [DataProposta],  
	            [CodigoFormaPagamento],                                             
	            [FormaPagamento],                                             
	            [AgenciaDebitoConta],                                         
	            [OperacaoDebitoConta],                                        
	            [ContaCorrenteDebitoConta],                                   
	            [MatriculaVendedor],                                          
	            [PrazoPercepcao],                                             
	            [PrazoDiferimento],                                           
	            [TipoContribuicao],                                           
	            [DiaVencimento],                                              
	            [IndicadorSimulacao],                                         
	            [ValorContribuicao],                                          
	            [ValorReservaInicial],                                        
	            [NumeroPropostaEmpresarial],                                  
	            [PercentualDesconto],                                         
	            [EmpresaConvenente],                                          
	            [CNPJEmpresaConvenente],                                      
	            [MatriculaConvenente],                                        
	            [SituacaoProposta],                                           
	            [SituacaoCobranca],                                           
	            [MotivoSituacao],                                             
	            [DataAutenticacaoSICOB],                                      
	            [ValorPagoSICOB],                                             
	            [AgenciaPagamentoSICOB],                                      
	            [TarifaCobrancaSICOB],                                        
	            [DataCreditoFederalPrevSICOB],                                
	            [ValorComissaoSICOB],                                         
	            [CodigoFundo],                                                
	            [PercentualReversao],                                         
	            [IndicadorReservaInicial],                                    
	            [AposentadoriaInvalidez],                                     
	            [OrigemProposta],                                             
	            [SequencialArquivo],                                          
	            [SequencialRegistro],                                         
	            [DeclaracaoSaude],
	            [TipoArquivo],
	            
	            [Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataExpedicaoRG]
            , [EstadoCivil],[Sexo],[DDDComercial],[TelefoneComercial],[DDDFax],[TelefoneFax],[DDDResidencial]
            , [TelefoneResidencial],[Email],[CodigoProfissao],[Profissao],[CodigoSegmento],[RendaFamiliar]
            , [RendaIndividual],[NomeConjuge],[DataNascimentoConjuge],[ProfissaoConjuge]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRPFPREV] ''''' + @PontoDeParada + ''''''') PRP
         '
  EXEC (@COMANDO)
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PRPFPREV_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPFPREV_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRPFPREV_TEMP];

	--Chama proc que carregará os endereços da propostas de Previdência
	--Egler Vieira: 2013-19-11
	EXEC [Dados].[proc_InserePropostaEndereco_PRPPREV] 

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereProposta_PRPFPREV] 

