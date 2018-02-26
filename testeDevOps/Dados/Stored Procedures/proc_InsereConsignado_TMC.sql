

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [PortalDesep].dbo.[[proc_InsereConsignado_TMC]]
	Descrição: Procedimento que realiza a inserção dos acordos,contratos, propostas, assim como sua situação e clientes no banco de dados.
		
	Parâmetros de entrada:
	
SELECT * FROM dbo.DmSegmento					
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [dados].[proc_InsereConsignado_TMC]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consignado_TMC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Consignado_TMC_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Consignado_TMC_TEMP]
(
    [ID] bigint NOT NULL,
	[CONTRATO] [varchar](20) NOT NULL,
	[CPF_CGC] [varchar](14) NOT NULL,
	--[NUM_CONTROLE_CPF] [varchar](4) NOT  NULL,
	--[NUM_DEPENDENTE] [varchar](3) not NULL,
	[DTA_LIBERACAO] [date] NULL,
	[VAL_CONTRATO] DECIMAL(24,4)  NULL,
	--[COD_SUREG] [varchar](2) NOT NULL,
	[COD_AGENCIA] [varchar](4) NOT NULL,
	[COD_TIPO_CONTRATO] [varchar](1) NOT NULL,
	[COD_CANAL_CONCESSAO] [varchar](2) NOT NULL,
	[COD_CONVENENTE] [varchar](5) NOT NULL,
	[COD_CORRESPONDENTE] [varchar](8) NOT NULL,
	[SEGURO] bit not NULL default 0,
	[VAL_SEGURO] DECIMAL(24,4)  NULL,
	--[SITUACAO_CONTRATO] [varchar](100) NULL,
	--[MATRICULA] [varchar](100) NULL,
	--[NOME_FUNCIONARIO] [varchar](100) NULL,
	[DataArquivo] [date]  NULL,
	[NomeArquivo] [varchar](150) NOT NULL,
	[CpfTratado]  [varchar](14) NOT NULL,
	--[CPFNOMASK]  [varchar](14) NOT NULL,
	PropostaLike as  '%' + SUBSTRING(CONTRATO,11,5)+'%'  PERSISTED,
	PropostaCCALike as  '%' + SUBSTRING(CONTRATO,10,5)+'%'  PERSISTED,
	--PropostaLike2 as  '%' + SUBSTRING(CONTRATO,11,5)+'%'  PERSISTED,
	--PropostaCCALike2 as  '%' + SUBSTRING(CONTRATO,10,5)+'%'  PERSISTED,
) 



 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_ConsignadoID_TEMP ON [dbo].[Consignado_TMC_TEMP] ([ID] ASC)  

CREATE NONCLUSTERED INDEX idx_ConsignadoCPF_TEMP ON [dbo].[Consignado_TMC_TEMP] ([CpfTratado] ASC)  

--CREATE NONCLUSTERED INDEX idx_Consignado_CPFNomask_TEMP ON [dbo].[Consignado_TMC_TEMP] ([CPFNOMASK] ASC)  


CREATE NONCLUSTERED INDEX idx_Consignado_Data_TEMP ON [dbo].[Consignado_TMC_TEMP] ([CpfTratado] ASC)  
INCLUDE (DTA_LIBERACAO);



CREATE NONCLUSTERED INDEX idx_Consignado_DataArquivo_TEMP ON [dbo].[Consignado_TMC_TEMP] ([CPF_CGC],[DataArquivo] ASC)  

CREATE NONCLUSTERED INDEX idx_Consignado_PropostaLike_TEMP ON [dbo].[Consignado_TMC_TEMP] ([PropostaLike] ASC)  


CREATE NONCLUSTERED INDEX idx_Consignado_PropostaLike_PropostaCCALike_TEMP ON [dbo].[Consignado_TMC_TEMP] ([PropostaLike],[PropostaCCALike])  

