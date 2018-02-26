
/*
	Autor: Pedro Guedes
	Data Criação: 20/04/2014

		Descrição: Proc que insere propostas saúde extraídas da base do Protheus.
	

*/

/*******************************************************************************
	Nome: Dados.proc_InsereProposta_Saude
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].proc_InserePropostaPlano
AS

BEGIN TRY	
    

--BEGIN TRAN

--DECLARE @PontoDeParada AS VARCHAR(400)
----set @PontoDeParada = 4188
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
----DECLARE @COMANDO AS NVARCHAR(max) 

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropostaPlano_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PropostaPlano_TEMP];


CREATE TABLE [dbo].[PropostaPlano_TEMP](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodigoPlano] [varchar] (4) NOT NULL,
	[VersaoPlano] [varchar] (3) NOT NULL,
	[NumeroProposta] [varchar] (20) NOT NULL,
	[IDSeguradora] [int] NOT NULL,
	[SubGrupo] [int] NOT NULL,
	[Empresa] [varchar] (2) NOT NULL
	
 CONSTRAINT [PK_PROPOSTAPLANO_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) 
) 

ALTER TABLE [dbo].[PropostaPlano_TEMP] ADD  CONSTRAINT [DF_PropostaPlano_IDSeguradora]  DEFAULT ((18)) FOR [IDSeguradora]



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_NumeroPropostaPlano_TEMP ON [dbo].PropostaPlano_TEMP
( 
  NumeroProposta ASC
)       





/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)= '0'
--DECLARE @MaiorCodigo AS bigint
--SET @COMANDO = '
--truncate  table [dbo].[Proposta_Saude_TEMP]
--DELETE FROM Dados.Proposta
--DELETE FROM Dados.PropostaEndereco
--DELETE FROM Dados.Proposta
--DELETE FROM Dados.Proposta


INSERT into [dbo].[PropostaPlano_TEMP] ( 
				[IDSeguradora],
				[NumeroProposta],
				[SubGrupo],
				[CodigoPlano],
				[VersaoPlano],
				[Empresa]
				
				)  exec [Dados].proc_RecuperaPropostaPlano
					
			   ----EXEC [dados].[proc_recuperaproposta_saude]
			   



/*********************************************************************************************************************/
  
--print @comando
--EXEC (@COMANDO)     
--SET @ParmDefinition = N'@MaiorCodigo BIGINT OUTPUT';     

