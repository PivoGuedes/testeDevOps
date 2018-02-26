
/*
	Autor: Pedro Guedes
	Data Criação: 09/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	
ALTER TABLE Dados.Plano DROP COLUMN ID
*/

/*******************************************************************************
	Nome: Dados.proc_InserePropostaSaudeFamiliaEVida
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
		delete from  dbo.proc_InserePropostaSaudeFamiliaEVida			
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePagamentosProtheus]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PagamentosProtheus_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PagamentosProtheus_TEMP];

CREATE TABLE [dbo].[PagamentosProtheus_TEMP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDMotivo] [int] NULL,
	[IDMotivoSituacao] [int] NULL,
	[IDEndosso] [int] NULL,
	[IDSituacaoProposta] [int] NULL,
	[NumeroParcela] [int] NULL,
	[NumeroTitulo] [varchar](12) NULL,
	[Valor] [decimal](24, 4) NULL,
	[ValorIOF] [decimal](24, 4) NULL,
	[DataEfetivacao] [date]  NULL,
	[DataArquivo] [date]  NULL,
	[CodigoNaFonte] [int] NULL,
	[TipoDado] [varchar](12) NULL,
	[EfetivacaoPgtoEstimadoPelaEmissao] [int] NULL,
	[SinalLancamento] [varchar](5) NULL,
	[ExpectativaDeReceita] [varchar](12) NULL,
	[Arquivo] [varchar](80) NULL,
	[DataInicioVigencia] [varchar] (12) NULL,
	[DataFimVigencia][varchar] (12) NULL,
	[ParcelaCalculada] [int] NULL,
	[SaldoProcessado] [int] NULL,	
	[DataEmissao] [varchar] (12) NULL,
	[DataVencimento] [varchar] (12) NULL,
	[Empresa] [varchar] (12)  NULL,
	[cliente] [varchar] (12)  NULL,
	[AnoMesBase] [varchar] (12)  NULL,
	[NumeroProposta] [varchar] (20) NOT NULL,
	[Operadora] [varchar] (4) NOT NULL,
	[MotivoBaixa] [varchar] (3)  NULL,
	[Ranking] [int] NOT NULL,
	--[ValorPremioLiquido] [decimal](19, 2) NULL,
	--[QuantidadeOcorrencias] [smallint] NULL,
	--[IDSituacaoParcela] [tinyint] NULL,

	
	
 CONSTRAINT [PK_PagamentosProtheus_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

--ALTER TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP] ADD  CONSTRAINT [DF_PropostaSaudeFamiliaEVida_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_PagamentosProtheus_TEMP ON [dbo].[PagamentosProtheus_TEMP]
( 
  NumeroTitulo ASC,AnoMesBase ASC
)       

INSERT into [dbo].[PagamentosProtheus_TEMP] (
											[IDMotivo],
											[IDMotivoSituacao],
											[IDEndosso],
											[IDSituacaoProposta],
											[NumeroParcela],
											[NumeroTitulo],
											[Valor],
											[ValorIOF],
											[DataEfetivacao],
											[DataArquivo],
											[CodigoNaFonte],
											[TipoDado],
											[EfetivacaoPgtoEstimadoPelaEmissao],
											[SinalLancamento],
											[ExpectativaDeReceita],
											[Arquivo],
											[DataInicioVigencia],
											[DataFimVigencia],
											[ParcelaCalculada],
											[SaldoProcessado],	
											[DataEmissao],
											[DataVencimento],
											[Empresa],
											[cliente],
											[AnoMesBase],
											[NumeroProposta],
											[Operadora],
											[MotivoBaixa],
											[Ranking]
											
				
				)  exec [Dados].[proc_RecuperaPagamentosProtheus]
					
			   ----SELECT * FROM [PagamentosProtheus_TEMP]
			   


/**********************************************************************
       Faz o merge na tabela Dados.Parcela
	  SELECT * FROM DADOS.Parcela
	 
 ***********************************************************************/  
 declare @idparcela int
 SELECT @idparcela = ISNULL(MAX(ID),0) from Dados.Parcela where ID IS NOT NULL
         
;MERGE INTO Dados.Parcela AS T
	 USING (select *,ROW_NUMBER() OVER (ORDER BY NumeroTitulo,NumeroParcela) AS numlinha from (SELECT  distinct IDEndosso,NumeroParcela,empresa+NumeroTitulo as NumeroTitulo,
			Valor as ValorPremioLiquido,DataVencimento,NULL AS QuantidadeOcorrencias,
				CASE WHEN DataEfetivacao IS NULL THEN 1
				ELSE 2 END AS IDSituacaoParcela,DataArquivo,DataEmissao
               FROM [dbo].[PagamentosProtheus_TEMP] t	
			    
              ) O ) X
       ON T.NumeroTitulo = X.NumeroTitulo and T.NumeroParcela = X.NumeroParcela
       WHEN NOT MATCHED
		          THEN INSERT (ID,IDEndosso,NumeroParcela,NumeroTitulo,
								ValorPremioLiquido,DataVencimento,QuantidadeOcorrencias,
								IDSituacaoParcela,DataArquivo,DataEmissao
								)
		               VALUES (X.numlinha+@idparcela,X.IDEndosso, X.NumeroParcela,X.NumeroTitulo,
							X.ValorPremioLiquido,X.DataVencimento,X.QuantidadeOcorrencias,
							X.IDSituacaoParcela,X.DataArquivo,X.DataEmissao
					   );

