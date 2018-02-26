

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereAcordo_SSD
	Descrição: Procedimento que realiza a inserção dos acordos,contratos, propostas, assim como sua situação e clientes no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'ANTARES', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereAcordo_SSD] 
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Acordo_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Acordo_SSD_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Acordo_SSD_TEMP]
(
    [TIPO_DADO]                                                                        VARCHAR(30) DEFAULT ('SSD.ACORDO') NOT NULL,
	[SUK_CONTRATO_VIDA]                                                                [int] NOT NULL,
	[NUM_BIL_CERTIF]                                                                   VARCHAR(20) NULL,
	[NUM_APOLICE]                                                                      [varchar](20) NULL,
	[NUM_PROPOSTA_SIVPF]                                                               VARCHAR(20) NULL,
    [NUM_PROPOSTA_TRATADO]                                                             AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(ISNULL([NUM_PROPOSTA_SIVPF],'SN' + [NUM_BIL_CERTIF])) as VARCHAR(20)) PERSISTED,
    [NUM_CERTIFICADO_TRATADO]                                                          AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NUM_BIL_CERTIF]) as VARCHAR(20)) PERSISTED,
	[ID_SEGURADORA]                                                                    [SMALLINT] DEFAULT(1) NOT NULL,
	[DTH_ATUALIZACAO]																   [Datetime] NULL,
	[DTH_INI_VIGENCIA]																   [Datetime] NULL,
	[DTH_FIM_VIGENCIA]																   [Datetime] NULL,
	[DTH_VENDA]								 									       [Datetime] NULL,
	[PCT_COM_CORRETOR]															       [decimal](8, 2) NULL,
	[PCT_PART_CORRETOR]																   [decimal](8, 2) NULL,
	[SUK_PRODUTOR]																	   [int] NOT NULL,
	[NUM_MATRICULA_ECONOM]                                                             [decimal](15, 0) NULL,

	[IND_ORIGEM_REGISTRO]												               [char](1) NULL,
	[COD_PRODUTOR]																	   [int] NOT NULL,) 


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_SituacaoPagamento_Acordo_SSD_TEMP ON [dbo].[Acordo_SSD_TEMP] ([SUK_CONTRATO_VIDA] ASC)  


