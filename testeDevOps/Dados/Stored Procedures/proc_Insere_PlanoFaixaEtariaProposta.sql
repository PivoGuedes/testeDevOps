
/*
	Autor: Pedro Guedes
	Data Criação: 09/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	
ALTER TABLE Dados.Plano DROP COLUMN ID
*/

/*******************************************************************************
	Nome: Dados.proc_InsereProposta_Saude
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
		delete from  dbo.proc_Insere_PlanoFaixaEtariaProposta			
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_Insere_PlanoFaixaEtariaProposta]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlanoFaixaEtariaProposta_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PlanoFaixaEtariaProposta_TEMP];

--IDSeguradora|NumeroProposta|NumeroPropostaEMISSAO|SubGrupo|CodigoRamoPAR|CodigoPlano|VersaoPlano|VALFAI|IDAINI|IDAFIN|TIPOTABVIDAS|TIPOADESAO|ESTADO|COPARTICIPACAO
CREATE TABLE [dbo].[PlanoFaixaEtariaProposta_TEMP](
	[ID]					 [int] IDENTITY(1,1) NOT NULL,
	[IDSeguradora]			 [int] NOT NULL,
	[NumeroProposta]		 [varchar] (20) NOT  NULL,
	[NumeroPropostaEMISSAO]	 [varchar] (20) NOT NULL,
	[SubGrupo]				 [int] NULL,
	[CodigoRamoPAR]			 [varchar] (2) NOT NULL,
	[CodigoPlano]			 [varchar] (4) NOT NULL,
	[VersaoPlano]			 [varchar] (3) NOT NULL,
	[VALFAI]				 [float]	 NOT NULL,
	[IDAINI]				 [int]		 NOT NULL,
	[IDAFIN]				 [int]		 NOT NULL,
	[TIPOTABVIDAS]			 [varchar] (2) NOT NULL,
	[TIPOADESAO]			 [varchar] (1) NOT NULL,
	[ESTADO]				 [varchar] (2) NOT NULL,
	[COPARTICIPACAO]		 [varchar] (1) NOT NULL,
	[DescriTabVidas]		 [varchar] (30) NULL,
	[EMPRESA]				 [varchar] (2) NOT NULL
	
 CONSTRAINT [PK_PlanoFaixaEtaria_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

ALTER TABLE [dbo].[PlanoFaixaEtariaProposta_TEMP] ADD  CONSTRAINT [DF_PlanoFaixaEtaria_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroModelagem_PlanoFaixaEtaria_TEMP ON [dbo].[PlanoFaixaEtariaProposta_TEMP]
( 
  IDSeguradora ASC,NumeroProposta ASC,IDAINI ASC
)       


INSERT into [dbo].[PlanoFaixaEtariaProposta_TEMP] ( 					 
				
				[IDSeguradora],			
				[NumeroProposta],		
				[NumeroPropostaEMISSAO],	
				[SubGrupo],				
				[CodigoRamoPAR],			
				[CodigoPlano],			
				[VersaoPlano],			
				[VALFAI],				
				[IDAINI],				
				[IDAFIN],				
				[TIPOTABVIDAS],			
				[TIPOADESAO],			
				[ESTADO],				
				[COPARTICIPACAO],
				[DescriTabVidas],
				[EMPRESA]			
				
				
				)  exec [Dados].[proc_RecuperaPlanoFaixaEtariaProposta]
					
			   ----EXEC [dados].[proc_recuperaproposta_saude]
			   


/**********************************************************************
       Carrega as Tabelas de Vidas não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.TabelaQtdVidas AS T
	 USING (SELECT DISTINCT t.[DescriTabVidas] as DescriTabVidas, t.[EMPRESA] as [EmpresaProtheus], t.[TipoTabVidas] as [CodigoProtheus]
               FROM [dbo].[PlanoFaixaEtariaProposta_TEMP] t
              ) X
       ON T.CodigoProtheus = X.CodigoProtheus and T.EmpresaProtheus = X.EmpresaProtheus
       WHEN NOT MATCHED
		          THEN INSERT (Descricao, EmpresaProtheus,CodigoProtheus)
		               VALUES (DescriTabVidas, X.EmpresaProtheus,X.[CodigoProtheus]);
--Select * from Dados.Seguradora

 /**********************************************************************
       Carrega os Planos não conhecidos
 ***********************************************************************/  
            
;MERGE INTO Dados.PlanoFaixaEtariaProposta AS T
	 USING (SELECT 	 q.[ID] as IDTabelaQtdVidas,
					 Case when t.[TIPOADESAO] = 'C' then 1
							when t.[TIPOADESAO] = 'V' then 2
							else 3 end as IDAdesao,
					t.[ESTADO] as UF,
					t.[COPARTICIPACAO] as Coparticipacao,
					t.[IDAINI] as IdadeDe,
					t.[IDAFIN] as IdadeAte,
					t.[VALFAI] as Premio,
					 null as [Validade],
					pl.[ID] as IDPlano,
					p.[ID] as IDProposta,
					t.[EMPRESA] as Empresa,
					t.[IDSeguradora]
				FROM [dbo].[PlanoFaixaEtariaProposta_TEMP] t
			   inner join [Dados].[Proposta] p on t.NumeroProposta = p.NumeroProposta 
						and t.IDSeguradora = p.IDSeguradora and t.SubGrupo = p.SubGrupo
				inner join [Dados].[TabelaQtdVidas] q on t.EMPRESA = q.EmpresaProtheus and t.TIPOTABVIDAS = q.CodigoProtheus
				inner join [Dados].[Plano] pl on pl.CodigoPlano = t.CodigoPlano and pl.VersaoPlano = t.VersaoPlano 
						and pl.Empresa = t.EMPRESA and pl.IDSeguradora = t.IDSeguradora

				--select * from dados.TabelaQtdVidas
				--select * from dbo.[PlanoFaixaEtariaProposta_TEMP]
				
              ) X
       ON T.[IDProposta] = X.IDProposta and T.[IDSeguradora] = X.IDSeguradora
		
		--WHEN MATCHED
		--THEN UPDATE
		--			SET
		--				 [NomePlano] = COALESCE(X.[NomePlano], T.[NomePlano]),
		--				 [NumANS] = COALESCE(X.[NumANS], T.[NumANS]),
		--				 [PlanoANS]= COALESCE(X.[PlanoANS], T.[PlanoANS])
       WHEN NOT MATCHED
		          THEN INSERT (
				  
				  [IDTabelaQtdVidas],
				  [IDAdesao],
				  [UF],
				  [Copart],
				  [IdadeDe],
				  [IdadeAte],
				  [Premio],
				  [Validade],
				  [IDPlano],
				  [IDProposta],
				  [Empresa],
				  [IDSeguradora]
				  
				  
				  
				  
				  
				  
				  
				  )
		               VALUES (X.[IDTabelaQtdVidas],
								X.[IDAdesao],
								X.[UF],
								X.[Coparticipacao],
								X.[IdadeDe],
								X.[IdadeAte],
								X.[Premio],
								X.[Validade],
							   X.[IDPlano],
							   X.[IDProposta],
							   X.[Empresa],
							   X.[IDSeguradora]);


--Select * from Dados.Plano
--DROP TABLE [dbo].[Planos_Protheus_TEMP]
END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  




