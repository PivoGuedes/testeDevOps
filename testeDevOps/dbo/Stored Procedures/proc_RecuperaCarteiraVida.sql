
CREATE Procedure proc_RecuperaCarteiraVida
AS

	IF(OBJECT_ID('tempdb..#PRP_VIDA') IS NOT NULL)
		DROP TABLE #PRP_VIDA;

	create table #PRP_VIDA
	(
		IDProposta BIGINT DEFAULT(0)
		,IDContrato BIGINT DEFAULT(0)
		,IDCertificado BIGINT DEFAULT(0)
		,IDContratoAnterior BIGINT DEFAULT(0)
	)
	
	CREATE CLUSTERED INDEX IDX_CL_IDContrato_IDProposta_IDCertificado ON #PRP_VIDA (IDCertificado, IDContrato, IDProposta,IDContratoAnterior);
	------Encontra contratos POR vigencia  pelo contrato
	;
	WITH CTE
	AS
	(
		SELECT CRT.IDContrato, CRT.ID, CRT.IDProposta,CNT.IDContratoAnterior, PRP.NumeroProposta, ROW_NUMBER() OVER (PARTITION BY CRT.NumeroCertificado ORDER BY CASE WHEN LEFT(PRP.NumeroProposta,2) = 'SN' THEN 1 ELSE 0 END, 
                           CASE WHEN LEFT(CRT.Arquivo,3) = 'SSD' THEN 0 ELSE 1 END) ORDEM,PRP.datafimvigencia
             FROM Dados.Certificado CRT
             LEFT JOIN Dados.Proposta PRP
             ON CRT.IDProposta = PRP.ID
             LEFT JOIN Dados.Produto PRD
             ON PRD.ID = PRP.IDProduto
             CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP 
             LEFT JOIN Dados.Contrato CNT
             ON CNT.ID = CRT.IDContrato
             LEFT JOIN Dados.PropostaCliente PRPC
             ON PRPC.ID = CRT.IDProposta
			 inner join Vincendos_vida v on PRP.NumeroProposta = v.PropostaTratada 
             --WHERE PRD.ID = 149
             WHERE RP.Codigo = '06'
     --               AND (
     --                      NOT EXISTS (
     --                                          SELECT *
     --                                          FROM Dados.CertificadoHistorico C
     --                                          WHERE C.IDCertificado = CRT.ID
     --                                          AND C.DataCancelamento IS NOT NULL
     --                                          )
     --                      OR CRT.DataCancelamento IS NULL
     --                      )
            AND DATEADD(MONTH,36,PRP.DataInicioVigencia) >= '2017-07-01'  
			and DATEADD(MONTH,36,PRP.DataInicioVigencia) <= '2017-12-30'
             AND PRD.ID in (145,146,149,222,230)

	)
	MERGE INTO #PRP_VIDA T
	USING
	(
		SELECT CTE.IDContrato, CTE.IDProposta, CTE.ID IDCertificado, IDContratoAnterior
		FROM CTE
		WHERE CTE.ORDEM = 1
	) AS S
	ON  T.IDContrato = S.IDContrato
	AND T.IDProposta >= S.IDProposta
	WHEN NOT MATCHED THEN
		INSERT (IDProposta, IDContrato, IDCertificado,IDContratoAnterior) 
		VALUES (isnull(S.IDProposta,0), isnull(S.IDContrato,0), isnull(S.IDCertificado,0),ISNULL(IDContratoAnterior,0));

	--CARREGA CONTRATO
	drop table Stage_SalesForce.Enqueue.[Contract_load_contract_VIDA];
	;
	with CTE
       as
       (
             SELECT  P.IDContrato 
                    , P.IDProposta
                    , P.IDCertificado
                    , CRT.NumeroCertificado
                    , PRP.NumeroProposta NumeroProposta
                    , CNT.NumeroContrato NumeroApolice
                    , PRP.DataProposta
                    , PRD.CodigoComercializado
                    , ISNULL(PRD.Descricao, '9300') [ProdutoComercializado]
                    , ISNULL(PRD.CodigoComercializado,'PRODUTO NAO ENCONTRADO') [CodigoProduto]
                    , PRD.Descricao [Produto]
                    , ProdutoAnterior.ProdutoAnterior
                    , ProdutoAnterior.CodigoProdutoAnterior
                    , dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(TRY_PARSE(REPLACE(REPLACE(PC.DDDCelular,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneCelular,')',''),'(','') AS INT))) TelCelular
                    , dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(TRY_PARSE(REPLACE(REPLACE(PC.DDDResidencial,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneResidencial,')',''),'(','') AS INT))) TelResidencial
                    , dados.fn_trataTelefoneSF(NULL,dados.fn_TrataNumeroTelefone(TRY_PARSE(REPLACE(REPLACE(PC.DDDComercial,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneComercial,')',''),'(','') AS INT))) TelComercial              
                    , COALESCE(v.[Inicio Vigência],PRP.DataInicioVigencia,CRT.DataInicioVigencia) DataInicioVigencia
                    , COALESCE(v.[Fim Vigência],PRP.DataFimVigencia,CRT.DataFimVigencia ) DataFimVigencia
                    , CNT.DataInicioVigencia InicioVigenciaApolice
                    , CNT.DataFimVigencia FimVigenciaApolice
                    , PE.Endereco
                    , PE.Bairro
                    , PE.Cidade
                    , PE.UF
                    , PE.CEP
                    , COALESCE(PC.CPFCNPJ, CRT.CPF) CPF
                    , COALESCE(PC.Nome, CRT.NomeCliente) Nome
                    , CleansingKit.dbo.fn_getFirstName(COALESCE(PC.Nome, CRT.NomeCliente)) FirstName
                    , CleansingKit.dbo.fn_getLastName(COALESCE(PC.Nome, CRT.NomeCliente)) LastName
                    , COALESCE(PC.DataNascimento, Cast('1900-01-01' as Date)) DataNascimento
                    , COALESCE(PRP.ValorPremioTotal,CRT.ValorPremioBruto,  PRP.ValorPremioBrutoEmissao) ValorPremioTotal                                                                                                       
                    , COALESCE(PRP.ValorPremioLiquidoEmissao,CRT.ValorPremioLiquido) ValorPremioLiquido         
                    , PRP.IDAgenciaVenda
                    , PRP.IDFuncionario
                    , PRP.Dataemissao
                    , PRP.CodigoSegmento
                    , ROW_NUMBER() OVER (PARTITION BY CRT.NumeroCertificado ORDER BY CASE WHEN LEFT(PRP.NumeroProposta,2) = 'SN' THEN 1 ELSE 0 END, CASE WHEN LEFT(CRT.Arquivo,3) = 'SSD' THEN 0 ELSE 1 END) ORDEM
                    --into #teste
					,cc.ImportanciaSegurada as ValorImportanciaSegurada
					,PP.Descricao PeriodicidadePagamento
					,PP.Codigo CdPeriodicidadePagamento
					,'3 anos' as Contratacao__c
					,36 as Contratacao_meses__c
                    FROM Dados.Certificado CRT
                    INNER JOIN #PRP_VIDA P
                    ON P.IDCertificado = CRT.ID
                    INNER JOIN Dados.Proposta PRP
                    ON P.IDProposta = PRP.ID
                    LEFT JOIN Dados.Produto PRD
                    ON PRD.ID = PRP.IDProduto
					inner join Dados.PeriodoPagamento pp 
					on pp.id=prd.idperiodopagamento
                    LEFT JOIN Dados.Contrato CNT
                    ON CNT.ID = CRT.IDContrato
                    LEFT JOIN Dados.PropostaCliente PC
                    ON PC.IDProposta = P.IDProposta
                    LEFT JOIN Dados.Sexo S
                    ON S.ID = PC.IDSexo
                    LEFT JOIN Dados.EstadoCivil EC
                    ON EC.ID = PC.IDEstadoCivil
                    LEFT JOIN Dados.PropostaEndereco PE
                    ON PE.IDProposta = P.IDProposta
					LEFT JOIN dados.certificadocoberturahistorico cc
					on cc.idcertificado=crt.iD
					inner join Vincendos_vida v on PRP.NumeroProposta = v.PropostaTratada
					and cc.ID = (select max(id) from dados.certificadocoberturahistorico where idcertificado=crt.id)
                    OUTER APPLY(
                           select pp.Descricao ProdutoAnterior,pp.CodigoComercializado CodigoProdutoAnterior
                           from dados.Contrato cc
                           inner join dados.Proposta pr
                           on pr.id=cc.IDProposta
                           inner join dados.produto pp
                           on pp.id=pr.IDProduto
                           where cc.id=P.IDContratoAnterior
                    ) as ProdutoAnterior
             --WHERE PRP.ID = 69027327
                    --where Nome is not null
       )                                                                                                                                                                                           
       SELECT                                                                                                                                                     
          CTE.CPF                                                                                                                                                               
       ,  CTE.Nome                                                                                                                                                
       ,  CTE.FirstName                                                                                                                                           
       ,  CTE.LastName                                                                                                          
       ,  CTE.NumeroCertificado
       ,  CTE.NumeroProposta
       ,  CTE.NumeroApolice                                                                                                                                       
       ,  COALESCE(TelCelular, TelResidencial, TelComercial) Telefone                                                           
       ,  DataProposta     
       ,  CTE.DataEmissao                                                                                                                                                                                                                                                           
       ,  CodigoComercializado                                                                                                                             
       ,  [ProdutoComercializado]        
       ,  CTE.CodigoProdutoAnterior
       ,  CTE.ProdutoAnterior
       ,  CTE.DataFimVigencia                  
       ,  CTE.InicioVigenciaApolice
       ,  CTE.FimVigenciaApolice                                                                                                       
       --,  CASE C.Sigla WHEN 'PAG' then 'Adimplente' ELSE 'Inadimplente' END Statuspagamento
       ,  CTE.CodigoSegmento
       ,  ISNULL(CTE.Endereco,'')  Endereco                                                      
       ,  ISNULL(CTE.Bairro, '') Bairro                                                                           
       ,  CTE.Cidade                                                                                                                         
       ,  CTE.UF                                                                                                                       
       ,  'Brazil' Pais                                                                                                                                    
       ,  'br' PaisCodigo                                                                                                                                  
       ,  CTE.CEP                                                                                                                                                                                                                                                                                 
       , IDContrato                                                                                                                                        
       , CTE.IDProposta                                                                                                                                           
       , CTE.DataInicioVigencia                                                                                                                            
       , CTE.ValorPremioTotal ValorPremioTotal                                                                                                      
       , CTE.ValorPremioLiquido ValorPremioLiquido                                                                                                                             
       , U.Codigo CodigoUnidade                                                                                                                     
       , U.Nome NomeUnidade                                                                                                                         
       , ISNULL(RIGHT('00000000' + F.Matricula,8), '')  MatriculaIndicador                                               
       , F.Nome NomeIndicador                                                                                                                              
       , F.CPF [CPFIndicador] 
	   ,PeriodicidadePagamento
	   ,CdPeriodicidadePagamento
	   ,ValorImportanciaSegurada
	   ,Contratacao__c
	   ,Contratacao_meses__c                                                                                    
       INTO Stage_SalesForce.Enqueue.[Contract_load_contract_VIDA]                             
       FROM CTE      
       LEFT JOIN Dados.vw_Unidade U
       ON U.IDUnidade = CTE.IDAgenciaVenda
       LEFT JOIN Dados.Funcionario F
       ON F.ID = CTE.IDFuncionario             
       --left JOIN Dados.PropostaSituacaoPagamento AS S ---- incluido por Andre - 2017-06-03
       --ON CTE.IDProposta=S.IDProposta
       --left JOIN Dados.SituacaoCobranca AS C
       --ON S.IDSituacaoCobranca=C.ID                          
       where ORDEM = 1   

	 IF(OBJECT_ID('tempdb..#ClienteVIDA') IS NOT NULL)
		DROP TABLE #ClienteVIDA;

	--CARREGA CONTA
	;with cte
       as
       (
       SELECT  DISTINCT                                                                                                                       
             --prp.idproposta                                                                                                                                                                                          
               COALESCE(PC.CPFCNPJ, CRT.CPF) CPF                                                                                                                                                          
             , [dbo].[InitCap](COALESCE(PC.Nome, CRT.NomeCliente)) Nome                                                                                                                      
             , PC.DataNascimento 
             , Cast(DATEDIFF(day,PC.DataNascimento,getdate()) / 365.25 as int) Idade
             , dados.fn_trataTelefoneSF(NULL,ISNULL(C.Telefone,[Dados].fn_TrataNumeroTelefone(TRY_PARSE(REPLACE(REPLACE(PC.DDDCelular,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneCelular,')',''),'(','') AS INT)))) TelCelular
             , dados.fn_trataTelefoneSF(NULL,ISNULL(t.Telefone,[Dados].[fn_TrataNumeroFixo] (TRY_PARSE(REPLACE(REPLACE(PC.DDDResidencial,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneResidencial,')',''),'(','') AS INT)))) TelResidencial
             , dados.fn_trataTelefoneSF(NULL,[Dados].[fn_TrataNumeroFixo] (TRY_PARSE(REPLACE(REPLACE(PC.DDDComercial,')',''),'(','') AS INT), TRY_PARSE(REPLACE(REPLACE(PC.TelefoneComercial,')',''),'(','') AS INT))) TelComercial              
             , ISNULL(email.Email,PC.Email) Email
             , PC.Emailcomercial                                                                                                                                                                                       
             , PE.Endereco                                                                                                                                                                                             
             , PE.Cidade                                                                                                                                                                                                      
             , PE.Bairro                                                                                                                                                                                                      
             , PE.CEP                                                                                                                                                                                                         
             , PE.UF
             , S.Descricao Sexo
             , EC.Descricao EstadoCivil
             , PRP.CodigoSegmento
             , ROW_NUMBER() OVER(PARTITION BY COALESCE(PC.CPFCNPJ, CRT.CPF) ORDER BY PE.IDTipoEndereco) ORDEM1
             ,  ROW_NUMBER() OVER (PARTITION BY CRT.NumeroCertificado ORDER BY CASE WHEN LEFT(PRP.NumeroProposta,2) = 'SN' THEN 1 ELSE 0 END, CASE WHEN LEFT(CRT.Arquivo,3) = 'SSD' THEN 0 ELSE 1 END) ORDEM
       FROM Dados.Certificado CRT
       INNER JOIN #PRP_VIDA P
       ON P.IDCertificado = CRT.ID
       INNER JOIN Dados.Proposta PRP
       ON P.IDProposta = PRP.ID
       LEFT JOIN Dados.Produto PRD
       ON PRD.ID = PRP.IDProduto
       LEFT JOIN Dados.PropostaCliente PC
       ON PC.IDProposta = P.IDProposta
       LEFT JOIN Dados.Sexo S
       ON S.ID = PC.IDSexo
       LEFT JOIN Dados.EstadoCivil EC
       ON EC.ID = PC.IDEstadoCivil
       LEFT JOIN Dados.PropostaEndereco PE
       ON PE.IDProposta = P.IDProposta
	   LEFT JOIN Dados.Vw_contatopessoa_celular C
	   on C.CPFCNPJ=PC.CPFCNPJ
	   LEFT JOIN Dados.Vw_contatopessoa_telefone t
	   on C.CPFCNPJ=PC.CPFCNPJ
	   LEFT JOIN Dados.vw_contatopessoa_email email
	   on C.CPFCNPJ=PC.CPFCNPJ
       )
       SELECT *
       INTO #ClienteVIDA
       FROM CTE
       where ORDEM = 1--
       and ORDEM1 = 1

	--INSERE STAGE SALES_FORCE
	truncate table Stage_SalesForce.Enqueue.account_load_cliente_VIDA
       ;
       MERGE INTO 
        Stage_SalesForce.Enqueue.account_load_cliente_VIDA T
       USING (
                    SELECT DISTINCT *
                    FROM #ClienteVIDA
               ) S
       ON 
       S.CPF COLLATE SQL_Latin1_General_CP1_CI_AS = T.CPF_CNPJ__c
       WHEN NOT MATCHED THEN
       INSERT (CPF_CNPJ__c, FirstName, LastName, Name, DataNascimento__c,Idade_c, DevLocale_SFMC__c, Email, CEP, Bairro__c, Cidade__c, Endereco__c, UF__c, Phone, Sexo, MobilePhone, EstadoCivil,Segmento_c)
       VALUES (S.CPF, CleansingKit.dbo.fn_getFirstName(s.Nome), CleansingKit.dbo.fn_getLastName(S.Nome), s.Nome, S.DataNascimento,Idade, 'br', COALESCE(S.Email, S.EmailComercial), S.CEP
               , S.Bairro, S.Cidade, S.Endereco, S.UF, COALESCE(TelResidencial, TelComercial,TelCelular), S.Sexo, 
               S.TelCelular, S.EstadoCivil,CodigoSegmento);