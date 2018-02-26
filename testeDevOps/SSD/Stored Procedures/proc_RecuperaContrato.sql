
/*
	Autor: Egler Vieira
	Data Criação: 20/07/2014

	Descrição: 
	
	Última alteração : 	

*/
/*******************************************************************************
       Nome: CORPORATIVO.SSD.proc_RecuperaContrato
       Descrição: Essa procedure vai consultar os dados de Contrato (pessoas físicas e jurídicas).
        Retorna os TOP N registros, a partir do último ponto de parada, especificado como parâmetro do procedimento.
            
       Parâmetros de entrada:
            
       Retorno:
             XML com as entidades.
      
*******************************************************************************/
CREATE PROCEDURE [SSD].[proc_RecuperaContrato](@PontoDeParada varchar(300))
AS
--declare @PontoDeParada varchar(300)
--set @PontoDeParada = '1944-01-01;0'
DECLARE @DataModificacao date
DECLARE @Contrato int

SET @DataModificacao = LEFT(@PontoDeParada, CHARINDEX(';',@PontoDeParada)-1)
--select @DataModificacao
SET @Contrato = RIGHT(@PontoDeParada, LEN(@PontoDeParada) - CHARINDEX(';',@PontoDeParada))
--SELECT @Contrato
--SELECT  
--FROM CleansingKit.dbo.[fn_Split](@PontoDeParada,';')  

