CREATE PROCEDURE Dados.proc_RecuperaSimulacaoSalesForceCPF @CPF VARCHAR(20) 
as
SELECT TOP 1  sc.Descricao AS SituacaoCalculo,v.Nome AS Veiculo,e.Descricao AS EstadoCivil,tc.Descricao AS TipoCliente,
		u.Codigo AS CodigoAgencia,sa.* 
FROM [Dados].[SimuladorAuto]  sa 
INNER JOIN	Dados.SituacaoCalculo sc ON sc.ID = sa.IDSituacaoCalculo
INNER JOIN Dados.Veiculo v ON v.id = sa.IDVeiculo
INNER JOIN Dados.EstadoCivil e ON e.id = sa.IDEstadoCivil
INNER JOIN Dados.TipoCliente tc ON tc.id = sa.IDTipoCliente
INNER JOIN Dados.Unidade u ON u.id = sa.IDAgenciaVenda
WHERE sa.cpfcnpj = @cpf
ORDER BY sa.DataCalculo DESC,sa.DataArquivo desc
OPTION(RECOMPILE)