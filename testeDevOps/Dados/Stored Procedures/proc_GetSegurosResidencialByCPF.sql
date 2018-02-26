﻿CREATE PROCEDURE [Dados].[proc_GetSegurosResidencialByCPF]
@CPF [nvarchar](14)
AS
SELECT TOP 10
		PC.Nome,
		PC.CPFCNPJ CPF,
		LEFT(CONVERT(VARCHAR, PC.DataNascimento, 120), 10) AS DataNascimento,
		PC.TipoPessoa,
		Se.Sigla Sexo,
		PC.Identidade,
		EC.Descricao EstadoCivil,
		PC.DDDResidencial,
		PC.TelefoneResidencial,
		c.[EnderecoLocalRisco] Endereco,
		c.[BairroLocalRisco] Bairro,
		c.[CidadeLocalRisco] Cidade,
		c.[UFLocalRisco] UF,
		C.[RazaoSocialCorretor1] Corretor,
		CAST(p.IDContrato AS varchar(30)) AS IDContrato,
		c.[NumeroContrato],
		LEFT(CONVERT(VARCHAR,c.[DataInicioVigencia], 120), 10) AS DataInicioVigenciaContrato,
		LEFT(CONVERT(VARCHAR,c.[DataFimVigencia], 120), 10) AS DataFimVigenciaContrato,
		LEFT(CONVERT(VARCHAR,c.[ValorPremioTotalAtual], 120), 10) AS ValorPremioTotalAtualContrato,
		LEFT(CONVERT(VARCHAR,PRes.[ValorPrimeiraParcela], 120), 10) AS ValorPrimeiraParcela,
		LEFT(CONVERT(VARCHAR,PRes.[QuantidadeParcelas], 120), 10) AS QuantidadeParcelas,
		LEFT(CONVERT(VARCHAR,PRes.[ValorDemaisParcelas], 120), 10) AS ValorDemaisParcelas
		

  FROM [Corporativo].[Dados].[Contrato] C
  INNER JOIN [Corporativo].[Dados].[Proposta] P on C.ID = P.IDContrato
  INNER JOIN [Corporativo].[Dados].[PropostaCliente] PC on PC.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Produto] PR on PR.ID = P.IDproduto
  INNER JOIN [Dados].[Seguradora] S on S.ID = p.IDSeguradora
  INNER JOIN [Corporativo].[Dados].[RamoPAR] RPAR on PR.IDRamoPAR = RPAR.id
  INNER JOIN [Corporativo].[Dados].[Sexo] Se on Se.ID = pc.IDSexo
  INNER JOIN [Corporativo].[Dados].[EstadoCivil] EC on EC.ID = pc.IDEstadoCivil
  INNER JOIN [Dados].[PropostaResidencial] PRes on PRes.[IDProposta] = P.ID

  
  WHERE 
  (CASE WHEN GETDATE() <= c.DataFimVigencia THEN 1
		 ELSE 0
	END ) = 1 AND
  PC.CPFCNPJ = @CPF --'004.996.271-05'--'035.870.871-05'--'578.960.381-53'--
 AND LastValue = 1
