
/*
	Autor: Pedro Guedes
	Data Criação: 20/04/2014

	Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	
ALTER TABLE Dados.Plano DROP COLUMN ID
*/

/*******************************************************************************
	Nome: Dados.proc_InsereProposta_Saude
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
		delete from  dbo.Planos_Protheus_TEMP			
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_Insere_Planos_Protheus]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Planos_Protheus_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Planos_Protheus_TEMP;


CREATE TABLE [dbo].[Planos_Protheus_TEMP](
	[ID]			 [bigint] IDENTITY(1,1) NOT NULL,
	[IDSeguradora]	 [int] NOT NULL,
	[CodigoPlano]	 [varchar] (4) NOT  NULL,
	[VersaoPlano]	 [varchar] (3) NOT NULL,
	[FormaDeCobranca]	 [int] NOT NULL,
	[NomePlano]		 [varchar] (60) NOT NULL,
	[NumANS]		 [int] NULL,
	[PlanoANS]		 [varchar] (30) NULL,
	[EMPRESA]		 [varchar] (2) NOT NULL

 CONSTRAINT [PK_PLANOS_PROTHEUS_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

ALTER TABLE [dbo].[Planos_Protheus_TEMP] ADD  CONSTRAINT [DF_Plano_Saude_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroModelagem_Proposta_Saude_TEMP ON [dbo].Planos_Protheus_TEMP
( 
  IDSeguradora ASC,CodigoPlano ASC
)       


INSERT into [dbo].[Planos_Protheus_TEMP] ( 					 
				[IDSeguradora],	
				[CodigoPlano],	
				[FormaDeCobranca],
				[VersaoPlano],	
				[NomePlano],		
				[NumANS],		
				[PlanoANS],		
				[EMPRESA]		)  exec [Dados].[proc_RecuperaPlanos_Protheus]
					
			   ----EXEC [dados].[proc_recuperaproposta_saude]
			   




 /**********************************************************************
       Carrega os Planos não conhecidos
	   DELETE FROM DADOS.PLANO
 ***********************************************************************/  
            
;MERGE INTO Dados.Plano AS T
	 USING (SELECT [IDSeguradora],	
				   [CodigoPlano],	
				   [FormaDeCobranca],
				   [VersaoPlano],	
				   [NomePlano],		
				   [NumANS],		
				   [PlanoANS],		
				   [EMPRESA]		 
               FROM [dbo].[Planos_Protheus_TEMP] t
              ) X
       ON T.[IDSeguradora] = X.IDSeguradora
			AND T.[CodigoPlano] = X.[CodigoPlano]
			AND T.[VersaoPlano] = X.[VersaoPlano]
			AND T.[Empresa] = X.[Empresa]
		WHEN MATCHED
		THEN UPDATE
					SET
						 [NomePlano] = COALESCE(X.[NomePlano], T.[NomePlano]),
						 [NumANS] = COALESCE(X.[NumANS], T.[NumANS]),
						 [PlanoANS]= COALESCE(X.[PlanoANS], T.[PlanoANS])
       WHEN NOT MATCHED
		          THEN INSERT ([IDSeguradora],
								[CodigoPlano],
								[FormaDeCobranca],
								[VersaoPlano],
								[NomePlano],		
								[NumANS],		
								[PlanoANS],		
								[EMPRESA])
		               VALUES (X.[IDSeguradora],
								X.[CodigoPlano],
								X.[FormaDeCobranca],
								X.[VersaoPlano],
								X.[NomePlano],		
								X.[NumANS],		
								X.[PlanoANS],		
								X.[EMPRESA]);
--Select * from Dados.Plano
END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  


 