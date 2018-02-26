/*
	Autor: Luan Moreno
	Data Criação: 20/02/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereComissao_COMISSAO_ANALIT_RE
	Descrição: Procedimento que realiza a inserção dos lançamentos de comissão.
		
	Parâmetros de entrada:	
					
	Retorno:

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
*/
CREATE PROCEDURE [Dados].[proc_InsereComissao_COMISSAO_ANALIT_RE](@DataComissao DATE = NULL) 
AS

BEGIN TRY

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAD_TEMP]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[CAD_TEMP];
  
  --RAISERROR (N'A tabela temporária [CAD_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
  --            16, -- Severity.
  --            1 -- State.
  --          )
END
--DECLARE @DataComissao AS DATE = '2014-02-19'
DECLARE @PontoDeParada AS DATE  --= '2014-02-19'
DECLARE @COMANDO AS NVARCHAR(4000);
DECLARE @MaiorCodigo AS DATE;
DECLARE @ParmDefinition NVARCHAR(500);
                
/*Cria tabela temporária para carregar os dados que vem da base primária*/
CREATE TABLE CAD_TEMP
   (  		
	DataArquivo                 date,           
	DataCalculo                 date,           
	DataRecibo                  date,           
	CodigoFilial                smallint,       
	CodigoFilialProposta        smallint,       
	CodigoOperacao              smallint,       
	CodigoPontoVenda            smallint,       
	CodigoRamo                  smallint,       
	NumeroParcela               smallint,       
	CodigoProduto               varchar(10),       
	TipoCorretagem              smallint,       
	CodigoProdutor              int,             
	CodigoSubgrupoRamoVida      int,       
	NomeCliente                 varchar(140),      
	NumeroApolice               varchar(20),   
	NumeroEndosso               numeric(9,0),    
	NumeroProposta              numeric(16,0),
	NumeroPropostaTratado       as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	NumeroCertificado           numeric(15,0),
	NumeroCertificadoTratado    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as   varchar(20)) PERSISTED,
	NumeroRecibo                numeric(9,0),    
	PercentualCorretagem        numeric(5,2),    
	ValorCorretagemCertificado  numeric(20,6),   
	ValorBase                   numeric(20,6),
	ValorCorretagem             numeric(20,6),    
	--ValorBaseCERT               numeric(15,2), 
	--ValorPremioAP               numeric(15,2),   
	--ValorPremioVG               numeric(15,2),   
	--ValorBaseAgrupado           numeric(20,6),   
	--ValorCorretagemAgrupado     numeric(20,6),   
	DataQuitacaoParcela         date,
	IDEmpresa                   smallint DEFAULT(15)    
   );

 
 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_CLProposta ON CAD_TEMP
( 
NumeroApolice,
NumeroEndosso,
CodigoProduto,
CodigoOperacao
);

CREATE NONCLUSTERED INDEX idx_NCLFilialProposta ON CAD_TEMP
(
  CodigoFilialProposta
);


CREATE NONCLUSTERED INDEX idx_NCLRamo ON CAD_TEMP
(
  CodigoRamo
);

CREATE NONCLUSTERED INDEX idx_NCLProduto ON CAD_TEMP
(
  CodigoProduto
);


CREATE NONCLUSTERED INDEX idx_NCLOperacao ON CAD_TEMP
(
  CodigoOperacao
);


CREATE NONCLUSTERED INDEX idx_NCLPontoVenda ON CAD_TEMP
(  
  CodigoPontoVenda
);


CREATE NONCLUSTERED INDEX idx_NCLProposta ON CAD_TEMP
(
  NumeroPropostaTratado
);


CREATE NONCLUSTERED INDEX idx_NCLCertificado ON CAD_TEMP
( 
  NumeroCertificadoTratado
);

CREATE NONCLUSTERED INDEX idx_NCLCodigoProdutor ON CAD_TEMP
(  
  CodigoProdutor
);


CREATE NONCLUSTERED INDEX idx_NCLApolice ON CAD_TEMP
(
  NumeroApolice
);                                                                       

