

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereOdonto_ODS]
	
	Descrição: Procedimento que realiza a inserção das propostas Odonto no ODS

	Parâmetros de entrada:
	
SELECT * FROM dbo.DmSegmento					
	Retorno:


*******************************************************************************/
CREATE  PROCEDURE [Dados].[proc_InsereOdonto_ODS]
AS

BEGIN TRY		
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Odonto_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Odonto_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Odonto_TEMP]
(
	[ID] [int]  NOT NULL,
 	[NOME_SUBESTIPULANTE] [varchar](200) NULL,
	[CODIGO_SEGURADO] [varchar](50) NULL,
	[CPF_SEGURADO] [varchar](14) NULL,
	[CPF_TITULAR] [varchar](14) NULL,
	[NOME_SEGURADO] [varchar](150) NULL,
	[ELEGIBILIDADE_SEGURADO] [varchar](50) NULL,
	[SITUACAO_SEGURADO] [varchar](50) NULL,
	[DATA_CANCELAMENTO] [date] NULL,
	[GRAU_PARENTESCO] [varchar](50) NULL,
	[DATA_NASCIMENTO] [date] NULL,
	[DATA_ADESAO] [date] NULL,
	[SEXO] [varchar](30) NULL,
	[NUMERO_PROPOSTA] [varchar](50) NULL,
	[ESTADO_CIVIL] [varchar](50) NULL,
	[FORMA_PAGAMENTO] [varchar](50) NULL,
	[MODALIDADE] [varchar](50) NULL,
	[DDD_TELEFONE] [varchar](50) NULL,
	[TELEFONE_1] [varchar](50) NULL,
	[TIPO_TELEFONE_1] [varchar](50) NULL,
	[TELEFONE_2] [varchar](50) NULL,
	[TIPO_TELEFONE_2] [varchar](50) NULL,
	[TELEFONE_3] [varchar](50) NULL,
	[TIPO_TELEFONE_3] [varchar](50) NULL,
	[CEP] [varchar](50) NULL,
	[LOGRADOURO] [varchar](200) NULL,
	[NUMERO] [varchar](200) NULL,
	[COMPLEMENTO] [varchar](200) NULL,
	[BAIRRO] [varchar](200) NULL,
	[LOCALIDADE] [varchar](200) NULL,
	[UF] [varchar](50) NULL,
	[EMAIL] [varchar](200) NULL,
	[BANCO] [varchar](150) NULL,
	[NUMERO_AGENCIA] [varchar](50) NULL,
	[UF_AGENCIA] [varchar](50) NULL,
	[CODIGO_PLANO] [varchar](50) NULL,
	[NOME_PLANO] [varchar](100) NULL,
	[INICIO_VIGENCIA] [DATE] NOT NULL,
	[FIM_VIGENCIA] [DATE]   NULL,
	[VALOR_MENSAL] [varchar](50) NULL,
	[DATA_ARQUIVO] [date] NOT NULL,
	[NOME_ARQUIVO] [varchar](150) NOT NULL
) 



 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_ConsignadoCPFSegurado_TEMP ON [dbo].[Odonto_TEMP] ([CPF_SEGURADO] ASC)  


CREATE NONCLUSTERED INDEX idx_ConsignadoCPFTitular_TEMP ON [dbo].[Odonto_TEMP] ([CPF_TITULAR] ASC)  

CREATE NONCLUSTERED INDEX idx_Consignado_Data_TEMP ON [dbo].[Odonto_TEMP] ([CPF_SEGURADO] ASC)  
INCLUDE ([DATA_ADESAO]);

CREATE NONCLUSTERED INDEX [ncl_idx_numprp_odonto]
ON [dbo].[Odonto_TEMP] ([NUMERO_PROPOSTA])
INCLUDE ([NOME_SUBESTIPULANTE],[CODIGO_SEGURADO],[CPF_SEGURADO],[NOME_SEGURADO],[ELEGIBILIDADE_SEGURADO],[SITUACAO_SEGURADO],
[GRAU_PARENTESCO],[SEXO],[ESTADO_CIVIL],[MODALIDADE],[CODIGO_PLANO],[INICIO_VIGENCIA],[FIM_VIGENCIA],[VALOR_MENSAL],[DATA_ARQUIVO],[NOME_ARQUIVO])

CREATE NONCLUSTERED INDEX idx_Consignado_DataArquivo_TEMP ON [dbo].[Odonto_TEMP] ([CPF_SEGURADO],[DATA_ARQUIVO] ASC)  



CREATE NONCLUSTERED INDEX idx_Consignado_GrauParentesco_TEMP ON [dbo].[Odonto_TEMP] ([GRAU_PARENTESCO]) INCLUDE ([DATA_ADESAO],[NUMERO_PROPOSTA],[FIM_VIGENCIA]
																										,[VALOR_MENSAL]	,[DATA_ARQUIVO],[NOME_ARQUIVO],[CPF_TITULAR])


