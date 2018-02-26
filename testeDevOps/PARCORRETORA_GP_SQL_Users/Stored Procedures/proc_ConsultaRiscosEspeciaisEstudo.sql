-- =============================================
-- Author:		Thiago Santos
-- Create date: 2017-11-23
-- Description:	Estudo: Vendas da Riscos Especiais 
-- =============================================
CREATE PROCEDURE [PARCORRETORA\GP_SQL_Users].[proc_ConsultaRiscosEspeciaisEstudo] 
	
	@ano int ,
	@mes int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   /*
CodigoComercializado	
Produto	CNPJCorretor1	
CodigoCorretor1	
RazaoSocialCorretor1	
NumeroContrato	
NumeroEndosso	 
Valor 	 
ValorPremioLiquido 	
numeroparcela	
DataEfetivacao	
DataArquivo

SELECT * FROM Dados.Proposta PRP
*/ 




SELECT  
       PRD.CodigoComercializado [CodigoProduto]
      ,PR.NOME
	  ,PR.CPFCNPJ
	  ,PR.CodigoProdutor 
	  ,PR.Codigo
	  ,CNT.NumeroContrato
		, PGTO.NumeroEndosso
      , PRP.NumeroProposta
    
     
      /*, PRD.Descricao,*/ 
         ,--SUM(
              CASE WHEN IDTipoMovimento = 2 THEN   ABS(PGTO.Valor) * -1 
                WHEN IDTipoMovimento IN (1,3) THEN   ABS(PGTO.Valor) 
           ELSE 0
           END [ValorBase]
             --   ) 

		 ,--SUM(
              CASE WHEN IDTipoMovimento = 2 THEN   ABS(PGTO.ValorPremioLiquido) * -1 
                WHEN IDTipoMovimento IN (1,3) THEN   ABS(PGTO.ValorPremioLiquido) 
           ELSE 0
           END [ValorPremioLiquido]
        
         , PGTO.NumeroParcela
         , PGTO.NumeroTitulo
         , PGTO.DataEndosso
         , PGTO.DataEfetivacao
		 , PRP.DataProposta 
		 , PRP.DataArquivo 
  
FROM Dados.Pagamento PGTO     
INNER JOIN Dados.Proposta PRP
ON PRP.ID = PGTO.IDProposta
LEFT JOIN Dados.Contrato CNT
ON PRP.IDContrato = CNT.ID
LEFT JOIN Dados.Produto PRD
ON PRP.IDProduto = PRD.ID

LEFT JOIN Dados.PropostaAcordo PA
 ON PA.IDProposta = PRP.ID

LEFT JOIN Dados.Produtor PR
ON PR.ID = PA.IDProdutor

OUTER APPLY (SELECT PRP2.Id as IDteste FROM Dados.Proposta PRP2 WHERE PRP2.NumeroProposta like 'SN'+PRP.NumeroProposta) teste
WHERE YEAR(PRP.DataProposta) = @ano AND MONTH(PRP.DataProposta) = @mes 
AND PGTO.Arquivo LIKE 'SSD.%'
-- RETIREI O NOT PARA BUSCAR SOMENTE REGISTRO DA PAR RISCOS 
--  NOT
AND    EXISTS (SELECT * 
                FROM Dados.PropostaAcordo PA
                           WHERE PA.IDProposta = PRP.ID
                           AND  EXISTS (SELECT *
                                           FROM Dados.Produtor PR
                                           WHERE PR.CPFCNPJ = '12.656.482/0001-11'
                                                      AND PR.ID = PA.IDProdutor
                                          )
                       )
AND PGTO.ValorPremioLiquido <> 0.0000000000
AND CASE WHEN teste.IDteste is  null and PRP.NumeroProposta not like 'SN%' then 0
when PRP.NumeroProposta like 'SN%' and IDteste IS null  then 0 
when PRP.NumeroProposta not like 'SN%' and IDteste IS not null  then 0 else 1 end = 0
--and  NumeroProposta in ('000082612977867','SN000082612977867')
AND PRD.CodigoComercializado <> '-1'

UNION ALL 


SELECT  
       PRD.CodigoComercializado [CodigoProduto]
      ,PR.NOME
	  ,PR.CPFCNPJ
	  ,PR.CodigoProdutor 
	  ,PR.Codigo
	  ,CNT.NumeroContrato
		, PGTO.NumeroEndosso
      , PRP.NumeroProposta
    
     
      /*, PRD.Descricao,*/ 
         ,--SUM(
              CASE WHEN IDTipoMovimento = 2 THEN   ABS(PGTO.Valor) * -1 
                WHEN IDTipoMovimento IN (1,3) THEN   ABS(PGTO.Valor) 
           ELSE 0
           END [ValorBase]
             --   ) 

		 ,--SUM(
              CASE WHEN IDTipoMovimento = 2 THEN   ABS(PGTO.ValorPremioLiquido) * -1 
                WHEN IDTipoMovimento IN (1,3) THEN   ABS(PGTO.ValorPremioLiquido) 
           ELSE 0
           END [ValorPremioLiquido]
        
         , PGTO.NumeroParcela
         , PGTO.NumeroTitulo
         , PGTO.DataEndosso
         , PGTO.DataEfetivacao
		 , PRP.DataProposta 
		 , PRP.DataArquivo 
  
FROM Dados.Pagamento PGTO     
INNER JOIN Dados.Proposta PRP
ON PRP.ID = PGTO.IDProposta
LEFT JOIN Dados.Contrato CNT
ON PRP.IDContrato = CNT.ID
LEFT JOIN Dados.Produto PRD
ON PRP.IDProduto = PRD.ID

LEFT JOIN Dados.PropostaAcordo PA
 ON PA.IDProposta = PRP.ID

LEFT JOIN Dados.Produtor PR
ON PR.ID = PA.IDProdutor

OUTER APPLY (SELECT PRP2.Id as IDteste FROM Dados.Proposta PRP2 WHERE PRP2.NumeroProposta like 'SN'+PRP.NumeroProposta) teste

WHERE YEAR(PRP.DataProposta) = @ano AND MONTH(PRP.DataProposta) = @mes 


-- ********************************************************************
-- **RETIRADO O CRITERIO DO CNPJ PARA  INCLUIR O CRITERIO DE PRODUTO **
-- ********************************************************************


-- RETIREI O NOT PARA BUSCAR SOMENTE REGISTRO DA PAR RISCOS 
--  NOT
--AND    EXISTS (SELECT * 
--                FROM Dados.PropostaAcordo PA
--                           WHERE PA.IDProposta = PRP.ID
--                           AND  EXISTS (SELECT *
--                                           FROM Dados.Produtor PR
--                                           WHERE PR.CPFCNPJ = '12.656.482/0001-11'
--                                                      AND PR.ID = PA.IDProdutor
--                                          )
--                       )



AND CASE 
WHEN PRP.NumeroProposta not like 'SN%' and teste.IDteste      is null        then 0
when PRP.NumeroProposta     like 'SN%' and IDteste			  IS null		 then 0 
when PRP.NumeroProposta not like 'SN%' and IDteste			  IS not null	 then 0 else 1 end = 0
 AND PGTO.ValorPremioLiquido <> 0.0000000000

-- ********************************************************************
-- *********************CRITERIO DE PRODUTO E OUTROS AJUSTES **********
-- ********************************************************************
--  AND PGTO.Arquivo LIKE 'SSD.%'
-- and  NumeroProposta in ('000082612977867','SN000082612977867')
-- AND PRD.CodigoComercializado <> '-1'

AND  PRD.CodigoComercializado IN (

									'1403',
									'1404',
									'1804',
									'6701',
									'7114',
									'1410',
									'3172',
									-- RETIRADO A PEDIDO DO JULIO 
									--'3173',
									--'3174',
									--'3175',
									--'3176',
									--'3177',
									--'3178',
									--'3179',
									--'3180',
									--'3181',
									'3183',
									-- RETIRADO A PEDIDO DO JULIO 
									--'7706',
									--'7714',
									--'7726',
									'8203',
									'8214',
									'9311',
									'9354'
 
 

)



END
