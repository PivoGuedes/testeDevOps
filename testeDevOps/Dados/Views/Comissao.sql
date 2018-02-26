





CREATE VIEW [Dados].[Comissao]
WITH SCHEMABINDING
AS 
SELECT CP.[ID]
      ,CP.[IDRamo]
      ,CP.[PercentualCorretagem]
      ,CP.[ValorCorretagem]
      ,CP.[ValorBase]
      ,CP.[ValorComissaoPAR]
      ,CP.[ValorRepasse]
      ,CP.[DataCompetencia]
      ,CP.[DataRecibo]
      ,CP.[NumeroRecibo]
      ,CP.[NumeroEndosso]
      ,CP.[NumeroParcela]
      ,CP.[DataCalculo]
      ,CP.[DataQuitacaoParcela]
      ,CP.[TipoCorretagem]
      ,CP.[IDContrato]
      ,CP.[IDCertificado]
      ,CP.[IDOperacao]
      ,CP.[IDFilialFaturamento]
      ,CP.[CodigoSubgrupoRamoVida]
      ,CP.[IDUnidadeVenda]
      ,CP.[IDProposta]
      ,CP.[IDCanalVendaPAR]
--      ,CP.[NumeroProposta]
      ,CP.[CodigoProduto]
      ,CP.[LancamentoManual]
      ,CP.[Repasse]
      ,CP.[Arquivo]
      ,CP.[DataArquivo]
      ,CP.[IDEmpresa]
      ,CP.[IDSeguradora]
      ,CP.[NumeroReciboOriginal]
	  ,CV.[Codigo] [CanalCodigo]
	  ,CV.[CodigoHierarquico] [CanalCodigoHierarquico]
	  ,CV.[Nome] [CanalNome]
	  ,CV.[DataInicio] [CanalDataInicio]
	  ,CV.[DataFim] [CanalDataFim]
	  ,CV.[CanalVinculador] [CanalVinculador]
	  ,CV.[IDCanalMestre] [IDCanalMestre]
	  ,CV.[DigitoIdentificador] [CanalDigitoIdentificador]
	  ,CV.[ProdutoIdentificador] [CanalProdutoIdentificador]
	  ,CV.[VendaAgencia] [CanalVendaAgencia]
	  ,CP.[IDProduto]
	  ,CP.CodigoProduto CodigoComercializado
	--  ,PRD.Descricao
	  ,CP.NumeroProposta
      ,CP.[IDProdutor]
	  ,CP.[CodigoProdutor]
	  ,CP.LancamentoProvisao
FROM [Dados].[Comissao_Partitioned] CP
INNER JOIN Dados.CanalVendaPAR CV
ON CV.ID = ISNULL(CP.IDCanalVendaPAR,-1)
--INNER JOIN Dados.Produto PRD
--ON PRD.ID = ISNULL(CP.IDProduto,-1)

--WHERE CP.DataCompetencia >= Convert(date,'20160315', 112)




GO
--- =============================================
-- Author:		Egler Vieira
-- Create date: 2016-04-05
-- Description:	Garantir a inserção na tabela física
-- =============================================
CREATE TRIGGER [Dados].[TRG_INSERT_COMISSAO] 
   ON  [Dados].[Comissao] 
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	INSERT INTO Dados.Comissao_Partitioned
           ([IDRamo]
           ,[PercentualCorretagem]
           ,[ValorCorretagem]
           ,[ValorBase]
           ,[ValorComissaoPAR]
           ,[ValorRepasse]
           ,[DataCompetencia]
           ,[DataRecibo]
           ,[NumeroRecibo]
           ,[NumeroEndosso]
           ,[NumeroParcela]
           ,[DataCalculo]
           ,[DataQuitacaoParcela]
           ,[TipoCorretagem]
           ,[IDContrato]
           ,[IDCertificado]
           ,[IDOperacao]
           ,[IDProdutor]
           ,[IDFilialFaturamento]
           ,[CodigoSubgrupoRamoVida]
           ,[IDProduto]
           ,[IDUnidadeVenda]
           ,[IDProposta]
           ,[IDCanalVendaPAR]
           ,[NumeroProposta]
           ,[CodigoProduto]
           ,[LancamentoManual]
           ,[Repasse]
           ,[Arquivo]
           ,[DataArquivo]
           ,[IDEmpresa]
           ,[IDSeguradora]
           ,[NumeroReciboOriginal]
		   ,CodigoProdutor)
      SELECT           
		    IDRamo
           ,PercentualCorretagem
           ,ValorCorretagem
           ,ValorBase
           ,ValorComissaoPAR 
           ,ValorRepasse
           ,DataCompetencia 
           ,DataRecibo
           ,NumeroRecibo 
           ,NumeroEndosso 
           ,NumeroParcela 
           ,DataCalculo
           ,DataQuitacaoParcela 
           ,TipoCorretagem
           ,IDContrato
           ,IDCertificado 
           ,IDOperacao
           ,IDProdutor 
           ,IDFilialFaturamento 
		   ,CodigoSubgrupoRamoVida 
           ,IDProduto
           ,IDUnidadeVenda 
           ,IDProposta
           ,IDCanalVendaPAR 
           ,NumeroProposta 
           ,CodigoProduto
           ,LancamentoManual 
           ,Repasse
           ,Arquivo 
           ,DataArquivo 
           ,IDEmpresa
           ,IDSeguradora 
           ,NumeroReciboOriginal	
		   ,CodigoProdutor	   
	  FROM INSERTED

