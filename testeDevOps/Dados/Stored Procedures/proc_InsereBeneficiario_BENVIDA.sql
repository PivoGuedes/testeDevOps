

/*
	Autor: Egler Vieira
	Data Criação: 14/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereBeneficiario_BENVIDA
	Descrição: Procedimento que realiza a inserção dos BENEFICIARIOS (BENVIDA) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereBeneficiario_BENVIDA] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_BENVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_BENVIDA_TEMP];

CREATE TABLE [dbo].[Beneficiario_BENVIDA_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](80) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	--[CPFCPNJ] [varchar](18) NULL,
	--[Nome] [varchar](140) NULL,
	--[DataNascimento] [date] NULL,
	--[TipoPessoa] [varchar](15) NULL,
	[NumeroCertificado] [varchar](20) NULL,
	[NumeroPropostaTratado]  as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as   varchar(20)) PERSISTED,
	--[NumeroApolice] [numeric](13, 0) NULL,
	[NumeroBeneficiario] [smallint] NULL,
	[DataInclusao] [date] NULL,
	[DataExclusao] [date] NULL,
	[NomeBeneficiario] [varchar](40) NULL,
	[Parentesco] [varchar](30) NULL,
	[PercentualBeneficio] [decimal](6,2) NULL
) 
 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_Beneficiario_BENVIDA_TEMP ON [dbo].[Beneficiario_BENVIDA_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Beneficiario_BENVIDA'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_BENVIDA_TEMP] (
	                      [Codigo],              
	                      [ControleVersao],      
	                      [NomeArquivo],         
	                      [DataArquivo],         
	                      --[CPFCPNJ],           
	                      --[Nome],              
	                      --[DataNascimento],    
	                      --[TipoPessoa],        
	                      --[NumeroApolice],     
	                      [NumeroCertificado],   
	                      [NumeroBeneficiario],  
	                      [DataInclusao],        
	                      [DataExclusao],        
	                      [NomeBeneficiario],    
	                      [Parentesco],          
	                      [PercentualBeneficio] )  
                SELECT  
                      	[Codigo],              
	                      [ControleVersao],      
	                      [NomeArquivo],         
	                      [DataArquivo],         
	                      --[CPFCPNJ],           
	                      --[Nome],              
	                      --[DataNascimento],    
	                      --[TipoPessoa],        
	                      --[NumeroApolice],     
	                      [NumeroCertificado],   
	                      [NumeroBeneficiario],  
	                      [DataInclusao],        
	                      [DataExclusao],        
	                      [NomeBeneficiario],    
	                      [Parentesco],          
	                      [PercentualBeneficio]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_BENVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[Beneficiario_BENVIDA_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
 
      /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT EM.[NumeroPropostaTratado], 1 [IDSeguradora]
	                           , 'BENVIDA.TP4' [TipoDado], MAX(DataArquivo) [DataArquivo]
               FROM [Beneficiario_BENVIDA_TEMP] EM
               WHERE EM.NumeroPropostaTratado IS NOT NULL
               GROUP BY EM.[NumeroPropostaTratado]
              ) X
        ON T.NumeroProposta = X.NumeroPropostaTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
                   VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, -1, 0, -1, X.TipoDado, X.DataArquivo);		               		               
		               
   
      /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.PropostaCliente AS T
	      USING (SELECT  PRP.ID [IDProposta], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 'BENVIDA.TP4' [TipoDado], MAX(EM.[DataArquivo]) [DataArquivo]
            FROM [Beneficiario_BENVIDA_TEMP] EM
            INNER JOIN Dados.Proposta PRP
            ON PRP.NumeroProposta = EM.NumeroPropostaTratado
            AND PRP.IDSeguradora = 1
            WHERE EM.NumeroPropostaTratado IS NOT NULL
            GROUP BY PRP.ID
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, X.TipoDado, X.[NomeCliente], X.[DataArquivo]);


      /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.Certificado AS T
	      USING (SELECT PRP.ID [IDProposta], EM.NumeroPropostaTratado [NumeroCertificado], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente]
	                           , MAX(EM.NomeArquivo) [Arquivo], MAX(EM.DataArquivo) [DataArquivo]
               FROM [Beneficiario_BENVIDA_TEMP] EM
                INNER JOIN Dados.Proposta PRP
                ON PRP.NumeroProposta = EM.NumeroPropostaTratado               
               WHERE EM.NumeroPropostaTratado IS NOT NULL
               GROUP BY PRP.ID, EM.NumeroPropostaTratado 
              ) X
        ON T.NumeroCertificado = X.NumeroCertificado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT ([NumeroCertificado], [IDSeguradora], [IDProposta], [NomeCliente], [Arquivo], [DataArquivo])
		               VALUES (X.[NumeroCertificado], X.[IDSeguradora], X.[IDProposta], X.NomeCliente, [Arquivo], X.[DataArquivo]);
		               		          
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Beneficiários dos certificados recebidos no arquivo BENVIDA infoVariavel TP4
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.CertificadoBeneficiario AS T
		USING (             

              SELECT
                  C.ID [IDCertificado],  
                  MAX(A.[NomeArquivo]) [Arquivo],
                  MAX(A.[DataArquivo]) [DataArquivo],
                  A.NumeroCertificado,
                  A.[Nome],
                  A.[Numero],
                  A.[DataInclusao],
                  A.[DataExclusao],
                  --A.IDParentesco,
                  MAX(A.[Parentesco]) [Parentesco],
                  SUM(A.[PercentualBeneficio]) [PercentualBeneficio]
              FROM
              (
              SELECT 	
                        [Codigo],              
	                      [ControleVersao],      
	                      [NomeArquivo],         
	                      [DataArquivo],	        
	                      [NumeroPropostaTratado] [NumeroCertificado],   
	                      [NumeroBeneficiario] [Numero],  
	                      [DataInclusao],        
	                      [DataExclusao],        
	                      [NomeBeneficiario] [Nome],    
	                      [Parentesco],          
	                      [PercentualBeneficio],
                        ROW_NUMBER() OVER(PARTITION BY /*BEN.Codigo,*/ NumeroCertificado, [NomeBeneficiario], ISNULL([Parentesco], '') ORDER BY Codigo DESC) [ORDER]
              FROM [Beneficiario_BENVIDA_TEMP] BEN
              --WHERE NumeroCertificadoTratado = '057399110209035'
              WHERE NomeBeneficiario is NOT null
              ) A
               LEFT JOIN Dados.Certificado C
               ON C.NumeroCertificado = A.[NumeroCertificado]
              WHERE A.[ORDER] = 1
              GROUP BY C.[ID],  
                  --A.[Arquivo],
                  --A.[DataArquivo],
                  A.[NumeroCertificado],
                  A.[Nome],
                  A.[Numero],
                  A.[DataInclusao],
                  A.[DataExclusao]     
			) AS O
		ON  T.[IDCertificado] = O.[IDCertificado]
    AND T.[Nome] = O.[Nome]
    AND T.[Numero] = O.[Numero]
    AND T.[DataExclusao] = O.[DataExclusao]
	
		WHEN MATCHED
			THEN UPDATE 
				SET
					  T.Parentesco = COALESCE(O.Parentesco, T.Parentesco)
					 ,T.PercentualBeneficio = COALESCE(O.PercentualBeneficio, T.PercentualBeneficio)
					 ,T.DataInclusao = COALESCE(O.DataInclusao, T.DataInclusao)
					 ,T.DataArquivo = COALESCE(O.DataArquivo, T.DataArquivo)
					 ,T.Arquivo = COALESCE(O.Arquivo, T.Arquivo)
		WHEN NOT MATCHED
			THEN INSERT ([IDCertificado], Nome, Numero, Parentesco, PercentualBeneficio, DataInclusao, DataExclusao
                 , DataArquivo, Arquivo)
				VALUES (O.[IDCertificado], O.Nome, O.Numero, O.Parentesco, O.PercentualBeneficio, O.DataInclusao, O.DataExclusao
				        , O.DataArquivo, O.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Beneficiario_BENVIDA'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[Beneficiario_BENVIDA_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_BENVIDA_TEMP] (
	                      [Codigo],              
	                      [ControleVersao],      
	                      [NomeArquivo],         
	                      [DataArquivo],         
	                      --[CPFCPNJ],           
	                      --[Nome],              
	                      --[DataNascimento],    
	                      --[TipoPessoa],        
	                      --[NumeroApolice],     
	                      [NumeroCertificado],   
	                      [NumeroBeneficiario],  
	                      [DataInclusao],        
	                      [DataExclusao],        
	                      [NomeBeneficiario],    
	                      [Parentesco],          
	                      [PercentualBeneficio] )  
                SELECT  
                      	[Codigo],              
	                      [ControleVersao],      
	                      [NomeArquivo],         
	                      [DataArquivo],         
	                      --[CPFCPNJ],           
	                      --[Nome],              
	                      --[DataNascimento],    
	                      --[TipoPessoa],        
	                      --[NumeroApolice],     
	                      [NumeroCertificado],   
	                      [NumeroBeneficiario],  
	                      [DataInclusao],        
	                      [DataExclusao],        
	                      [NomeBeneficiario],    
	                      [Parentesco],          
	                      [PercentualBeneficio]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_BENVIDA] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)         

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[Beneficiario_BENVIDA_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_BENVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_BENVIDA_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

