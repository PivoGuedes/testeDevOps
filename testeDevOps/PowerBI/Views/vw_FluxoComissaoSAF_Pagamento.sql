create view PowerBI.vw_FluxoComissaoSAF_Pagamento
as

select * from PowerBI.FluxoComissaoSAF_Pagamento
where
	Publicado = 0