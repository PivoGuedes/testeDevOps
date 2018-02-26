

/*
	Autor: Egler Vieira
	Data Criação: 21/07/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereContrato_SSD
	Descrição: Procedimento que realiza a inserção dos contratos, propostas, assim como sua situação e clientes no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'ANTARES', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereContrato_SSD] 
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contrato_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Contrato_SSD_TEMP];

CREATE TABLE [dbo].[Contrato_SSD_TEMP]
(
    [TIPO_DADO]                                                                        VARCHAR(30) DEFAULT ('SSD.CONTRATO') NOT NULL,
	[SUK_CONTRATO_VIDA]                                                                [int] NOT NULL,
	[NUM_BIL_CERTIF]                                                                   VARCHAR(20) NOT NULL,
	[NUM_APOLICE]                                                                      [varchar](20) NULL,
	[NUM_PROPOSTA_SIVPF]                                                               VARCHAR(20) NULL,
    [NUM_PROPOSTA_TRATADO]                                                             AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(ISNULL([NUM_PROPOSTA_SIVPF],'SN' + [NUM_BIL_CERTIF])) as VARCHAR(20)) PERSISTED,
    [NUM_CERTIFICADO_TRATADO]                                                          AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NUM_BIL_CERTIF]) as VARCHAR(20)) PERSISTED,
	[ID_SEGURADORA]                                                                    [SMALLINT] DEFAULT(1) NOT NULL,
    [NUM_CONTRATO]                                                                     [decimal](15, 0) NULL,
	[DTH_PROPOSTA]                                                                     [datetime] NULL,
	[DTH_VENDA]                                                                        [datetime] NULL,
	[DTH_QUITACAO]                                                                     [datetime] NULL,
	[DTH_EMISSAO]                                                                      [datetime] NULL,
    [DTH_CANCELAMENTO]                                                                 [datetime] NULL,
	[DTH_INI_VIGENCIA]                                                                 [datetime] NULL,
	[DTH_FIM_VIGENCIA]                                                                 [datetime] NULL,
	[VLR_PREMIO_BRUTO_ATUAL]                                                           [decimal](15, 2) NULL,
	[VLR_PREMIO_LIQ_ATUAL]                                                             [decimal](15, 2) NULL,
    VLR_PREMIO_LIQ_INICIAL                                                             [decimal](15, 2) NULL,
    VLR_PREMIO_BRUTO_INICIAL                                                           [decimal](15, 2) NULL,
	[VLR_IOF]                                                                          [decimal](8, 2) NULL,
	[VLR_CUSTO_EMISSAO]                                                                [decimal](8, 2) NULL,
	[COD_SUBGRUPO]                                                                     [smallint] NULL,
	[IND_PERI_PAGAMENTO]                                                               [varchar] (2) NULL,
	[COD_OPCAO_PAGAMENTO]                                                              [char](1) NULL,
	[NUM_MATRICULA_VENDEDOR]                                                           [decimal](15, 0) NULL,
	[NUM_MATRICULA_ECONOM]                                                             [decimal](15, 0) NULL,
	[NUM_MATRICULA_PDV]                                                                [varchar](20) NULL,
	[NUM_APOLICE_ANTERIOR]                                                             [varchar](20) NULL,
	[IND_RENOVACAO]                                                                    [char](1) NULL,
	[IND_ADIMPLENTE]                                                                   [char](1) NULL,
	[NUM_QTD_PARCELAS]                                                                 [smallint] NULL,
	[IND_ORIGEM_REGISTRO_CONTRATO]                                                     [char](1) NULL,
	[STA_ANTECIPACAO]																   [bit] null,
	[STA_MUDANCA_PLANO]																   [bit] null,
    -------------------------------------PRODUTO----------------------------------------------------------
    COD_PRODUTO_SIAS                                                                   [smallint] NULL,
    COD_PRODUTO_SIVPF                                                                  [smallint] NULL,
    COD_RAMO_EMISSOR                                                                   [smallint] NULL,
    COD_EMPRESA_SIAS                                                                   [smallint] NULL,
    -------------------------------------VENDEDOR---------------------------------------------------------  
	[COD_CPF_CNPJ_VENDEDOR]                                                            [decimal](16, 0) NULL,
	[COD_MATRICULA_VENDEDOR]                                                           [varchar](50) NULL,
	[IND_ORIGEM_REGISTRO_VENDEDOR]                                                     [char](1) NULL,
	[IND_TIPO_VENDEDOR]                                                                [char](1) NULL,
    ---------------------------------------SITUACAO-------------------------------------------------------
    [IDSUBSITUACAO]                                                                    [smallint] NULL,
	[DATA_SITUACAO]                                                                    [datetime] NULL,
    [DATA_ATUALIZACAO]                                                                 [datetime] NULL,
	[QTD_CONTRATO]                                                                     [int] NULL,
	[QTD_PROPOSTA]                                                                     [int] NULL,
    ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
	[COD_AGENCIA]                                                                      [smallint] NULL,
    --------------------------------------ESTIPULANTE----------------------------------------------------
	[COD_CLIENTE_PE]                                                                   [int] NULL,
	[NUM_OCORR_ENDERECO_PE]                                                                    [smallint] NULL,
	[NOM_PESSOA_PE]                                                                    [varchar](200) NULL,
	[COD_CPF_CNPJ_PE]                                                                  [varchar](20) NULL,
	[DTH_NASCIMENTO_PE]                                                                [datetime] NULL,
	[COD_SEXO_PE]                                                                      [tinyint] NULL,
	[COD_ESTADO_CIVIL_PE]                                                              [char](1) NULL,
	[DES_ESTADO_CIVIL_PE]                                                              [varchar](30) NULL,
	[IND_TIPO_PESSOA_PE]                                                               [varchar](20) NULL,
	[DES_EMAIL_PE]                                                                     [varchar](200) NULL,
	[NUM_IDENTIDADE_PE]                                                                [varchar](15) NULL,
	[DES_ORGAO_EXPEDIDOR_PE]                                                           [varchar](10) NULL,
	[COD_UF_EXPEDIDORA_PE]                                                             [char](2) NULL,
	[DTH_EXPEDICAO_PE]                                                                 [datetime] NULL,
	[COD_DDD_TELEFONE_PE]                                                              [smallint] NULL,
	[COD_TELEFONE_PE]                                                                  [int] NULL,
	[COD_DDD_CELULAR_PE]                                                               [smallint] NULL,
	[COD_CELULAR_PE]                                                                   [int] NULL,
	[COD_CBO_PE]                                                                       [varchar] (3) NULL,
    [DES_ENDERECO_PE]                                                                  [varchar](255) NULL,
	[DES_BAIRRO_PE]                                                                    [varchar](100) NULL,
	[DES_CIDADE_PE]                                                                    [varchar](100) NULL,
	[COD_UF_PE]                                                                        [char](2) NULL,
	[DES_COMPLEMENTO_ENDERECO_PE]                                                      [varchar](100) NULL,
	[NUM_IMOVEL_PE]                                                                    [smallint] NULL,
	[COD_CEP_PE]                                                                       [varchar](15) NULL,
	[COD_BANCO_PE]                                                                     [smallint] NULL,
	[COD_AGENCIA_PE]                                                                   [smallint] NULL,
	[NUM_CONTA_PE]                                                                     [decimal](15, 0) NULL,
	[NUM_DV_CONTA_PE]                                                                  [smallint] NULL,
	[NUM_OPERACAO_CONTA_PE]                                                            [smallint] NULL,
	[COD_ORIGEM_PESSOA_PE]                                                             [smallint] NULL,
    --------------------------------------SUB ESTIPULANTE------------------------------------------------
	[COD_CLIENTE_PSE]                                                                  [int] NULL,
	[NUM_OCORR_ENDERECO_PSE]                                                           [smallint] NULL,
	[NOM_PESSOA_PSE]                                                                   [varchar](200) NULL,
	[COD_CPF_CNPJ_PSE]                                                                 [varchar](20) NULL,
	[DTH_NASCIMENTO_PSE]                                                               [datetime] NULL,
	[COD_SEXO_PSE]                                                                     [tinyint] NULL,
	[COD_ESTADO_CIVIL_PSE]                                                             [char](1) NULL,
	[DES_ESTADO_CIVIL_PSE]                                                             [varchar](30) NULL,
	[IND_TIPO_PESSOA_PSE]                                                              [varchar](20) NULL,
	[DES_EMAIL_PSE]                                                                    [varchar](200) NULL,
	[NUM_IDENTIDADE_PSE]                                                               [varchar](15) NULL,
	[DES_ORGAO_EXPEDIDOR_PSE]                                                          [varchar](10) NULL,
	[COD_UF_EXPEDIDORA_PSE]                                                            [char](2) NULL,
	[DTH_EXPEDICAO_PSE]                                                                [datetime] NULL,
	[COD_DDD_TELEFONE_PSE]                                                             [smallint] NULL,
	[COD_TELEFONE_PSE]                                                                 [int] NULL,
	[COD_DDD_CELULAR_PSE]                                                              [smallint] NULL,
	[COD_CELULAR_PSE]                                                                  [int] NULL,
	[COD_CBO_PSE]                                                                      [varchar] (3) NULL,
    [DES_ENDERECO_PSE]                                                                 [varchar](255) NULL,
	[DES_BAIRRO_PSE]                                                                   [varchar](100) NULL,
	[DES_CIDADE_PSE]                                                                   [varchar](100) NULL,
	[COD_UF_PSE]                                                                       [char](2) NULL,
	[DES_COMPLEMENTO_ENDERECO_PSE]                                                     [varchar](100) NULL,
	[NUM_IMOVEL_PSE]                                                                   [smallint] NULL,
	[COD_CEP_PSE]                                                                      [varchar](15) NULL,
	[COD_BANCO_PSE]                                                                    [smallint] NULL,
	[COD_AGENCIA_PSE]                                                                  [smallint] NULL,
	[NUM_CONTA_PSE]                                                                    [decimal](15, 0) NULL,
	[NUM_DV_CONTA_PSE]                                                                 [smallint] NULL,
	[NUM_OPERACAO_CONTA_PSE]                                                           [smallint] NULL,
	[COD_ORIGEM_PSESSOA_PSE]                                                           [smallint] NULL,
    --------------------------------------SEGURADO-------------------------------------------------------
	[COD_CLIENTE_PS]                                                                   [int] NULL,
	[NUM_OCORR_ENDERECO_PS]                                                            [smallint] NULL,
	[NOM_PESSOA_PS]                                                                    [varchar](200) NULL,
	[COD_CPF_CNPJ_PS]                                                                  [varchar](20) NULL,
	[DTH_NASCIMENTO_PS]                                                                [datetime] NULL,
	[COD_SEXO_PS]                                                                      [tinyint] NULL,
	[COD_ESTADO_CIVIL_PS]                                                              [char](1) NULL,
	[DES_ESTADO_CIVIL_PS]                                                              [varchar](30) NULL,
	[IND_TIPO_PESSOA_PS]                                                               [varchar](20) NULL,
	[DES_EMAIL_PS]                                                                     [varchar](200) NULL,
	[NUM_IDENTIDADE_PS]                                                                [varchar](15) NULL,
	[DES_ORGAO_EXPEDIDOR_PS]                                                           [varchar](10) NULL,
	[COD_UF_EXPEDIDORA_PS]                                                             [char](2) NULL,
	[DTH_EXPEDICAO_PS]                                                                 [datetime] NULL,
	[COD_DDD_TELEFONE_PS]                                                              [smallint] NULL,
	[COD_TELEFONE_PS]                                                                  [int] NULL,
	[COD_DDD_CELULAR_PS]                                                               [smallint] NULL,
	[COD_CELULAR_PS]                                                                   [int] NULL,
	[COD_CBO_PS]                                                                       [varchar] (3) NULL,
    [DES_ENDERECO_PS]                                                                  [varchar](255) NULL,
	[DES_BAIRRO_PS]                                                                    [varchar](100) NULL,
	[DES_CIDADE_PS]                                                                    [varchar](100) NULL,
	[COD_UF_PS]                                                                        [char](2) NULL,
	[DES_COMPLEMENTO_ENDERECO_PS]                                                      [varchar](100) NULL,
	[NUM_IMOVEL_PS]                                                                    [smallint] NULL,
	[COD_CEP_PS]                                                                       [varchar](15) NULL,
	[COD_BANCO_PS]                                                                     [smallint] NULL,
	[COD_AGENCIA_PS]                                                                   [smallint] NULL,
	[NUM_CONTA_PS]                                                                     [decimal](15, 0) NULL,
	[NUM_DV_CONTA_PS]                                                                  [smallint] NULL,
	[NUM_OPERACAO_CONTA_PS]                                                            [smallint] NULL,
	[COD_ORIGEM_PESSOA_PS]                                                             [smallint] NULL,
) 


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_SituacaoPagamento_Contrato_SSD_TEMP ON [dbo].[Contrato_SSD_TEMP] ([SUK_CONTRATO_VIDA] ASC)  


CREATE NONCLUSTERED INDEX IDX_NCL_NUM_MATRICULA_VENDEDOR_Contrato_SSD
ON [dbo].[Contrato_SSD_TEMP] ([NUM_MATRICULA_VENDEDOR])
INCLUDE ([TIPO_DADO],[DATA_ATUALIZACAO])


CREATE NONCLUSTERED INDEX IDX_NCL_IDSUBSITUACAO_Contrato_SSD
ON [dbo].[Contrato_SSD_TEMP] ([IDSUBSITUACAO])
INCLUDE ([TIPO_DADO],[NUM_PROPOSTA_TRATADO],[ID_SEGURADORA],[DATA_SITUACAO],[DATA_ATUALIZACAO])

CREATE NONCLUSTERED INDEX IDX_NCL_COD_AGENCIA_Contrato_SSD
ON [dbo].[Contrato_SSD_TEMP] ([COD_AGENCIA])
INCLUDE ([TIPO_DADO])

CREATE NONCLUSTERED INDEX IDX_NCL_NUM_APOLICE_ANTERIOR_Contrato_SSD
ON [dbo].[Contrato_SSD_TEMP] ([NUM_APOLICE_ANTERIOR])
INCLUDE ([TIPO_DADO],[ID_SEGURADORA],[DATA_ATUALIZACAO])

SELECT  @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Contrato_SSD'



--SELECT * FROM [Contrato_SSD_TEMP] WHERE [NUM_PROPOSTA_TRATADO] like 'SN%'

/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
---DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)

SET @COMANDO = 'INSERT INTO [dbo].[Contrato_SSD_TEMP] 
				(      
				    [SUK_CONTRATO_VIDA], 
	                [NUM_BIL_CERTIF], 
	                [NUM_APOLICE], 
	                [NUM_PROPOSTA_SIVPF], 
	                [NUM_CONTRATO],  
	                [DTH_PROPOSTA],
	                [DTH_VENDA],
	                [DTH_QUITACAO] ,
	                [DTH_EMISSAO] ,                                                        
	                [DTH_INI_VIGENCIA] ,                                                   
	                [DTH_FIM_VIGENCIA] , 
                    [DTH_CANCELAMENTO],                                                  
	                [VLR_PREMIO_BRUTO_ATUAL] ,                                             
	                [VLR_PREMIO_LIQ_ATUAL] ,
                    VLR_PREMIO_LIQ_INICIAL,               
                    VLR_PREMIO_BRUTO_INICIAL,      
	                [VLR_IOF] ,                                                            
	                [VLR_CUSTO_EMISSAO] ,                                                  
	                [COD_SUBGRUPO] ,                                                       
	                [IND_PERI_PAGAMENTO] ,                                                 
	                [COD_OPCAO_PAGAMENTO] ,                                                
	                [NUM_MATRICULA_VENDEDOR] ,                                             
	                [NUM_MATRICULA_ECONOM] ,                                               
	                [NUM_MATRICULA_PDV] ,                                                  
	                [NUM_APOLICE_ANTERIOR] ,                                               
	                [IND_RENOVACAO] ,                                                      
	                [IND_ADIMPLENTE] ,                                                     
	                [NUM_QTD_PARCELAS] ,                                                   
	                [IND_ORIGEM_REGISTRO_CONTRATO] ,      
					[STA_ANTECIPACAO] ,		
					[STA_MUDANCA_PLANO] ,
                    -------------------------------------PRODUTO----------------------------------------------------------
                    COD_PRODUTO_SIAS,
                    COD_PRODUTO_SIVPF,
                    COD_RAMO_EMISSOR,
                    COD_EMPRESA_SIAS,
                    -------------------------------------VENDEDOR---------------------------------------------------------  
	                [COD_CPF_CNPJ_VENDEDOR] ,                                                                  
	                [COD_MATRICULA_VENDEDOR] ,                                                                 
	                [IND_ORIGEM_REGISTRO_VENDEDOR] ,                                                           
	                [IND_TIPO_VENDEDOR] ,                                                                    
                    ---------------------------------------SITUACAO-------------------------------------------------------
	                [IDSUBSITUACAO],
                    [DATA_SITUACAO] ,    
                    [DATA_ATUALIZACAO],                                 
	                [QTD_CONTRATO] ,                                      
	                [QTD_PROPOSTA] ,                                      
                    ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
	                [COD_AGENCIA] ,                                                                
                    --------------------------------------ESTIPULANTE----------------------------------------------------
	                [COD_CLIENTE_PE] ,                                                     
	                [NUM_OCORR_ENDERECO_PE] ,                                              
	                [NOM_PESSOA_PE] ,                                                      
	                [COD_CPF_CNPJ_PE] ,                                                    
	                [DTH_NASCIMENTO_PE] ,                                                  
	                [COD_SEXO_PE] ,                                                        
	                [COD_ESTADO_CIVIL_PE] ,                                                
	                [DES_ESTADO_CIVIL_PE] ,                                                
	                [IND_TIPO_PESSOA_PE] ,                                                 
	                [DES_EMAIL_PE] ,                                                       
	                [NUM_IDENTIDADE_PE] ,                                                  
	                [DES_ORGAO_EXPEDIDOR_PE] ,                                             
	                [COD_UF_EXPEDIDORA_PE] ,                                               
	                [DTH_EXPEDICAO_PE] ,                                                   
	                [COD_DDD_TELEFONE_PE] ,                                                
	                [COD_TELEFONE_PE] ,                                                    
	                [COD_DDD_CELULAR_PE] ,                                                 
	                [COD_CELULAR_PE] ,                                                     
	                --[COD_CBO_PE] , 
                    [DES_ENDERECO_PE] ,  
   	                [DES_BAIRRO_PE] ,                                                      
	                [DES_CIDADE_PE] ,                                                      
	                [COD_UF_PE] ,                                                          
	                [DES_COMPLEMENTO_ENDERECO_PE] ,                                        
	                [NUM_IMOVEL_PE] ,                                                      
	                [COD_CEP_PE] ,                                                         
	                [COD_BANCO_PE] ,                                                       
	                [COD_AGENCIA_PE] ,                                                     
	                [NUM_CONTA_PE] ,                                                       
	                [NUM_DV_CONTA_PE] ,                                                    
	                [NUM_OPERACAO_CONTA_PE] ,                                              
	                [COD_ORIGEM_PESSOA_PE] ,                                               
                    --------------------------------------SUB ESTIPULANTE------------------------------------------------
	                [COD_CLIENTE_PSE] ,                                           
	                [NUM_OCORR_ENDERECO_PSE] ,                                    
	                [NOM_PESSOA_PSE] ,                                            
	                [COD_CPF_CNPJ_PSE] ,                                          
	                [DTH_NASCIMENTO_PSE] ,                                        
	                [COD_SEXO_PSE] ,                                              
	                [COD_ESTADO_CIVIL_PSE] ,                                      
	                [DES_ESTADO_CIVIL_PSE] ,                                      
	                [IND_TIPO_PESSOA_PSE] ,                                      
	                [DES_EMAIL_PSE] ,                                             
	                [NUM_IDENTIDADE_PSE] ,                                        
	                [DES_ORGAO_EXPEDIDOR_PSE] ,                                   
	                [COD_UF_EXPEDIDORA_PSE] ,                                     
	                [DTH_EXPEDICAO_PSE] ,                                         
	                [COD_DDD_TELEFONE_PSE] ,                                      
	                [COD_TELEFONE_PSE] ,                                          
	                [COD_DDD_CELULAR_PSE] ,                                       
	                [COD_CELULAR_PSE] ,  
                    --[COD_CBO_PSE] ,                                         
	                [DES_ENDERECO_PSE] ,                                          
	                [DES_BAIRRO_PSE] ,                                            
	                [DES_CIDADE_PSE] ,                                            
	                [COD_UF_PSE] ,                                                
	                [DES_COMPLEMENTO_ENDERECO_PSE] ,                              
	                [NUM_IMOVEL_PSE] ,                                            
	                [COD_CEP_PSE] ,                                               
	                [COD_BANCO_PSE] ,                                             
	                [COD_AGENCIA_PSE] ,                                           
	                [NUM_CONTA_PSE] ,                                             
	                [NUM_DV_CONTA_PSE] ,                                          
	                [NUM_OPERACAO_CONTA_PSE] ,                                    
	                [COD_ORIGEM_PSESSOA_PSE] ,                                    
                    --------------------------------------SEGURADO-------------------------------------------------------
	                [COD_CLIENTE_PS] ,                                                   
	                [NUM_OCORR_ENDERECO_PS] ,                                            
	                [NOM_PESSOA_PS] ,                                                    
	                [COD_CPF_CNPJ_PS] ,                                                  
	                [DTH_NASCIMENTO_PS] ,                                                
	                [COD_SEXO_PS] ,                                                      
	                [COD_ESTADO_CIVIL_PS] ,                                              
	                [DES_ESTADO_CIVIL_PS] ,                                              
	                [IND_TIPO_PESSOA_PS] ,                                               
	                [DES_EMAIL_PS] ,                                                     
	                [NUM_IDENTIDADE_PS] ,                                                
	                [DES_ORGAO_EXPEDIDOR_PS] ,                                           
	                [COD_UF_EXPEDIDORA_PS] ,                                             
	                [DTH_EXPEDICAO_PS] ,                                                 
	                [COD_DDD_TELEFONE_PS] ,                                              
	                [COD_TELEFONE_PS] ,                                                  
	                [COD_DDD_CELULAR_PS] ,                                               
	                [COD_CELULAR_PS] ,  
                    --[COD_CBO_PS],                                                 
	                [DES_ENDERECO_PS] ,                                                  
	                [DES_BAIRRO_PS] ,                                                    
	                [DES_CIDADE_PS] ,                                                    
	                [COD_UF_PS] ,                                                        
	                [DES_COMPLEMENTO_ENDERECO_PS] ,                                      
	                [NUM_IMOVEL_PS] ,                                                    
	                [COD_CEP_PS] ,                                                       
	                [COD_BANCO_PS] ,                                                     
	                [COD_AGENCIA_PS] ,                                                   
	                [NUM_CONTA_PS] ,                                                     
	                [NUM_DV_CONTA_PS] ,                                                  
	                [NUM_OPERACAO_CONTA_PS] ,                                            
	                [COD_ORIGEM_PESSOA_PS] 
				)  
                SELECT 
                        [SUK_CONTRATO_VIDA] , 
	                    [NUM_BIL_CERTIF] , 
	                    [NUM_APOLICE] , 
	                    [NUM_PROPOSTA_SIVPF] , 
	                    [NUM_CONTRATO] ,   
	                    [DTH_PROPOSTA] ,
	                    [DTH_VENDA],
	                    [DTH_QUITACAO] ,
	                    [DTH_EMISSAO] ,                                                        
	                    [DTH_INI_VIGENCIA] ,                                                   
	                    [DTH_FIM_VIGENCIA] ,        
                        [DTH_CANCELAMENTO],                                           
	                    CASE WHEN [VLR_PREMIO_BRUTO_ATUAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_BRUTO_ATUAL] END [VLR_PREMIO_BRUTO_ATUAL],                                              
	                    CASE WHEN [VLR_PREMIO_LIQ_ATUAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_LIQ_ATUAL] END [VLR_PREMIO_LIQ_ATUAL], 
                        CASE WHEN [VLR_PREMIO_LIQ_INICIAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_LIQ_INICIAL] END [VLR_PREMIO_LIQ_INICIAL],                   
                        CASE WHEN [VLR_PREMIO_BRUTO_INICIAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_BRUTO_INICIAL] END [VLR_PREMIO_BRUTO_INICIAL],  
	                    [VLR_IOF] ,                                                            
	                    [VLR_CUSTO_EMISSAO] ,                                                  
	                    [COD_SUBGRUPO] ,                                                       
	                    [IND_PERI_PAGAMENTO] ,                                                 
	                    [COD_OPCAO_PAGAMENTO] ,                                                
	                    [NUM_MATRICULA_VENDEDOR] ,                                             
	                    [NUM_MATRICULA_ECONOM] ,                                               
	                    [NUM_MATRICULA_PDV] ,                                                  
	                    [NUM_APOLICE_ANTERIOR] ,                                               
	                    [IND_RENOVACAO] ,                                                      
	                    [IND_ADIMPLENTE] ,                                                     
	                    [NUM_QTD_PARCELAS] ,                                                   
	                    [IND_ORIGEM_REGISTRO_CONTRATO] ,  
						[STA_ANTECIPACAO] ,		
						[STA_MUDANCA_PLANO] ,
                        -------------------------------------PRODUTO----------------------------------------------------------
                        COD_PRODUTO_SIAS,
                        COD_PRODUTO_SIVPF,
                        COD_RAMO_EMISSOR,
                        COD_EMPRESA_SIAS,                                     
                        -------------------------------------VENDEDOR---------------------------------------------------------  
	                    [COD_CPF_CNPJ_VENDEDOR] ,                                                                  
	                    [COD_MATRICULA_VENDEDOR] ,                                                                 
	                    [IND_ORIGEM_REGISTRO_VENDEDOR] ,                                                           
	                    [IND_TIPO_VENDEDOR] ,                                                                    
                        ---------------------------------------SITUACAO-------------------------------------------------------
	                    [IDSUBSITUACAO],
                        [DATA_SITUACAO] , 
                        [DATA_ATUALIZACAO],                                    
	                    [QTD_CONTRATO] ,                                      
	                    [QTD_PROPOSTA] ,                                      
                        ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
	                    [COD_AGENCIA] ,                                                                
                        --------------------------------------ESTIPULANTE----------------------------------------------------
	                    [COD_CLIENTE_PE] ,                                                     
	                    [NUM_OCORR_ENDERECO_PE] ,                                              
	                    [NOM_PESSOA_PE] ,                                                      
                        CASE
                        		WHEN IND_TIPO_PESSOA_PE = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PE as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PE = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PE as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PE as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PE ,                                                            
	                    [DTH_NASCIMENTO_PE] ,
                        CASE WHEN [COD_SEXO_PE] = ''F'' THEN 2
                             WHEN [COD_SEXO_PE] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PE],                                                       
	                    [COD_ESTADO_CIVIL_PE] ,                                                
	                    [DES_ESTADO_CIVIL_PE] ,                                                
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PE = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PE = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PE] ,                                                       
	                    [DES_EMAIL_PE] ,                                                       
	                    [NUM_IDENTIDADE_PE] ,                                                  
	                    [DES_ORGAO_EXPEDIDOR_PE] ,                                             
	                    [COD_UF_EXPEDIDORA_PE] ,                                               
	                    [DTH_EXPEDICAO_PE] ,                                                   
	                    [COD_DDD_TELEFONE_PE] ,                                                
	                    [COD_TELEFONE_PE] ,                                                    
	                    [COD_DDD_CELULAR_PE] ,                                                 
	                    [COD_CELULAR_PE] , 
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PE]) [COD_CBO_PE],                                                  
	                    [DES_ENDERECO_PE] ,                                                    
	                    [DES_BAIRRO_PE] ,                                                      
	                    [DES_CIDADE_PE] ,                                                      
	                    [COD_UF_PE] ,                                                          
	                    [DES_COMPLEMENTO_ENDERECO_PE] ,                                        
	                    [NUM_IMOVEL_PE] ,                                                      
	                    [COD_CEP_PE] ,                                                         
	                    [COD_BANCO_PE] ,                                                       
	                    [COD_AGENCIA_PE] ,                                                     
	                    [NUM_CONTA_PE] ,                                                       
	                    [NUM_DV_CONTA_PE] ,                                                    
	                    [NUM_OPERACAO_CONTA_PE] ,                                              
	                    [COD_ORIGEM_PESSOA_PE] ,                                               
                        --------------------------------------SUB ESTIPULANTE------------------------------------------------
	                    [COD_CLIENTE_PSE] ,                                           
	                    [NUM_OCORR_ENDERECO_PSE] ,                                    
	                    [NOM_PESSOA_PSE] ,    
                        CASE
                        		WHEN IND_TIPO_PESSOA_PSE = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PSE as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PSE = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PSE as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PSE as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PSE ,   
	                    [DTH_NASCIMENTO_PSE] ,                                        
                        CASE WHEN [COD_SEXO_PSE] = ''F'' THEN 2
                             WHEN [COD_SEXO_PSE] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PSE],                                              
	                    [COD_ESTADO_CIVIL_PSE] ,                                      
	                    [DES_ESTADO_CIVIL_PSE] ,                                      
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PSE = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PSE = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PSE] ,                                           
	                    [DES_EMAIL_PSE] ,                                             
	                    [NUM_IDENTIDADE_PSE] ,                                        
	                    [DES_ORGAO_EXPEDIDOR_PSE] ,                                   
	                    [COD_UF_EXPEDIDORA_PSE] ,                                     
	                    [DTH_EXPEDICAO_PSE] ,                                         
	                    [COD_DDD_TELEFONE_PSE] ,                                      
	                    [COD_TELEFONE_PSE] ,                                          
	                    [COD_DDD_CELULAR_PSE] ,                                       
	                    [COD_CELULAR_PSE] ,  
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PSE]) [COD_CBO_PSE],                                         
	                    [DES_ENDERECO_PSE] ,                                          
	                    [DES_BAIRRO_PSE] ,                                            
	                    [DES_CIDADE_PSE] ,                                            
	                    [COD_UF_PSE] ,                                                
	                    [DES_COMPLEMENTO_ENDERECO_PSE] ,                              
	                    [NUM_IMOVEL_PSE] ,                                            
	                    [COD_CEP_PSE] ,                                               
	                    [COD_BANCO_PSE] ,                                             
	                    [COD_AGENCIA_PSE] ,                                           
	                    [NUM_CONTA_PSE] ,                                             
	                    [NUM_DV_CONTA_PSE] ,                                          
	                    [NUM_OPERACAO_CONTA_PSE] ,                                    
	                    [COD_ORIGEM_PSESSOA_PSE] ,                                    
                        --------------------------------------SEGURADO-------------------------------------------------------
	                    [COD_CLIENTE_PS] ,                                                   
	                    [NUM_OCORR_ENDERECO_PS] ,                                            
	                    [NOM_PESSOA_PS] ,                                                    
                        CASE
                        		WHEN IND_TIPO_PESSOA_PS = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PS as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PS = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PS as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PS as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PS ,                                                  
	                    [DTH_NASCIMENTO_PS] ,                                                
	                    CASE WHEN [COD_SEXO_PS] = ''F'' THEN 2
                             WHEN [COD_SEXO_PS] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PS] ,                                                      
	                    [COD_ESTADO_CIVIL_PS] ,                                              
	                    [DES_ESTADO_CIVIL_PS] ,  
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PS = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PS = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PS] ,                                              
                                             
	                    [DES_EMAIL_PS] ,                                                     
	                    [NUM_IDENTIDADE_PS] ,                                                
	                    [DES_ORGAO_EXPEDIDOR_PS] ,                                           
	                    [COD_UF_EXPEDIDORA_PS] ,                                             
	                    [DTH_EXPEDICAO_PS] ,                                                 
	                    [COD_DDD_TELEFONE_PS] ,                                              
	                    [COD_TELEFONE_PS] ,                                                  
	                    [COD_DDD_CELULAR_PS] ,                                               
	                    [COD_CELULAR_PS] ,  
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PS]) [COD_CBO_PS],                                                 
	                    [DES_ENDERECO_PS] ,                                                  
	                    [DES_BAIRRO_PS] ,                                                    
	                    [DES_CIDADE_PS] ,                                                    
	                    [COD_UF_PS] ,                                                        
	                    [DES_COMPLEMENTO_ENDERECO_PS] ,                                      
	                    [NUM_IMOVEL_PS] ,                                                    
	                    [COD_CEP_PS] ,                                                       
	                    [COD_BANCO_PS] ,                                                     
	                    [COD_AGENCIA_PS] ,                                                   
	                    [NUM_CONTA_PS] ,                                                     
	                    [NUM_DV_CONTA_PS] ,                                                  
	                    [NUM_OPERACAO_CONTA_PS] ,                                            
	                    [COD_ORIGEM_PESSOA_PS]                                              
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaContrato] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[Contrato_SSD_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      UPDATE [Contrato_SSD_TEMP] SET DTH_PROPOSTA = DTH_VENDA WHERE DTH_VENDA IS NOT NULL AND DTH_PROPOSTA IS NULL 
   
   --SELECT * FROM DBO.Contrato_SSD_TEMP SSD WHERE SSD.[NUM_PROPOSTA_TRATADO] IS NULL

    ;MERGE INTO Dados.Proposta AS T
	    USING (
                SELECT SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo], 
					SSD.[STA_ANTECIPACAO] as BitAntecipacao,SSD.[STA_MUDANCA_PLANO] as BitMudancaPlano
                FROM dbo.CONTRATO_SSD_TEMP SSD				
            --WHERE PGTO.[RANK] = 1              
            ) X
        ON T.NumeroProposta = X.NumeroProposta  
    AND T.IDSeguradora = X.IDSeguradora
    WHEN NOT MATCHED
		        THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo , BitAntecipacao , BitMudancaPlano)
		            VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, ISNULL(X.DataArquivo, '1900-01-01'),X.BitAntecipacao , X.BitMudancaPlano);		   
       
--SELECT * FROM dbo.CONTRATO_SSD_TEMP SSD  WHERE [NUM_PROPOSTA_TRATADO] IS NULL    
                    
                      --, SSD.[VLR_IOF] 
	                  --, SSD.[VLR_CUSTO_EMISSAO]  
                      --, SSD.[NUM_MATRICULA_ECONOM]                                                          
	                  --, SSD.[NUM_MATRICULA_PDV]                                                             
	                  --, SSD.[NUM_APOLICE_ANTERIOR]                                                          
	                  --, SSD.[IND_RENOVACAO]               
                      --, SSD.[COD_SUBGRUPO]                                                                  
	                  --, SSD.[IND_PERI_PAGAMENTO]                                                            
	                  --, SSD.[COD_OPCAO_PAGAMENTO] 
	-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta]
                  , SSD.[ID_SEGURADORA] [IDSeguradora]
                  , SSD.[NOM_PESSOA_PS] [Nome]
                                                                   
                  ,  [COD_CPF_CNPJ_PS] CPFCNPJ                                                   
	              ,  Cast([DTH_NASCIMENTO_PS] as date) DataNascimento                                                
	              ,  [COD_SEXO_PS] IDSexo                                                       
	              ,  EC.ID [IDEstadoCivil]                                               
	              ,  [IND_TIPO_PESSOA_PS] [TipoPessoa]                                                
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros([DES_EMAIL_PS]) [Email]                                                     
	              ,  LTRIM(RTRIM(CleansingKit.dbo.fn_RemoveLeadingZeros([NUM_IDENTIDADE_PS]))) [Identidade]                                                
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros([DES_ORGAO_EXPEDIDOR_PS]) [OrgaoExpedidor]                                           
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros( [COD_UF_EXPEDIDORA_PS]) [UFOrgaoExpedidor]                                             
	              ,  Cast([DTH_EXPEDICAO_PS] as date) [DataExpedicaoRG]                                                
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_DDD_TELEFONE_PS]) [DDDResidencial]                                              
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros(CASE WHEN [COD_TELEFONE_PS] < 0 THEN NULL ELSE [COD_TELEFONE_PS] END) [TelefoneResidencial]                                                  
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_DDD_CELULAR_PS]) [DDDCelular]                                               
	              ,  CleansingKit.dbo.fn_RemoveLeadingZeros(CASE WHEN [COD_CELULAR_PS] < 0 THEN NULL ELSE [COD_CELULAR_PS] END) [TelefoneCelular]                     
                  --,  CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PS]) [CodigoProfissao] -- COMENTADO POR PEDRO
                  ,  [NUM_MATRICULA_ECONOM] [Matricula]    
                  , SSD.[TIPO_DADO] [TipoDado]
                  , Cast(SSD.[DATA_ATUALIZACAO] as date)[DataArquivo]
              FROM CONTRATO_SSD_TEMP SSD
              INNER JOIN Dados.Proposta PRP
              ON PRP.NumeroProposta = SSD.[NUM_PROPOSTA_TRATADO]
              AND PRP.IDSeguradora = 1
              LEFT JOIN Dados.EstadoCivil EC
              ON EC.Descricao = SSD.DES_ESTADO_CIVIL_PS
              WHERE  SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL
              --ORDER BY LEN([COD_DDD_TELEFONE_PS] ) DESC
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN MATCHED THEN 
         UPDATE
	  SET [Nome] = COALESCE(X.[Nome], T.[Nome])
		, CPFCNPJ = COALESCE(X.CPFCNPJ, T.CPFCNPJ)
		, DataNascimento = COALESCE(X.DataNascimento, T.DataNascimento)
        , IDSexo = COALESCE(X.IDSexo, T.IDSexo)
        , [IDEstadoCivil] = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil])
        , [TipoPessoa] = COALESCE(X.[TipoPessoa], T.[TipoPessoa])
        , [Email] = COALESCE(X.[Email], T.[Email])
        , [Identidade] = COALESCE(X.[Identidade], T.[Identidade])
        , [OrgaoExpedidor] = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor])
        , [DataExpedicaoRG] = COALESCE(X.[DataExpedicaoRG], T.[DataExpedicaoRG])
        , [DDDResidencial] = COALESCE(X.[DDDResidencial], T.[DDDResidencial])
        , [TelefoneResidencial] = COALESCE(X.[TelefoneResidencial], T.[TelefoneResidencial])
        , [DDDCelular] = COALESCE(X.[DDDCelular], T.[DDDCelular])
        , [TelefoneCelular] = COALESCE(X.[TelefoneCelular], T.[TelefoneCelular])
        --, [CodigoProfissao] = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao]) COMENTADO POR PEDRO
        , [Matricula] = COALESCE(X.[Matricula], T.[Matricula])
        , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
        , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
     WHEN NOT MATCHED
	          THEN INSERT (   IDProposta
                            , CPFCNPJ
                            , Nome
                            , DataNascimento
                            , TipoPessoa
                            , IDSexo
                            , IDEstadoCivil
                            , Identidade
                            , OrgaoExpedidor
                            , UFOrgaoExpedidor
                            , DataExpedicaoRG
                            , DDDResidencial
                            , TelefoneResidencial
                            , Email
                            --, CodigoProfissao COMENTADO POR PEDRO
                            , DDDCelular
                            , TelefoneCelular
                            , Matricula
                            , [TipoDado]
                            , [DataArquivo])
	               VALUES (X.IDProposta 
                         , X.CPFCNPJ
                         , X.Nome
                         , X.DataNascimento
                         , X.TipoPessoa
                         , X.IDSexo
                         , X.IDEstadoCivil
                         , X.Identidade
                         , X.OrgaoExpedidor
                         , X.UFOrgaoExpedidor
                         , X.DataExpedicaoRG
                         , X.DDDResidencial
                         , X.TelefoneResidencial
                         , X.Email
                         --, X.CodigoProfissao COMENTADO POR PEDRO
                         , X.DDDCelular
                         , X.TelefoneCelular
                         , X.Matricula
                         , X.[TipoDado]
                         , X.[DataArquivo]);
                   
        
---------------------------------begin PROPOSTA SITUACAO----------------------------------------------------------


    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaSituacaoContratual SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaSituacaoContratual PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
                                   ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                                  AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora  
                                 -- AND PS.DataInicioSituacao < SSD.DATA_SITUACAO
                            --WHERE PRP.ID = PS.IDProposta
                            )
           AND PS.LastValue = 1


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Status recebidos no SSD
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PropostaSituacaoContratual AS T
		USING (
        SELECT 
               PRP.ID [IDProposta],  SC.ID [IDSituacaoContratual]
             , SSD.DATA_SITUACAO [DataInicioSituacao], SSD.[DATA_ATUALIZACAO] DataArquivo
             , [TIPO_DADO] TipoDado --, PGTO.[Codigo]
        FROM [dbo].CONTRATO_SSD_TEMP SSD
          INNER JOIN Dados.Proposta PRP
          ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          INNER JOIN Dados.SituacaoContratual SC
          ON SSD.[IDSUBSITUACAO] = SC.ID
		  --AND PRP.ID = 41090394
		  --SELECT * FROM Dados.PropostaSituacaoContratual where idproposta =41090394
    
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.[DataInicioSituacao] = T.[DataInicioSituacao]
   AND X.[IDSituacaoContratual] = T.[IDSituacaoContratual]
    WHEN MATCHED
			    THEN UPDATE
			     SET 
                [DataArquivo] = X.[DataArquivo]
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
    WHEN NOT MATCHED
			    THEN INSERT          
              (
               [IDProposta],  [IDSituacaoContratual] 
             , [DataArquivo], [DataInicioSituacao], [TipoDado]
             , LastValue        
              )
          VALUES (X.[IDProposta]
                 ,X.[IDSituacaoContratual]
                 ,X.[DataArquivo]       
                 ,X.[DataInicioSituacao]    
                 ,X.[TipoDado]
                 ,0
                 ); 
    
    --Atualiza LastValue PropostaSituacaoContratual  para 1         
    WITH CTE 
    AS 
    (
     SELECT DISTINCT PRP.ID [IDProposta]
     FROM Dados.Proposta PRP                      
      INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
           ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
      )  
    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacaoContratual SET LastValue = 1
    FROM  CTE
    CROSS APPLY (SELECT TOP 1 ID
                 FROM Dados.PropostaSituacaoContratual PS1
                 WHERE PS1.IDProposta = CTE.IDProposta -- idproposta =41090394 --				  
                 ORDER BY [IDProposta] ASC,
	                      [DataInicioSituacao] DESC,
						  [DataArquivo] DESC
                 ) LASTVALUE 
    INNER JOIN Dados.PropostaSituacaoContratual PS
    ON PS.ID = LASTVALUE.ID;
    
    ---------------------------------end PROPOSTA SITUACAO----------------------------------------------------------

     --SELECT SSD.NUM_APOLICE [NumeroContrato]
     --                 , SSD.[ID_SEGURADORA] [IDSeguradora]
     --                 , SSD.[COD_CPF_CNPJ_PSE]
     --                 , SSD.[TIPO_DADO] [TipoDado]
     --                 , SSD.[DATA_ATUALIZACAO] [DataArquivo]
     --            FROM dbo.CONTRATO_SSD_TEMP SSD
     --            WHERE [COD_CPF_CNPJ_PSE] IS NOT NULL
    
    
    -- TODO         , RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(10)),8) [IDIndicador]                    
    
   -- SELECT * FROM Dados.Funcionario WHERE ID IN (353, 627)
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir indicador (Funcionário Caixa)
    -----------------------------------------------------------------------------------------------------------------------
    MERGE INTO Dados.Funcionario AS T
		USING (
                SELECT DISTINCT
                        RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(10)),8) Matricula
                       ,  1 [IDEmpresa] -- Caixa Econômica
                       ,  MAX(Cast(SSD.[DATA_ATUALIZACAO] AS Date)) DataArquivo
                       , [TIPO_DADO] TipoDado --, PGTO.[Codigo]
                FROM [dbo].CONTRATO_SSD_TEMP SSD
                WHERE  SSD.[NUM_MATRICULA_VENDEDOR] IS NOT NULL AND SSD.[NUM_MATRICULA_VENDEDOR] <> 0 AND LEN(SSD.[NUM_MATRICULA_VENDEDOR]) < 11
              --  AND SSD.[NUM_MATRICULA_VENDEDOR]  = 07777777
                GROUP BY RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(10)),8), [TIPO_DADO]
          ) AS X
    ON   X.Matricula = T.Matricula   
	 AND X.IDEmpresa = T.IDEmpresa
      WHEN NOT MATCHED
			    THEN INSERT          
              (
                    Matricula
                 ,  [IDEmpresa] 
                 ,  [DataArquivo]
                 ,  NomeArquivo
  
              )
          VALUES (X.Matricula
                 ,X.[IDEmpresa]
                 ,X.[DataArquivo]       
                 ,X.[TipoDado]
                 ); 

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Unidade (Agência Caixa)
    -----------------------------------------------------------------------------------------------------------------------
    MERGE INTO Dados.Unidade AS T
		USING (
                SELECT DISTINCT
                       [COD_AGENCIA] Codigo        
                       ,  MAX(Cast(SSD.[DATA_ATUALIZACAO] AS Date)) DataArquivo
                       , [TIPO_DADO] TipoDado --, PGTO.[Codigo]
                FROM [dbo].CONTRATO_SSD_TEMP SSD
                WHERE  SSD.[COD_AGENCIA] <> 0 AND SSD.[COD_AGENCIA] IS NOT NULL
              --  AND SSD.[NUM_MATRICULA_VENDEDOR]  = 07777777
                GROUP BY [COD_AGENCIA], [TIPO_DADO]
          ) AS X
    ON   X.Codigo = T.Codigo   
      WHEN NOT MATCHED
			    THEN INSERT          
              (
                 Codigo
              )
          VALUES (Codigo
                 ); 

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as apólices (Contratos Anteriores) ainda não registradas
    -----------------------------------------------------------------------------------------------------------------------
    ;MERGE INTO Dados.Contrato AS T
	      USING (
                 SELECT DISTINCT
                        SSD.NUM_APOLICE_ANTERIOR [NumeroContrato]
                      , SSD.[ID_SEGURADORA] [IDSeguradora]
                      , SSD.[TIPO_DADO] [TipoDado]
                      , SSD.[DATA_ATUALIZACAO] [DataArquivo]
                 FROM dbo.CONTRATO_SSD_TEMP SSD
                 WHERE SSD.NUM_APOLICE_ANTERIOR <> '0' 
                   and SSD.NUM_APOLICE_ANTERIOR is not null
                 --WHERE SSD.[IND_ORIGEM_REGISTRO_CONTRATO] = 2
                 --WHERE [COD_CPF_CNPJ_PE] IS NOT NULL
                 --WHERE PGTO.[RANK] = 1              
              ) X
         ON T.NumeroContrato = X.[NumeroContrato]
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT 
                             (
                               [IDSeguradora]
                             , [NumeroContrato]                            
                             , Arquivo
                             , [DataArquivo]
                             
                             )
		               VALUES (
                               X.[IDSeguradora]
                             , X.[NumeroContrato]
                             , X.TipoDado
                             , ISNULL(X.[DataArquivo],'1900-01-01'))	;

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as apólices (Contratos) ainda não registradas
    -----------------------------------------------------------------------------------------------------------------------
    WITH CTE
    AS
    (         
        SELECT  
                  SSD.NUM_APOLICE [NumeroContrato]
                , SSD.[ID_SEGURADORA] [IDSeguradora]
                , SSD.COD_CPF_CNPJ_PE
                , SSD.COD_CPF_CNPJ_PS
                , CASE WHEN SSD.[IND_ORIGEM_REGISTRO_CONTRATO] = '2' THEN SSD.[NUM_BIL_CERTIF] ELSE NULL END [NumeroBilhete]
                , PRP.ID [IDProposta]
                , F.ID [IDIndicador]
                , SSD.[DTH_EMISSAO]  DataEmissao                                               
	            , SSD.[DTH_INI_VIGENCIA]  DataInicioVigencia                                                            
	            , SSD.[DTH_FIM_VIGENCIA] DataFimVigencia                                                             
	            , SSD.[VLR_PREMIO_LIQ_ATUAL] ValorPremioLiquidoAtual                                                         
	            , SSD.[VLR_PREMIO_BRUTO_ATUAL] ValorPremioTotalAtual     
                      
                , SSD.[VLR_PREMIO_BRUTO_INICIAL] ValorPremioTotal     
                , SSD.[VLR_PREMIO_LIQ_INICIAL] ValorPremioLiquido     
                                                            
	            , SSD.[NUM_QTD_PARCELAS] [QuantidadeParcelas]

                , SSD.[IND_ORIGEM_REGISTRO_CONTRATO]
                , SSD.[TIPO_DADO] [TipoDado]
                , ISNULL(SSD.[DATA_ATUALIZACAO],getdate()) [DataArquivo]
                , ROW_NUMBER() OVER(PARTITION BY SSD.NUM_APOLICE ORDER BY SSD.NUM_APOLICE, SSD.[NUM_PROPOSTA_TRATADO]) SEQ
            FROM dbo.CONTRATO_SSD_TEMP SSD
            INNER JOIN Dados.Proposta PRP
            ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
        OUTER APPLY (SELECT ID FROM Dados.Funcionario F
                        WHERE RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(20)),8) = F.Matricula
                            AND SSD.[NUM_MATRICULA_VENDEDOR] IS NOT NULL AND SSD.[NUM_MATRICULA_VENDEDOR] <> 0 AND LEN(SSD.[NUM_MATRICULA_VENDEDOR]) < 11
							AND F.IDEmpresa = 1 ) F
            WHERE SSD.NUM_APOLICE <> '0' 
            and SSD.NUM_APOLICE is not null AND SSD.DATA_ATUALIZACAO IS NOT NULL
            --and SSD.NUM_APOLICE = '109300000959'-- '108208874329'
            --WHERE SSD.[IND_ORIGEM_REGISTRO_CONTRATO] = 2
            --WHERE [COD_CPF_CNPJ_PE] IS NOT NULL
            --WHERE PGTO.[RANK] = 1           
    )
    MERGE INTO Dados.Contrato AS T
	      USING (                
                 --É necessário tratar a apólice guarda-chuva, já que ela não pode receber nenhum valor referente ao Contrato do Segurado
                 --Para isso, verifica-se se o CPFCNPJ do Estipulante é diferente daquele segurado. Se sim, é apólice guarda-chuva
                 --Data: 2014/07/24 - Egler 
                  SELECT                             
                          CTE.[NumeroContrato]
                        , CTE. [IDSeguradora]
                        , CTE.COD_CPF_CNPJ_PE
                        , CTE.COD_CPF_CNPJ_PS
                        , CTE.[NumeroBilhete]
                        , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.[IDProposta] END [IDProposta]
                        , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.[IDIndicador] END [IDIndicador]
                        , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.DataEmissao END DataEmissao
	                    , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.DataInicioVigencia END DataInicioVigencia                                                            
	                    , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.DataFimVigencia END DataFimVigencia                                                           
	                    , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.ValorPremioLiquidoAtual END ValorPremioLiquidoAtual                                                       
	                    , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.ValorPremioTotalAtual END ValorPremioTotalAtual    
                      
                        , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.ValorPremioTotal END ValorPremioTotal       
                        , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.ValorPremioLiquido END ValorPremioLiquido       
                                                            
	                    , CASE WHEN COD_CPF_CNPJ_PE <> CTE.COD_CPF_CNPJ_PS THEN NULL ELSE CTE.[QuantidadeParcelas] END [QuantidadeParcelas]   

                        , CTE.[IND_ORIGEM_REGISTRO_CONTRATO]
                        , CTE.[TipoDado]
                        , CTE.[DataArquivo]

                  FROM CTE
                  WHERE CTE.SEQ = 1  
                         
              ) X
         ON T.NumeroContrato = X.[NumeroContrato]
        AND T.IDSeguradora = X.IDSeguradora
        WHEN MATCHED THEN 
                UPDATE
	        SET 
              NumeroBilhete = COALESCE(X.NumeroBilhete, T.NumeroBilhete)
            , [IDProposta] = COALESCE(X.[IDProposta], T.[IDProposta])
            , ValorPremioTotal = COALESCE(X.ValorPremioTotal, T.ValorPremioTotal)     
            , ValorPremioLiquido = COALESCE(X.ValorPremioLiquido, T.ValorPremioLiquido)       
            , DataEmissao = COALESCE(X.DataEmissao, T.DataEmissao)                                              
	        , DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)                                                           
	        , DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)                                                            
	        , ValorPremioLiquidoAtual = COALESCE(X.ValorPremioLiquidoAtual, T.ValorPremioLiquidoAtual)                                                        
	        , ValorPremioTotalAtual = COALESCE(X.ValorPremioTotalAtual, T.ValorPremioTotalAtual)    
	        , IDIndicador = COALESCE(X.IDIndicador, T.IDIndicador)                          
	        , QuantidadeParcelas = COALESCE(X.QuantidadeParcelas, T.QuantidadeParcelas)
            --, SSD.[IND_ORIGEM_REGISTRO_CONTRATO]
            , [Arquivo] = COALESCE(X.[TipoDado], T.[Arquivo])
            , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
         WHEN NOT MATCHED
		          THEN INSERT 
                             (
                               [IDSeguradora]
                             , [NumeroContrato]
                             , [NumeroBilhete]
                             , [IDProposta]
                             , ValorPremioTotal
                             , ValorPremioLiquido
                             , DataEmissao                                               
	                         , DataInicioVigencia                                                            
	                         , DataFimVigencia                                                             
	                         , ValorPremioLiquidoAtual                                                         
	                         , ValorPremioTotalAtual     
	                         , IDIndicador                           
	                         , QuantidadeParcelas
                             --, SSD.[IND_ORIGEM_REGISTRO_CONTRATO]
                             , Arquivo
                             , [DataArquivo]
                             
                             )
		               VALUES (
                               X.[IDSeguradora]
                             , X.[NumeroContrato]
                             , X.NumeroBilhete
                             , X.[IDProposta]
                             , X.ValorPremioTotal
                             , X.ValorPremioLiquido
                             , X.DataEmissao                                               
	                         , X.DataInicioVigencia                                                            
	                         , X.DataFimVigencia                                                             
	                         , X.ValorPremioLiquidoAtual                                                         
	                         , X.ValorPremioTotalAtual     
	                         , X.IDIndicador                           
	                         , X.QuantidadeParcelas
                             --, SSD.[IND_ORIGEM_REGISTRO_CONTRATO]
                             , X.TipoDado
                             , X.[DataArquivo])    
            ;
-----------------------------------------------------------------------------------------------------

    --TODO  ENDOSSO        --, SSD.[COD_SUBGRUPO]

    -----------------------------------------------------------------------------------------------------------------------
    -- TODO CONTRATO CLINETE
    -----------------------------------------------------------------------------------------------------------------------
    --                  , SSD.[COD_CPF_CNPJ_PE] [CPFCNPJ]
    --                  , SSD.[COD_CLIENTE_PE] [CodigoCliente]
    --                  , SSD.[IND_TIPO_PESSOA_PE] [TipoPessoa]   
    --                  , SSD.[NOM_PESSOA_PE] [NomeCliente]
    --                  , SSD.[DES_ENDERECO_PE] + ' - ' + SSD.[DES_COMPLEMENTO_ENDERECO_PE] + ' - ' + SSD.[NUM_IMOVEL_PE] [Endereco]                                                               
	--                  , SSD.[DES_BAIRRO_PE]  [Bairro]
	--                  , SSD.[DES_CIDADE_PE]  [Cidade]                                                                 
	--                  , SSD.[COD_UF_PE] [UF]  	                  
	--                  , SSD.[COD_CEP_PE] [CEP]  
    --                  , SSD.[COD_DDD_TELEFONE_PE] [DDD]
	--                  , SSD.[COD_TELEFONE_PE] [Telefone]

    -----------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para atualizar as propostas com os dados do contrato
    -----------------------------------------------------------------------------------------------------------------------

      ;MERGE INTO Dados.Proposta AS T
	      USING (
                 SELECT PRP.ID [IDProposta]
                      , CNT.ID [IDContrato]
                      , CNTA.ID [IDContratoAnterior]
                      , U.ID [IDAgenciaVenda]
                      , SSD.[DTH_PROPOSTA] DataProposta                                   
                      , SSD.[DTH_VENDA] DataVenda      
                      , SSD.[DTH_QUITACAO] DataQuitacao
                      , SSD.[DTH_EMISSAO] DataEmissao                                      
                      , SSD.[DTH_INI_VIGENCIA] DataInicioVigencia
                      , SSD.[DTH_FIM_VIGENCIA] DataFimVigencia
	                  , SSD.[VLR_PREMIO_LIQ_ATUAL] ValorPremioLiquidoTotal                                                         
	                  , SSD.[VLR_PREMIO_BRUTO_ATUAL] ValorPremioBrutoTotal                                
                      , SSD.[VLR_PREMIO_BRUTO_INICIAL] ValorPremioBrutoEmissao      
                      , SSD.[VLR_PREMIO_LIQ_INICIAL] ValorPremioLiquidoEmissao  
                      , SSD.[VLR_IOF] ValorIOF                                          
                      , SSD.[VLR_CUSTO_EMISSAO] ValorCustoEmissao                                 
                      , SSD.[COD_SUBGRUPO] SubGrupo                                     
                      , PP.ID [IDPeriodicidadePagamento]    
                      , PP.Codigo PeriodicidadePagamento --SSD.[IND_PERI_PAGAMENTO]  
                      , PSG.ID [IDProdutoSIGPF]                              
                      --, SSD.[COD_OPCAO_PAGAMENTO]                               
                      --, SSD.[NUM_MATRICULA_VENDEDOR]                            
                      , F.ID [IDFuncionario]
                      --, SSD.[NUM_MATRICULA_ECONOM]                              
                      --, SSD.[NUM_MATRICULA_PDV]    
                      , SSD.[IND_RENOVACAO] RenovacaoAutomatica                                    
                      --, SSD.[IND_ADIMPLENTE]                                    
                      --, SSD.[NUM_QTD_PARCELAS]                                  
                      --, SSD.[IND_ORIGEM_REGISTRO_CONTRATO] 
                                                            
	                  , SSD.[NUM_QTD_PARCELAS] [QuantidadeParcelas]

                      , SSD.[IND_ORIGEM_REGISTRO_CONTRATO] [OrigemProposta]
                      , [DATA_SITUACAO] [DataSituacaoContratual]
                      , [IDSUBSITUACAO] [IDSituacaoContratual]
                      , SSD.[TIPO_DADO] [TipoDado]
                      , SSD.[DATA_ATUALIZACAO] [DataArquivo]
					  , SSD.[STA_ANTECIPACAO] as BitAntecipacao
					  , SSD.[STA_MUDANCA_PLANO] as BitMudancaPlano
                 FROM Dados.Proposta PRP                      
                  INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
                       ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                      AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
                  LEFT JOIN Dados.Unidade U
                  ON U.Codigo = SSD.[COD_AGENCIA]
                  LEFT JOIN Dados.PeriodoPagamento PP
                  ON PP.Codigo = RIGHT('00' + [IND_PERI_PAGAMENTO],2)
                  LEFT JOIN Dados.Contrato CNT
                       ON CNT.NumeroContrato = SSD.NUM_APOLICE
                       AND CNT.IDSeguradora =[ID_SEGURADORA]
                  LEFT JOIN Dados.Contrato CNTA
                       ON CNTA.NumeroContrato = SSD.NUM_APOLICE_ANTERIOR
                       AND CNTA.IDSeguradora = [ID_SEGURADORA]
                  LEFT JOIN Dados.ProdutoSIGPF PSG
                       ON SSD.COD_PRODUTO_SIVPF > 0
                       AND PSG.CodigoProduto = RIGHT('00' + Cast(SSD.COD_PRODUTO_SIVPF AS varchar(4)),2)                       
                  OUTER APPLY (SELECT ID FROM Dados.Funcionario F
                               WHERE 
							      SSD.[NUM_MATRICULA_VENDEDOR] IS NOT NULL AND SSD.[NUM_MATRICULA_VENDEDOR] <> 0 AND LEN(SSD.[NUM_MATRICULA_VENDEDOR]) < 11
								  AND RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(12)),8) = F.Matricula
                                 AND F.IDEmpresa = 1 ) F
                 WHERE SSD.[NUM_PROPOSTA_TRATADO] <> '0'
                   and SSD.[NUM_PROPOSTA_TRATADO] is not null

               --WHERE PGTO.[RANK] = 1              
              ) X
         ON T.ID = X.[IDProposta]  
       WHEN MATCHED THEN 
           UPDATE
	          SET 
		          IDContrato = COALESCE(X.[IDContrato], T.[IDContrato])
                , [IDContratoAnterior] = COALESCE(X.[IDContratoAnterior], T.[IDContratoAnterior])
                , SubGrupo = COALESCE(X.SubGrupo, T.SubGrupo)
                , IDProdutoSIGPF = COALESCE(X.[IDProdutoSIGPF], T.[IDProdutoSIGPF])

		        , DataProposta = COALESCE(X.DataProposta, T.DataProposta)
                , DataVenda = COALESCE(X.DataVenda, T.DataVenda)                
                , DataEmissao = COALESCE(X.DataEmissao, T.DataEmissao)
                , DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)
                , DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
                --, DataQuitacao = COALESCE(X.DataQuitacao, T.DataQuitacao)
                ----------
                , ValorPremioLiquidoCalculado = COALESCE(X.ValorPremioLiquidoTotal, T.ValorPremioLiquidoCalculado)
                , ValorPremioBrutoCalculado = COALESCE(X.ValorPremioBrutoTotal, T.ValorPremioBrutoCalculado) 
                , ValorPremioTotal = COALESCE(X.ValorPremioBrutoTotal, T.ValorPremioTotal) 
                , ValorPremioLiquidoEmissao = COALESCE(X.ValorPremioLiquidoEmissao, T.ValorPremioLiquidoEmissao)
                , ValorPremioBrutoEmissao = COALESCE(X.ValorPremioBrutoEmissao, T.ValorPremioBrutoEmissao)
                
                , [IDPeriodicidadePagamento] = COALESCE(X.[IDPeriodicidadePagamento], T.[IDPeriodicidadePagamento])
                , PeriodicidadePagamento = COALESCE(X.PeriodicidadePagamento, T.PeriodicidadePagamento)
                , [IDFuncionario] = COALESCE(X.[IDFuncionario], T.[IDFuncionario])
                , [IDAgenciaVenda] = COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda]) 
                , RenovacaoAutomatica = COALESCE(X.RenovacaoAutomatica, T.RenovacaoAutomatica)
                , [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas]) 
                , OrigemProposta = COALESCE(X.OrigemProposta, T.OrigemProposta) 
                
                , [DataSituacaoContratual] = COALESCE(X.[DataSituacaoContratual], T.[DataSituacaoContratual]) 
                , [IDSituacaoContratual] = COALESCE(X.[IDSituacaoContratual], T.[IDSituacaoContratual]) 
                
                , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
                , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
				, [BitAntecipacao] = COALESCE(X.[BitAntecipacao],T.[BitAntecipacao])
				, [BitMudancaPlano] =   COALESCE(X.[BitMudancaPlano],T.[BitMudancaPlano])
				
				; 
                       
                      --, SSD.[VLR_IOF] 
	                  --, SSD.[VLR_CUSTO_EMISSAO]  
                      --, SSD.[NUM_MATRICULA_ECONOM]                                                          
	                  --, SSD.[NUM_MATRICULA_PDV]    
	-----------------------------------------------------------------------------------------------------------------------
	--SET IDENTITY_INSERT Dados.TipoMotivo On
	--insert into dados.TipoMotivo (ID, Codigo, Nome) VALUES (-3, -3, 'SSD')
	--SET IDENTITY_INSERT Dados.TipoMotivo off
--SELECT * FROM Dados.Proposta

    -- UNIQUE
	--[IDProposta] ASC,
	--[IDMotivo] ASC,
	--[Valor] ASC,
	--[DataArquivo] ASC


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para isererir ou atualizar o PagamentoEmissao
    -----------------------------------------------------------------------------------------------------------------------
      MERGE INTO Dados.PagamentoEmissao AS T
	      USING (
                 SELECT 
				 --SSD.*
				        DISTINCT
                        PRP.ID [IDProposta]
                      , SSD.[DTH_QUITACAO] DataEfetivacao
                      , Cast(SSD.[DTH_EMISSAO] as date) [DataArquivo]                                      
                      , SSD.[DTH_INI_VIGENCIA] DataInicioVigencia
                      , SSD.[DTH_FIM_VIGENCIA] DataFimVigencia
                      , SSD.[VLR_PREMIO_BRUTO_ATUAL] Valor      
                      , SSD.[VLR_IOF] ValorIOF                                          
                      , SSD.[VLR_CUSTO_EMISSAO] ValorCustoEmissao                                 
                      , '+' SinalLancamento
                      , '0' ExpectativaDeReceita      
					  , -3 IDMotivo --Inclusão pelo SSD
                      , SSD.[TIPO_DADO] [TipoDado]
                      , [TipoDado] + ISNULL(' ' +  Cast(Cast([DATA_ATUALIZACAO] as date) as varchar(10)),'') Arquivo
                      --, SSD.[DATA_ATUALIZACAO] [DataArquivo]
                 
                 FROM Dados.Proposta PRP                      
                  INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
                       ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                      AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
                 WHERE SSD.[DTH_EMISSAO] is not null

			   --WHERE PGTO.[RANK] = 1              
              ) X
         ON  T.IDProposta          = X.[IDProposta] 
		 AND T.DataArquivo         = X.DataArquivo
		 AND ISNULL(T.Valor,0)     = ISNULL(X.Valor,0)
		 AND ISNULL(T.IDMotivo,-3) = ISNULL(X.IDMotivo,-3)  
       WHEN MATCHED AND X.[DataArquivo] IS NOT NULL THEN 
           UPDATE
	          SET DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)
		        , DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
                , ValorIOF = COALESCE(X.ValorIOF, T.ValorIOF)
                , ValorCustoEmissao = COALESCE(X.ValorCustoEmissao, T.ValorCustoEmissao)
                , SinalLancamento = COALESCE(X.SinalLancamento, T.SinalLancamento)
                , ExpectativaDeReceita = COALESCE(X.ExpectativaDeReceita, T.ExpectativaDeReceita)
                , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
                , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
                , DataEfetivacao = COALESCE(X.DataEfetivacao, T.DataEfetivacao) 
                , Arquivo = COALESCE(X.Arquivo, T.Arquivo) 
       WHEN NOT MATCHED
		          THEN INSERT 
                             (
                               [IDProposta]
                             , DataEfetivacao
                             , [DataArquivo]
                             , DataInicioVigencia
                             , DataFimVigencia
                             , Valor
                             , ValorIOF                                               
	                        
	                         , ValorCustoEmissao                                                         
	                         , SinalLancamento     
	                         , ExpectativaDeReceita  
                             , IDMotivo 
                             , TipoDado                        
                             , Arquivo
                             )
		               VALUES (
                               X.[IDProposta]
                             , X.DataEfetivacao
                             , X.[DataArquivo]
                             , X.DataInicioVigencia
                             , X.DataFimVigencia
                             , X.Valor
                             , X.ValorIOF                                               
                                                          
	                         , X.ValorCustoEmissao                                                         
	                         , X.SinalLancamento     
	                         , X.ExpectativaDeReceita                           
                             , X.IDMotivo
                             , X.TipoDado
                             , X.[Arquivo]);
                       
                      --, SSD.[VLR_IOF] 
	                  --, SSD.[VLR_CUSTO_EMISSAO]  
                      --, SSD.[NUM_MATRICULA_ECONOM]                                                          
	                  --, SSD.[NUM_MATRICULA_PDV]    
	-----------------------------------------------------------------------------------------------------------------------
--SELECT * FROM Dados.PagamentoEmissao WHERE IDProposta = 8898140 ORDER BY Arquivo DESC

--SELECT * FROM Dados.PropostaCliente
    -----------------------------------------------------------------------------------------------------------------------
    --Verifica o Produto SIGPF para inserir o certificado
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir um Certificado das propostas cujos status estão disponíveis na fato FM_039_FATO_SITUACAO_CONTRATO_VIDA 
      ;MERGE INTO Dados.Certificado AS T
      USING (
                 SELECT   
                         --, PRP.Nome 
                          PRP.ID [IDProposta]
                        , CNT.ID [IDContrato]
                        , SSD.[ID_SEGURADORA] [IDSeguradora]
                        , SSD.[NUM_CERTIFICADO_TRATADO] [NumeroCertificado]
                        , SSD.[COD_CPF_CNPJ_PS] CPF
                        , SSD.NOM_PESSOA_PS [NomeCliente]
                        , Cast(SSD.DTH_NASCIMENTO_PS as date) [DataNascimento]
                        , U.ID [IDAgencia]
                        , F.ID [IDIndicador]
                        , F.Matricula [MatriculaIndicador]
                        , Cast(ISNULL(SSD.[DTH_INI_VIGENCIA], '1900-01-01') as date) DataInicioVigencia
                        , Cast(ISNULL(SSD.[DTH_FIM_VIGENCIA] , '9999-12-31') as date) DataFimVigencia	 
                        , Cast(SSD.DTH_CANCELAMENTO as date) DataCancelamento
                        , SSD.[VLR_PREMIO_LIQ_ATUAL] ValorPremioLiquido                                                         
	                    , SSD.[VLR_PREMIO_BRUTO_ATUAL] ValorPremioBruto   
                        , [TipoDado] + ISNULL(' ' +  Cast(Cast([DATA_ATUALIZACAO] as date) as varchar(10)),'') Arquivo
                        , Cast(SSD.[DATA_ATUALIZACAO] as date) [DataArquivo]
                 FROM Dados.Proposta PRP                      
                   INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
                       ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                      AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora --Caixa Seguros
                    -------------------------------------------------------------------------------------------------------------------
                   LEFT JOIN Dados.Unidade U
                   ON U.Codigo = SSD.[COD_AGENCIA]
					-------------------------------------------------------------------------------------------------------------------
					--Esse trecho foi adicionado para garantir que o Contrato fake será gerado quando o Produto for conhecido e este
					-- estiver marcado como produto sem certificado
					-- Autor: Egler - 2013/09/18
					-------------------------------------------------------------------------------------------------------------------
					LEFT JOIN Dados.ProdutoSIGPF PSG
					ON PSG.ID = PRP.IDProdutoSIGPF
					AND (PSG.ProdutoComCertificado IS NOT NULL OR PSG.ProdutoComCertificado = 1)
					AND (PSG.ID <> 0) /*Garante que a proposta foi recebida ou que de alguma forma sabe-se o Produto da Proposta.*/
					-------------------------------------------------------------------------------------------------------------------
	                LEFT JOIN Dados.Contrato CNT
                    ON CNT.NumeroContrato = SSD.NUM_APOLICE
                    AND CNT.IDSeguradora = 1
                    -------------------------------------------------------------------------------------------------------------------
                    OUTER APPLY (SELECT ID, Matricula FROM Dados.Funcionario F
                               WHERE RIGHT ('00000000' + Cast(SSD.[NUM_MATRICULA_VENDEDOR] as varchar(12)),8) = F.Matricula
							     AND SSD.[NUM_MATRICULA_VENDEDOR] IS NOT NULL AND SSD.[NUM_MATRICULA_VENDEDOR] <> 0 AND LEN(SSD.[NUM_MATRICULA_VENDEDOR]) < 11
                                 AND F.IDEmpresa = 1 ) F
                 
             ) X
    ON  T.IDSeguradora = X.[IDSeguradora] --Caixa Seguros
    AND T.NumeroCertificado = X.NumeroCertificado
    AND ISNULL(T.IDProposta, -1) = ISNULL(X.IDProposta, -1)
    WHEN MATCHED AND X.[DataArquivo] IS NOT NULL
       THEN UPDATE
             SET IDProposta = COALESCE(X.IDProposta, T.IDProposta)
               , [IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato])
               , [IDAgencia] = COALESCE(X.[IDAgencia], T.[IDAgencia])
               , CPF = COALESCE(X.CPF, T.CPF)
               , [NomeCliente] = COALESCE(X.[NomeCliente], T.[NomeCliente])
               , [DataNascimento] = COALESCE(X.[DataNascimento], T.[DataNascimento])
               , [IDIndicador] = COALESCE(X.[IDIndicador], T.[IDIndicador])
               , [MatriculaIndicador] = COALESCE(X.[MatriculaIndicador], T.[MatriculaIndicador])
               , ValorPremioLiquido = COALESCE(X.ValorPremioLiquido, T.ValorPremioLiquido)
               , ValorPremioBruto = COALESCE(X.ValorPremioBruto, T.ValorPremioBruto)
		   --------------------------------------------------------------------------------
			   -- Altera o início e fim de vigência do certificado através do status
			   --Egler - 2013/09/19
			   --------------------------------------------------------------------------------
               , DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)
               , DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
               , DataCancelamento = COALESCE(X.DataCancelamento, T.DataCancelamento)
			   --------------------------------------------------------------------------------
               , Arquivo = COALESCE(X.[Arquivo], T.[Arquivo])
               , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)
    WHEN NOT MATCHED 
       THEN INSERT
            (IDProposta
           , IDContrato
           , IDSeguradora
           , NumeroCertificado

           , CPF
           , [NomeCliente]
           , [DataNascimento]
           , [IDAgencia]
           , [IDIndicador]
           , [MatriculaIndicador]
           , ValorPremioLiquido 
           , ValorPremioBruto 

           , DataInicioVigencia
           , DataFimVigencia
           , DataCancelamento
           , DataArquivo
           , Arquivo
           )
            VALUES ( X.IDProposta, X.IDContrato, X.[IDSeguradora], X.NumeroCertificado 
                   , X.CPF
                   , X.[NomeCliente]
                   , X.[DataNascimento]
                   , X.[IDAgencia]
                   , X.[IDIndicador]
                   , X.[MatriculaIndicador]
                   , X.ValorPremioLiquido 
                   , X.ValorPremioBruto 
                   , X.DataInicioVigencia, X.DataFimVigencia, X.DataCancelamento, COALESCE(X.DataArquivo, '1900-01-01'), X.[Arquivo]);
                          
     --SELECT *   FROM Dados.Certificado
     -----------------------------------------------------------------------------------------------------------------------
                        
                        
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir O HISTORICO DO CERTIFICADO 
    --das propostas cujos status foram atualizados na fato FM_039_FATO_SITUACAO_CONTRATO_VIDA 
    -----------------------------------------------------------------------------------------------------------------------
     MERGE INTO Dados.CertificadoHistorico AS T
      USING (
                 SELECT   
                          CRT.ID [IDCertificado]
                        , 'SSD' NumeroProposta
                        , SSD.ID_SEGURADORA IDSeguradora
                        , SSD.[VLR_PREMIO_LIQ_ATUAL] ValorPremioLiquido                                                         
	                    , SSD.[VLR_PREMIO_BRUTO_ATUAL] ValorPremioBruto 
                        , ISNULL(SSD.[DTH_INI_VIGENCIA] , '1900-01-01') DataInicioVigencia
                        , ISNULL(SSD.[DTH_FIM_VIGENCIA] , '9999-12-31') DataFimVigencia
                        , DTH_CANCELAMENTO DataCancelamento	 	
                        , [NUM_QTD_PARCELAS] QuantidadeParcelas
                        , PP.ID [IDPeriodoPagamento]
                        , [COD_SUBGRUPO] CodigoSubEstipulante
                        , [TipoDado] + ISNULL(' ' +  Cast(Cast(SSD.[DATA_SITUACAO] as date) as varchar(10)),'') Arquivo
                        , SSD.[DATA_SITUACAO] [DataArquivo]
                 FROM Dados.Proposta PRP                      
                   INNER JOIN dbo.CONTRATO_SSD_TEMP SSD
                       ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                      AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora --Caixa Seguros
                  INNER JOIN Dados.Certificado CRT
                      ON CRT.NumeroCertificado = SSD.[NUM_CERTIFICADO_TRATADO]
                      AND CRT.IDSeguradora = SSD.ID_SEGURADORA --Caixa Seguros
                      AND CRT.IDProposta = PRP.ID     
                  LEFT JOIN Dados.PeriodoPagamento PP
                  ON PP.Codigo = RIGHT('00' + [IND_PERI_PAGAMENTO],2)
             ) X
    ON  T.NumeroProposta = X.NumeroProposta 
    AND T.[IDCertificado] = X.[IDCertificado] 
    AND ISNULL(T.DataArquivo, '1900-01-01') = ISNULL(X.DataArquivo,'1900-01-01')
    WHEN MATCHED AND X.[DataArquivo] IS NOT NULL
       THEN UPDATE
             SET 
                 DataInicioVigencia = COALESCE(X.DataInicioVigencia  ,T.DataInicioVigencia   )
               , DataFimVigencia =    COALESCE(X.DataFimVigencia     ,T.DataFimVigencia      )
               , DataCancelamento =   COALESCE(X.DataCancelamento    ,T.DataCancelamento     )
               , ValorPremioTotal =   COALESCE(X.ValorPremioBruto    ,T.ValorPremioTotal     )
               , ValorPremioLiquido = COALESCE(X.ValorPremioLiquido  ,T.ValorPremioLiquido   )
               , IDPeriodoPagamento = COALESCE(X.IDPeriodoPagamento  ,T.IDPeriodoPagamento   )
               , QuantidadeParcelas = COALESCE(X.QuantidadeParcelas  ,T.QuantidadeParcelas   )
               , Arquivo = X.[Arquivo]
    WHEN NOT MATCHED 
       THEN INSERT
                   ([IDCertificado], NumeroProposta, CodigoSubEstipulante, QuantidadeParcelas, ValorPremioTotal, ValorPremioLiquido
                  , IDPeriodoPagamento, DataInicioVigencia, DataFimVigencia, DataCancelamento, DataArquivo, Arquivo)
            VALUES (X.[IDCertificado], X.[NumeroProposta], X.CodigoSubEstipulante, X. QuantidadeParcelas, ISNULL(X.ValorPremioBruto,0.00), ISNULL(X.ValorPremioLiquido,0.00)
                  , X.IDPeriodoPagamento, X.DataInicioVigencia, X.DataFimVigencia, X.DataCancelamento, COALESCE(X.DataArquivo, '1900-01-01'), X.[Arquivo]);

 --SELECT * FROM   Dados.CertificadoHistorico AS T
 --TRUNCATE TABLE  Dados.CertificadoHistorico
 --SELECT * FROM [Contrato_SSD_TEMP]
    -----------------------------------------------------------------------------------------------------------------------