IF @DataComissao IS NULL
BEGIN
  SELECT @PontoDeParada = Cast(PontoParada as date)
  FROM ControleDados.PontoParada
  WHERE NomeEntidade = 'COMISSAO_RE';
  
  
  SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

  SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
                FROM OPENQUERY ([OBERON], 
                '' SELECT MAX(DataArquivo) [MaiorData]
                   FROM FENAE.dbo.COMISSAO_ANALIT_RE
                   WHERE DataArquivo >= ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') EM';

                
  exec sp_executesql @COMANDO
                    ,@ParmDefinition
                    ,@MaiorCodigo = @MaiorCodigo OUTPUT;
END
ELSE
BEGIN
  SET @PontoDeParada = @DataComissao
  SET @MaiorCodigo = @DataComissao
END

                  
WHILE @PontoDeParada <= @MaiorCodigo /*'2012-12-31'*/
BEGIN 

--BEGIN TRAN
--DECLARE @PontoDeParada AS DATE 
--DECLARE @COMANDO AS NVARCHAR(4000);
--DECLARE @MaiorCodigo AS DATE;
--DECLARE @ParmDefinition NVARCHAR(500);

;SET @COMANDO =   
'INSERT INTO CAD_TEMP (	
	DataArquivo                 ,           
	DataCalculo                 ,           
	DataRecibo                  ,           
	CodigoFilial                ,       
	CodigoFilialProposta        ,       
	CodigoOperacao              ,       
	CodigoPontoVenda            ,       
	CodigoRamo        ,       
	NumeroParcela               ,       
	CodigoProduto               ,       
	TipoCorretagem              ,       
	CodigoProdutor              ,             
	CodigoSubgrupoRamoVida      , 
	NomeCliente                 ,            
	NumeroApolice               ,   
	NumeroEndosso               ,    
	NumeroProposta              ,   
	NumeroCertificado           ,   
	NumeroRecibo                ,    
	PercentualCorretagem        ,    
	ValorBase                   ,  
	ValorCorretagem             ,   
	/*ValorBaseAgrupado           ,
	ValorCorretagemAgrupado     ,*/
	DataQuitacaoParcela         )
SELECT 	
	DataArquivo                 ,           
	DataCalculo                 ,           
	DataRecibo                  ,           
	CodigoFilial                ,       
	CodigoFilialProposta        ,       
	CodigoOperacao              ,       
	CodigoPontoVenda            ,       
	CodigoRamo                  ,       
	NumeroParcela               ,       
	Cast(CodigoProduto as varchar(10)),       
	TipoCorretagem              ,       
	CodigoProdutor              ,             
	CodigoSubgrupoRamoVida      ,             
	NomeSegurado                ,   
	Cast(NumeroApolice as varchar(20)),
	NumeroEndosso               ,    
	NumeroProposta              ,   
	NumeroCertificado           ,   
	NumeroRecibo                ,    
	PercentualCorretagem        ,    
	ValorBase                   ,        
	ValorCorretagem             ,              
	/*ValorBaseAgrupado           ,
	ValorCorretagemAgrupado     ,*/
	DataQuitacaoParcela           
FROM  OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaComissaoAnalitico_RE] ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') CAD'

;exec sp_executesql @COMANDO

print '1'
/**************************************/
/*Faz a compensação de arredondamento*/
/**************************************/
--DESNECESSARIO POIS NAO HA SUBVALOR A SER AGREGADO

/*******************************************************************************************************************************************************************************************************************************************/

--COMMIT TRAN
print '2'
--BEGIN TRAN
                  --,@ParmDefinition
                  --,@MaiorCodigo = @MaiorCodigo OUTPUT
    
    
/*INSERE PVs NÃO LOCALIZADOS*/
;INSERT INTO Dados.Unidade(Codigo)
SELECT DISTINCT CAD.CodigoPontoVenda
FROM CAD_TEMP CAD
WHERE  CAD.CodigoPontoVenda IS NOT NULL 
  AND not exists (
                  SELECT     *
                  FROM         Dados.Unidade U
                  WHERE U.Codigo = CAD.CodigoPontoVenda)                  
                                                        

INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], -1 [CodigoNaFonte], 'COMISSAO' [TipoDado], MAX(EM.DataArquivo) [DataArquivo], 'COMISSAO' [Arquivo]
FROM CAD_TEMP EM
INNER JOIN Dados.Unidade U
ON EM.CodigoPontoVenda = U.Codigo
WHERE 
    not exists (
                SELECT     *
                FROM         Dados.UnidadeHistorico UH
                WHERE UH.IDUnidade = U.ID)    
GROUP BY U.ID 

print '3'                  

/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT EM.[NumeroApolice], EM.[NumeroPropostaTratado], 1 [IDSeguradora], PRD.ID [IDProduto], U.ID IDAgenciaVenda, 'FN0710B.COMISSAO.CADASTRO' [NomeArquivo], EM.[DataArquivo]
            FROM CAD_TEMP EM
			INNER JOIN Dados.Produto PRD
			ON PRD.CodigoComercializado = EM.CodigoProduto
			LEFT JOIN Dados.Unidade U
			ON U.Codigo = EM.CodigoPontoVenda
            WHERE EM.NumeroPropostaTratado IS NOT NULL
              ) X
        ON T.NumeroProposta = X.NumeroPropostaTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta,              [IDSeguradora],    IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora],    COALESCE(X.IDAgenciaVenda, -1),  X.IDProduto,                0,              -1,                  0,           -1, 'COMISSAO', X.DataArquivo)		               
	   WHEN MATCHED																																			         
	     THEN UPDATE
		 /*Atualiza o código do Produto & código do Produto Anterior com o código recebido no comissionamento
		   Egler - 23/09/2013*/
		       SET T.IDProduto = X.IDProduto,
				   T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											   ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											             ELSE T.IDProdutoAnterior
												    END
										 END                  
		               
