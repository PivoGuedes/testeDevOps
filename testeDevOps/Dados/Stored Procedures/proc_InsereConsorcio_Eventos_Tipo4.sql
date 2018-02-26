
/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_InsereConsorcio_Eventos_Tipo4]
	Descrição: 
		
	Parâmetros de entrada:
	 
	Retorno:

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
 
CREATE PROCEDURE [Dados].[proc_InsereConsorcio_Eventos_Tipo4] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consorcio_Eventos_Tipo4_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Consorcio_Eventos_Tipo4_Temp];

CREATE TABLE [dbo].[Consorcio_Eventos_Tipo4_Temp](
	NUMERO_GRUPO	int	
	,NUMERO_COTA	int	
	,NUMERO_VERSAO	int	
	,TIPO_EVENTO	int	
	,DATA_EVENTO	date	
	,VALOR_EVENTO_PARCELA	decimal(19,2)
	,VALOR_CREDITO_ATUALIZADO	decimal(19,2)
	,PV_GERADOR_EVENTO	int	
	,BRANCOS	varchar(300)
	,Codigo	int	
	,TipoRegistro	char(2)
	,NomeArquivo	varchar(200)
	,DataSistema	datetime2	
	,DataArquivo	date	
	,NumeroProposta	varchar(24)
);

/* SELECIONA O ÚLTIMO PONTO DE PARADA */
--SELECT *
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Consorcio_Eventos_Tipo4'

		
/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--   DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[Consorcio_Eventos_Tipo4_Temp]
           (Numero_grupo, Numero_cota ,Numero_versao ,Tipo_Evento ,Data_Evento ,Valor_Evento_Parcela ,VALOR_CREDITO_ATUALIZADO ,PV_Gerador_Evento ,Brancos ,DataArquivo ,NomeArquivo ,Codigo, NumeroProposta)
		   SELECT  Numero_grupo, Numero_cota ,Numero_versao ,Tipo_Evento ,Data_Evento ,Valor_Evento_Parcela ,VALOR_CREDITO_ATUALIZADO ,PV_Gerador_Evento ,Brancos ,DataArquivo ,NomeArquivo ,Codigo, NumeroProposta
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Eventos_Tipo4]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Consorcio_Eventos_Tipo4_Temp PRP                    

/*
ALTER TABLE Dados.EventosContratoConsorcio
ADD CONSTRAINT PK_EventosContratoConsorcio_Contrato
FOREIGN KEY (IDContrato)
REFERENCES Dados.Contrato (ID)

ALTER TABLE Dados.EventosContratoConsorcio
ADD CONSTRAINT PK_EventosContratoConsorcio_Unidade
FOREIGN KEY (IDUnidade)
REFERENCES Dados.Unidade (ID)
GO

*/
/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
/**********************************************************************
       grava informações de migração, transferência dos contratos de consórcio.
***********************************************************************/
;MERGE INTO Dados.EventosContratoConsorcio AS T
	USING (
			SELECT DISTINCT 
				C.ID AS IDContrato, U.ID AS IDUnidade, TP.ID AS IDTipoEvento,TMP.Numero_grupo, TMP.Numero_cota ,
				TMP.Numero_versao ,TMP.Data_Evento ,
				TMP.Valor_Evento_Parcela ,TMP.VALOR_CREDITO_ATUALIZADO ,
				TMP.Brancos , TMP.DataArquivo ,TMP.NomeArquivo 
			FROM DBO.Consorcio_Eventos_Tipo4_Temp AS TMP
			INNER JOIN Dados.Contrato AS C
			ON TMP.NumeroProposta=C.NumeroContrato
			LEFT OUTER JOIN Dados.Unidade AS U 
			ON U.Codigo=TMP.PV_Gerador_Evento
			LEFT OUTER JOIN Dados.TipoEventoConsorcio AS TP
			ON TP.Codigo=TMP.Tipo_Evento
          ) X
        ON T.IDContrato = X.IDContrato
		AND T.DataArquivo=X.DataArquivo
		AND T.IDTipoEvento=X.IDTipoEvento
		WHEN NOT MATCHED
		          THEN INSERT (IDContrato, IDUnidade, IDTipoEvento, Numero_grupo, Numero_cota, Numero_versao, Data_Evento, Valor_Evento_Parcela, VALOR_CREDITO_ATUALIZADO,
								Brancos, DataArquivo, NomeArquivo)
		               VALUES (X.IDContrato, X.IDUnidade, X.IDTipoEvento, X.Numero_grupo, X.Numero_cota, X.Numero_versao, X.Data_Evento, X.Valor_Evento_Parcela, X.VALOR_CREDITO_ATUALIZADO,
								X.Brancos, X.DataArquivo, X.NomeArquivo); 

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Consorcio_Eventos_Tipo4'

 /****************************************************************************************/
  
  TRUNCATE TABLE [dbo].Consorcio_Eventos_Tipo4_Temp
  
  /**************************************************************************************/
   
    SET @COMANDO = 'INSERT INTO [dbo].[Consorcio_Eventos_Tipo4_Temp]
           (Numero_grupo, Numero_cota ,Numero_versao ,Tipo_Evento ,Data_Evento ,Valor_Evento_Parcela ,VALOR_CREDITO_ATUALIZADO ,PV_Gerador_Evento ,Brancos ,DataArquivo ,NomeArquivo ,Codigo, NumeroProposta)
		   SELECT  Numero_grupo, Numero_cota ,Numero_versao ,Tipo_Evento ,Data_Evento ,Valor_Evento_Parcela ,VALOR_CREDITO_ATUALIZADO ,PV_Gerador_Evento ,Brancos ,DataArquivo ,NomeArquivo ,Codigo, NumeroProposta
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Eventos_Tipo4]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    


SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Consorcio_Eventos_Tipo4_Temp PRP 

  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consorcio_Eventos_Tipo4_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Consorcio_Eventos_Tipo4_Temp];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

			    
			                    