CREATE PROCEDURE [Dados].[proc_GetSeguroAutoByIDContrato]
@IDContrato [nvarchar](14)
AS
SELECT TOP 10
		C.NumeroContrato AS NumeroApolice,
		S.Nome NomeSeguradora,
		RTRIM(LEFT(CONVERT(VARCHAR, C.DataInicioVigencia, 120), 10)) AS DataInicioVigencia,
	    RTRIM(LEFT(CONVERT(VARCHAR, C.DataFimVigencia, 120), 10)) AS DataFimVigencia,
		PC.Nome CondutorAssegurado,
		RTRIM(PA.[NomeCondutor1]) CondutorPrincipal,
		'' AS ModalidadeSeguro,
		RTRIM(V.Nome) VeiculoSegurado,
		'' CEPPernoite,
		'' Bonus,
		'' Franquia,
		'' ValorSeguro,
		'' Parcelas,
		'' PgtoEm,
		'' MelhorDia,
		'' PrimeiraParcela,
		'' DemaisParcelas,
		'' CoberturaCondutoes18a25,
		RTRIM(C.[RazaoSocialCorretor1]) Corretora,
		'' Compreensiva,
		'' Veiculo,
		'' CoberturaTerceiros,
		'' CoberturaVidros,
		'' CarroReservaBasico,
		'' LanternaFaroisRetrovisor,
		'' Assitencia24Hora,
		'' CondicoesEspeciais,
		CAST(C.[ValorPremioLiquido] AS VARCHAR(20)) ValorLiquido,
		'' IOF,
		CAST(C.[ValorPremioTotal] AS VARCHAR(20)) ValorTotal,
		CAST(PA.Placa AS VARCHAR(20)) Placa,
		CAST(PA.AnoModelo AS VARCHAR(4)) AnoModelo

  FROM [Corporativo].[Dados].[Contrato] C
  INNER JOIN [Corporativo].[Dados].[Proposta] P on C.ID = P.IDContrato
  INNER JOIN [Corporativo].[Dados].[PropostaCliente] PC on PC.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Produto] PR on PR.ID = P.IDproduto
  INNER JOIN [Dados].[Seguradora] S on S.ID = p.IDSeguradora
  INNER JOIN [Corporativo].[Dados].[RamoPAR] RPAR on PR.IDRamoPAR = RPAR.id
  INNER JOIN [Corporativo].[Dados].[PropostaAutomovel] PA on PA.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Veiculo] V on V.ID = PA.IDVeiculo

  WHERE 
  (CASE WHEN GETDATE() <= c.DataFimVigencia THEN 1
		 ELSE 0
	END ) = 1 AND
  C.ID = @IDContrato


