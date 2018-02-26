





/*
0,0                 


	Autor: Luan Moreno M. Maciel
	Data Criação: 27/03/2014
*/

/*******************************************************************************
Nome: Dados.proc_InsereRetorno_VendasAuto_KPN	
--*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereVendasAuto_KPN] 
AS

BEGIN TRY		


    
DECLARE @PontoDeParada AS VARCHAR(400) = 0
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

--PRINT 'DROPA E RECRIA TABEBELA TEMPORARIA'
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Retorno_VendasAuto_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Retorno_VendasAuto_KPN_TEMP];
	
CREATE TABLE [dbo].[Retorno_VendasAuto_KPN_TEMP]           
(                                                    	  
	ID BIGINT NOT NULL,            					 	  
	DataArquivo DATE NULL,							 	  
	NomeArquivo VARCHAR(300) NULL,					 	  
	ControleVersao [decimal](16, 8) NULL,			 	  
	Protocolo CHAR(10) NULL,						 	  
	TMA INT NULL,								 		  
	CPF CHAR(14) NULL,								 	  
	DataNascimento varchar(10) NULL,						 	  
	Status_Ligacao VARCHAR(100) NULL,				 	  
	
	Status_Ligacao2 VARCHAR(100) NULL,				 	  
	Status_Ligacao3 VARCHAR(100) NULL,				 	  
	Status_Ligacao4 VARCHAR(100) NULL,				 	  
	Status_Ligacao5 VARCHAR(100) NULL,				 	  
	Status_Ligacao6 VARCHAR(100) NULL,				 	  
	Status_Ligacao7 VARCHAR(100) NULL,				 	  
	Status_Ligacao8 VARCHAR(100) NULL,				 	  
	Status_Ligacao9 VARCHAR(100) NULL,				 	  

	Status_Final VARCHAR(100) NULL,					
		
	--Status_Final2 VARCHAR(100) NULL,					
	--Status_Final3 VARCHAR(100) NULL,					
	--Status_Final4 VARCHAR(100) NULL,					
	--Status_Final5 VARCHAR(100) NULL,					
	--Status_Final6 VARCHAR(100) NULL,					
	--Status_Final7 VARCHAR(100) NULL,					
	--Status_Final8 VARCHAR(100) NULL,					
	--Status_Final9 VARCHAR(100) NULL,					
		 	  
	Telefone_Contato_Efetivo CHAR(20) NULL,			 	  
	Tel_Contato_1 CHAR(20) NULL,					 	  
	Tel_Contato_2 CHAR(20) NULL,					 	  
	Tel_Adicional_1 CHAR(20) NULL,					 	  
	Tel_Adicional_2  CHAR(20) NULL,					 	  
	Email1 VARCHAR(200) NULL,						 	  
	Email2 VARCHAR(200) NULL,						 	  
	DateTime_Contato_Efetivo Datetime NULL,			 	  
	TipoProduto INT NULL,							 	  
	Contato_Mkt_Direto VARCHAR(80) NULL,			 	  
	AgenciaLotacao CHAR(20) NULL,					 	  
	AgenciaIndicacao CHAR(20) NULL,					 	  
	ProdutosAdquiridos VARCHAR(100) NULL,			 	  
	NomeVeiculo VARCHAR(100) NULL,						  
	PlacaVeiculo VARCHAR(100) NULL,				 		  
	BitVistoria CHAR(20) NULL,						 	  
	QuantidadeParcelas CHAR(20) NULL,	
	
	NomeVeiculo2 VARCHAR(100) NULL,						  
	PlacaVeiculo2 VARCHAR(100) NULL,				 		  
	BitVistoria2 CHAR(20) NULL,						 	  
	QuantidadeParcelas2 CHAR(20) NULL,			

	NomeVeiculo3 VARCHAR(100) NULL,						  
	PlacaVeiculo3 VARCHAR(10) NULL,				 		  
	BitVistoria3 CHAR(20) NULL,						 	  
	QuantidadeParcelas3 CHAR(20) NULL,			

	NomeVeiculo4 VARCHAR(100) NULL,						  
	PlacaVeiculo4 VARCHAR(100) NULL,				 		  
	BitVistoria4 CHAR(20) NULL,						 	  
	QuantidadeParcelas4 CHAR(20) NULL,			

	NomeVeiculo5 VARCHAR(100) NULL,						  
	PlacaVeiculo5 VARCHAR(100) NULL,				 		  
	BitVistoria5 CHAR(20) NULL,						 	  
	QuantidadeParcelas5 CHAR(20) NULL,			

	NomeVeiculo6 VARCHAR(100) NULL,						  
	PlacaVeiculo6 VARCHAR(100) NULL,				 		  
	BitVistoria6 CHAR(20) NULL,						 	  
	QuantidadeParcelas6 CHAR(20) NULL,			

	NomeVeiculo7 VARCHAR(100) NULL,						  
	PlacaVeiculo7 VARCHAR(100) NULL,				 		  
	BitVistoria7 CHAR(20) NULL,						 	  
	QuantidadeParcelas7 CHAR(20) NULL,			

	NomeVeiculo8 VARCHAR(100) NULL,						  
	PlacaVeiculo8 VARCHAR(100) NULL,				 		  
	BitVistoria8 CHAR(20) NULL,						 	  
	QuantidadeParcelas8 CHAR(20) NULL,			

	NomeVeiculo9 VARCHAR(100) NULL,						  
	PlacaVeiculo9 VARCHAR(100) NULL,				 		  
	BitVistoria9 CHAR(20) NULL,						 	  
	QuantidadeParcelas9 CHAR(20) NULL,			

	ProdutoOferta VARCHAR(100) NULL,				 	  
	ProspectOferta VARCHAR(100) NULL,				 	  
	CotacaoRealizada VARCHAR(100) NULL,				  
	Termino_Vigencia DATE NULL,						 	  
	Data_Renovacao DATE NULL,						 	  
	Premio_Atual DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto DECIMAL(19,2) NULL,			  
	FormaPagamento VARCHAR(100) NULL,				 	  
	Proposta CHAR(40) NULL,							  
	Informe_Seguradora VARCHAR(100) NULL,			 	  
	Seguradora_Atual VARCHAR(100) NULL,	
	
	ProspectOferta2 VARCHAR(100) NULL,				 	  
	CotacaoRealizada2 VARCHAR(100) NULL,				  
	Data_Renovacao2 DATE NULL,						 	  
	Premio_Atual2 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto2 DECIMAL(19,2) NULL,			  
	FormaPagamento2 VARCHAR(100) NULL,				 	  
	Proposta2 CHAR(40) NULL,							  
	Informe_Seguradora2 VARCHAR(100) NULL,			 	  
	Seguradora_Atual2 VARCHAR(100) NULL,	

	ProspectOferta3 VARCHAR(100) NULL,				 	  
	CotacaoRealizada3 VARCHAR(100) NULL,				  
	Data_Renovacao3 DATE NULL,						 	  
	Premio_Atual3 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto3 DECIMAL(19,2) NULL,			  
	FormaPagamento3 VARCHAR(100) NULL,				 	  
	Proposta3 CHAR(40) NULL,							  
	Informe_Seguradora3 VARCHAR(100) NULL,			 	  
	Seguradora_Atual3 VARCHAR(100) NULL,	

	ProspectOferta4 VARCHAR(100) NULL,				 	  
	CotacaoRealizada4 VARCHAR(100) NULL,				  
	Data_Renovacao4 DATE NULL,						 	  
	Premio_Atual4 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto4 DECIMAL(19,2) NULL,			  
	FormaPagamento4 VARCHAR(100) NULL,				 	  
	Proposta4 CHAR(40) NULL,							  
	Informe_Seguradora4 VARCHAR(100) NULL,			 	  
	Seguradora_Atual4 VARCHAR(100) NULL,	

	ProspectOferta5 VARCHAR(100) NULL,				 	  
	CotacaoRealizada5 VARCHAR(100) NULL,				  
	Data_Renovacao5 DATE NULL,						 	  
	Premio_Atual5 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto5 DECIMAL(19,2) NULL,			  
	FormaPagamento5 VARCHAR(100) NULL,				 	  
	Proposta5 CHAR(40) NULL,							  
	Informe_Seguradora5 VARCHAR(100) NULL,			 	  
	Seguradora_Atual5 VARCHAR(100) NULL,	

	ProspectOferta6 VARCHAR(100) NULL,				 	  
	CotacaoRealizada6 VARCHAR(100) NULL,				  
	Data_Renovacao6 DATE NULL,						 	  
	Premio_Atual6 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto6 DECIMAL(19,2) NULL,			  
	FormaPagamento6 VARCHAR(100) NULL,				 	  
	Proposta6 CHAR(40) NULL,							  
	Informe_Seguradora6 VARCHAR(100) NULL,			 	  
	Seguradora_Atual6 VARCHAR(100) NULL,	

	ProspectOferta7 VARCHAR(100) NULL,				 	  
	CotacaoRealizada7 VARCHAR(100) NULL,				  
	Data_Renovacao7 DATE NULL,						 	  
	Premio_Atual7 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto7 DECIMAL(19,2) NULL,			  
	FormaPagamento7 VARCHAR(100) NULL,				 	  
	Proposta7 CHAR(40) NULL,							  
	Informe_Seguradora7 VARCHAR(100) NULL,			 	  
	Seguradora_Atual7 VARCHAR(100) NULL,	

	ProspectOferta8 VARCHAR(100) NULL,				 	  
	CotacaoRealizada8 VARCHAR(100) NULL,				  
	Data_Renovacao8 DATE NULL,						 	  
	Premio_Atual8 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto8 DECIMAL(19,2) NULL,			  
	FormaPagamento8 VARCHAR(100) NULL,				 	  
	Proposta8 CHAR(40) NULL,							  
	Informe_Seguradora8 VARCHAR(100) NULL,			 	  
	Seguradora_Atual8 VARCHAR(100) NULL,	

	ProspectOferta9 VARCHAR(100) NULL,				 	  
	CotacaoRealizada9 VARCHAR(100) NULL,				  
	Data_Renovacao9 DATE NULL,						 	  
	Premio_Atual9 DECIMAL(19,2) NULL,				 	  
	Premio_Sem_Desconto9 DECIMAL(19,2) NULL,			  
	FormaPagamento9 VARCHAR(100) NULL,				 	  
	Proposta9 CHAR(40) NULL,							  
	Informe_Seguradora9 VARCHAR(100) NULL,			 	  
	Seguradora_Atual9 VARCHAR(100) NULL,	
						  
	Cod_Campanha VARCHAR(100) NULL,					 	  
	Cod_Mailing VARCHAR(100) NULL,					 	  
	Produto_Efetivado VARCHAR(100) NULL,			 	  
	Regional_Par VARCHAR(100) NULL,					 	  
	SuperIntendencia_Regional VARCHAR(100) NULL	,
	NomeCliente VARCHAR(255)  NULL,
	NomeClienteTratado as LEFT(NomeCliente,100)  PERSISTED 	  

) ON [PRIMARY]										 		

 /*Cria Índices */  
