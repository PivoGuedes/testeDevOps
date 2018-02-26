CREATE PROCEDURE [Dados].[proc_GetSegurosVidaByCPF]
@CPF [nvarchar](14)
AS
SELECT       PC.Nome,
             PC.CPFCNPJ CPF,
             LEFT(CONVERT(VARCHAR, PC.DataNascimento, 120), 10) AS DataNascimento,
             PC.TipoPessoa,
             Se.Sigla Sexo,
             PC.Identidade,
             EC.Descricao EstadoCivil,
                     c.[NumeroContrato] NumeroApolice,
                     PP.[Descricao] PeriodicidadePagamento,
                     CAST(p.IDContrato AS varchar(30)) AS IDContrato,
             LEFT(CONVERT(VARCHAR,p.[DataInicioVigencia], 120), 10) AS DataInicioVigenciaContrato,
             LEFT(CONVERT(VARCHAR,p.[DataFimVigencia], 120), 10) AS DataFimVigenciaContrato,
                     LEFT(CONVERT(VARCHAR,p.[ValorPremioTotal], 120), 10) AS ValorPremioTotal,
                     pr.descricao Produto
  FROM [Corporativo].[Dados].[Contrato] C
  INNER JOIN [Corporativo].[Dados].[Proposta] P on C.ID = P.IDContrato
  INNER JOIN [Corporativo].[Dados].[PropostaCliente] PC on PC.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Produto] PR on PR.ID = P.IDproduto
  INNER JOIN [Dados].[Seguradora] S on S.ID = p.IDSeguradora
  INNER JOIN [Corporativo].[Dados].[RamoPAR] RPAR on PR.IDRamoPAR = RPAR.id
  INNER JOIN [Corporativo].[Dados].[Sexo] Se on Se.ID = pc.IDSexo
  INNER JOIN [Corporativo].[Dados].[EstadoCivil] EC on EC.ID = pc.IDEstadoCivil
  INNER JOIN [Corporativo].[Dados].[PeriodoPagamento] PP on PP.Codigo = P.PeriodicidadePagamento
  WHERE 
  (CASE WHEN GETDATE() <= c.DataFimVigencia THEN 1
             ELSE 0
       END ) = 1 AND
  PC.CPFCNPJ = @CPF --'011.880.221-64'
  --'006.439.871-42' --'004.996.271-05'--'035.870.871-05'--'578.960.381-53'--
AND P.TipoDado like 'SSD%' 