--SELECT DISTINCT IND_ORIGEM_REGISTRO_CONTRATO, COD_ESTADO_CIVIL_PS, DES_ESTADO_CIVIL_PS, [IND_TIPO_PESSOA_PS], [NUM_MATRICULA_ECONOM] FROM [Contrato_SSD_TEMP]
--SELECT DISTINCT * FROM [Contrato_SSD_TEMP] where len([COD_CELULAR_PS]) > 9 
--truncate table   dados.propostacliente


------------------------------------------------------------------
----Proposta Endereço

--TODO  -> NÃO HÁ IDENTIFICAÇÃO DO TIPO DE ENDEREÇO


------------------------------------------------------------------
----    [DES_ENDERECO_PS] ,                                                  
----    [DES_BAIRRO_PS] ,                                                    
----    [DES_CIDADE_PS] ,                                                    
----    [COD_UF_PS] ,                                                        
----    [DES_COMPLEMENTO_ENDERECO_PS] ,                                      
----    [NUM_IMOVEL_PS] ,                                                    
----    [COD_CEP_PS] ,                                                       
----    [COD_BANCO_PS] ,                                                     
----    [COD_AGENCIA_PS] ,                                                   
----    [NUM_CONTA_PS] ,                                                     
----    [NUM_DV_CONTA_PS] ,                                                  
----    [NUM_OPERACAO_CONTA_PS] ,                                            
----    [COD_ORIGEM_PESSOA_PS]  

