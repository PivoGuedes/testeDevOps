




/*
	Autor: Pedro Guedes
	Data Criação: 09/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	
ALTER TABLE Dados.Plano DROP COLUMN ID
*/

/*******************************************************************************
	Nome: Dados.proc_InsereComissaoProtheus
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
		delete from  dbo.proc_InsereComissaoProtheus			
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereComissaoProtheus]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComissaoProtheus_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[ComissaoProtheus_TEMP];

CREATE TABLE [dbo].[ComissaoProtheus_TEMP](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDRamo] [int] NULL,
	[ValorCorretagem] [decimal](38, 6) NULL,
	[PercentualCorretagem] [decimal](5, 2) NULL,
	[ValorBase] [decimal](38, 6) NULL,
	[ValorComissaoPAR] [decimal](38, 6) NULL,
	[ValorRepasse] [decimal](38, 6) NULL,
	[DataCompetencia] [VARCHAR] (10) NULL,
	[DataRecibo] [date] NULL,
	[NumeroRecibo] [int] NULL,
	[NumeroEndosso] [int] NULL,
	[NumeroParcela] [int] NULL,
	[DataCalculo] [date] NULL,
	[DataQuitacaoParcela] [date] NULL,
	[TipoCorretagem] [int] NULL,
	[IDOperacao] [int] NULL,
	[IDProdutor] [int] NULL,
	[IDFilialFaturamento] [int] NULL,
	[CodigoSubgrupoRamoVida] [int] NULL,
	[IDProduto] [int] NULL,
	[IDUnidadeVenda] [smallint] NULL,
	[IDProposta] [bigint] NULL,
	[IDCanalVendaPAR] [int] NULL,
	[NumeroProposta] [varchar](20)  NULL,
	[CodigoProduto] [varchar](5) NULL,
	[LancamentoManual] [bit] NULL,
	[Repasse] [bit] NULL,
	[Arquivo] [varchar](80) NULL,
	[DataArquivo] [date] NULL,
	[Operadora] [varchar] (4) NOT NULL,
	[Empresa] [varchar] (2) NOT NULL,
	[Segmento] [varchar] (2) NOT NULL,
	[NomeContrato] [varchar] (70) NULL,
	[IDEmpresa] [int] NOT NULL,
	[DescricaoCanalVenda] [varchar] (100) NOT NULL,
	[IDSeguradora] [int] NULL,
	[QtApolices] [int] NULL,
 CONSTRAINT [PK_Comissao_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
)
 

INSERT into [dbo].[ComissaoProtheus_TEMP] (
											[IDRamo],
											[ValorCorretagem],
											[PercentualCorretagem],
											[ValorBase],
											[ValorComissaoPAR],
											[ValorRepasse],
											[DataCompetencia],
											[DataRecibo],
											[NumeroRecibo],
											[NumeroEndosso],
											[NumeroParcela],
											[DataCalculo],
											[DataQuitacaoParcela],
											[TipoCorretagem],
											--[IDOperacao],
											--[IDProdutor],
											--[IDFilialFaturamento],
											--[CodigoSubgrupoRamoVida],
											--[IDProduto],
											--[IDUnidadeVenda],
											--[IDProposta],
											[NumeroProposta],
											--[CodigoProduto],
											--[LancamentoManual],
											--[Repasse],
											[Arquivo],
											--[DataArquivo]
											[Operadora],
											[Empresa],
											[Segmento],
											[NomeContrato],
											[IDEmpresa],
											[IDCanalVendaPAR],
											[DescricaoCanalVenda],
											[IDSeguradora],
											[QtApolices]


															
				) exec [Dados].[proc_RecuperaComissao]
					
			   ----SELECT * FROM [ComissaoProtheus_TEMP]


/**********************************************************************
       Faz o merge na tabela Dados.CanalVendaPARSaude
	   select * from dados.CanalVendaPARSAude
 ***********************************************************************/  



