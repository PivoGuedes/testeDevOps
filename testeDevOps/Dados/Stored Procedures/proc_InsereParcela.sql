
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
	Autor: Andre Anselmo
	Data Criação: 28/07/2015

	Descrição: 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereParcela
	Descrição: 
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereParcela] as
BEGIN TRY		
 
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max)

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parcela_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Parcela_TEMP;

CREATE TABLE [dbo].Parcela_TEMP(
	Codigo bigint NOT NULL
	,NumeroApolice	varchar(20)
	,NumeroEndosso	int
	,NumeroParcela	smallint
	,NumeroTitulo	varchar(20)
	,ValorPremioLiquido	numeric(19,2)
	,DataVencimento	date
	,QuantidadeOcorrencias	smallint
	,Situacao	smallint
	,DataArquivo	date
	,NomeArquivo	nvarchar(200)
) 

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada 
WHERE NomeEntidade = 'Parcela'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)= '81441947'
--DECLARE @COMANDO AS NVARCHAR(max)
SET @COMANDO = 'INSERT INTO [dbo].[Parcela_TEMP] ( 
					NumeroApolice
					,NumeroEndosso
					,NumeroParcela
					,NumeroTitulo
					,ValorPremioLiquido
					,DataVencimento
					,QuantidadeOcorrencias
					,Situacao
					,DataArquivo
					,NomeArquivo
					,Codigo
					   )
                SELECT 
					NumeroApolice
					,NumeroEndosso
					,ISNULL(NumeroParcela,0) AS NumeroParcela
					,NumeroTitulo
					,ValorPremioLiquido
					,DataVencimento
					,QuantidadeOcorrencias
					,Situacao
					,DataArquivo
					,NomeArquivo
					,Codigo
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaParcela] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     
                
SELECT @MaiorCodigo= MAX(Codigo)
FROM [dbo].[Parcela_TEMP]

/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 

 declare @idparcela int
 SELECT @idparcela = ISNULL(MAX(ID),0) from Dados.Parcela where ID IS NOT NULL

  	 /***********************************************************************
     Carregar as parcelas
   ***********************************************************************/

    MERGE INTO Dados.Parcela AS T
		USING (	select  
					e.id as idendosso
					,temp.NumeroParcela
					,temp.NumeroTitulo
					,temp.ValorPremioLiquido
					,temp.DataVencimento
					,temp.QuantidadeOcorrencias
					,sp.id as idsituacaoparcela
					,temp.DataArquivo
					,temp.NomeArquivo
					,ISNULL(C.DataEmissao,'2001-01-01') AS DataEmissao
					,ROW_NUMBER() OVER (ORDER BY NumeroTitulo,NumeroParcela) AS numlinha
				from [dbo].Parcela_TEMP temp
				inner join dados.contrato as c
				on c.numerocontrato=temp.numeroapolice
				inner join dados.endosso as e
				on e.idcontrato=c.id
				and e.numeroendosso=temp.numeroendosso
				inner join dados.situacaoparcela as sp
				on sp.codigo=temp.situacao 
			) AS X

	ON  X.idendosso = T.idendosso
	and X.NumeroParcela = T.NumeroParcela
	and X.idsituacaoparcela = T.idsituacaoparcela

	WHEN NOT MATCHED
			THEN INSERT (id,idendosso, NumeroParcela, NumeroTitulo, ValorPremioLiquido, DataVencimento, QuantidadeOcorrencias, idsituacaoparcela, DataArquivo, DataEmissao,TipoDado,NomeArquivo)
	  values (X.numlinha+@idparcela,X.idendosso, X.NumeroParcela, X.NumeroTitulo, X.ValorPremioLiquido, X.DataVencimento, X.QuantidadeOcorrencias, X.idsituacaoparcela, X.DataArquivo, X.DataEmissao, 'PRD.FENAE.PARCELA' ,X.NomeArquivo);
	

 /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'PARCELA'

   /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[Parcela_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[Parcela_TEMP] ( 
					NumeroApolice
					,NumeroEndosso
					,NumeroParcela
					,NumeroTitulo
					,ValorPremioLiquido
					,DataVencimento
					,QuantidadeOcorrencias
					,Situacao
					,DataArquivo
					,NomeArquivo
					,Codigo
					   )
                SELECT 
					NumeroApolice
					,NumeroEndosso
					,ISNULL(NumeroParcela,0) AS NumeroParcela
					,NumeroTitulo
					,ValorPremioLiquido
					,DataVencimento
					,QuantidadeOcorrencias
					,Situacao
					,DataArquivo
					,NomeArquivo
					,Codigo
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaParcela] ''''' + @PontoDeParada + ''''''') PRP'

	EXEC (@COMANDO)     
                
	SELECT @MaiorCodigo= MAX(Codigo)
	FROM [dbo].[Parcela_TEMP]

END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parcela_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Parcela_TEMP;				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH








--select * from Dados.Parcela where NomeArquivo is null
--update Dados.Parcela set NomeArquivo = TipoDado where NomeArquivo is null