/*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
;MERGE INTO Dados.PropostaCliente AS T
	      USING (SELECT DISTINCT PRP.ID [IDProposta], CASE WHEN NomeCliente IS NULL OR NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente], 'FN0710B.COMISSAO.CADASTRO' [NomeArquivo], EM.[DataArquivo]
            FROM CAD_TEMP EM
            INNER JOIN Dados.Proposta PRP
            ON PRP.NumeroProposta = EM.NumeroPropostaTratado
            AND PRP.IDSeguradora = 1
            WHERE EM.NumeroPropostaTratado IS NOT NULL
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, 'COMISSAO', X.[NomeCliente], X.[DataArquivo])
		               		               
		/*PRODUTOS DE VIDA COM CAPITAL GLOBAL EMPRESARIAL POSSUEM NÚMERO DE PROPOSTA DIFERENTE DO NÚMERO DO CERTIFICADO
		#REMOVIDO EM 06/11/2013 - EGLER
		#REINCLUÍDO EM 12/12/2013 após adaptar a solução para adicionando a condição da cláusula WHERE --### 2013-12-12:*/    
		           
/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NÚMERO DE CERTIFICADO*/
		;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT EM.[NumeroApolice], EM.[NumeroCertificadoTratado], 1 [IDSeguradora], PRD.ID [IDProduto], U.ID IDAgenciaVenda, 'FN0710B.COMISSAO.CADASTRO' [NomeArquivo], EM.[DataArquivo]
				 FROM CAD_TEMP EM
				 	 INNER JOIN Dados.Produto PRD
					 ON PRD.CodigoComercializado = EM.CodigoProduto
					 INNER JOIN Dados.ProdutoSIGPF SIGPF
					 ON  SIGPF.ID = PRD.IDProdutoSIGPF
					LEFT JOIN Dados.Unidade U
					ON U.Codigo = EM.CodigoPontoVenda
				WHERE EM.NumeroCertificadoTratado IS NOT NULL
				AND NOT (    ISNULL(SIGPF.ProdutoComCertificado,0) = 1	  --### 2013-12-12:  Gustavo/Egler/Diego -> Condição necessária para garantir que os produtos com o número da proposta diferente do número do 
						 AND ISNULL(SIGPF.ProdutoComContrato,0) = 1		  --certificado não sejam inseridos EQUIVOCADAMENTE como proposta, já que o número da proposta não existirá como número de certificado
						)			  
              ) X
        ON T.NumeroProposta = X.NumeroCertificadoTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta,              [IDSeguradora],    IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.[NumeroCertificadoTratado], X.[IDSeguradora],                COALESCE(X.IDAgenciaVenda, -1),  X.IDProduto,                0,              -1,                  0,           -1, 'COMISSAO', X.DataArquivo)	
	   WHEN MATCHED
	     THEN UPDATE
		  /*Atualiza o código do Produto & código do Produto Anterior com o código recebido no comissionamento
		    Egler - 23/09/2013*/
		       SET T.IDProduto = X.IDProduto,
				   T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											   ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											             ELSE T.IDProdutoAnterior
												    END
										 END              
												
		/*PRODUTOS DE VIDA COM CAPITAL GLOBAL EMPRESARIAL POSSUEM NÚMERO DE PROPOSTA DIFERENTE DO NÚMERO DO CERTIFICADO
		#REMOVIDO EM 06/11/2013 - EGLER
		#REINCLUÍDO EM 12/12/2013 após adaptar a solução para adicionando a condição da cláusula WHERE --### 2013-12-12: */      

	/*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS -  POR NÚMERO DE CERTIFICADO*/
	;MERGE INTO Dados.PropostaCliente AS T
			  USING (SELECT DISTINCT PRP.ID [IDProposta], CASE WHEN NomeCliente IS NULL OR NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente], 'FN0710B.COMISSAO.CADASTRO' [NomeArquivo], EM.[DataArquivo]
					FROM CAD_TEMP EM
						INNER JOIN Dados.Proposta PRP
						ON PRP.NumeroProposta = EM.NumeroCertificadoTratado
						AND PRP.IDSeguradora = 1
						INNER JOIN Dados.Produto PRD
						ON PRD.CodigoComercializado = EM.CodigoProduto
						INNER JOIN Dados.ProdutoSIGPF SIGPF
						ON  SIGPF.ID = PRD.IDProdutoSIGPF
					WHERE EM.NumeroCertificadoTratado IS NOT NULL
					AND NOT (    ISNULL(SIGPF.ProdutoComCertificado,0) = 1	  --### 2013-12-12:  Gustavo/Egler/Diego -> Condição necessária para garantir que os produtos com o número da proposta diferente do número do 
							 AND ISNULL(SIGPF.ProdutoComContrato,0) = 1		  --certificado não sejam inseridos EQUIVOCADAMENTE como proposta, já que o número da proposta não existirá como número de certificado
							)			
				  ) X
			ON T.IDProposta = X.IDProposta
		   WHEN NOT MATCHED
					  THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
						   VALUES (X.IDProposta, 'COMISSAO', X.[NomeCliente], X.[DataArquivo])

