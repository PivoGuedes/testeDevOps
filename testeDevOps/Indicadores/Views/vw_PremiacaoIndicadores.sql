
CREATE VIEW [Indicadores].[vw_PremiacaoIndicadores]
WITH SCHEMABINDING 
AS
SELECT        RE.ID AS Sequencial, F.ID AS IDIndicador, F.Nome AS NomeIndicador, F.Matricula, F.CPF, F.DataNascimento, F.PIS, F.Salario, 
						 RE.Banco, RE.Operacao, U.Codigo AS Agencia, RE.ContaCorrente, 
						 RE.ValorBruto, RE.ValorISS, RE.ValorINSS, RE.ValorIRF, 
						 
						-- RE.ValorLiquido, 

						 Cast(RE.ValorBruto as decimal(24,9)) -  ISNULL(Cast(RE.CalculadoValorINSS as decimal(24,9)),0) - ISNULL(Cast(RE.CalculadoValorISS as decimal(24,9)),0) - ISNULL(Cast(RE.CalculadoValorIRRF as decimal(24,9)),0) ValorLiquido,

						 RE.ValorINSSRecolhidoCEF, 
                         RE.CalculadoAliquotaISS, RE.CalculadoValorISS, RE.CalculadoAliquotaIRRF, RE.CalculadoValorIRRF, RE.CalculadoAliquotaINSS, RE.CalculadoValorINSS, 
                         RE.CalculadoTetoINSS, RE.CodigoEmpresaProtheus, RE.CodigoFilialProtheus, RE.CodigoImportacaoPROTHEUS, RE.LoteImportacaoPROTHEUS, 
                         RE.ItemImportacaoPROTHEUS, RE.DataCalculo, RE.DataArquivo , RE.Cancelado, RE.NomeArquivo, RE.DataReferencia, RE.DataCompetencia, IDLote, Gerente
FROM            Dados.RePremiacaoIndicadores AS RE INNER JOIN
                         Dados.Funcionario AS F ON RE.IDFuncionario = F.ID 
				LEFT OUTER JOIN Dados.Unidade AS U
						ON U.ID=RE.IDUnidade
WHERE       (RE.Autorizado = 1)
			-- and IDLote = 217 -- Retirar essa linha. Ajuste para o Protheus buscar apenas esse lote. Alterado por Danilo em 18/09/2017.


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "RE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 366
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
', @level0type = N'SCHEMA', @level0name = N'Indicadores', @level1type = N'VIEW', @level1name = N'vw_PremiacaoIndicadores';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'Indicadores', @level1type = N'VIEW', @level1name = N'vw_PremiacaoIndicadores';

