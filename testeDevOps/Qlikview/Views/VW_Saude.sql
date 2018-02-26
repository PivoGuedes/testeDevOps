








CREATE VIEW [Qlikview].[VW_Saude] AS 
WITH PROPOSTAS AS (
SELECT p.ID as IDProposta,p.DataInicioVigencia as DataInicioVigenciaProposta,p.DataFimVigencia as DataFimVigenciaProposta,
		pv.ID as IDPropostaSaudeVida, pv.DataVigencia as DataInicioVigenciaVida,pv.DataFimVigencia as DataFimVigenciaVida,
		ctr.ID as IDCliente,cv.ID as IDCanalVenda,cv.Nome as NomeCanalVenda,cv.IDTipoCanal,
		Case when cv.IDTipoCanal = 1 then 'Corretor Proprio'
			when cv.IDTipoCanal = 2 then  'Corretor Externo'
		End as TipoCanal,
		s.ID as IDSegmento, s.Nome as NomeSegmento,s.IDTipoSegmento,
		--Case When IDTipoSegmento = 1  THEN 'PME SAUDE'
		--	 When IDTipoSegmento = 2 THEN 'PME ODONTO'
		--	 When IDTipoSegmento = 3 THEN 'MIDDLE SAUDE'
		--	 When IDTipoSegmento = 4 THEN 'MIDDLE ODONTO'
		--	 When IDTipoSegmento = 5 THEN 'CORPORATE SAUDE'
		--	 When IDTipoSegmento = 6 THEN 'CORPORATE ODONTO'
		--	 When IDTipoSegmento = 7 THEN 'ODONTO PF'
		--	 When IDTipoSegmento = 8 THEN 'ADESAO'
		--End as NomeTipoSegmento,
		ts.Nome as NomeTipoSegmento,
		pc.Nome as NomeCliente,
		tcs.ID as IDTipoClienteSaude,
		tcs.Nome as NomeTipoClienteSaude,
		tes.ID as IDTipoEmpresaSaude,
		tes.Nome as NomeTipoEmpresaSaude,
		pc.CPFCNPJ as CPFCNPJ
	
FROM DADOS.PROPOSTA p
INNER JOIN DADOS.PropostaSaude ps on  ps.IDPropostaOrigem = p.ID
inner join Dados.PropostaSaudeFamilia pf on pf.IDPropostaSaude = ps.ID
inner join Dados.PropostaSaudeVida pv on pv.IDPropostaSaudeFamilia = pf.ID
inner join Dados.PropostaCliente pc on pc.IDProposta = p.ID
inner join Dados.SegmentoSaude s on Cast(p.CodigoSegmento as int) = s.Codigo
inner join Dados.CanalVendaPARSaude cv on cv.ID = ps.IDCanalVendaPARSaude
inner join Dados.TipoSegmento ts on ts.ID = s.IDTipoSegmento
inner join Dados.TipoClienteSaude tcs on tcs.ID = s.IDTipoClienteSaude
inner join Dados.TipoEmpresaSaude tes on tes.ID = s.IDTipoEmpresaSaude
left  join Dados.Contrato ctr on ctr.IDProposta = p.ID

)
,
COMISSAO AS (SELECT c.DataRecibo,cs.NomeContrato as NomeCliente,cs.QtApolices,c.ValorBase as ValorPremio,c.ValorCorretagem as ValorComissao,
				cv.ID as IDCanalVenda,cv.Nome as NomeCanalVenda,		cv.IDTipoCanal,
				Case when cv.IDTipoCanal = 1 then 'Corretor Proprio'
					when cv.IDTipoCanal = 2 then  'Corretor Externo'
				End as TipoCanal,
				ss.ID as IDSegmento, ss.Nome as NomeSegmento,ss.IDTipoSegmento,
				--Case When IDTipoSegmento = 1  THEN 'PME SAUDE'
				--	 When IDTipoSegmento = 2 THEN 'PME ODONTO'
				--	 When IDTipoSegmento = 3 THEN 'MIDDLE SAUDE'
				--	 When IDTipoSegmento = 4 THEN 'MIDDLE ODONTO'
				--	 When IDTipoSegmento = 5 THEN 'CORPORATE SAUDE'
				--	 When IDTipoSegmento = 6 THEN 'CORPORATE ODONTO'
				--	 When IDTipoSegmento = 7 THEN 'ODONTO PF'
				--	 When IDTipoSegmento = 8 THEN 'ADESAO'
				--End as NomeTipoSegmento,
				ts.Nome as NomeTipoSegmento,
				NumeroParcela,
				c.IDContrato as IDCliente,
				tcs.ID as IDTipoClienteSaude,
				tcs.Nome as NomeTipoClienteSaude,
				tes.ID as IDTipoEmpresaSaude,
				tes.Nome as NomeTipoEmpresaSaude,
				cs.TipoComissao as TipoComissao,
				c.ID as IDComissao,
				cs.CPFCNPJ  as CPFCNPJ

		FROM DADOS.Comissao c 
		INNER JOIN Dados.ComissaoSaude cs on cs.IDComissao = c.ID
		INNER JOIN Dados.CanalVendaPARSaude cv on cv.ID = cs.IDCanalVendaPARSaude
		inner join Dados.SegmentoSaude ss on ss.ID = cs.IDSegmento
		inner join Dados.TipoSegmento ts on ss.IDTipoSegmento = ts.ID
		inner join Dados.TipoClienteSaude tcs on tcs.ID = ss.IDTipoClienteSaude
		inner join Dados.TipoEmpresaSaude tes on tes.ID = ss.IDTipoEmpresaSaude
		

)
SELECT distinct IDProposta,DataInicioVigenciaProposta,DataFimVigenciaProposta,IDPropostaSaudeVida,DataInicioVigenciaVida,
		DataFimVigenciaVida,Coalesce(PROPOSTAS.IDCliente,COMISSAO.IDCliente) IDCliente,Coalesce(PROPOSTAS.IDCanalVenda,COMISSAO.IDCanalVenda) IDCanalVenda,
		Coalesce(PROPOSTAS.NomeCanalVenda,COMISSAO.NomeCanalVenda) NomeCanalVenda,
		Coalesce(PROPOSTAS.IDTipoCanal,COMISSAO.IDTipoCanal) IDTipoCanal,Coalesce(PROPOSTAS.TipoCanal,COMISSAO.TipoCanal) TipoCanal,
		Coalesce(PROPOSTAS.IDSegmento,COMISSAO.IDSegmento) IDSegmento,Coalesce(PROPOSTAS.NomeSegmento,COMISSAO.NomeSegmento) NomeSegmento,
		Coalesce(PROPOSTAS.IDTipoSegmento,COMISSAO.IDTipoSegmento) IDTipoSegmento,Coalesce(PROPOSTAS.NomeTipoSegmento,COMISSAO.NomeTipoSegmento) NomeTipoSegmento,
		Coalesce(PROPOSTAS.NomeCliente,COMISSAO.NomeCliente) NomeCliente,DataRecibo,QtApolices,ValorPremio,ValorComissao,NumeroParcela,
		Coalesce(PROPOSTAS.IDTipoClienteSaude,COMISSAO.IDTipoClienteSaude) as IDTipoClienteSaude,Coalesce(PROPOSTAS.NomeTipoClienteSaude,COMISSAO.NomeTipoClienteSaude) as NomeTipoClienteSaude,
		Coalesce(PROPOSTAS.IDTipoEmpresaSaude,COMISSAO.IDTipoEmpresaSaude) as IDTipoEmpresaSaude,Coalesce(PROPOSTAS.NomeTipoEmpresaSaude,COMISSAO.NomeTipoEmpresaSaude) as NomeTipoEmpresaSaude,
		COMISSAO.IDComissao,COMISSAO.TipoComissao,COALESCE(PROPOSTAS.CPFCNPJ,COMISSAO.CPFCNPJ)  as CPFCNPJ
		

 FROM 
PROPOSTAS
full outer join COMISSAO ON COMISSAO.IDCliente = PROPOSTAS.IDCliente