/****** Object:  Index [NonClusteredIndex-20150225-183313]    Script Date: 2/25/2015 6:36:19 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20150225-183313] ON [dbo].[Acordo_SSD_TEMP]
(
	[NUM_PROPOSTA_TRATADO] ASC
)
INCLUDE ( 	[TIPO_DADO],
	[DTH_ATUALIZACAO],
	[DTH_INI_VIGENCIA],
	[DTH_FIM_VIGENCIA],
	[PCT_COM_CORRETOR],
	[PCT_PART_CORRETOR],
	[COD_PRODUTOR]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Dados]




SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Acordo_SSD'
--DECLARE @PontoDeParada as int
--SET @PontoDeParada = 0

/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = 'INSERT INTO [dbo].[Acordo_SSD_TEMP]
				(         
				   [SUK_CONTRATO_VIDA],
				   [NUM_BIL_CERTIF],          
				   [NUM_APOLICE],             
				   [NUM_PROPOSTA_SIVPF],      
				   [IND_ORIGEM_REGISTRO], 
				   [DTH_ATUALIZACAO],
				   [DTH_INI_VIGENCIA],
				   [DTH_FIM_VIGENCIA],
				   [DTH_VENDA],
				   [PCT_COM_CORRETOR],
				   [PCT_PART_CORRETOR],
				   [SUK_PRODUTOR],
				 
				   [NUM_MATRICULA_ECONOM],
				   [COD_PRODUTOR]
				)  
                SELECT        
				   [SUK_CONTRATO_VIDA],
				   [NUM_BIL_CERTIF],          
				   [NUM_APOLICE],             
				   [NUM_PROPOSTA_SIVPF],      
				   [IND_ORIGEM_REGISTRO], 
				   [DTH_ATUALIZACAO],
				   [DTH_INI_VIGENCIA],
				   [DTH_FIM_VIGENCIA],
				   [DTH_VENDA],
				   [PCT_COM_CORRETOR],
				   [PCT_PART_CORRETOR],
				   [SUK_PRODUTOR],
				  
				   [NUM_MATRICULA_ECONOM],
				   [COD_PRODUTOR]   
					                                             
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaAcordo] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[Acordo_SSD_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE	
    -----------------------------------------------------------------------------------------------------------------------
    --  UPDATE [Acordo_SSD_TEMP] SET DTH_PROPOSTA = DTH_VENDA WHERE DTH_VENDA IS NOT NULL AND DTH_PROPOSTA IS NULL 
   
   --SELECT * FROM DBO.Contrato_SSD_TEMP SSD WHERE SSD.[NUM_PROPOSTA_TRATADO] IS NULL
   
   
   --DESCOMENTAR DAQUI

    --;MERGE INTO Dados.Proposta AS T
	   -- USING (
    --            SELECT DISTINCT  SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DTH_ATUALIZACAO] [DataArquivo]
    --            FROM dbo.[Acordo_SSD_TEMP] SSD
				----INNER OI				
    --        --WHERE PGTO.[RANK] = 1              
    --        ) X
    --    ON T.NumeroProposta = X.NumeroProposta  
    --AND T.IDSeguradora = X.IDSeguradora
    --WHEN NOT MATCHED
		  --      THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		  --          VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, ISNULL(X.DataArquivo, '1900-01-01'));		   
       
	--ATE AQUI
	-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/

--DESCOMENTAR DAQUI   
  --  MERGE INTO Dados.PropostaCliente AS T
  --    USING (SELECT PRP.ID [IDProposta]
  --                , SSD.[ID_SEGURADORA] [IDSeguradora]
  --                , SSD.[NOM_PESSOA_PS] [Nome]
                                                                   
  --                ,  [COD_CPF_CNPJ_PS] CPFCNPJ                                                   
	 --             ,  Cast([DTH_NASCIMENTO_PS] as date) DataNascimento                                                
	 --             ,  [COD_SEXO_PS] IDSexo                                                       
	 --             ,  EC.ID [IDEstadoCivil]                                               
	 --             ,  [IND_TIPO_PESSOA_PS] [TipoPessoa]                                                
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros([DES_EMAIL_PS]) [Email]                                                     
	 --             ,  LTRIM(RTRIM(CleansingKit.dbo.fn_RemoveLeadingZeros([NUM_IDENTIDADE_PS]))) [Identidade]                                                
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros([DES_ORGAO_EXPEDIDOR_PS]) [OrgaoExpedidor]                                           
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros( [COD_UF_EXPEDIDORA_PS]) [UFOrgaoExpedidor]                                             
	 --             ,  Cast([DTH_EXPEDICAO_PS] as date) [DataExpedicaoRG]                                                
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_DDD_TELEFONE_PS]) [DDDResidencial]                                              
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros(CASE WHEN [COD_TELEFONE_PS] < 0 THEN NULL ELSE [COD_TELEFONE_PS] END) [TelefoneResidencial]                                                  
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_DDD_CELULAR_PS]) [DDDCelular]                                               
	 --             ,  CleansingKit.dbo.fn_RemoveLeadingZeros(CASE WHEN [COD_CELULAR_PS] < 0 THEN NULL ELSE [COD_CELULAR_PS] END) [TelefoneCelular]                     
  --                ,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PS]) [CodigoProfissao]
  --                ,  [NUM_MATRICULA_ECONOM] [Matricula]    
  --                , SSD.[TIPO_DADO] [TipoDado]
  --                , Cast(SSD.[DTH_ATUALIZACAO] as date)[DataArquivo]
  --            FROM [Acordo_SSD_TEMP] SSD
  --            INNER JOIN Dados.Proposta PRP
  --            ON PRP.NumeroProposta = SSD.[NUM_PROPOSTA_TRATADO]
  --            AND PRP.IDSeguradora = 1
  --            LEFT JOIN Dados.EstadoCivil EC
  --            ON EC.Descricao = SSD.DES_ESTADO_CIVIL_PS
  --            WHERE  SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL
  --            --ORDER BY LEN([COD_DDD_TELEFONE_PS] ) DESC
  --          ) X
  --    ON T.IDProposta = X.IDProposta
  --   WHEN MATCHED THEN 
  --       UPDATE
	 -- SET [Nome] = COALESCE(X.[Nome], T.[Nome])
		--, CPFCNPJ = COALESCE(X.CPFCNPJ, T.CPFCNPJ)
		--, DataNascimento = COALESCE(X.DataNascimento, T.DataNascimento)
  --      , IDSexo = COALESCE(X.IDSexo, T.IDSexo)
  --      , [IDEstadoCivil] = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil])
  --      , [TipoPessoa] = COALESCE(X.[TipoPessoa], T.[TipoPessoa])
  --      , [Email] = COALESCE(X.[Email], T.[Email])
  --      , [Identidade] = COALESCE(X.[Identidade], T.[Identidade])
  --      , [OrgaoExpedidor] = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor])
  --      , [DataExpedicaoRG] = COALESCE(X.[DataExpedicaoRG], T.[DataExpedicaoRG])
  --      , [DDDResidencial] = COALESCE(X.[DDDResidencial], T.[DDDResidencial])
  --      , [TelefoneResidencial] = COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial])
  --      , [DDDCelular] = COALESCE(X.[DDDCelular], T.[DDDCelular])
  --      , [TelefoneCelular] = COALESCE(X.[TelefoneCelular], T.[TelefoneCelular])
  --      , [CodigoProfissao] = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao])
  --      , [Matricula] = COALESCE(X.[Matricula], T.[Matricula])
  --      , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
  --      , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
  --   WHEN NOT MATCHED
	 --         THEN INSERT (   IDProposta
  --                          , CPFCNPJ
  --                          , Nome
  --                          , DataNascimento
  --                          , TipoPessoa
  --                          , IDSexo
  --                          , IDEstadoCivil
  --                          , Identidade
  --                          , OrgaoExpedidor
  --                          , UFOrgaoExpedidor
  --                          , DataExpedicaoRG
  --                          , DDDResidencial
  --                          , TelefoneResidencial
  --                          , Email
  --                          , CodigoProfissao
  --                          , DDDCelular
  --                          , TelefoneCelular
  --                          , Matricula
  --                          , [TipoDado]
  --                          , [DataArquivo])
	 --              VALUES (X.IDProposta 
  --                       , X.CPFCNPJ
  --                       , X.Nome
  --                       , X.DataNascimento
  --                       , X.TipoPessoa
  --                       , X.IDSexo
  --                       , X.IDEstadoCivil
  --                       , X.Identidade
  --                       , X.OrgaoExpedidor
  --                       , X.UFOrgaoExpedidor
  --                       , X.DataExpedicaoRG
  --                       , X.DDDResidencial
  --                       , X.TelefoneResidencial
  --                       , X.Email
  --                       , X.CodigoProfissao
  --                       , X.DDDCelular
  --                       , X.TelefoneCelular
  --                       , X.Matricula
  --                       , X.[TipoDado]
  --                       , X.[DataArquivo]);
                   
   --ATE AQUI     

/*------------------------INSERE ACORDO COMERCIAL------------------------------------*/
  ;MERGE INTO Dados.PropostaAcordo as T
   Using 
   ( 
		SELECT * FROM  (SELECT [NUM_PROPOSTA_TRATADO],        
			--   [NUM_CERTIFICADO_TRATADO],     
			 --  [ID_SEGURADORA],               
			   [DTH_ATUALIZACAO],				
			   [DTH_INI_VIGENCIA],				
			   [DTH_FIM_VIGENCIA],				
			   --[DTH_VENDA],						
			   [PCT_PART_CORRETOR],				
			   [PCT_COM_CORRETOR],				
			   --[SUK_PRODUTOR],					
			   --[NUM_MATRICULA_ECONOM],
			   p.ID as IDProposta,
			   pd.ID as IDProdutor,
			   t.[TIPO_DADO],
			   ROW_NUMBER() OVER (PARTITION BY p.ID,pd.ID,DTH_INI_VIGENCIA order by p.ID) linha
		FROM  [dbo].[Acordo_SSD_TEMP] t
			INNER JOIN Dados.Proposta p on p.NumeroProposta = t.[NUM_PROPOSTA_TRATADO]  and p.IDSeguradora = 1
			INNER JOIN Dados.Produtor pd on pd.Codigo = t.COD_PRODUTOR) X where Linha = 1
			
		 ) S
   on s.IDProposta = t.IDProposta
	and s.IDProdutor = t.IDProdutor
	and s.[DTH_INI_VIGENCIA] = t.DataInicioVigencia
	
 WHEN NOT MATCHED THEN INSERT (  IDProposta,IDProdutor,PercentualParticipacaoProdutor,PercentualComissaoProdutor,DataArquivo,NomeArquivo,DataInicioVigencia,DataFimVigencia)
		Values(s.IDProposta,s.IDProdutor,s.[PCT_PART_CORRETOR],s.[PCT_COM_CORRETOR],s.[DTH_ATUALIZACAO],s.[TIPO_DADO],s.[DTH_INI_VIGENCIA],s.[DTH_FIM_VIGENCIA]);

		