CREATE CLUSTERED INDEX idx_Retorno_VendasAuto_KPN_TEMP 
ON [dbo].Retorno_VendasAuto_KPN_TEMP
( 
  ID ASC
)   

CREATE NONCLUSTERED INDEX idx_NDX_NumeroProposta_Retorno_VendasAuto_KPN_TEMP
ON [dbo].Retorno_VendasAuto_KPN_TEMP
( 
  CPF ASC
)       

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo1_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta1_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta])


CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo2_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo2])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta2_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta2])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo3_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo3])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta3_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta3])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo4_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo4])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta4_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta4])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo5_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo5])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta5_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta5])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo6_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo6])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta6_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta6])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo7_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo7])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta7_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta7])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo8_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo8])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta8_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta8])

CREATE NONCLUSTERED INDEX idx_NDX_NomeVeiculo9_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([NomeVeiculo9])


CREATE NONCLUSTERED INDEX idx_NDX_ProspectOferta9_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([ProspectOferta9])

CREATE NONCLUSTERED INDEX idx_NDX_InformeSeguradora_KPN_TEMP
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora])

CREATE NONCLUSTERED INDEX [informe_Seguradora]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta],[NomeClienteTratado])

CREATE NONCLUSTERED INDEX [informe_Seguradora2]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora2])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta2],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora3]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora3])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta3],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora4]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora4])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta4],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora5]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora5])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta5],[NomeClienteTratado])

CREATE NONCLUSTERED INDEX [informe_Seguradora6]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora6])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta6],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora7]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora7])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta7],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora8]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora8])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta8],[NomeClienteTratado])


CREATE NONCLUSTERED INDEX [informe_Seguradora9]
ON [dbo].[Retorno_VendasAuto_KPN_TEMP] ([Informe_Seguradora9])
INCLUDE ([DataArquivo],[NomeArquivo],[CPF],[DataNascimento],[Proposta9],[NomeClienteTratado])




--PRINT 'RECUPERA PONTO DE PARADA'
--SELECT *
SELECT  @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Retorno_VendasAuto_KPN'

