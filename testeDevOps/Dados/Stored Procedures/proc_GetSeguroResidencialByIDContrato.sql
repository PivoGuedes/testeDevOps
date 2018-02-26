CREATE PROCEDURE [Dados].[proc_GetSeguroResidencialByIDContrato]
@IDContrato [nvarchar](14)
AS
SELECT TOP 10
		PC.CPFCNPJ CPF,
		PC.Nome,
		LEFT(CONVERT(VARCHAR, PC.DataNascimento, 120), 10) AS DataNascimento,
		PC.TipoPessoa,
		Se.Sigla Sexo,
		PC.Identidade,
		EC.Descricao EstadoCivil,
		PC.DDDResidencial,
		PC.TelefoneResidencial,
		CAST(c.[ID] AS VARCHAR(20)) IDContrato
		,c.[NumeroContrato] NumeroContrato
		,LEFT(CONVERT(VARCHAR, C.DataInicioVigencia, 120), 10) AS DataInicioVigencia
	    ,LEFT(CONVERT(VARCHAR, C.DataFimVigencia, 120), 10) AS DataFimVigencia
		,PR.Descricao Produto
		,RPAR.Nome TipoProduto
		,S.Nome NomeSeguradora
		,TM.Descricao TipoMoradia
		,CAST(R.ValorPremioLiquido AS VARCHAR(20)) ValorPremioLiquido
		,CAST(R.ValorIOF AS VARCHAR(20)) ValorIOF
		,CAST(R.ValorPremioTotal AS VARCHAR(20)) ValorPremioTotal
		,CAST(R.QuantidadeParcelas AS VARCHAR(20)) QuantidadeParcelas
		,CAST(R.ValorPrimeiraParcela AS VARCHAR(20)) ValorPrimeiraParcela
		,CAST(R.ValorDemaisParcelas AS VARCHAR(20)) ValorDemaisParcelas
	  
  FROM [Corporativo].[Dados].[Contrato] C
  INNER JOIN [Corporativo].[Dados].[Proposta] P on C.ID = P.IDContrato
  INNER JOIN [Corporativo].[Dados].[PropostaCliente] PC on PC.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Produto] PR on PR.ID = P.IDproduto
  INNER JOIN [Dados].[Seguradora] S on S.ID = p.IDSeguradora
  INNER JOIN [Corporativo].[Dados].[RamoPAR] RPAR on PR.IDRamoPAR = RPAR.id
  INNER JOIN [Corporativo].[Dados].[Sexo] Se on Se.ID = pc.IDSexo
  INNER JOIN [Corporativo].[Dados].[EstadoCivil] EC on EC.ID = pc.IDEstadoCivil
  INNER JOIN [Corporativo].[Dados].[PropostaResidencial] R ON R.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[TipoMoradia] TM on TM.ID = R.IDTipoMoradia
  WHERE 
  (CASE WHEN GETDATE() <= c.DataFimVigencia THEN 1
		 ELSE 0
	END ) = 1 AND LastValue = 1 AND
  C.ID = @IDContrato


