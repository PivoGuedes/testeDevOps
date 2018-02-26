

CREATE VIEW Marketing.DadosAtendimento 
AS
SELECT A.Protocolo,
	   A.TMA,
	   A.CPF,
	   A.NumeroTitulo,
	   A.Cod_Cliente,
	   A.UF,
	   A.DataNascimento,
	   A.IDStatus_Ligacao,
	   SL.Nome AS Status_Ligacao,
	   A.IDStatus_Final,
	   SF.Nome AS Status_Final,
	   AC.TelefoneEmail AS TelefoneEfetivo,
	   AC_tel.TelefoneEmail AS Telefone,
	   AC_email.TelefoneEmail AS Email,
	   A.IDProduto,
	   A.DateTime_Contato_Efetivo AS DataContato,
	   A.ProdutosAdquiridos,
	   A.Produto_Efetivado,
	   VEI.Nome AS NomeVeiculo,
	   A.BitVistoria,
	   A.NomeProduto,
	   A.ProdutoOferta,
	   A.CotacaoRealizada,
	   PROSP.Nome AS ProspectOferta,
	   A.Termino_Vigencia,
	   A.Data_Renovacao,
	   A.Premio_Atual,
	   A.Premio_Sem_Desconto,
	   A.FormaPagamento,
	   A.QtdParcelas,
	   A.NomeMailing,
	   A.NomeCampanha,
	   A.Regional_Par,
	   A.CPF_Solicitante,
	   A.Nome,
	   A.Contatante,
	   A.Contato_Retorno,
	   A.Cliente_Interessado,
	   A.TipoArquivo,
	   A.NomeArquivo,
	   A.Banco,
	   TipoFone.Nome AS TipoFone,
	   TDOR.Nome AS TipoDoador,
	   TIPA.Nome AS TipoAcao,
	   TPSA.Nome AS TipoSubAcao
FROM Dados.Atendimento AS A
LEFT OUTER JOIN Dados.Status_Ligacao AS SL
ON A.IDStatus_Ligacao = SL.ID
LEFT OUTER JOIN Dados.Status_Final AS SF
ON A.IDStatus_Final = SF.ID
LEFT OUTER JOIN Dados.AtendimentoContatos AS AC
ON A.IDTelefoneEfetivo = AC.ID
LEFT OUTER JOIN Dados.AtendimentoContatos AS AC_tel
ON A.IDTelefone = AC_tel.ID
LEFT OUTER JOIN Dados.AtendimentoContatos AS AC_email
ON A.IDEmail = AC_tel.ID
LEFT OUTER JOIN Dados.Produto AS PROD
ON A.IDProduto = PROD.ID
LEFT OUTER JOIN Dados.Veiculo AS VEI
ON VEI.ID = A.IDVeiculo
LEFT OUTER JOIN Dados.ProspectOferta AS PROSP
ON PROSP.ID = A.IDProspectOferta
LEFT OUTER JOIN Dados.Motivo_Contato AS MC
ON MC.ID = A.IDMotivo
LEFT OUTER JOIN Dados.TipoFone AS TipoFone
ON TipoFone.ID = A.IDTipoFone
LEFT OUTER JOIN Dados.TipoDoador AS TDOR
ON TDOR.ID = A.IDTipoDoador
LEFT OUTER JOIN Dados.TipoAcao AS TIPA
ON TIPA.ID = A.IDTipoAcao
LEFT OUTER JOIN Dados.TipoSubAcao AS TPSA
ON TPSA.ID = A.IDTipoSubAcao
