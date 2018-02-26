CREATE procedure [PowerBI].[proc_InserirFluxoComissaoSAF_Atendente]
(
	@DataArquivo	date
)
as

-- Faz uma NOVA carga do período informado, eliminando os registros anteriores (se houver).
delete from PowerBI.FluxoComissaoSAF_Arquivo
where
	DataArquivo = @DataArquivo and
	Tipo		= 'Atendente'

insert into PowerBI.FluxoComissaoSAF_Arquivo
select 
	convert(int, a.Codigo_BU) as CodigoBU,
	convert(int, a.CodigoProduto) as CodigoProduto,
	convert(bigint, a.NumeroRecibo) as NumeroRecibo,
	a.DataArquivo,
	replace(left(a.DataArquivo, 7), '-', '') as AnoMes,
	convert(bigint, a.NumeroMatricula) as NumeroMatricula,
	a.NumeroApoliceINT as NumeroContrato,
	a.NumeroTituloINT as NumeroProposta,
	convert(int, a.NumeroParcela) as NumeroParcela,
	round(convert(float, a.ValorCorretagem) * (case when a.CodigoOperacao = '1001' then 1 else -1 end), 2) as ValorCorretagem,
	a.NomeArquivo,
	'Atendente' as Tipo,
	case 
		when b.ID is null then 'Não'
		else 'Sim'
	end FluxoCompleto,
	null as Motivo,
	c.Nome,
	replace(replace(c.CPFCNPJ, '.', ''),  '-', '') as CPFCNPJ
from 
	[Fenae].[DC0701_CBN_Atendente] as a
left join
	[Dados].[PremiacaoCorrespondente] as b with (nolock) on
		b.NumeroRecibo		= convert(bigint, a.NumeroRecibo) and
		convert(bigint, b.NumeroContrato)	= a.NumeroApoliceINT and
		convert(bigint, b.NumeroProposta)	= a.NumeroTituloINT and
		b.NumeroParcela		= convert(int, a.NumeroParcela) and
		b.NumeroBilhete		= convert(bigint, a.NumeroBilhete) and		
		b.IDOperacao		= replace(replace(a.CodigoOperacao, '1001', 1), '1003', 4)
left join
	[Dados].[Correspondente] as c with (nolock) on
		c.ID		= b.IDCorrespondente and
		c.Matricula = convert(bigint, a.NumeroMatricula) and
		c.IDTipoCorrespondente = 2
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
	Tipo			= 'Atendente' and	
	NumeroMatricula = '0' and
	DataArquivo		= @DataArquivo

-- Fluxo Completo Não - Cadastro incompleto.
update PowerBI.FluxoComissaoSAF_Arquivo set
	Motivo = 'Cadastro incompleto.'
where
	FluxoCompleto	= 'Não' and
	Tipo			= 'Atendente' and	
	((CPFCNPJ is null or ltrim(rtrim(CPFCNPJ)) <> '') or (Nome is null or ltrim(rtrim(Nome)) <> '') or (NumeroMatricula is null or ltrim(rtrim(NumeroMatricula)) <> '0')) and
	DataArquivo = @DataArquivo

-- Fluxo Completo Não - Matrícula informada errada.
update a set
	a.Motivo = 'A matrícula informada corresponde à um empresário.'
from
	PowerBI.FluxoComissaoSAF_Arquivo as a
inner join
	[Dados].[Correspondente] as b on 
		b.Matricula = a.NumeroMatricula and
		b.IDTipoCorrespondente = 1 
where
	a.FluxoCompleto = 'Não' and
	a.Tipo			= 'Atendente' and
	a.DataArquivo	= @DataArquivo

-- Fluxo Completo Não - Motivo não mapeado pelas regras de negócio
update PowerBI.FluxoComissaoSAF_Arquivo set
	Motivo = 'Motivo não mapeado pelas regras de negócio.'
where
	FluxoCompleto	= 'Não' and
	Tipo			= 'Atendente' and
	DataArquivo		= @DataArquivo and
	Motivo is null