/*INSERE CONTRATOS NÃO LOCALIZADOS*/
;MERGE INTO Dados.Contrato AS T
USING	
(
SELECT DISTINCT
       1 [IDSeguradora] /*Caixa Seguros*/               
     , CAD.[NumeroApolice]
     --, CAD.NumeroCertificado
     , /*@PontoDeParada*/ [DataArquivo]
     , 'FN0710B.COMISSAO.CADASTRO' [Arquivo]
FROM CAD_TEMP CAD
WHERE CAD.NumeroApolice IS NOT NULL
) X
ON T.[NumeroContrato] = X.[NumeroApolice]
AND T.[IDSeguradora] = X.[IDSeguradora]
WHEN NOT MATCHED
        THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
             VALUES (X.[NumeroApolice], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);   



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Clientes dos Contratos recebidos no arquivo EMISSAO
        
    ;MERGE INTO Dados.ContratoCliente AS T
		USING (
            SELECT DISTINCT
                   C.ID [IDContrato], 1 [IDSeguradora]    
                   , CASE WHEN NomeCliente IS NULL OR NomeCliente = '' or (NomeCliente <> '' AND NumeroCertificado IS NOT NULL) THEN 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente]
                   , C.[DataArquivo],'FN0710B.COMISSAO.CADASTRO' [Arquivo]
            FROM [dbo].[CAD_TEMP] EM
              LEFT JOIN Dados.Contrato C
              ON  C.[NumeroContrato] = EM.[NumeroApolice]
              AND C.[IDSeguradora] = 1 --C.[IDSeguradora]
              
             WHERE /*[RankContrato] = 1  
               AND */EM.[NumeroApolice] IS NOT NULL
          ) AS X
    ON  X.[IDContrato] = T.[IDContrato]
    AND X.[DataArquivo] = T.[DataArquivo]  
    WHEN NOT MATCHED
			    THEN INSERT          
              (   IDContrato
                , [NomeCliente]
                , [DataArquivo]
                , [Arquivo]  )
          VALUES (
                  X.IDContrato
                , X.[NomeCliente]

                , X.[DataArquivo]
                , X.[Arquivo]               
                 );

    -----------------------------------------------------------------------------------------------------------------------      
    
print '4'	

/*ATUALIZA PROPOSTAS LOCALIZADAS - POR PROPOSTA*/
;MERGE INTO Dados.Proposta AS T
USING	
(SELECT DISTINCT
       CAD.[NumeroApolice]
     , PRP.ID [IDProposta]
     , C.ID [IDContrato]
FROM CAD_TEMP CAD
INNER JOIN Dados.Proposta PRP
ON PRP.NumeroProposta = CAD.NumeroPropostaTratado
INNER JOIN Dados.Contrato C
ON C.[NumeroContrato] = CAD.[NumeroApolice]
and C.IDSeguradora = PRP.IDSeguradora
WHERE PRP.IDSeguradora = 1
) X
ON 
 T.ID = X.[IDProposta]
WHEN MATCHED
        THEN UPDATE SET IDContrato = X.IDContrato
        
        
 /*ATUALIZA PROPOSTAS LOCALIZADAS - POR NÚMERO DE CERTIFICADO*/     
;MERGE INTO Dados.Proposta AS T
USING	
(SELECT DISTINCT
       CAD.[NumeroApolice]
     , PRP.ID [IDProposta]
     , C.ID [IDContrato]
FROM CAD_TEMP CAD
INNER JOIN Dados.Proposta PRP
ON PRP.NumeroProposta = CAD.NumeroCertificadoTratado
INNER JOIN Dados.Contrato C
ON C.[NumeroContrato] = CAD.[NumeroApolice]
and C.IDSeguradora = PRP.IDSeguradora
WHERE PRP.IDSeguradora = 1
) X
ON 
 T.ID = X.[IDProposta]
WHEN MATCHED
        THEN UPDATE SET IDContrato = X.IDContrato; 
       	
print '5'       	


/*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
;MERGE INTO Dados.Certificado AS T
USING (
        SELECT *
	        FROM
	        (
            SELECT 
                   CNT.ID [IDContrato], PRP.ID [IDProposta], CAD.[NumeroCertificadoTratado], 1 [IDSeguradora]
                 , UA.ID [IDAgencia] , CASE WHEN CAD.NomeCliente IS NULL OR CAD.NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' ELSE CAD.[NomeCliente] END [NomeCliente]
                 , /*@PontoDeParada*/ CAD.[DataArquivo], 'FN0710B.COMISSAO.CADASTRO' [Arquivo]
              , ROW_NUMBER() OVER (PARTITION BY IDContrato, PRP.ID, CAD.NumeroCertificadoTratado 
                          ORDER BY IDContrato, PRP.ID, CAD.NumeroCertificadoTratado, CAD.CodigoPontoVenda DESC) [ROWNUMBER]
            FROM CAD_TEMP CAD
              INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = CAD.NumeroApolice
              LEFT JOIN Dados.Unidade UA
              ON UA.Codigo = CAD.CodigoPontoVenda
              LEFT JOIN Dados.Proposta PRP
              ON CAD.NumeroCertificadoTratado = PRP.NumeroProposta
			  AND PRP.IDSeguradora = 1
            WHERE CAD.NumeroCertificadoTratado IS NOT NULL
            ) A
            WHERE A.[ROWNUMBER] = 1
      ) AS X