--CREATE UNIQUE NONCLUSTERED INDEX  IND_NCL_UNQ_PropostaAcordo_IDProposta_IdProdutor_Vigencia on
--Dados.PropostaAcordo (IDProposta,IDProdutor,DataInicioVigencia)
--WITH (FILLFACTOR=100,MAXDOP=7)


/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada = '1900-01-01;' + Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Acordo_SSD'

TRUNCATE TABLE [dbo].[Acordo_SSD_TEMP]

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[Acordo_SSD_TEMP]
				(         
				   [SUK_CONTRATO_VIDA],
				   [NUM_BIL_CERTIF],          
				   [NUM_APOLICE],             
				   [NUM_PROPOSTA_SIVPF],      
				   [IND_ORIGEM_REGISTRO], 
				   [DTH_ATUALIZACAO],
				   [DTH_INI_VIGENCIA],
				   [DTH_FIM_VIGENCIA],
				   [DTH_VENDA],
				   [PCT_COM_CORRETOR],
				   [PCT_PART_CORRETOR],
				   [SUK_PRODUTOR],
				  
				   [NUM_MATRICULA_ECONOM],
				   [COD_PRODUTOR]
				)  
                SELECT        
				   [SUK_CONTRATO_VIDA],
				   [NUM_BIL_CERTIF],          
				   [NUM_APOLICE],             
				   [NUM_PROPOSTA_SIVPF],      
				   [IND_ORIGEM_REGISTRO], 
				   [DTH_ATUALIZACAO],
				   [DTH_INI_VIGENCIA],
				   [DTH_FIM_VIGENCIA],
				   [DTH_VENDA],
				   [PCT_COM_CORRETOR],
				   [PCT_PART_CORRETOR],
				   [SUK_PRODUTOR],
				
				   [NUM_MATRICULA_ECONOM],
				   [COD_PRODUTOR]   
					                                             
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaAcordo] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[Acordo_SSD_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Acordo_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Acordo_SSD_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