CREATE NONCLUSTERED INDEX idx_Consignado_PropostaLike_PropostaCCATESTELike_TEMP ON [dbo].[Consignado_TMC_TEMP] ([PropostaLike],[PropostaCCALike],COD_AGENCIA,DTA_LIBERACAO)  

CREATE NONCLUSTERED INDEX idx_Consignado_Val_Cpf_TEMP ON [dbo].[Consignado_TMC_TEMP] (CPFTRATADO,VAL_SEGURO,[PropostaLike] )  

CREATE NONCLUSTERED INDEX [NCL_idx_contrato]
ON [dbo].[Consignado_TMC_TEMP] ([CONTRATO])
INCLUDE ([DTA_LIBERACAO],[VAL_CONTRATO],[COD_AGENCIA],[VAL_SEGURO],[DataArquivo],[NomeArquivo])
/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/

--select top 1 * From ControleDados.PontoParada order by ID desc
--declare @COMANDO  varchar(MAX)
--DECLARE @PontoDeParada VARCHAR(MAX)
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Consignado_TMC'



SET @COMANDO = '
INSERT INTO [dbo].[Consignado_TMC_TEMP]
				(      [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,VAL_CONTRATO
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  ,[SEGURO]
					  ,[VAL_SEGURO]
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					 -- ,[CPFNOMASK]

				)  
                SELECT 
					   [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,VAL_CONTRATO /100 as VAL_CONTRATO
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  , case when [SEGURO] = ''FINANCIADO'' THEN 1 ELSE 0 END AS SEGURO
					  ,[VAL_SEGURO]/10 AS VAL_SEGURO
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					--  ,[CPFNOMASK]
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaConsignado_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

	  
SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Consignado_TMC_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 


/**********************************************************************
Inserção dos Dados

select * from Dados.Proposta where ID in (56984615,
58055092)
SELECT * FROM Consignado_TMC_TEMP WHERE CONTRATO = '210979110001036144'
060170110000911089
SELECT TOP 20 * FROM Dados.PropostaConsignado where Contrato = '210979110001036144'  order by ID desc
***********************************************************************/ 
--;WITH DADOS AS (	SELECT [CONTRATO]
--				--,pp.ID as IDCointrato
--				,p.NumeroProposta
--				,pp.Propostalike
--				,[CPF_CGC]
--				--,[NUM_CONTROLE_CPF]
--				--,[NUM_DEPENDENTE]
--				,[DTA_LIBERACAO]
--				,[VAL_CONTRATO]
--				--,[COD_SUREG]
--				,[COD_AGENCIA]
--				,[COD_TIPO_CONTRATO]
--				,[COD_CANAL_CONCESSAO]
--				,[COD_CONVENENTE]
--				,[COD_CORRESPONDENTE]
--				--,[SEGURO]
--				,[VAL_SEGURO]
--				,p.valor
--				,pp.VAL_SEGURO -p.Valor diff
--				--,[SITUACAO_CONTRATO]
--				--,pp.[MATRICULA]
--				--,[NOME_FUNCIONARIO]
--				,pp.[DataArquivo]
--				,[NomeArquivo]
--				,[CPFTRATADO]
--				,p.[ID] IDProposta
--				,p.DataProposta
--				,u.Codigo
				
--				,pd.CodigoComercializado
				
--			FROM Corporativo.Dados.Proposta p
-- left join Consignado_TMC_TEMP pp on p.NumeroProposta like  pp.Propostalike 
-- LEFT join Corporativo.Dados.PropostaCliente pc on pc.IDProposta = p.ID 
-- left join Corporativo.Dados.Unidade u on p.IDAgenciaVenda = u.ID
-- left join Dados.Produto pd on pd.ID = p.IDProduto
-- WHERE pc.CPFCNPJ = pp.CPFTRATADO   and DataProposta = [DTA_LIBERACAO] and COD_AGENCIA = Codigo
--)  ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY CPFTRATADO,CONTRATO ORDER BY DataArquivo desc) AS LINHA from DADOS where diff between -1 and 1 and CodigoComercializado <> '7716'/* and linha = 1 and CodigoComercializado <> '7716'*/)
----select * from dados2 --where IDProposta = 56935883
--MERGE INTO Dados.PropostaConsignado as T USING
--(

--	SELECT * FROM dados2 where linha = 1
--		--and propostalike in ('%000002%','%000005%','%000008%')


--) as S
--ON (S.IDProposta = T.IDProposta)-- or T.NumeroProposta = s.CONTRATO) 
--WHEN NOT MATCHED THEN INSERT( [IDProposta],[DataLiberacao] ,[TipoDado] ,[CPFCNPJ],[Contrato],Valor)
--Values (s.IDProposta,s.DTA_LIBERACAO,s.NomeArquivo,s.CPFTRATADO,s.CONTRATO,s.VAL_CONTRATO);



/**********************************************************************
Inserção dos Dados

060170110000911089


SELECT * FROM DBO.Consignado_TMC_TEMP pp where   CPFTRATADO ='471.345.507-53'
***********************************************************************/ 
--;WITH DADOS AS (	SELECT 
--					[CONTRATO]
--					,pp.ID as IDContrato
--					,p.NumeroProposta
--					,pp.Propostalike
--					,[CPF_CGC]
--					--,[NUM_CONTROLE_CPF]
--					--,[NUM_DEPENDENTE]
--					,[DTA_LIBERACAO]
--					,[VAL_CONTRATO]
--					--,[COD_SUREG]
--					,[COD_AGENCIA]
--					,[COD_TIPO_CONTRATO]
--					,[COD_CANAL_CONCESSAO]
--					,[COD_CONVENENTE]
--					,[COD_CORRESPONDENTE]
--					--,[SEGURO]
--					,[VAL_SEGURO]
--					,p.valor
--					,pp.VAL_SEGURO -p.Valor diff
--					--,[SITUACAO_CONTRATO]
--					--,pp.[MATRICULA]
--					--,[NOME_FUNCIONARIO]
--					,pp.[DataArquivo]
--					,[NomeArquivo]
--					,[CPFTRATADO]
--					,p.[ID] IDProposta
--					,p.DataProposta
--					,u.Codigo
					
--					,pd.CodigoComercializado
--					--*
--			FROM DBO.Consignado_TMC_TEMP pp			
-- left join Corporativo.Dados.Proposta p on p.NumeroProposta like  pp.Propostalike 
-- LEFT join Corporativo.Dados.PropostaCliente pc on pc.IDProposta = p.ID  
-- left join Corporativo.Dados.Unidade u on p.IDAgenciaVenda = u.ID
--  left join Dados.Produto pd on pd.ID = p.IDProduto
-- WHERE  pc.CPFCNPJ = pp.CPFTRATADO and  (DataProposta = [DTA_LIBERACAO] or DataProposta < DTA_LIBERACAO) and COD_AGENCIA = Codigo

--) ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY IDProposta ORDER BY  DataArquivo desc) AS LINHA from DADOS where diff between -1 and 1 and CodigoComercializado<> '7716'/*and linha = 1  and CodigoComercializado<> '7716'*/)
----select * from dados2 where linha = 1
--MERGE INTO Dados.PropostaConsignado as T USING
--(

--	SELECT * FROM dados2 where linha =1
--	--WHERE LINHA = 1
--	--where diff between -1 and 1
-- /*
-- CodigoTipoContrato, CodigoCanalConcessao, CodigoCorrespondente, CodigoConvenente
-- */	--and propostalike in ('%000002%','%000005%','%000008%')


--) as S
--ON (S.IDProposta = T.IDProposta)-- or T.NumeroProposta = s.CONTRATO) 
--WHEN NOT MATCHED THEN INSERT( [IDProposta], [DataLiberacao] ,[TipoDado] ,[CPFCNPJ],[Contrato],Valor,CodigoTipoContrato, CodigoCanalConcessao, CodigoCorrespondente, CodigoConvenente)
--Values (s.IDProposta,s.DTA_LIBERACAO,s.NomeArquivo,s.CPFTRATADO,s.CONTRATO,s.VAL_CONTRATO,s.COD_TIPO_CONTRATO,s.COD_CANAL_CONCESSAO,s.COD_CORRESPONDENTE,s.COD_CONVENENTE);








