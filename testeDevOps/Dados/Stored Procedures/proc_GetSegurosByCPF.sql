CREATE PROCEDURE [Dados].[proc_GetSegurosByCPF]
@CPF [nvarchar](14)
AS
  SELECT TOP 10

			--Cliente
		---xxx---xxx---xxx---xxx
		PC.CPFCNPJ CPF,
		PC.Nome,
		LEFT(CONVERT(VARCHAR, PC.DataNascimento, 120), 10) AS DataNascimento,
		PC.TipoPessoa,
		Se.Sigla Sexo,
		PC.Identidade,
		EC.Descricao EstadoCivil,
		PC.DDDResidencial,
		PC.TelefoneResidencial,

		---Proposta
		---xx-----x-----x----

		p.NumeroProposta,
		LEFT(CONVERT(VARCHAR, P.DataInicioVigencia, 120), 10) AS DataInicioVigencia,
		LEFT(CONVERT(VARCHAR, p.DataFimVigencia, 120), 10) AS DataFimVigencia,
	
		---Contrato
		CAST(p.IDContrato AS varchar(30)) AS IDContrato,
		c.[NumeroContrato],
		LEFT(CONVERT(VARCHAR,c.[DataInicioVigencia], 120), 10) AS DataInicioVigenciaContrato,
		LEFT(CONVERT(VARCHAR,c.[DataFimVigencia], 120), 10) AS DataFimVigenciaContrato,
		c.[ValorPremioTotalAtual] AS ValorPremioTotalAtualContrato,
		p.[ValorPremioBrutoEmissao] AS ValorPremio,
		C.[CodigoCorretor1] CodigoCorretor,
		C.[CNPJCorretor1] CNPJCorretor,
		C.[RazaoSocialCorretor1] RazaoSocialCorretor,

		---Produto
		---xx-----x-----x----
		PR.CODIGOCOMERCIALIZADO CodigoComercializado, 
		PR.DESCRICAO Produto,
		RPAR.Nome TipoProduto,
		s.Nome NomeSeguradora,

		LEFT(CONVERT(VARCHAR, p.[DataProposta], 120), 10) AS DataProposta,
	    LEFT(CONVERT(VARCHAR, c.[DataEmissao], 120), 10) AS DataContrato

  FROM [Corporativo].[Dados].[Contrato] C
  INNER JOIN [Corporativo].[Dados].[Proposta] P on C.ID = P.IDContrato
  INNER JOIN [Corporativo].[Dados].[PropostaCliente] PC on PC.IDProposta = P.ID
  INNER JOIN [Corporativo].[Dados].[Produto] PR on PR.ID = P.IDproduto
  INNER JOIN [Dados].[Seguradora] S on S.ID = p.IDSeguradora
  INNER JOIN [Corporativo].[Dados].[RamoPAR] RPAR on PR.IDRamoPAR = RPAR.id
  INNER JOIN [Corporativo].[Dados].[Sexo] Se on Se.ID = pc.IDSexo
  INNER JOIN [Corporativo].[Dados].[EstadoCivil] EC on EC.ID = pc.IDEstadoCivil
  WHERE 
  (CASE WHEN GETDATE() <= c.DataFimVigencia THEN 1
		 ELSE 0
	END ) = 1 AND
  --YEAR(DataInicioVigencia) = 2017  
  --AND PR.CODIGOCOMERCIALIZADO = '1403'
  PC.CPFCNPJ = @CPF ---'004.996.271-05'--'035.870.871-05'--'578.960.381-53'--
 -- DataFimVigencia > GetDate() 


