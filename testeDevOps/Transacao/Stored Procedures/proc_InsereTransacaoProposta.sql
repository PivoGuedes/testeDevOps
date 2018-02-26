
CREATE PROCEDURE Transacao.proc_InsereTransacaoProposta
AS
BEGIN TRY
	TRUNCATE TABLE Transacao.DimRedeCaixa;
	--BEGIN TRANSACTION
	;with CteProposta as (
		select NuApolice NumeroApolice,NuProposta NumeroProposta,NuCertificado NumeroApolicecertificado,VlPremioTotal,FlNova,FlRenovacaoResidencial,'' FlIndRenovacaoAutomaticaResidencial
			   ,CdIndicador,Nmsistema,'' FlRenovada,DtProposta DataProposta ,DtEmissao DataEmissao,CdSituacaoProposta DescricaoSituacaoProposta,VlPremioLiquido,CdCliente CodigoCliente,DsRamoCS DescricaoRamoCS
			   ,CdProduto CodigoProduto
		from seguros_temp
		where CdProduto <> 6118
		AND ISNULL(NmSistema,'') <> 'SIAPX'
		UNION
		select idApoliceSeguro,idContrato,'',0,'S','','',null,'','',DataArquivo,DataArquivo,'',0,CPF,'Habitacional',6118
		from HB_LARMAIS_VENDAS
	)
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select DISTINCT t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(s.CdIndicador,-1) CdIndicador,ISNULL(pp.CdProduto,-1) CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			ISNULL(CAST(CAST(s.NumeroApolice as Bigint) as varchar(20)),'') NuApolice, ISNULL(CAST(CAST(s.NumeroApoliceCertificado as Bigint) as varchar(20)),'') NuCertificado
			,ISNULL(CAST(CAST(s.NumeroProposta as Bigint) as varchar(20)),'') NuProposta,
			case WHEN g.Descricao in ('Financiamento Auto','Financiamento Habitacional','Capital de Giro') AND ISNULL(NumeroProposta,'') <> ''
					THEN t.VlCredito
				WHEN s.NmSistema = 'SIAPX' THEN t.VlCredito
				ELSE 
					0
			END VlImportanciaSegurada
			,ISNULL(s.vlPremioTotal,0) VlPremio, ISNULL(FlNova,'') FlNova,ISNULL(FlRenovacaoResidencial,'') FlRenovacaoResidencial,ISNULL(FlIndRenovacaoAutomaticaResidencial,'') FlIndRenovacaoAutomaticaResidencial
			,ISNULL(FlRenovada,'') FlRenovada, CASE WHEN s.NumeroProposta IS NULL THEN 0 ELSE 1 END FlOfertaQualificada,
			ISNULL(s.DataProposta,'1900-01-01') DtProposta, ISNULL(CAST(YEAR(DataProposta) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataProposta) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesProposta,
			ISNULL(s.DataEmissao,'1900-01-01') DtEmissao, ISNULL(CAST(Year(DataEmissao) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataEmissao) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesEmissao,
			ISNULL(NmSistema,'') DsSistema, ISNULL(s.DescricaoSituacaoProposta,'') DsStatus, ISNULL(s.CdIndicador,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, t.VlCredito VlTransacao, ISNULL(VlPremioLiquido,0) VlPremioLiquido
		from Transacao.DimTransacao t
		INNER JOIN Transacao.DmTipoTransacao td
		on td.id=t.IdTipoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = td.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT join CteProposta s
		on (t.CdCliente = s.CodigoCliente AND CdCliente <> -1 AND CodigoCliente <> -1)
		AND ISNULL(s.NmSistema,'') <> 'SIAPX'
		AND (
			(DATEDIFF(day,dt.DtDia,DataProposta) between tt.JanelaInicio and tt.JanelaFim and s.CodigoProduto<>6118)
			OR
			(s.CodigoProduto=6118 AND t.NuContratoTransacao=s.NumeroProposta)
		)
		LEFT JOIN Dados.DimProduto pp
		on pp.cdproduto=s.codigoProduto
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = cast(s.cdindicador as varchar(6))
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where g.id not in (2,8,1,4,7)
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	AND ISNULL(T.NuProposta,'') = ISNULL(C.NuProposta,'')
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;

	;with CteProposta as (
		select NuApolice NumeroApolice,NuProposta NumeroProposta,NuCertificado NumeroApolicecertificado,VlPremioTotal,FlNova,FlRenovacaoResidencial,'' FlIndRenovacaoAutomaticaResidencial
			   ,CdIndicador,Nmsistema,'' FlRenovada,DtProposta DataProposta ,DtEmissao DataEmissao,CdSituacaoProposta DescricaoSituacaoProposta,VlPremioLiquido,CdCliente CodigoCliente,DsRamoCS DescricaoRamoCS
			   ,CdProduto CodigoProduto
		from seguros_temp
		where CdProduto <> 6118
		AND ISNULL(NmSistema,'') <> 'SIAPX'
	)
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select DISTINCT t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(s.CdIndicador,-1) CdIndicador,ISNULL(pp.CdProduto,-1) CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			ISNULL(CAST(CAST(s.NumeroApolice as Bigint) as varchar(20)),'') NuApolice, ISNULL(CAST(CAST(s.NumeroApoliceCertificado as Bigint) as varchar(20)),'') NuCertificado
			,ISNULL(CAST(CAST(s.NumeroProposta as Bigint) as varchar(20)),'') NuProposta,
			case WHEN g.Descricao in ('Financiamento Auto','Financiamento Habitacional','Capital de Giro') AND ISNULL(NumeroProposta,'') <> ''
					THEN t.VlCredito
				WHEN s.NmSistema = 'SIAPX' THEN t.VlCredito
				ELSE 
					0
			END VlImportanciaSegurada
			,ISNULL(s.vlPremioTotal,0) VlPremio, ISNULL(FlNova,'') FlNova,ISNULL(FlRenovacaoResidencial,'') FlRenovacaoResidencial,ISNULL(FlIndRenovacaoAutomaticaResidencial,'') FlIndRenovacaoAutomaticaResidencial
			,ISNULL(FlRenovada,'') FlRenovada, CASE WHEN s.NumeroProposta IS NULL THEN 0 ELSE 1 END FlOfertaQualificada,
			ISNULL(s.DataProposta,'1900-01-01') DtProposta, ISNULL(CAST(YEAR(DataProposta) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataProposta) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesProposta,
			ISNULL(s.DataEmissao,'1900-01-01') DtEmissao, ISNULL(CAST(Year(DataEmissao) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataEmissao) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesEmissao,
			ISNULL(NmSistema,'') DsSistema, ISNULL(s.DescricaoSituacaoProposta,'') DsStatus, ISNULL(s.CdIndicador,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, t.VlCredito VlTransacao, ISNULL(VlPremioLiquido,0) VlPremioLiquido
		from Transacao.DimTransacao t
		INNER JOIN Transacao.DmTipoTransacao td
		on td.id=t.IdTipoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = td.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT join CteProposta s
		on (t.CdCliente = s.CodigoCliente AND CdCliente <> -1 AND CodigoCliente <> -1)
		AND ISNULL(s.NmSistema,'') <> 'SIAPX'
		AND DATEDIFF(day,dt.DtDia,DataProposta) between tt.JanelaInicio and tt.JanelaFim 
		AND DescricaoRamoCS not in ('Prestamista','Prestamista PJ')
		LEFT JOIN Dados.DimProduto pp
		on pp.cdproduto=s.codigoProduto
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = cast(s.cdindicador as varchar(6))
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where g.id in (2,8)
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	AND ISNULL(T.NuProposta,'') = ISNULL(C.NuProposta,'')
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;


	;with CteProposta as (
		select NuApolice NumeroApolice,NuProposta NumeroProposta,NuCertificado NumeroApolicecertificado,VlPremioTotal,FlNova,FlRenovacaoResidencial,'' FlIndRenovacaoAutomaticaResidencial
			   ,CdIndicador,Nmsistema,'' FlRenovada,DtProposta DataProposta ,DtEmissao DataEmissao,CdSituacaoProposta DescricaoSituacaoProposta,VlPremioLiquido,CdCliente CodigoCliente,DsRamoCS DescricaoRamoCS
			   ,CdProduto CodigoProduto
		from seguros_temp
		where CdProduto <> 6118
		AND ISNULL(NmSistema,'') <> 'SIAPX'
	)
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select DISTINCT t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(s.CdIndicador,-1) CdIndicador,ISNULL(pp.CdProduto,-1) CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			ISNULL(CAST(CAST(s.NumeroApolice as Bigint) as varchar(20)),'') NuApolice, ISNULL(CAST(CAST(s.NumeroApoliceCertificado as Bigint) as varchar(20)),'') NuCertificado
			,ISNULL(CAST(CAST(s.NumeroProposta as Bigint) as varchar(20)),'') NuProposta,
			case WHEN g.Descricao in ('Financiamento Auto','Financiamento Habitacional','Capital de Giro') AND ISNULL(NumeroProposta,'') <> ''
					THEN t.VlCredito
				WHEN s.NmSistema = 'SIAPX' THEN t.VlCredito
				ELSE 
					0
			END VlImportanciaSegurada
			,ISNULL(s.vlPremioTotal,0) VlPremio, ISNULL(FlNova,'') FlNova,ISNULL(FlRenovacaoResidencial,'') FlRenovacaoResidencial,ISNULL(FlIndRenovacaoAutomaticaResidencial,'') FlIndRenovacaoAutomaticaResidencial
			,ISNULL(FlRenovada,'') FlRenovada, CASE WHEN s.NumeroProposta IS NULL THEN 0 ELSE 1 END FlOfertaQualificada,
			ISNULL(s.DataProposta,'1900-01-01') DtProposta, ISNULL(CAST(YEAR(DataProposta) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataProposta) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesProposta,
			ISNULL(s.DataEmissao,'1900-01-01') DtEmissao, ISNULL(CAST(Year(DataEmissao) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataEmissao) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesEmissao,
			ISNULL(NmSistema,'') DsSistema, ISNULL(s.DescricaoSituacaoProposta,'') DsStatus, ISNULL(s.CdIndicador,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, t.VlCredito VlTransacao, ISNULL(VlPremioLiquido,0) VlPremioLiquido
		from Transacao.DimTransacao t
		INNER JOIN Transacao.DmTipoTransacao td
		on td.id=t.IdTipoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = td.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT join CteProposta s
		on (t.CdCliente = s.CodigoCliente AND CdCliente <> -1 AND CodigoCliente <> -1)
		AND ISNULL(s.NmSistema,'') <> 'SIAPX'
		AND DATEDIFF(day,dt.DtDia,DataProposta) between tt.JanelaInicio and tt.JanelaFim
		AND s.codigoProduto not in(7707,7711,7713,7715)
		----rural 7705/7725
		LEFT JOIN Dados.DimProduto pp
		on pp.cdproduto=s.codigoProduto
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = cast(s.cdindicador as varchar(6))
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where g.id =4
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	AND ISNULL(T.NuProposta,'') = ISNULL(C.NuProposta,'')
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;



	;with CteProposta as (
		select NuApolice NumeroApolice,NuProposta NumeroProposta,NuCertificado NumeroApolicecertificado,VlPremioTotal,FlNova,FlRenovacaoResidencial,'' FlIndRenovacaoAutomaticaResidencial
			   ,CdIndicador,Nmsistema,'' FlRenovada,DtProposta DataProposta ,DtEmissao DataEmissao,CdSituacaoProposta DescricaoSituacaoProposta,VlPremioLiquido,CdCliente CodigoCliente,DsRamoCS DescricaoRamoCS
			   ,CdProduto CodigoProduto
		from seguros_temp
		where CdProduto <> 6118
		AND ISNULL(NmSistema,'') <> 'SIAPX'
	)
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select DISTINCT t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(s.CdIndicador,-1) CdIndicador,ISNULL(pp.CdProduto,-1) CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			ISNULL(CAST(CAST(s.NumeroApolice as Bigint) as varchar(20)),'') NuApolice, ISNULL(CAST(CAST(s.NumeroApoliceCertificado as Bigint) as varchar(20)),'') NuCertificado
			,ISNULL(CAST(CAST(s.NumeroProposta as Bigint) as varchar(20)),'') NuProposta,
			case WHEN g.Descricao in ('Financiamento Auto','Financiamento Habitacional','Capital de Giro') AND ISNULL(NumeroProposta,'') <> ''
					THEN t.VlCredito
				WHEN s.NmSistema = 'SIAPX' THEN t.VlCredito
				ELSE 
					0
			END VlImportanciaSegurada
			,ISNULL(s.vlPremioTotal,0) VlPremio, ISNULL(FlNova,'') FlNova,ISNULL(FlRenovacaoResidencial,'') FlRenovacaoResidencial,ISNULL(FlIndRenovacaoAutomaticaResidencial,'') FlIndRenovacaoAutomaticaResidencial
			,ISNULL(FlRenovada,'') FlRenovada, CASE WHEN s.NumeroProposta IS NULL THEN 0 ELSE 1 END FlOfertaQualificada,
			ISNULL(s.DataProposta,'1900-01-01') DtProposta, ISNULL(CAST(YEAR(DataProposta) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataProposta) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesProposta,
			ISNULL(s.DataEmissao,'1900-01-01') DtEmissao, ISNULL(CAST(Year(DataEmissao) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataEmissao) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesEmissao,
			ISNULL(NmSistema,'') DsSistema, ISNULL(s.DescricaoSituacaoProposta,'') DsStatus, ISNULL(s.CdIndicador,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, t.VlCredito VlTransacao, ISNULL(VlPremioLiquido,0) VlPremioLiquido
		from Transacao.DimTransacao t
		INNER JOIN Transacao.DmTipoTransacao td
		on td.id=t.IdTipoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = td.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT join CteProposta s
		on (t.CdCliente = s.CodigoCliente AND CdCliente <> -1 AND CodigoCliente <> -1)
		AND ISNULL(s.NmSistema,'') <> 'SIAPX'
		AND DATEDIFF(day,dt.DtDia,DataProposta) between tt.JanelaInicio and tt.JanelaFim 
		AND s.CodigoProduto not in (7725,7711,7713,7715)
		----rural 7705/7725
		LEFT JOIN Dados.DimProduto pp
		on pp.cdproduto=s.codigoProduto
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = cast(s.cdindicador as varchar(6))
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where g.id =1
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	AND ISNULL(T.NuProposta,'') = ISNULL(C.NuProposta,'')
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;

	;with CteProposta as (
		select NuApolice NumeroApolice,NuProposta NumeroProposta,NuCertificado NumeroApolicecertificado,VlPremioTotal,FlNova,FlRenovacaoResidencial,'' FlIndRenovacaoAutomaticaResidencial
			   ,CdIndicador,Nmsistema,'' FlRenovada,DtProposta DataProposta ,DtEmissao DataEmissao,CdSituacaoProposta DescricaoSituacaoProposta,VlPremioLiquido,CdCliente CodigoCliente,DsRamoCS DescricaoRamoCS
			   ,CdProduto CodigoProduto
		from seguros_temp
		where CdProduto <> 6118
		AND ISNULL(NmSistema,'') <> 'SIAPX'
	)
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select DISTINCT t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(s.CdIndicador,-1) CdIndicador,ISNULL(pp.CdProduto,-1) CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			ISNULL(CAST(CAST(s.NumeroApolice as Bigint) as varchar(20)),'') NuApolice, ISNULL(CAST(CAST(s.NumeroApoliceCertificado as Bigint) as varchar(20)),'') NuCertificado
			,ISNULL(CAST(CAST(s.NumeroProposta as Bigint) as varchar(20)),'') NuProposta,
			case WHEN g.Descricao in ('Financiamento Auto','Financiamento Habitacional','Capital de Giro') AND ISNULL(NumeroProposta,'') <> ''
					THEN t.VlCredito
				WHEN s.NmSistema = 'SIAPX' THEN t.VlCredito
				ELSE 
					0
			END VlImportanciaSegurada
			,ISNULL(s.vlPremioTotal,0) VlPremio, ISNULL(FlNova,'') FlNova,ISNULL(FlRenovacaoResidencial,'') FlRenovacaoResidencial,ISNULL(FlIndRenovacaoAutomaticaResidencial,'') FlIndRenovacaoAutomaticaResidencial
			,ISNULL(FlRenovada,'') FlRenovada, CASE WHEN s.NumeroProposta IS NULL THEN 0 ELSE 1 END FlOfertaQualificada,
			ISNULL(s.DataProposta,'1900-01-01') DtProposta, ISNULL(CAST(YEAR(DataProposta) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataProposta) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesProposta,
			ISNULL(s.DataEmissao,'1900-01-01') DtEmissao, ISNULL(CAST(Year(DataEmissao) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(DataEmissao) as VARCHAR(2)),2) + '-' + '01','1900-01-01') DtMesEmissao,
			ISNULL(NmSistema,'') DsSistema, ISNULL(s.DescricaoSituacaoProposta,'') DsStatus, ISNULL(s.CdIndicador,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, t.VlCredito VlTransacao, ISNULL(VlPremioLiquido,0) VlPremioLiquido
		from Transacao.DimTransacao t
		INNER JOIN Transacao.DmTipoTransacao td
		on td.id=t.IdTipoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = td.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT join CteProposta s
		on (t.CdCliente = s.CodigoCliente AND CdCliente <> -1 AND CodigoCliente <> -1)
		AND ISNULL(s.NmSistema,'') <> 'SIAPX'
		AND DATEDIFF(day,dt.DtDia,DataProposta) between tt.JanelaInicio and tt.JanelaFim
		AND s.codigoproduto not in (7707,7711,7713,7715)
		----construcard 7705/7716/7706/7707
		----Capital giro 7725
		----rural 7705/7725
		LEFT JOIN Dados.DimProduto pp
		on pp.cdproduto=s.codigoProduto
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = cast(s.cdindicador as varchar(6))
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where g.id =7
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	AND ISNULL(T.NuProposta,'') = ISNULL(C.NuProposta,'')
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;

	--COMMIT;
	delete
	from transacao.dimredecaixa
	where ID  in (
		select dr.id
		from Transacao.Consignado c
		inner join Transacao.DimRedeCaixa dr
		on dr.NuContratoTransacao=c.NumeroContrato
		where IsFinanciado=1
		and dr.NuProposta=''
	);
	
	--CONSTRUCARD ENTRA SOMENTE PRESTAMISTA CODIGOS 7705,7716,7706,7707
	--delete
	--from Transacao.DimRedeCaixa
	--where id in (
	--	select r.id
	--	from Transacao.DimRedeCaixa r
	--	inner join transacao.DmTipoTransacao t
	--	on t.id=r.idtipotransacao
	--	inner join Transacao.TipoTransacao tt
	--	on tt.id=t.idtipoTransacao
	--	where tt.IDGrupoTransacao=1
	--	and cdproduto between 7701 and 7790
	--	and cdproduto not in (7705,7716,7706,7707)
	--)

	--CAPITAL DE GIRO SOMENTE 7725
	--delete
	--from Transacao.DimRedeCaixa
	--where id in (
	--	select r.id
	--	from Transacao.DimRedeCaixa r
	--	inner join transacao.DmTipoTransacao t
	--	on t.id=r.idtipotransacao
	--	inner join Transacao.TipoTransacao tt
	--	on tt.id=t.idtipoTransacao
	--	where tt.IDGrupoTransacao=7
	--	and cdproduto between 7701 and 7790
	--	and cdproduto not in (7725)
	--)

	--CONTA CORRENTE NAO ENTRA PRESTAMISTA
	--delete
	--from Transacao.DimRedeCaixa
	--where id in (
	--select r.ID
	--from Transacao.DimRedeCaixa r
	--inner join transacao.DmTipoTransacao t
	--on t.id=r.idtipotransacao
	--inner join Transacao.DimProduto p
	--on p.cdproduto=r.cdproduto
	--where DsTransacaoGrupo like '%Conta Corrente%'
	--and r.cdproduto between 7704 and 8000
	----group by t.DsTransacaoGrupo,p.CdPRoduto,Dsproduto
	--);

	--CREDITO RURAL SOMENTE 7705 e 7725
	--delete
	--from Transacao.DimRedeCaixa
	--where id in (
	--	select r.id
	--	from Transacao.DimRedeCaixa r
	--	inner join transacao.DmTipoTransacao t
	--	on t.id=r.idtipotransacao
	--	inner join Transacao.TipoTransacao tt
	--	on tt.id=t.idtipoTransacao
	--	where tt.IDGrupoTransacao=4
	--	and cdproduto between 7701 and 7790
	--	and cdproduto not in (7725,7705)
	--	AND DsSistema='SIAPX'
	--);

	--BEGIN TRANSACTION;
	MERGE INTO Transacao.DimRedeCaixa as C USING
	(
		select distinct t.IDTipoTransacao, t.IDUnidade,t.IDCanal,t.IDTempo,t.IDFaixa, t.IDCCA, t.IDConvenente, t.IDTipoContratacaoTransacao, 
			isnull(REPLACE(c.Matricula,'c',''),-1) CdIndicador,7705 CdProduto,t.CdCliente, t.NuContratoTransacao, t.DtMesTransacao, 
			t.DtDiaTransacao,  t.FlRepactuacaoRenda, 
			'117700000023'-- SIAPX
			  NuApolice, '' NuCertificado
			,ISNULL(CAST(CAST(t.NuContratoTransacao as Bigint) as varchar(20)),'') NuProposta,
			t.VlCredito VlImportanciaSegurada
			,ISNULL(c.ValorSeguro,0) VlPremio, 'S' FlNova,'N' FlRenovacaoResidencial,'N' FlIndRenovacaoAutomaticaResidencial
			,'N' FlRenovada, 1 FlOfertaQualificada,
			DtDiaTransacao DtProposta, DtMesTransacao DtMesProposta,
			DtDiaTransacao DtEmissao, DtMesTransacao DtMesEmissao,
			'SIAPX' DsSistema, 'Emitida pela empresa' DsStatus, ISNULL(f.Matricula,'') Cdmatricula, ISNULL(f.Nome,'') DsnomeIndicador, ISNULL(t.VlCredito,0) VlTransacao, 
			ISNULL(c.ValorSeguro,0) VlPremioLiquido
		from Transacao.DimTransacao t
		inner join Transacao.Consignado c
		on c.NumeroContrato=t.NucontratoTransacao
		INNER join Transacao.TipoTransacao tt
		on tt.id = t.IDTipoTransacao
		inner join transacao.GrupoTipoTransacao g
		on g.id = tt.idgrupotransacao
		inner join Transacao.DmTempo dt
		on dt.ID=t.IDTempo
		LEFT JOIN Dados.Funcionario f
		on f.Matricula = c.Matricula
		and f.id= (select max(id) from dados.funcionario where matricula=f.matricula) 
		where IsFinanciado=1
	)
	AS T
	ON C.CdCliente = t.CdCliente
	AND C.NuContratoTransacao = t.NuContratoTransacao
	AND T.IDTipoTransacao=C.IDTipoTransacao
	WHEN NOT MATCHED THEN INSERT(IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
			VALUES (IDTipoTransacao, IDUnidade,IDCanal,IDTempo,IDFaixa, IDCCA, IDConvenente, IDTipoContratacaoTransacao, 
			CdIndicador,CdProduto,CdCliente,NuContratoTransacao,DtMesTransacao,DtDiaTransacao,  FlRepactuacaoRenda,NuApolice, NuCertificado, NuProposta,
			VlImportanciaSegurada,VlPremio,FlNova,FlRenovacaoResidencial,FlIndRenovacaoAutomaticaResidencial,FlRenovada, FlOfertaQualificada,DtProposta,DtMesProposta,
			DtEmissao,DtMesEmissao,DsSistema,DsStatus,Cdmatricula,DsnomeIndicador,VlTransacao,VlPremioLiquido)
	;

	--COMMIT;
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )  
	--ROLLBACK;
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereTransacaoProposta