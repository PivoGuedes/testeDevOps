


/*
	Autor: Egler Vieira
	Data Criação: 21/01/2013

	Descrição: 
	
	Última alteração : 18/02/2013 - Inserção do calculo do canal de venda
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereComissao_DC0701
	Descrição: Procedimento que realiza a inserção dos lançamentos de comissão.
		
	Parâmetros de entrada:	
		SELECT * FROM [dbo].[CAD_TEMP]			
	Retorno:
	[Dados].[proc_InsereComissao_DC0701] '20160303'
OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
*/
CREATE PROCEDURE [Dados].[proc_InsereComissao_DC0701](@DataComissao DATE = NULL) 
AS

BEGIN TRY

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAD_TEMP]') AND type in (N'U'))
BEGIN
	--DROP TABLE [dbo].[CAD_TEMP];
  
  RAISERROR (N'A tabela temporária [CAD_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
              16, -- Severity.
              1 -- State.
            )
END 
--select * from CAD_TEMP
--DECLARE @DataComissao DATE = '20160407'
--DROP TABLE [dbo].[CAD_TEMP];
DECLARE @PontoDeParada AS DATE -- = '2012-12-03'
DECLARE @COMANDO AS NVARCHAR(4000);
DECLARE @MaiorCodigo AS DATE;
DECLARE @ParmDefinition NVARCHAR(500);
                   
/*Cria tabela temporária para carregar os dados que vem da base primária*/
CREATE TABLE CAD_TEMP
   (  		
    Codigo                      int,                                                                          
    CodigoEmpresa               varchar(5),			
	DataCalculo                 date,             																   	
	DataRecibo                  date,         
	DataCompetencia  			date,										   	
	CodigoFilial                smallint,       													   	
	CodigoFilialProposta        smallint,       													
	CodigoOperacao              smallint,          												
	CodigoPontoVenda            smallint,       													
	CodigoRamo                  smallint,          												
	NumeroParcela               smallint,       													
	CodigoProduto               varchar(5),        												
	TipoCorretagem              smallint,       													
	CodigoProdutor              int,             													
	CodigoSubgrupoRamoVida      int,       															
	NomeCliente                 varchar(140),      												   
	NumeroContrato               varchar(20),   														
	[NumeroBilhete]             numeric(15,0),     
	[NumeroTitulo]              numeric(15,0),
	[NumeroSerieTitulo]         numeric(15,0),
	[IndicadorTipoContribuicao] numeric(15,0),
	[Grupo]                     numeric(15,0),
	[NumeroCota]                numeric(15,0),
	NumeroEndosso               numeric(9,0),    																
	NumeroProposta              numeric(16,0),																	
	NumeroPropostaTratado       as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,			
	NumeroPropostaInterno       numeric(16,0),																						
	NumeroCertificado           numeric(15,0),																	
	NumeroCertificadoTratado    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as   varchar(20)) PERSISTED,			
	NumeroReciboOriginal        BIGINT,           
	NumeroRecibo                BIGINT,       						
	PercentualCorretagem        numeric(5,2),      												
	ValorBase                   numeric(20,6),         											
	ValorCorretagem             numeric(20,6),         											
	DataQuitacaoParcela         date,                   
	[RangeCEP]					bigint,	
	[AliquotaISS]               numeric(5,2),			
	[NomeArquivo]		        varchar(200),
 	DataArquivo                 date,
	IDSeguradora               as Cast(CASE CodigoEmpresa   
										WHEN '00003' THEN 1
										WHEN '00005' THEN 4
					  					WHEN '00004' THEN 3
										WHEN '00006' THEN 5
										WHEN '00001' THEN 1
										WHEN '00002' THEN 1
										ELSE 
											CASE WHEN Cast(CodigoProduto as int) > 9400 THEN 4
												WHEN Cast(CodigoProduto as int) BETWEEN 9201 AND 9250 THEN 4 
												WHEN Cast(CodigoProduto as int) BETWEEN 5501 AND 5627 THEN 4 
												WHEN Cast(CodigoProduto as int) = 60 THEN 5
												WHEN Cast(CodigoProduto as int) BETWEEN 222 AND 413 THEN 3  
												WHEN Cast(CodigoProduto as int) BETWEEN 1403 AND 3180 THEN 1 
												WHEN Cast(CodigoProduto as int) IN (3709, 5302, 7701, 7709, 8105,8203, 8205, 8209) THEN 0  
												WHEN Cast(CodigoProduto as int) BETWEEN 9311 AND 9361 THEN 0 
												WHEN Cast(CodigoProduto as int) IN (6814,7114, 8112, 8113, 8201) THEN 1 
											ELSE
											0
											END
										END as smallint) PERSISTED,
						   );															
   
   
--'00001' DIRVI - Vida
--'00002' DISEF - Prestamista
--'00003' DIRID - Ríscos
--'00004' DICAP - Capitalização
--'00005' DIPREV - Prev 
--'00006' DICON - Consórcio

																																
 /*Cria alguns índices para facilitar a busca*/  																					
CREATE CLUSTERED INDEX idx_CLProposta ON CAD_TEMP																					
( 																																	
NumeroContrato,																														
NumeroEndosso,																														
CodigoProduto,																														
CodigoOperacao																														
);

CREATE NONCLUSTERED INDEX idx_NCLFilialProposta ON CAD_TEMP
(
  CodigoFilialProposta
);


CREATE NONCLUSTERED INDEX idx_NCL_NumeroPropostaTratado	ON [dbo].[CAD_TEMP]
 ([NumeroPropostaTratado])
INCLUDE ([NomeCliente])


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


CREATE NONCLUSTERED INDEX idx_NCLContrato ON CAD_TEMP
(
  NumeroContrato
);                                                                       

IF @DataComissao IS NULL
BEGIN
  SELECT @PontoDeParada = Cast(PontoParada as date)
  FROM ControleDados.PontoParada
  WHERE NomeEntidade = 'COMISSAO';
  
  
  SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

  SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
                FROM OPENQUERY ([OBERON], 
                '' SELECT MAX(DataArquivo) [MaiorData]
                   FROM FENAE.dbo.[vw_COMISSAO_ANALIT_SIGDC]
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

print '1'    
      
  
WHILE @PontoDeParada <= @MaiorCodigo AND @PontoDeParada >= '20160101'/*'2012-12-31'*/
BEGIN 

--BEGIN TRAN
--DECLARE @PontoDeParada AS DATE  = '2014-02-19'
--DECLARE @COMANDO AS NVARCHAR(4000);
--DECLARE @MaiorCodigo AS DATE;
--DECLARE @ParmDefinition NVARCHAR(500);

;SET @COMANDO =   
'INSERT INTO CAD_TEMP (	
	Codigo                    ,                                                                  
    CodigoEmpresa              ,		
	DataCalculo                ,     																   	
	DataRecibo                 ,   													   	
	CodigoFilial               ,   													   	
	CodigoFilialProposta       ,   													
	CodigoOperacao             ,      												
	CodigoPontoVenda           ,   													
	CodigoRamo                 ,      												
	NumeroParcela              ,   													
	CodigoProduto              ,      												
	TipoCorretagem             ,   													
	CodigoProdutor             ,    													
	CodigoSubgrupoRamoVida     ,														
	NomeCliente                ,      												   
	NumeroContrato              ,  														
	[NumeroBilhete]            ,
	[NumeroTitulo]             ,
	[NumeroSerieTitulo]        ,
	[IndicadorTipoContribuicao],
	[Grupo]                    ,
	[NumeroCota]               ,
	NumeroEndosso              ,															
	NumeroProposta             ,															
	NumeroPropostaInterno      ,																				
	NumeroCertificado          ,															
	NumeroReciboOriginal       , 								
	PercentualCorretagem       ,											
	ValorBase                  , 											
	ValorCorretagem            , 											
	DataQuitacaoParcela        , 
	[RangeCEP]				   ,
	[AliquotaISS]              ,			
	[NomeArquivo]		       ,
	DataArquivo
)       
SELECT 	
	Codigo                     ,      
	CodigoEmpresa              ,	
	DataCalculo                ,     
	DataRecibo                 ,   	
	CodigoFilial               ,   	
	CodigoFilialProposta       ,   	
	CodigoOperacao             ,     
	CodigoPontoVenda           ,   	
	CodigoRamo  ,     
	NumeroParcela              ,   	
	CodigoProduto              ,     
	TipoCorretagem             ,   	
	CodigoProdutor             ,    
	CodigoSubgrupoRamoVida     ,	
	NomeCliente                ,     
	NumeroContrato             ,  	
	[NumeroBilhete]            ,
	[NumeroTitulo]             ,
	[NumeroSerieTitulo]        ,
	[IndicadorTipoContribuicao],
	[Grupo]                    ,
	[NumeroCota]               ,
	NumeroEndosso              ,	
	NumeroProposta             ,	
	NumeroPropostaInterno      ,	
	NumeroCertificado          ,	
	NumeroRecibo               , 	
	PercentualCorretagem       ,	
	ValorBase                  , 	
	ValorCorretagem            , 	
	DataQuitacaoParcela        , 
	[RangeCEP]				   ,
	[AliquotaISS]              ,	
	[NomeArquivo]		       ,
	DataArquivo
FROM  OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaComissaoAnalitico] ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') CAD'

;exec sp_executesql @COMANDO

--COMMIT TRAN
print '2'
--BEGIN TRAN
                  --,@ParmDefinition
                  --,@MaiorCodigo = @MaiorCodigo OUTPUT
--              delete FROM CAD_TEMP WHERE CodigoProduto  NOT in ( 223	,
--413	,
--5512,
--5517,
--5548,
--5557,
--5559,
--5562,
--5563,
--5564,
--5608,
--5627,
--5630,
--9405,
--9407)
	--/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
	--;MERGE INTO Dados.Produto AS T
	--USING (
	--	SELECT DISTINCT
	--		   Cast(CAD.CodigoProduto as varchar(5)) CodigoProduto, CAD.IDSeguradora 
	--	FROM CAD_TEMP CAD
	--	WHERE CAD.CodigoProduto IS NOT NULL
	--	  ) AS X
	--ON  T.[CodigoComercializado] = X.CodigoProduto 
	--   WHEN MATCHED AND T.IDSeguradora IS NULL
	--		THEN UPDATE SET IDSeguradora = X.IDSeguradora;    

	/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
	;MERGE INTO Dados.Produto AS T
	USING (
		SELECT DISTINCT
			   CAD.CodigoProduto CodigoProduto, CAD.IDSeguradora 
		FROM CAD_TEMP CAD
		WHERE CAD.CodigoProduto IS NOT NULL
		  ) AS X
	ON  T.[CodigoComercializado] = X.CodigoProduto 
	AND ISNULL(T.IDSeguradora,X.IDSeguradora) = X.IDSeguradora
	   WHEN NOT MATCHED  
			THEN INSERT          
			  (   
			   CodigoComercializado, IDSeguradora
			  )
		  VALUES (   
				  X.[CodigoProduto], IDSeguradora)
	   WHEN MATCHED	AND T.IDSeguradora IS NULL
		     THEN UPDATE SET IDSeguradora = X.IDSeguradora;       

    
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
	--select *                                 --084842180001731
	--FROM CAD_TEMP EM where numerocertificado = 13526163 where NumeroPropostaTratado = '069999145169297'
				--SELECT DISTINCT EM.CodigoEmpresa, EM.[NumeroContrato], EM.[NumeroPropostaTratado], em.numerocertificado, 1 [IDSeguradora], PRD.ID [IDProduto], [NomeArquivo], [DataArquivo]
				--FROM CAD_TEMP EM
				--INNER JOIN Dados.Produto PRD
				--ON PRD.CodigoComercializado = EM.CodigoProduto
				--where not exists (select *
				--				  from dados.proposta prp
				--				 where 
				--		                 EM.NumeroPropostaTratado = prp.numeroproposta	and prp.idseguradora = 1
				--)
				--AND EM.NumeroPropostaTratado IS NOT NULL
	--BEGIN TRAN 
	--select * from cad_temp where IDSEGURADORA IS NULL numeropropostatratado =  '010673120000081'
	--select * from dados.Produto where id = 2
	--select * from dados.Produtopremiacao prd where prd.codigocomercializado in ('5536', '5601') -- prd.id in (276, 284)
	--SELECT * FROM DADOS.Proposta WHERE NumeroProposta = '084601770000422'
	--SELECT @@TRANCOUNT
	--ROLLBACK
		/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
		;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT EM.CodigoEmpresa, EM.[NumeroContrato], EM.[NumeroPropostaTratado], EM.[IDSeguradora], CASE WHEN EM.CodigoEmpresa = '00005' THEN NULL ELSE PRD.ID END [IDProduto], [NomeArquivo], [DataArquivo]
				FROM CAD_TEMP EM
				INNER JOIN Dados.Produto PRD
				ON PRD.CodigoComercializado = EM.CodigoProduto
				AND PRD.IDSeguradora = EM.IDSeguradora
				where not exists (select *
								  from dados.proposta prp
								 where 
						                 EM.NumeroPropostaTratado = prp.numeroproposta	and prp.idseguradora = EM.IDSeguradora
				)
				AND EM.NumeroPropostaTratado IS NOT NULL
				--and em.NumeroPropostaTratado = '010673120000081'
              ) X
        ON T.NumeroProposta = X.NumeroPropostaTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta,              [IDSeguradora],    IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora],                -1,  X.IDProduto,                0,              -1,                  0,           -1, 'COMISSAO', X.DataArquivo)		               
	   WHEN MATCHED	AND X.IDProduto IS NOT NULL																																		         
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
	      USING (SELECT DISTINCT PRP.ID [IDProposta], CASE WHEN NomeCliente IS NULL OR NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente],  EM.[NomeArquivo],  EM.[DataArquivo]
            FROM CAD_TEMP EM
            INNER JOIN Dados.Proposta PRP
            ON PRP.NumeroProposta = EM.NumeroPropostaTratado
            AND PRP.IDSeguradora = EM.IDSeguradora
            WHERE EM.NumeroPropostaTratado IS NOT NULL
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, X.NomeArquivo, X.[NomeCliente], X.[DataArquivo])
		               		               
		/*PRODUTOS DE VIDA COM CAPITAL GLOBAL EMPRESARIAL POSSUEM NÚMERO DE PROPOSTA DIFERENTE DO NÚMERO DO CERTIFICADO
		#REMOVIDO EM 06/11/2013 - EGLER
		#REINCLUÍDO EM 12/12/2013 após adaptar a solução para adicionando a condição da cláusula WHERE --### 2013-12-12:*/    
		           
	/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NÚMERO DE CERTIFICADO*/
		;MERGE INTO Dados.Proposta AS T
	      USING (select * from (SELECT DISTINCT EM.[NumeroContrato], EM.[NumeroCertificadoTratado], EM.[IDSeguradora], PRD.ID [IDProduto], EM.[NomeArquivo], EM.[DataArquivo],row_number() over(partition  by [NumeroCertificadoTratado] order by ValorCorretagem DESC) linha
				 FROM CAD_TEMP EM
					INNER JOIN Dados.Produto PRD
					ON PRD.CodigoComercializado = EM.CodigoProduto
					AND PRD.IDSeguradora = EM.IDSeguradora
					 INNER JOIN Dados.ProdutoSIGPF SIGPF
					 ON  SIGPF.ID = PRD.IDProdutoSIGPF
				WHERE EM.NumeroCertificadoTratado IS NOT NULL
				AND NOT (    ISNULL(SIGPF.ProdutoComCertificado,0) = 1	  --### 2013-12-12:  Gustavo/Egler/Diego -> Condição necessária para garantir que os produtos com o número da proposta diferente do número do 
						 AND ISNULL(SIGPF.ProdutoComContrato,0) = 1		  --certificado não sejam inseridos EQUIVOCADAMENTE como proposta, já que o número da proposta não existirá como número de certificado
						)			  
				--and em.NumeroCertificadoTratado <> '012348770096230'
				and EM.CodigoEmpresa <> '00005' -- PREV tem tratamento diferente para o certificado
					)y where linha = 1
              ) X
        ON T.NumeroProposta = X.NumeroCertificadoTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta,              [IDSeguradora],    IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.[NumeroCertificadoTratado], X.[IDSeguradora],                -1,  X.IDProduto,                0,              -1,                  0,           -1, X.NomeArquivo, X.DataArquivo)	
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
			  USING (SELECT DISTINCT PRP.ID [IDProposta], CASE WHEN NomeCliente IS NULL OR NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente], EM.[NomeArquivo], EM.[DataArquivo]
					FROM CAD_TEMP EM
						INNER JOIN Dados.Proposta PRP
						ON PRP.NumeroProposta = EM.NumeroCertificadoTratado
						AND PRP.IDSeguradora = EM.IDSeguradora
						INNER JOIN Dados.Produto PRD
						ON PRD.CodigoComercializado = EM.CodigoProduto
						AND PRD.IDSeguradora = EM.IDSeguradora
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
						   VALUES (X.IDProposta, NomeArquivo, X.[NomeCliente], X.[DataArquivo])

	/*INSERE CONTRATOS NÃO LOCALIZADOS*/
	;MERGE INTO Dados.Contrato AS T
	USING	
	(
	SELECT DISTINCT
		   CAD.[IDSeguradora] /*Caixa Seguros*/               
		 , CAD.[NumeroContrato]
		 --, CAD.NumeroCertificado
		 , /*@PontoDeParada*/ [DataArquivo]
		 , CAD.NomeArquivo [Arquivo]
	FROM CAD_TEMP CAD
	WHERE CAD.NumeroContrato IS NOT NULL
	) X
	ON T.[NumeroContrato] = X.[NumeroContrato]
	AND T.[IDSeguradora] = X.[IDSeguradora]
	WHEN NOT MATCHED
			THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
				 VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);   



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Clientes dos Contratos recebidos no arquivo EMISSAO
        
    ;MERGE INTO Dados.ContratoCliente AS T
		USING (
          select * from  ( SELECT DISTINCT
                     C.ID [IDContrato]
				   , EM.[IDSeguradora]    
                   , CASE WHEN NomeCliente IS NULL OR NomeCliente = '' or (NomeCliente <> '' AND NumeroCertificado IS NOT NULL) THEN 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' ELSE [NomeCliente] END [NomeCliente]
                   , C.[DataArquivo]
				   ,EM.NomeArquivo [Arquivo]
				   , row_number() over ( partition by C.ID order by c.ID) linha
            FROM [dbo].[CAD_TEMP] EM
              LEFT JOIN Dados.Contrato C
              ON  C.[NumeroContrato] = EM.[NumeroContrato]
              AND C.[IDSeguradora] = EM.IDSeguradora --C.[IDSeguradora]
              
             WHERE /*[RankContrato] = 1  
               AND */EM.[NumeroContrato] IS NOT NULL 
			   ) y where linha = 1
			   
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
	(select * from (
			SELECT DISTINCT
					CAD.[NumeroContrato]
					, PRP.ID [IDProposta]
					, C.ID [IDContrato]
					,ROW_NUMBER() OVER (PARTITION  BY PRP.Id order by PRP.ID) linha
			FROM CAD_TEMP CAD
			INNER JOIN Dados.Proposta PRP
			ON PRP.NumeroProposta = CAD.NumeroPropostaTratado
			INNER JOIN Dados.Contrato C
			ON C.[NumeroContrato] = CAD.[NumeroContrato]
			and C.IDSeguradora = PRP.IDSeguradora
			WHERE PRP.IDSeguradora = CAD.IDSeguradora
			) y where linha = 1
	) X
	ON 
	 T.ID = X.[IDProposta]
	WHEN MATCHED
			THEN UPDATE SET IDContrato = X.IDContrato
        
        
	 /*ATUALIZA PROPOSTAS LOCALIZADAS - POR NÚMERO DE CERTIFICADO*/     
	;MERGE INTO Dados.Proposta AS T
	USING	
	( select  * from (
		SELECT DISTINCT
			   CAD.[NumeroContrato]
			 , PRP.ID [IDProposta]
			 , C.ID [IDContrato]
			 , ROW_NUMBER() OVER (PARTITION BY PRP.Id  ORDER BY PRP.Id) linha
		FROM CAD_TEMP CAD
		INNER JOIN Dados.Proposta PRP
		ON PRP.NumeroProposta = CAD.NumeroCertificadoTratado
		INNER JOIN Dados.Contrato C
		ON C.[NumeroContrato] = CAD.[NumeroContrato]
		and C.IDSeguradora = PRP.IDSeguradora
		WHERE PRP.IDSeguradora = CAD.IDSeguradora
		AND CAD.CodigoEmpresa <> '00005' -- PREV tem tratamento diferente para o certificado
		) y where linha = 1
	) X
	ON 
	 T.ID = X.[IDProposta]
	WHEN MATCHED
			THEN UPDATE SET IDContrato = X.IDContrato; 
       	
print '5'       	

--SELECT * FROM DADOS.Certificado WHERE NumeroCertificado = '000095455422989'
--SELECT * FROM Dados.CertificadoHistorico WHERE idCertificado = 39527557
/*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
	;MERGE INTO Dados.Certificado AS T
	USING (
			SELECT *
				FROM
				(
				SELECT 
					   CNT.ID [IDContrato], PRP.ID [IDProposta], CAD.[NumeroCertificadoTratado], CAD.[IDSeguradora]
					 , UA.ID [IDAgencia] , CASE WHEN CAD.NomeCliente IS NULL OR CAD.NomeCliente = '' THEN 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' ELSE CAD.[NomeCliente] END [NomeCliente]
					 , /*@PontoDeParada*/ CAD.[DataArquivo], CAD.NomeARquivo [Arquivo]
				  , ROW_NUMBER() OVER (PARTITION BY IDContrato, PRP.ID, CAD.NumeroCertificadoTratado 
							  ORDER BY IDContrato, PRP.ID, CAD.NumeroCertificadoTratado, CAD.CodigoPontoVenda DESC) [ROWNUMBER]
				FROM CAD_TEMP CAD
				  INNER JOIN Dados.Contrato CNT
				  ON CNT.NumeroContrato = CAD.NumeroContrato
				  LEFT JOIN Dados.Unidade UA
				  ON UA.Codigo = CAD.CodigoPontoVenda
				  LEFT JOIN Dados.Proposta PRP
				  ON CAD.NumeroPropostaTratado = PRP.NumeroProposta
				  AND PRP.IDSeguradora = CAD.IDSeguradora
				WHERE CAD.NumeroCertificadoTratado IS NOT NULL
				  AND CAD.CodigoEmpresa <> '00005' -- PREV tem tratamento diferente para o certificado
				) A
				WHERE A.[ROWNUMBER] = 1
				--select * from dados.produto where codigoComercializado = '9343'
				--select * from dados.ProdutoHistorico where idproduto = 252
				--select * from dados.produtoSigpf where id = 11
				--SELECT * FROM CAD_TEMP WHERE NumeroCertificadoTratado = '000095487990109'
				--select * from dados.Proposta where NumeroProposta = '084111160000556'
		  ) AS X
	ON  X.[NumeroCertificadoTratado] = T.[NumeroCertificado]
	AND X.[IDSeguradora] = T.[IDSeguradora]
	AND X.IDProposta = T.IDProposta
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
	  --   WHEN MATCHED --AND T.[IDProposta] IS NULL
	  --	 THEN UPDATE SET [IDProposta] = X.IDProposta;    
            
            
	/*INSERE CERTIFICADOS NÃO LOCALIZADOS NA TABELA DE CERTIFICADO HISTÓRICO*/	
	;MERGE INTO Dados.CertificadoHistorico AS T
	USING (
			SELECT DISTINCT C.ID [IDCertificado], CAD.CodigoSubgrupoRamoVida, Cast(CAD.NumeroEndosso as varchar(20)) [NumeroProposta]
						 , 0 [ValorPremioTotal], 0 [ValorPremioLiquido]
						 , /*@PontoDeParada*/ CAD.[DataArquivo], CAD.NomeArquivo [Arquivo]
			FROM Dados.Certificado C
			INNER JOIN CAD_TEMP CAD
			ON CAD.NumeroCertificadoTratado = C.NumeroCertificado
			INNER JOIN Dados.Proposta PRP
			ON PRP.NumeroProposta = CAD.NumeroPropostaTratado
			AND C.IDProposta = PRP.ID
			AND PRP.IDSeguradora = CAD.IDSeguradora
			WHERE NOT EXISTS (SELECT * 
							  FROM Dados.CertificadoHistorico CH            
							  WHERE CH.IDCertificado = C.ID)
				  AND CAD.CodigoEmpresa <> '00005'
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
				 CAD.[CodigoFilial] 
		  FROM CAD_TEMP CAD
		  WHERE CAD.[CodigoFilial] IS NOT NULL
		  UNION ALL
		  SELECT DISTINCT
				 CAD.[CodigoFilial] * -1
		  FROM CAD_TEMP CAD
		  WHERE CAD.[CodigoFilial] IS NOT NULL
			) AS X
	  ON  X.[CodigoFilial] = T.[Codigo]
		 WHEN NOT MATCHED  
				THEN INSERT          
				(   
				 Codigo
				)
			VALUES (   
					X.[CodigoFilial]);  

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
				 PRD.ID [IDProduto], R.ID [IDRamo]
		  FROM CAD_TEMP CAD
		  INNER JOIN Dados.Ramo R
		  ON R.Codigo = CAD.CodigoRamo
		  INNER JOIN Dados.Produto PRD
		  ON PRD.CodigoComercializado = CAD.CodigoProduto
		 AND PRD.IDSeguradora = CAD.IDSeguradora
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
                     
     
--COMMIT TRAN;