--SET @COMANDO = 'SELECT @MaiorCodigo= MAX(PRP.Codigo)
--                FROM OPENQUERY ([OBERON], 
--                ''EXEC [EVendasCSVE].[Corporativo].[proc_RecuperaProposta_MaquinaVendas] ''''' + @PontoDeParada + ''''''') PRP'

--exec sp_executesql @COMANDO
--                  ,@ParmDefinition
--                  ,@MaiorCodigo = @MaiorCodigo OUTPUT

/*********************************************************************************************************************/
                  
--SET @COMANDO = ''    

--WHILE @MaiorCodigo IS NOT NULL
--BEGIN
--


 /**********************************************************************
       Carrega as Seguradoras não conhecidas
 ***********************************************************************/  
            
;MERGE INTO Dados.PropostaPlano AS T
	 USING (SELECT   t.IDSeguradora,t.NumeroProposta,t.CodigoPlano,t.VersaoPlano,pl.ID,prp.ID as IDProposta
               FROM [dbo].[PropostaPlano_TEMP] t
			   INNER JOIN Dados.Plano  pl on 
					pl.CodigoPlano =  t.CodigoPlano
					AND pl.VersaoPlano = t.VersaoPlano
					AND pl.IDSeguradora = t.IDSeguradora
					AND pl.Empresa = t.Empresa
				inner JOIN Dados.Proposta prp on
					prp.NumeroProposta = t.NumeroProposta
					AND prp.IDSeguradora = t.IDSeguradora
					AND left(prp.NumeroProposta,2) = t.Empresa
              ) X
       ON T.[IDPlano] = X.ID
		AND T.[IDProposta] = X.IDProposta

		WHEN MATCHED
		          THEN UPDATE 
		               SET t.IDPlano = Coalesce(X.ID,t.IDPlano),
							t.IDProposta = Coalesce(X.IDProposta,t.IDProposta)
							
       WHEN NOT MATCHED
		          THEN INSERT (IDPlano, IDProposta)
		               VALUES (X.ID, X.IDProposta);
	  
--Select * from Dados.PropostaPlano


END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  


    /*Limpa os meios de pagamento repetidos*/
	/*Diego - Data: 17/12/2013 */
/*		
	DELETE  Dados.MeioPagamento
	FROM  Dados.MeioPagamento b
	INNER JOIN
	(
		SELECT PGTO.*, row_number() over (PARTITION BY PGTO.IDProposta, PGTO.Banco, PGTO.Agencia, PGTO.Operacao, PGTO.ContaCorrente, PGTO.DiaVencimento ORDER BY PGTO.IDProposta, PGTO.DataArquivo DESC) ordem  
		FROM Dados.MeioPagamento PGTO
			INNER JOIN
			dbo.[Proposta_Saude_TEMP] PRP
			INNER JOIN Dados.Proposta P
			ON P.NumeroProposta = PRP.[NumeroProposta]
			--AND P.IDSeguradora = 1 
			ON PGTO.IDProposta = P.ID	 
	) A
	ON   A.IDProposta = B.IDProposta
	AND A.DataArquivo = B.DataArquivo
	AND A.ordem > 1	 	
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Diego - Data: 17/12/2013 */	
	
    UPDATE Dados.MeioPagamento SET LastValue = 1
    FROM Dados.MeioPagamento MP
	CROSS APPLY(
				SELECT TOP 1 *
				FROM Dados.MeioPagamento MP1
				WHERE 
				  MP.IDProposta = MP1.IDProposta
				ORDER BY MP1.IDProposta DESC, MP1.DataArquivo DESC
			   ) A
	 WHERE MP.IDProposta = A.IDProposta 	
 	   AND MP.DataArquivo = A.DataArquivo 
	   AND EXISTS (SELECT  PRP.ID [IDProposta]
					FROM dbo.[Proposta_Saude_TEMP] PRP_T
						INNER JOIN Dados.Proposta PRP
						ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
					--	AND PRP.IDSeguradora = 1
						AND MP.IDProposta = PRP.ID
				  )
                 




----ROLLBACK TRAN

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proposta_Saude_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Proposta_Saude_TEMP;

                
BEGIN CATCH
	
--EXEC CleansingKit.dbo.proc_RethrowError	
--	RETURN @@ERROR	
END CATCH     


----EXEC [Dados].[proc_InsereProposta_MaquinaVendas] 


--/*

--		SELECT @@TRANCOUNT



--		SELECT *
--  FROM [Corporativo].[dbo].[Proposta_Saude_TEMP] A
--  INNER JOIN DADOS.Proposta PRP 
--  ON PRP.NumeroProposta = A.NumeroProposta



--  SELECT prp.id, a.*
--  FROM [Corporativo].[dbo].[Proposta_Saude_TEMP] A
--  INNER JOIN DADOS.Proposta PRP 
--  ON PRP.NumeroProposta = A.NumeroProposta
--    inner join dados.propostacliente pc 
--  on prp.id = pc.idproposta
--  and idproposta = 10084193
  

--  select *
--  from dados.propostacliente
--  where idproposta = 10084193

--		SELECT *
--  FROM [Corporativo].[dbo].[Proposta_Saude_TEMP] A
--  INNER JOIN DADOS.Proposta PRP 
--  ON PRP.NumeroProposta = A.NumeroProposta


--		SELECT *
--  FROM [dbo].[Proposta_Saude_TEMP] A
--  INNER JOIN DADOS.Proposta PRP 
--  ON PRP.NumeroProposta = A.NumeroProposta


--		SELECT *
--  FROM [Corporativo].[dbo].[Proposta_Saude_TEMP] A
--  INNER JOIN DADOS.Proposta PRP 
--  ON PRP.NumeroProposta = A.NumeroProposta


--  select *
--  from dados.meiopagamento
----  where idproposta = 10084193*/
----USE qlikview
---- SELECT [IDProdutoSIGPF],[IDContrato],* FROM  Dados.Proposta*/
--use qlikview
--SELECT * FROM Dados.Plano
--SELECT * FROM Dados.Proposta
--SELECT DISTINCT IDSEGURADORA FROM Dados.Proposta














