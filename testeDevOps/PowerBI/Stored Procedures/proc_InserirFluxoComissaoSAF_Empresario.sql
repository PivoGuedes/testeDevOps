CREATE procedure [PowerBI].[proc_InserirFluxoComissaoSAF_Empresario]
(
	@DataArquivo	date
)
as

-- Faz uma NOVA carga do período informado, eliminando os registros anteriores (se houver).
delete from PowerBI.FluxoComissaoSAF_Arquivo
where
	DataArquivo = @DataArquivo and
	Tipo		= 'Empresário'

insert into PowerBI.FluxoComissaoSAF_Arquivo
select 
	convert(int, a.Codigo_BU) as CodigoBU,
	convert(int, a.CodigoProduto) as CodigoProduto,
	convert(bigint, a.NumeroRecibo) as NumeroRecibo,
	a.DataArquivo,
	replace(left(a.DataArquivo, 7), '-', '') as AnoMes,
	convert(bigint, a.NumeroMatricula) as NumeroMatricula,
	a.NumeroApoliceINT as NumeroContrato,
	convert(bigint, a.NumeroTitulo) as NumeroProposta,
	convert(int, a.NumeroParcela) as NumeroParcela,
	round(convert(float, a.ValorCorretagem) * (case when a.CodigoOperacao = '1001' then 1 else -1 end), 2) as ValorCorretagem,
	a.NomeArquivo,
	'Empresário' as Tipo,
	case 
		when b.ID is null then 'Não'
		else 'Sim'
	end FluxoCompleto,
	null as Motivo,
	c.Nome,
	replace(replace(replace(c.CPFCNPJ, '.', ''), '/', ''), '-', '') as CPFCNPJ
from 
	[Fenae].[DC0701_CBN_Empresario] as a
left join
	[Dados].[PremiacaoCorrespondente] as b with (nolock) on
		b.NumeroRecibo		= convert(bigint, a.NumeroRecibo) and
		convert(bigint, b.NumeroContrato)	= a.NumeroApoliceINT and
		convert(bigint, b.NumeroProposta)	= convert(bigint, a.NumeroTitulo) and
		b.NumeroParcela		= convert(int, a.NumeroParcela) and
		b.NumeroBilhete		= convert(bigint, a.NumeroBilhete) and		
		b.IDOperacao		= replace(replace(a.CodigoOperacao, '1001', 1), '1003', 4)
left join
	[Dados].[Correspondente] as c with (nolock) on
		c.ID		= b.IDCorrespondente and
		c.Matricula = convert(bigint, a.NumeroMatricula) and
		c.IDTipoCorrespondente = 1
left join
	[Dados].[ComissaoOperacao] as d on 
		d.ID		= b.IDOperacao and
		d.Codigo	= convert(int, a.CodigoOperacao)
where
	a.DataArquivo = @DataArquivo

-- Fluxo Completo Não - Matrícula não existente.
update PowerBI.FluxoComissaoSAF_Arquivo set
	Motivo = 'Matrícula inválida.'
where
	FluxoCompleto	= 'Não' and
	Tipo			= 'Empresário' and	
	NumeroMatricula = '0' and
	DataArquivo	= @DataArquivo

-- Fluxo Completo Não - Cadastro incompleto.
update PowerBI.FluxoComissaoSAF_Arquivo set
	Motivo = 'Cadastro incompleto.'
where
	FluxoCompleto	= 'Não' and
	Tipo			= 'Empresário' and	
	((CPFCNPJ is null or ltrim(rtrim(CPFCNPJ)) <> '') or (Nome is null or ltrim(rtrim(Nome)) <> '') or (NumeroMatricula is null or ltrim(rtrim(NumeroMatricula)) <> '0')) and
	DataArquivo	= @DataArquivo

-- Fluxo Completo Não - Matrícula informada errada.
update a set
	a.Motivo = 'A matrícula informada corresponde à um atendente.'
from
	PowerBI.FluxoComissaoSAF_Arquivo as a
inner join
	[Dados].[Correspondente] as b on 
		b.Matricula = a.NumeroMatricula and
		b.IDTipoCorrespondente = 2
where
	a.FluxoCompleto = 'Não' and
	a.Tipo			= 'Empresário' and
	a.DataArquivo	= @DataArquivo

-- Fluxo Completo Não - Motivo não mapeado pelas regras de negócio
update PowerBI.FluxoComissaoSAF_Arquivo set
	Motivo = 'Motivo não mapeado pelas regras de negócio.'
where
	FluxoCompleto	= 'Não' and
	Tipo			= 'Empresário' and
	DataArquivo		= @DataArquivo and
	Motivo is null

/*
-------------------
---------------
--------- Insere o fluxo de pagamento do lotérico (empresário)
*/

declare @AnoMes	int = convert(varchar(6), @DataArquivo, 112)

-- Apaga os registros anteriores (se houver)
delete from PowerBI.FluxoComissaoSAF_Pagamento
where
	AnoMes = @AnoMes

-- Insere o novo lote
insert into PowerBI.FluxoComissaoSAF_Pagamento
select 
	@AnoMes,
	a.CNPJ,
	a.Nome,
	a.DocEmpresa,
	a.Banco,
	a.Agencia,
	a.Conta,
	a.Valor,
	c.ValorBox,
	coalesce(b.Ocorrencia01, 'Sem informação de retorno de crédito do banco.') as Ocorrencia01,
	b.CodOcorrencia,
	case
		when b.CodOcorrencia is null then 0
		when b.CodOcorrencia not in ('00', 'BD') then 0
		else 1
	end PagamentoOk
from 
	Financeiro.EnvioBancarioSAF as a
full join
	Financeiro.RetornoBancarioSAF as b on 
		b.DocEmpresa	= a.DocEmpresa and
		b.AnoMes		= a.AnoMes
full join
	(
		select
			a.AnoMes,
			replace(replace(replace(b.CPFCNPJ, '.', ''), '-', ''), '/', '') as CNPJ,
			sum(a.ValorCorretagem) as ValorBox
		from 
			Dados.PremiacaoCorrespondente as a
		inner join
			Dados.Correspondente as b on 
				b.ID = a.IDCorrespondente
		where
			a.IDOperacao = 1 and
			a.IDTipoProduto	= 1 and
			b.IDTipoCorrespondente = 1 and
			((b.CPFCNPJ is not null and ltrim(rtrim(b.CPFCNPJ)) <> '') and (b.Nome is not null and ltrim(rtrim(b.Nome)) <> '') and (b.Matricula is not null and ltrim(rtrim(b.Matricula)) <> '0'))
		group by
			a.AnoMes,
			b.CPFCNPJ
	) as c on 
		c.CNPJ		= a.CNPJ and
		c.AnoMes	= a.AnoMes
where
		c.AnoMes	= @AnoMes