ON  X.[NumeroCertificadoTratado] = T.[NumeroCertificado]
AND X.[IDSeguradora] = T.[IDSeguradora]
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
              [NumeroCertificado]
            , [NomeCliente]  
            , [IDSeguradora]
            , [IDContrato]
            , [IDProposta]
            , [IDAgencia]
            , [DataArquivo]
            , [Arquivo])
      VALUES (   
              X.[NumeroCertificadoTratado]
            , X.[NomeCliente]
            , X.[IDSeguradora]
            , X.[IDContrato]
            , X.[IDProposta]
            , X.[IDAgencia]
            , X.[DataArquivo]
            , X.[Arquivo]); 	

/*INSERE CERTIFICADOS NÃO LOCALIZADOS NA TABELA DE CERTIFICADO HISTÓRICO*/	
;MERGE INTO Dados.CertificadoHistorico AS T
USING (
        SELECT DISTINCT C.ID [IDCertificado], CAD.CodigoSubgrupoRamoVida, Cast(CAD.NumeroEndosso as varchar(20)) [NumeroProposta]
                     , 0 [ValorPremioTotal], 0 [ValorPremioLiquido]
                     , /*@PontoDeParada*/ CAD.[DataArquivo], 'FN0710B.COMISSAO.CADASTRO' [Arquivo]
        FROM Dados.Certificado C
        INNER JOIN CAD_TEMP CAD
        ON CAD.NumeroCertificadoTratado = C.NumeroCertificado
        WHERE NOT EXISTS (SELECT * 
                          FROM Dados.CertificadoHistorico CH            
                          WHERE CH.IDCertificado = C.ID)
      ) AS X
ON  X.[IDCertificado] = T.[IDCertificado]
AND X.[NumeroProposta] = T.[NumeroProposta]
AND X.[DataArquivo] = T.[DataArquivo]
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
              [IDCertificado]
            , [CodigoSubEstipulante]
            , [NumeroProposta]
            , [ValorPremioTotal]
            , [ValorPremioLiquido]
            , [DataArquivo]
            , [Arquivo])
      VALUES (   
              X.[IDCertificado]
            , X.[CodigoSubgrupoRamoVida]
            , X.[NumeroProposta]
            , X.[ValorPremioTotal]
            , X.[ValorPremioLiquido]
            , X.[DataArquivo]
            , X.[Arquivo]
            );

            

print '6'
               
/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
;MERGE INTO Dados.Produto AS T
USING (
    SELECT DISTINCT
           CAD.CodigoProduto 
    FROM CAD_TEMP CAD
    WHERE CAD.CodigoProduto IS NOT NULL
      ) AS X
ON  T.[CodigoComercializado] = Cast(X.CodigoProduto as varchar(5))
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           CodigoComercializado
          )
      VALUES (   
              X.[CodigoProduto]);                                   
        
print '7'                  
               
/*INSERE AS OPERAÇÕES DE COMISSAO NÃO LOCALIZADAS*/	
;MERGE INTO Dados.ComissaoOperacao AS T
USING (
    SELECT DISTINCT
           CAD.CodigoOperacao 
    FROM CAD_TEMP CAD
    WHERE CAD.CodigoOperacao IS NOT NULL
      ) AS X
ON  X.CodigoOperacao = T.[Codigo]
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           Codigo
          )
      VALUES (   
              X.[CodigoOperacao]);
    
print '8'    
    
/*INSERE OS PRODUTORES NÃO LOCALIZADOS*/	
;MERGE INTO Dados.Produtor AS T
USING (
    SELECT DISTINCT
           CAD.[CodigoProdutor] 
    FROM CAD_TEMP CAD
    WHERE CAD.[CodigoProdutor] IS NOT NULL
      ) AS X
ON  X.[CodigoProdutor] = T.[Codigo]
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           Codigo
          )
      VALUES (   
              X.[CodigoProdutor]);                     

print '9'

/*INSERE AS FILIAIS DE FATURAMENTO NÃO LOCALIZADAS*/
;MERGE INTO Dados.FilialFaturamento AS T
	USING (
      SELECT DISTINCT
             CAD.[CodigoFilialProposta] 
      FROM CAD_TEMP CAD
      WHERE CAD.[CodigoFilialProposta] IS NOT NULL
        ) AS X
  ON  X.[CodigoFilialProposta] = T.[Codigo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             Codigo
            )
        VALUES (   
                X.[CodigoFilialProposta]);  