--DECLARE @PontoDeParada VARCHAR(10) 
--SET @PontoDeParada = '0'
--DECLARE @COMANDO VARCHAR(MAX)
/*********************************************************************************************************************/               
/*Recuperação do Maior Código*/
/*********************************************************************************************************************/
SET @COMANDO =
'
INSERT INTO [dbo].[Retorno_VendasAuto_KPN_TEMP]
(
    ID,
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Ligacao2,
	Status_Ligacao3,
	Status_Ligacao4,
	Status_Ligacao5,
	Status_Ligacao6,
	Status_Ligacao7,
	Status_Ligacao8,
	Status_Ligacao9,
	Status_Final,

	
	
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Tel_Adicional_1,
	Tel_Adicional_2,
	Email1,
	Email2,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	AgenciaLotacao,
	AgenciaIndicacao,
	ProdutosAdquiridos,
	NomeVeiculo,
	PlacaVeiculo,
	NomeVeiculo2,
	PlacaVeiculo2,
	NomeVeiculo3,
	PlacaVeiculo3,
	NomeVeiculo4,
	PlacaVeiculo4,
	NomeVeiculo5,
	PlacaVeiculo5,
	NomeVeiculo6,
	PlacaVeiculo6,
	NomeVeiculo7,
	PlacaVeiculo7,
	NomeVeiculo8,
	PlacaVeiculo8,
	NomeVeiculo9,
	PlacaVeiculo9,
	BitVistoria,
	BitVistoria2,
	BitVistoria3,
	BitVistoria4,
	BitVistoria5,
	BitVistoria6,
	BitVistoria7,
	BitVistoria8,
	BitVistoria9,
	QuantidadeParcelas,
	QuantidadeParcelas2,
	QuantidadeParcelas3,
	QuantidadeParcelas4,
	QuantidadeParcelas5,
	QuantidadeParcelas6,
	QuantidadeParcelas7,
	QuantidadeParcelas8,
	QuantidadeParcelas9,							
	ProdutoOferta,
	ProspectOferta,
	CotacaoRealizada,
	Termino_Vigencia,
	Data_Renovacao,
	Premio_Atual,
	Premio_Sem_Desconto,
	FormaPagamento,
	Proposta,
	Informe_Seguradora,
	Seguradora_Atual,

	ProspectOferta2,
	CotacaoRealizada2,
	Data_Renovacao2,
	Premio_Atual2,
	Premio_Sem_Desconto2,
	FormaPagamento2,
	Proposta2,
	Informe_Seguradora2,
	Seguradora_Atual2,

	ProspectOferta3,
	CotacaoRealizada3,
	Data_Renovacao3,
	Premio_Atual3,
	Premio_Sem_Desconto3,
	FormaPagamento3,
	Proposta3,
	Informe_Seguradora3,
	Seguradora_Atual3,

	ProspectOferta4,
	CotacaoRealizada4,
	Data_Renovacao4,
	Premio_Atual4,
	Premio_Sem_Desconto4,
	FormaPagamento4,
	Proposta4,
	Informe_Seguradora4,
	Seguradora_Atual4,

	ProspectOferta5,
	CotacaoRealizada5,
	Data_Renovacao5,
	Premio_Atual5,
	Premio_Sem_Desconto5,
	FormaPagamento5,
	Proposta5,
	Informe_Seguradora5,
	Seguradora_Atual5,

	ProspectOferta6,
	CotacaoRealizada6,
	Data_Renovacao6,
	Premio_Atual6,
	Premio_Sem_Desconto6,
	FormaPagamento6,
	Proposta6,
	Informe_Seguradora6,
	Seguradora_Atual6,

	ProspectOferta7,
	CotacaoRealizada7,
	Data_Renovacao7,
	Premio_Atual7,
	Premio_Sem_Desconto7,
	FormaPagamento7,
	Proposta7,
	Informe_Seguradora7,
	Seguradora_Atual7,

	ProspectOferta8,
	CotacaoRealizada8,
	Data_Renovacao8,
	Premio_Atual8,
	Premio_Sem_Desconto8,
	FormaPagamento8,
	Proposta8,
	Informe_Seguradora8,
	Seguradora_Atual8,

		ProspectOferta9,
	CotacaoRealizada9,
	Data_Renovacao9,
	Premio_Atual9,
	Premio_Sem_Desconto9,
	FormaPagamento9,
	Proposta9,
	Informe_Seguradora9,
	Seguradora_Atual9,

	Cod_Campanha,
	Cod_Mailing,
	Produto_Efetivado,
	Regional_Par,
	SuperIntendencia_Regional,
	NomeCliente
)
SELECT 
    ID,	
	Cast(DataArquivo as Date) DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	Cast(TMA as int) TMA,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Ligacao2,
	Status_Ligacao3,
	Status_Ligacao4,
	Status_Ligacao5,
	Status_Ligacao6,
	Status_Ligacao7,
	Status_Ligacao8,
	Status_Ligacao9,
	Status_Final,
	
	
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Tel_Adicional_1,
	Tel_Adicional_2,
	Email1,
	Email2,
	cast(Datetime_Contato_Efetivo as datetime) as DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	AgenciaLotacao,
	(CASE WHEN ISNUMERIC(LTRIM(RTRIM(AgenciaIndicacao)))=1 THEN AgenciaIndicacao ELSE NULL END) AS AgenciaIndicacao,
	ProdutosAdquiridos,
	LEFT(NomeVeiculo,100) NomeVeiculo,
	PlacaVeiculo,
	LEFT(NomeVeiculo2,100) NomeVeiculo2,
	PlacaVeiculo2,
	LEFT(NomeVeiculo3,100) NomeVeiculo3,
	PlacaVeiculo3,
	LEFT(NomeVeiculo4,100) NomeVeiculo4,
	PlacaVeiculo4,
	LEFT(NomeVeiculo5,100) NomeVeiculo5,
	PlacaVeiculo5,
	LEFT(NomeVeiculo6,100) NomeVeiculo6,
	PlacaVeiculo6,
	LEFT(NomeVeiculo7,100) NomeVeiculo7,
	PlacaVeiculo7,
	LEFT(NomeVeiculo8,100) NomeVeiculo8,
	PlacaVeiculo8,
	LEFT(NomeVeiculo9,100) NomeVeiculo9,
	PlacaVeiculo9,
	BitVistoria,
	BitVistoria2,
	BitVistoria3,
	BitVistoria4,
	BitVistoria5,
	BitVistoria6,
	BitVistoria7,
	BitVistoria8,
	BitVistoria9,
	QuantidadeParcelas,
	QuantidadeParcelas2,
	QuantidadeParcelas3,
	QuantidadeParcelas4,
	QuantidadeParcelas5,
	QuantidadeParcelas6,
	QuantidadeParcelas7,
	QuantidadeParcelas8,
	QuantidadeParcelas9,
	ProdutoOferta,
	ProspectOferta,
	CotacaoRealizada,
	Termino_Vigencia,
	Data_Renovacao,
	LTRIM(RTRIM(Premio_Atual)),
	LTRIM(RTRIM(Premio_Sem_Desconto)),
	FormaPagamento,
	Proposta,
	Informe_Seguradora,
	Seguradora_Atual,
	ProspectOferta2,
	CotacaoRealizada2,
	Data_Renovacao2,
	LTRIM(RTRIM(Premio_Atual2)),
	LTRIM(RTRIM(Premio_Sem_Desconto2)),
	FormaPagamento2,
	Proposta2,
	Informe_Seguradora2,
	Seguradora_Atual2,
	ProspectOferta3,
	CotacaoRealizada3,
	Data_Renovacao3,
	LTRIM(RTRIM(Premio_Atual3)),
	LTRIM(RTRIM(Premio_Sem_Desconto3)),
	FormaPagamento3,
	Proposta3,
	Informe_Seguradora3,
	Seguradora_Atual3,
	ProspectOferta4,
	CotacaoRealizada4,
	Data_Renovacao4,
	LTRIM(RTRIM(Premio_Atual4)),
	LTRIM(RTRIM(Premio_Sem_Desconto4)),
	FormaPagamento4,
	Proposta4,
	Informe_Seguradora4,
	Seguradora_Atual4,
	ProspectOferta5,
	CotacaoRealizada5,
	Data_Renovacao5,
	LTRIM(RTRIM(Premio_Atual5)),
	LTRIM(RTRIM(Premio_Sem_Desconto5)),
	FormaPagamento5,
	Proposta5,
	Informe_Seguradora5,
	Seguradora_Atual5,
	ProspectOferta6,
	CotacaoRealizada6,
	Data_Renovacao6,
	LTRIM(RTRIM(Premio_Atual6)),
	LTRIM(RTRIM(Premio_Sem_Desconto6)),
	FormaPagamento6,
	Proposta6,
	Informe_Seguradora6,
	Seguradora_Atual6,
	ProspectOferta7,
	CotacaoRealizada7,
	Data_Renovacao7,
	LTRIM(RTRIM(Premio_Atual7)),
	LTRIM(RTRIM(Premio_Sem_Desconto7)),
	FormaPagamento7,
	Proposta7,
	Informe_Seguradora7,
	Seguradora_Atual7,
	ProspectOferta8,
	CotacaoRealizada8,
	Data_Renovacao8,
	LTRIM(RTRIM(Premio_Atual8)),
	LTRIM(RTRIM(Premio_Sem_Desconto8)),
	FormaPagamento8,
	Proposta8,
	Informe_Seguradora8,
	Seguradora_Atual8,
	ProspectOferta9,
	CotacaoRealizada9,
	Data_Renovacao9,
	LTRIM(RTRIM(Premio_Atual9)),
	LTRIM(RTRIM(Premio_Sem_Desconto9)),
	FormaPagamento9,
	Proposta9,
	Informe_Seguradora9,
	Seguradora_Atual9,
	Cod_Campanha,
	Cod_Mailing,
	Produto_Efetivado,
	Regional_Par,
	SuperIntendencia_Regional,
	NomeCliente

FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaVendasAuto_KPN] ''''' + @PontoDeParada + ''''''') PRP '	   


--PRINT @COMANDO
PRINT 'EXECUTA PROC proc_RecuperaVendasAuto_KPN'
EXEC (@COMANDO)  
		   
SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]

SET @COMANDO = '' 

PRINT 'ENTRA NO WHILE'
WHILE @MaiorCodigo IS NOT NULL
BEGIN
--SELECT * FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
/**********************************************************************
Inserção dos Dados - Inserção de Seguradoras
***********************************************************************/ 
PRINT 'Dados.Seguradora'
MERGE INTO Dados.Seguradora AS T
USING
(
	SELECT  ROW_NUMBER() OVER(ORDER BY Informe_Seguradora)+(SELECT MAX(ISNULL(CAST(Codigo AS INT),0)) FROM Dados.Seguradora) AS Codigo,
		   Informe_Seguradora,
		   Seguradora_Atual
	FROM (
	SELECT DISTINCT Informe_Seguradora,
		   Seguradora_Atual FROM 

			(
			SELECT Informe_Seguradora,
				   Seguradora_Atual
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora IS NOT NULL
			OR Seguradora_Atual IS NOT NULL
		
			UNION ALL

			SELECT Informe_Seguradora2,
				   Seguradora_Atual2
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora2 IS NOT NULL
			OR Seguradora_Atual2 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora3,
				   Seguradora_Atual3
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora3 IS NOT NULL
			OR Seguradora_Atual3 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora4,
				   Seguradora_Atual4
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora4 IS NOT NULL
			OR Seguradora_Atual4 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora5,
				   Seguradora_Atual5
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora5 IS NOT NULL
			OR Seguradora_Atual5 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora6,
				   Seguradora_Atual6
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora6 IS NOT NULL
			OR Seguradora_AtuaL6 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora7,
				   Seguradora_Atual7
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora7 IS NOT NULL
			OR Seguradora_Atual7 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora8,
				   Seguradora_Atual8
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora8 IS NOT NULL
			OR Seguradora_Atual8 IS NOT NULL

			UNION ALL

			SELECT Informe_Seguradora9,
				   Seguradora_Atual9
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			WHERE Informe_Seguradora9 IS NOT NULL
			OR Seguradora_Atual9 IS NOT NULL	
		) X
			
	) AS T
	
) AS S
ON T.Nome = Informe_Seguradora
	AND T.Nome = Seguradora_Atual
WHEN NOT MATCHED THEN
	INSERT (Codigo,Nome)
	VALUES (S.Codigo, S.Informe_Seguradora);

/**********************************************************************
Inserção dos Dados - Tipos de Prospecção de Vendas
***********************************************************************/ 
PRINT 'Dados.ProspectOferta'
MERGE INTO Dados.ProspectOferta AS T
USING
(
	SELECT  DISTINCT Nome,DataArquivo from ( SELECT  (T.ProspectOferta) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta2) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta2 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta3) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta3 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta4) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta4 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta5) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta5 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta6) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta6 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta7) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta7 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta8) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta8 IS NOT NULL

	UNION ALL

	SELECT  (T.ProspectOferta9) AS Nome,t.DataArquivo
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
	WHERE T.ProspectOferta9 IS NOT NULL) AS x

) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome,DataCadastro)
	VALUES (S.Nome,s.DataArquivo);

/**********************************************************************
Inserção dos Dados - Inserção de Veículos
***********************************************************************/     
PRINT 'Dados.Veiculo'        
MERGE INTO Dados.Veiculo AS T
USING
(
	SELECT DISTINCT Nome 
	from 
	(
	SELECT NomeVeiculo AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo IS NOT NULL
	
	UNION ALL

	SELECT NomeVeiculo2 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo2 IS NOT NULL
	
	UNION ALL

	SELECT  NomeVeiculo3 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo3 IS NOT NULL
	
	UNION ALL
	
	SELECT NomeVeiculo4 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo4 IS NOT NULL
	
	UNION ALL

	SELECT NomeVeiculo5 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo5 IS NOT NULL
	
	UNION ALL
		
	SELECT NomeVeiculo6 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo6 IS NOT NULL
	
	UNION ALL

	SELECT NomeVeiculo7 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo7 IS NOT NULL
	
	UNION ALL

	SELECT NomeVeiculo8 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo8 IS NOT NULL
	
	UNION ALL

	SELECT NomeVeiculo9 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE NomeVeiculo9 IS NOT NULL) x
	
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Status de Ligação
***********************************************************************/             
PRINT 'Dados.Status_Ligacao'        
MERGE INTO Dados.Status_Ligacao AS T
USING 
(
	SELECT DISTINCT Nome 
	FROM (
	SELECT Status_Ligacao AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao2 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao2 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao3 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao3 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao4 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao4 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao5 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao5 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao6 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao6 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao7 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao7 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao8 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao8 IS NOT NULL --and len(Status_Ligacao) =58

	UNION ALL

	SELECT Status_Ligacao9 AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Ligacao9 IS NOT NULL --and len(Status_Ligacao) =58
	) x



) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Status de Ligação
***********************************************************************/         
PRINT 'Dados.Status_Final'            
MERGE INTO Dados.Status_Final AS T
USING 
(
	SELECT DISTINCT Status_Final AS Nome
	FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
	WHERE Status_Final IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Dados de Atendimento de Contatos
***********************************************************************/   
PRINT 'Dados.AtendimentoContatos'            
MERGE INTO Dados.AtendimentoContatos AS T
USING
(
	SELECT DISTINCT Telefone_Contato_Efetivo AS TelefoneEmail
	FROM
		(
			SELECT Telefone_Contato_Efetivo
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
			WHERE Telefone_Contato_Efetivo IS NOT NULL
			UNION ALL
			SELECT ISNULL(Tel_Contato_1, Tel_Contato_2)
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] 
			WHERE ISNULL(Tel_Contato_1, Tel_Contato_2) IS NOT NULL
			UNION ALL
			SELECT ISNULL(Tel_Adicional_1,Tel_Adicional_2) 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
			WHERE ISNULL(Tel_Adicional_1,Tel_Adicional_2) IS NOT NULL
			UNION ALL
			SELECT ISNULL(Email1,Email2) 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
			WHERE ISNULL(Email1,Email2) IS NOT NULL
		) AS Dados
) AS S
ON T.TelefoneEmail = S.TelefoneEmail
WHEN NOT MATCHED THEN
	INSERT (TelefoneEmail)
	VALUES (S.TelefoneEmail)

WHEN MATCHED THEN
	UPDATE 
		SET TelefoneEmail = COALESCE(S.TelefoneEmail, T.TelefoneEmail);

--UPDATE Dados.Atendimento
--	SET IDTelefoneEfetivo = NULL,
--		IDTelefone = NULL,
--		IDTelefoneAdicional = NULL,
--		IDEmail = NULL

--DELETE
--FROM Dados.AtendimentoContatos 

/**********************************************************************
Inserção dos Dados - Dados de Atendimento
SELECT * FROM Dados.Atendimento where Protocolo = '7967430'
SELECT * FROM Dados.AtendimentoVeiculo
***********************************************************************/    
PRINT 'Dados.Atendimento'            
MERGE INTO Dados.Atendimento AS T
USING 
(
	SELECT * FROM (	SELECT *,ROW_NUMBER() OVER ( PARTITION BY Protocolo,CPF,IDStatus_Ligacao,IDVeiculo order by IDStatus_Ligacao desc) as linha
		FROM 
		(
			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo,
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo ORDER BY VEI.Codigo DESC) VEI 
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 
			UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo, 
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao2 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo2 ORDER BY VEI.Codigo DESC) VEI -- COMENTADO POR PEDRO GUEDES
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora2
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual2
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo, 
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao3 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo3 ORDER BY VEI.Codigo DESC) VEI 
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora3
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual3
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo, 
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao4 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo4 ORDER BY VEI.Codigo DESC) VEI 
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora4
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual4
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo,
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao5 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo5 ORDER BY VEI.Codigo DESC) VEI
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora5
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual5
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo,
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao6 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo6 ORDER BY VEI.Codigo DESC) VEI 
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora6
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual6
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo,
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao7 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo7 ORDER BY VEI.Codigo DESC) VEI
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora7
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual7
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo,
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao8 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo8 ORDER BY VEI.Codigo DESC) VEI
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora8
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual8
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

				UNION ALL

			SELECT
			-- distinct t.*	
			 DISTINCT
				   ROW_NUMBER() OVER(PARTITION BY Protocolo, CPF ORDER BY Termino_Vigencia DESC, CotacaoRealizada DESC) AS NewIDDados,
				   T.DataArquivo,
				   T.NomeArquivo [Arquivo],
				   CAST(CAST(T.Protocolo AS INT) AS VARCHAR(20)) AS Protocolo,
				   T.TMA,
				   T.CPF,
				   T.DataNascimento,
				   SL.ID AS IDStatus_Ligacao,
				   SF.ID AS IDStatus_Final,
				   TE.ID AS IDTelefoneEfetivo,
				   TEL.ID AS IDTelefone,
				   TELAC.ID AS IDTelefoneAdicional,
				   EM.ID AS IDEmail,
				   PROD.ID AS IDProduto,
				   UN1.ID AS IDAgenciaLotacao,
				   RTRIM(LTRIM(REPLACE(UN2.ID,',',''))) AS IDAgenciaIndicacao,
				   T.ProdutosAdquiridos,
				   T.Contato_Mkt_Direto,
				   T.Produto_Efetivado,
				   T.DateTime_Contato_Efetivo,
				   VEI.ID AS IDVeiculo, 
				   REPLACE(REPLACE(REPLACE(T.BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
				   PO.ID AS IDProspectOferta,
				   T.ProdutosAdquiridos AS Produto,
				   T.ProdutoOferta AS ProdutoOferta,
				   T.CotacaoRealizada AS CotacaoRealizada,
				   T.Termino_Vigencia,
				   T.Data_Renovacao,
				   REPLACE(T.Premio_Atual,',','.') AS Premio_Atual,
				   REPLACE(T.Premio_Sem_Desconto,',','.') AS Premio_Sem_Desconto,
				   T.FormaPagamento,
				   T.QuantidadeParcelas,
				   SEG1.ID AS IDInforme_Seguradora,
				   SEG2.ID AS IDSeguradora_Atual,
				   T.Cod_Campanha AS NomeCampanha, 
				   T.Cod_Mailing AS NomeMailing,
				   UNI.ID AS IDUnidade,
				   REPLACE(Regional_Par,'N/A','') AS Regional_Par 
			FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
			LEFT OUTER JOIN Dados.Status_Ligacao AS SL
			ON T.Status_Ligacao9 = SL.Nome
			LEFT OUTER JOIN Dados.Status_Final AS SF
			ON T.Status_Final = SF.Nome
			LEFT OUTER JOIN Dados.Unidade AS UN1
			ON T.AgenciaLotacao = UN1.Codigo
			LEFT OUTER JOIN Dados.Unidade AS UN2
			ON T.AgenciaIndicacao = UN2.Codigo
			LEFT JOIN Dados.AtendimentoContatos AS TE
			ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
			ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS TELAC
			ON TELAC.TelefoneEmail = ISNULL(T.Tel_Adicional_1, T.Tel_Adicional_2)
			LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
			ON EM.TelefoneEmail = ISNULL(T.Email1,T.Email2)
			LEFT OUTER JOIN Dados.Produto AS PROD
			ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
			OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo9 ORDER BY VEI.Codigo DESC) VEI
			LEFT OUTER JOIN Dados.ProspectOferta AS PO
			ON PO.Nome = T.ProspectOferta
			LEFT OUTER JOIN Dados.Seguradora AS SEG1
			ON SEG1.Nome = T.Informe_Seguradora9
			LEFT OUTER JOIN Dados.Seguradora AS SEG2
			ON SEG2.Nome = T.Seguradora_Atual9
			LEFT OUTER JOIN Dados.Unidade AS UNI
			ON REPLACE(T.SuperIntendencia_Regional,'N/A','') = UNI.Codigo
			--WHERE Protocolo = 57361800
			--where isnumeric(isnull(bitvistoria,''))=0 

	
		) AS Q
		WHERE Q.NewIDDados = 1
	) AS X where X.Linha = 1
	
) AS S
ON T.Protocolo = S.Protocolo
	AND T.CPF = S.CPF
	AND ISNULL(T.IDStatus_Ligacao,0) = ISNULL(S.IDStatus_Ligacao,0)
	AND ISNULL(T.IDVeiculo,0) = ISNULL(S.IDVeiculo,0)
WHEN MATCHED THEN
	UPDATE
		SET TMA = COALESCE(S.TMA, T.TMA),
		    DataNascimento = COALESCE(S.DataNascimento, T.DataNascimento),
			IDStatus_Ligacao = COALESCE(S.IDStatus_Ligacao, T.IDStatus_Ligacao),
			IDStatus_Final = COALESCE(S.IDStatus_Final, T.IDStatus_Final),
			IDTelefoneEfetivo = COALESCE(S.IDTelefoneEfetivo, T.IDTelefoneEfetivo),
			IDTelefone = COALESCE(S.IDTelefone, T.IDTelefone),
			IDEmail = COALESCE(S.IDEmail, T.IDEmail),
			IDProduto = COALESCE(S.IDProduto, T.IDProduto),
			IDTelefoneAdicional = COALESCE(S.IDTelefoneAdicional, T.IDTelefoneAdicional),
			DateTime_Contato_Efetivo = COALESCE(S.DateTime_Contato_Efetivo, T.DateTime_Contato_Efetivo),
			IDAgenciaLotacao = COALESCE(S.IDAgenciaLotacao, T.IDAgenciaLotacao),
			IDAgenciaIndicacao = COALESCE(S.IDAgenciaIndicacao, T.IDAgenciaIndicacao),
			ProdutosAdquiridos = left(COALESCE(S.ProdutosAdquiridos, T.ProdutosAdquiridos),60),
			Contato_Mkt_Direto = COALESCE(S.Contato_Mkt_Direto, T.Contato_Mkt_Direto),
			Produto_Efetivado = LEFT(COALESCE(S.Produto_Efetivado, T.Produto_Efetivado),60),
			--IDVeiculo = COALESCE(S.IDVeiculo, T.IDVeiculo), -- COMENTADO POR PEDRO GUEDES
			BitVistoria = COALESCE(S.BitVistoria, T.BitVistoria),
			IDProspectOferta = COALESCE(S.IDProspectOferta, T.IDProspectOferta),
			NomeProduto = left(COALESCE(S.Produto, T.NomeProduto),60),
			ProdutoOferta = COALESCE(S.ProdutoOferta, T.ProdutoOferta),
			CotacaoRealizada = left(COALESCE(S.CotacaoRealizada, T.CotacaoRealizada),2),
			Termino_Vigencia = COALESCE(S.Termino_Vigencia, T.Termino_Vigencia),
			Data_Renovacao = COALESCE(S.Data_Renovacao, T.Data_Renovacao),
			Premio_Atual = COALESCE(S.Premio_Atual, T.Premio_Atual),
			Premio_Sem_Desconto = COALESCE(S.Premio_Sem_Desconto, T.Premio_Sem_Desconto),
			FormaPagamento = COALESCE(S.FormaPagamento, T.FormaPagamento),
			QtdParcelas = COALESCE(S.QuantidadeParcelas, T.QtdParcelas),
			IDInforme_Seguradora = COALESCE(S.IDInforme_Seguradora, T.IDInforme_Seguradora),
			IDSeguradora_Atual = COALESCE(S.IDSeguradora_Atual, T.IDSeguradora_Atual),
			NomeCampanha = left(COALESCE(S.NomeCampanha, T.NomeCampanha),60),
			NomeMailing = LEFT(COALESCE(S.NomeMailing, T.NomeMailing),60),
			IDUnidade = COALESCE(S.IDUnidade, T.IDUnidade),
			Regional_Par = LEFT(COALESCE(S.Regional_Par, T.Regional_Par),60),
			DataArquivo = COALESCE(S.DataArquivo, T.DataArquivo),
			Arquivo = LEFT(COALESCE(S.Arquivo, T.Arquivo),60)
WHEN NOT MATCHED THEN
	INSERT ( Protocolo, TMA, CPF, DataNascimento, IDStatus_Ligacao, IDStatus_Final, IDTelefoneEfetivo, IDTelefone, IDTelefoneAdicional, IDEmail, IDVeiculo,  -- COMENTADO POR PEDRO GUEDES
		     IDProduto, IDAgenciaLotacao, IDAgenciaIndicacao, ProdutosAdquiridos, Contato_Mkt_Direto, Produto_Efetivado, DateTime_Contato_Efetivo, BitVistoria,
			 IDProspectOferta, NomeProduto, ProdutoOferta, CotacaoRealizada, Termino_Vigencia, Data_Renovacao, Premio_Atual, Premio_Sem_Desconto, FormaPagamento, 
			 QtdParcelas, IDInforme_Seguradora, IDSeguradora_Atual, NomeMailing, NomeCampanha, IDUnidade, Regional_Par, DataArquivo, Arquivo
		   )
	VALUES ( 
	
	         S.Protocolo, S.TMA, S.CPF, S.DataNascimento, S.IDStatus_Ligacao, S.IDStatus_Final, S.IDTelefoneEfetivo, S.IDTelefone, S.IDTelefoneAdicional, S.IDEmail, S.IDVeiculo,  -- COMENTADO POR PEDRO GUEDES
		     S.IDProduto, S.IDAgenciaLotacao, S.IDAgenciaIndicacao, Left(S.ProdutosAdquiridos,60), S.Contato_Mkt_Direto, left(S.Produto_Efetivado,60), S.DateTime_Contato_Efetivo, S.BitVistoria,
			 S.IDProspectOferta, left(S.Produto,60), left(S.ProdutoOferta,60), left(S.CotacaoRealizada,2), S.Termino_Vigencia, S.Data_Renovacao, S.Premio_Atual, S.Premio_Sem_Desconto, S.FormaPagamento, 
			 S.QuantidadeParcelas, S.IDInforme_Seguradora, S.IDSeguradora_Atual, left(S.NomeMailing,60), left(S.NomeCampanha,60), S.IDUnidade, left(S.Regional_Par,100), S.DataArquivo, Left(S.Arquivo,60)
		    );


/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA DE PROPOSTAS -select * from [Retorno_VendasAuto_KPN_TEMP] select TRY_PARSE(ltrim(rtrim(NumeroProposta)) as int),* from dbo.[AtendimentoPARIndica_TEMP] where NumeroProposta <> ''	 AND charindex('.',NumeroProposta) =  0 and Num




e

roProposta <> '0'  AND NumeroProposta not in ('C','FI') AND NomeCliente = 'LEONILA MARIA GONCALVES SAMPAIO'*/
/*********************************************************************************************************************/
PRINT 'Dados.PROPOSTA'            
;with propostas as 	
(
		select  
				t.[Premio_Sem_Desconto] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta) > 0 THEN t.Proposta ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta)) END AS Proposta,
				t.[Premio_Atual] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora
				where  Proposta IS NOT NULL

				UNION ALL 

		select 
				t.[Premio_Sem_Desconto2] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta2) > 0 THEN t.Proposta2 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta2)) END AS Proposta,
				t.[Premio_Atual2] as Valor,
				t.NomeArquivo
				--,S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora2
				where  Proposta2 IS NOT NULL

				UNION ALL 

		select 
				t.[Premio_Sem_Desconto3] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta3) > 0 THEN t.Proposta3 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta3)) END AS Proposta,
				t.[Premio_Atual3] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora3
				where  Proposta3 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto4] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta4) > 0 THEN t.Proposta4 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta4)) END AS Proposta,
				t.[Premio_Atual4] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora4
				where  Proposta4 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto5] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta5) > 0 THEN t.Proposta5 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta5)) END AS Proposta,
				t.[Premio_Atual5] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora5
				where  Proposta5 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto6] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta6) > 0 THEN t.Proposta6 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta6)) END AS Proposta,
				t.[Premio_Atual6] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora6
				where  Proposta6 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto7] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta7) > 0 THEN t.Proposta7 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta7)) END AS Proposta,
				t.[Premio_Atual] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora7
				where  Proposta7 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto8] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta8) > 0 THEN t.Proposta8 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta8)) END AS Proposta,
				t.[Premio_Atual8] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 

				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora8
				where  Proposta8 IS NOT NULL

				UNION ALL 

	select 
				t.[Premio_Sem_Desconto9] as [ValorPremioBrutoEmissao],
				t.DataArquivo,
				 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta9) > 0 THEN t.Proposta9 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta9)) END AS Proposta,
				t.[Premio_Atual9] as Valor,
				t.NomeArquivo
				--,				S.ID as IDSeguradora 
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora9
				where  Proposta9 IS NOT NULL  
) ,ranking as 
(
			select * from (select row_number() over (partition by Proposta order by prp.DataArquivo Desc) as rankin,prp.*
				from Propostas prp
			--	left join Dados.Proposta p on p.NumeroProposta = prp.Proposta and p.IDSeguradora = prp.IDSeguradora 
			) as  a where rankin = 1
				
)
MERGE INTO Dados.Proposta as T
	USING
	(	
		select * from ranking 


		) AS X
		ON   T.NumeroProposta = X.Proposta
		 --and T.IDSeguradora = X.IDSeguradora

	--WHEN MATCHED AND TipoDado = 'AQAUTSIS' THEN UPDATE SET 
	WHEN NOT MATCHED  THEN INSERT
	(	
							    [NumeroProposta]
							   ,[Valor]
							   ,[DataArquivo]
							   ,[ValorPremioBrutoEmissao]
							   ,[TipoDado]
							   ,[IDSeguradora]
							)

     VALUES (			
	          X.[Proposta],
			  X.[Valor], 
			  X.DataArquivo,
			  X.[ValorPremioBrutoEmissao],
			  X.NomeArquivo,
			  1
			)
	--WHEN MATCHED AND T.Arquivo like X.Arquivo THEN
	--UPDATE SET I
	;

	--SELECT * FROM Dados.SEguradora

	--TODO -- Proposta Cliente




--SELECT Protocolo, COUNT(*) AS QTD
--FROM Dados.Atendimento
--GROUP BY Protocolo
--HAVING COUNT(*) > 1

--SELECT *
--FROM Dados.Atendimento
--WHERE Protocolo = 5736180   

--DELETE 
--FROM Dados.AtendimentoClientePropostas

--DELETE 
--FROM Dados.PropostaCliente
--select * from [dbo].[Retorno_VendasAuto_KPN_TEMP]

/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA DE PROPOSTAS - select TRY_PARSE(ltrim(rtrim(NumeroProposta)) as int),* from dbo.[AtendimentoPARIndica_TEMP] where NumeroProposta <> ''	 AND charindex('.',NumeroProposta) =  0 and NumeroProposta <> '0'  AND NumeroProposta not 
i



n ('C','FI') AND NomeCliente = 'LEONILA MARIA GONCALVES SAMPAIO'*/
--SELECT * FROM Dados.Proposta where ID IN (676,678)
/*********************************************************************************************************************/
PRINT 'Dados.PropostaCliente'            
;MERGE INTO Dados.PropostaCliente as T
	USING
	(	
		select * from (select distinct NomeArquivo,
				1 as IDSeguradora ,
				x.TipoDado,
				x.DataArquivo,
				[NomeClienteTratado],
				p.ID as IDProposta,
				x.CPF,
				x.DataNascimento,
				row_number() over (partition by p.id order by x.DataArquivo desc) as numerador
				
				from (
			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta) > 0 THEN t.Proposta ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta)) END AS Proposta,
				t.NomeArquivo,
				--S.ID as IDSeguradora,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora
				
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta2) > 0 THEN t.Proposta2 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta2)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora2
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta3) > 0 THEN t.Proposta3 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta3)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				-- join Dados.Seguradora S on S.Nome = t.Informe_Seguradora3
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta4) > 0 THEN t.Proposta4 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta4)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora4
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta5) > 0 THEN t.Proposta5 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta5)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				-- join Dados.Seguradora S on S.Nome = t.Informe_Seguradora5
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta6) > 0 THEN t.Proposta6 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta6)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora6
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta7) > 0 THEN t.Proposta7 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta7)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora7
				
				UNION ALL

			select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta8) > 0 THEN t.Proposta8 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta8)) END AS Proposta,
				t.NomeArquivo,
				--S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora8
				
				UNION ALL
	select 
			 /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CASE WHEN PATINDEX('%[^0-9]%', t.Proposta9) > 0 THEN t.Proposta9 ELSE CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(CleansingKit.dbo.fn_TrimNull(t.Proposta9)) END AS Proposta,
				t.NomeArquivo,
			--	S.ID as IDSeguradora ,
				Nomearquivo as TipoDado,
				DataArquivo,
				[NomeClienteTratado],
				CPF,
				DataNascimento
				
				FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] t 
				--inner join Dados.Seguradora S on S.Nome = t.Informe_Seguradora9
				
				
				) as x
				inner join Dados.Proposta p on p.NumeroProposta = x.Proposta and 1 = p.IDSeguradora
				where  Proposta IS NOT NULL) y where numerador = 1
	) AS X
		ON X.IDProposta = T.IDProposta
	WHEN MATCHED THEN UPDATE SET CPFCNPJ = COALESCE(X.CPF,T.CPFCNPJ),
								Nome = COALESCE(X.[NomeClienteTratado],T.Nome),
								DataNascimento = COALESCE(X.DataNascimento,T.DataNascimento)
	WHEN NOT MATCHED  THEN INSERT
	(	
							    [IDProposta]
							   ,[CPFCNPJ]
							   ,[Nome]
							   ,[DataNascimento]
							   ,[TipoDado]
							   ,[DataArquivo]
							   
							)

     VALUES (			X.[IDProposta],
						X.[CPF],
					    X.[NomeClienteTratado], 
					    X.[DataNascimento],
						X.[TipoDado],
						X.[DataArquivo]
					    );




/**********************************************************************
Inserção dos Dados - Dados de Atendimento Proposta de Clientes
***********************************************************************/    
PRINT 'Dados.AtendimentoClientePropostas'            
MERGE INTO Dados.AtendimentoClientePropostas AS T
USING
	(
		SELECT DA.ID AS IDAtendimento,
			   P.ID AS IDProposta,
			   T.DataArquivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		INNER JOIN Dados.Proposta AS P
		ON T.Proposta = P.NumeroProposta
		INNER JOIN Dados.Atendimento AS DA
		ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
	) AS S
ON T.IDAtendimento = S.IDAtendimento
WHEN NOT MATCHED THEN
	INSERT (IDAtendimento, IDProposta,DataCadastro)
	VALUES (IDAtendimento, IDProposta,DataArquivo);



/**********************************************************************
Inserção dos Dados - Dados de veículos do Atendimento
***********************************************************************/  
PRINT 'Dados.AtendimentoVeiculo'              
MERGE INTO Dados.AtendimentoVeiculo AS T
USING
	(
		SELECT DISTINCT * FROM (select  IDAtendimento,
						NumeroVeiculo,
						IDVeiculo,
						Placa,
						Premio_Atual,
						Premio_Sem_Desconto,
						QuantidadeParcelas,
						FormaPagamento,
						IDSeguradora_Atual,
						REPLACE(REPLACE(REPLACE(BitVistoria,'SIM',''),'NÃO',''),'NAO','') AS BitVistoria,
						IDStatus_Ligacao,
						ROW_NUMBER() OVER (PARTITION BY IDAtendimento,NumeroVeiculo order by DateTime_Contato_Efetivo desc) as ordem					
		from (SELECT  DA.ID AS IDAtendimento,
			   1 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo],
			   T.PlacaVeiculo Placa,
			   T.Premio_Atual,
			   T.Premio_Sem_Desconto,
			   T.QuantidadeParcelas,
			   T.FormaPagamento,
			   SEG.ID [IDSeguradora_Atual],
			   T.BitVistoria,
			   SL.ID [IDStatus_Ligacao],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo IS NOT NULL --and DA.ID = 2143087

		UNION ALL

		--veículo 2

		SELECT  DA.ID AS IDAtendimento,
			   2 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo2],
			   T.PlacaVeiculo2 Placa2,
			   T.Premio_Atual2,
			   T.Premio_Sem_Desconto2,
			   T.QuantidadeParcelas2,
			   T.FormaPagamento2,
			   SEG.ID [IDSeguradora_Atual2],
			   T.BitVistoria2,
			   SL.ID [IDStatus_Ligacao2],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo2 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual2 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo2 IS NOT NULL 

		UNION ALL

--veículo 3

		SELECT  DA.ID AS IDAtendimento,
			   3 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo3],
			   T.PlacaVeiculo3 Placa3,
			   T.Premio_Atual3,
			   T.Premio_Sem_Desconto3,
			   T.QuantidadeParcelas3,
			   T.FormaPagamento3,
			   SEG.ID [IDSeguradora_Atual3],
			   T.BitVistoria3,
			   SL.ID [IDStatus_Ligacao3],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo3 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual3 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo3 IS NOT NULL 

		UNION ALL

		SELECT DA.ID AS IDAtendimento,
			   4 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo4],
			   T.PlacaVeiculo4 Placa4,
			   T.Premio_Atual4,
			   T.Premio_Sem_Desconto4,
			   T.QuantidadeParcelas4,
			   T.FormaPagamento4,
			   SEG.ID [IDSeguradora_Atual4],
			   T.BitVistoria4,
			   SL.ID [IDStatus_Ligacao4],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo4 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual4 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo IS NOT NULL 

		UNION ALL

		SELECT DA.ID AS IDAtendimento,
			   5 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo5],
			   T.PlacaVeiculo5 Placa5,
			   T.Premio_Atual5,
			   T.Premio_Sem_Desconto5,
			   T.QuantidadeParcelas5,
			   T.FormaPagamento5,
			   SEG.ID [IDSeguradora_Atual5],
			   T.BitVistoria5,
			   SL.ID [IDStatus_Ligacao5],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo5 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual5 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo5 IS NOT NULL 
		
		UNION ALL

		SELECT DA.ID AS IDAtendimento,
			   6 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo6],
			   T.PlacaVeiculo5 Placa6,
			   T.Premio_Atual6,
			   T.Premio_Sem_Desconto6,
			   T.QuantidadeParcelas6,
			   T.FormaPagamento6,
			   SEG.ID [IDSeguradora_Atual6],
			   T.BitVistoria6,
			   SL.ID [IDStatus_Ligacao6],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
  		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo5 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual6 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo5 IS NOT NULL 

		UNION ALL

		SELECT DA.ID AS IDAtendimento,
			   7 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo7],
			   T.PlacaVeiculo5 Placa7,
			   T.Premio_Atual7,
			   T.Premio_Sem_Desconto7,
			   T.QuantidadeParcelas7,
			   T.FormaPagamento7,
			   SEG.ID [IDSeguradora_Atual7],
			   T.BitVistoria7,
			   SL.ID [IDStatus_Ligacao7],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		  	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo5 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual7 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo5 IS NOT NULL 

		UNION ALL

		SELECT DA.ID AS IDAtendimento,
			   8 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo8],
			   T.PlacaVeiculo5 Placa8,
			   T.Premio_Atual8,
			   T.Premio_Sem_Desconto8,
			   T.QuantidadeParcelas8,
			   T.FormaPagamento8,
			   SEG.ID [IDSeguradora_Atual8],
			   T.BitVistoria8,
			   SL.ID [IDStatus_Ligacao8],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo8 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual8 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo5 IS NOT NULL 
		
		UNION ALL

		SELECT  DA.ID AS IDAtendimento,
			   9 AS [NumeroVeiculo],
			   VEI.ID [IDVeiculo9],
			   T.PlacaVeiculo5 Placa9,
			   T.Premio_Atual9,
			   T.Premio_Sem_Desconto9,
			   T.QuantidadeParcelas9,
			   T.FormaPagamento9,
			   SEG.ID [IDSeguradora_Atual9],
			   T.BitVistoria9,
			   SL.ID [IDStatus_Ligacao9],	
			   T.DateTime_Contato_Efetivo
		FROM [dbo].[Retorno_VendasAuto_KPN_TEMP] AS T
		   INNER JOIN Dados.Atendimento AS DA
		   ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
		    --LEFT OUTER JOIN Dados.Seguradora AS SEG
	     --  ON SEG.Nome = T.Seguradora_Atual1
   		   	LEFT OUTER JOIN Dados.Status_Ligacao AS SL
	       ON T.Status_Ligacao = SL.Nome
	       OUTER APPLY (SELECT TOP 1 * FROM Dados.Veiculo AS VEI WHERE VEI.Nome = T.NomeVeiculo9 ORDER BY VEI.Codigo DESC) VEI
		   OUTER APPLY (SELECT TOP 1 * FROM Dados.Seguradora AS SEG WHERE SEG.Nome = T.Seguradora_Atual9 ORDER BY SEG.Codigo DESC) SEG
		WHERE T.NomeVeiculo5 IS NOT NULL 

		) x where IDVeiculo is not null ) Y where ordem = 1 

	) AS S
ON  T.IDAtendimento = S.IDAtendimento
AND T.NumeroVeiculo = S.NumeroVeiculo
WHEN NOT MATCHED THEN
	INSERT (IDAtendimento, NumeroVeiculo, IDVeiculo, Placa, Premio_Atual, Premio_Sem_Desconto
	      , QtdParcelas, FormaPagamento, BitVistoria, IDSeguradora_Atual, IDStatus_Ligacao)
	VALUES (S.IDAtendimento, S.NumeroVeiculo, S.[IDVeiculo], S.Placa, S.Premio_Atual, S.Premio_Sem_Desconto
		  , S.QuantidadeParcelas, S.FormaPagamento, S.BitVistoria, S.IDSeguradora_Atual, S.IDStatus_Ligacao)
WHEN MATCHED THEN
    UPDATE
		SET IDVeiculo = COALESCE(S.IDVeiculo, T.IDVeiculo),
		    Placa = COALESCE(S.Placa, T.Placa),
			Premio_Atual = COALESCE(S.Premio_Atual, T.Premio_Atual),
			Premio_Sem_Desconto = COALESCE(S.Premio_Sem_Desconto, T.Premio_Sem_Desconto),
			QtdParcelas = COALESCE(S.QuantidadeParcelas, T.QtdParcelas),
			FormaPagamento = COALESCE(S.FormaPagamento, T.FormaPagamento),
            BitVistoria = COALESCE(S.BitVistoria, T.BitVistoria),
			IDSeguradora_Atual = COALESCE(S.IDSeguradora_Atual, T.IDSeguradora_Atual),
			IDStatus_Ligacao = COALESCE(S.IDStatus_Ligacao, T.IDStatus_Ligacao)
		  ;


--TODO -- Demais veiculos do atendimento

/*****************************************************************************************/
/*Ponto de Parada*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Retorno_VendasAuto_KPN'

TRUNCATE TABLE [dbo].[Retorno_VendasAuto_KPN_TEMP]

/*Recuperação do Maior Código do Retorno*/
SET @COMANDO =
'
INSERT INTO [dbo].[Retorno_VendasAuto_KPN_TEMP]
(
    ID,
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,

	
	
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Tel_Adicional_1,
	Tel_Adicional_2,
	Email1,
	Email2,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	AgenciaLotacao,
	AgenciaIndicacao,
	ProdutosAdquiridos,
	NomeVeiculo,
	PlacaVeiculo,
	NomeVeiculo2,
	PlacaVeiculo2,
	NomeVeiculo3,
	PlacaVeiculo3,
	NomeVeiculo4,
	PlacaVeiculo4,
	NomeVeiculo5,
	PlacaVeiculo5,
	NomeVeiculo6,
	PlacaVeiculo6,
	NomeVeiculo7,
	PlacaVeiculo7,
	NomeVeiculo8,
	PlacaVeiculo8,
	NomeVeiculo9,
	PlacaVeiculo9,
	BitVistoria,
	BitVistoria2,
	BitVistoria3,
	BitVistoria4,
	BitVistoria5,
	BitVistoria6,
	BitVistoria7,
	BitVistoria8,
	BitVistoria9,
	QuantidadeParcelas,
	QuantidadeParcelas2,
	QuantidadeParcelas3,
	QuantidadeParcelas4,
	QuantidadeParcelas5,
	QuantidadeParcelas6,
	QuantidadeParcelas7,
	QuantidadeParcelas8,
	QuantidadeParcelas9,							
	ProdutoOferta,
	ProspectOferta,
	CotacaoRealizada,
	Termino_Vigencia,
	Data_Renovacao,
	Premio_Atual,
	Premio_Sem_Desconto,
	FormaPagamento,
	Proposta,
	Informe_Seguradora,
	Seguradora_Atual,

	ProspectOferta2,
	CotacaoRealizada2,
	Data_Renovacao2,
	Premio_Atual2,
	Premio_Sem_Desconto2,
	FormaPagamento2,
	Proposta2,
	Informe_Seguradora2,
	Seguradora_Atual2,

	ProspectOferta3,
	CotacaoRealizada3,
	Data_Renovacao3,
	Premio_Atual3,
	Premio_Sem_Desconto3,
	FormaPagamento3,
	Proposta3,
	Informe_Seguradora3,
	Seguradora_Atual3,

	ProspectOferta4,
	CotacaoRealizada4,
	Data_Renovacao4,
	Premio_Atual4,
	Premio_Sem_Desconto4,
	FormaPagamento4,
	Proposta4,
	Informe_Seguradora4,
	Seguradora_Atual4,

	ProspectOferta5,
	CotacaoRealizada5,
	Data_Renovacao5,
	Premio_Atual5,
	Premio_Sem_Desconto5,
	FormaPagamento5,
	Proposta5,
	Informe_Seguradora5,
	Seguradora_Atual5,

	ProspectOferta6,
	CotacaoRealizada6,
	Data_Renovacao6,
	Premio_Atual6,
	Premio_Sem_Desconto6,
	FormaPagamento6,
	Proposta6,
	Informe_Seguradora6,
	Seguradora_Atual6,

	ProspectOferta7,
	CotacaoRealizada7,
	Data_Renovacao7,
	Premio_Atual7,
	Premio_Sem_Desconto7,
	FormaPagamento7,
	Proposta7,
	Informe_Seguradora7,
	Seguradora_Atual7,

	ProspectOferta8,
	CotacaoRealizada8,
	Data_Renovacao8,
	Premio_Atual8,
	Premio_Sem_Desconto8,
	FormaPagamento8,
	Proposta8,
	Informe_Seguradora8,
	Seguradora_Atual8,

		ProspectOferta9,
	CotacaoRealizada9,
	Data_Renovacao9,
	Premio_Atual9,
	Premio_Sem_Desconto9,
	FormaPagamento9,
	Proposta9,
	Informe_Seguradora9,
	Seguradora_Atual9,

	Cod_Campanha,
	Cod_Mailing,
	Produto_Efetivado,
	Regional_Par,
	SuperIntendencia_Regional,
	NomeCliente
)
SELECT 
    ID,	
	Cast(DataArquivo as Date) DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	Cast(TMA as int) TMA,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,
	
	
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Tel_Adicional_1,
	Tel_Adicional_2,
	Email1,
	Email2,
	cast(Datetime_Contato_Efetivo as datetime) as DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	AgenciaLotacao,
	AgenciaIndicacao,
	ProdutosAdquiridos,
	LEFT(NomeVeiculo,100) NomeVeiculo,
	PlacaVeiculo,
	LEFT(NomeVeiculo2,100) NomeVeiculo2,
	PlacaVeiculo2,
	LEFT(NomeVeiculo3,100) NomeVeiculo3,
	PlacaVeiculo3,
	LEFT(NomeVeiculo4,100) NomeVeiculo4,
	PlacaVeiculo4,
	LEFT(NomeVeiculo5,100) NomeVeiculo5,
	PlacaVeiculo5,
	LEFT(NomeVeiculo6,100) NomeVeiculo6,
	PlacaVeiculo6,
	LEFT(NomeVeiculo7,100) NomeVeiculo7,
	PlacaVeiculo7,
	LEFT(NomeVeiculo8,100) NomeVeiculo8,
	PlacaVeiculo8,
	LEFT(NomeVeiculo9,100) NomeVeiculo9,
	PlacaVeiculo9,
	BitVistoria,
	BitVistoria2,
	BitVistoria3,
	BitVistoria4,
	BitVistoria5,
	BitVistoria6,
	BitVistoria7,
	BitVistoria8,
	BitVistoria9,
	QuantidadeParcelas,
	QuantidadeParcelas2,
	QuantidadeParcelas3,
	QuantidadeParcelas4,
	QuantidadeParcelas5,
	QuantidadeParcelas6,
	QuantidadeParcelas7,
	QuantidadeParcelas8,
	QuantidadeParcelas9,
	ProdutoOferta,
	ProspectOferta,
	CotacaoRealizada,
	Termino_Vigencia,
	Data_Renovacao,
	Premio_Atual,
	Premio_Sem_Desconto,
	FormaPagamento,
	Proposta,
	Informe_Seguradora,
	Seguradora_Atual,
	ProspectOferta2,
	CotacaoRealizada2,
	Data_Renovacao2,
	Premio_Atual2,
	Premio_Sem_Desconto2,
	FormaPagamento2,
	Proposta2,
	Informe_Seguradora2,
	Seguradora_Atual2,
	ProspectOferta3,
	CotacaoRealizada3,
	Data_Renovacao3,
	Premio_Atual3,
	Premio_Sem_Desconto3,
	FormaPagamento3,
	Proposta3,
	Informe_Seguradora3,
	Seguradora_Atual3,
	ProspectOferta4,
	CotacaoRealizada4,
	Data_Renovacao4,
	Premio_Atual4,
	Premio_Sem_Desconto4,
	FormaPagamento4,
	Proposta4,
	Informe_Seguradora4,
	Seguradora_Atual4,
	ProspectOferta5,
	CotacaoRealizada5,
	Data_Renovacao5,
	Premio_Atual5,
	Premio_Sem_Desconto5,
	FormaPagamento5,
	Proposta5,
	Informe_Seguradora5,
	Seguradora_Atual5,
	ProspectOferta6,
	CotacaoRealizada6,
	Data_Renovacao6,
	Premio_Atual6,
	Premio_Sem_Desconto6,
	FormaPagamento6,
	Proposta6,
	Informe_Seguradora6,
	Seguradora_Atual6,
	ProspectOferta7,
	CotacaoRealizada7,
	Data_Renovacao7,
	Premio_Atual7,
	Premio_Sem_Desconto7,
	FormaPagamento7,
	Proposta7,
	Informe_Seguradora7,
	Seguradora_Atual7,
	ProspectOferta8,
	CotacaoRealizada8,
	Data_Renovacao8,
	Premio_Atual8,
	Premio_Sem_Desconto8,
	FormaPagamento8,
	Proposta8,
	Informe_Seguradora8,
	Seguradora_Atual8,
	ProspectOferta9,
	CotacaoRealizada9,
	Data_Renovacao9,
	Premio_Atual9,
	Premio_Sem_Desconto9,
	FormaPagamento9,
	Proposta9,
	Informe_Seguradora9,
	Seguradora_Atual9,
	Cod_Campanha,
	Cod_Mailing,
	Produto_Efetivado,
	Regional_Par,
	SuperIntendencia_Regional,
	NomeCliente
FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaVendasAuto_KPN] ''''' + @PontoDeParada + ''''''') PRP '	   

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[Retorno_VendasAuto_KPN_TEMP]
            
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Retorno_VendasAuto_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Retorno_VendasAuto_KPN_TEMP]				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

--	EXEC [Dados].[proc_InsereVendasAuto_KPN] 

--SELECT *
--FROM [Retorno_VendasAuto_KPN_TEMP]