;MERGE INTO Dados.CanalVendaPARSaude AS T
	 USING (SELECT distinct '04'+right('000'+Cast(IDCanalVendaPAR as varchar),3) as CanalVendaPAR ,DescricaoCanalVenda
               FROM [dbo].[ComissaoProtheus_TEMP] t
              ) X
       ON T.[Codigo] = X.CanalVendaPAR
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, DigitoIdentificador,ProdutoIdentificador,MatriculaVendedorIdentificadora,VendaAgencia,Nome,DataInicio)
		               VALUES (X.CanalVendaPAR, 0,0,0,0, X.DescricaoCanalVenda,cast('2010-01-01' as date));




			   


/**********************************************************************
       Faz o merge na tabela Dados.Comissao
	
	
	
	
	
	  SELECT * FROM DADOS.Contrato
	  Select * From Dados.Proposta
	  select *  FROM Dados.Comissao where arquivo  = 'PROTHEUS' and ValorCorretagem < 0
	  select * from dados.empresa
	  select @@trancount
 ***********************************************************************/  
    
delete from Dados.ComissaoSaude
delete from Dados.Comissao where arquivo like '%PROTHEUS%'
	        
;MERGE INTO Dados.Comissao AS T
	 USING (SELECT distinct t.IDRamo as IDRamo,PercentualCorretagem,ValorCorretagem,ValorBase,DataRecibo,
				NumeroRecibo,NumeroEndosso,NumeroParcela,DataCalculo,DataQuitacaoParcela,TipoCorretagem,
				c.ID as IDContrato,NULL AS IDCertificado,IDOperacao,
				IDProdutor,IDFilialFaturamento,CodigoSubGrupoRamoVida,t.IDProduto,
				IDUnidadeVenda,p.ID as IDProposta,0 as LancamentoManual,Repasse,t.Arquivo,t.DataArquivo,t.IDEmpresa
               FROM [dbo].[ComissaoProtheus_TEMP] t	
			   LEFT join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora = case when Cast(Operadora AS iNT) = 1 then 18
					when Cast(Operadora AS iNT) = 2 then 42
					when Cast(Operadora AS iNT) = 3 then 43
					when Cast(Operadora AS iNT) = 4 then 44 
					when Cast(Operadora AS iNT) = 5 then 45
					when Cast(Operadora AS iNT) = 6 then 46
					when Cast(Operadora AS iNT) = 7 then 47 
					when Cast(Operadora AS iNT) = 8 then 50
					Else 18
					End 
				LEFT join [Dados].[Contrato] c on c.IDProposta = p.ID			    
              ) X
       ON  ISNULL(T.NumeroParcela,0) = ISNULL(X.NumeroParcela,0) and ISNULL(T.TipoCorretagem,0) = ISNULL(X.TipoCorretagem,0) and ISNULL(T.IDProposta,-1) = ISNULL(X.IDProposta,-1) and ISNULL(T.IDContrato,-1) = ISNULL(X.IDContrato,-1) AND ISNULL(T.NumeroEndosso,-1) = ISNULL(X.NumeroEndosso,-1)
       WHEN NOT MATCHED
		    THEN INSERT (IDRamo,PercentualCorretagem,
							ValorCorretagem,ValorBase,DataRecibo,
							NumeroRecibo,NumeroEndosso,NumeroParcela,
							DataCalculo,DataQuitacaoParcela,TipoCorretagem,
							IDContrato,IDCertificado,IDOperacao,IDProdutor,
							IDFilialFaturamento,CodigoSubgrupoRamoVida,IDProduto,
							IDUnidadeVenda,IDProposta,LancamentoManual,
							Repasse,Arquivo,DataArquivo,IDEmpresa
						)
		        VALUES (X.IDRamo,X.PercentualCorretagem,
							X.ValorCorretagem,X.ValorBase,X.DataRecibo,
							X.NumeroRecibo,X.NumeroEndosso,X.NumeroParcela,
							X.DataCalculo,X.DataQuitacaoParcela,X.TipoCorretagem,
							X.IDContrato,X.IDCertificado,X.IDOperacao,X.IDProdutor,
							X.IDFilialFaturamento,X.CodigoSubgrupoRamoVida,X.IDProduto,
							X.IDUnidadeVenda,X.IDProposta,X.LancamentoManual,
							X.Repasse,X.Arquivo,X.DataArquivo,X.IDEmpresa
					   );
