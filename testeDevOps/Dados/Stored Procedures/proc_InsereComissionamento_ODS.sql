
/*
	Autor: Sandrine Oliveira
	Data Criação: 30/04/2017

	Descrição: Insere dados de Comissioanamento
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereComissionamento
	Descrição:
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereComissionamento_ODS] 
AS

BEGIN 		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorID AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Comissionamento_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[Comissionamento_TEMP];
END


CREATE TABLE [dbo].[Comissionamento_TEMP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	--[IDOrigem] [int] NOT NULL,
	[TP] [varchar](50) NULL,
	[CodUnidadeVenda] [varchar](50) NULL,
	[VlrAprovisionado] varchar (50) NULL,
	[MatrGestor] [int] NULL,
	[MesRef] [varchar](50) NULL,
	[DataArquivo] [datetime] NULL,
	[NomeArquivo] [varchar](200) NULL
)                       


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_Comissionamento_TEMP_ID ON [dbo].[Comissionamento_TEMP]
( 
  ID ASC
)   

--DECLARE @PontoDeParada AS VARCHAR(400)
--DECLARE @COMANDO AS NVARCHAR(MAX) 
SET @PontoDeParada = 
(SELECT ISNULL(PontoParada, 12664) AS PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Comissionamento')
SELECT @PontoDeParada


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO [dbo].[Comissionamento_TEMP]
        ( 	 
		    
			[TP],
			[CodUnidadeVenda] ,
			[VlrAprovisionado] ,
			[MatrGestor],
			[MesRef],
			[DataArquivo],
			[NomeArquivo] 
			)
     SELECT 
		    
			[TP],
			[CodUnidadeVenda] ,
			[VlrAprovisionado] ,
			[MatrGestor],
			[MesRef],
			[DataArquivo],
			[NomeArquivo] 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaComissionamento] ''''' + @PontoDeParada + ''''''') PRP 
    '
exec (@COMANDO)    

SELECT @MaiorID= MAX(PRP.ID)
FROM dbo.Comissionamento_TEMP PRP                  

--/*********************************************************************************************************************/
                  
--SET @COMANDO = '' 

--WHILE @MaiorID IS NOT NULL
--BEGIN
--print @MaiorID

  
 /*INSERE COMISSIONAMENTO NO ODS*/
 --select * from [Dados].[Comissionamento]

 INSERT INTO [Dados].[Comissionamento]
 (
			[TP],
			[CodUnidadeVenda],
			[VlrAprovisionado],
		    [MatrGestor ],
			[MesRef],
			[DataArquivo],
			[NomeArquivo] 
			)

SELECT 
			
			[TP],
			[CodUnidadeVenda],
cast(case when len([VlrAprovisionado] ) >= 7 then replace(SUBSTRING([VlrAprovisionado] ,1,3),'.','') 
+ substring([VlrAprovisionado] ,4,len([VlrAprovisionado] )) when  [VlrAprovisionado] = 'NULL' then NULL else [VlrAprovisionado]  end as decimal(18,2)) as [VlrAprovisionado],
			[MatrGestor],
			[MesRef],
			[DataArquivo],
			[NomeArquivo]
  FROM [dbo].[Comissionamento_TEMP] 
  WHERE [ID] IS NOT NULL
  
 

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorID
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'Comissionamento'  
 
 DROP TABLE [dbo].[Comissionamento_TEMP]

  
END


--ALTER TABLE Comissionamento_TEMP ALTER COLUMN [VlrAprovisionado] decimal (29,2);

--EXEC [Dados].[proc_InsereComissionamento_ODS]  

--SELECT * FROM ControleDados.PontoParada 
--WHERE NomeEntidade = 'Comissionamento'

--UPDATE ControleDados.PontoParada 
--SET PontoParada = '12665'
--WHERE NomeEntidade = 'Comissionamento'  


--select cast(MatrGestor as numeric) from [Dados].[Comissionamento]
--select * from  [Dados].[Comissionamento]