/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Odonto'


/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Odonto_TEMP]
				(    [ID]
					  ,[NOME_SUBESTIPULANTE]
					  ,[CODIGO_SEGURADO]
					  ,[CPF_SEGURADO]
					  ,[CPF_TITULAR]
					  ,[NOME_SEGURADO]
					  ,[ELEGIBILIDADE_SEGURADO]
					  ,[SITUACAO_SEGURADO]
					  ,[DATA_CANCELAMENTO]
					  ,[GRAU_PARENTESCO]
					  ,[DATA_NASCIMENTO]
					  ,[DATA_ADESAO]
					  ,[SEXO]
					  ,[NUMERO_PROPOSTA]
					  ,[ESTADO_CIVIL]
					  ,[FORMA_PAGAMENTO]
					  ,[MODALIDADE]
					  ,[DDD_TELEFONE]
					  ,[TELEFONE_1]
					  ,[TIPO_TELEFONE_1]
					  ,[TELEFONE_2]
					  ,[TIPO_TELEFONE_2]
					  ,[TELEFONE_3]
					  ,[TIPO_TELEFONE_3]
					  ,[CEP]
					  ,[LOGRADOURO]
					  ,[NUMERO]
					  ,[COMPLEMENTO]
					  ,[BAIRRO]
					  ,[LOCALIDADE]
					  ,[UF]
					  ,[EMAIL]
					  ,[BANCO]
					  ,[NUMERO_AGENCIA]
					  ,[UF_AGENCIA]
					  ,[CODIGO_PLANO]
					  ,[NOME_PLANO]
					  ,[INICIO_VIGENCIA]
					  ,[FIM_VIGENCIA]
					  ,[VALOR_MENSAL]
					  ,[DATA_ARQUIVO]
					  ,[NOME_ARQUIVO]

				)
				SELECT 
						[ID]
						  ,[NOME_SUBESTIPULANTE]
						  ,[CODIGO_SEGURADO]
						  ,[CPF_SEGURADO]
						  ,[CPF_TITULAR]
						  ,[NOME_SEGURADO]
						  ,[ELEGIBILIDADE_SEGURADO]
						  ,[SITUACAO_SEGURADO]
						  ,[DATA_CANCELAMENTO]
						  ,[GRAU_PARENTESCO]
						  ,[DATA_NASCIMENTO]
						  ,[DATA_ADESAO]
						  ,[SEXO]
						  ,[NUMERO_PROPOSTA]
						  ,[ESTADO_CIVIL]
						  ,[FORMA_PAGAMENTO]
						  ,[MODALIDADE]
						  ,[DDD_TELEFONE]
						  ,[TELEFONE_1]
						  ,[TIPO_TELEFONE_1]
						  ,[TELEFONE_2]
						  ,[TIPO_TELEFONE_2]
						  ,[TELEFONE_3]
						  ,[TIPO_TELEFONE_3]
						  ,[CEP]
						  ,[LOGRADOURO]
						  ,[NUMERO]
						  ,[COMPLEMENTO]
						  ,[BAIRRO]
						  ,[LOCALIDADE]
						  ,[UF]
						  ,[EMAIL]
						  ,[BANCO]
						  ,[NUMERO_AGENCIA]
						  ,[UF_AGENCIA]
						  ,[CODIGO_PLANO]
						  ,[NOME_PLANO]
						  ,[INICIO_VIGENCIA]
						  ,[FIM_VIGENCIA]
						  ,[VALOR_MENSAL]
						  ,[DataArquivo]
						  ,[NomeArquivo]
	FROM OPENQUERY ([OBERON], ''EXEC [FENAE].[Corporativo].[proc_RecuperaOdonto_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Odonto_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--begin tran
--select @@TRANCOUNT
--rollback
/**********************************************************************
Inserção dos Dados - Estado Civil
***********************************************************************/ 
MERGE INTO Dados.EstadoCivil  as T USING
(
 
	 SELECT *,(SELECT MAX(ID) FROM Dados.EstadoCivil) +ROW_NUMBER() OVER (ORDER BY Descricao) AS ID from (SELECT DISTINCT ESTADO_CIVIL as Descricao from dbo.Odonto_TEMP) X
) as S
ON S.Descricao = T.Descricao
WHEN NOT MATCHED THEN INSERT (ID,Descricao)
		VALUES (s.ID,Descricao);



/**********************************************************************
Inserção dos Dados - TipoModalidadePagamentoPropostaOdonto
***********************************************************************/ 
MERGE INTO Dados.TipoModalidadePagamentoPropostaOdonto  as T USING
(
	 SELECT DISTINCT MODALIDADE as Descricao from dbo.Odonto_TEMP
) as S
ON S.Descricao = T.Descricao
WHEN NOT MATCHED THEN INSERT (Descricao)
		VALUES (Descricao);

	
		

/**********************************************************************
Inserção dos Dados - TipoElegibilidade
***********************************************************************/ 
MERGE INTO Dados.TipoElegibilidade  as T USING
(
	 SELECT DISTINCT ELEGIBILIDADE_SEGURADO as Descricao from dbo.Odonto_TEMP
) as S
ON S.Descricao = T.Descricao
WHEN NOT MATCHED THEN INSERT (Descricao)
		VALUES (Descricao);

	
/**********************************************************************
Inserção dos Dados - TipoSituacaoSeguradoOdonto
 
***********************************************************************/ 
MERGE INTO Dados.TipoSituacaoSeguradoOdonto  as T USING
(
	 SELECT DISTINCT SITUACAO_SEGURADO as Descricao from dbo.Odonto_TEMP
) as S
ON S.Descricao = T.Descricao
WHEN NOT MATCHED THEN INSERT (Descricao)
		VALUES (Descricao);


--/**********************************************************************
--Inserção dos Dados - TipoSituacaoSeguradoOdonto
--***********************************************************************/ 
--MERGE INTO Dados.TipoSituacaoSeguradoOdonto  as T USING
--(
--	 SELECT DISTINCT SITUACAO_SEGURADO as Descricao from dbo.Odonto_TEMP
--) as S
--ON S.Descricao = T.Descricao
--WHEN NOT MATCHED THEN INSERT (Descricao)
--		VALUES (Descricao);






/**********************************************************************
Inserção dos Dados - SubEstipulante
***********************************************************************/ 
MERGE INTO Dados.PropostaOdontoSubestipulante  as T USING
(
	 SELECT DISTINCT [NOME_SUBESTIPULANTE] as Nome from dbo.Odonto_TEMP
) as S
ON S.Nome = T.Nome
WHEN NOT MATCHED THEN INSERT (Nome)
		VALUES (Nome);


		
/**********************************************************************
Inserção dos Dados - Grau de Parentesco
***********************************************************************/ 
MERGE INTO Dados.GrauParentesco  as T USING
(
	 SELECT DISTINCT GRAU_PARENTESCO as Descricao from dbo.Odonto_TEMP
) as S
ON S.Descricao = T.Descricao
WHEN NOT MATCHED THEN INSERT (Descricao)
		VALUES (Descricao);



--/**********************************************************************
--Inserção dos Dados - Unidade
--***********************************************************************/ 
--MERGE INTO Dados.Unidade  as T USING
--(
--	 SELECT DISTINCT NUMERO_AGENCIA as Codigo from dbo.Odonto_TEMP
--) as S
--ON S.Codigo = T.Codigo
--WHEN NOT MATCHED THEN INSERT (Codigo)
--		VALUES (Codigo);


/**********************************************************************
Inserção dos Dados - Plano
***********************************************************************/ 
MERGE INTO Dados.Plano  as T USING
(
	 SELECT DISTINCT CODIGO_PLANO as CodigoPlano,NOME_PLANO as NomePlano,2517 AS IDSeguradora,'00' as Empresa
		from dbo.Odonto_TEMP 
		--where NOME_PLANO not in ('L0022311','','1023','8','L0022105','L0022107',
		--						'L0022111','L0022307','L0022311','PR','RS','MG','DF')
) as S
ON S.CodigoPlano = T.CodigoPlano
WHEN NOT MATCHED THEN INSERT (CodigoPlano,NomePlano,IDSeguradora,Empresa)
		VALUES (S.CodigoPlano,S.NomePlano,s.IDSeguradora,s.Empresa);





/**********************************************************************
Inserção dos Dados - Contratos
select @@trancount
rollback
DELETE FROM Dados.Contrato where Arquivo = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
delete contrato  from Dados.Contrato  INNER JOIN dbo.Odonto_TEMP T ON Contrato.NumeroContrato = T.NUMERO_PROPOSTA AND Contrato.IDSeguradora = 18
***********************************************************************/ 
--select distinct SITUACAO_SEGURADO,ELEGIBILIDADE_SEGURADO FROM dbo.Odonto_TEMP
--;with Contrato as (SELECT [DATA_ADESAO]
--				     ,[NUMERO_PROPOSTA]
--				     ,[FIM_VIGENCIA]
--					 ,[VALOR_MENSAL]
--					 ,[DATA_ARQUIVO]
--					 ,[NOME_ARQUIVO]
--					select distinct CODIGO_SEGURADO  FROM  [dbo].[Odonto_TEMP] t
		
--		) 
	MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT [INICIO_VIGENCIA] as DataInicioVigencia
			,[NUMERO_PROPOSTA] as NumeroContrato
			,[FIM_VIGENCIA] as DataFimVigencia
			,[VALOR_MENSAL] as ValorPremioLiquido
			,[DATA_ARQUIVO] as DataArquivo
			,[NOME_ARQUIVO] as Arquivo
	        ,2517 as IDSeguradora
			,[DATA_CANCELAMENTO] as DataCancelamento
			,*
			,ROW_NUMBER() OVER (PARTITION BY NUMERO_PROPOSTA ORDER BY [DATA_ARQUIVO] desc) LINHA	 
				--,[CPF_TITULAR] as CpfSegurado
		FROM dbo.Odonto_TEMP
		WHERE GRAU_PARENTESCO = 'TITULAR' AND SITUACAO_SEGURADO <> 'Adesão Não Efetivada') X  where LINHA = 1
		) as s
		on s.NumeroContrato = t.NumeroContrato and t.IDSeguradora = 2517
		WHEN NOT MATCHED THEN INSERT (NumeroContrato,ValorPremioLiquido,DataArquivo,Arquivo,DataInicioVigencia,DataFimVigencia,IDSeguradora,DataCancelamento)
					Values(s.NumeroContrato,s.ValorPremioLiquido,s.DataArquivo,s.Arquivo,s.DataInicioVigencia,s.DataFimVigencia,s.IDSeguradora,s.DataCancelamento)
			WHEN MATCHED THEN UPDATE SET t.NumeroContrato = s.NumeroContrato,
										t.ValorPremioLiquido = s.ValorPremioLiquido,	
										t.DataArquivo = s.DataArquivo,	
										t.Arquivo = s.Arquivo,	
										t.DataInicioVigencia = s.DataInicioVigencia,	
										t.DataFimVigencia = s.DataFimVigencia,	
										t.DataCancelamento = s.DataCancelamento
									;

