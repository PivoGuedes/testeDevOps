
/*
	Autor: Egler Vieira
	Data Criação: 09/11/2012

	Descrição: 
	
	Última alteração : Diego Lima
	Data de alteração : 16/10/2013
	Descrição : Alteração da proc que inseri proposta maquina vendas.

*/

/*******************************************************************************
	Nome: CONCILIACAO.Dados.proc_InsereProposta_MaquinaVendas
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_MaquinaVendas] 
AS

BEGIN TRY		
    

--BEGIN TRAN

DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = 4188
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max) 

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proposta_MaquinaVendas_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Proposta_MaquinaVendas_TEMP;

	
CREATE TABLE [dbo].Proposta_MaquinaVendas_TEMP(
[ID] bigint NOT NULL,
[IDTaxa] int NULL,
[IDFluxo] int NULL,
[MatriculaVendedor] varchar(15) null,
[NumeroProposta] varchar(20) null,
[DiaVencimento] int null,
[ValorPremio] decimal(24,4),
[DataProposta] date null,
[DataCancelamento] date null,
[DataUltimoEndosso] date null,
[CoberturaConjuge] varchar(2) null,
[IDEmpresa] smallint null,
[CPF] varchar(18) null,
[Nome] varchar(200) null,
[Matricula] varchar(15) null,
[Sexo] tinyint null,
[EstadoCivil] tinyint null,
[DataNascimento] date null,
[EmailPessoal] varchar(60) null,
[EmailComercial] varchar(60) null,
[Logradouro] varchar(100)null,
[Numero] varchar(10)null,
[Complemento] varchar(255) null,
[Endereco]varchar(150) null,
[Bairro] varchar(80) null,
[Cidade] varchar(80) null,
[UF] char(2) null,
[CEP] varchar(10) null,
[Profissao] varchar(100) null,
[CodigoCBO] varchar(10) null,
[RG] varchar(25)null,
[OrgaoExpedidor] varchar(20) null,
[UFExpedicao] varchar(2) null,
[TelResidencial]varchar(20) null,
[DDDResidencial] varchar(5) null,
[TelefoneResidencial] varchar(20) null,
[TelCelular] varchar(20) null,
[DDDCelular] varchar(5) null,
[TelefoneCelular]varchar(20) null,
[TelComercial] varchar(20) null,
[DDDComercial] varchar(5) null,
[TelefoneComercial]varchar(20) null,
[TelFax] varchar(20) null,
[DDDFax]varchar(5) null,
[TelefoneFax]varchar(20) null,
[CPFConjuge] varchar(18) null,
[NomeConjuge]varchar(140) null,
[SexoConjuge]tinyint null,
[ProfissaoConjuge] varchar(100) null,
[DataNascimentoConjuge] date null,
[CodigoCBOConjuge] varchar(10) null,
[CodigoFormaPagamento] tinyint null,
[FormaPagamento] varchar(60) null,
[CodigoProduto] varchar(10) null,
[Produto] varchar(100) null,
[Situacao] varchar(100) null,
[Sigla] varchar(10) null,
[Agencia] varchar(10) null,
[Operacao] varchar(10) null,
[Conta] varchar(20) null,
[DV] varchar(5) null,
[CartaoCredito] varchar(60) null,
[Rank] bigint not null
	
) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroProposta_MaquinaVendas_TEMP ON [dbo].Proposta_MaquinaVendas_TEMP
( 
  NumeroProposta ASC
)       


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_Proposta_MaquinaVendas_TEMP ON [dbo].Proposta_MaquinaVendas_TEMP
( 
  ID ASC
)       

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_MaquinaVendas'
               --select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)= '0'
--DECLARE @COMANDO AS NVARCHAR(max)
--SET @COMANDO = '
INSERT into [dbo].[Proposta_MaquinaVendas_TEMP] ( 
												   [ID]
												  ,[IDTaxa]
												  ,[IDFluxo]
												  ,[MatriculaVendedor]
												  ,[NumeroProposta]
												  ,[DiaVencimento]
												  ,[ValorPremio]
												  ,[DataProposta]
												  ,[DataCancelamento]
												  ,[DataUltimoEndosso]
												  ,[CoberturaConjuge]
												  ,[IDEmpresa]
												  ,[CPF]
												  ,[Nome]
												  ,[Matricula]
												  ,[Sexo]
												  ,[EstadoCivil]
												  ,[DataNascimento]
												  ,[EmailPessoal]
												  ,[EmailComercial]
												  ,[Logradouro]
												  ,[Numero]
												  ,[Complemento]
												  ,[Endereco]
												  ,[Bairro]
												  ,[Cidade]
												  ,[UF]
												  ,[CEP]
												  ,[Profissao]
												  ,[CodigoCBO]
												  ,[RG]
												  ,[OrgaoExpedidor]
												  ,[UFExpedicao]
												  ,[TelResidencial]
												  ,[DDDResidencial]
												  ,[TelefoneResidencial]
												  ,[TelCelular]
												  ,[DDDCelular]
												  ,[TelefoneCelular]
												  ,[TelComercial]
												  ,[DDDComercial]
												  ,[TelefoneComercial]
												  ,[TelFax]
												  ,[DDDFax]
												  ,[TelefoneFax]
												  ,[CPFConjuge]
												  ,[NomeConjuge]
												  ,[SexoConjuge]
												  ,[ProfissaoConjuge]
												  ,[DataNascimentoConjuge]
												  ,[CodigoCBOConjuge]
												  ,[CodigoFormaPagamento]
												  ,[FormaPagamento]
												  ,[CodigoProduto]
												  ,[Produto]
												  ,[Situacao]
												  ,[Sigla]
												  ,[Agencia]
												  ,[Operacao]
												  ,[Conta]
												  ,[DV]
												  ,[CartaoCredito]
												  ,[Rank])
               EXEC [EVendasCSVE].[Corporativo].[proc_RecuperaProposta_MaquinaDeVendas] @PontoDeParada


SELECT @MaiorCodigo= MAX(ID)
FROM [dbo].[Proposta_MaquinaVendas_TEMP]


/*********************************************************************************************************************/
  