--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP]
-- SELECT * FROM DADOS.TIPOKIT


/**********************************************************************
       Faz o merge na tabela Dados.ParcelaSaude
	  SELECT * FROM DADOS.ParcelaSaude

	  	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParcela] [bigint] NOT NULL,
	[NumeroTitulo] [varchar](13) NOT NULL,
	[DataVencimento] [date] NOT NULL,
	[IDSeguradora] [smallint] NOT NULL,
	[NumeroProposta] [varchar](20) NOT NULL,
	[IDProposta] [bigint] NOT NULL,
	[DataEmissao] [date] NOT NULL,
	
 ***********************************************************************/  
 --declare @idparcela int
 --SELECT @idparcela = ISNULL(MAX(ID),0) from Dados.Parcela where ID IS NOT NULL
         
;MERGE INTO Dados.ParcelaSaude AS T
	 USING (SELECT distinct p.ID as IDParcela,t.empresa+t.NumeroTitulo as NumeroTitulo,t.DataVencimento,
				case when Cast(t.OPERADORA AS iNT) = 1 then 18
					when Cast(t.OPERADORA AS iNT) = 2 then 42
					when Cast(t.OPERADORA AS iNT) = 3 then 43
					when Cast(t.OPERADORA AS iNT) = 4 then 44 End as IDSeguradora,
					t.NumeroProposta,prp.ID as IDProposta,t.DataEmissao
               FROM [dbo].[PagamentosProtheus_TEMP] t	
			   inner join Dados.Parcela p on empresa+t.NumeroTitulo = p.NumeroTitulo and p.NumeroParcela = t.NumeroParcela
			   inner join Dados.Proposta prp on prp.NumeroProposta = t.NumeroProposta and case when Cast(t.OPERADORA AS iNT) = 1 then 18
					else cast(t.operadora as int) end = prp.IDSeguradora
			    
             ) X
       ON T.IDParcela = X.IDParcela
       WHEN NOT MATCHED
		          THEN INSERT ([IDParcela],[NumeroTitulo],[DataVencimento],[IDSeguradora] ,
								  [NumeroProposta],[IDProposta], [DataEmissao] 
								)
		               VALUES (X.IDParcela,X.NumeroTitulo, X.[DataVencimento],X.[IDSeguradora],
							X.[NumeroProposta],X.[IDProposta],X.[DataEmissao]
					   );

--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP]
-- SELECT * FROM DADOS.TIPOKIT


/**********************************************************************
        Faz o merge na tabela Dados.Pagamento
		  SELECT * FROM DADOS.Pagamento where IDProposta = 15940
		  	  SELECT top 3 * FROM dbo.[PagamentosProtheus_TEMP]
			  The duplicate key value is (15940, 1, 7, 344.00, 2014-04-25).
			  The duplicate key value is (221368, 1, 31, 222.10, 2014-05-12).
 ***********************************************************************/  
            
;MERGE INTO Dados.Pagamento AS T
	 USING (SELECT distinct  p.ID as IDProposta,IDMotivo,t.IDMotivoSituacao,t.IDSituacaoProposta,t.NumeroParcela,
			t.Valor,NULL AS ValorIOF,t.NumeroTitulo,t.DataEfetivacao,t.DataArquivo,t.CodigoNaFonte,t.TipoDado,t.EfetivacaoPgtoEstimadoPelaEmissao,
			t.SinalLancamento,t.ExpectativaDeReceita,t.Arquivo,t.DataInicioVigencia,t.DataFimVigencia,t.ParcelaCalculada,t.SaldoProcessado--,*
				 FROM [dbo].[PagamentosProtheus_TEMP] t	
			   inner join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora = Case when Cast(Operadora as Int) = 1 then 18
							else Cast(Operadora as Int) End 
							 where DataEfetivacao is not null --and p.ID = 234104

							 --SELECT * FROM DADOS.Pagamento where IDProposta = 15940
              ) X
       ON /*T.NumeroTitulo = X.NumeroTitulo and*/ T.NumeroParcela = X.NumeroParcela 
				AND T.IDProposta = X.IDProposta AND T.IDMotivo = X.IDMotivo
				AND X.DataArquivo = T.DataArquivo AND X.Valor = T.Valor
       WHEN NOT MATCHED 
		          THEN INSERT (IDProposta,IDMotivo,IDMotivoSituacao,IDSituacaoProposta,NumeroParcela,
							Valor,ValorIOF,NumeroTitulo,DataEfetivacao,DataArquivo,CodigoNaFonte,
							TipoDado,EfetivacaoPgtoEstimadoPelaEmissao,SinalLancamento,ExpectativaDeReceita,Arquivo,DataInicioVigencia,
							DataFimVigencia,ParcelaCalculada,SaldoProcessado
							)
				  
		               VALUES (X.IDProposta, X.IDMotivo,X.IDMotivoSituacao,
							X.IDSituacaoProposta,X.NumeroParcela,X.Valor,
							X.ValorIOF,X.NumeroTitulo,X.DataEfetivacao,
							X.DataArquivo,X.CodigoNaFonte,X.TipoDado,
							X.EfetivacaoPgtoEstimadoPelaEmissao,X.SinalLancamento,X.ExpectativaDeReceita,
							X.Arquivo,X.DataInicioVigencia,X.DataFimVigencia,
							X.ParcelaCalculada,X.SaldoProcessado
					   );
--Select * from dados.[TipoVida]


END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  






