/**********************************************************************
Inserção dos Dados - propostas que fazem match

060170110000911089

***********************************************************************/ 
;WITH DADOS AS (	SELECT [CONTRATO]
				--,pp.ID as IDCointrato
				,p.NumeroProposta
				,pp.Propostalike
				,[CPF_CGC]
				--,[NUM_CONTROLE_CPF]
				--,[NUM_DEPENDENTE]
				,[DTA_LIBERACAO] 
				,[VAL_CONTRATO]
				--,[COD_SUREG]
				,[COD_AGENCIA]
				,[COD_TIPO_CONTRATO]
				,[COD_CANAL_CONCESSAO]
				,[COD_CONVENENTE]
				,[COD_CORRESPONDENTE]
				,[SEGURO]
				,[VAL_SEGURO]
				,p.valor
				,pp.VAL_SEGURO -p.Valor diff
				--,[SITUACAO_CONTRATO]
				--,pp.[MATRICULA]
				--,[NOME_FUNCIONARIO]
				,pp.[DataArquivo]
				,[NomeArquivo]
				,[CPFTRATADO]
				,p.[ID] IDProposta
				,p.DataProposta
				,u.Codigo
				
				--,pd.CodigoComercializado
			FROM DBO.Consignado_TMC_TEMP pp			
 INNER join Corporativo.Dados.Proposta p on (p.NumeroProposta like  pp.PropostaCCAlike  OR p.NumeroProposta like PropostaLike)
 INNER join Corporativo.Dados.PropostaCliente pc on pc.IDProposta = p.ID 
 INNER join Corporativo.Dados.Unidade u on p.IDAgenciaVenda = u.ID

 WHERE pc.CPFCNPJ = pp.CPFTRATADO   and DataProposta = [DTA_LIBERACAO] and COD_AGENCIA = Codigo

) ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY [CONTRATO] ORDER BY [DTA_LIBERACAO] desc) AS LINHA from DADOS where diff between -1 and 1 /*and linha = 1'and CodigoComercializado = '7716'*/)
--select * from dados2 where Contrato = '010711110002276608'
MERGE INTO Dados.PropostaConsignado as T USING
(

	SELECT * FROM dados2
	WHERE LINHA = 1
	--where diff between -1 and 1
 
	--and propostalike in ('%000002%','%000005%','%000008%')


) as S
ON (S.IDProposta = T.IDProposta)-- or T.NumeroProposta = s.CONTRATO) 
WHEN NOT MATCHED THEN INSERT( [IDProposta], [DataLiberacao] ,[TipoDado] ,[CPFCNPJ],[Contrato],ValorCredito,CodigoTipoContrato, CodigoCanalConcessao, CodigoCorrespondente, CodigoConvenente,FlagPrestamista,ValorPrestamista,Agencia)
Values (s.IDProposta,s.[DTA_LIBERACAO],s.NomeArquivo,s.CPFTRATADO,s.CONTRATO,s.VAL_CONTRATO,s.COD_TIPO_CONTRATO,s.COD_CANAL_CONCESSAO,s.COD_CORRESPONDENTE,s.COD_CONVENENTE,s.Seguro,s.VAL_SEGURO,s.COD_AGENCIA);