--Select * from dbo.[ComissaoProtheus_TEMP]
-- SELECT * FROM DADOS.[ComissaoProtheus_TEMP]

/**********************************************************************
       Faz o merge na tabela Dados.Parcela
	SELECT * FROM DADOS.EMPRESA
	  SELECT * FROM DADOS.Contrato
	  Select * From Dados.Proposta
	  select *  FROM Dados.Comissao WHERE ARQUIVO = 'PROTHEUS'
	  BEGIN TRAN
	  SELECT @@TRANCOUNT
	  DELETE FROM Dados.Comissao WHERE ARQUIVO = 'PROTHEUS'
	  COMMIT
	  rollback
	  108000620
108000783
2073
1374
select * from dados.comissaosaude
begin tran
delete from dados.comissaosaude
commit
ALTER TABLE Dados.ComissaoSaude add CPFCNPJ VARCHAR(18)
SELECT * FROM DADOS.ComissaoSaude WHERE ID IN ( 108000620,108000783)
SELECT * FROM [ComissaoProtheus_TEMP] WHERE NumeroProposta IS NULL
 ***********************************************************************/  
            
;MERGE INTO Dados.ComissaoSaude AS T
	 USING (SELECT  distinct com.ID as IDComissao,cv.ID as IDCanalVendaPARSaude,ss.ID as IDSegmento,com.TipoCorretagem as TipoComissao,ctr.IDProposta,ctr2.ID as IDTESTE,t.NumeroProposta,
					t.IDSeguradora,QtApolices,Segmento,t.DataRecibo,t.ValorCorretagem,t.IDEmpresa,t.NumeroEndosso,t.NomeContrato,pc.CPFCNPJ,prp.ID
               FROM [dbo].[ComissaoProtheus_TEMP] t				
				INNER JOIN [Dados].[Comissao] com on com.DataRecibo = t.DataRecibo and com.ValorCorretagem = t.ValorCorretagem and com.IDEmpresa = t.IDEmpresa and com.NumeroEndosso = t.NumeroEndosso
				INNER JOIN [Dados].[CanalVendaPARSaude] cv on cv.Codigo = '04'+right('000'+Cast(t.IDCanalVendaPAR as varchar),3) 
				INNER JOIN [Dados].[SegmentoSaude] ss on ss.Codigo = Cast(t.Segmento as int)
				LEFT JOIN [Dados].[Proposta] prp on prp.NumeroProposta = t.NumeroProposta
				LEFT JOIN [Dados].[PropostaCliente] pc on prp.ID = pc.IDProposta
				LEFT JOIN [Dados].[PropostaSaude] ps on ps.IDProposta = prp.ID
				LEFT JOIN [Dados].[Proposta] prp2 on ps.IDPropostaOrigem = prp2.ID	
				LEFT JOIN  [Dados].[Contrato] ctr on com.IDContrato = ctr.ID 
				LEFT JOIN  [Dados].[Contrato] ctr2 on prp2.IDContrato = ctr2.ID
					--and com.ValorBase = t.ValorBase and com.ValorCorretagem = t.ValorCorretagem and com.NumeroParcela = t.NumeroParcela 
					--and com.TipoCorretagem = t.TipoCorretagem and com.DataCalculo = t.DataCalculo and com.Arquivo = 'PROTHEUS' 
					--and com.PercentualCorretagem = t.PercentualCorretagem
					WHERE t.IDSeguradora IS NOT NULL
              ) X
       ON T.IDComissao = X.IDComissao
	  
	   WHEN MATCHED
		    THEN UPDATE 
			    SET  T.[IDCanalVendaPARSaude] = COALESCE(X.[IDCanalVendaPARSaude],T.[IDCanalVendaPARSaude])
             , T.[IDSegmento] = COALESCE(X.[IDSegmento], T.[IDSegmento])
             , T.[TipoComissao] = COALESCE(X.[TipoComissao], T.[TipoComissao])
             , T.[IDSeguradora] = COALESCE(X.[IDSeguradora], T.[IDSeguradora])
             , T.[QtApolices] = COALESCE(X.[QtApolices], T.[QtApolices])
			 , T.[Segmento] = COALESCE(X.[Segmento], T.[Segmento])
			 , T.[NomeContrato] = COALESCE(X.[NomeContrato], T.[NomeContrato])
			 , T.[CPFCNPJ] = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])

       WHEN NOT MATCHED
		    THEN INSERT ([IDComissao],[IDCanalVendaPARSaude],[IDSegmento],[TipoComissao],
							[IDSeguradora],[QtApolices],[Segmento],[NomeContrato],[CPFCNPJ]
						)
		        VALUES (X.[IDComissao],X.[IDCanalVendaPARSaude],
							X.[IDSegmento],X.[TipoComissao],X.[IDSeguradora],
							X.[QtApolices],X.[Segmento],X.[NomeContrato],X.[CPFCNPJ]
					   );