print '10'

/*INSERE OS RAMOS DE FATURAMENTO NÃO LOCALIZADOS*/
;MERGE INTO Dados.Ramo AS T
	USING (
      SELECT DISTINCT
             CAD.CodigoRamo 
      FROM CAD_TEMP CAD
      WHERE CAD.CodigoRamo IS NOT NULL
        ) AS X
  ON  X.CodigoRamo = T.[Codigo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             Codigo
            )
        VALUES (   
                X.CodigoRamo);

print '11'

/*INSERE A COMBINAÇÃO DE PRODUTO COM RAMOS DE FATURAMENTO NÃO LOCALIZADOS*/
;MERGE INTO Dados.ProdutoRamo AS T
	USING (
      SELECT DISTINCT
             P.ID [IDProduto], R.ID [IDRamo]
      FROM CAD_TEMP CAD
      INNER JOIN Dados.Ramo R
      ON R.Codigo = CAD.CodigoRamo
      INNER JOIN Dados.Produto P
      ON P.CodigoComercializado = CAD.CodigoProduto
      WHERE CAD.CodigoRamo IS NOT NULL
        ) AS X
  ON  X.IDProduto = T.IDProduto
  AND X.[IDRamo] = T.[IDRamo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             IDProduto, IDRamo
            )
        VALUES (   
                X.[IDProduto], X.[IDRamo]);   
                 
print '12';            
     
--COMMIT TRAN;

--BEGIN TRAN;
        
--DISABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
/*LIMPA OS DADOS DO MESMO PERÍODO (DIA)*/
DELETE FROM Dados.Comissao_Partitioned 
WHERE DataRecibo = Cast(@PontoDeParada as Date)
  AND LancamentoManual = 0
  AND IDEmpresa = 15; --Riscos Especiais


print '13';		   