--   /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
--	/*Egler - Data: 23/09/2013 */
--    UPDATE Dados.PropostaEndereco SET LastValue = 0
--   -- SELECT *
--    FROM Dados.PropostaEndereco PS
--    WHERE PS.IDProposta IN (
--	                        SELECT PRP.ID
--                            FROM dbo.CONTRATO_SSD_TEMP PRP_T
--							  INNER JOIN Dados.Proposta PRP
--							  ON PRP_T.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
--							 AND PRP.IDSeguradora = 1
--							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
--                           )
--           AND PS.LastValue = 1
    
                      
--     /***********************************************************************
--       Carrega os dados do Cliente da proposta
--     ***********************************************************************/                 
--    ;MERGE INTO Dados.PropostaEndereco AS T
--		USING (

--					SELECT   
--					    PRP.ID [IDProposta]
--						,TipoEndereco [IDTipoEndereco]
--						,PRP_T.Endereco        
--						,PRP_T.Bairro Bairro             
--						,PRP_T.Cidade Cidade       
--						,PRP_T.SiglaUF  [UF]      
--						,PRP_T.CEP CEP   
--						,'SSD.CONTRATO' [TipoDado]           
--						,PRP_T.DataArquivo DataArquivo	   								
--					FROM dbo.CONTRATO_SSD_TEMP PRP_T
--						INNER JOIN Dados.Proposta PRP
--						ON PRP_T.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
--						AND PRP.IDSeguradora = 1
--					WHERE  PRP_T.Endereco IS NOT NULL
--					   and PRP_T.TIPOENDERECO <> 0
--				) A 				

