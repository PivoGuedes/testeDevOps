CREATE VIEW Dados.vw_Produto
AS
SELECT        PH.ID, PRD.[ID] [IDProduto], [CodigoComercializado], [IDRamoPrincipal], [IDRamoSUSEP], [IDRamoPAR], [IDSeguradora], RP.Codigo[CodigoRamoPAR], RP.Nome[NomeRamoPAR], PH.[Descricao], 
                         PH.[DataInicioComercializacao], PH.[DataFimComercializacao], PH.[DataInicio], PH.[DataFim], CASE WHEN (PH.DataFimComercializacao IS NOT NULL) THEN Cast(1 AS bit) ELSE Cast(0 AS bit) END [RunOff], 
                         PH.MetaASVEN, PH.MetaAVCaixa, PH.PercentualASVEN, PH.PercentualCorretora, PH.PercentualRepasse, PH.IDProdutoSegmento, PH.IDPeriodoContratacao, PC.Descricao[PeriodoContratacao], 
                         PRD.IDPeriodoPagamento, PP.Descricao[PeriodoPagamento], PRD.IDProdutoSIGPF, PH.IDEmpresaRepasse
FROM            [Dados].[Produto] PRD LEFT JOIN
                         Dados.RamoPAR RP ON RP.ID = PRD.IDRamoPar OUTER APPLY
                             (SELECT        TOP 1 [ID], [PercentualCorretora], [PercentualASVEN], [PercentualRepasse]/*,[RunOff] */ , [MetaASVEN], [MetaAVCaixa], [Descricao], [DataInicioComercializacao], [DataFimComercializacao], 
                                                         [DataInicio], [DataFim], IDProdutoSegmento, PH.IDPeriodoContratacao, PH.IDEmpresaRepasse
                               FROM            [Dados].[ProdutoHistorico] PH
                               WHERE        PRD.ID = PH.IDProduto
                               ORDER BY PH.IDProduto ASC, DataInicio DESC, DataFim ASC, ID DESC) PH LEFT JOIN
                         Dados.PeriodoContratacao PC ON PC.ID = PH.IDPeriodoContratacao LEFT JOIN
                         Dados.PeriodoPagamento PP ON PP.ID = PRD.IDPeriodoPagamento
WHERE        PRD.ID <> - 1

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[17] 4[23] 2[42] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'VIEW', @level1name = N'vw_Produto';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'Dados', @level1type = N'VIEW', @level1name = N'vw_Produto';