;WITH CTE 
AS
(
    SELECT  --100 PERCENT 
    CV.SUK_CONTRATO_VIDA,
    CV.NUM_BIL_CERTIF,
    CV.NUM_APOLICE,
    CASE WHEN CV.NUM_PROPOSTA_SIVPF IS NULL AND (CV.NUM_APOLICE IN ('109300000559','109300002344','97010000889')) THEN CV.NUM_BIL_CERTIF ELSE CleansingKit.dbo.fn_RemoveLeadingZeros(CV.NUM_PROPOSTA_SIVPF) END AS NUM_PROPOSTA_SIVPF,
    CV.NUM_CONTRATO,
    CV.DTH_PROPOSTA,
    CV.DTH_VENDA,
    CV.DTH_QUITACAO,
    CV.DTH_EMISSAO,
    CV.DTH_CANCELAMENTO,
    CV.DTH_INI_VIGENCIA,
    CV.DTH_FIM_VIGENCIA,
    CV.VLR_PREMIO_BRUTO_INICIAL,
    CV.VLR_PREMIO_LIQ_INICIAL,
    CV.VLR_PREMIO_BRUTO_ATUAL,
    CV.VLR_PREMIO_LIQ_ATUAL,
    CV.VLR_IOF,
    CV.VLR_CUSTO_EMISSAO,
    CV.COD_SUBGRUPO,
    CV.IND_PERI_PAGAMENTO,
    CV.COD_OPCAO_PAGAMENTO,
    CV.NUM_MATRICULA_VENDEDOR,
    CV.NUM_MATRICULA_ECONOM,
    CV.NUM_MATRICULA_PDV,
    CV.NUM_APOLICE_ANTERIOR,
    CV.IND_RENOVACAO,
    CV.IND_ADIMPLENTE,
    CV.NUM_QTD_PARCELAS,
    CV.IND_ORIGEM_REGISTRO [IND_ORIGEM_REGISTRO_CONTRATO],
	CASE WHEN CV.[STA_ANTECIPACAO] = 'S' THEN 1 WHEN CV.[STA_ANTECIPACAO] = 'N' THEN 0 END AS [STA_ANTECIPACAO],
	CASE WHEN CV.[STA_MUDANCA_PLANO] = 'S' THEN 1 WHEN CV.[STA_MUDANCA_PLANO] = 'N' THEN 0 END AS [STA_MUDANCA_PLANO],
    -------------------------------------PRODUTO----------------------------------------------------------
    PU.COD_PRODUTO_SIAS,
    PU.COD_PRODUTO_SIVPF,
    PU.COD_RAMO_EMISSOR,
    PU.COD_EMPRESA_SIAS,
    -------------------------------------VENDEDOR---------------------------------------------------------   
    V.COD_CPF_CNPJ [COD_CPF_CNPJ_VENDEDOR],
    V.COD_MATRICULA [COD_MATRICULA_VENDEDOR],
    V.IND_ORIGEM_REGISTRO [IND_ORIGEM_REGISTRO_VENDEDOR],
    V.IND_TIPO_VENDEDOR,
    ---------------------------------------SITUACAO-------------------------------------------------------
    CASE WHEN SC.NUM_SITUACAO_CONTRATO < 0 OR SC.NUM_SUB_SITUACAO < 0 THEN NULL
         ELSE Cast(SC.IND_ORIGEM_SITUACAO as varchar(1))+ Cast(SC.NUM_SITUACAO_CONTRATO as varchar(5)) + Cast(SC.NUM_SUB_SITUACAO as varchar(5))
    END [IDSUBSITUACAO],
    FS.DTH_DATA [DATA_SITUACAO],
    FS.[DTH_ATUALIZACAO] [DATA_ATUALIZACAO],
    FS.QTD_CONTRATO [QTD_CONTRATO],
    FS.QTD_PROPOSTA [QTD_PROPOSTA],
    ---------------------------------------UNIDADE ORGANIZACIONAL-----------------------------------------
    UO.COD_AGENCIA,
    ---------------------------------------ESTIPULANTE----------------------------------------------------
    PE.COD_CLIENTE               COD_CLIENTE_PE                ,
    PE.NUM_OCORR_ENDERECO	     NUM_OCORR_ENDERECO_PE 	       ,
    PE.NOM_PESSOA                NOM_PESSOA_PE                 ,
    PE.COD_CPF_CNPJ	             COD_CPF_CNPJ_PE               ,
    PE.DTH_NASCIMENTO            DTH_NASCIMENTO_PE             ,
    PE.COD_SEXO	                 COD_SEXO_PE	               ,
    PE.COD_ESTADO_CIVIL	         COD_ESTADO_CIVIL_PE	       ,
    PE.DES_ESTADO_CIVIL	         DES_ESTADO_CIVIL_PE	       ,
    PE.IND_TIPO_PESSOA	         IND_TIPO_PESSOA_PE	           ,
    PE.DES_EMAIL	             DES_EMAIL_PE	               ,
    PE.NUM_IDENTIDADE	         NUM_IDENTIDADE_PE	           ,
    PE.DES_ORGAO_EXPEDIDOR	     DES_ORGAO_EXPEDIDOR_PE	       ,
    PE.COD_UF_EXPEDIDORA	     COD_UF_EXPEDIDORA_PE	       ,
    PE.DTH_EXPEDICAO	         DTH_EXPEDICAO_PE	           ,
    PE.COD_DDD_TELEFONE	         COD_DDD_TELEFONE_PE	       ,
    PE.COD_TELEFONE	             COD_TELEFONE_PE	           ,
    PE.COD_DDD_CELULAR	         COD_DDD_CELULAR_PE	           ,
    PE.COD_CELULAR	             COD_CELULAR_PE	               ,
    PE.COD_CBO                   COD_CBO_PE                    ,
    PE.DES_ENDERECO	             DES_ENDERECO_PE	           ,
    PE.DES_BAIRRO	             DES_BAIRRO_PE	               ,
    PE.DES_CIDADE	             DES_CIDADE_PE	               ,
    PE.COD_UF	                 COD_UF_PE	                   ,
    PE.DES_COMPLEMENTO_ENDERECO  DES_COMPLEMENTO_ENDERECO_PE   ,
    PE.NUM_IMOVEL	             NUM_IMOVEL_PE	               ,
    PE.COD_CEP	                 COD_CEP_PE	                   ,
    PE.COD_BANCO	             COD_BANCO_PE	               ,
    PE.COD_AGENCIA	             COD_AGENCIA_PE	               ,
    PE.NUM_CONTA	             NUM_CONTA_PE	               ,
    PE.NUM_DV_CONTA	             NUM_DV_CONTA_PE	           ,
    PE.NUM_OPERACAO_CONTA	     NUM_OPERACAO_CONTA_PE	       ,
    PE.COD_ORIGEM_PESSOA         COD_ORIGEM_PESSOA_PE          ,
    --------------------------------------SUB ESTIPULANTE------------------------------------------------
    PSE.COD_CLIENTE               COD_CLIENTE_PSE              ,
    PSE.NUM_OCORR_ENDERECO	      NUM_OCORR_ENDERECO_PSE 	   ,
    PSE.NOM_PESSOA                NOM_PESSOA_PSE               ,
    PSE.COD_CPF_CNPJ	          COD_CPF_CNPJ_PSE             ,
    PSE.DTH_NASCIMENTO            DTH_NASCIMENTO_PSE           ,
    PSE.COD_SEXO	              COD_SEXO_PSE	               ,
    PSE.COD_ESTADO_CIVIL	      COD_ESTADO_CIVIL_PSE	       ,
    PSE.DES_ESTADO_CIVIL	      DES_ESTADO_CIVIL_PSE	       ,
    PSE.IND_TIPO_PESSOA	          IND_TIPO_PESSOA_PSE	       ,
    PSE.DES_EMAIL	              DES_EMAIL_PSE	               ,
    PSE.NUM_IDENTIDADE	          NUM_IDENTIDADE_PSE	       ,
    PSE.DES_ORGAO_EXPEDIDOR	      DES_ORGAO_EXPEDIDOR_PSE	   ,
    PSE.COD_UF_EXPEDIDORA	      COD_UF_EXPEDIDORA_PSE	       ,
    PSE.DTH_EXPEDICAO	          DTH_EXPEDICAO_PSE	           ,
    PSE.COD_DDD_TELEFONE	      COD_DDD_TELEFONE_PSE	       ,
    PSE.COD_TELEFONE	          COD_TELEFONE_PSE	           ,
    PSE.COD_DDD_CELULAR	          COD_DDD_CELULAR_PSE	       ,
    PSE.COD_CELULAR	              COD_CELULAR_PSE	           ,
    PSE.COD_CBO                   COD_CBO_PSE                  ,
    PSE.DES_ENDERECO	          DES_ENDERECO_PSE	           ,
    PSE.DES_BAIRRO	              DES_BAIRRO_PSE	           ,
    PSE.DES_CIDADE	              DES_CIDADE_PSE	           ,
    PSE.COD_UF	                  COD_UF_PSE	               ,
    PSE.DES_COMPLEMENTO_ENDERECO  DES_COMPLEMENTO_ENDERECO_PSE ,
    PSE.NUM_IMOVEL	              NUM_IMOVEL_PSE	           ,
    PSE.COD_CEP	                  COD_CEP_PSE	               ,
    PSE.COD_BANCO	              COD_BANCO_PSE	               ,
    PSE.COD_AGENCIA	              COD_AGENCIA_PSE	           ,
    PSE.NUM_CONTA	              NUM_CONTA_PSE	               ,
    PSE.NUM_DV_CONTA	          NUM_DV_CONTA_PSE	           ,
    PSE.NUM_OPERACAO_CONTA	      NUM_OPERACAO_CONTA_PSE	   ,
    PSE.COD_ORIGEM_PESSOA         COD_ORIGEM_PSESSOA_PSE       ,
    --------------------------------------SEGURADO-------------------------------------------------------
    PS.COD_CLIENTE               COD_CLIENTE_PS                ,
    PS.NUM_OCORR_ENDERECO	     NUM_OCORR_ENDERECO_PS 	       ,
    PS.NOM_PESSOA                NOM_PESSOA_PS                 ,
    PS.COD_CPF_CNPJ	             COD_CPF_CNPJ_PS               ,
    PS.DTH_NASCIMENTO            DTH_NASCIMENTO_PS             ,
    PS.COD_SEXO	                 COD_SEXO_PS	               ,
    PS.COD_ESTADO_CIVIL	         COD_ESTADO_CIVIL_PS	       ,
    PS.DES_ESTADO_CIVIL	         DES_ESTADO_CIVIL_PS	       ,
    PS.IND_TIPO_PESSOA	         IND_TIPO_PESSOA_PS	           ,
    PS.DES_EMAIL	             DES_EMAIL_PS	               ,
    PS.NUM_IDENTIDADE	         NUM_IDENTIDADE_PS	           ,
    PS.DES_ORGAO_EXPEDIDOR	     DES_ORGAO_EXPEDIDOR_PS	       ,
    PS.COD_UF_EXPEDIDORA	     COD_UF_EXPEDIDORA_PS	       ,
    PS.DTH_EXPEDICAO	         DTH_EXPEDICAO_PS	           ,
    PS.COD_DDD_TELEFONE	         COD_DDD_TELEFONE_PS	       ,
    PS.COD_TELEFONE	             COD_TELEFONE_PS	           ,
    PS.COD_DDD_CELULAR	         COD_DDD_CELULAR_PS	           ,
    PS.COD_CELULAR	             COD_CELULAR_PS	               ,
    PS.COD_CBO                   COD_CBO_PS                    ,
    PS.DES_ENDERECO	             DES_ENDERECO_PS	           ,
    PS.DES_BAIRRO	             DES_BAIRRO_PS	               ,
    PS.DES_CIDADE	             DES_CIDADE_PS	               ,
    PS.COD_UF	                 COD_UF_PS	                   ,
    PS.DES_COMPLEMENTO_ENDERECO  DES_COMPLEMENTO_ENDERECO_PS   ,
    PS.NUM_IMOVEL	             NUM_IMOVEL_PS	               ,
    PS.COD_CEP	                 COD_CEP_PS	                   ,
    PS.COD_BANCO	             COD_BANCO_PS	               ,
    PS.COD_AGENCIA	             COD_AGENCIA_PS	               ,
    PS.NUM_CONTA	             NUM_CONTA_PS	               ,
    PS.NUM_DV_CONTA	             NUM_DV_CONTA_PS	           ,
    PS.NUM_OPERACAO_CONTA	     NUM_OPERACAO_CONTA_PS	       ,
    PS.COD_ORIGEM_PESSOA         COD_ORIGEM_PESSOA_PS          
FROM (SELECT TOP 3000 * FROM DMDB13.dbo.DM_030_CONTRATO_VIDA CV WHERE CV.SUK_CONTRATO_VIDA > @Contrato  ORDER BY CV.SUK_CONTRATO_VIDA ASC) CV
LEFT JOIN DMDB13.dbo.DM_039_FATO_SITUACAO_CONTRATO_VIDA FS
ON CV.SUK_CONTRATO_VIDA = FS.SUK_CONTRATO_VIDA
LEFT JOIN DMDB13.dbo.DM_014_UNIDADE_ORGANIZACIONAL UO
ON UO.SUK_UNIDADE = FS.SUK_UNIDADE
LEFT JOIN DMDB13.dbo.DM_038_PESSOA PE
ON PE.SUK_PESSOA = FS.SUK_PESSOA_ESTIPULANTE
LEFT JOIN DMDB13.dbo.DM_038_PESSOA PSE
ON PSE.SUK_PESSOA = FS.SUK_PESSOA_SUBESTIPULANTE
LEFT JOIN DMDB13.dbo.DM_038_PESSOA PS
ON PS.SUK_PESSOA = FS.SUK_PESSOA_SEGURADO
LEFT JOIN DMDB13.dbo.DM_036_SITUACAO_CONTRATO SC
ON SC.SUK_SITUACAO_CONTRATO = FS.SUK_SITUACAO_CONTRATO
LEFT JOIN DMDB13.dbo.DM_010_VENDEDOR V
ON V.SUK_VENDEDOR = FS.SUK_VENDEDOR
LEFT JOIN  DMDB13.dbo.DM_026_PRODUTO_UNIFICADO PU
ON PU.SUK_PRODUTO_UNIFICADO = FS.SUK_PRODUTO_UNIFICADO
--AND CV.NUM_BIL_CERTIF <> CV.NUM_PROPOSTA_SIVPF
--	WHERE COD_TIPO_PRODUTOR IN (0, 1) NOM_PRODUTOR like '%PAR C%'
--WHERE CV.NUM_BIL_CERTIF = '10000036804'
) 
SELECT *
FROM CTE
option (maxdop 4)





--select * from DMDB13.dbo.DM_030_CONTRATO_VIDA WHERE NUM_BIL_CERTIF = '10000036804'