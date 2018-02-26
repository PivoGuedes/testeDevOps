
/*
	Autor: Egler Vieira
	Data Criação: 27/09/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_Endosso_STASASSE
	Descrição: Procedimento que realiza a inserção dos lançamentos dos endossos recebidos.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_Endosso_STASASSE] 
AS			
    
BEGIN TRY	
  
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENSOSSO_STASASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[ENSOSSO_STASASSE_TEMP];

CREATE TABLE [dbo].[ENSOSSO_STASASSE_TEMP](
	Codigo [bigint] NOT NULL,
	NumeroProposta [varchar](20) NULL,
	NumeroPropostaTratado     as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	NumeroContrato [varchar] (20) NOT NULL,
	[IDSeguradora] [int] NOT NULL,
	DataInicioVigencia date NOT NULL,
	DataFimVigencia date NULL,
	ValorDiferencaEndosso numeric(16, 2) NOT NULL,
	ValorPremioLiquido numeric(16, 2) NOT NULL,
	ValorIOF numeric(16, 2) NOT NULL,
	[DataEmissao] [date] NULL,
	[DataArquivo] [date] NULL,
	)  

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_ENSOSSO_STASASSE_TEMP ON [dbo].[ENSOSSO_STASASSE_TEMP]
( 
  Codigo ASC
)   
WITH(FILLFACTOR=100)

CREATE NONCLUSTERED INDEX idx_NCL_NumeroProposta_ENSOSSO_STASASSE_TEMP
ON [dbo].[ENSOSSO_STASASSE_TEMP] ([NumeroProposta])
INCLUDE ([NumeroPropostaTratado],[IDSeguradora],[DataEmissao])
WITH(FILLFACTOR=100)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_Endosso_STASASSE'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[ENSOSSO_STASASSE_TEMP]  
                     ( 
					        Codigo
						  , NumeroProposta
						  , NumeroContrato
						  , DataInicioVigencia
						  , DataFimVigencia
						  , ValorPremioLiquido
						  , ValorIOF
						  , ValorDiferencaEndosso
						  , DataEmissao
						  , DataArquivo
						  , IDSeguradora
					  )
                  SELECT  DISTINCT
				            Codigo
				          , NumeroProposta
						  , NumeroContrato
						  , DataInicioVigencia
						  , DataFinalVigencia
						  , ValorPremioLiquido
						  , ValorIOF
						  , ValorDiferencaEndosso
						  , [DataEmissao]
						  , DataArquivo
						  , 1
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_Endosso_STASASSE] ''''' + @PontoDeParada + ''''''') PRP
				 '                
  EXEC (@COMANDO)
  
SELECT @MaiorCodigo= MAX(STA.Codigo)
FROM dbo.ENSOSSO_STASASSE_TEMP STA    
                  
                  
/*********************************************************************************************************************/
                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT PGTO.NumeroPropostaTratado, PGTO.[IDSeguradora], PGTO.DataEmissao
              FROM dbo.ENSOSSO_STASASSE_TEMP PGTO
			  WHERE PGTO.NumeroProposta IS NOT NULL
         
              ) X
         ON T.NumeroProposta = X.NumeroPropostaTratado  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroPropostaTratado, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, 'PROPOSTA ENDOSSO', X.DataEmissao);		               
	-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 'PROPOSTA ENDOSSO' [TipoDado], MAX(PGTO.DataEmissao) [DataArquivo]
          FROM ENSOSSO_STASASSE_TEMP PGTO
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = PGTO.NumeroPropostaTratado
          AND PRP.IDSeguradora = 1
          WHERE PGTO.NumeroProposta IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
	          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os pagamentos recebidos no arquivo STASASSE - TIPO - 2
    -----------------------------------------------------------------------------------------------------------------------		         
     ;MERGE INTO Dados.PropostaEndosso AS T
		USING (
			  SELECT *
			  FROM
			  (
				SELECT DISTINCT 
						PRP.ID [IDProposta],	
						PGTO.DataInicioVigencia,
						PGTO.DataFimVigencia,
						PGTO.ValorDiferencaEndosso,
						PGTO.ValorPremioLiquido ValorPremioLiquido,
						PGTO.ValorIOF ValorIOF,
						PGTO.[DataEmissao],
						PGTO.NumeroContrato,
						PGTO.DataArquivo,
						ROW_NUMBER() OVER (PARTITION BY PGTO.NumeroPropostaTratado, PGTO.DataInicioVigencia, PGTO.ValorPremioLiquido ORDER BY PGTO.DataEmissao DESC) [NUMERADOR]
				FROM dbo.ENSOSSO_STASASSE_TEMP PGTO
				  INNER JOIN Dados.Proposta PRP
				  ON  PGTO.NumeroPropostaTratado = PRP.NumeroProposta
				  AND PGTO.IDSeguradora = PRP.IDSeguradora
				WHERE PGTO.NumeroProposta IS NOT NULL
				--  WHERE prp.id = 3601415       
			  ) A
			  WHERE A.NUMERADOR = 1  
	  --  GROUP BY  PRP.ID, PGTO.DataInicioVigencia,
		--		PGTO.DataFimVigencia, PGTO.ValorDiferencaEndosso,
	--			PGTO.[DataEmissao], PGTO.NumeroContrato
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.DataInicioVigencia = T.DataInicioVigencia 
   AND X.ValorPremioLiquido = T.ValorPremioLiquido  
 --  AND X.[NUMERADOR] = 1  
    WHEN MATCHED
		THEN UPDATE
		     SET DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
			   , ValorDiferencaEndosso = CASE WHEN X.ValorDiferencaEndosso <> 0.0 THEN X.ValorDiferencaEndosso ELSE T.ValorDiferencaEndosso END
               , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
               , ValorPremioLiquido = COALESCE(X.ValorPremioLiquido, T.ValorPremioLiquido)
               , [DataEmissao] = COALESCE(X.[DataEmissao], T.[DataEmissao])
			   , [NumeroContrato] = COALESCE(X.[NumeroContrato], T.[NumeroContrato])
			   , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
    WHEN NOT MATCHED
			    THEN INSERT          
              (
			   [IDProposta],  DataInicioVigencia, DataFimVigencia
             , ValorDiferencaEndosso, ValorPremioLiquido, [ValorIOF]
             , [DataEmissao], NumeroContrato, [DataArquivo]         
             )
          VALUES (
		          X.[IDProposta]
                 ,X.DataInicioVigencia
                 ,X.DataFimVigencia
                 ,X.ValorDiferencaEndosso
                 ,X.ValorPremioLiquido
                 ,X.[ValorIOF]
                 ,X.[DataEmissao]
				 ,X.NumeroContrato
				 ,X.[DataArquivo]
                 );


	;MERGE INTO Dados.PropostaEndosso AS T
	USING (
			SELECT IDProposta, DataInicioVigencia, ValorPremioLiquido, ROW_NUMBER() OVER (PARTITION BY IDProposta ORDER BY DataInicioVigencia, ValorPremioLiquido ASC) - 1 [NumeroEndosso]
			FROM Dados.PropostaEndosso 
			WHERE IDProposta in	 (
								SELECT PRP.ID
								FROM dbo.ENSOSSO_STASASSE_TEMP PGTO
								INNER JOIN Dados.Proposta PRP
								ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
								--and pgto.numeropropostatratado like '%1201800022834%'
								AND PGTO.IDSeguradora = PRP.IDSeguradora 
								WHERE PGTO.NumeroProposta IS NOT NULL)      
			) X
    ON   X.[IDProposta]       = T.[IDProposta]   
     AND X.DataInicioVigencia = T.DataInicioVigencia 
	 AND X.ValorPremioLiquido = T.ValorPremioLiquido    
    WHEN MATCHED
	   THEN
			UPDATE SET T.NumeroEndosso = X.NumeroEndosso;  
  -----------------------------------------------------------------------------------------------------------------------

--Inserção da Primeira Parcela PropostaAutomovel e PropostaResidencial no Pagamento
--Luan Moreno M. Maciel
;WITH PRPAuto AS 
(
SELECT PA.IDProposta, PA.ValorPrimeiraParcela, PA.DataArquivo, PE.NumeroEndosso, P.NumeroProposta
FROM Dados.Proposta AS P
INNER JOIN ENSOSSO_STASASSE_TEMP AS TP
ON P.NumeroProposta = TP.NumeroPropostaTratado
	AND P.IDSeguradora = TP.IDSeguradora
INNER JOIN Dados.PropostaAutomovel AS PA
ON PA.IDProposta = P.ID
INNER JOIN Dados.PropostaEndosso PE
ON PA.DataInicioVigencia = PE.DataInicioVigencia
AND PA.IDProposta = PE.IDProposta
) ,  PRPResidencial AS
(
SELECT PR.IDProposta, PR.ValorPrimeiraParcela, PR.DataArquivo, NumeroEndosso, P.NumeroProposta
FROM Dados.vw_PropostaResidencial AS PR
INNER JOIN Dados.Proposta AS P
ON P.ID = PR.IDProposta
INNER JOIN ENSOSSO_STASASSE_TEMP AS TP
ON P.NumeroProposta = TP.NumeroPropostaTratado
)  , DadosInsertParcela AS
(
SELECT *
FROM PRPAuto AS A
UNION ALL
SELECT *
FROM PRPResidencial AS A
)
INSERT INTO Dados.Pagamento (IDProposta, IDMotivo, NumeroParcela, Valor, DataArquivo, CodigoNaFonte, TipoDado, EfetivacaoPgtoEstimadoPelaEmissao, ExpectativaDeReceita, Arquivo, ParcelaCalculada)
SELECT DISTINCT DIP.IDProposta, -2, 1, DIP.ValorPrimeiraParcela, DIP.DataArquivo, -2, 'TP2 + MarcacaoSIDEM', 0, 0, 'TP2 + MarcacaoSIDEM', 1
FROM DadosInsertParcela AS DIP
WHERE IDProposta IN (
							SELECT PRP.ID
							FROM dbo.ENSOSSO_STASASSE_TEMP PGTO
							INNER JOIN Dados.Proposta PRP
							ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
							AND PGTO.IDSeguradora = PRP.IDSeguradora 
							WHERE PGTO.NumeroProposta IS NOT NULL
						)     
AND NumeroEndosso = 0
AND NOT EXISTS (
				SELECT *
				FROM Dados.Pagamento PGTO
				WHERE PGTO.IDProposta = DIP.IDProposta
				AND PGTO.NumeroParcela = 1
				AND PGTO.ParcelaCalculada = 1
				)
			 
--Inserção da Primeira Parcela de NumeroEndosso = 0 e Produto Fake que não possui primeira parcela em auto e residencial
--Luan Moreno M. Maciel
INSERT INTO Dados.Pagamento (IDProposta, IDMotivo, NumeroParcela, Valor, DataArquivo, CodigoNaFonte, TipoDado, EfetivacaoPgtoEstimadoPelaEmissao, ExpectativaDeReceita, Arquivo, ParcelaCalculada)
SELECT PE.IDProposta, -2, 1, PE.ValorPremioLiquido, P.DataArquivo, -2, 'TP2 + MarcacaoSIDEM', 0, 0, 'TP2 + MarcacaoSIDEM', 1
FROM Dados.Proposta AS P
INNER JOIN Dados.PropostaEndosso AS PE
ON P.ID = PE.IDProposta	
	AND NumeroEndosso = 0
WHERE P.IDProdutoSIGPF <> 0
AND NOT EXISTS (SELECT * 
				FROM Dados.PropostaAutomovel AS PA
				WHERE PA.IDProposta = P.ID)
AND NOT EXISTS (SELECT * 
				FROM Dados.PropostaResidencial AS PR
				WHERE PR.IDProposta = P.ID)
AND IDProposta IN (
							SELECT PRP.ID
							FROM dbo.ENSOSSO_STASASSE_TEMP PGTO
							INNER JOIN Dados.Proposta PRP
							ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
							AND PGTO.IDSeguradora = PRP.IDSeguradora 
							WHERE PGTO.NumeroProposta IS NOT NULL
						)   
AND NOT EXISTS (
				SELECT *
				FROM Dados.Pagamento PGTO
				WHERE PGTO.IDProposta = PE.IDProposta
				AND PGTO.NumeroParcela = 1
				AND PGTO.ParcelaCalculada = 1
				)  
  /*TODO - Atualizar saldo pago*/

  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_Endosso_STASASSE'
  /*************************************************************************************/
  
                    
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[ENSOSSO_STASASSE_TEMP] 
  
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[ENSOSSO_STASASSE_TEMP]  
                     ( 
					        Codigo
						  , NumeroProposta
						  , NumeroContrato
						  , DataInicioVigencia
						  , DataFimVigencia
						  , ValorPremioLiquido
						  , ValorIOF
						  , ValorDiferencaEndosso
						  , DataEmissao
						  , DataArquivo
						  , IDSeguradora
					  )
                  SELECT  DISTINCT
				            Codigo
				          , NumeroProposta
						  , NumeroContrato
						  , DataInicioVigencia
						  , DataFinalVigencia
						  , ValorPremioLiquido
						  , ValorIOF
						  , ValorDiferencaEndosso
						  , [DataEmissao]
						  , DataArquivo
						  , 1
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_Endosso_STASASSE] ''''' + @PontoDeParada + ''''''') PRP
				 '                
  EXEC (@COMANDO)

                  
  SELECT @MaiorCodigo= MAX(STA.Codigo)
  FROM dbo.ENSOSSO_STASASSE_TEMP STA    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END


--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENSOSSO_STASASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	--DROP TABLE [dbo].[ENSOSSO_STASASSE_TEMP];
  	      	                                
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

                