--print @comando
--EXEC (@COMANDO)     
--SET @ParmDefinition = N'@MaiorCodigo BIGINT OUTPUT';     

--SET @COMANDO = 'SELECT @MaiorCodigo= MAX(PRP.Codigo)
--                FROM OPENQUERY ([OBERON], 
--                ''EXEC [EVendasCSVE].[Corporativo].[proc_RecuperaProposta_MaquinaVendas] ''''' + @PontoDeParada + ''''''') PRP'

--exec sp_executesql @COMANDO
--                  ,@ParmDefinition
--                  ,@MaiorCodigo = @MaiorCodigo OUTPUT

/*********************************************************************************************************************/
                  
--SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/***********************************************************************
       Carregar os FUNCIONARIOS de proposta não carregados do SRH
 ***********************************************************************/

 ;MERGE INTO Dados.Funcionario AS T
	 USING (           
              SELECT DISTINCT t.[MatriculaVendedor] [Matricula], 3 IDEmpresa, 'CSVE' NomeArquivo, MAX(DataProposta) DataArquivo  -- Empresa 3 - Funcionarios da PAR corretora             
              FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
              WHERE t.[MatriculaVendedor] IS NOT NULL
			  GROUP BY t.[MatriculaVendedor]
              ) X
       ON T.[Matricula] = X.[Matricula] 
	   and t.IDEmpresa = X.IDEmpresa
       WHEN NOT MATCHED
		          THEN INSERT ([Matricula],IDEmpresa,NomeArquivo,DataArquivo)
		               VALUES (X.[Matricula], X.IDEmpresa, X.NomeArquivo, X.DataArquivo); 


/*
 /**********************************************************************
       Carrega os PRODUTOS SIGPF desconhecidos
 ***********************************************************************/  
            
;MERGE INTO Dados.ProdutoSIGPF AS T
	 USING (SELECT DISTINCT t.[CodigoProduto], t.produto as [Descricao]
               FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
              ) X
       ON T.CodigoProduto = X.CodigoProduto 
       WHEN NOT MATCHED
		          THEN INSERT (CodigoProduto, Descricao)
		               VALUES (X.[CodigoProduto], X.[Descricao]);
*/

/***********************************************************************
     Carregar as situações das propostas não cadastradas
***********************************************************************/

; MERGE INTO [Dados].[SituacaoProposta] T
	USING (SELECT DISTINCT t.Situacao, t.Sigla
			FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
			WHERE t.Sigla IS NOT NULL
			) X
		ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.SITUACAO);

/***********************************************************************
     Carregar os dados da Proposta
***********************************************************************/

;MERGE INTO Dados.Proposta AS T
		USING (
				SELECT null as IDContrato,
					   1 as IDSeguradora, --1 
					   t.NumeroProposta,
					   null as NumeroPropostaEmissao,
					   133 as IDProduto,---*****/*SIAS 9310 - Produto vida exclusivo, único comercializado pelo sistema máquina de vendas,  */
					   null as IDProdutoAnterior,
					   p.ID as IDProdutoSIGPF,
					   null as IDPeriodicidadePagamento,
					   null as IDCanalVendaPAR,
					   t.DataProposta,
					   null as DataInicioVigencia,
					   null as DataFimVigencia,
					   f.ID as IDFuncionario,
					   t.ValorPremio as Valor,
					   null as [RendaIndividual],
					   null as [RendaFamiliar],
					   null as [IDAgenciaVenda],
					   null as [DataSituacao],
					   sp.ID as [IDSituacaoProposta],
					   null as [IDSituacaoCobranca],
					   null as [IDTipoMotivo],
					   'CSVE' as [TipoDado],
					   t.DataProposta as [DataArquivo],
					   --CASE 
						--	WHEN T.MatriculaVendedor = '99 999 999' THEN 7
						--	ELSE 2 
					   --END AS 
					  -- null [IDCanalVenda],
					   null as [ValorPremioBrutoEmissao],
					   null as [ValorPremioLiquidoEmissao],
					   null as [ValorPremioBrutoCalculado],
					   null as [ValorPremioLiquidoCalculado],
					   null as [ValorPagoAcumulado],
					   t.ValorPremio as [ValorPremioTotal],
					   null as [RenovacaoAutomatica],
					   null as [PercentualDesconto],
					   null as [EmpresaConvenente],
					   null as [MatriculaConvenente],
					   null as [OpcaoCobertura],
					   null as [CodigoPlano],
					   null as [DataAutenticacaoSICOB],
					   null as [AgenciaPagamentoSICOB],
					   null as [TarifaCobrancaSICOB],
					   null as [DataCreditoSASSESICOB],
					   null as [ValorComissaoSICOB],
					   null as [PeriodicidadePagamento],
					   null as [OpcaoConjuge],
					   null as [OrigemProposta],
					   null as [DeclaracaoSaudeTitular],
					   null as [DeclaracaoSaudeConjuge],
					   null as [AposentadoriaInvalidez],
					   null as [CodigoSegmento]
					FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
						INNER JOIN [Corporativo].[Dados].SituacaoProposta sp
							ON t.Sigla = sp.Sigla

						INNER JOIN [Dados].[ProdutoSIGPF] p
						 ON  p.CodigoProduto = '93' /*Fixo pois o máquina de vendas só comercializa o vida exclusivo.
						                       Caso o máquina de vendas passe a vender outros produtos, todos
											    os códigos de produtos, assim como o código do produto armazenado no máquina de vendas deverão ser revisados*/--t.CodigoProduto = p.CodigoProduto 

						INNER JOIN [Dados].[Funcionario] f
						on f.Matricula = t.MatriculaVendedor
						AND F.IDEmpresa = 3
						--and t.numeroproposta ='029993939999817'
					WHERE [RANK] = 1
			) AS X
	 ON X.NumeroProposta = T.NumeroProposta  
   AND T.IDSeguradora = 1

		WHEN MATCHED
			    THEN UPDATE
					SET
						 [IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato])
						,[IDSeguradora]= COALESCE(X.[IDSeguradora], T.[IDSeguradora])
						,[NumeroProposta]= COALESCE(X.[NumeroProposta], T.[NumeroProposta])
						,[NumeroPropostaEMISSAO]= COALESCE(X.[NumeroPropostaEMISSAO], T.[NumeroPropostaEMISSAO])
						,[IDProduto]= COALESCE(X.[IDProduto], T.[IDProduto])
						,[IDProdutoAnterior]= COALESCE(X.[IDProdutoAnterior], T.[IDProdutoAnterior])
						,[IDProdutoSIGPF]= COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF])
						,[IDPeriodicidadePagamento]= COALESCE(X.[IDPeriodicidadePagamento], T.[IDPeriodicidadePagamento])
						,[IDCanalVendaPAR]= COALESCE(X.[IDCanalVendaPAR], T.[IDCanalVendaPAR])
						,[DataProposta] = COALESCE(X.[DataProposta], T.[DataProposta])
						,[DataInicioVigencia]= COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
					    ,[DataFimVigencia]= COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
					    ,[IDFuncionario]= COALESCE(X.[IDFuncionario], T.[IDFuncionario])
					    ,[Valor]= COALESCE(X.[Valor], T.[Valor])
					    ,[RendaIndividual] = COALESCE(X.[RendaIndividual], T.[RendaIndividual])
					    ,[RendaFamiliar]= COALESCE(X.[RendaFamiliar], T.[RendaFamiliar])
					    ,[IDAgenciaVenda]= COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda])
					    ,[DataSituacao]= COALESCE(X.[DataSituacao], T.[DataSituacao])
					    ,[IDSituacaoProposta]= COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
					    ,[IDSituacaoCobranca]= COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
					    ,[IDTipoMotivo]= COALESCE(X.[IDTipoMotivo], T.[IDTipoMotivo])
					    ,[TipoDado]= COALESCE(X.[TipoDado], T.[TipoDado])
					    ,[DataArquivo]= COALESCE(X.[DataArquivo], T.[DataArquivo])
					    --,[IDCanalVenda]= COALESCE(X.[IDCanalVenda], T.[IDCanalVenda])
					    ,[ValorPremioBrutoEmissao]= COALESCE(X.[ValorPremioBrutoEmissao], T.[ValorPremioBrutoEmissao])
					    ,[ValorPremioLiquidoEmissao]= COALESCE(X.[ValorPremioLiquidoEmissao], T.[ValorPremioLiquidoEmissao])
					    ,[ValorPremioBrutoCalculado]= COALESCE(X.[ValorPremioBrutoCalculado], T.[ValorPremioBrutoCalculado])
					    ,[ValorPremioLiquidoCalculado]= COALESCE(X.[ValorPremioLiquidoCalculado], T.[ValorPremioLiquidoCalculado])
					    ,[ValorPagoAcumulado]= COALESCE(X.[ValorPagoAcumulado], T.[ValorPagoAcumulado])
					    ,[ValorPremioTotal]= COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
					    ,[RenovacaoAutomatica]= COALESCE(X.[RenovacaoAutomatica], T.[RenovacaoAutomatica])
					    ,[PercentualDesconto]= COALESCE(X.[PercentualDesconto], T.[PercentualDesconto])
					    ,[EmpresaConvenente]= COALESCE(X.[EmpresaConvenente], T.[EmpresaConvenente])
					    ,[MatriculaConvenente]= COALESCE(X.[MatriculaConvenente], T.[MatriculaConvenente])
					    ,[OpcaoCobertura]= COALESCE(X.[OpcaoCobertura], T.[OpcaoCobertura])
					    ,[CodigoPlano]= COALESCE(X.[CodigoPlano], T.[CodigoPlano])
					    ,[DataAutenticacaoSICOB]= COALESCE(X.[DataAutenticacaoSICOB], T.[DataAutenticacaoSICOB])
					    ,[AgenciaPagamentoSICOB]= COALESCE(X.[AgenciaPagamentoSICOB], T.[AgenciaPagamentoSICOB])
					    ,[TarifaCobrancaSICOB]= COALESCE(X.[TarifaCobrancaSICOB], T.[TarifaCobrancaSICOB])
					    ,[DataCreditoSASSESICOB]= COALESCE(X.[DataCreditoSASSESICOB], T.[DataCreditoSASSESICOB])
					    ,[ValorComissaoSICOB]= COALESCE(X.[ValorComissaoSICOB], T.[ValorComissaoSICOB])
					    ,[PeriodicidadePagamento]= COALESCE(X.[PeriodicidadePagamento], T.[PeriodicidadePagamento])
					    ,[OpcaoConjuge]= COALESCE(X.[OpcaoConjuge], T.[OpcaoConjuge])
					    ,[OrigemProposta]= COALESCE(X.[OrigemProposta], T.[OrigemProposta])
					    ,[DeclaracaoSaudeTitular]= COALESCE(X.[DeclaracaoSaudeTitular], T.[DeclaracaoSaudeTitular])
					    ,[DeclaracaoSaudeConjuge]= COALESCE(X.[DeclaracaoSaudeConjuge], T.[DeclaracaoSaudeConjuge])
					    ,[AposentadoriaInvalidez]= COALESCE(X.[AposentadoriaInvalidez], T.[AposentadoriaInvalidez])
					    ,[CodigoSegmento]= COALESCE(X.[CodigoSegmento], T.[CodigoSegmento])
			WHEN NOT MATCHED
				THEN INSERT
							(	
							    [IDContrato]
							   ,[IDSeguradora]
							   ,[NumeroProposta]
							   ,[NumeroPropostaEMISSAO]
							   ,[IDProduto]
							   ,[IDProdutoAnterior]
							   ,[IDProdutoSIGPF]
							   ,[IDPeriodicidadePagamento]
							   ,[IDCanalVendaPAR]
							   ,[DataProposta]
							   ,[DataInicioVigencia]
							   ,[DataFimVigencia]
							   ,[IDFuncionario]
							   ,[Valor]
							   ,[RendaIndividual]
							   ,[RendaFamiliar]
							   ,[IDAgenciaVenda]
							   ,[DataSituacao]
							   ,[IDSituacaoProposta]
							   ,[IDSituacaoCobranca]
							   ,[IDTipoMotivo]
							   ,[TipoDado]
							   ,[DataArquivo]
							   --,[IDCanalVenda]
							   ,[ValorPremioBrutoEmissao]
							   ,[ValorPremioLiquidoEmissao]
							   ,[ValorPremioBrutoCalculado]
							   ,[ValorPremioLiquidoCalculado]
							   ,[ValorPagoAcumulado]
							   ,[ValorPremioTotal]
							   ,[RenovacaoAutomatica]
							   ,[PercentualDesconto]
							   ,[EmpresaConvenente]
							   ,[MatriculaConvenente]
							   ,[OpcaoCobertura]
							   ,[CodigoPlano]
							   ,[DataAutenticacaoSICOB]
							   ,[AgenciaPagamentoSICOB]
							   ,[TarifaCobrancaSICOB]
							   ,[DataCreditoSASSESICOB]
							   ,[ValorComissaoSICOB]
							   ,[PeriodicidadePagamento]
							   ,[OpcaoConjuge]
							   ,[OrigemProposta]
							   ,[DeclaracaoSaudeTitular]
							   ,[DeclaracaoSaudeConjuge]
							   ,[AposentadoriaInvalidez]
							   ,[CodigoSegmento]
							)

     VALUES (			X.[IDContrato], 
						X.[IDSeguradora],
						X.[NumeroProposta],
						X.[NumeroPropostaEMISSAO],
						X.[IDProduto],
						X.[IDProdutoAnterior],
						X.[IDProdutoSIGPF],
						X.[IDPeriodicidadePagamento],
						X.[IDCanalVendaPAR], 
						X.[DataProposta], 
						X.[DataInicioVigencia], 
					    X.[DataFimVigencia],
					    X.[IDFuncionario], 
					    X.[Valor], 
					    X.[RendaIndividual], 
					    X.[RendaFamiliar], 
					    X.[IDAgenciaVenda],
					    X.[DataSituacao], 
					    X.[IDSituacaoProposta],
					    X.[IDSituacaoCobranca], 
					    X.[IDTipoMotivo], 
					    X.[TipoDado], 
					    X.[DataArquivo], 
					   -- X.[IDCanalVenda], 
					    X.[ValorPremioBrutoEmissao], 
					    X.[ValorPremioLiquidoEmissao],
					    X.[ValorPremioBrutoCalculado], 
					    X.[ValorPremioLiquidoCalculado],
					    X.[ValorPagoAcumulado], 
					    X.[ValorPremioTotal],
					    X.[RenovacaoAutomatica], 
					    X.[PercentualDesconto],
					    X.[EmpresaConvenente], 
					    X.[MatriculaConvenente], 
					    X.[OpcaoCobertura], 
					    X.[CodigoPlano], 
					    X.[DataAutenticacaoSICOB], 
					    X.[AgenciaPagamentoSICOB], 
					    X.[TarifaCobrancaSICOB], 
					    X.[DataCreditoSASSESICOB], 
					    X.[ValorComissaoSICOB], 
					    X.[PeriodicidadePagamento], 
					    X.[OpcaoConjuge], 
					    X.[OrigemProposta], 
					    X.[DeclaracaoSaudeTitular], 
					    X.[DeclaracaoSaudeConjuge],
					    X.[AposentadoriaInvalidez], 
						x.[CodigoSegmento]);

/***********************************************************************
    Carrega os dados do estado civil não cadastrados
***********************************************************************/
--select * from [Dados].[EstadoCivil]
;MERGE INTO [Dados].[EstadoCivil] T
	USING (SELECT DISTINCT t.EstadoCivil,
				CASE 
					WHEN t.EstadoCivil = 1 THEN 'Solteiro'
					WHEN t.EstadoCivil = 2 THEN 'Casado'
					WHEN t.EstadoCivil = 3 THEN 'Viuvo'
					WHEN t.EstadoCivil = 4 THEN 'Outros'
					WHEN t.EstadoCivil = 5 THEN 'Divorciado'
					WHEN t.EstadoCivil = 6 THEN 'Separado Judicialmente'
					ELSE '-'
				END	AS Descricao
			FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
		    ) X
			ON T.ID = X.EstadoCivil
			WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.EstadoCivil, X.Descricao);

/***********************************************************************
    Carrega os dados de sexo do cliente não cadastrados
***********************************************************************/

;MERGE INTO [Dados].[Sexo] T
	USING (select distinct t.Sexo,'-' as descricao
			FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
			) X
		ON T.ID = X.Sexo
			WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.Sexo, X.descricao);

/***********************************************************************
    Carrega os dados de sexo do conjuge do cliente não cadastrados
***********************************************************************/

;MERGE INTO [Dados].[Sexo] T
	USING (select distinct t.SexoConjuge ,'-' as descricao
			FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
			) X
		ON T.ID = X.SexoConjuge
		WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.SexoConjuge, X.descricao);


/***********************************************************************
    Carrega os dados do Cliente da proposta
***********************************************************************/

;MERGE INTO Dados.PropostaCliente AS T
		USING (
				SELECT  DISTINCT prp.id as [IDProposta],
								 t.cpf as [CPFCNPJ],
								t.nome as [Nome],
								t.DataNascimento as [DataNascimento],
								'Pessoa Física' as [TipoPessoa],
								t.Sexo as [IDSexo],
								t.EstadoCivil as IDEstadoCivil, 
								t.rg as [Identidade],
								t.OrgaoExpedidor as [OrgaoExpedidor],
								t.UFExpedicao as [UFOrgaoExpedidor],
								null as [DataExpedicaoRG],
								--T.telcomercial,
								[DDDComercial],
								[TelefoneComercial],
								--t.telfax,
								[DDDFax],
								[TelefoneFax],
								--t.telresidencial,
								[DDDResidencial],
								[TelefoneResidencial],
								t.EmailPessoal as [Email],
								t.CodigoCBO as [CodigoProfissao],
								t.profissao as [Profissao],
								t.NomeConjuge as [NomeConjuge],
								t.ProfissaoConjuge as [ProfissaoConjuge],
								'CSVE' as [TipoDado],
								t.DataProposta as [DataArquivo],
								t.EmailComercial,
								--T.TelCelular,
								[DDDCelular],
							    [TelefoneCelular],
								t.CPFConjuge,
								t.SexoConjuge,
								t.DataNascimentoConjuge,
								t.CodigoCBOConjuge as CodigoProfissaoConjuge,
								t.Matricula

					FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
						INNER JOIN Dados.Proposta PRP
							ON t.NumeroProposta = PRP.NumeroProposta 
								AND PRP.IDSeguradora = 1
							WHERE [RANK] = 1
						--	and PRP.id= 10084193
			) AS X
			ON X.IDProposta = T.IDProposta
			--and t.idproposta = 10084193
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
					   , EmailComercial = COALESCE(X.EmailComercial, T.EmailComercial)  
					   , DDDCelular = COALESCE(X.DDDCelular, T.DDDCelular) 
					   , TelefoneCelular = COALESCE(X.TelefoneCelular, T.TelefoneCelular) 
					   , CPFConjuge = COALESCE(X.CPFConjuge, T.CPFConjuge) 
					   , IDSexoConjuge = COALESCE(X.SexoConjuge, T.IDSexoConjuge) 
					   , DataNascimentoConjuge = COALESCE(X.DataNascimentoConjuge, T.DataNascimentoConjuge) 
					   , CodigoProfissaoConjuge = COALESCE(X.CodigoProfissaoConjuge, T.CodigoProfissaoConjuge) 
					   , Matricula = COALESCE(X.Matricula, T.Matricula) 
		 WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, CPFCNPJ, Nome, DataNascimento, TipoPessoa        
              , IDSexo, IDEstadoCivil, Identidade, OrgaoExpedidor, UFOrgaoExpedidor  
              , DataExpedicaoRG, DDDComercial, TelefoneComercial 
              , DDDFax, TelefoneFax, DDDResidencial, TelefoneResidencial
              , Email, CodigoProfissao, Profissao, NomeConjuge, ProfissaoConjuge                   
              , TipoDado, DataArquivo, EmailComercial, DDDCelular, TelefoneCelular, CPFConjuge, 
			  IDSexoConjuge, DataNascimentoConjuge, CodigoProfissaoConjuge, Matricula)
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
				 ,X.EmailComercial
				 ,X.DDDCelular
				 ,X.TelefoneCelular
				 ,X.CPFConjuge
				 ,X.SexoConjuge
				 ,X.DataNascimentoConjuge
				 ,X.CodigoProfissaoConjuge
				 ,X.Matricula
                 );

/***********************************************************************
    Atualiza o Last Value
***********************************************************************/

 UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
							  INNER JOIN Dados.Proposta PRP
							  ON T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							 WHERE [Rank] = 1
							-- AND T.[DataProposta] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
		   --AND PS.TipoDado = 'CSVE'

 /***********************************************************************
       Carrega os dados do Cliente endereco da proposta
 ***********************************************************************/ 

;MERGE INTO  Dados.PropostaEndereco AS T
		USING ( SELECT  A. [IDProposta],
						A.[IDTipoEndereco]
						,A.Endereco        
						,A.Bairro              
						,A.Cidade       
						,A.[UF]      
						,A.CEP    
						--,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco ORDER BY A.DataArquivo DESC) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
						--					ELSE 0
						--	END) LastValue
						, 0 LastValue
						, A.[TipoDado]           
						, A.DataArquivo	
						,ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco, Endereco ORDER BY A.DataArquivo DESC) NUMERADOR
			FROM ( 
						SELECT prp.id as [IDProposta],
								1 as [IDTipoEndereco],
								[Endereco],
								t.Bairro,
								t.Cidade,
								t.UF,
								t.Cep,
								'CSVE' as [TipoDado],
								t.DataProposta as [DataArquivo]
							FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
								INNER JOIN Dados.Proposta PRP
									on t.NumeroProposta = PRP.NumeroProposta 
										and PRP.IDSeguradora = 1
							WHERE Rank= 1 
								and [Endereco] IS NOT NULL
						) as A
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
/*DIEGO - Data: 18/10/2013 */		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].[Proposta_MaquinaVendas_TEMP] t
										  INNER JOIN Dados.Proposta PRP
										  ON T.[NumeroProposta] = PRP.NumeroProposta
										 AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	

 /***********************************************************************
       Comando para inserir Formas de pagamento não existentes
 ***********************************************************************/ 

;MERGE INTO [Dados].[FormaPagamento] T
	USING (SELECT distinct t.CodigoFormaPagamento, t.FormaPagamento, '' AS Descricao 
			FROM [dbo].[Proposta_MaquinaVendas_TEMP] t 
				WHERE t.CodigoFormaPagamento IS NOT NULL
			) X
		ON T.ID = X.CodigoFormaPagamento
       WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.CodigoFormaPagamento, X.[Descricao]);

-----------------------------------------------------------------------------------------------------------------------               
		                 
	/*Apaga a marcação LastValue dos meios de pagamento das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */
    UPDATE Dados.MeioPagamento SET LastValue = 0
   -- SELECT *
    FROM Dados.MeioPagamento MP
    WHERE MP.IDProposta IN (
	                        SELECT PRP.ID
                            FROM dbo.[Proposta_MaquinaVendas_TEMP] PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND MP.LastValue = 1 


  /***********************************************************************
       Carrega os dados da meio Pagamento da Proposta
   ***********************************************************************/ 
	  
;MERGE INTO Dados.MeioPagamento AS T
	 USING ( 
			SELECT *
					FROM
						(
							SELECT DISTINCT
											P.ID [IDProposta],
											t.DataProposta as [DataArquivo],
											t.CodigoFormaPagamento as [IDFormaPagamento],
											'104' [Banco],
											t.Agencia,
											t.Operacao,
											t.Conta+''+ t.DV as [ContaCorrente],
											t.diavencimento as [DiaVencimento],
										    ROW_NUMBER() OVER(PARTITION BY t.[NumeroProposta] ORDER BY t.dataproposta DESC) [ORDER]
							FROM [dbo].[Proposta_MaquinaVendas_TEMP] t 
								INNER JOIN Dados.Proposta P
									ON P.NumeroProposta = t.[NumeroProposta] 
									AND P.IDSeguradora = 1           
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
  

    /*Limpa os meios de pagamento repetidos*/
	/*Diego - Data: 17/12/2013 */
		
	DELETE  Dados.MeioPagamento
	FROM  Dados.MeioPagamento b
	INNER JOIN
	(
		SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
		FROM Dados.MeioPagamento PGTO
			INNER JOIN
			dbo.[Proposta_MaquinaVendas_TEMP] PRP
			INNER JOIN Dados.Proposta P
			ON P.NumeroProposta = PRP.[NumeroProposta]
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
					FROM dbo.[Proposta_MaquinaVendas_TEMP] PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
						AND PRP.IDSeguradora = 1
						AND MP.IDProposta = PRP.ID
				  )
                 
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_MaquinaVendas'

  /*************************************************************************************/
  
  TRUNCATE TABLE [dbo].[Proposta_MaquinaVendas_TEMP]
  
  /*********************************************************************************************************************/
  
  INSERT into [dbo].[Proposta_MaquinaVendas_TEMP] ( 
												   [ID]
												  ,[IDTaxa]
												  ,[IDFluxo]
												  ,[MatriculaVendedor]
												  ,[NumeroProposta]
												  ,[DiaVencimento]
												  ,[ValorPremio]
												  ,[DataProposta]
												  ,[DataCancelamento]
												  ,[DataUltimoEndosso]
												  ,[CoberturaConjuge]
												  ,[IDEmpresa]
												  ,[CPF]
												  ,[Nome]
												  ,[Matricula]
												  ,[Sexo]
												  ,[EstadoCivil]
												  ,[DataNascimento]
												  ,[EmailPessoal]
												  ,[EmailComercial]
												  ,[Logradouro]
												  ,[Numero]
												  ,[Complemento]
												  ,[Endereco]
												  ,[Bairro]
												  ,[Cidade]
												  ,[UF]
												  ,[CEP]
												  ,[Profissao]
												  ,[CodigoCBO]
												  ,[RG]
												  ,[OrgaoExpedidor]
												  ,[UFExpedicao]
												  ,[TelResidencial]
												  ,[DDDResidencial]
												  ,[TelefoneResidencial]
												  ,[TelCelular]
												  ,[DDDCelular]
												  ,[TelefoneCelular]
												  ,[TelComercial]
												  ,[DDDComercial]
												  ,[TelefoneComercial]
												  ,[TelFax]
												  ,[DDDFax]
												  ,[TelefoneFax]
												  ,[CPFConjuge]
												  ,[NomeConjuge]
												  ,[SexoConjuge]
												  ,[ProfissaoConjuge]
												  ,[DataNascimentoConjuge]
												  ,[CodigoCBOConjuge]
												  ,[CodigoFormaPagamento]
												  ,[FormaPagamento]
												  ,[CodigoProduto]
												  ,[Produto]
												  ,[Situacao]
												  ,[Sigla]
												  ,[Agencia]
												  ,[Operacao]
												  ,[Conta]
												  ,[DV]
												  ,[CartaoCredito]
												  ,[Rank])
               EXEC [EVendasCSVE].[Corporativo].[proc_RecuperaProposta_MaquinaDeVendas] @PontoDeParada
	
  
  	   
			   
SELECT @MaiorCodigo= MAX(ID)
FROM [dbo].[Proposta_MaquinaVendas_TEMP]

  /*********************************************************************************************************************/
  
END







--ROLLBACK TRAN
--COMMIT TRAN
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proposta_MaquinaVendas_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Proposta_MaquinaVendas_TEMP;

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     


--EXEC [Dados].[proc_InsereProposta_MaquinaVendas] 


/*

		SELECT @@TRANCOUNT



		SELECT *
  FROM [Corporativo].[dbo].[Proposta_MaquinaVendas_TEMP] A
  INNER JOIN DADOS.Proposta PRP 
  ON PRP.NumeroProposta = A.NumeroProposta



  SELECT prp.id, a.*
  FROM [Corporativo].[dbo].[Proposta_MaquinaVendas_TEMP] A
  INNER JOIN DADOS.Proposta PRP 
  ON PRP.NumeroProposta = A.NumeroProposta
    inner join dados.propostacliente pc
  on prp.id = pc.idproposta
  and idproposta = 10084193
  

  select *
  from dados.propostacliente
  where idproposta = 10084193

		SELECT *
  FROM [Corporativo].[dbo].[Proposta_MaquinaVendas_TEMP] A
  INNER JOIN DADOS.Proposta PRP 
  ON PRP.NumeroProposta = A.NumeroProposta


		SELECT *
  FROM [Corporativo].[dbo].[Proposta_MaquinaVendas_TEMP] A
  INNER JOIN DADOS.Proposta PRP 
  ON PRP.NumeroProposta = A.NumeroProposta


		SELECT *
  FROM [Corporativo].[dbo].[Proposta_MaquinaVendas_TEMP] A
  INNER JOIN DADOS.Proposta PRP 
  ON PRP.NumeroProposta = A.NumeroProposta


  select *
  from dados.meiopagamento
  where idproposta = 10084193*/