/**********************************************************************
Inserção dos Dados - Proposta

select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
rollback
select * from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

	MERGE INTO [Dados].[Proposta] as t
	USING
	(SELECT * FROM (SELECT [INICIO_VIGENCIA] as DataInicioVigencia
			,[NUMERO_PROPOSTA] as NumeroProposta
			,[FIM_VIGENCIA] as DataFimVigencia
			,[VALOR_MENSAL] as Valor
			,[DATA_ARQUIVO] as DataArquivo
			,[NOME_ARQUIVO] as TipoDado
			--,[CPF_TITULAR] as CpfSegurado
			,c.ID as IDContrato
	--		,u.ID as IDAgenciaVenda
			,c.IDSeguradora
			,ROW_NUMBER() OVER (PARTITION BY NUMERO_PROPOSTA ORDER BY DATA_ARQUIVO DESC) as linha
		FROM dbo.Odonto_TEMP t
		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 2517
--		inner  join Dados.Unidade u on u.Codigo = t.NUMERO_AGENCIA
		WHERE GRAU_PARENTESCO = 'TITULAR') X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
		on s.NumeroProposta = t.NumeroProposta and t.IDSeguradora = 2517
		WHEN NOT MATCHED THEN INSERT (NumeroProposta,Valor,DataArquivo,TipoDado,DataInicioVigencia,DataFimVigencia,IDContrato,IDSeguradora)
					Values(s.NumeroProposta,s.Valor,s.DataArquivo,s.TipoDado,s.DataInicioVigencia,s.DataFimVigencia,s.IDContrato,s.IDSeguradora)
			WHEN MATCHED THEN UPDATE SET t.NumeroProposta = s.NumeroProposta,
										t.Valor = s.Valor,	
										t.DataArquivo = s.DataArquivo,
										t.TipoDado= s.TipoDado,	
										t.DataInicioVigencia = s.DataInicioVigencia,	
										t.DataFimVigencia = s.DataFimVigencia;








/**********************************************************************
Atualiza IDContrato na Proposta
***********************************************************************/ 

	--MERGE INTO [Dados].[Proposta] as t
	--USING
	--(SELECT * FROM (SELECT c.ID as IDContrato
	--		,t.NUMERO_PROPOSTA as NumeroProposta
	--		,ROW_NUMBER() OVER (PARTITION BY NUMERO_PROPOSTA ORDER BY DATA_ARQUIVO DESC) as linha
	--	FROM dbo.Odonto_TEMP t
	--	INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 18
	--	WHERE NOME_PLANO not in ('L0022311','','1023','8','L0022105','L0022107',
	--							'L0022111','L0022307','L0022311','PR','RS','MG','DF') AND INICIO_VIGENCIA <> 'L0022311') X WHERE LINHA = 1
	--	) as s
	--	on s.NumeroProposta = t.NumeroProposta and t.IDSeguradora = 18
	--	WHEN MATCHED THEN UPDATE SET t.IDContrato = s.IDContrato;


