---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	Autor: Egler Vieira
	Data Criação: 2014/03/12

	Descrição: 
	
	Última alteração :  
                                                                                      

******************************************************************************
	Nome: CORPORATIVO.Premiacao.vw_PremiacaoCorrespondenteAT_Analitico
	Descrição: Procedimento que realiza a recuperação da premiação analítica dos atentendetes lotéricos .
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

******************************************************************************
AND PC.IDOperacao = 1 --Corretagem -> 1001
and c.NomeArquivo NOT LIKE 'SAFCBN'*/
CREATE VIEW Premiacao.vw_PremiacaoCorrespondenteAT_Analitico
AS
SELECT        PC.ID, C.Matricula, C.CPFCNPJ, C.Nome, C.Cidade, C.UF, CDB.Banco, CDB.Agencia AS AgenciaConta, CDB.ContaCorrente, CDB.Operacao, 
                         PRP.NumeroProposta, CNT.NumeroContrato, CNT.NumeroBilhete, PC.NumeroEndosso, PC.NumeroRecibo, PC.NumeroParcela, 
                         CO.Codigo AS CodigoOperacao, PC.DataArquivo, PC.ValorCorretagem AS ValoCorretagem, PC.IDTipoProduto
FROM            Dados.PremiacaoCorrespondente AS PC LEFT OUTER JOIN
                         Dados.Correspondente AS C ON C.ID = PC.IDCorrespondente LEFT OUTER JOIN
                         Dados.CorrespondenteDadosBancarios AS CDB ON CDB.IDCorrespondente = PC.IDCorrespondente AND CDB.IDTipoProduto = PC.IDTipoProduto INNER JOIN
                         Dados.TipoProduto AS TP ON TP.ID = PC.IDTipoProduto LEFT OUTER JOIN
                         Dados.Unidade AS U ON U.ID = C.IDUnidade LEFT OUTER JOIN
                         Dados.Proposta AS PRP ON PC.IDProposta = PRP.ID LEFT OUTER JOIN
                         Dados.Contrato AS CNT ON CNT.ID = PC.IDContrato LEFT OUTER JOIN
                         Dados.ComissaoOperacao AS CO ON CO.ID = PC.IDOperacao
WHERE        (C.IDTipoCorrespondente = 2)
AND PC.IDOperacao=1



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
         Begin Table = "PC"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CDB"
            Begin Extent = 
               Top = 6
               Left = 270
               Bottom = 136
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TP"
            Begin Extent = 
               Top = 138
               Left = 285
               Bottom = 234
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 234
               Left = 285
               Bottom = 330
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PRP"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CNT"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 321
            End
            DisplayFlags = 280
            TopColumn = 0
      ', @level0type = N'SCHEMA', @level0name = N'Premiacao', @level1type = N'VIEW', @level1name = N'vw_PremiacaoCorrespondenteAT_Analitico';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   End
         Begin Table = "CO"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 696
               Right = 233
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3270
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
', @level0type = N'SCHEMA', @level0name = N'Premiacao', @level1type = N'VIEW', @level1name = N'vw_PremiacaoCorrespondenteAT_Analitico';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'Premiacao', @level1type = N'VIEW', @level1name = N'vw_PremiacaoCorrespondenteAT_Analitico';

