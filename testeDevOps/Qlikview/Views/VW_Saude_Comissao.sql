











CREATE VIEW [Qlikview].[VW_Saude_Comissao] AS 
WITH COMISSAO AS (SELECT c.DataRecibo,cs.NomeContrato as NomeCliente,cs.QtApolices,c.ValorBase as ValorPremio,c.ValorCorretagem as ValorComissao,
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
				cs.CPFCNPJ  as CPFCNPJ,
				c.IDProposta,
				cc.IDContrato as IDcontratoCliente,
				cc.NomeCliente as NomeContratoCliente
			
		FROM DADOS.Comissao c 
		INNER JOIN Dados.ComissaoSaude cs on cs.IDComissao = c.ID
		INNER JOIN Dados.CanalVendaPARSaude cv on cv.ID = cs.IDCanalVendaPARSaude
		inner join Dados.SegmentoSaude ss on ss.ID = cs.IDSegmento
		inner join Dados.TipoSegmento ts on ss.IDTipoSegmento = ts.ID
		inner join Dados.TipoClienteSaude tcs on tcs.ID = ss.IDTipoClienteSaude
		inner join Dados.TipoEmpresaSaude tes on tes.ID = ss.IDTipoEmpresaSaude
		left join Dados.ContratoCliente cc on cc.IDContrato = c.IDContrato		
)
SELECT distinct top 100 percent  COMISSAO.IDProposta,--DataInicioVigenciaProposta,DataFimVigenciaProposta,IDPropostaSaudeVida,DataInicioVigenciaVida,DataFimVigenciaVida,
		COMISSAO.IDCliente as IDCliente,COMISSAO.IDCanalVenda,COMISSAO.NomeCanalVenda,COMISSAO.IDTipoCanal,
		/*PROPOSTAS.TipoCanal,*/COMISSAO.IDSegmento,COMISSAO.NomeSegmento,COMISSAO.IDTipoSegmento,COMISSAO.NomeTipoSegmento,
		COALESCE(COMISSAO.NomeContratoCliente,COMISSAO.NomeCliente) as NomeCliente,DataRecibo,QtApolices,ValorPremio,ValorComissao,NumeroParcela,COMISSAO.IDTipoClienteSaude,
		COMISSAO.NomeTipoClienteSaude,COMISSAO.IDTipoEmpresaSaude,COMISSAO.NomeTipoEmpresaSaude,
		COMISSAO.IDComissao,COMISSAO.TipoComissao,COMISSAO.CPFCNPJ

	
 FROM 
COMISSAO
	ORDER BY IDCliente,NumeroParcela,idcomissao