/**********************************************************************
Atualiza IDProposta no Contrato
select @@trancount
***********************************************************************/ 

	MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT c.ID as IDProposta
			,t.NUMERO_PROPOSTA as NumeroProposta
			,ROW_NUMBER() OVER (PARTITION BY NUMERO_PROPOSTA ORDER BY DATA_ARQUIVO DESC) as linha
		FROM dbo.Odonto_TEMP t
		INNER JOIN Dados.Proposta c on c.NumeroProposta = t.NUMERO_PROPOSTA and c.IDSeguradora = 2517
		--WHERE NOME_PLANO not in ('L0022311','','1023','8','L0022105','L0022107',
		--						'L0022111','L0022307','L0022311','PR','RS','MG','DF') 
								) X WHERE LINHA = 1
		) as s
		on s.NumeroProposta = t.NumeroContrato and t.IDSeguradora = 2517
		WHEN MATCHED THEN UPDATE SET t.IDProposta = s.IDProposta;


		

		
/**********************************************************************
Inserção dos Dados - PropostaCliente
select @@trancount
select  max(len(email)) from #teste
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
(
	SELECT  * FROM (SELECT 
       p.ID as [IDProposta]
	   ,[NOME_SUBESTIPULANTE]
      ,[CODIGO_SEGURADO]
      ,[CPF_SEGURADO] as CPFCNPJ
      ,[CPF_TITULAR]
      ,[NOME_SEGURADO] as Nome
      ,[ELEGIBILIDADE_SEGURADO]
      ,[SITUACAO_SEGURADO]
      ,[DATA_CANCELAMENTO]
      ,[GRAU_PARENTESCO]
      ,[DATA_NASCIMENTO] as DataNascimento
      ,[DATA_ADESAO]
      --,[SEXO]
      ,[NUMERO_PROPOSTA]
      ,[ESTADO_CIVIL]
      ,[FORMA_PAGAMENTO]
      ,[MODALIDADE]
      ,[EMAIL]
      ,[INICIO_VIGENCIA]
      ,[FIM_VIGENCIA]
      ,[VALOR_MENSAL]
      ,[DATA_ARQUIVO] as DataArquivo
      ,[NOME_ARQUIVO] as TipoDado
	--  ,u.ID as IDUnidade
	  , CASE WHEN SEXO = 'M' THEN 1
			WHEN SEXO = 'F' THEN 2
			ELSE 0
		END as IDSexo
		,e.ID as IDEstadoCivil
		--,NUMERO_AGENCIA
		 ,ROW_NUMBER() OVER (PARTITION BY [NUMERO_PROPOSTA] ORDER BY DataArquivo DESC) as linha
FROM [dbo].[Odonto_TEMP] O
INNER JOIN Dados.EstadoCivil e on e.Descricao = O.ESTADO_CIVIL
INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517
--INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
where GRAU_PARENTESCO = 'TITULAR') x  where linha =1  
) as S on S.IDProposta = T.IDProposta
	WHEN NOT MATCHED THEN INSERT (IDProposta,CPFCNPJ,Nome,DataNascimento,TipoPessoa,IDSexo,IDEstadoCivil,Email,TipoDado,DataArquivo)
	VALUES(s.IDProposta,CPFCNPJ,Nome,DataNascimento,'Pessoa Física',IDSexo,IDEstadoCivil,Email,TipoDado,DataArquivo);



/**********************************************************************
Inserção dos Dados - PropostaoMeioPagamento
select @@trancount
select * from Dados.PropostaCLiente where IDProposta = 61324099
***********************************************************************/ 
--MERGE INTO Dados.PropostaMeioPagamento as T USING
--(
--	SELECT  * FROM (SELECT 
--       p.ID as [IDProposta]
	  
--      ,[NUMERO_PROPOSTA]
--      ,[FORMA_PAGAMENTO]
--      ,[DATA_ARQUIVO] as DataArquivo
--      ,[NOME_ARQUIVO] as TipoDado
--		--,NUMERO_AGENCIA
--		 ,ROW_NUMBER() OVER (PARTITION BY [NUMERO_PROPOSTA] ORDER BY DataArquivo DESC) as linha
--FROM [dbo].[Odonto_TEMP] O
--INNER JOIN Dados.EstadoCivil e on e.Descricao = O.ESTADO_CIVIL
--INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 18
----INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
--where GRAU_PARENTESCO = 'TITULAR') x  where linha =1 
--) as S on S.IDProposta = T.IDProposta
--	WHEN NOT MATCHED THEN INSERT ([IDProposta],[DiaVencimento],[DiaCorte],[FormaPagamento],[Banco],[Agencia],[Conta],[OperacaoConta])
--	VALUES(s.IDProposta,CPFCNPJ,Nome,DataNascimento,'Pessoa Física',IDSexo,IDEstadoCivil,Email,TipoDado,DataArquivo);