--BEGIN TRAN;
        
	--DISABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
	/*LIMPA OS DADOS DO MESMO PERÍODO (DIA)*/



print '12';
	--Atualiza as Filiais com os critérios de ISS (para faturamento com a aliquota correta e considerando o substituto tributário
	
	UPDATE CAD_TEMP	SET CodigoFilial =
									 --CASE WHEN AliquotaISS = 0.00 THEN CodigoFilial * -1
										--  ELSE CASE WHEN FF.Codigo IS NOT NULL THEN FF.Codigo
										-- 		    ELSE 
										--				CodigoFilial * -1
										--		    END
										-- END 
										CASE WHEN AliquotaISS = 0.00 and c.IDSeguradora not in (3,4) THEN CodigoFilial * -1
											WHEN FF.Codigo IS NOT NULL and c.IDSeguradora not in (3,4) THEN FF.Codigo
											WHEN c.IDSeguradora in (3,4) AND ffc.ID is not null then 5
											WHEN c.IDSeguradora in (3,4) AND ffc.ID is null then -10
										 		    ELSE 
														CodigoFilial * -1
												    
										 END
	FROM CAD_TEMP C
	--LEFT JOIN Dados.FilialFaturamento FF
	--ON C.RangeCEP BETWEEN FF.RangeCEPInicio1 AND FF.RangeCEPFim1
	--	OR C.RangeCEP BETWEEN FF.RangeCEPInicio2 AND FF.RangeCEPFim2
	LEFT JOIN Dados.FilialFaturamentoRangeCEP FFc
	ON (C.RangeCEP BETWEEN FFc.RangeCEPInicio1 AND FFc.RangeCEPFim1
	OR C.RangeCEP BETWEEN FFc.RangeCEPInicio2 AND FFc.RangeCEPFim2)
	and FFc.IDSeguradora = c.IDSeguradora 
	LEFT JOIN Dados.FilialFaturamento FF
	ON FF.ID = FFc.IDFilialFaturamento;

print '13';
	--Cria número de registro artificial

	WITH CTE
	AS
	(SELECT  DataRecibo, CodigoEmpresa,  Cast(COUNT(DISTINCT NumeroReciboOriginal) as varchar(20)) + Cast(CodigoEmpresa as varchar(5)) [NumeroRecibo] --COUNT(DISTINCT NumeroReciboOriginal),
	FROM CAD_TEMP
	GROUP BY  DataRecibo, CodigoEmpresa
	)
	UPDATE CAD_TEMP SET NumeroRecibo = CTE.[NumeroRecibo]
	FROM CAD_TEMP C
	INNER JOIN CTE
	ON CTE.DataRecibo = C.DataRecibo
	AND CTE.CodigoEmpresa = C.CodigoEmpresa;


print '14';
	--Carrega a data de competência com a última (maior) data de recibo do arquivo
	DECLARE @DataCompetencia DATE = (SELECT  MAX(DataRecibo) DataCompetencia
								       FROM CAD_TEMP)

	UPDATE CAD_TEMP SET DataCompetencia = @DataCompetencia
	FROM CAD_TEMP C;


print '15';        

	DELETE FROM Dados.Comissao_Partitioned 
	WHERE DataCompetencia = @DataCompetencia
	  AND LancamentoManual = 0
	  AND IDEmpresa = 3;

print '16';
	--SELECT * FROM Dados.Comissao WHERE DataArquivo = '20160108'
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
	NumeroReciboOriginal,
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
	IDSeguradora,
--	IDCanalVendaPAR,
	NumeroProposta,
	IDEmpresa,
    [CodigoProdutor],
	CodigoProduto
	)  
	SELECT R.ID [IDRamo], CAD.PercentualCorretagem, CAD.ValorCorretagem,
		   CAD.ValorBase, CAD.DataRecibo, CAD.[DataCompetencia], 
		   --CAD.ValorBaseCERT, CAD.ValorPremioAP, CAD.ValorPremioVG, CAD.ValorBaseAgrupado,    /**/
		   /*********************************************************************************************************************************************************/
		   /*APLICAÇÃO DE REGRA DE 3 PARA DISTRIBUIR COMISSÃO E REPASSE*/ 
		   /*********************************************************************************************************************************************************/
		   CASE WHEN PH.PercentualRepasse IS NOT NULL AND PH.PercentualRepasse > 0.0 THEN
			((CAD.ValorCorretagem * /*MULTIPLICADO PELA COMISSAO DA PAR (PRIORITARIAMENTE) OU PELA TAXA DE CORRETAGEM (CS) MENOS A TAXA DE REPASSE*/
											 CASE /*PEGA A TAXA DE CORRETAGEM, PRIORIZANDO O VALOR INSERIDO NA TABELA DE PRODUTO (HISTÓRICO ÚLTIMO STATUS)*/
												 WHEN ISNULL(PH.PercentualCorretora,0.00) = 0.00  and ISNULL(CAD.PercentualCorretagem, 0.00) <> 0.00 THEN (ISNULL(CAD.PercentualCorretagem, 0.00) - ISNULL(PH.PercentualRepasse,0.00)) 
												 WHEN ISNULL(PH.PercentualCorretora,0.00) = 0.00 AND ISNULL(CAD.PercentualCorretagem, 0.00) = 0 THEN 1
												 ELSE PH.PercentualCorretora 
											 END)
											 / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
					   CASE WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
							WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
							ELSE ISNULL(CAD.PercentualCorretagem, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/ 
				 ELSE CAD.ValorCorretagem
				 END [ValorComissaoPAR],
		   /*********************************************************************************************************************************************************/
		   /*********************************************************************************************************************************************************/
		   /*CALCULA O REPASSE*/
		   /*********************************************************************************************************************************************************/
		   CASE WHEN PH.PercentualRepasse IS NOT NULL AND PH.PercentualRepasse > 0.0 THEN
		   ((CAD.ValorCorretagem * PH.PercentualRepasse)
				 / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
				  CASE WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
				  WHEN ISNULL(CAD.PercentualCorretagem, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
				  ELSE ISNULL(CAD.PercentualCorretagem, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/
				ELSE
				   0
				END [ValorRepasse],
		   /*********************************************************************************************************************************************************/ 
		   CAD.NumeroRecibo, CAD.NumeroReciboOriginal, CAD.NumeroEndosso, CAD.NumeroParcela, CAD.DataCalculo, CAD.DataQuitacaoParcela,
		   CAD.TipoCorretagem, CNT.ID [IDContrato], CRT.ID [IDCertificado], CO.ID [IDOperacao],
		   PTR.ID [IDProdutor], CASE WHEN CAD.NomeArquivo like '%21534365000176%' and CodigoProduto in ('7730','7731') THEN 83  ELSE FF.ID END AS [IDFilialFaturamento], CAD.CodigoSubgrupoRamoVida,
		   PRD.ID [IDProduto], U.ID [IDUnidadeVenda], COALESCE(PRP.ID, CRT.IDProposta) [IDProposta], CAD.NomeArquivo + ' - ' + CAD.CodigoEmpresa [Arquivo],  CAD.DataArquivo,
		   CAD.IDSeguradora,
		--   CASE WHEN CO.ID = 8 THEN 37 ELSE Dados.fn_CalculaCanalVendaPAR(CAD.NumeroPropostaTratado, CAD.CodigoProduto, NULL) END,
		   CAD.NumeroPropostaTratado [NumeroProposta],
		   CASE WHEN CAD.NomeArquivo like '%21534365000176%' THEN 52 ELSE 3 END IDEmpresa,
		   PTR.Codigo [CodigoProdutor],
		   PRD.CodigoComercializado
		   --CAD.NumeroPropostaTratado [NumeroProposta], CAD.NumeroCertificadoTratado [NumeroCertificado]
	--SELECT  SUM(CAD.ValorCorretagem)
	--select count(*)
	FROM CAD_TEMP [CAD]
	INNER JOIN Dados.FilialFaturamento FF
	ON FF.Codigo = CAD.CodigoFilial
	INNER JOIN Dados.Produto PRD
	ON PRD.CodigoComercializado = CAD.CodigoProduto
	AND PRD.IDSeguradora = CAD.IDSeguradora
	INNER JOIN Dados.ComissaoOperacao CO
	ON CO.Codigo = CAD.CodigoOperacao
	INNER JOIN Dados.Produtor PTR
	ON PTR.Codigo = CAD.CodigoProdutor
	LEFT JOIN Dados.Contrato CNT
	ON CNT.NumeroContrato = CAD.NumeroContrato
	AND CNT.IDSeguradora = CAD.IDSeguradora /*CaixaSeguros - ##TODO##*/
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
	LEFT JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = CAD.NumeroPropostaTratado--CASE WHEN     (CAD.NumeroPropostaTratado IS null OR CAD.NumeroPropostaTratado = '0') 
									 --  AND CAD.NumeroCertificadoTratado IS NOT NULL  THEN CAD.NumeroCertificadoTratado
									 --            ELSE CAD.NumeroPropostaTratado
									 --     END-- COLLATE SQL_Latin1_General_CP1_CI_AI
	AND PRP.IDSeguradora = CAD.IDSeguradora
	OUTER APPLY (SELECT TOP 1 CRT.ID, CRT.IDProposta
				 FROM Dados.Certificado CRT
				 WHERE CRT.NumeroCertificado = CAD.NumeroCertificadoTratado
				 AND CRT.IDSeguradora = CAD.IDSeguradora
				 AND CRT.IDProposta = PRP.ID
				 ORDER BY CRT.IDContrato DESC) CRT --COLLATE SQL_Latin1_General_CP1_CI_AI) CRT 
	--AND PRP.IDSeguradora = 1 ##TODO##
	--where crt.id is not null
	OPTION(MAXDOP 7)
	  ; --delete from dados.Comissao_Partitioned where dataarquivo = '20160108'

--SELECT *  FROM CAD_TEMP [CAD] WHERE NumeroPropostaTratado = '010881190000963'
--select * from dados.proposta where numeroproposta = '010881190000963'
/*CALCULA OS CANAIS DE VENDA DA DATA*/
   BEGIN TRY     
	   /*CALCULA OS CANAIS DE VENDA DA DATA*/
	   print '17';
	   
	   EXEC Dados.proc_AtualizaCanalVendaPAR_Comissao @DataRecibo = @DataCompetencia, @ForcarAtualizacaoCompleta = 0, @IDEmpresa = 3;
	   --EXEC Dados.proc_AtualizaCanalVendaPAR_Comissao @DataRecibo = '2016-04-05', @ForcarAtualizacaoCompleta = 0, @IDEmpresa = 3;

   END TRY
   BEGIN CATCH
     PRINT @@ERROR
   END CATCH
   
	--;ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
	--COMMIT TRAN
	print '18';       					   
	--		 DECLARE @PontoDeParada AS DATE  = '2016-04-07'
	--DECLARE @COMANDO AS NVARCHAR(4000);  
	--BEGIN TRAN
	DELETE FROM Dados.Recomissao 
	WHERE DataArquivo = Cast(@PontoDeParada as Date)
	AND IDEmpresa = 3;

	print '19';
	--COMMIT
	--	   DECLARE @DataComissao DATE
	--		DROP TABLE [dbo].[CAD_TEMP];
	--		DECLARE @PontoDeParada AS DATE = '2016-01-08'
	--		DECLARE @COMANDO AS NVARCHAR(4000);
	--		DECLARE @MaiorCodigo AS DATE;
	--		DECLARE @ParmDefinition NVARCHAR(500);

	/*CARREGA A TABELA DE RECOMISSÃO*/
	SET @COMANDO =   
	'INSERT INTO Dados.Recomissao 
	(IDProdutor,
	 NumeroRecibo,
	 IDFilialFaturamento,
	 ValorCorretagem,
	 ValorAdiantamento,
	 ValorRecuperacao,
	 ValorISS,
	 ValorIRF,
	 ValorAIRE,
	 ValorLiquido,
	 NomeArquivo,
	 DataArquivo
	)
	SELECT PTR.Id [IdProdutor], RF.NumeroRecibo,
		   FF.ID [IDFilialFaturamento], RF.ValorCorretagem,
		   RF.ValorAdiantamento, RF.ValorRecuperacao,
		   RF.ValorISS, RF.ValorIRF,
		   RF.ValorAIRE, RF.ValorLiquido,
		   RF.NomeArquivo, RF.DataArquivo
	FROM
	OPENQUERY ([OBERON], ''SELECT *
						  FROM FENAE.dbo.vw_DC0701_RECOMISS_FILIAL RF 
						  WHERE RF.DataArquivo = ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') RF 
	INNER JOIN Dados.Produtor PTR
	ON RF.CodigoProdutor =  PTR.Codigo
	INNER JOIN Dados.FilialFaturamento FF
	ON RF.CodigoFonte =  FF.Codigo'

	exec sp_executesql @COMANDO;     

print '20';
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'COMISSAO'
  /*************************************************************************************/
  
print '21'  

  /*************************************************************************************/
  /*INSERE O DIA PARA CONTROLE DE EXPORTAÇÃO DE FATURAMENTO PARA A BASE INTERMEDIÁRIA */
  /*************************************************************************************/
  ;MERGE INTO ControleDados.ExportacaoFaturamento AS T
	  USING (
        SELECT DISTINCT DataRecibo, NumeroRecibo, [DataCompetencia],   CASE WHEN CAD.NomeArquivo like '%21534365000176%' THEN 52 ELSE 3 END IDEmpresa
        FROM dbo.CAD_TEMP CAD
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
  
print '22'
  --TRUNCATE TABLE [dbo].[CAD_TEMP];
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
print '23'  
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
 print '24'  
  /*************************************************************************************/
  --Data: 2013/11/06
  --Atualiza o ID da Proposta na comissao
  /*************************************************************************************/
  UPDATE Dados.Comissao_Partitioned SET IDProposta = CRT.IDProposta
  FROM Dados.Comissao_Partitioned CM
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
print '25'  
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAD_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[CAD_TEMP];
	
print '26'	


END TRY
BEGIN CATCH
  --ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
   --ROLLBACK TRAN

  EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--EXEC [Dados].[proc_InsereComissao_DC0701] '2016-01-08'

