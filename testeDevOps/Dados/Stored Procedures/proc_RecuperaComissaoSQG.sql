
CREATE procedure [Dados].[proc_RecuperaComissaoSQG] @DataCompetencia date as 

begin
	select sum(case when  c.valorbase < 0 then valorbase end) as Restituicao,sum(case when  c.valorbase > 0 then valorbase end) as ValorLiquido,sum(valorcorretagem) as
	 ValorComissao, sum(PremioSQg) as Valorbruto,c.DataCompetencia,count(*) QtdRegistros, c.NumeroRecibo
	from (
	select  ROW_NUMBER() OVER(PARTITION BY ID order by dataquitacaoParcela) Orde,*
	from dados.Comissao_Partitioned c
	CROSS APPLY
	(
		select PremioSqg
			from (
			select PremioSqg,ROW_Number() OVER (PARTITION BY q.IDContrato,NumeroPrestacaoPaga,t.Codigo,q.PremioSqg Order by DataPagamentoPremio desc) Ordem
			from dados.SQGImob q
			inner join dados.TipoMovimentoSQG t
			on t.ID=q.IDTipoMovimentoSQG
			where q.IDContrato=c.IDContrato
			and q.NumeroPrestacaoPaga=c.NumeroParcela
			and c.IDOperacao = case WHEN t.Codigo = 'E' THEN 4 ELSE 1 END
			and c.DataQuitacaoParcela=q.DataPAgamentoPremio
		) as q
		where Ordem =1
	) sqg
	where idempresa = 52 
	 and c.DataCompetencia = @DataCompetencia
	 and c.IDProduto in (804,803,802) 
	 --and c.IDContrato = 27982012
	 --and c.NumeroParcela=24
	 ) as c
	 where Orde =1
	group by c.DataCompetencia, c.NumeroRecibo
	
end