/**********************************************************************
Inserção dos Dados - PropostaoOdonto
select @@trancount
rollback
ALTER TABLE Dados.PropostaOdonto drop column IDMeioPagamento
select * from Dados.PropostaCLiente where IDProposta = 61324099
***********************************************************************/ 
MERGE INTO Dados.PropostaOdonto as T USING
(
	SELECT * FROM (SELECT 
       p.ID as [IDProposta]
	   ,s.ID as IDSubestipulante--[NOME_SUBESTIPULANTE] as NomeSubestipulante
      ,[CODIGO_SEGURADO] as NumeroCartao
      ,[CPF_SEGURADO] as CPF
      ,[CPF_TITULAR]
      ,[NOME_SEGURADO] as NomeSegurado
      ,te.ID as IDElegibilidade--[ELEGIBILIDADE_SEGURADO]
      ,ts.ID as IDSituacao--[SITUACAO_SEGURADO]
      ,[DATA_CANCELAMENTO]
       ,[DATA_NASCIMENTO] as DataNascimento
      --,[DATA_ADESAO]
      --,[SEXO]
      --,p.ID as IDProposta--[NUMERO_PROPOSTA]
      ,e.ID as IDEstadoCivil--[ESTADO_CIVIL]
      ,[FORMA_PAGAMENTO]
      ,tmp.ID as IDModalidadePagamento--[MODALIDADE]
      --,[EMAIL]
      ,[INICIO_VIGENCIA] as DataInicioVigencia
      ,[FIM_VIGENCIA] as DataFimVigencia
      ,[VALOR_MENSAL] as ValorMensal
      ,[DATA_ARQUIVO] as DataArquivo
      ,[NOME_ARQUIVO] as NomeArquivo
	  ,CASE WHEN SEXO = 'M' THEN 1
			WHEN SEXO = 'F' THEN 2
							ELSE 0
		 END as IDSexo
	  ,g.ID as IDGrauParentesco
	  ,pl.ID as IDPlano
	  ,o.GRAU_PARENTESCO
	  ,ROW_NUMBER() OVER (PARTITION BY [CODIGO_SEGURADO] ORDER BY DATA_ARQUIVO DESC) LINHA
FROM [dbo].[Odonto_TEMP] O
inner JOIN Dados.EstadoCivil e on e.Descricao = O.ESTADO_CIVIL
inner JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517
inner  JOIN Dados.TipoModalidadePagamentoPropostaOdonto tmp on O.MODALIDADE = tmp.Descricao
inner  JOIN Dados.TipoElegibilidade  te on O.ELEGIBILIDADE_SEGURADO = te.Descricao
inner  JOIN Dados.TipoSituacaoSeguradoOdonto ts on ts.Descricao = O.SITUACAO_SEGURADO
inner  JOIN Dados.PropostaOdontoSubestipulante s on s.Nome = O.NOME_SUBESTIPULANTE
inner  JOIN Dados.GrauParentesco g on g.Descricao = O.[GRAU_PARENTESCO]
inner  JOIN Dados.Plano pl on pl.CodigoPlano = O.[CODIGO_PLANO] ) X WHERE LINHA = 1 -- and IDProposta is null
) as S on S.IDProposta = T.IDProposta
	WHEN NOT MATCHED THEN INSERT (IDProposta,IDSubestipulante,NomeSegurado,CPF,IDElegibilidade,IDGrauParentesco,IDSituacao,IDSexo,IDEstadoCivil,IDModalidadePagamento,IDPlano,
				ValorMensal,NumeroCartao,DataInicioVigencia,DataFimVigencia,NomeArquivo,DataArquivo)
	VALUES(IDProposta,IDSubestipulante,NomeSegurado,CPF,IDElegibilidade,IDGrauParentesco,IDSituacao,IDSexo,IDEstadoCivil,IDModalidadePagamento,IDPlano,
				ValorMensal,NumeroCartao,DataInicioVigencia,DataFimVigencia,NomeArquivo,DataArquivo);


			



