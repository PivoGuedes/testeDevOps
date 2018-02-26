
CREATE VIEW Marketing.vw_ContratoConsorcio
AS
SELECT 
	CC.IDContrato,
	CC.Numero_Grupo, 
	CC.Numero_Cota, 
	CC.Numero_Versao, 
	CC.Dia_Vencimento, 
	CC.Operacao, 
	CC.Conta, 
	CC.Digito, 
	CC.Data_Pagamento_Primeira_Parcela, 
	CC.Prazo_grupo_meses, 
	CC.prazo_cota_meses, 
	CC.valor_data_venda, 
	CC.valor_credito_atualizado, 
	CC.data_contemplacao, 
	CC.data_confirmacao,
	C.DataEmissao,
	C.DataInicioVigencia,
	C.DataFimVigencia,
	C.ValorPremioTotal,
	C.NumeroContrato,
	CL.NomeCliente,
	CL.TipoPessoa,
	CL.CPFCNPJ,
	TP.Descricao AS TipoPagamento,
	U.Codigo AS CodigoAgencia,
	UH.Nome AS NomeAgencia,
	F.Nome AS NomeVendedor,
	F.Matricula AS MatriculaVendedor,
	O.Descricao AS OrigemVenda,
	C.DataArquivo,
	C.Arquivo	
FROM Dados.ContratoConsorcio AS CC
INNER JOIN Dados.Contrato AS C 
ON CC.IDContrato=C.ID
LEFT OUTER JOIN Dados.ContratoCliente AS CL
ON CL.IDContrato=C.ID
INNER JOIN Dados.TipoPagamentoConsorcio AS TP
ON TP.ID=CC.IDTipoPagamentoConsorcio
INNER JOIN Dados.Unidade AS U
ON U.ID=CC.IDAgencia
INNER JOIN Dados.UnidadeHistorico AS UH
ON UH.IDUnidade=U.ID AND UH.LastValue=1
INNER JOIN Dados.Funcionario AS F
ON F.ID=CC.IDVendedor
INNER JOIN Dados.OrigemVendaConsorcio AS O
ON O.ID=CC.IDOrigemVendaConsorcio