/**********************************************************************
Inserção dos Dados - propostas não encontradas

060170110000911089

***********************************************************************/ 
;WITH DADOS AS (	SELECT [CONTRATO]
				--,pp.ID as IDCointrato
				--,p.NumeroProposta
				,pp.Propostalike
				,[CPF_CGC]
				--,[NUM_CONTROLE_CPF]
				--,[NUM_DEPENDENTE]
				,[DTA_LIBERACAO] 
				,[VAL_CONTRATO]
				--,[COD_SUREG]
				,[COD_AGENCIA]
				,[COD_TIPO_CONTRATO]
				,[COD_CANAL_CONCESSAO]
				,[COD_CONVENENTE]
				,[COD_CORRESPONDENTE]
				,[SEGURO]
				,[VAL_SEGURO]
				--,p.valor
				--,pp.VAL_SEGURO -p.Valor diff
				--,[SITUACAO_CONTRATO]
				--,pp.[MATRICULA]
				--,[NOME_FUNCIONARIO]
				,pp.[DataArquivo]
				,[NomeArquivo]
				,[CPFTRATADO]
				--,p.[ID] IDProposta
				--,p.DataProposta
				--,u.Codigo
				
				--,pd.CodigoComercializado
			FROM DBO.Consignado_TMC_TEMP pp			
		--	INNER JOIN Dados.Unidade on pp.COD_AGENCIA = u.Codigo
			--LEFT JOIN Dados.PropostaConsignado pc on p

 WHERE NOT EXISTS (SELECT Contrato from Dados.PropostaConsignado pc where pc.Contrato = pp.CONTRATO)

) ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY [CONTRATO] ORDER BY [DTA_LIBERACAO] desc) AS LINHA from DADOS /*and linha = 1'and CodigoComercializado = '7716'*/)
MERGE INTO Dados.PropostaConsignado as T USING
(

	SELECT * FROM dados2
	WHERE LINHA = 1
	--where diff between -1 and 1
 
	--and propostalike in ('%000002%','%000005%','%000008%')


) as S
ON S.Contrato = T.Contrato and  T.CPFCNPJ= s.CPFTRATADO
WHEN NOT MATCHED THEN INSERT(  [DataLiberacao] ,[TipoDado] ,[CPFCNPJ],[Contrato],ValorCredito,CodigoTipoContrato, CodigoCanalConcessao, CodigoCorrespondente, CodigoConvenente,FlagPrestamista,ValorPrestamista,Agencia)
Values (s.[DTA_LIBERACAO],s.NomeArquivo,s.CPFTRATADO,s.CONTRATO,s.VAL_CONTRATO,s.COD_TIPO_CONTRATO,s.COD_CANAL_CONCESSAO,s.COD_CORRESPONDENTE,s.COD_CONVENENTE,s.Seguro,s.VAL_SEGURO,s.COD_AGENCIA);




/*-------------------------------------------------
insere Propostas não encontrados

select top 100 * from Dados.CanalVendaPAR order by ID desc
select * from Dados.Proposta where NumeroProposta = '010712110000033932'
----------------------------------------------*/


;WITH DADOS AS (	SELECT pp.[CONTRATO] as NumeroProposta
				--,pp.ID as IDCointrato
				,[DTA_LIBERACAO] as DataLiberacao
				,[VAL_CONTRATO]
				--,[COD_SUREG]
				,[COD_AGENCIA]
				,[VAL_SEGURO]
				,pp.[DataArquivo]
				,pp.[NomeArquivo]
				--,pc.[IDProposta] IDProposta
				,u.ID as IDAgencia
				,pc.IDProposta 	
				,u.Codigo
				,ROW_NUMBER() OVER (PARTITION BY pc.CONTRATO ORDER BY pp.[DTA_LIBERACAO] desc) linha
			FROM DBO.Consignado_TMC_TEMP pp			
		 INNER JOIN Dados.PropostaConsignado pc on pc.Contrato =  pp.CONTRATO
		 INNER join Corporativo.Dados.Unidade u on pp.COD_AGENCIA = u.Codigo
		 WHERE pc.IDProposta IS NULL --and pp.CONTRATO = '010712110000033932'
			 )
---) ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY IDProposta ORDER BY DataArquivo desc) AS LINHA from DADOS where diff between -1 and 1 /*and linha = 1'and CodigoComercializado = '7716'*/)
--select * from dados WHERE LINHA = 1
MERGE INTO Dados.Proposta as T USING
(

	SELECT * FROM dados
	
	where linha = 1
 
	--and propostalike in ('%000002%','%000005%','%000008%')


) as S on T.NumeroProposta = S.NumeroProposta
WHEN NOT MATCHED THEN INSERT(NumeroProposta,Valor,IDAgenciaVenda,TipoDado,DataArquivo,DataProposta,IDProduto)
			VALUES (s.NumeroProposta,s.VAL_CONTRATO,s.IDAgencia,s.NomeArquivo,s.DataArquivo,s.DataLiberacao,101);




--/*-------------------------------------------------
--insere clientes não encontrados


------------------------------------------------*/

----SELECT TOP 1 * FROM Dados.PropostaCliente
;WITH DADOS AS (SELECT pp.[DataArquivo]
				,pp.[NomeArquivo]
				,pp.CPFTRATADO
				,'Pessoa Física' as TipoPessoa
				,cn.IDProposta IDConsignado 	
				,Cli.Nome
				,Cli.IDSexo
				,Cli.IDEstadoCivil
				,Cli.Identidade
				,Cli.OrgaoExpedidor
				,Cli.UFOrgaoExpedidor
				,Cli.DataExpedicaoRG
				,Cli.DDDComercial				
				,Cli.TelefoneComercial
				,Cli.DDDFax
				,Cli.TelefoneFax
				,Cli.DDDResidencial
				,Cli.TelefoneResidencial
				,Cli.Email
				,Cli.CodigoProfissao
				,Cli.NomeConjuge
				,Cli.ProfissaoConjuge
				,Cli.EmailComercial
				,Cli.DDDCelular
				,Cli.CPFConjuge
				,Cli.IDSexoConjuge
				,Cli.DataNascimentoConjuge
				,Cli.CodigoProfissaoConjuge
				,Cli.Matricula
				,c.ID
				,pc.ID as IDProposta
				--,pp.CpfTratado
			FROM DBO.Consignado_TMC_TEMP pp			
		 INNER JOIN Dados.Proposta pc on pc.NumeroProposta =  pp.CONTRATO
		 INNER JOIN Dados.PropostaConsignado cn on cn.Contrato = pc.NumeroProposta
		 OUTER APPLY( SELECT TOP 1 Nome,TipoPessoa,IDSexo,IDEstadoCivil,Identidade,OrgaoExpedidor,UFOrgaoExpedidor,DataExpedicaoRG,DDDComercial,TelefoneComercial,
						DDDFax,TelefoneFax,DDDResidencial,TelefoneResidencial,Email,CodigoProfissao,NomeConjuge,ProfissaoConjuge,EmailComercial,DDDCelular,CPFConjuge,
						IDSexoConjuge,DataNascimentoConjuge,CodigoProfissaoConjuge,Matricula from Dados.PropostaCliente pcd where pcd.CPFCNPJ = pp.CPFTRATADO order by pcd.DataArquivo desc) as Cli
		 --INNER join Corporativo.Dados.Unidade u on pp.COD_AGENCIA = u.ID
		 left join Dados.PropostaCliente c on c.IDProposta = pc.ID
		 WHERE cn.IDProposta IS NULL
			 )
