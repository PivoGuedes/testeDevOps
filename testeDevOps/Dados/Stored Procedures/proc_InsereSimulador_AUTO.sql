

CREATE PROCEDURE [Dados].[proc_InsereSimulador_AUTO]

AS

BEGIN TRY		


--exec [Dados].[proc_InsereSimulador_AUTO]
 		 

DECLARE @PontoDeParada AS VARCHAR(400) = '0' 

DECLARE @MaiorCodigo AS BIGINT

DECLARE @ParmDefinition NVARCHAR(500)

DECLARE @COMANDO AS NVARCHAR(MAX)



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SIMULADOR_AUTO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)

	DROP TABLE [dbo].[SIMULADOR_AUTO_TEMP];



CREATE TABLE [dbo].[SIMULADOR_AUTO_TEMP]

(

	[Codigo] [bigint] NOT NULL,                             

	[ControleVersao] [decimal](16, 8) NULL,

	[NomeArquivo] [varchar](300) NULL,

	[DataArquivo] [datetime] NULL,

	[NUMERO_DO_CALCULO] [varchar](20) NULL,

	[DATA_CALCULO] [date] NULL,

	[SITUACAO_CALCULO] [varchar](30) NULL,

	[DATA_INI_VIGENCIA] [date] NULL,

	[AGENCIA_VENDA] [varchar](5) NULL,

	[MATRICULA_INDICADOR] [varchar](15) NULL,

	[CPFCNPJ] [varchar](19) NULL,

	[NOME] [varchar](150) NULL,

	[TIPO_PESSOA] [varchar](10) NULL,

	[TIPO_CLIENTE] [varchar](5) NULL,

	[DESC_TIPO_CLIENTE] [varchar](40) NULL,

	[TIPO_SEGURO] [varchar](50) NULL,

	[SEXO] [varchar](15) NULL,

	[DDD] [varchar](4) NULL,

	[TELEFONE] [varchar](10) NULL,

	[DATA_NASC] [date] NULL,

	[BONUS_ANTERIOR] [varchar](5) NULL,

	[CEP] [varchar](10) NULL,

	[UF] [varchar](2) NULL,

	[CIDADE] [varchar](80) NULL,

	[ANO_MODELO] [varchar](9) NULL,

	[COD_MODELO] [varchar](10) NULL,

	[USO_VEICULO] [varchar](50) NULL,

	[BLINDADO] [bit] NULL,

	[TURBINADO] [bit] NULL,

	[FORMA_CONTRATACAO] [varchar](50) NULL,

	[FRANQUIA] [varchar](50) NULL,

	[DANOS_MATERIAIS] [decimal](19, 3) NULL,

	[DANOS_MORAIS] [decimal](19, 3) NULL,

	[DANOS_CORPORAIS] [decimal](19, 3) NULL,

	[ASSIS_24_HRS] [varchar](50) NULL,

	[CARRO_RESERVA] [varchar](50) NULL,

	[GARANTIA_CARRO_RESERVA] [varchar](50) NULL,

	[APP_PASSAGEIRO] [decimal](19, 3) NULL,

	[DESP_MEDICO_HOSP] [varchar](50) NULL,

	[LANT_FAROIS_RETROVIS] [bit] NULL,

	[VIDROS] [bit] NULL,

	[DESP_EXTRAORDINARIAS] [bit] NULL,

	[RESPOND_QAR] [bit] NULL,

	[PERFIL_QAR] [varchar](50) NULL,

	[RELACAO_COND_SEGURADO] [varchar](50) NULL,

	[ESTADO_CIVIL] [varchar](50) NULL,

	[KM_MEDIA_PARTICULAR] [varchar](50) NULL,

	[KM_MEDIA_COMERCIAL] [varchar](50) NULL,

	[ESTENDER_COB_PARA_MENORES] [bit] NULL,

	[PREMIO_BRUTO] [decimal](19, 3) NULL,

	[PRECISA_VISTORIA] [bit] NULL,

	[FORMA_PGTO_1_PARCELA] [varchar](50) NULL,

	[FORMAT_PGTO_DEMAIS_PARCELAS] [varchar](50) NULL,

	[QTDE_PARCELAS] [varchar](50) NULL,

	[EMAIL] [varchar](70) NULL,

	[CHASSI] [varchar](25) NULL,

	[MODELO_VEICULO] [varchar](150) NULL,

	[PLACA_VEICULO] [varchar](20) NULL,

	[CARROCERIA] [varchar](40) NULL,

	[COD_FIPE] [int] NULL,

	[VALOR_FIPE] [varchar](20) NULL,

	[PRODUTO_MULHER] [bit] NULL,

	[PRODUTO_0KM] [bit] NULL,

	[ISEN_FRANQ_1_SINISTRO] [bit] NULL,

	[ISEN_FRANQ_EQUIP] [bit] NULL,

	[ISEN_FRANQ_CARROC] [bit] NULL,

	[APOLICE_ANTERIOR] [varchar](20) NULL,

	[PROPOSTA] [varchar](20) NULL,

	[NumeroPropostaTratado]                   as Cast(dbo.fn_TrataNumeroPropostaZeroExtra([PROPOSTA]) as   varchar(20)) PERSISTED,

	[APELIDO] [varchar](70) NULL,

	[DataNascimentoPrincipalCondutor] DATE NULL, 

	[EstadoCivilPrincipalCondutor] VARCHAR(20) NULL, 

	[PrincipalCondutorTrabalha] VARCHAR(20) NULL, 

	[PrincipalCondutorEstuda] VARCHAR(20) NULL, 

	[CadastroOpcionais] VARCHAR(200) NULL, 

	[ValorFranquia] DECIMAL(19,2) NULL,

	[TIPO_COMBUSTIVEL] VARCHAR(50) NULL,

	[UFPLACA] CHAR(2) NULL,

	[CEPResidenciaEOMesmo] VARCHAR(20) NULL,

	[GuardaVeiculoGaragem] VARCHAR(50) NULL,

	[CPFPrincipalCondutor] VARCHAR(20) NULL,

	[NomePrincipalCondutor] VARCHAR(200) NULL,

	[SexoPrincipalCondutor] VARCHAR(20) NULL,

	[NomeUsuarioLogado] VARCHAR (100) NULL,

	[CPFUsuarioLogado] VARCHAR (50) NULL

) 



 /*Criação de Índices*/  

CREATE CLUSTERED INDEX idx_SIMULADOR_TEMP ON [dbo].SIMULADOR_AUTO_TEMP

( 

  Codigo ASC

)    

 

CREATE NONCLUSTERED INDEX idx_NCL_MODELO_VEICULO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([MODELO_VEICULO])

INCLUDE(COD_FIPE)



CREATE NONCLUSTERED INDEX idx_NCL_APOLICE_ANTERIOR_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([APOLICE_ANTERIOR])

INCLUDE(DataArquivo)



CREATE NONCLUSTERED INDEX idx_NCL_NumeroPropostaTratado_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([NumeroPropostaTratado])

INCLUDE(DataArquivo)



CREATE NONCLUSTERED INDEX idx_NCL_KM_MEDIA_PARTICULAR_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([KM_MEDIA_PARTICULAR])



