



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
CREATE PROCEDURE [Dados].[proc_InserePropostaSaudeFamiliaEVida]
AS

BEGIN TRY	
    
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropostaSaudeFamiliaEVida_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP];

--IDSeguradora|NumeroProposta|NumeroPropostaEMISSAO|SubGrupo|CodigoRamoPAR|CodigoPlano|VersaoPlano|VALFAI|IDAINI|IDAFIN|TIPOTABVIDAS|TIPOADESAO|ESTADO|COPARTICIPACAO
create TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP](
	[ID]					 [int] IDENTITY(1,1) NOT NULL,
	[FilialProtheus]		 [varchar] (2) NOT NULL,
	[OperadoraProposta]	     [varchar] (4)  NOT NULL,
	[GrupoEmpresa]			 [varchar] (4) NOT  NULL,
	[NumeroContrato]		 [varchar] (12) NOT  NULL,
	[VersaoContrato]		 [varchar] (3) NOT  NULL,	
	[SubContrato]			 [varchar] (9) NOT  NULL,
	[VersaoSubContrato]		 [varchar] (3) NOT  NULL,
	[PropostaProtheus]		 [varchar] (12) NOT  NULL,
	[OperadoraVida]			 [varchar] (4)	NOT NULL,
	[GrupoEmpresaVida]		 [varchar] (4)	NOT NULL,
	[Matricula] 			 [varchar] (6) NOT NULL,
	[ContratoVida]			 [varchar] (12) NOT NULL,
	[NomeSegurado]			 [varchar] (70) NOT NULL,
	[Empresa]				 [varchar] (2) NOT NULL,
	[Carteirinha]			 [varchar] (25) NULL,
	[NumeroProposta]		 [varchar]	(25) NOT NULL,
	[GrauParentesco]		 [varchar]	(2)  NOT NULL,
	[CPF]				     [varchar]	(14) NOT NULL,
	[EstadoCivil]			 [varchar] (2) NOT NULL,
	[NomeMae]				 [varchar] (120) NOT NULL,
	[TipoUsuario]			 [varchar] (1) NOT NULL,
	[GrupoCarencia]	 		 [varchar] (3)  NULL,
	[SubContratoVida]		 [varchar] (9)	NOT NULL,
	[VersaoSubContratoVida]	 [varchar] (3) NOT NULL,
	[VersaoContratoVida]	 [varchar] (3) NOT NULL,
	[FilialVida]			 [varchar] (2) NOT NULL,
	[PropostaFamilia]	     [varchar] (30) NOT NULL,
	[TipoKit]				 [varchar] (16) NULL,
	[DescKit]				 [varchar] (65) NULL,
	[TipoVida]				 [varchar] (40) NULL,
	[CodigoPlano]			 [varchar] (4)	NOT NULL,
	[VersaoPlano]			 [varchar] (3) NOT NULL,
	[DescGrauParentesco]     [varchar] (30) NOT NULL,
	[DataVigencia]			 [date]   NOT NULL,
	[DataFimVigencia]		 [date]    NULL,
	[CodigoMotivoCancelamento] [varchar] (3)   NULL,
	[DescricaoMotivoCancelamento] [varchar] (60)   NULL,
	[TipoBloqueio]			[varchar] (21) NULL,
	[TipoRegistro]			[varchar] (2) NOT NULL,
	[Digito]			[varchar] (1) NOT NULL,
	
 CONSTRAINT [PK_PropostaSaudeFamiliaEVida_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

--ALTER TABLE [dbo].[PropostaSaudeFamiliaEVida_TEMP] ADD  CONSTRAINT [DF_PropostaSaudeFamiliaEVida_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroModelagem_PlanoFaixaEtaria_TEMP ON [dbo].[PropostaSaudeFamiliaEVida_TEMP]
( 
  OperadoraProposta ASC,NumeroProposta ASC,Matricula ASC
)       


CREATE NONCLUSTERED INDEX [IDX_PropostaSaudeFamilia]
ON [dbo].[PropostaSaudeFamiliaEVida_TEMP] ([NumeroProposta])
INCLUDE ([OperadoraProposta],[Matricula],[Empresa],[CodigoPlano],[VersaoPlano],[CPF],[NomeSegurado],[TipoUsuario],[TipoRegistro],[Digito],[DataFimVigencia])

CREATE NONCLUSTERED INDEX [IDX_Plano]
ON [dbo].[PropostaSaudeFamiliaEVida_TEMP] ([CodigoPlano],[VersaoPlano],[Empresa])
INCLUDE(Carteirinha,CPF,GrupoCarencia,DataVigencia,EstadoCivil,NomeMae,DataFimVigencia,NomeSegurado,TipoRegistro,Digito)

CREATE NONCLUSTERED INDEX [IDX_Kit]
ON [dbo].[PropostaSaudeFamiliaEVida_TEMP] ([TipoKit],[DescKit])
INCLUDE(Carteirinha,CPF,GrupoCarencia,DataVigencia,EstadoCivil,NomeMae,DataFimVigencia,NomeSegurado,TipoRegistro,Digito)

CREATE NONCLUSTERED INDEX [IDX_Carteirinha]
ON [dbo].[PropostaSaudeFamiliaEVida_TEMP] ([Carteirinha],[NomeSegurado])
INCLUDE(CPF,GrupoCarencia,DataVigencia,EstadoCivil,NomeMae,DataFimVigencia,TipoRegistro,Digito)

INSERT into [dbo].[PropostaSaudeFamiliaEVida_TEMP] ( [FilialProtheus],							 
													 [OperadoraProposta],
													 [GrupoEmpresa],		
													 [NumeroContrato],		
													 [VersaoContrato],		
													 [SubContrato],			
													 [VersaoSubContrato],		
													 [PropostaProtheus],		
													 [OperadoraVida],
													 [GrupoEmpresaVida],			
													 [Matricula],			
													 [ContratoVida],			
													 [NomeSegurado],			
													 [Empresa],				
													 [Carteirinha],			
													 [NumeroProposta],	
													 [GrauParentesco],		
													 [CPF],				   
													 [EstadoCivil],			
													 [NomeMae],			
													 [TipoUsuario],			
													 [GrupoCarencia],	 		
													 [SubContratoVida],		
													 [VersaoSubContratoVida],
													 [VersaoContratoVida],	
													 [FilialVida],
													 [PropostaFamilia],
													 [TipoKit],
													 [DescKit],
													 [Tipovida],
													 [CodigoPlano],
													 [VersaoPlano],
													 [DescGrauParentesco],
													 [DataVigencia]	,
													 [DataFimVigencia],
													 [CodigoMotivoCancelamento],
													 [DescricaoMotivoCancelamento], 
													 [TipoBloqueio],
													 [TipoRegistro],
													 [Digito]
				
				)  exec [Dados].[proc_RecuperaPropostaSaudeFamiliaEVida]
					
			   ----EXEC [dados].[proc_recuperaproposta_saude]
			   
print 'TempTable - ok'

/**********************************************************************
       Carrega as Tabelas de Tipos de KIT não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.TipoKit AS T
	 USING (SELECT DISTINCT TipoKit,DescKit
               FROM [dbo].[PropostaSaudeFamiliaEVida_TEMP] t	
			   where t.DescKit IS NOT NULL		   
              ) X
       ON T.Descricao = X.DescKit and T.CodigoKIT = X.TipoKit
       WHEN NOT MATCHED
		          THEN INSERT (CodigoKIT, Descricao)
		               VALUES (X.TipoKit, X.DescKit);
--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP] WHERE NomeSegurado like 'NATANAEL NEL%'
-- SELECT * FROM DADOS.TIPOKIT

print 'tipokit - ok'

/**********************************************************************
       Carrega as Tabelas de Tipos de VIDA não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.TipoVida AS T
	 USING (SELECT DISTINCT TipoUsuario,TipoVida
               FROM [dbo].[PropostaSaudeFamiliaEVida_TEMP] t
              ) X
       ON T.Codigo = X.TipoUsuario and T.Descricao = X.TipoVida
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, Descricao)
		               VALUES (X.TipoUsuario, X.TipoVida);
--Select * from dados.[TipoVida]
print 'tipovida - ok'
/**********************************************************************
       Carrega as Tabelas de Tipos de GRAU DE PARENTESCO não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.GrauParentesco AS T
	 USING (SELECT DISTINCT DescGrauParentesco,GrauParentesco
               FROM [dbo].[PropostaSaudeFamiliaEVida_TEMP] t
              ) X
       ON T.Codigo = X.GrauParentesco and T.Descricao = X.DescGrauParentesco
       WHEN NOT MATCHED
		          THEN INSERT (Codigo, Descricao)
		               VALUES (X.GrauParentesco, X.DescGrauParentesco);
--Select * from dbo.[PropostaSaudeFamiliaEVida_TEMP] with (nolock

print 'GrauPar - ok'

 /**********************************************************************
       Carrega os Famílias não conhecidas
	   select * from PropostaSaudeFamiliaEVida_TEMP where EstadoCivil = '*'
	   select *  FROM Dados.Proposta p
	   inner join Dados.PropostaSaude ps on ps.IDProposta = p.ID
	   	    where NumeroProposta = '031000000000275001'

			SELECT * FROM DADOS.PLANO where CodigoPlano = '0006' and Empresa = '03'
 ***********************************************************************/  

delete from Dados.PropostaSaudeVida       
delete from Dados.PropostaSaudeFamilia
            
;MERGE INTO Dados.PropostaSaudeFamilia AS T
	 USING (SELECT DISTINCT  ps.ID as IDPropostaSaude,
				Matricula,pl.ID as IDPlano
				from [dbo].[PropostaSaudeFamiliaEVida_TEMP] t
				inner join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora = OperadoraProposta
				inner join [Dados].[PropostaSaude] ps on ps.IDProposta =  p.ID						
				inner join [Dados].[Plano] pl on pl.CodigoPlano =  t.CodigoPlano and pl.IDSeguradora = p.IDSeguradora and pl.VersaoPlano = t.VersaoPlano and pl.Empresa = t.Empresa
				--DELETE  from dados.PropostaSaudeFamilia
				--select * from dbo.[PropostaSaudeFamiliaEVida_TEMP]
				
              ) X
       ON T.[IDPropostaSaude] = X.IDPropostaSaude --and T.[IDSeguradora] = X.IDSeguradora
		
		--WHEN MATCHED
		--THEN UPDATE
		--			SET
		--				 [MatriculaFamiliaProtheus] = COALESCE(X.[Matricula], T.[MatriculaFamiliaProtheus]),
		--				 [IDPlano]= COALESCE(X.[IDPlano], T.[IDPlano])
       WHEN NOT MATCHED
		          THEN INSERT (
				  
				   [IDPropostaSaude] ,
				   [MatriculaFamiliaProtheus],
				   [IDPlano]
				  
				  
				  )
		               VALUES (X.[IDPropostaSaude],
								X.[Matricula],
								X.[IDPlano]);



print 'Familia - ok'


								
 /**********************************************************************
       Carrega as Vidas não conhecidas
	   SELECT * FROM Dados.PropostaSaudeVida
	   SELECT * FROM 
	   Dados.PropostaSaudeFamilia pf
	   inner join Dados.PropostaSaude ps on ps.ID = pf.IDPropostaSaude
	   inner join Dados.Proposta p on p.ID = ps.IDProposta
	   inner join Dados.PropostaSaudeVida pv on pv.IDPropostaSaudeFamilia = pf.ID
	   where pf.ID = 33250
	   delete from Dados.PropostaSaudeFamilia

	    
 ***********************************************************************/  
 
		    
;with teste as (SELECT DISTINCT pf.ID as IDPropostaSaudeFamilia,
						ps.ID as IDPropostaSaude,
					
					t.Carteirinha,t.CPF,GrupoCarencia as IDGrupoCarencia,
					t.DataVigencia, t.EstadoCivil,t.NomeMae, 
					t.DataFimVigencia,t.NomeSegurado,t.TipoRegistro,t.Digito,t.CodigoPlano as CodigoPlano1,p.IDseguradora as IDSeguradora1,t.VersaoPlano as VersaoPlano1,t.Empresa as Empresa1,
					t.GrauParentesco,t.TipoUsuario,t.DescKit,t.TipoKit,pf.ID as IDPropostaFamilia
						 
				from [dbo].[PropostaSaudeFamiliaEVida_TEMP] t
				inner join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora =OperadoraProposta
				inner join [Dados].[PropostaSaude] ps on ps.IDProposta =  p.ID
				inner join [Dados].[PropostaSaudeFamilia] pf on pf.IDPropostaSaude =  ps.ID and pf.MatriculaFamiliaProtheus = t.Matricula )
				,
				teste2 as (
				select t.IDPropostaSaudeFamilia,t.IDPropostaSaude,t.Carteirinha,t.CPF,t.IDGrupoCarencia,
				gp.ID as IDParentesco,tv.ID as IDTipoVida,tk.ID as IDTipoKit,v.ID as IDVida ,
				t.DataVigencia, t.EstadoCivil,t.NomeMae, 
					t.DataFimVigencia,t.NomeSegurado,t.TipoRegistro,t.Digito,pl.CodigoPlano,IDSeguradora
				
				from teste t
				inner join [Dados].[Plano] pl on pl.CodigoPlano =  t.CodigoPlano1 and pl.IDSeguradora = t.IDSeguradora1 and pl.VersaoPlano = t.VersaoPlano1 and pl.Empresa = t.Empresa1
				inner join [Dados].[GrauParentesco] gp on t.GrauParentesco = gp.Codigo
				inner join [Dados].[TipoVida] tv on tv.Codigo = t.TipoUsuario
				left join [Dados].[TipoKit] tk on tk.Descricao = t.DescKit and tk.CodigoKit = t.TipoKit
				left join [Dados].[PropostaSaudeVida] v on v.IDPropostaSaudeFamilia = t.IDPropostaFamilia and v.NomeSegurado = t.NomeSegurado and v.NumeroCarteirinha = t.Carteirinha )
				
				--select * from dados.EstadoCivil
				--select * from dados.PropostaSaudeFamilia
				--select * from dbo.[PropostaSaudeFamiliaEVida_TEMP] where numeroproposta like '%000000000003%'
				--select * from dados.TipoKit order by codigokit delete from dados.tipokit where descricao ='Nao se Aplica'
MERGE INTO Dados.PropostaSaudeVida AS T
	 USING (/*SELECT  DISTINCT pf.ID as IDPropostaSaudeFamilia,
						ps.ID as IDPropostaSaude,
					gp.ID as IDParentesco,tv.ID as IDTipoVida,
					t.Carteirinha,t.CPF,GrupoCarencia as IDGrupoCarencia,
					t.DataVigencia, t.EstadoCivil,t.NomeMae, tk.ID as IDTipoKit,
					t.DataFimVigencia,t.NomeSegurado,v.ID as IDVida,t.TipoRegistro,t.Digito
						 
				from [dbo].[PropostaSaudeFamiliaEVida_TEMP] t
				inner join [Dados].[Proposta] p on p.NumeroProposta =  t.NumeroProposta and p.IDSeguradora =OperadoraProposta
				inner join [Dados].[PropostaSaude] ps on ps.IDProposta =  p.ID
				inner join [Dados].[PropostaSaudeFamilia] pf on pf.IDPropostaSaude =  ps.ID and pf.MatriculaFamiliaProtheus = t.Matricula 
				inner join [Dados].[Plano] pl on pl.CodigoPlano =  t.CodigoPlano and pl.IDSeguradora = p.IDSeguradora and pl.VersaoPlano = t.VersaoPlano and pl.Empresa = t.Empresa
				inner join [Dados].[GrauParentesco] gp on t.GrauParentesco = gp.Codigo
				inner join [Dados].[TipoVida] tv on tv.Codigo = t.TipoUsuario
				left join [Dados].[TipoKit] tk on tk.Descricao = t.DescKit and tk.CodigoKit = t.TipoKit
				left join [Dados].[PropostaSaudeVida] v on v.IDPropostaSaudeFamilia = pf.ID and v.NomeSegurado = t.NomeSegurado and v.NumeroCarteirinha = t.Carteirinha 
				--where t.NomeSegurado like 'ANA CLAUDIA OLIVEIRA FERREIRA%' */    
			
			select * from teste2
				
              ) X 
       ON T.[IDPropostaSaudeFamilia] = X.IDPropostaSaudeFamilia and T.[IDTipoVida] = X.[IDTipoVida] --and T.[NumeroCarteirinha] = X.[Carteirinha] 
	 --  and T.[IDParentesco] = X.[IDParentesco] and T.DataFimVigencia = X.DataFimVigencia and X.CPF = T.CPF and T.TipoRegistro = X.TipoRegistro and T.Digito = X.Digito
	   and T.ID = X.IDVida

		
		WHEN MATCHED
		THEN UPDATE
					SET
						 [IDPropostaSaudeFamilia] = COALESCE(X.[IDPropostaSaudeFamilia], T.[IDPropostaSaudeFamilia]),
						 [IDParentesco] = COALESCE(X.[IDParentesco], T.[IDParentesco]),
						 [IDTipoVida]= COALESCE(X.[IDTipoVida], T.[IDTipoVida]),
						 [NumeroCarteirinha] = COALESCE(X.[Carteirinha], T.[NumeroCarteirinha]),
						 [CPF]= COALESCE(X.[CPF], T.[CPF]),
						 [IDGrupoCarencia]= COALESCE(X.[IDGrupoCarencia], T.[IDGrupoCarencia]),
						 [DataVigencia]= COALESCE(X.[DataVigencia], T.[DataVigencia]),
						 [EstadoCivil]= COALESCE(X.[EstadoCivil], T.[EstadoCivil]),
						 [NomeDaMae]= COALESCE(X.[NomeMae], T.[NomeDaMae]),
						 [IDTipoKit]= COALESCE(X.[IDTipoKit], T.[IDTipoKit]),
						 [DataFimVigencia]= COALESCE(X.[DataFimVigencia], T.[DataFimVigencia]),
						 [NomeSegurado]= COALESCE(X.[NomeSegurado], T.[NomeSegurado])
       WHEN NOT MATCHED
		          THEN INSERT ([IDPropostaSaudeFamilia], 
							   [IDParentesco], 
							   [IDTipoVida],
							   [NumeroCarteirinha],
							   [CPF],
							   [IDGrupoCarencia],
							   [DataVigencia],
							   [EstadoCivil],
							   [NomeDaMae],
							   [IDTipoKit],
							   [DataFimVigencia],
							   [NomeSegurado],
							   [TipoRegistro],
							   [Digito]				  
				  
				  )
		               VALUES (X.[IDPropostaSaudeFamilia],
								X.[IDParentesco],
								X.[IDTipoVida],
								X.[Carteirinha],
								X.[CPF],
								X.[IDGrupoCarencia],
								X.[DataVigencia],
								X.[EstadoCivil],
								X.[NomeMae],
								X.[IDTipoKit],
								X.[DataFimVigencia],
								X.[NomeSegurado],
								X.[TipoRegistro],
								X.[Digito]);
print 'Vida - ok'

--Select * from DADOS.[PropostaSaudeVida] group by 
--Select NumeroCarteirinha,* from dados.[PropostaSaudeVida]  where NumeroCarteirinha = '250630000001007'          
--DROP TABLE [dbo].[Planos_Protheus_TEMP]
END TRY
BEGIN CATCH
	 SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH  

--select count(1) from Dados.PropostaSaudeFamilia