/**********************************************************************
Atualiza o Telefone Comercial  na tabela Dados - PropostaCliente
rollback
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
( 
	SELECT * FROM (SELECT  pc.ID,O.*,ROW_NUMBER() OVER (PARTITION BY p.ID order by p.ID desc) as linha FROM (SELECT DDD_TELEFONE as DDDComercial,
						TELEFONE_1 as TelefoneComercial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_1 = 'COM'
				UNION
				SELECT DDD_TELEFONE as DDDComercial,
						TELEFONE_2 as TelefoneComercial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_2 = 'COM'
				UNION
				SELECT DDD_TELEFONE as DDDComercial,
						TELEFONE_3 as TelefoneComercial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_3 = 'COM'
				) O
	INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517	
	INNER JOIN Dados.PropostaCliente pc on p.ID = pc.IDProposta) X where linha = 1 and len(TelefoneComercial) < 11
) as S on S.ID = T.ID
	WHEN MATCHED THEN UPDATE  SET T.[DDDComercial] = S.[DDDComercial],
									T.[TelefoneComercial] = S.[TelefoneComercial];

/**********************************************************************
Atualiza o Telefone Celular na tabela Dados - PropostaCliente
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
( 
	select * from ( SELECT  pc.ID,O.DDDCelular,Replace(O.TelefoneCelular,'-','') AS TelefoneCelular,O.NUMERO_PROPOSTA,ROW_NUMBER() OVER (PARTITION BY p.ID order by p.ID desc) as linha FROM (SELECT DDD_TELEFONE as DDDCelular,
						TELEFONE_1 as TelefoneCelular,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_1 = 'CEL'
				UNION
				SELECT DDD_TELEFONE as DDDCelular,
						TELEFONE_2 as TelefoneCelular,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_2 = 'CEL'
				UNION
				SELECT DDD_TELEFONE as DDDCelular,
						TELEFONE_2 as TelefoneCelular,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_3 = 'CEL'
				) O
	INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517	
	INNER JOIN Dados.PropostaCliente pc on p.ID = pc.IDProposta ) x where linha = 1 and len(TelefoneCelular) < 11
) as S on S.ID = T.ID
	WHEN MATCHED THEN UPDATE  SET T.[DDDCelular] = S.[DDDCelular],
									T.[TelefoneCelular] = S.[TelefoneCelular];





/**********************************************************************
Atualiza o Telefone Celular na tabela Dados - PropostaCliente
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
( 
	select * from (SELECT  pc.ID,O.*,ROW_NUMBER() OVER (PARTITION BY p.ID order by p.ID desc) as linha FROM (SELECT DDD_TELEFONE as DDDFAX,
						TELEFONE_1 as TelefoneFax,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_1 = 'FAX'
				UNION
				SELECT DDD_TELEFONE as DDDFax,
						TELEFONE_2 as TelefoneFax,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_2 = 'FAX'
				UNION
				SELECT DDD_TELEFONE as DDDFax,
						TELEFONE_3 as TelefoneFax,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_3 = 'FAX'
				) O
	INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517	
	INNER JOIN Dados.PropostaCliente pc on p.ID = pc.IDProposta ) x where linha =1 and len(TelefoneFax) < 11
) as S on S.ID = T.ID
	WHEN MATCHED THEN UPDATE  SET T.[DDDFax] = S.[DDDFax],
									T.[TelefoneFax] = S.[TelefoneFax];


/**********************************************************************
Atualiza o Telefone Residencial na tabela Dados - PropostaCliente
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
( 
	select * from (SELECT  pc.ID,O.*,ROW_NUMBER() OVER (PARTITION BY p.ID order by p.ID desc) as linha FROM (SELECT DDD_TELEFONE as DDDResidencial,
						TELEFONE_1 as TelefoneResidencial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_1 = 'RES'
				UNION
				SELECT DDD_TELEFONE as DDDResidencial,
						TELEFONE_2 as TelefoneResidencial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_2 = 'RES'
				UNION
				SELECT DDD_TELEFONE as DDDResidencial,
						TELEFONE_3 as TelefoneResidencial,
						NUMERO_PROPOSTA
				FROM [dbo].[Odonto_TEMP] O
				WHERE TIPO_TELEFONE_3 = 'RES'
				) O
	INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 2517	 
	INNER JOIN Dados.PropostaCliente pc on p.ID = pc.IDProposta ) x where linha = 1 and len(TelefoneResidencial) < 11
) as S on S.ID = T.ID
	WHEN MATCHED THEN UPDATE  SET T.[DDDResidencial] = S.[DDDResidencial],
									T.[TelefoneResidencial] = S.[TelefoneResidencial];



									--				T.[DDDFax] = S.[DDDFax],
									--T.[TelefoneFax] = S.[TelefoneFax],
									--T.[DDDResidencial] = S.[DDDResidencial],
									--T.[TelefoneResidencial] = S.[TelefoneResidencial],
									






/**********************************************************************
Inserção dos Dados - PropostaEndereco
***********************************************************************/ 
MERGE INTO Dados.PropostaEndereco  as T USING
(
	 SELECT * FROM (SELECT  c.ID as [IDProposta]
			  ,1 as [IDTipoEndereco]
			  ,LOGRADOURO + ' ' + COMPLEMENTO + ' ' + NUMERO AS [Endereco]
			  ,[Bairro]
			  ,LOCALIDADE AS [Cidade]
			  ,[UF]
			  ,[CEP]
			  ,1 as [LastValue]
			  ,NOME_ARQUIVO AS [TipoDado]
			  ,DATA_ARQUIVO AS [DataArquivo]
			  ,ROW_NUMBER() OVER (PARTITION BY c.ID order by DataArquivo DESC) linha
		from dbo.Odonto_TEMP t
		INNER JOIN Dados.Proposta c on c.NumeroProposta = t.NUMERO_PROPOSTA and c.IDSeguradora = 2517
		--where NOME_PLANO not in ('L0022311','','1023','8','L0022105','L0022107',
		--						'L0022111','L0022307','L0022311','PR','RS','MG','DF') 
								) x where linha  =1 
) as S
ON S.IDProposta = T.IDProposta
WHEN NOT MATCHED THEN INSERT (IDProposta,IDTipoEndereco,Endereco,Bairro,Cidade,UF,Cep,LastValue,TipoDado,DataArquivo)
		VALUES (S.IDProposta,S.IDTipoEndereco,S.Endereco,S.Bairro,S.Cidade,S.UF,S.Cep,S.LastValue,S.TipoDado,S.DataArquivo);