---) ,dados2 as (select *,ROW_NUMBER() OVER (PARTITION BY IDProposta ORDER BY DataArquivo desc) AS LINHA from DADOS where diff between -1 and 1 /*and linha = 1'and CodigoComercializado = '7716'*/)
--select * from dados2 where Contrato = '010711110002276608'
MERGE INTO Dados.PropostaCliente as T USING
(

	SELECT * FROM dados
	
	--where diff between -1 and 1
 
	--and propostalike in ('%000002%','%000005%','%000008%')


) as S on T.ID = S.ID
WHEN NOT MATCHED THEN INSERT(IDProposta,Nome,TipoPessoa,IDSexo,IDEstadoCivil,Identidade,OrgaoExpedidor,UFOrgaoExpedidor,DataExpedicaoRG,DDDComercial,TelefoneComercial,
						DDDFax,TelefoneFax,DDDResidencial,TelefoneResidencial,Email,CodigoProfissao,NomeConjuge,ProfissaoConjuge,EmailComercial,DDDCelular,CPFConjuge,
						IDSexoConjuge,DataNascimentoConjuge,CodigoProfissaoConjuge,Matricula,TipoDado,CPFCNPJ)
			VALUES (s.IDProposta,s.Nome,s.TipoPessoa,s.IDSexo,s.IDEstadoCivil,s.Identidade,s.OrgaoExpedidor,s.UFOrgaoExpedidor,s.DataExpedicaoRG,s.DDDComercial,s.TelefoneComercial,
						s.DDDFax,s.TelefoneFax,s.DDDResidencial,s.TelefoneResidencial,s.Email,s.CodigoProfissao,s.NomeConjuge,s.ProfissaoConjuge,s.EmailComercial,s.DDDCelular,s.CPFConjuge,
						s.IDSexoConjuge,s.DataNascimentoConjuge,s.CodigoProfissaoConjuge,s.Matricula,s.NomeArquivo,s.CpfTratado);







--/*-------------------------------------------------
--atualiza PropostaConsignado
--SELECT * FROM Dados.PropostaConsignado where Contrato = '010055110000003501'

------------------------------------------------*/


;WITH DADOS AS (	SELECT pp.[CONTRATO] as NumeroProposta
				--,pp.ID as IDCointrato
				,[DTA_LIBERACAO] as DataLiberacao
				,[VAL_CONTRATO]
				--,[COD_SUREG]
				,[COD_AGENCIA]
				,[VAL_SEGURO]
				,pp.[DataArquivo]
				,pp.[NomeArquivo]
				--,p.[ID] IDProposta
				,p.DataProposta
				,p.ID as IDProposta
				,ROW_NUMBER() OVER (PARTITION BY pp.[CONTRATO] ORDER BY pp.[DTA_LIBERACAO] desc) AS LINHA
			FROM DBO.Consignado_TMC_TEMP pp			
		 INNER JOIN Dados.PropostaConsignado pc on pc.Contrato =  pp.CONTRATO
		 INNER join Corporativo.Dados.Proposta p on p.NumeroProposta = pc.Contrato
		 WHERE p.ID  = 60761018
			 
) ,dados2 as (select * from DADOS where linha = 1)
--select * from dados2  
MERGE INTO Dados.PropostaConsignado as T USING
(

	SELECT * FROM dados2
	
	--where diff between -1 and 1
 
	--and propostalike in ('%000002%','%000005%','%000008%')


) as S on T.Contrato = S.NumeroProposta and T.DataLiberacao = S.DataLiberacao
WHEN MATCHED AND T.IDProposta IS NULL THEN UPDATE set T.IDProposta = s.IDProposta;







/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Consignado_TMC'

TRUNCATE TABLE [dbo].[Consignado_TMC_TEMP]

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = '
INSERT INTO [dbo].[Consignado_TMC_TEMP]
				(      [ID]    
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,[VAL_CONTRATO]
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  ,[SEGURO]
					  ,[VAL_SEGURO]
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
				)  
                SELECT 
					   [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,[VAL_CONTRATO] /100 as VAL_CONTRATO
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  , case when [SEGURO] = ''FINANCIADO'' THEN 1 ELSE 0 END AS SEGURO
					  ,[VAL_SEGURO] /10 AS VAL_SEGURO
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaConsignado_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)         

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Consignado_TMC_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consignado_TMC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Consignado_TMC_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