CREATE NONCLUSTERED INDEX idx_NCL_KM_MEDIA_COMERCIAL_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([KM_MEDIA_COMERCIAL])



CREATE NONCLUSTERED INDEX idx_NCL_RELACAO_COND_SEGURADO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([RELACAO_COND_SEGURADO])



CREATE NONCLUSTERED INDEX idx_NCL_PERFIL_QAR_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([PERFIL_QAR])



CREATE NONCLUSTERED INDEX idx_NCL_SITUACAO_CALCULO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([SITUACAO_CALCULO])

INCLUDE ([AGENCIA_VENDA])



CREATE NONCLUSTERED INDEX idx_NCL_TIPO_SEGURO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([TIPO_SEGURO])


CREATE NONCLUSTERED INDEX idx_NCL_ESTADO_CIVIL_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([ESTADO_CIVIL])


CREATE NONCLUSTERED  INDEX idx_NCL_TIPO_CLIENTE_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([TIPO_CLIENTE])

INCLUDE(DESC_TIPO_CLIENTE)



CREATE NONCLUSTERED INDEX idx_NCL_USO_VEICULO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([USO_VEICULO])


CREATE NONCLUSTERED INDEX idx_NCL_FORMA_CONTRATACAO_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([FORMA_CONTRATACAO])



CREATE NONCLUSTERED INDEX idx_NCL_GARANTIA_CARRO_RESERVA_SIMULADOR_TEMP

ON [dbo].[SIMULADOR_AUTO_TEMP] ([GARANTIA_CARRO_RESERVA])



SELECT @PontoDeParada = PontoParada

FROM ControleDados.PontoParada

WHERE NomeEntidade = 'SIMULADOR_AUTO'







/*********************************************************************************************************************/               

/*Recuperação do Maior Código do Retorno*/