/*CARREGA A TABELA DE COMISSÃO*/    
INSERT INTO Dados.Comissao_Partitioned
(
IDRamo,
PercentualCorretagem,
ValorCorretagem,
ValorBase,
DataRecibo,
DataCompetencia,
ValorComissaoPAR,
ValorRepasse,
NumeroRecibo,
NumeroEndosso,
NumeroParcela,
DataCalculo,
DataQuitacaoParcela,
TipoCorretagem,
IDContrato,
IDCertificado,
IDOperacao,
IDProdutor,
IDFilialFaturamento,
CodigoSubgrupoRamoVida,
IDProduto,                                               --SELECT Cast(8 * (6.8800 - 1.3800) / 6.88 as decimal(38,4)) [5.500],  Cast(8 * (1.38) / 6.88 as decimal(38,4)) [1.38]
IDUnidadeVenda,
IDProposta,
Arquivo,
DataArquivo,
IDEmpresa
)  
SELECT R.ID [IDRamo], CAD.PercentualCorretagem, CAD.ValorCorretagem * CO.SinalOperacao,
       CAD.ValorBase * CO.SinalOperacao, CAD.DataRecibo, CAD.DataRecibo [DataCompetencia], --CAD.ValorBaseCERT, CAD.ValorPremioAP, CAD.ValorPremioVG, CAD.ValorBaseAgrupado,    /**/
       /*********************************************************************************************************************************************************/
       /*APLICAÇÃO DE REGRA DE 3 PARA DISTRIBUIR COMISSÃO E REPASSE*/ 
       /*********************************************************************************************************************************************************/
     
        ((CAD.ValorCorretagem * CO.SinalOperacao * /*MULTIPLICADO PELA COMISSAO DA PAR (PRIORITARIAMENTE) OU PELA TAXA DE CORRETAGEM (CS) MENOS A TAXA DE REPASSE*/
                                         CASE /*PEGA A TAXA DE CORRETAGEM, PRIORIZANDO O VALOR INSERIDO NA TABELA DE PRODUTO (HISTÓRICO ÚLTIMO STATUS)*/
                                             WHEN ISNULL(PH.PercentualCorretora,0.00) = 0.00  THEN (ISNULL(CAD.PercentualCorretagem, 0.00) - ISNULL(PH.PercentualRepasse,0.00)) 
                                             ELSE PH.PercentualCorretora 
                                         END) 
                                         / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
                   CASE WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
                        WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
                        ELSE ISNULL(CAD.PercentualCorretagem, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/ [ValorComissaoPAR], 
       /*********************************************************************************************************************************************************/
       /*********************************************************************************************************************************************************/
       /*CALCULA O REPASSE*/
       /*********************************************************************************************************************************************************/
       ((CAD.ValorCorretagem * CO.SinalOperacao * PH.PercentualRepasse)
             / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
              CASE WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
              WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
              ELSE ISNULL(CAD.PercentualCorretagem, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/ [ValorRepasse],
       /*********************************************************************************************************************************************************/ 
       CAD.NumeroRecibo, CAD.NumeroEndosso, CAD.NumeroParcela, CAD.DataCalculo, CAD.DataQuitacaoParcela,
       CAD.TipoCorretagem, CNT.ID [IDContrato], CRT.ID [IDCertificado], CO.ID [IDOperacao],
       PTR.ID [IDProdutor], FF.ID [IDFilialFaturamento], CAD.CodigoSubgrupoRamoVida,
       PRD.ID [IDProduto], U.ID [IDUnidadeVenda], COALESCE(PRP.ID, CRT.IDProposta) [IDProposta], 'FN0710B' [Arquivo],  CAD.DataArquivo,
	   IDEmpresa
       --CAD.NumeroPropostaTratado [NumeroProposta], CAD.NumeroCertificadoTratado [NumeroCertificado]
FROM CAD_TEMP [CAD]
INNER JOIN Dados.FilialFaturamento FF
ON FF.Codigo = CAD.CodigoFilialProposta
INNER JOIN Dados.Produto PRD
ON PRD.CodigoComercializado = CAD.CodigoProduto
INNER JOIN Dados.ComissaoOperacao CO
ON CO.Codigo = CAD.CodigoOperacao
INNER JOIN Dados.Contrato CNT
ON CNT.NumeroContrato = CAD.NumeroApolice
--AND CNT.IDSeguradora = 1 /*CaixaSeguros - ##TODO##*/
INNER JOIN Dados.Produtor PTR
ON PTR.Codigo = CAD.CodigoProdutor
/*Alterado no dia 01/10/2013 para pegar a última configuração de comissão com base na (datafim da configuração) X (DataCalculo comissão)*/
OUTER APPLY (SELECT TOP 1  PH.PercentualRepasse, PH.PercentualCorretora, PH.DataInicio, PH.DataFim 
             FROM Dados.ProdutoHistorico PH 
             WHERE PH.IDProduto = PRD.ID --AND PH.DataFim IS NULL
			 AND  CAD.DataCalculo <= ISNULL(PH.DataFim, '9999-12-31')
             ORDER BY PH.IDProduto ASC, PH.DataFim DESC) PH
LEFT JOIN Dados.Unidade U
ON U.Codigo = CAD.CodigoPontoVenda
LEFT JOIN Dados.Ramo R
ON R.Codigo = CAD.CodigoRamo 
OUTER APPLY (SELECT TOP 1 CRT.ID, CRT.IDProposta
             FROM Dados.Certificado CRT
             WHERE CRT.NumeroCertificado = CAD.NumeroCertificadoTratado
             AND CRT.IDSeguradora = 1
             ORDER BY CRT.IDContrato DESC) CRT --COLLATE SQL_Latin1_General_CP1_CI_AI) CRT 
LEFT JOIN Dados.Proposta PRP
ON PRP.NumeroProposta = CASE WHEN     (CAD.NumeroPropostaTratado IS null OR CAD.NumeroPropostaTratado = '0') 
                                   AND CAD.NumeroCertificadoTratado IS NOT NULL  THEN CAD.NumeroCertificadoTratado
								             ELSE CAD.NumeroPropostaTratado
							          END-- COLLATE SQL_Latin1_General_CP1_CI_AI
--AND PRP.IDSeguradora = 1 ##TODO##
  ;
print '14';
 
/*CALCULA OS CANAIS DE VENDA DA DATA*/
   BEGIN TRY     
	   /*CALCULA OS CANAIS DE VENDA DA DATA*/
	   EXEC Dados.proc_AtualizaCanalVendaPAR_Comissao @DataRecibo = @PontoDeParada, @ForcarAtualizacaoCompleta = 0;

   END TRY
   BEGIN CATCH
     PRINT @@ERROR
   END CATCH

   --;ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;

--COMMIT TRAN
print '15';       /*					   r
         DECLARE @PontoDeParada AS DATE  = '20130430'
DECLARE @COMANDO AS NVARCHAR(4000);  */
--BEGIN TRAN
DELETE FROM Dados.Recomissao 
WHERE DataArquivo = Cast(@PontoDeParada as Date)
AND IDEmpresa = 15;	--Riscos Especiais

print '16';
	-- DECLARE @COMANDO NVARCHAR(4000)
/*CARREGA A TABELA DE RECOMISSÃO*/
SET @COMANDO =   
'INSERT INTO Dados.Recomissao 
(IDProdutor,
 NumeroRecibo,
 --IDFilialFaturamento,
 ValorCorretagem,
 ValorAdiantamento,
 ValorRecuperacao,
 ValorISS,
 ValorIRF,
 ValorAIRE,
 ValorLiquido,
 NomeArquivo,
 DataArquivo,
 IDEmpresa
)
SELECT PTR.Id [IdProdutor],
       RF.NumeroRecibo,
       --FF.ID [IDFilialFaturamento],
	   RF.ValorCorretagem,
       RF.ValorAdiantamento,
	   RF.ValorRecuperacao,
       RF.ValorISS, 
	   RF.ValorIRF,
       RF.ValorAIRE, 
	   RF.ValorLiquido,
       RF.NomeArquivo,
	   RF.DataArquivo,
	   RF.[IDEmpresa] --15 PAR Riscos Especiais 
FROM
OPENQUERY ([OBERON], ''SELECT *, 15 [IDEmpresa]	  /*15 PAR Riscos Especiais*/
                      FROM FENAE.dbo.COMISSAO_GERAL_RE RF 
                      WHERE RF.DataArquivo = ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') RF 
INNER JOIN Dados.Produtor PTR
ON RF.CodigoProdutor =  PTR.Codigo
--INNER JOIN Dados.FilialFaturamento FF
--ON RF.CodigoFonte =  FF.Codigo
'

exec sp_executesql @COMANDO;		 

print '17';
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'COMISSAO_RE'
  /*************************************************************************************/
  
print '18'  

  /*************************************************************************************/
  /*INSERE O DIA PARA CONTROLE DE EXPORTAÇÃO DE FATURAMENTO PARA A BASE INTERMEDIÁRIA */
  /*************************************************************************************/
  ;MERGE INTO ControleDados.ExportacaoFaturamento AS T
	  USING (
        SELECT DISTINCT DataRecibo, NumeroRecibo, DataRecibo [DataCompetencia], IDEmpresa
        FROM dbo.CAD_TEMP [PontoDeParada]
          ) AS X
    ON  X.DataRecibo = T.DataRecibo
    AND X.NumeroRecibo = T.NumeroRecibo
    AND X.DataCompetencia = T.DataCompetencia
	AND X.IDEmpresa = T.IDEmpresa
       WHEN NOT MATCHED  
		      THEN INSERT          
              (   
               DataRecibo,
               NumeroRecibo,
               DataCompetencia,
			   IDEmpresa
              )
          VALUES (   
                  X.DataRecibo,
                  X.NumeroRecibo,
                  X.DataCompetencia,
				  X.IDEmpresa);  
  /*************************************************************************************/

print '19'
  TRUNCATE TABLE [dbo].[CAD_TEMP];
   /*
  /*************************************************************************************/
  /*Atualiza o produto por meio do produto da proposta recebida pela COMISSÃO*/
  /*************************************************************************************/
  UPDATE Dados.Proposta SET IDProduto = C.IDProduto
  --SELECT *
  FROM Dados.Proposta PRP
  INNER JOIN
  (
  SELECT DISTINCT IDProposta, IDProduto
  FROM Dados.Comissao C
  WHERE C.DataArquivo = Cast(@PontoDeParada as Date)
  AND C.IDProduto IS NOT NULL
  AND C.IDProduto NOT IN (-1, 193) /*Produtos de controle interno*/
  )C
  ON C.IDProposta = PRP.ID
  AND (PRP.IDProduto IS NULL OR PRP.IDProduto <> C.IDProduto)
  /*************************************************************************************/
print '20'  	  */

  /*************************************************************************************/
  --Data: 2013/11/06
  --Atualiza o ID do Contrato na Proposta
  /*************************************************************************************/
  UPDATE Dados.Proposta SET IDContrato = CM.IDContrato
  FROM Dados.Proposta PRP
  INNER JOIN Dados.Comissao CM
  ON CM.IDProposta = PRP.ID
  WHERE CM.DataArquivo = Cast(@PontoDeParada as Date)
  and (
       PRP.IDContrato <> CM.IDContrato
    OR PRP.IDContrato IS NULL) 	  
  /*************************************************************************************/
print '21'  
  /*************************************************************************************/
  --Data: 2013/11/06
  --Atualiza o ID do Contrato no Certificadoo
  /*************************************************************************************/
  UPDATE Dados.Certificado SET IDContrato = CM.IDContrato
  FROM Dados.Certificado CT
  INNER JOIN Dados.Comissao CM
  ON CM.IDCertificado = CT.ID
  WHERE CM.DataArquivo = Cast(@PontoDeParada as Date)	
  and (
       CT.IDContrato <> CM.IDContrato
    OR CT.IDContrato IS NULL) 
  /*************************************************************************************/
 print '22'  
  /*************************************************************************************/
  --Data: 2013/11/06
  --Atualiza o ID da Proposta na comissao
  /*************************************************************************************/
  UPDATE Dados.Comissao_Partitioned SET IDProposta = CRT.IDProposta
  FROM Dados.Comissao CM--Dados.Comissao_Partitioned CM
  INNER JOIN Dados.Certificado CRT
  ON CRT.ID = CM.IDCertificado
  WHERE CM.DataArquivo = Cast(@PontoDeParada as Date)
    AND  EXISTS (SELECT *
				 FROM CAD_TEMP CAD
				 WHERE CRT.NumeroCertificado = CAD.NumeroCertificadoTratado
				   AND CRT.IDSeguradora = 1
				);
   /*************************************************************************************/
  
  --COMMIT TRAN
print '23'  
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAD_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[CAD_TEMP];
	
print '24'	


END TRY
BEGIN CATCH
  --ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
   --ROLLBACK TRAN

  EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

