



/*
	Autor: Pedro Guedes
	Data Criação: 09/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	
ALTER TABLE Dados.Plano DROP COLUMN ID
*/

/*******************************************************************************
	Nome: Dados.proc_InserePropostaSaudeComissao
	Descrição: Procedimento que realiza a inserção de tratativas comerciais na base.
		
	Parâmetros de entrada:
	
		delete from  dbo.proc_InserePropostaSaudeComissao			
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePropostaSaudeComissao]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropostaSaudeComissao_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PropostaSaudeComissao_TEMP];
	

CREATE TABLE [dbo].PropostaSaudeComissao_TEMP(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NumeroProposta] [varchar] (20) NULL,
	[TipoComissao] [char] (1) NULL,
	[PercentualComissao] [int] NULL,
	[ParcelaInicialComissao] [int] NULL,
	[ParcelaFinalComissao] [int] NULL,
	[BaseCalculoComissao] [int] NULL,
	[Operadora] [varchar] (4) NOT NULL,
	[CodigoVendedor] [int] NOT NULL,
	[NomeVendedor] [varchar] (60) NOT NULL,
	--[ValorPremioLiquido] [decimal](19, 2) NULL,
	--[QuantidadeOcorrencias] [smallint] NULL,
	--[IDSituacaoParcela] [tinyint] NULL,

	
	
 CONSTRAINT [PK_PropostaSaudeComissao_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

--ALTER TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP] ADD  CONSTRAINT [DF_PropostaSaudeFamiliaEVida_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_PropostaSaudeComissao_TEMP ON [dbo].[PropostaSaudeComissao_TEMP]
( 
  NumeroProposta ASC
)       

INSERT into [dbo].PropostaSaudeComissao_TEMP (
											[NumeroProposta],
											[TipoComissao],
											[ParcelaInicialComissao],
											[PercentualComissao],
											[ParcelaFinalComissao],
											[BaseCalculoComissao],
											[Operadora],
											[CodigoVendedor],
											[NomeVendedor]
															
				)  exec [Dados].[proc_RecuperaPropostaSaudeComissao]
					
			   ----SELECT * FROM [PagamentosProtheus_TEMP]


			   
/**********************************************************************
       Faz o merge na tabela Dados.Produtor - Corretoras
	  SELECT * FROM DADOS.ProdutorSaude where Codigo =  7
	  SELECT * FROM PropostaSaudeComissao_TEMP
 ***********************************************************************/  
            
;MERGE INTO Dados.ProdutorSaude AS T
	 USING (SELECT DISTINCT CodigoVendedor  as Codigo, [NomeVendedor] as Nome
			FROM [dbo].[PropostaSaudeComissao_TEMP] t	
			where CodigoVendedor not in (7,86)		    
              ) X
       ON  X.Codigo = T.Codigo --and X.Nome = T.Nome
       WHEN NOT MATCHED
		          THEN INSERT (Codigo,Nome)
		               VALUES (X.Codigo, X.Nome);


/**********************************************************************
       Faz o merge na tabela Dados.PropostaSaudeComissao - tratativas comerciais (percentuais de comissão)
	select * fROM DADOS.PropostaSaudeComissao
	delete fROM DADOS.PropostaSaudeComissao
	  SELECT * FROM PropostaSaudeComissao_TEMP
 ***********************************************************************/  
            
;MERGE INTO Dados.PropostaSaudeComissao AS T
	 USING (SELECT  ps.ID as IDPropostaSaude,t.TipoComissao,t.PercentualComissao,
				t.ParcelaInicialcomissao,t.ParcelaFinalComissao,t.BaseCalculoComissao,t.CodigoVendedor,pr.ID as IDProdutor
			FROM [dbo].[PropostaSaudeComissao_TEMP] t	
			    left join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora = Case when Cast(Operadora as Int) = 1 then 18
																	else Cast(t.Operadora as Int) End  
				left join [Dados].[PropostaSaude] ps on ps.IDProposta =  p.ID
				inner join [Dados].[ProdutorSaude] pr on t.CodigoVendedor = pr.Codigo and t.NomeVendedor = pr.Nome
				where ps.ID IS NOT NULL
              ) X
       ON  X.IDPropostaSaude = T.IDPropostaSaude and T.IDProdutor = X.IDProdutor 
				and T.TipoComissao = X.TipoComissao and T.ParcelaInicialComissao = X.ParcelaInicialComissao
				and T.ParcelaFinalComissao = X.ParcelaFinalComissao and T.PercentualComissao = X.PercentualComissao
				and T.BaseCalculoComissao = X.BaseCalculoComissao
       WHEN NOT MATCHED
		          THEN INSERT (IDPropostaSaude,TipoComissao,PercentualComissao,
								ParcelaInicialComissao,ParcelaFinalComissao,BaseCalculoComissao,IDProdutor
								)
		               VALUES (X.IDPropostaSaude, X.TipoComissao,X.PercentualComissao,
							X.ParcelaInicialComissao,X.ParcelaFinalComissao,X.BaseCalculoComissao,X.IDProdutor
					   );
--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP]
-- SELECT * FROM DADOS.TIPOKIT




END TRY
BEGIN CATCH
    EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  

























--exec Dados.proc_InsereAcordo_SSD

--SELECT * FROM ControleDAdos.PontoParada where ID = 78