/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[SIMULADOR_AUTO_TEMP] 

						( 

							[Codigo],

							[ControleVersao],                                                               

							[NomeArquivo],                                                                  

							[DataArquivo],                                                                  

							[NUMERO_DO_CALCULO],                                                            

							[DATA_CALCULO],                                                                 

							[SITUACAO_CALCULO],                                                             

							[DATA_INI_VIGENCIA],                                                            

							[AGENCIA_VENDA],              

							[MATRICULA_INDICADOR],                                                          

							[CPFCNPJ],                                                                      

							[NOME],                                                                         

							[TIPO_PESSOA],                                                                  

							[TIPO_CLIENTE],                                                                 

							[DESC_TIPO_CLIENTE],                                                            

							[TIPO_SEGURO],                                                                  

							[SEXO],                                                                         

							[DDD],                                                                          

							[TELEFONE],                                                                     

							[DATA_NASC],                                                                    

							[BONUS_ANTERIOR],                                                               

							[CEP],                                                                          

							[UF],                                                                           

							[CIDADE],                                                                       

							[ANO_MODELO],                                                                   

							[COD_MODELO],                                                                   

							[USO_VEICULO],                                                                  

							[BLINDADO],                                                                     

							[TURBINADO],                                                                    

							[FORMA_CONTRATACAO],                                                            

							[FRANQUIA],                                                                     

							[DANOS_MATERIAIS],                                                              

							[DANOS_MORAIS],                                                                 

							[DANOS_CORPORAIS],                                                              

							[ASSIS_24_HRS],                                                                 

							[CARRO_RESERVA],                                                                

							[GARANTIA_CARRO_RESERVA],                                                       

							[APP_PASSAGEIRO],                                                               

							[DESP_MEDICO_HOSP],                                                             

							[LANT_FAROIS_RETROVIS],                                                         

							[VIDROS],                                                                       

							[DESP_EXTRAORDINARIAS],                                                         

							[RESPOND_QAR],                                                                  

							[PERFIL_QAR],                                                                   

							[RELACAO_COND_SEGURADO],                                                        

							[ESTADO_CIVIL],                                                                 

							[KM_MEDIA_PARTICULAR],                                                          

							[KM_MEDIA_COMERCIAL],                                                           

							[ESTENDER_COB_PARA_MENORES],                                                    

							[PREMIO_BRUTO],                                                                 

							[PRECISA_VISTORIA],                                                             

							[FORMA_PGTO_1_PARCELA],                                                         

							[FORMAT_PGTO_DEMAIS_PARCELAS],                                                  

							[QTDE_PARCELAS],                                                                

							[EMAIL],                                                                        

							[CHASSI],                                                                       

							[MODELO_VEICULO],                                                               

							[PLACA_VEICULO],                                                                

							[CARROCERIA],                                                                   

							[COD_FIPE],                                                                     

							[VALOR_FIPE],                                                                   

							[PRODUTO_MULHER],                                                               

							[PRODUTO_0KM],                                                                  

							[ISEN_FRANQ_1_SINISTRO],                                                        

							[ISEN_FRANQ_EQUIP],                                                             

							[ISEN_FRANQ_CARROC],                                                            

							[APOLICE_ANTERIOR],                                                             

							[PROPOSTA],                                                                     

							[APELIDO],

							[DataNascimentoPrincipalCondutor], 

							[EstadoCivilPrincipalCondutor], 

							[PrincipalCondutorTrabalha], 

							[PrincipalCondutorEstuda], 
							 
							[CadastroOpcionais], 
							 
							[ValorFranquia],
							 
							[TIPO_COMBUSTIVEL],
						 
							[UFPLACA],
							 
							[CEPResidenciaEOMesmo],
							 
							[GuardaVeiculoGaragem],
							 
							[CPFPrincipalCondutor],
							 
							[NomePrincipalCondutor],
							 
							[SexoPrincipalCondutor],
							 
							[NomeUsuarioLogado],
							 
							[CPFUsuarioLogado] 

								                                                                 

					   )

					   SELECT 

   
							[Codigo],

							[ControleVersao],                                                               

							[NomeArquivo],                                                                  

							[DataArquivo],                                                                  

							[NUMERO_DO_CALCULO],                                                            

							[DATA_CALCULO],                                                                 

							[SITUACAO_CALCULO],                                                             

							[DATA_INI_VIGENCIA],                                                            

							[AGENCIA_VENDA],              

							[MATRICULA_INDICADOR],                                                          

							[CPFCNPJ],                                                                      

							[NOME],                                                                         

							[TIPO_PESSOA],                                                                  

							[TIPO_CLIENTE],                                                                 

							[DESC_TIPO_CLIENTE],                                                            

							[TIPO_SEGURO],                                                                  

							[SEXO],                                                                         

							[DDD],                                                                          

							[TELEFONE],                                                                     

							[DATA_NASC],                                                                    

							[BONUS_ANTERIOR],                                                               

							[CEP],                                                                          

							[UF],                                                                           

							[CIDADE],                                                                       

							[ANO_MODELO],                                                                   

							[COD_MODELO],                                                                   

							[USO_VEICULO],                                                                  

							[BLINDADO],                                                                     

							[TURBINADO],                                                                    

							[FORMA_CONTRATACAO],                                                            

							[FRANQUIA],                                                                     

							[DANOS_MATERIAIS],                                                              

							[DANOS_MORAIS],                                                                 

							[DANOS_CORPORAIS],                                                              

							[ASSIS_24_HRS],                                                                 

							[CARRO_RESERVA],                                                                

							[GARANTIA_CARRO_RESERVA],                                                       

							[APP_PASSAGEIRO],                                                               

							[DESP_MEDICO_HOSP],                                                             

							[LANT_FAROIS_RETROVIS],                                                         

							[VIDROS],                                                                       

							[DESP_EXTRAORDINARIAS],                                                         

							[RESPOND_QAR],                                                                  

							[PERFIL_QAR],                                                                   

							[RELACAO_COND_SEGURADO],                                                        

							[ESTADO_CIVIL],                                                                 

							[KM_MEDIA_PARTICULAR],                                                          

							[KM_MEDIA_COMERCIAL],                                                           

							[ESTENDER_COB_PARA_MENORES],                                                    

							[PREMIO_BRUTO],                                                                 

							[PRECISA_VISTORIA],                                                             

							[FORMA_PGTO_1_PARCELA],                                                         

							[FORMAT_PGTO_DEMAIS_PARCELAS],                                                  

							[QTDE_PARCELAS],                                                                

							[EMAIL],                                                                        

							[CHASSI],                                                                       

							[MODELO_VEICULO],                                                               

							[PLACA_VEICULO],                                                                

							[CARROCERIA],                                                                   

							[COD_FIPE],                                                                     

							[VALOR_FIPE],                                                                   

							[PRODUTO_MULHER],                                                               

							[PRODUTO_0KM],                                                                  

							[ISEN_FRANQ_1_SINISTRO],                                                        

							[ISEN_FRANQ_EQUIP],                                                             

							[ISEN_FRANQ_CARROC],                                                            

							[APOLICE_ANTERIOR],                                                             

							[PROPOSTA],                                                                     

							[APELIDO],

							[DataNascimentoPrincipalCondutor], 

							[EstadoCivilPrincipalCondutor], 

							[PrincipalCondutorTrabalha], 

							[PrincipalCondutorEstuda], 
							 
							[CadastroOpcionais], 
							 
							[ValorFranquia],
							 
							[TIPO_COMBUSTIVEL],
						 
							[UFPLACA],
							 
							[CEPResidenciaEOMesmo],
							 
							[GuardaVeiculoGaragem],
							 
							[CPFPrincipalCondutor],
							 
							[NomePrincipalCondutor],
							 
							[Sexo],
							 
							[NmUsuarioLogado],
							 
							[CPFUsuarioLogado] 


						FROM OPENQUERY ([OBERON], 

						''EXEC [FENAE].[Corporativo].[proc_RecuperaSIMULADOR_AUTO] ''''' + @PontoDeParada + ''''''') SA'



EXEC (@COMANDO)     



SELECT @MaiorCodigo = MAX(Codigo)

FROM dbo.SIMULADOR_AUTO_TEMP



/*********************************************************************************************************************/



WHILE @MaiorCodigo IS NOT NULL

BEGIN 





---SELECT * FROM SIMULADOR_AUTO_TEMP

--Carga de Dados

	--Funcionário.Cargo

	--Funcionário.Lotação

	--Funcionário.Funcionário - Empresa, Matrícula, Nome, CPF, Sexo, EstadoCivil, DataNascimento

	--Funcionário.Endereço

	--Funcionários.Telefone



--SELECT *

--FROM SIMULADOR_AUTO_TEMP





/***********************************************************************

Carregar SituacaoCalculo

***********************************************************************/

MERGE INTO Dados.SituacaoCalculo AS T

USING 

(

	SELECT DISTINCT SITUACAO_CALCULO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE SITUACAO_CALCULO IS NOT NULL

) AS S

ON T.Descricao = S.Descricao

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar Unidade

***********************************************************************/

MERGE INTO Dados.Unidade AS T

USING 

(

	SELECT DISTINCT AGENCIA_VENDA  [Codigo]

	FROM SIMULADOR_AUTO_TEMP

	WHERE SITUACAO_CALCULO IS NOT NULL

) AS S

ON T.Codigo = S.Codigo

WHEN NOT MATCHED THEN

	INSERT (Codigo)

	VALUES (S.Codigo);



/***********************************************************************

Carregar SituacaoCalculo

***********************************************************************/

MERGE INTO Dados.SituacaoCalculo AS T

USING 

(

	SELECT DISTINCT SITUACAO_CALCULO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE SITUACAO_CALCULO IS NOT NULL

) AS S

ON T.Descricao = S.Descricao

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);





/***********************************************************************

 Carregar Funcionários Caixa Seguros

***********************************************************************/

MERGE INTO Dados.Funcionario AS T

USING 

(

	SELECT *

	FROM

	(

	SELECT DISTINCT MATRICULA_INDICADOR Matricula, 1 IDEmpresa, 'SIMULADOR_AUTO' NomeArquivo, DataArquivo

	FROM SIMULADOR_AUTO_TEMP AS T

	WHERE MATRICULA_INDICADOR IS NOT NULL

	) A

) AS S



ON S.Matricula = T.Matricula

	AND S.IDEmpresa = T.IDEmpresa



WHEN NOT MATCHED THEN 

	INSERT 

	(

		[Matricula],[IDEmpresa], DataArquivo, NomeArquivo

     )

	 VALUES

	 (

		S.Matricula, S.IDEmpresa, DataArquivo, NomeArquivo

	 );



/***********************************************************************

Carregar TipoSeguro

***********************************************************************/

MERGE INTO Dados.TipoSeguro AS T

USING 

(

	SELECT DISTINCT TIPO_SEGURO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE TIPO_SEGURO IS NOT NULL

) AS S

ON T.Descricao = S.Descricao

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar EstadoCivil

***********************************************************************/

MERGE INTO Dados.EstadoCivil AS T

USING 

(

	SELECT DISTINCT ESTADO_CIVIL  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE ESTADO_CIVIL IS NOT NULL

) AS S

ON T.Descricao = S.Descricao

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar TipoCliente

***********************************************************************/

MERGE INTO Dados.TipoCliente AS T

USING 

(

	SELECT DISTINCT TIPO_CLIENTE [Codigo],  DESC_TIPO_CLIENTE  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE TIPO_CLIENTE IS NOT NULL

) AS S

ON T.[Codigo] = S.[Codigo]

WHEN NOT MATCHED THEN

	INSERT ([Codigo], Descricao)

	VALUES (S.[Codigo], S.Descricao);





/***********************************************************************

Carregar TipoUsoVeiculo

***********************************************************************/

MERGE INTO Dados.TipoUsoVeiculo AS T

USING 

(

	SELECT DISTINCT USO_VEICULO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE USO_VEICULO IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar FormaContratacao

***********************************************************************/

MERGE INTO Dados.FormaContratacao AS T

USING 

(

	SELECT DISTINCT FORMA_CONTRATACAO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE FORMA_CONTRATACAO IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



--/***********************************************************************

--Carregar ClasseFranquia

--***********************************************************************/

--MERGE INTO Dados.ClasseFranquia AS T

--USING 

--(

--	SELECT DISTINCT FRANQUIA  [Descricao]

--	FROM SIMULADOR_AUTO_TEMP

--	WHERE FRANQUIA IS NOT NULL

--) AS S

--ON T.[Descricao] = S.[Descricao]

--WHEN NOT MATCHED THEN

--	INSERT (Descricao)

--	VALUES (S.Descricao);



/***********************************************************************

Carregar TipoCarroReserva

***********************************************************************/

MERGE INTO Dados.TipoCarroReserva AS T

USING 

(

	SELECT DISTINCT GARANTIA_CARRO_RESERVA  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE GARANTIA_CARRO_RESERVA IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar PerfilQuestionarioRisco

***********************************************************************/

MERGE INTO Dados.PerfilQuestionarioRisco AS T

USING 

(

	SELECT DISTINCT PERFIL_QAR  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE PERFIL_QAR IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar TipoRelacaoSegurado

***********************************************************************/

MERGE INTO Dados.TipoRelacaoSegurado AS T

USING 

(

	SELECT DISTINCT RELACAO_COND_SEGURADO  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE RELACAO_COND_SEGURADO IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar MediaQuilometragem

***********************************************************************/

MERGE INTO Dados.MediaQuilometragem AS T

USING 

(

	SELECT DISTINCT KM_MEDIA_PARTICULAR  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE KM_MEDIA_PARTICULAR IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



/***********************************************************************

Carregar MediaQuilometragem

***********************************************************************/

MERGE INTO Dados.MediaQuilometragem AS T

USING 

(

	SELECT DISTINCT KM_MEDIA_COMERCIAL  [Descricao]

	FROM SIMULADOR_AUTO_TEMP

	WHERE KM_MEDIA_COMERCIAL IS NOT NULL

) AS S

ON T.[Descricao] = S.[Descricao]

WHEN NOT MATCHED THEN

	INSERT (Descricao)

	VALUES (S.Descricao);



--/***********************************************************************

--Carregar FormaPagamento

--***********************************************************************/

--MERGE INTO Dados.FormaPagamento AS T

--USING 

--(

--	SELECT DISTINCT FORMA_PGTO_1_PARCELA  [Descricao]

--	FROM SIMULADOR_AUTO_TEMP

--	WHERE FORMA_PGTO_1_PARCELA IS NOT NULL

--) AS S

--ON T.[Descricao] = S.[Descricao]

--WHEN NOT MATCHED THEN

--	INSERT (Descricao)

--	VALUES (S.Descricao);



--/***********************************************************************

--Carregar FormaPagamento

--***********************************************************************/

--MERGE INTO Dados.FormaPagamento AS T

--USING 

--(

--	SELECT DISTINCT [FORMAT_PGTO_DEMAIS_PARCELAS]  [Descricao]

--	FROM SIMULADOR_AUTO_TEMP

--	WHERE [FORMAT_PGTO_DEMAIS_PARCELAS] IS NOT NULL

--) AS S

--ON T.[Descricao] = S.[Descricao]

--WHEN NOT MATCHED THEN

--	INSERT (Descricao)

--	VALUES (S.Descricao);





/***********************************************************************

Carregar Proposta

***********************************************************************/

MERGE INTO Dados.Proposta AS T

USING 

(
	SELECT *
	FROM (
		SELECT DISTINCT NumeroPropostaTratado [NumeroProposta], 1 [IDSeguradora], DataArquivo, 'SIMULADOR_AUTO' [TipoDado]
			   ,ROW_NUMBER() OVER (PARTITION BY NumeroPropostaTratado ORDER BY DataArquivo Desc) Ordem

		FROM SIMULADOR_AUTO_TEMP

		WHERE NumeroPropostaTratado IS NOT NULL
	) as x
	where Ordem=1

) AS S

ON T.[NumeroProposta] = S.[NumeroProposta]

AND T.IDSeguradora = S.[IDSeguradora]

WHEN NOT MATCHED THEN

	INSERT ([NumeroProposta], IDSeguradora, DataArquivo, TipoDado)

	VALUES (S.[NumeroProposta], S.IDSeguradora, S.DataArquivo, S.TipoDado);



/***********************************************************************

Carregar Contrato

***********************************************************************/

MERGE INTO Dados.Contrato AS T

USING 

(

	SELECT DISTINCT [APOLICE_ANTERIOR] [NumeroContratoAnterior], 1 [IDSeguradora], DataArquivo, 'SIMULADOR_AUTO' [Arquivo]

	FROM SIMULADOR_AUTO_TEMP

	WHERE [APOLICE_ANTERIOR] IS NOT NULL

) AS S

ON T.[NumeroContrato] = S.[NumeroContratoAnterior]

AND T.IDSeguradora = S.[IDSeguradora]

WHEN NOT MATCHED THEN

	INSERT ([NumeroContrato], IDSeguradora, DataArquivo, Arquivo)

	VALUES (S.[NumeroContratoAnterior], S.IDSeguradora, S.DataArquivo, [Arquivo]);



/***********************************************************************

Carregar FormaPagamento

***********************************************************************/

MERGE INTO Dados.Veiculo AS T

USING 

(

	SELECT MODELO_VEICULO [Nome], MAX(ISNULL(COD_FIPE,0)) [Codigo]

	FROM SIMULADOR_AUTO_TEMP

	WHERE MODELO_VEICULO IS NOT NULL

	GROUP BY MODELO_VEICULO

) AS S

ON T.[Nome] = S.[Nome]

--WHEN MATCHED --AND t.Codigo IS not null

-- THEN UPDATE SET T.Codigo = S.Codigo

WHEN NOT MATCHED THEN

	INSERT (Codigo, [Nome])

	VALUES (S.Codigo, S.[Nome]);



	--SELECT * FROM DADOS.Veiculo WHERE ID IN (6168,7176)

	--select * from dados.Contrato where id = 19554213

	--select * from dados.proposta where id = 49777277





MERGE INTO Dados.SimuladorAuto AS T

USING 

(

	SELECT DISTINCT

  		cast(SA.[DataArquivo] as date)            DataArquivo,

		SA.[NomeArquivo]            Arquivo,

		SA.[NUMERO_DO_CALCULO]      [NumeroCalculo],

		ISNULL(SA.[DATA_CALCULO],'1999-01-01') [DataCalculo],

		SC.ID                   	[IDSituacaoCalculo],

		SA.[DATA_INI_VIGENCIA]      [DataInicioVigencia],

		[U].[ID]                  	[IDAgenciaVenda],

		[F].[ID]    	            [IDIndicador],  	

		SA.[CPFCNPJ]                [CPFCNPJ],  

		SA.[NOME]                   [NomeCliente],  

		EC.ID	                    [IDEstadoCivil],  

		[TIPO_PESSOA]              	[TipoPessoa],  

		TC.ID               	    [IDTipoCliente],  

		--[DESC_TIPO_CLIENTE]        	[DescTipoCliente],  

		TS.ID                  	    [IDTipoSeguro],  

		S.ID                     	[IDSexo],  

		SA.[DDD]                    [DDDTelefoneContato],  

		SA.[TELEFONE]               [TelefoneContato],  

		SA.[DATA_NASC]              [DataNascimento],  

		CB.ID                   	[IDClasseBonusAnterior],  

		SA.[CEP]                   	[CEP],  

		SA.[UF]                    	[UF],  

		SA.[CIDADE]                 [Cidade],  

		SA.[ANO_MODELO]             [Ano],  

		SA.[COD_MODELO]             [CodModelo],  

		TUV.ID                      [IDTipoUsoVeiculo],  

		SA.[BLINDADO]               [Blindado],  

		SA.[TURBINADO]              [Turbinado],  

		FC.ID                   	[IDFormaContratacao],  

		CF.ID                    	[IDTipoFranquia],  

		[DANOS_MATERIAIS]          	[CobDanosMateriais],  

		[DANOS_MORAIS]             	[CobDanosMorais],  

		[DANOS_CORPORAIS]          	[CobDanosCorporais],  

		[ASSIS_24_HRS]             	[IDAss24h],  

		[CARRO_RESERVA]            	[IDCarroReserva],  

		TCR.ID   	                [IDTipoCarroReserva],  

		[APP_PASSAGEIRO]           	[CobApp],  

		[DESP_MEDICO_HOSP]         	[DespesasMedHosp],  

		[LANT_FAROIS_RETROVIS]     	[CobLantFarRetro],  

		[VIDROS]                   	[CobVidros],  

		[DESP_EXTRAORDINARIAS]     	[CobDespesasExtras],  

		[RESPOND_QAR]              	[QRRespondido],  

		PQR.ID                  	[IDPerfil_Qar],  

		TRS.ID             	        [IDTipoRelacaoSegurado],  

		MQP.ID                      [IDFaixaMediaKMParticular],  

		MQC.ID        	            [IDFaixaMediaKMComercial],  

		[ESTENDER_COB_PARA_MENORES]	EstendeCoberturaMenores,  

		[PREMIO_BRUTO]             	[ValorPremio],  

		[PRECISA_VISTORIA]         	[PrecisaVistoria],  

		FP1.ID     	                [IDFormaPagtoParcela1],  

		FPD.ID                      [IDFormaPagtoDemaisParcelas],

		[QTDE_PARCELAS]             [QtdParcelas], 

		SA.[EMAIL]                  [Email], 

		[CHASSI]                    [Chassis], 

		--[MODELO_VEICULO]            [Modelo], 

		[PLACA_VEICULO]             [Placa], 

		[CARROCERIA]                [Carroceria], 

		[COD_FIPE]                  [CodigoFIPE],  --- ***********************************************************

		V.ID                        [IDVeiculo],

		[VALOR_FIPE]                [ValorFIPE], 

		[PRODUTO_MULHER]            [ProdutoMulher], 

		[PRODUTO_0KM]               [Produto0KM], 

		[ISEN_FRANQ_1_SINISTRO]     [IsentoFran1Sin], 

		[ISEN_FRANQ_EQUIP]          [IsentoFranEquip], 

		[ISEN_FRANQ_CARROC]         [IsentoFranCarroc], 

		--[APOLICE_ANTERIOR]          [NumeroApoliceAnterior],

		CNT.ID                      [IDContratoAnterior],

		--[PROPOSTA]                  [NumeroProposta],

		PRP.ID                      [IDProposta],

		[APELIDO]                   [Apelido],

		DataNascimentoPrincipalCondutor, 

		EstadoCivilPrincipalCondutor, 

		PrincipalCondutorTrabalha, 

		PrincipalCondutorEstuda, 

		CadastroOpcionais, 

		ValorFranquia,



		SA.TIPO_COMBUSTIVEL,

		SA.UFPLACA,

		SA.CEPResidenciaEOMesmo,

		SA.GuardaVeiculoGaragem,

		SA.CPFPrincipalCondutor,

		SA.NomePrincipalCondutor,

		SA.SexoPrincipalCondutor,

		NomeUsuarioLogado,

		CPFUsuarioLogado 



	FROM [dbo].[SIMULADOR_AUTO_TEMP] SA

	LEFT JOIN Dados.SituacaoCalculo SC

	ON SC.Descricao = SA.[SITUACAO_CALCULO]

	LEFT JOIN Dados.Unidade U

	ON SA.[AGENCIA_VENDA] = U.Codigo

	LEFT JOIN Dados.TipoCliente TC

	--ON TC.Descricao = SA.DESC_TIPO_CLIENTE

		ON TC.Codigo = SA.TIPO_CLIENTE --Egler - 22/10/2014

	LEFT JOIN Dados.Funcionario F

	ON F.Matricula = SA.[MATRICULA_INDICADOR]

	AND F.IDEmpresa = 1

	LEFT JOIN Dados.EstadoCivil EC

	ON EC.Descricao = SA.ESTADO_CIVIL

	LEFT JOIN Dados.TipoSeguro TS

	ON TS.Descricao = SA.TIPO_SEGURO

	LEFT JOIN Dados.Sexo S

	ON S.Descricao = SA.SEXO

	LEFT JOIN Dados.ClasseBonus CB

	ON CB.ID = ISNULL(BONUS_ANTERIOR,0)

	LEFT JOIN Dados.TipoUsoVeiculo TUV

	ON TUV.Descricao = SA.USO_VEICULO

	LEFT JOIN Dados.FormaContratacao FC

	ON FC.Descricao = SA.FORMA_CONTRATACAO

	LEFT JOIN Dados.ClasseFranquia CF

	ON CF.Descricao = SA.FRANQUIA

	LEFT JOIN Dados.TipoCarroReserva TCR

	ON TCR.Descricao = SA.GARANTIA_CARRO_RESERVA

	LEFT JOIN Dados.PerfilQuestionarioRisco PQR

	ON PQR.Descricao = SA.PERFIL_QAR

	LEFT JOIN Dados.TipoRelacaoSegurado TRS

	ON TRS.Descricao = SA.RELACAO_COND_SEGURADO

	LEFT JOIN Dados.MediaQuilometragem MQP

	ON MQP.Descricao = SA.KM_MEDIA_PARTICULAR

	LEFT JOIN Dados.MediaQuilometragem MQC

	ON MQC.Descricao = SA.KM_MEDIA_COMERCIAL

	LEFT JOIN Dados.FormaPagamento FP1

	ON FP1.Descricao = SA.[FORMA_PGTO_1_PARCELA]

	LEFT JOIN Dados.FormaPagamento FPD

	ON FPD.Descricao = SA.[FORMAT_PGTO_DEMAIS_PARCELAS]

	LEFT JOIN Dados.Proposta PRP

	ON PRP.NumeroProposta = SA.NumeroPropostaTratado

	LEFT JOIN Dados.Contrato CNT

	ON CNT.NumeroContrato = SA.APOLICE_ANTERIOR

	LEFT JOIN Dados.Veiculo V

	ON V.Nome = SA.MODELO_VEICULO

	--WHERE NUMERO_DO_CALCULO = 1920906 AND DATA_CALCULO =  '2014-05-18'





) AS S

     ON T.NumeroCalculo = S.NumeroCalculo 

	AND T.DataCalculo = S.DataCalculo

	AND T.DataArquivo = S.DataArquivo

WHEN MATCHED THEN

	UPDATE

		SET  [DataArquivo]              = COALESCE(S.[DataArquivo], T.[DataArquivo])

		    ,[Arquivo]                  = COALESCE(S.[Arquivo], T.[Arquivo])

			--,[NumeroCalculo]            = COALESCE(S., T.)

			--,[DataCalculo]              = COALESCE(S., T.)

			,[IDSituacaoCalculo]	    = COALESCE(S.[IDSituacaoCalculo], T.[IDSituacaoCalculo])

			,[DataInicioVigencia]	    = COALESCE(S.[DataInicioVigencia], T.[DataInicioVigencia])

			,[IDAgenciaVenda]           = COALESCE(S.[IDAgenciaVenda], T.[IDAgenciaVenda])

			,IDIndicador			    = COALESCE(S.IDIndicador, T.IDIndicador)

			,[CPFCNPJ]				    = COALESCE(S.[CPFCNPJ], T.[CPFCNPJ])

			,[NomeCliente]              = COALESCE(S.[NomeCliente], T.[NomeCliente])

			,[IDEstadoCivil]		    = COALESCE(S.[IDEstadoCivil], T.[IDEstadoCivil])

			,[TipoPessoa]			    = COALESCE(S.[TipoPessoa], T.[TipoPessoa])

			,[IDTipoCliente]            = COALESCE(S.[IDTipoCliente], T.[IDTipoCliente])

			,[IDTipoSeguro]			    = COALESCE(S.[IDTipoSeguro], T.[IDTipoSeguro])

			,[IDSexo]				    = COALESCE(S.[IDSexo], T.[IDSexo])

			,[DDDTelefoneContato]       = COALESCE(S.[DDDTelefoneContato], T.[DDDTelefoneContato])

			,[TelefoneContato]		    = COALESCE(S.[TelefoneContato], T.[TelefoneContato])

			,[DataNascimento]		    = COALESCE(S.[DataNascimento], T.[DataNascimento])

			,[IDClasseBonusAnterior]    = COALESCE(S.[IDClasseBonusAnterior], T.[IDClasseBonusAnterior])

			,[CEP]					    = COALESCE(S.[CEP], T.[CEP])

			,[UF]					    = COALESCE(S.[UF], T.[UF])

			,[Cidade]                   = COALESCE(S.[Cidade], T.[Cidade])

			,[Ano]					    = COALESCE(S.[Ano], T.[Ano])

			,[CodModelo]			    = COALESCE(S.[CodModelo], T.[CodModelo])

			,[IDTipoUsoVeiculo]         = COALESCE(S.[IDTipoUsoVeiculo], T.[IDTipoUsoVeiculo]) 

			,[Blindado]				    = COALESCE(S.[Blindado], T.[Blindado])

			,[Turbinado]			    = COALESCE(S.[Turbinado], T.[Turbinado])

			,[IDFormaContratacao]       = COALESCE(S.[IDFormaContratacao], T.[IDFormaContratacao])

			,[IDTipoFranquia]		    = COALESCE(S.[IDTipoFranquia], T.[IDTipoFranquia])

			,[CobDanosMateriais]	    = COALESCE(S.[CobDanosMateriais], T.[CobDanosMateriais])

			,[CobDanosMorais]           = COALESCE(S.[CobDanosMorais], T.[CobDanosMorais])

			,[CobDanosCorporais]	    = COALESCE(S.[CobDanosCorporais], T.[CobDanosCorporais])

			,IDAss24h				    = COALESCE(S.[IDAss24h], T.[IDAss24h])

			,IDCarroReserva             = COALESCE(S.IDCarroReserva, T.IDCarroReserva)

			,[IDTipoCarroReserva]	    = COALESCE(S.[IDTipoCarroReserva], T.[IDTipoCarroReserva])

			,CobAPP					    = COALESCE(S.CobAPP, T.CobAPP)

			,DespesasMedHosp            = COALESCE(S.DespesasMedHosp, T.DespesasMedHosp)

			,CobLantFarRetro		    = COALESCE(S.CobLantFarRetro, T.CobLantFarRetro)

			,CobVidros				    = COALESCE(S.CobVidros, T.CobVidros)

			,CobDespesasExtras          = COALESCE(S.CobDespesasExtras, T.CobDespesasExtras)

			,[QRRespondido]			    = COALESCE(S.[QRRespondido], T.[QRRespondido])

			,IDPerfil_Qar			    = COALESCE(S.IDPerfil_Qar, T.IDPerfil_Qar)

			,[IDTipoRelacaoSegurado]    = COALESCE(S.[IDTipoRelacaoSegurado], T.[IDTipoRelacaoSegurado])

			,IDFaixaMediaKMParticular   = COALESCE(S.IDFaixaMediaKMParticular, T.IDFaixaMediaKMParticular)

			,IDFaixaMediaKMComercial    = COALESCE(S.IDFaixaMediaKMComercial, T.IDFaixaMediaKMComercial)

			,EstendeCoberturaMenores    = COALESCE(S.EstendeCoberturaMenores, T.EstendeCoberturaMenores)

			,[ValorPremio]			    = COALESCE(S.[ValorPremio], T.[ValorPremio])

			,ValorFIPE				    = COALESCE(S.ValorFIPE, T.ValorFIPE)

			,[PrecisaVistoria]             = COALESCE(S.[PrecisaVistoria], T.[PrecisaVistoria])

			,[IDFormaPagtoParcela1]		   = COALESCE(S.[IDFormaPagtoParcela1], T.[IDFormaPagtoParcela1])

			,[IDFormaPagtoDemaisParcelas]  = COALESCE(S.[IDFormaPagtoDemaisParcelas], T.[IDFormaPagtoDemaisParcelas])

			,QtdParcelas                = COALESCE(S.QtdParcelas, T.QtdParcelas)

			,[ProdutoMulher]		    = COALESCE(S.[ProdutoMulher], T.[ProdutoMulher])

			,Produto0KM				    = COALESCE(S.Produto0KM, T.Produto0KM)

			,EMail                      = COALESCE(S.EMail, T.EMail)

			,Chassis				    = COALESCE(S.Chassis, T.Chassis)

			,PLaca					    = COALESCE(S.PLaca, T.PLaca)

			,Carroceria                 = COALESCE(S.Carroceria, T.Carroceria)

			,CodigoFIPE                 = COALESCE(S.CodigoFIPE, T.CodigoFIPE)

			,IDVeiculo				    = COALESCE(S.IDVeiculo, T.IDVeiculo)

			,IsentoFran1Sin			    = COALESCE(S.IsentoFran1Sin, T.IsentoFran1Sin)

			,IsentoFranEquip       = COALESCE(S.IsentoFranEquip, T.IsentoFranEquip)

			,IsentoFranCarroc		    = COALESCE(S.IsentoFranCarroc, T.IsentoFranCarroc)

			,IDProposta				    = COALESCE(S.IDProposta, T.IDProposta)

			,IDContratoAnterior         = COALESCE(S.IDContratoAnterior, T.IDContratoAnterior)

			,Apelido				    = COALESCE(S.Apelido, T.Apelido)

			,DataNascimentoPrincipalCondutor = COALESCE(S.DataNascimentoPrincipalCondutor, T.DataNascimentoPrincipalCondutor)

			,EstadoCivilPrincipalCondutor = COALESCE(S.EstadoCivilPrincipalCondutor, T.EstadoCivilPrincipalCondutor)

			,PrincipalCondutorTrabalha = COALESCE(S.PrincipalCondutorTrabalha, T.PrincipalCondutorTrabalha)

			,PrincipalCondutorEstuda = COALESCE(S.PrincipalCondutorEstuda, T.PrincipalCondutorEstuda)

			,CadastroOpcionais = COALESCE(S.CadastroOpcionais, T.CadastroOpcionais)

			,ValorFranquia = COALESCE(S.ValorFranquia, T.ValorFranquia)

			

			,TIPO_COMBUSTIVEL = COALESCE(S.TIPO_COMBUSTIVEL, T.TIPO_COMBUSTIVEL)

			,UFPLACA = COALESCE(S.UFPLACA, T.UFPLACA)

			,CEPResidenciaEOMesmo = COALESCE(S.CEPResidenciaEOMesmo, T.CEPResidenciaEOMesmo)

			,GuardaVeiculoGaragem = COALESCE(S.GuardaVeiculoGaragem, T.GuardaVeiculoGaragem)

			,CPFPrincipalCondutor = COALESCE(S.CPFPrincipalCondutor, T.CPFPrincipalCondutor)

			,NomePrincipalCondutor = COALESCE(S.NomePrincipalCondutor, T.NomePrincipalCondutor)

			,SexoPrincipalCondutor = COALESCE(S.SexoPrincipalCondutor, T.SexoPrincipalCondutor)

			,NomeUsuarioLogado = COALESCE(S.NomeUsuarioLogado, T.NomeUsuarioLogado)

			,CPFUsuarioLogado = COALESCE(S.CPFUsuarioLogado, T.CPFUsuarioLogado)
			 





WHEN NOT MATCHED THEN				   

	INSERT ( [DataArquivo],[Arquivo],[NumeroCalculo],[DataCalculo],[IDSituacaoCalculo],[DataInicioVigencia],[IDAgenciaVenda],

			 IDIndicador,[CPFCNPJ],[NomeCliente],[IDEstadoCivil],[TipoPessoa],[IDTipoCliente],[IDTipoSeguro],[IDSexo],

			 [DDDTelefoneContato],[TelefoneContato],[DataNascimento],[IDClasseBonusAnterior],[CEP],[UF],[Cidade],[Ano],[CodModelo],[IDTipoUsoVeiculo],[Blindado],

			 [Turbinado],[IDFormaContratacao],[IDTipoFranquia],[CobDanosMateriais],[CobDanosMorais],[CobDanosCorporais],IDAss24h,IDCarroReserva,

			 [IDTipoCarroReserva],CobAPP,DespesasMedHosp,CobLantFarRetro,CobVidros,CobDespesasExtras,

			 [QRRespondido],IDPerfil_Qar,[IDTipoRelacaoSegurado],IDFaixaMediaKMParticular,IDFaixaMediaKMComercial,EstendeCoberturaMenores,[ValorPremio],ValorFIPE,

			 [PrecisaVistoria],[IDFormaPagtoParcela1],[IDFormaPagtoDemaisParcelas],QtdParcelas, [ProdutoMulher], Produto0KM, EMail,

			 Chassis, PLaca, Carroceria, IDVeiculo, IsentoFran1Sin, IsentoFranEquip, IsentoFranCarroc, IDProposta, IDContratoAnterior, Apelido, 

			 DataNascimentoPrincipalCondutor, EstadoCivilPrincipalCondutor, PrincipalCondutorTrabalha,  PrincipalCondutorEstuda, CadastroOpcionais, ValorFranquia,

			 TIPO_COMBUSTIVEL, UFPLACA, CEPResidenciaEOMesmo, GuardaVeiculoGaragem, CPFPrincipalCondutor, NomePrincipalCondutor, SexoPrincipalCondutor, CodigoFIPE,

			 [NomeUsuarioLogado],[CPFUsuarioLogado]

			 )

			 			 

	VALUES ( S.[DataArquivo],S.[Arquivo],[NumeroCalculo],[DataCalculo],[IDSituacaoCalculo],[DataInicioVigencia],[IDAgenciaVenda],

			 S.[IDIndicador],[CPFCNPJ],S.[NomeCliente],S.[IDEstadoCivil],S.[TipoPessoa],S.[IDTipoCliente],S.[IDTipoSeguro],S.[IDSexo],

			 S.[DDDTelefoneContato],S.[TelefoneContato],S.[DataNascimento],S.[IDClasseBonusAnterior],S.[CEP],S.[UF],S.[Cidade],S.[Ano],S.[CodModelo],S.[IDTipoUsoVeiculo],S.[Blindado],

			 S.[Turbinado],S.[IDFormaContratacao],S.[IDTipoFranquia],S.[CobDanosMateriais],S.[CobDanosMorais],S.[CobDanosCorporais],S.[IDAss24h],S.[IDCarroReserva],

			 S.[IDTipoCarroReserva],S.[CobAPP],S.[DespesasMedHosp],S.CobLantFarRetro,S.[CobVidros],S.[CobDespesasExtras],

			 S.[QRRespondido],S.[IDPerfil_Qar],S.[IDTipoRelacaoSegurado],S.[IDFaixaMediaKMParticular],S.[IDFaixaMediaKMComercial],S.EstendeCoberturaMenores,S.[ValorPremio],ValorFIPE,

			 S.[PrecisaVistoria],S.[IDFormaPagtoParcela1],S.[IDFormaPagtoDemaisParcelas],S.[QtdParcelas], S.[ProdutoMulher], S.Produto0KM, S.EMail,

			 S.Chassis, S.PLaca, S.Carroceria, S.IDVeiculo, S.IsentoFran1Sin, S.IsentoFranEquip, S.IsentoFranCarroc, S.IDProposta, S.IDContratoAnterior, S.Apelido,

			 S.DataNascimentoPrincipalCondutor, S.EstadoCivilPrincipalCondutor, S.PrincipalCondutorTrabalha,  S.PrincipalCondutorEstuda, S.CadastroOpcionais, S.ValorFranquia,

			 S.TIPO_COMBUSTIVEL, S.UFPLACA, S.CEPResidenciaEOMesmo, S.GuardaVeiculoGaragem, S.CPFPrincipalCondutor, S.NomePrincipalCondutor, S.SexoPrincipalCondutor, S.CodigoFIPE,

			S.NomeUsuarioLogado,S.CPFUsuarioLogado);

			
			--Aqui

/*************************************************************************************/

/*Atualização do Ponto de Parada, Maior Código*/

/*************************************************************************************/

SET @PontoDeParada = @MaiorCodigo

  

UPDATE ControleDados.PontoParada 

SET PontoParada = @MaiorCodigo

WHERE NomeEntidade = 'SIMULADOR_AUTO'





TRUNCATE TABLE [dbo].SIMULADOR_AUTO_TEMP 

    

/*********************************************************************************************************************/               

/*Recuperação do Maior Código*/

/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[SIMULADOR_AUTO_TEMP] 

						( 

							[Codigo],

							[ControleVersao],                                                               

							[NomeArquivo],                                                                  

							[DataArquivo],                                                                  

							[NUMERO_DO_CALCULO],                                                            

							[DATA_CALCULO],                                                                 

							[SITUACAO_CALCULO],                                                             

							[DATA_INI_VIGENCIA],                                                            

							[AGENCIA_VENDA],                                                             

							[MATRICULA_INDICADOR],                                                          

							[CPFCNPJ],                                                                      

							[NOME],                                                                         

							[TIPO_PESSOA],                                                                  

							[TIPO_CLIENTE],                                                                 

							[DESC_TIPO_CLIENTE],                                                            

							[TIPO_SEGURO],                                                                  

							[SEXO],                                                                         

							[DDD],                                                                          

							[TELEFONE],                                                                     

							[DATA_NASC],                                                                    

							[BONUS_ANTERIOR],                                                               

							[CEP],                                                                          

							[UF],                                                                           

							[CIDADE],                                                                       

							[ANO_MODELO],                                                                   

							[COD_MODELO],                                                                   

							[USO_VEICULO],                                                                  

							[BLINDADO],                                                                     

							[TURBINADO],                                                                    

							[FORMA_CONTRATACAO],                                                            

							[FRANQUIA],                                                                     

							[DANOS_MATERIAIS],                                                              

							[DANOS_MORAIS],            

							[DANOS_CORPORAIS],                                                              

							[ASSIS_24_HRS],                                                                 

							[CARRO_RESERVA],                                                                

							[GARANTIA_CARRO_RESERVA],                                                       

							[APP_PASSAGEIRO],                                                               

							[DESP_MEDICO_HOSP],                                                             

							[LANT_FAROIS_RETROVIS],                                                         

							[VIDROS],                                                                       

							[DESP_EXTRAORDINARIAS],                                                         

							[RESPOND_QAR],                                                                  

							[PERFIL_QAR],                                                                   

							[RELACAO_COND_SEGURADO],                                                        

							[ESTADO_CIVIL],                                                                 

							[KM_MEDIA_PARTICULAR],                                                          

							[KM_MEDIA_COMERCIAL],                                                           

							[ESTENDER_COB_PARA_MENORES],                                                    

							[PREMIO_BRUTO],                                                                 

							[PRECISA_VISTORIA],                                                             

							[FORMA_PGTO_1_PARCELA],                                                         

							[FORMAT_PGTO_DEMAIS_PARCELAS],                                                  

							[QTDE_PARCELAS],                                                                

							[EMAIL],                                                                        

							[CHASSI],                                                                       

							[MODELO_VEICULO],                                                               

							[PLACA_VEICULO],                                                                

							[CARROCERIA],                                                                   

							[COD_FIPE],                                                                     

							[VALOR_FIPE],                                                                   

							[PRODUTO_MULHER],                                                               

							[PRODUTO_0KM],                                                                  

							[ISEN_FRANQ_1_SINISTRO],                                                        

							[ISEN_FRANQ_EQUIP],                                                             

							[ISEN_FRANQ_CARROC],                                                            

							[APOLICE_ANTERIOR],                                                             

							[PROPOSTA],                                                                     

							[APELIDO],



							DataNascimentoPrincipalCondutor, 

							EstadoCivilPrincipalCondutor, 

							PrincipalCondutorTrabalha, 

							PrincipalCondutorEstuda, 

							CadastroOpcionais, 

							ValorFranquia

														                                                                      

					   )

					   SELECT 

                      		[Codigo],

							[ControleVersao],                                                               

							[NomeArquivo],                                                                  

							[DataArquivo],                                                                  

							[NUMERO_DO_CALCULO],                                                            

							[DATA_CALCULO],                                                                 

							[SITUACAO_CALCULO],                                

							[DATA_INI_VIGENCIA],                                                            

							[AGENCIA_VENDA],                                                               

							[MATRICULA_INDICADOR],                                                          

							[CPFCNPJ],                                                                      

							[NOME],                                                                         

							[TIPO_PESSOA],                                                                  

							[TIPO_CLIENTE],                                                                 

							[DESC_TIPO_CLIENTE],                                                            

							[TIPO_SEGURO],                                                                  

							[SEXO],                                                                         

							[DDD],                                                                          

							[TELEFONE],                                                                     

							[DATA_NASC],                                                                    

							[BONUS_ANTERIOR],                                                               

							[CEP],                                                                          

							[UF],                                                                           

							[CIDADE],                                                                       

							[ANO_MODELO],                                                                   

							[COD_MODELO],                                                                   

							[USO_VEICULO],                                                                  

							[BLINDADO],                                                                     

							[TURBINADO],                                                                    

							[FORMA_CONTRATACAO],                                                            

							[FRANQUIA],                                                                     

							[DANOS_MATERIAIS],                                                              

							[DANOS_MORAIS],                                                                 

							[DANOS_CORPORAIS],                                                              

							[ASSIS_24_HRS],                                                                 

							[CARRO_RESERVA],                                                                

							[GARANTIA_CARRO_RESERVA],                                                       

							[APP_PASSAGEIRO],                                                               

							[DESP_MEDICO_HOSP],                                                             

							[LANT_FAROIS_RETROVIS],                                                         

							[VIDROS],                                                                       

							[DESP_EXTRAORDINARIAS],                                                         

							[RESPOND_QAR],                                                                  

							[PERFIL_QAR],                                                                   

							[RELACAO_COND_SEGURADO],                                                        

							[ESTADO_CIVIL],                                                                 

							[KM_MEDIA_PARTICULAR],                                                          

							[KM_MEDIA_COMERCIAL],                                                           

							[ESTENDER_COB_PARA_MENORES],                                                    

							[PREMIO_BRUTO],                                                                 

							[PRECISA_VISTORIA],                                                             

							[FORMA_PGTO_1_PARCELA],                                    

							[FORMAT_PGTO_DEMAIS_PARCELAS],                                                  

							[QTDE_PARCELAS],                                                                

							[EMAIL],                                                                        

							[CHASSI],                                                                       

							[MODELO_VEICULO],                                                               

							[PLACA_VEICULO],                                                                

							[CARROCERIA],                                                                   

							[COD_FIPE],                                                                     

							[VALOR_FIPE],                                                                   

							[PRODUTO_MULHER],                                                               

							[PRODUTO_0KM],                                                                  

							[ISEN_FRANQ_1_SINISTRO],                                                        

							[ISEN_FRANQ_EQUIP],                                                             

							[ISEN_FRANQ_CARROC],                                                            

							[APOLICE_ANTERIOR],                                                             

							[PROPOSTA],                                                                     

							[APELIDO],



							DataNascimentoPrincipalCondutor, 

							EstadoCivilPrincipalCondutor, 

							PrincipalCondutorTrabalha, 

							PrincipalCondutorEstuda, 

							CadastroOpcionais, 

							ValorFranquia

						FROM OPENQUERY ([OBERON], 

						''EXEC [FENAE].[Corporativo].[proc_RecuperaSIMULADOR_AUTO] ''''' + @PontoDeParada + ''''''') SA'



EXEC (@COMANDO)     



SELECT @MaiorCodigo = MAX(Codigo)

FROM dbo.SIMULADOR_AUTO_TEMP

                

END



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SIMULADOR_AUTO_TEMP]') AND type IN (N'U') /*ORDER BY NAME*/)

	DROP TABLE [dbo].SIMULADOR_AUTO_TEMP;			



END TRY                

BEGIN CATCH

	

  EXEC CleansingKit.dbo.proc_RethrowError	

  RETURN @@ERROR	



END CATCH





--	EXEC Corporativo.Dados.[proc_InsereSimulador_AUTO]