--          ) AS X
--    ON  X.IDProposta = T.IDProposta
--    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
--    --AND X.[DataArquivo] >= T.[DataArquivo]
--	AND X.[Endereco] = T.[Endereco]
--	AND NUMERADOR = 1 --Garante uma única ocorrência do mesmo endereço.
--       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
--		      UPDATE
--				SET 
--                 Endereco = COALESCE(X.[Endereco], T.[Endereco])
--               , Bairro = COALESCE(X.[Bairro], T.[Bairro])
--               , Cidade = COALESCE(X.[Cidade], T.[Cidade])
--               , UF = COALESCE(X.[UF], T.[UF])
--               , CEP = COALESCE(X.[CEP], T.[CEP])
--               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
--			   , DataArquivo = X.DataArquivo
--			   , LastValue = X.LastValue
--    WHEN NOT MATCHED
--			    THEN INSERT          
--              ( IDProposta, IDTipoEndereco, Endereco, Bairro                                                                
--              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                            
--          VALUES (
--                  X.[IDProposta]   
--                 ,X.[IDTipoEndereco]                                                
--                 ,X.[Endereco]  
--                 ,X.[Bairro]   
--                 ,X.[Cidade]      
--                 ,X.[UF] 
--                 ,X.[CEP]            
--                 ,X.[TipoDado]       
--                 ,X.[DataArquivo]
--				 ,X.LastValue   
--                 );
		
--	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
--	/*Egler - Data: 23/09/2013 */		 
--    UPDATE Dados.PropostaEndereco SET LastValue = 1
--    FROM Dados.PropostaEndereco PE
--	INNER JOIN (
--				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
--				FROM Dados.PropostaEndereco PS
--				WHERE PS.IDProposta IN (
--										SELECT PRP.ID
--										FROM dbo.PRPSASSE_TEMP PRP_T
--										  INNER JOIN Dados.Proposta PRP
--										  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
--										 AND PRP.IDSeguradora = 1
--									   )
--					) A
--	 ON A.ID = PE.ID 
--	 AND A.ORDEM = 1
     
--------------------------------------------------------------------

     
----------    -----------------------------------------------------------------------------------------------------------------------
----------    --Comando para inserir um ENDOSSO (1º Endosso) de emissão na marra 
----------    --das propostas cujo status de emissão foram recebidos no arquivo STASASSE
----------    -----------------------------------------------------------------------------------------------------------------------     
----------     INSERT INTO Dados.Endosso (IDContrato, IDProduto, NumeroEndosso, IDTipoEndosso, IDSituacaoEndosso
----------                               , Arquivo, DataArquivo, DataInicioVigencia, DataFimVigencia, ValorPremioTotal)
----------     SELECT [IDContrato], [IDProduto], [NumeroEndosso], [IDTipoEndosso], [IDSituacaoEndosso],
----------                                                                                  (SELECT TOP 1 NomeArquivo 
----------                                                                                  FROM dbo.STASASSE_TP2_TEMP PGTO1 
----------                                                                                  WHERE PGTO1.Codigo = A.Codigo) NomeArquivo,
----------                                                                                  (SELECT TOP 1 DataArquivo 
----------                                                                                  FROM dbo.STASASSE_TP2_TEMP PGTO1 
----------                                                                                  WHERE PGTO1.Codigo = A.Codigo) DataArquivo
----------          , DataInicioVigencia, DataFimVigencia, ValorPremioTotal
----------     FROM            
----------     (     
----------         SELECT   
----------                  CNT.ID [IDContrato], -1 [IDProduto] /*PRODUTO NÃO INDICADO*/, -1 [NumeroEndosso] /*ENDOSSO DE EMISSÃO FORÇACO*/
----------                  , 0 [IDTipoEndosso] /*ENDOSSO DE EMISSÃO*/ , 2 [IDSituacaoEndosso] /*ENDOSSO PAGO*/
----------                , MAX(PGTO.Codigo) Codigo, MAX(Valor) ValorPremioTotal
----------                , MIN(PGTO.DataInicioVigencia) DataInicioVigencia, MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	                         
----------         FROM dbo.STASASSE_TP2_TEMP PGTO
----------           INNER JOIN Dados.Contrato CNT
----------           ON CNT.NumeroContrato = PGTO.NumeroCertificado
----------           AND CNT.IDSeguradora = PGTO.IDSeguradora
----------         WHERE NOT EXISTS (
----------                           SELECT * FROM Dados.Endosso EN
----------                           WHERE EN.IDContrato = CNT.ID
----------                          )
----------              AND PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta
----------           AND PGTO.[RANK] = 1
----------           AND PGTO.SituacaoProposta = 'EMT'  
----------          GROUP BY CNT.ID
----------     ) A;
----------     -----------------------------------------------------------------------------------------------------------------------

            
		                   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada = '1900-01-01;' + Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Contrato_SSD'

TRUNCATE TABLE [dbo].Contrato_SSD_TEMP

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[Contrato_SSD_TEMP] 
				(      
				    [SUK_CONTRATO_VIDA], 
	                [NUM_BIL_CERTIF], 
	                [NUM_APOLICE], 
	                [NUM_PROPOSTA_SIVPF], 
	                [NUM_CONTRATO],  
	                [DTH_PROPOSTA],
	                [DTH_VENDA],
	                [DTH_QUITACAO] ,
	                [DTH_EMISSAO] ,                                                        
	                [DTH_INI_VIGENCIA] ,                                                   
	                [DTH_FIM_VIGENCIA] , 
                    [DTH_CANCELAMENTO],                                                  
	                [VLR_PREMIO_BRUTO_ATUAL] ,                                             
	                [VLR_PREMIO_LIQ_ATUAL] ,
                    VLR_PREMIO_LIQ_INICIAL,               
                    VLR_PREMIO_BRUTO_INICIAL,                                                            
	                [VLR_IOF] ,                                                            
	                [VLR_CUSTO_EMISSAO] ,                                                  
	                [COD_SUBGRUPO] ,                                                       
	                [IND_PERI_PAGAMENTO] ,                                                 
	                [COD_OPCAO_PAGAMENTO] ,                                                
	                [NUM_MATRICULA_VENDEDOR] ,                                             
	                [NUM_MATRICULA_ECONOM] ,                                               
	                [NUM_MATRICULA_PDV] ,                                                  
	                [NUM_APOLICE_ANTERIOR] ,                                               
	                [IND_RENOVACAO] ,                                                      
	                [IND_ADIMPLENTE] ,                                                     
	                [NUM_QTD_PARCELAS] ,                                                   
	                [IND_ORIGEM_REGISTRO_CONTRATO] ,    
					[STA_ANTECIPACAO] ,		
					[STA_MUDANCA_PLANO] ,					  
                    -------------------------------------PRODUTO----------------------------------------------------------
                    COD_PRODUTO_SIAS,
                    COD_PRODUTO_SIVPF,
                    COD_RAMO_EMISSOR,
                    COD_EMPRESA_SIAS,
                    -------------------------------------VENDEDOR---------------------------------------------------------  
	                [COD_CPF_CNPJ_VENDEDOR] ,                                                                  
	                [COD_MATRICULA_VENDEDOR] ,                                                                 
	                [IND_ORIGEM_REGISTRO_VENDEDOR] ,                                                           
	                [IND_TIPO_VENDEDOR] ,                                                                    
                    ---------------------------------------SITUACAO-------------------------------------------------------
	                [IDSUBSITUACAO],
                    [DATA_SITUACAO] ,    
                    [DATA_ATUALIZACAO],                                 
	                [QTD_CONTRATO] ,                                      
	                [QTD_PROPOSTA] ,                                      
                    ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
	                [COD_AGENCIA] ,                                                                
                    --------------------------------------ESTIPULANTE----------------------------------------------------
	                [COD_CLIENTE_PE] ,                                                     
	                [NUM_OCORR_ENDERECO_PE] ,                                              
	                [NOM_PESSOA_PE] ,                                                      
	                [COD_CPF_CNPJ_PE] ,                                                    
	                [DTH_NASCIMENTO_PE] ,                                                  
	                [COD_SEXO_PE] ,                                                        
	                [COD_ESTADO_CIVIL_PE] ,                                                
	                [DES_ESTADO_CIVIL_PE] ,                                                
	                [IND_TIPO_PESSOA_PE] ,                                                 
	                [DES_EMAIL_PE] ,                                                       
	                [NUM_IDENTIDADE_PE] ,                                                  
	                [DES_ORGAO_EXPEDIDOR_PE] ,                                             
	                [COD_UF_EXPEDIDORA_PE] ,                                               
	                [DTH_EXPEDICAO_PE] ,                                                   
	                [COD_DDD_TELEFONE_PE] ,                                                
	                [COD_TELEFONE_PE] ,                                                    
	                [COD_DDD_CELULAR_PE] ,                                                 
	                [COD_CELULAR_PE] ,                                                     
	                --[COD_CBO_PE] , 
                    [DES_ENDERECO_PE] ,  
   	                [DES_BAIRRO_PE] ,                                                      
	                [DES_CIDADE_PE] ,                                                      
	                [COD_UF_PE] ,                                                          
	                [DES_COMPLEMENTO_ENDERECO_PE] ,                                        
	                [NUM_IMOVEL_PE] ,                                                      
	                [COD_CEP_PE] ,                                                         
	                [COD_BANCO_PE] ,                                                       
	                [COD_AGENCIA_PE] ,                                                     
	                [NUM_CONTA_PE] ,                                                       
	                [NUM_DV_CONTA_PE] ,                                                    
	                [NUM_OPERACAO_CONTA_PE] ,                                              
	                [COD_ORIGEM_PESSOA_PE] ,                                               
                    --------------------------------------SUB ESTIPULANTE------------------------------------------------
	                [COD_CLIENTE_PSE] ,                                           
	                [NUM_OCORR_ENDERECO_PSE] ,                                    
	                [NOM_PESSOA_PSE] ,                                            
	                [COD_CPF_CNPJ_PSE] ,                                          
	                [DTH_NASCIMENTO_PSE] ,                                        
	                [COD_SEXO_PSE] ,                                              
	                [COD_ESTADO_CIVIL_PSE] ,                                      
	                [DES_ESTADO_CIVIL_PSE] ,                                      
	                [IND_TIPO_PESSOA_PSE] ,                                      
	                [DES_EMAIL_PSE] ,                                             
	                [NUM_IDENTIDADE_PSE] ,                                        
	                [DES_ORGAO_EXPEDIDOR_PSE] ,                                   
	                [COD_UF_EXPEDIDORA_PSE] ,                                     
	                [DTH_EXPEDICAO_PSE] ,                                         
	                [COD_DDD_TELEFONE_PSE] ,                                      
	                [COD_TELEFONE_PSE] ,                                          
	                [COD_DDD_CELULAR_PSE] ,                                       
	                [COD_CELULAR_PSE] ,  
                    --[COD_CBO_PSE] ,                                         
	                [DES_ENDERECO_PSE] ,                                          
	                [DES_BAIRRO_PSE] ,                                            
	                [DES_CIDADE_PSE] ,                                            
	                [COD_UF_PSE] ,                                                
	                [DES_COMPLEMENTO_ENDERECO_PSE] ,                              
	                [NUM_IMOVEL_PSE] ,                                            
	                [COD_CEP_PSE] ,                                               
	                [COD_BANCO_PSE] ,                                             
	                [COD_AGENCIA_PSE] ,                                           
	                [NUM_CONTA_PSE] ,                                             
	                [NUM_DV_CONTA_PSE] ,                                          
	                [NUM_OPERACAO_CONTA_PSE] ,                                    
	                [COD_ORIGEM_PSESSOA_PSE] ,                                    
                    --------------------------------------SEGURADO-------------------------------------------------------
	                [COD_CLIENTE_PS] ,                                                   
	                [NUM_OCORR_ENDERECO_PS] ,                                            
	                [NOM_PESSOA_PS] ,                                                    
	                [COD_CPF_CNPJ_PS] ,                                                  
	                [DTH_NASCIMENTO_PS] ,                                                
	                [COD_SEXO_PS] ,                                                      
	                [COD_ESTADO_CIVIL_PS] ,                                              
	                [DES_ESTADO_CIVIL_PS] ,                                              
	                [IND_TIPO_PESSOA_PS] ,                                               
	                [DES_EMAIL_PS] ,                                                     
	                [NUM_IDENTIDADE_PS] ,                                                
	                [DES_ORGAO_EXPEDIDOR_PS] ,                                           
	                [COD_UF_EXPEDIDORA_PS] ,                                             
	                [DTH_EXPEDICAO_PS] ,                                                 
	                [COD_DDD_TELEFONE_PS] ,                                              
	                [COD_TELEFONE_PS] ,                                                  
	                [COD_DDD_CELULAR_PS] ,                                               
	                [COD_CELULAR_PS] ,  
                    --[COD_CBO_PS],                                                 
	                [DES_ENDERECO_PS] ,                                                  
	                [DES_BAIRRO_PS] ,                                                    
	                [DES_CIDADE_PS] ,                                                    
	                [COD_UF_PS] ,                                                        
	                [DES_COMPLEMENTO_ENDERECO_PS] ,                                      
	                [NUM_IMOVEL_PS] ,                                                    
	                [COD_CEP_PS] ,                                                       
	                [COD_BANCO_PS] ,                                                     
	                [COD_AGENCIA_PS] ,                                                   
	                [NUM_CONTA_PS] ,                                                     
	                [NUM_DV_CONTA_PS] ,                                                  
	                [NUM_OPERACAO_CONTA_PS] ,                                            
	                [COD_ORIGEM_PESSOA_PS] 
				)  
                SELECT 
                        [SUK_CONTRATO_VIDA] , 
	                    [NUM_BIL_CERTIF] , 
	                    [NUM_APOLICE] , 
	                    [NUM_PROPOSTA_SIVPF] , 
	                    [NUM_CONTRATO] ,   
	                    [DTH_PROPOSTA] ,
	                    [DTH_VENDA],
	                    [DTH_QUITACAO] ,
	                    [DTH_EMISSAO] ,                                                        
	                    [DTH_INI_VIGENCIA] ,                                                   
	                    [DTH_FIM_VIGENCIA] ,        
                        [DTH_CANCELAMENTO],                                           
	                    CASE WHEN [VLR_PREMIO_BRUTO_ATUAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_BRUTO_ATUAL] END [VLR_PREMIO_BRUTO_ATUAL],                                              
	                    CASE WHEN [VLR_PREMIO_LIQ_ATUAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_LIQ_ATUAL] END [VLR_PREMIO_LIQ_ATUAL], 
                        CASE WHEN [VLR_PREMIO_LIQ_INICIAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_LIQ_INICIAL] END [VLR_PREMIO_LIQ_INICIAL],                   
                        CASE WHEN [VLR_PREMIO_BRUTO_INICIAL] <= 0.00 THEN NULL ELSE [VLR_PREMIO_BRUTO_INICIAL] END [VLR_PREMIO_BRUTO_INICIAL],  
	                    [VLR_IOF] ,                                                            
	                    [VLR_CUSTO_EMISSAO] ,                                                  
	                    [COD_SUBGRUPO] ,                                                       
	                    [IND_PERI_PAGAMENTO] ,                                                 
	                    [COD_OPCAO_PAGAMENTO] ,                                                
	                    [NUM_MATRICULA_VENDEDOR] ,                                             
	                    [NUM_MATRICULA_ECONOM] ,                                               
	                    [NUM_MATRICULA_PDV] ,                                                  
	                    [NUM_APOLICE_ANTERIOR] ,                                               
	                    [IND_RENOVACAO] ,                                                      
	                    [IND_ADIMPLENTE] ,                                                     
	                    [NUM_QTD_PARCELAS] ,                                                   
	                    [IND_ORIGEM_REGISTRO_CONTRATO] ,
						[STA_ANTECIPACAO] ,		
						[STA_MUDANCA_PLANO] ,						  
                        -------------------------------------PRODUTO----------------------------------------------------------
                        COD_PRODUTO_SIAS,
                        COD_PRODUTO_SIVPF,
                        COD_RAMO_EMISSOR,
                        COD_EMPRESA_SIAS,                                     
                        -------------------------------------VENDEDOR---------------------------------------------------------  
	                    [COD_CPF_CNPJ_VENDEDOR] ,                                                                  
	                    [COD_MATRICULA_VENDEDOR] ,                                                                 
	                    [IND_ORIGEM_REGISTRO_VENDEDOR] ,                                                           
	                    [IND_TIPO_VENDEDOR] ,                                                                    
                        ---------------------------------------SITUACAO-------------------------------------------------------
	                    [IDSUBSITUACAO],
                        [DATA_SITUACAO] , 
                        [DATA_ATUALIZACAO],                                    
	                    [QTD_CONTRATO] ,                                      
	                    [QTD_PROPOSTA] ,                                      
                        ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
	                    [COD_AGENCIA] ,                                                                
                        --------------------------------------ESTIPULANTE----------------------------------------------------
	                    [COD_CLIENTE_PE] ,                                                     
	                    [NUM_OCORR_ENDERECO_PE] ,                                              
	                    [NOM_PESSOA_PE] ,                                                      
                        CASE
                        		WHEN IND_TIPO_PESSOA_PE = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PE as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PE = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PE as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PE as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PE ,                                                            
	                    [DTH_NASCIMENTO_PE] ,
                        CASE WHEN [COD_SEXO_PE] = ''F'' THEN 2
                             WHEN [COD_SEXO_PE] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PE],                                                       
	                    [COD_ESTADO_CIVIL_PE] ,                                                
	                    [DES_ESTADO_CIVIL_PE] ,                                                
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PE = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PE = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PE] ,                                                       
	                    [DES_EMAIL_PE] ,                                                       
	                    [NUM_IDENTIDADE_PE] ,                                                  
	                    [DES_ORGAO_EXPEDIDOR_PE] ,                                             
	                    [COD_UF_EXPEDIDORA_PE] ,                                               
	                    [DTH_EXPEDICAO_PE] ,                                                   
	                    [COD_DDD_TELEFONE_PE] ,                                                
	                    [COD_TELEFONE_PE] ,                                                    
	                    [COD_DDD_CELULAR_PE] ,                                                 
	                    [COD_CELULAR_PE] , 
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PE]) [COD_CBO_PE],                                                  
	                    [DES_ENDERECO_PE] ,                                                    
	                    [DES_BAIRRO_PE] ,                                                      
	                    [DES_CIDADE_PE] ,                                                      
	                    [COD_UF_PE] ,                                                          
	                    [DES_COMPLEMENTO_ENDERECO_PE] ,                                        
	                    [NUM_IMOVEL_PE] ,                                                      
	                    [COD_CEP_PE] ,                                                         
	                    [COD_BANCO_PE] ,                                                       
	                    [COD_AGENCIA_PE] ,                                                     
	                    [NUM_CONTA_PE] ,                                                       
	                    [NUM_DV_CONTA_PE] ,                                                    
	                    [NUM_OPERACAO_CONTA_PE] ,                                              
	                    [COD_ORIGEM_PESSOA_PE] ,                                               
                        --------------------------------------SUB ESTIPULANTE------------------------------------------------
	                    [COD_CLIENTE_PSE] ,                                           
	                    [NUM_OCORR_ENDERECO_PSE] ,                                    
	                    [NOM_PESSOA_PSE] ,    
                        CASE
                        		WHEN IND_TIPO_PESSOA_PSE = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PSE as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PSE = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PSE as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PSE as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PSE ,   
	                    [DTH_NASCIMENTO_PSE] ,                                        
                        CASE WHEN [COD_SEXO_PSE] = ''F'' THEN 2
                             WHEN [COD_SEXO_PSE] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PSE],                                              
	                    [COD_ESTADO_CIVIL_PSE] ,                                      
	                    [DES_ESTADO_CIVIL_PSE] ,                                      
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PSE = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PSE = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PSE] ,                                           
	                    [DES_EMAIL_PSE] ,                                             
	                    [NUM_IDENTIDADE_PSE] ,                                        
	                    [DES_ORGAO_EXPEDIDOR_PSE] ,                                   
	                    [COD_UF_EXPEDIDORA_PSE] ,                                     
	                    [DTH_EXPEDICAO_PSE] ,                                         
	                    [COD_DDD_TELEFONE_PSE] ,                                      
	                    [COD_TELEFONE_PSE] ,                                          
	                    [COD_DDD_CELULAR_PSE] ,                                       
	                    [COD_CELULAR_PSE] ,  
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PSE]) [COD_CBO_PSE],                                         
	                    [DES_ENDERECO_PSE] ,                                          
	                    [DES_BAIRRO_PSE] ,                                            
	                    [DES_CIDADE_PSE] ,                                            
	                    [COD_UF_PSE] ,                                                
	                    [DES_COMPLEMENTO_ENDERECO_PSE] ,                              
	                    [NUM_IMOVEL_PSE] ,                                            
	                    [COD_CEP_PSE] ,                                               
	                    [COD_BANCO_PSE] ,                                             
	                    [COD_AGENCIA_PSE] ,                                           
	                    [NUM_CONTA_PSE] ,                                             
	                    [NUM_DV_CONTA_PSE] ,                                          
	                    [NUM_OPERACAO_CONTA_PSE] ,                                    
	                    [COD_ORIGEM_PSESSOA_PSE] ,                                    
                        --------------------------------------SEGURADO-------------------------------------------------------
	                    [COD_CLIENTE_PS] ,                                                   
	                    [NUM_OCORR_ENDERECO_PS] ,                                            
	                    [NOM_PESSOA_PS] ,                                                    
                        CASE
                        		WHEN IND_TIPO_PESSOA_PS = ''J'' THEN CleansingKit.dbo.fn_FormataCNPJ(Cast(Cast(COD_CPF_CNPJ_PS as bigint) as varchar(20)))
		                        WHEN IND_TIPO_PESSOA_PS = ''F'' THEN CleansingKit.dbo.fn_FormataCPF(Cast(Cast(COD_CPF_CNPJ_PS as bigint) as varchar(20))) 
                                ELSE  Cast(COD_CPF_CNPJ_PS as varchar(20)) /*'''' COLLATE SQL_Latin1_General_CP1_CI_AS*/
	                            END AS COD_CPF_CNPJ_PS ,                                                  
	                    [DTH_NASCIMENTO_PS] ,                                                
	                    CASE WHEN [COD_SEXO_PS] = ''F'' THEN 2
                             WHEN [COD_SEXO_PS] = ''M'' THEN 1
                             ELSE 0
                        END [COD_SEXO_PS] ,                                                      
	                    [COD_ESTADO_CIVIL_PS] ,                                              
	                    [DES_ESTADO_CIVIL_PS] ,  
	                    CASE
                        		WHEN IND_TIPO_PESSOA_PS = ''J'' THEN ''Pessoa Jurídica'' COLLATE SQL_Latin1_General_CP1_CI_AS
		                        WHEN IND_TIPO_PESSOA_PS = ''F'' THEN ''Pessoa Física'' COLLATE SQL_Latin1_General_CP1_CI_AS
                                ELSE  '''' COLLATE SQL_Latin1_General_CP1_CI_AS
	                            END AS [IND_TIPO_PESSOA_PS] ,                                              
                                             
	                    [DES_EMAIL_PS] ,                                                     
	                    [NUM_IDENTIDADE_PS] ,                                                
	                    [DES_ORGAO_EXPEDIDOR_PS] ,                                           
	                    [COD_UF_EXPEDIDORA_PS] ,                                             
	                    [DTH_EXPEDICAO_PS] ,                                                 
	                    [COD_DDD_TELEFONE_PS] ,                                              
	                    [COD_TELEFONE_PS] ,                                                  
	                    [COD_DDD_CELULAR_PS] ,                                               
	                    [COD_CELULAR_PS] ,  
                        --CleansingKit.dbo.fn_RemoveLeadingZeros([COD_CBO_PS]) [COD_CBO_PS],                                                 
	                    [DES_ENDERECO_PS] ,                                                  
	                    [DES_BAIRRO_PS] ,                                                    
	                    [DES_CIDADE_PS] ,                                                    
	                    [COD_UF_PS] ,                                                        
	                    [DES_COMPLEMENTO_ENDERECO_PS] ,                                      
	                    [NUM_IMOVEL_PS] ,                                                    
	                    [COD_CEP_PS] ,                                                       
	                    [COD_BANCO_PS] ,                                                     
	                    [COD_AGENCIA_PS] ,                                                   
	                    [NUM_CONTA_PS] ,                                                     
	                    [NUM_DV_CONTA_PS] ,                                                  
	                    [NUM_OPERACAO_CONTA_PS] ,                                            
	                    [COD_ORIGEM_PESSOA_PS]                                              
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaContrato] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[Contrato_SSD_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contrato_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Contrato_SSD_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