END



GO
--                     =============================================
-- Author:		Egler Vieira
-- Create date: 2016-04-05
-- Description:	Garantir a exclusão na tabela física
--                     =============================================
CREATE TRIGGER [Dados].[TRG_UPDATE_COMISSAO] 
   ON  [Dados].[Comissao] 
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--    -- Insert statements for trigger here

UPDATE [Dados].[Comissao_Partitioned]
   SET 
       [IDRamo]                     =  I.[IDRamo]                     
      ,[PercentualCorretagem]       =  I.[PercentualCorretagem]       
      ,[ValorCorretagem]            =  I.[ValorCorretagem]            
      ,[ValorBase]                  =  I.[ValorBase]                  
      ,[ValorComissaoPAR]           =  I.[ValorComissaoPAR]           
      ,[ValorRepasse]               =  I.[ValorRepasse]               
      ,[DataCompetencia]            =  I.[DataCompetencia]            
      ,[DataRecibo]                 =  I.[DataRecibo]                 
      ,[NumeroRecibo]               =  I.[NumeroRecibo]               
      ,[NumeroEndosso]              =  I.[NumeroEndosso]              
      ,[NumeroParcela]              =  I.[NumeroParcela]              
      ,[DataCalculo]                =  I.[DataCalculo]                
      ,[DataQuitacaoParcela]        =  I.[DataQuitacaoParcela]        
      ,[TipoCorretagem]             =  I.[TipoCorretagem]             
      ,[IDContrato]                 =  I.[IDContrato]                 
      ,[IDCertificado]              =  I.[IDCertificado]              
      ,[IDOperacao]                 =  I.[IDOperacao]                 
      ,[IDFilialFaturamento]        =  I.[IDFilialFaturamento]        
      ,[CodigoSubgrupoRamoVida]     =  I.[CodigoSubgrupoRamoVida]     
      ,[IDUnidadeVenda]             =  I.[IDUnidadeVenda]             
      ,[IDProposta]                 =  I.[IDProposta]                 
      ,[IDCanalVendaPAR]            =  I.[IDCanalVendaPAR]            
      ,[CodigoProduto]              =  I.[CodigoProduto]              
      ,[LancamentoManual]           =  I.[LancamentoManual]           
      ,[Repasse]                    =  I.[Repasse]                    
      ,[Arquivo]                    =  I.[Arquivo]                    
      ,[DataArquivo]                =  I.[DataArquivo]                
      ,[IDEmpresa]                  =  I.[IDEmpresa]                  
      ,[IDSeguradora]               =  I.[IDSeguradora]               
      ,[NumeroReciboOriginal]       =  I.[NumeroReciboOriginal]    
      ,[IDProduto]                  =  I.[IDProduto]       
      ,[NumeroProposta]             =  I.[NumeroProposta]             
      ,[IDProdutor]                 =  I.[IDProdutor]     
	  ,CodigoProdutor               =  I.CodigoProdutor      
 FROM Dados.Comissao_Partitioned CP
 --INNER JOIN DELETED D
 --ON D.ID = CP.ID
 INNER JOIN INSERTED I
 ON I.ID = CP.ID
END


GO
--- =============================================
-- Author:		Egler Vieira
-- Create date: 2016-04-05
-- Description:	Garantir a exclusão na tabela física
-- =============================================
CREATE TRIGGER Dados.TRG_DELETE_COMISSAO 
   ON  Dados.Comissao 
   INSTEAD OF DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	DELETE Dados.Comissao_Partitioned	   
	FROM Dados.Comissao_Partitioned 
	WHERE ID IN (SELECT ID FROM DELETED)
END