--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP]
-- SELECT * FROM DADOS.Contrato





;MERGE INTO Dados.Comissao AS T
	 USING (SELECT distinct com.ID as IDComissao,cv.ID as IDCanalVendaPARSaude,ss.ID as IDSegmento,com.TipoCorretagem as TipoComissao,ctr.IDProposta,ctr2.ID as IDCliente,t.NumeroProposta,
					t.IDSeguradora,QtApolices,Segmento,t.DataRecibo,t.ValorCorretagem,t.IDEmpresa,t.NumeroEndosso,t.NomeContrato,pc.CPFCNPJ,prp.ID
               FROM [dbo].[ComissaoProtheus_TEMP] t				
				INNER JOIN [Dados].[Comissao] com on com.DataRecibo = t.DataRecibo and com.ValorCorretagem = t.ValorCorretagem and com.IDEmpresa = t.IDEmpresa and com.NumeroEndosso = t.NumeroEndosso
				INNER JOIN [Dados].[CanalVendaPARSaude] cv on cv.Codigo = '04'+right('000'+Cast(t.IDCanalVendaPAR as varchar),3) 
				INNER JOIN [Dados].[SegmentoSaude] ss on ss.Codigo = Cast(t.Segmento as int)
				LEFT JOIN [Dados].[Proposta] prp on prp.NumeroProposta = t.NumeroProposta
				LEFT JOIN [Dados].[PropostaCliente] pc on prp.ID = pc.IDProposta
				LEFT JOIN [Dados].[PropostaSaude] ps on ps.IDProposta = prp.ID
				LEFT JOIN [Dados].[Proposta] prp2 on ps.IDPropostaOrigem = prp2.ID	
				LEFT JOIN  [Dados].[Contrato] ctr on com.IDContrato = ctr.ID 
				LEFT JOIN  [Dados].[Contrato] ctr2 on prp2.IDContrato = ctr2.ID
					--and com.ValorBase = t.ValorBase and com.ValorCorretagem = t.ValorCorretagem and com.NumeroParcela = t.NumeroParcela 
					--and com.TipoCorretagem = t.TipoCorretagem and com.DataCalculo = t.DataCalculo and com.Arquivo = 'PROTHEUS' 
					--and com.PercentualCorretagem = t.PercentualCorretagem
					WHERE t.IDSeguradora IS NOT NULL
              ) X
       ON T.ID = X.IDComissao
	  
	   WHEN MATCHED
		    THEN UPDATE 
			    SET  T.[IDContrato] = COALESCE(X.IDCliente,T.[IDContrato]);









END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  