--rollback




							



/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Odonto'

TRUNCATE TABLE [dbo].[Odonto_TEMP]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Odonto_TEMP]
				(    [ID]
					  ,[NOME_SUBESTIPULANTE]
					  ,[CODIGO_SEGURADO]
					  ,[CPF_SEGURADO]
					  ,[CPF_TITULAR]
					  ,[NOME_SEGURADO]
					  ,[ELEGIBILIDADE_SEGURADO]
					  ,[SITUACAO_SEGURADO]
					  ,[DATA_CANCELAMENTO]
					  ,[GRAU_PARENTESCO]
					  ,[DATA_NASCIMENTO]
					  ,[DATA_ADESAO]
					  ,[SEXO]
					  ,[NUMERO_PROPOSTA]
					  ,[ESTADO_CIVIL]
					  ,[FORMA_PAGAMENTO]
					  ,[MODALIDADE]
					  ,[DDD_TELEFONE]
					  ,[TELEFONE_1]
					  ,[TIPO_TELEFONE_1]
					  ,[TELEFONE_2]
					  ,[TIPO_TELEFONE_2]
					  ,[TELEFONE_3]
					  ,[TIPO_TELEFONE_3]
					  ,[CEP]
					  ,[LOGRADOURO]
					  ,[NUMERO]
					  ,[COMPLEMENTO]
					  ,[BAIRRO]
					  ,[LOCALIDADE]
					  ,[UF]
					  ,[EMAIL]
					  ,[BANCO]
					  ,[NUMERO_AGENCIA]
					  ,[UF_AGENCIA]
					  ,[CODIGO_PLANO]
					  ,[NOME_PLANO]
					  ,[INICIO_VIGENCIA]
					  ,[FIM_VIGENCIA]
					  ,[VALOR_MENSAL]
					  ,[DATA_ARQUIVO]
					  ,[NOME_ARQUIVO]

				)
				SELECT 
						[ID]
						  ,[NOME_SUBESTIPULANTE]
						  ,[CODIGO_SEGURADO]
						  ,[CPF_SEGURADO]
						  ,[CPF_TITULAR]
						  ,[NOME_SEGURADO]
						  ,[ELEGIBILIDADE_SEGURADO]
						  ,[SITUACAO_SEGURADO]
						  ,[DATA_CANCELAMENTO]
						  ,[GRAU_PARENTESCO]
						  ,[DATA_NASCIMENTO]
						  ,[DATA_ADESAO]
						  ,[SEXO]
						  ,[NUMERO_PROPOSTA]
						  ,[ESTADO_CIVIL]
						  ,[FORMA_PAGAMENTO]
						  ,[MODALIDADE]
						  ,[DDD_TELEFONE]
						  ,[TELEFONE_1]
						  ,[TIPO_TELEFONE_1]
						  ,[TELEFONE_2]
						  ,[TIPO_TELEFONE_2]
						  ,[TELEFONE_3]
						  ,[TIPO_TELEFONE_3]
						  ,[CEP]
						  ,[LOGRADOURO]
						  ,[NUMERO]
						  ,[COMPLEMENTO]
						  ,[BAIRRO]
						  ,[LOCALIDADE]
						  ,[UF]
						  ,[EMAIL]
						  ,[BANCO]
						  ,[NUMERO_AGENCIA]
						  ,[UF_AGENCIA]
						  ,[CODIGO_PLANO]
						  ,[NOME_PLANO]
						  ,[INICIO_VIGENCIA]
						  ,[FIM_VIGENCIA]
						  ,[VALOR_MENSAL]
						  ,[DATA_ARQUIVO]
						  ,[NOME_ARQUIVO]
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaOdonto_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Odonto_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Odonto_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Odonto_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
