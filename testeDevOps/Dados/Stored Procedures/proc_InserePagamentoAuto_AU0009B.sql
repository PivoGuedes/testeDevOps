---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------











/*



	Autor: Pedro Guedes



	Data Criação: 25/10/2015







	Descrição: 







*/







/*******************************************************************************



	Nome: CORPORATIVO.Dados.proc_InserePagamentoAuto



	Descrição: 



		



	Parâmetros de entrada:



	



			rollback		



	Retorno: 



	











OBS: Rodar os comandos abaixo para que a proc possa funcionar



	



*******************************************************************************/







CREATE PROCEDURE [Dados].[proc_InserePagamentoAuto_AU0009B] 

WITH RECOMPILE

AS



BEGIN TRY		



 



DECLARE @PontoDeParada AS VARCHAR(400)



DECLARE @MaiorCodigo AS BIGINT







DECLARE @ParmDefinition NVARCHAR(500)



DECLARE @COMANDO AS NVARCHAR(max)







 



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PagamentoAuto_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)



	DROP TABLE [dbo].PagamentoAuto_TEMP;







CREATE TABLE [dbo].PagamentoAuto_TEMP(



	ID INT NOT NULL,



	NumeroProposta varchar(20) NOT NULL,



	NumeroApolice varchar(20) NOT NULL,



	PropostaSIVPF varchar(17) NOT NULL,



	EndossoContrato int,



	EndossoPagamento int,



	Parcela INT NOT NULL,



	Operacao VARCHAR(4) NOT NULL,



	DescricaoOperacao VARCHAR(60) NOT NULL,



	Produto VARCHAR(5) NOT NULL,



	Titulo VARCHAR(14) NOT NULL,



	CodigoSituacao VARCHAR(3) NOT NULL,



	DescricaoSituacao VARCHAR(60) NOT NULL,



	DataVencimento DATE NOT NULL,



	DataQuitacao DATE NULL,



	ValorBruto DECIMAL(24,4) NOT NULL,



	ValorLiquido DECIMAL(24,4) NOT NULL,



	ValorIOF DECIMAL(24,4) NOT NULL,



	ValorTotal DECIMAL(24,4) NOT NULL,



	QuantidadeOcorrencias INT NOT NULL,



	DataArquivo DATE NOT NULL,



	NomeArquivo VARCHAR(150) NOT NULL,



	ValorTotalEndosso DECIMAL(24,4) NOT NULL,



	ValorLiquidoEndosso DECIMAL(24,4) NOT NULL,



	ValorIOFEndosso DECIMAL(24,4) NOT NULL,



	QuantidadeParcelas INT NOT NULL,



	CodigoSituacaoInt as cast(CodigoSituacao  as tinyint)  persisted



	



	



	--Codigo bigint NOT NULL



	--,NumeroApolice	varchar(20)



	--,NumeroEndosso	int



	--,NumeroParcela	smallint



	--,NumeroTitulo	varchar(20)



	--,ValorPremioLiquido	numeric(19,2)



	--,DataVencimento	date



	--,QuantidadeOcorrencias	smallint



	--,Situacao	smallint



	--,DataArquivo	date



	--,NomeArquivo	nvarchar(200)



) 







CREATE NONCLUSTERED INDEX [ncl_idx_Produto_PagamentoTemp]



ON [dbo].[PagamentoAuto_TEMP] ([Produto])



INCLUDE ([Operacao],[DescricaoOperacao])







SELECT @PontoDeParada = PontoParada



from ControleDados.PontoParada



WHERE NomeEntidade = 'PagamentoAuto'











/*********************************************************************************************************************/               



/*Recupeara maior Código do retorno*/



/*********************************************************************************************************************/



--DECLARE @PontoDeParada AS VARCHAR(400)= '81441947'



--DECLARE @COMANDO AS NVARCHAR(max)



SET @COMANDO = 'INSERT INTO [dbo].[PagamentoAuto_TEMP] ( 



							ID,



							NumeroProposta,



							--TipoRegistro,



							NumeroApolice,



							PropostaSIVPF,



							EndossoContrato,



							EndossoPagamento,



							Parcela,



							Operacao,



							DescricaoOperacao,



							Produto,



							Titulo,



							CodigoSituacao,



							DescricaoSituacao,



							DataVencimento,



							DataQuitacao,



							ValorBruto,



							ValorLiquido,



							ValorIOF,



							ValorTotal,



							QuantidadeOcorrencias,



							DataArquivo,



							NomeArquivo,



							ValorTotalEndosso,



							ValorLiquidoEndosso,



							ValorIOFEndosso,



							QuantidadeParcelas



					   )



                SELECT ID,



					NumeroProposta,       



					--TipoRegistro,



					NumeroApolice,



					PropostaSIVPF,



					EndossoContrato,



					EndossoPagamento,



					Parcela,



					Operacao,



					DescricaoOperacao, 



					Produto, 



					Titulo,         



					CodigoSituacao, 



					DescricaoSituacao,              



					DataVencimento, 



					DataQuitacao, 



					ValorBruto,                              



					ValorLiquido,                            



					ValorIOF,                                



					ValorTotal,                              



					QuantidadeOcorrencias, 



					DataArquivo, 



					NomeArquivo,



					ValorTotalEndosso,



					ValorLiquidoEndosso,



					ValorIOFEndosso,



					QuantidadeParcelas



                FROM OPENQUERY ([OBERON], 



                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_Auto]  ''''' + @PontoDeParada + ''''''') PRP'







EXEC (@COMANDO)     



                



SELECT @MaiorCodigo= MAX(ID)



FROM [dbo].[PagamentoAuto_TEMP]







--SELECT *



--FROM [dbo].[PagamentoAuto_TEMP]



--select @@TRANCOUNT



--begin tran



/*********************************************************************************************************************/







WHILE @MaiorCodigo IS NOT NULL



BEGIN 











/***********************************************************************



     Carregar as Operacoes das Parcelas rollback



	 select top 1100 * from Dados.Parcela order by ID DESC 



	 select top 1 * from [dbo].PagamentoAuto_TEMP temp



***********************************************************************/



MERGE INTO Dados.ParcelaOperacao as T USING



(







	SELECT DISTINCT Operacao as Codigo,DescricaoOperacao as Descricao,pd.IDRamoPAR as IDRamo



	FROM [dbo].PagamentoAuto_TEMP temp



	INNER JOIN Dados.Produto pd on pd.CodigoComercializado = temp.Produto



)



AS S



ON S.Codigo = T.Codigo



AND S.IDRamo = T.IDRamo



WHEN NOT MATCHED THEN INSERT(Codigo,Descricao,IDRamo)



VALUES



(Codigo,Descricao,IDRamo);















  /*********************************************************************** 



     Carregar os contratos 



   ***********************************************************************/



   --begin tran



    MERGE INTO Dados.Contrato AS T



		USING (	select * from (select  



					NumeroApolice as NumeroContrato



					,temp.DataArquivo



					,temp.NomeArquivo



					,temp.ValorLiquido as ValorPremioLiquido



					,temp.ValorTotal 



					,c.ID  



					



					,ROW_NUMBER() OVER (partition by temp.NumeroApolice ORDER BY temp.DataArquivo DESC) AS numlinha



			from [dbo].PagamentoAuto_TEMP temp



				left join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice) a where numlinha = 1 



			



			) AS X







	ON  X.ID = T.ID











	WHEN NOT MATCHED



			THEN INSERT (NumeroContrato, DataArquivo, Arquivo, ValorPremioLiquido, ValorPremioTotal,IDSeguradora)



	  values (X.NumeroContrato,X.DataArquivo, X.NomeArquivo, X.ValorPremioLiquido, X.ValorTotal,1);



	



	  



  



  



  



   /*********************************************************************** 



     Carregar as propostas  rollback select @@trancount - 084842430060003



	 select top 20 * from Dados.Proposta order by ID DESC



   ***********************************************************************/







    MERGE INTO Dados.Proposta AS T



		USING (	select * from (select  



					temp.NumeroProposta



					,c.ID as IDContrato



					,p.ID as IDProposta



					,temp.PropostaSIVPF



					,temp.ValorLiquido ValorPremioLiquido



					,temp.ValorTotal ValorPremioTotal



					,temp.DataArquivo



					,temp.NomeArquivo



					,pd.ID as IDProduto



					,ROW_NUMBER() OVER (partition by temp.NumeroApolice,temp.NumeroProposta ORDER BY temp.DataArquivo DESC) AS numlinha



			from [dbo].PagamentoAuto_TEMP temp



				inner join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice



				inner join Dados.Produto pd



				on pd.CodigoComercializado = temp.Produto



				left join dados.proposta as p



				on p.numeroproposta =temp.numeroproposta) a where numlinha = 1 --and IDProposta is null 



			



			) AS X

		



	ON  X.IDProposta = T.ID





	WHEN NOT MATCHED



			THEN INSERT (NumeroProposta, IDContrato, DataArquivo, TipoDado, Valor, ValorPremioTotal,IDProduto)



	  values (X.NumeroProposta,X.IDContrato, X.DataArquivo, X.NomeArquivo, X.ValorPremioLiquido, X.ValorPremioTotal,X.IDProduto)



	  



	WHEN MATCHED AND T.IDProduto is NULL THEN UPDATE SET IDProduto = X.IDProduto

	;



  



  



  --select top 300 * from Dados.Proposta order by ID DESC







  



  



   /*********************************************************************** 



     Atualiza ID Proposta nos contratos 



   ***********************************************************************/







    MERGE INTO Dados.Contrato AS T



		USING (	select * from (select  



					p.ID as IDProposta



					,c.ID 



					



					,ROW_NUMBER() OVER (partition by temp.NumeroApolice ORDER BY temp.DataArquivo DESC) AS numlinha



			from [dbo].PagamentoAuto_TEMP temp



				inner join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice



				inner join dados.proposta as p



				on p.numeroproposta =temp.numeroproposta) a where numlinha = 1



			



			) AS X







	ON  X.ID = T.ID











	WHEN  MATCHED AND T.IDProposta is null



	THEN UPDATE SET T.IDProposta = X.IDProposta;







	



  



  















  --select @@TRANCOUNT







  --rollback



  



   /*********************************************************************** 



     Carregar os endossos select   * from Dados.Endosso where idcontrato = 23201853



   ***********************************************************************/







    MERGE INTO Dados.Endosso AS T



		USING (	select * from (select  



					temp.EndossoContrato as NumeroEndosso



					,c.ID as IDContrato



					,p.ID as IDProposta



					,temp.NumeroProposta



					,temp.Parcela as NumeroParcela



					,temp.Titulo as NumeroTitulo



					,temp.ValorLiquidoEndosso as ValorPremioLiquido



					,temp.ValorTotalEndosso as ValorPremioTotal



					,temp.ValorIOFEndosso as ValorIOF



					,temp.QuantidadeParcelas



					,temp.DataVencimento



					,temp.QuantidadeOcorrencias



					,temp.DataArquivo



					,temp.EndossoContrato



					,temp.NomeArquivo



					,ISNULL(C.DataEmissao,'2001-01-01') AS DataEmissao



					,ISNULL(p.IDProduto,-1) as IDProduto



					--,P.id AS IDProposta



					



					,ROW_NUMBER() OVER (partition by temp.NumeroApolice,temp.NumeroProposta,temp.EndossoContrato ORDER BY temp.DataArquivo DESC) AS numlinha



			from [dbo].PagamentoAuto_TEMP temp



				inner join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice



				inner join dados.proposta as p



				on p.numeroproposta =temp.numeroproposta



				--left join Dados.Produto pd on pd.CodigoComercializado = temp.Codigo



				--where c.ID = 3683325



				--left join dados.endosso as e select top 1 * from PagamentoAuto_TEMP select * from Dados.Endosso where IDContrato = 3683325 select * from Dados.Endosso where Arquivo like '%AU0009B%' AND DataInicioVigencia is not null



				--on e.idcontrato=c.id



				) a where numlinha = 1 --and IDcontrato = 23201853



			) AS X







	ON  X.NumeroEndosso = T.NumeroEndosso



		and X.IDContrato = T.IDContrato



		--and X.IDProposta = T.IDProposta



		--and X.NumeroParcela = T.NumeroParcela



 --and x.DataArquivo > T.DataArquivo







	WHEN NOT MATCHED



			THEN INSERT (IDProposta,IDContrato, NumeroEndosso, DataEmissao, ValorPremioLiquido, ValorPremioTotal, ValorIOF,DataArquivo,Arquivo,IDProduto,QuantidadeParcelas)



	  values (X.IDProposta,X.IDContrato, X.EndossoContrato, X.DataEmissao, X.ValorPremioLiquido, X.ValorPremioTotal, X.ValorIOF, X.DataArquivo, X.NomeArquivo,X.IDProduto,X.QuantidadeParcelas)



	WHEN MATCHED 



			THEN UPDATE SET IDProposta = COALESCE(X.IDProposta,T.IDProposta),



							IDProduto = COALESCE(X.IDProduto,T.IDProduto),



							DataEmissao = COALESCE(X.DataEmissao,T.DataEmissao),



							ValorPremioLiquido = COALESCE(X.ValorPremioLiquido,T.ValorPremioLiquido),



							ValorPremioTotal = COALESCE(X.ValorPremioTotal ,T.ValorPremioTotal),



							ValorIOF = COALESCE(X.ValorIOF,T.ValorIOF),



							DataArquivo = COALESCE(X.DataArquivo,T.DataArquivo),



							Arquivo = COALESCE(X.NomeArquivo,T.Arquivo),



							QuantidadeParcelas = COALESCE(X.QuantidadeParcelas,T.QuantidadeParcelas);



	 --select @@TRANCOUNT



	 --rollback



	 --4



	 --select top 10 * from DAdos.Endosso order by ID DESC







  



  /***********************************************************************



     Carregar as parcelas select top 1000 * from Dados.Proposta order by ID DESC



	 



   ***********************************************************************/



 declare @idparcela int



 SELECT @idparcela = ISNULL(MAX(ID),0) from Dados.Parcela where ID IS NOT NULL



    MERGE INTO Dados.Parcela AS T



		USING (	select *,row_number() over (order by IDEndosso,NumeroTitulo,NumeroParcela,QuantidadeOcorrencias)  as numlinha from (select  



						



					e.id as idendosso



					,temp.Parcela as NumeroParcela



					,right(temp.Titulo,13)  as NumeroTitulo



					,temp.ValorLiquido ValorPremioLiquido



					,temp.DataVencimento



					,temp.QuantidadeOcorrencias



					,sp.id as idsituacaoparcela



					,temp.DataArquivo



					, CASE WHEN CodigoComercializado in ('1803','1805') then 'MR0009B' ELSE 'AU0009B' END as TipoDado



					--,temp.DescricaoSituacao



					,po.ID as IDParcelaOperacao



					--,po.Descricao



					--,temp.DescricaoOperacao



					,temp.NomeArquivo



					,ISNULL(C.DataEmissao,'2001-01-01') AS DataEmissao



					,temp.NumeroProposta



					,temp.NumeroApolice



					,pd.CodigoComercializado



					,ROW_NUMBER() OVER (PARTITION BY e.ID,Titulo,Parcela,temp.QuantidadeOcorrencias ORDER BY temp.DataArquivo DESC ) AS linha



					--,pc.ID



			from [dbo].PagamentoAuto_TEMP temp



				inner join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice



				inner join dados.endosso as e



				on e.idcontrato=c.id



				INNER JOIN dados.proposta pp ON pp.ID = e.IDProposta AND pp.IDProduto = e.IDProduto



				and e.numeroendosso=temp.EndossoContrato



				inner join dados.situacaoparcela as sp



				on sp.codigo=temp.CodigoSituacaoInt



				inner join Dados.Produto pd 



				on pd.CodigoComercializado = temp.Produto



				left join dados.parcelaoperacao po



				on po.Codigo = temp.Operacao and po.IDRamo = pd.IDRamoPAR



				--left join Dados.Parcela pc on pc.IDEndosso = e.ID and pc.NumeroParcela = temp.Parcela



				--where IDEndosso =7923819



				--ORDER BY IDEndosso,NumeroParcela,IDSituacaoParcela

				

				) a where linha = 1 



				 



			) AS X







	ON  X.idendosso = T.idendosso



	and X.NumeroParcela = T.NumeroParcela



	AND x.IDParcelaOperacao = T.IDParcelaOperacao







	--and X.idsituacaoparcela = T.idsituacaoparcela



	--and X.NumeroTitulo = T.NumeroTitulo



	--and X.QuantidadeOcorrencias = T.QuantidadeOcorrencias



	--and X.IDParcelaOperacao = T.IDParcelaOperacao



	--and X.DataEmissao = T.DataEmissao



	--and X.ValorPremioLiquido = T.ValorPremioLiquido



	WHEN NOT MATCHED



			THEN INSERT (id,idendosso, NumeroParcela, NumeroTitulo, ValorPremioLiquido, DataVencimento, QuantidadeOcorrencias, idsituacaoparcela, DataArquivo, DataEmissao,IDParcelaOperacao,NomeArquivo,TipoDado)



	  values (X.numlinha+@idparcela,X.idendosso, X.NumeroParcela, X.NumeroTitulo, X.ValorPremioLiquido, X.DataVencimento, X.QuantidadeOcorrencias, X.idsituacaoparcela, X.DataArquivo, X.DataEmissao,X.IDParcelaOperacao,X.NomeArquivo,TipoDado	)



	WHEN MATCHED AND (X.DataArquivo > T.DataArquivo OR X.QuantidadeOcorrencias > T.QuantidadeOcorrencias) 



		THEN UPDATE SET DataVencimento =COALESCE(X.DataVencimento,T.DataVencimento),



								ValorPremioLiquido = COALESCE(X.ValorPremioLiquido,T.ValorPremioLiquido),



								idsituacaoparcela = COALESCE(X.IDSituacaoParcela,T.IDSituacaoParcela),



								DataArquivo = COALESCE(X.DataArquivo,T.DataArquivo),



								TipoDado = COALESCE(X.TipoDado,T.TipoDado),



								NomeArquivo = COALESCE(X.NomeArquivo,T.NomeArquivo),



								NumeroTitulo = COALESCE(X.NumeroTitulo,T.NumeroTitulo);







	



	



	



	--							IDSituacaoParcela =  COALESCE(T.IDSituacaoParcela,X.IDSituacaoParcela),



	--							DataVencimento = COALESCE ( T.DataVencimento,X.DataVencimento),



	--							QuantidadeOcorrencias = COALESCE ( T.QuantidadeOcorrencias,X.QuantidadeOcorrencias),



	--							DataArquivo = COALESCE ( T.DataArquivo,X.DataArquivo),



	--							ValorPremioLiquido = COALESCE ( T.ValorPremioLiquido,X.ValorPremioLiquido);



								















/***********************************************************************



     Carregar os pagamentos 



	 select top 400 * from Dados.Pagamento order by ID DESC



	 select top 1 * from [dbo].PagamentoAuto_TEMP temp



***********************************************************************/







    MERGE INTO Dados.Pagamento AS T



		USING (	select * from (select  



					p.id as IDProposta



					,temp.Parcela as NumeroParcela



					,temp.ValorLiquido ValorPremioLiquido



					,temp.ValorTotal



					,temp.DataVencimento



					,temp.DataQuitacao as DataEfetivacao



					,temp.ValorIOF



					,temp.Titulo as NumeroTitulo



					--,temp.QuantidadeOcorrencias



					--,sp.id as idsituacaoparcela



					--,temp.DataEmissao



					,p.IDProduto



					,e.NumeroEndosso



					,temp.DataArquivo



					,temp.NomeArquivo



					, CASE WHEN CodigoComercializado in ('1803','1805') then 'MR0009B' ELSE 'AU0009B' END as TipoDado



					,ROW_NUMBER() OVER (PARTITION BY temp.NumeroApolice,temp.NumeroProposta,temp.Parcela order by temp.DataArquivo DESC) AS numlinha



					,po.SinalLancamento



					,po.IDRamo



					,pd.CodigoComercializado



					--,po.Codigo



					--,pd.IDRamoPAR



	 from [dbo].PagamentoAuto_TEMP temp



				inner join dados.contrato as c



				on c.numerocontrato=temp.numeroapolice



				inner join dados.proposta as p



				on p.numeroproposta =temp.numeroproposta



				inner join Dados.Produto pd on p.IDProduto = pd.ID



				inner join dados.endosso as e



				on e.idcontrato=c.id



				and e.numeroendosso=temp.EndossoContrato



				inner join Dados.ParcelaOperacao po 



				on po.Codigo = temp.Operacao and ((((po.IDRamo = pd.IDRamoPAR) or (po.IDRamo = 38 and pd.IDRamoPAR = 52)) and po.IDRAmo in (38,39,37) and po.Codigo in('0231','0241','0290','0201','0232','0242','0802','0804','0801','0101','0300','0233','0404')) or (p.



IDProduto = -1))



				where DataQuitacao IS NOT NULL  ) x where numlinha = 1-- and temp.Operacao in ('0231','0241','0290') and p.



			) AS X











--			0231



--0231



--0241



--0290



--0290







	ON  X.IDProposta = T.IDProposta



	and X.NumeroParcela = T.NumeroParcela



	and X.NumeroEndosso = T.NumeroEndosso



	and X.TipoDado = T.TipoDado



	WHEN NOT MATCHED



			THEN INSERT (IDProposta, NumeroParcela, NumeroEndosso, ValorPremioLiquido, Valor, ValorIOF, NumeroTitulo, DataEfetivacao, TipoDado,DataArquivo,Arquivo,SinalLancamento)



	  values (X.IDProposta, X.NumeroParcela, X.NumeroEndosso, X.ValorPremioLiquido, X.ValorTotal, ValorIOF, NumeroTitulo, DataEfetivacao, TipoDado,DataArquivo,NomeArquivo,SinalLancamento)



	  WHEN MATCHED THEN UPDATE SET 



							T.DataEfetivacao = COALESCE(X.DataEfetivacao,T.DataEfetivacao),



							T.Arquivo = COALESCE(X.NomeArquivo,t.Arquivo),



							T.DataArquivo = COALESCE(X.DataArquivo,T.DataArquivo),



							T.ValorPremioLiquido = COALESCE(X.ValorPremioLiquido,T.ValorPremioLiquido),



							T.Valor = COALESCE(X.ValorTotal,T.Valor),



							T.ValorIOF = COALESCE(X.ValorIOF,T.ValorIOF),



							T.SinalLancamento = COALESCE(X.SinalLancamento,T.SinalLancamento);







 /*************************************************************************************/



  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/



  /*************************************************************************************/



  SET @PontoDeParada = @MaiorCodigo



  



  UPDATE ControleDados.PontoParada 



  SET PontoParada = @MaiorCodigo



  WHERE NomeEntidade = 'PagamentoAuto'







   /*************************************************************************************/



  



 /*********************************************************************************************************************/



  TRUNCATE TABLE [dbo].[PagamentoAuto_TEMP] 



    



  /*********************************************************************************************************************/               



  /*Recupeara maior Código do retorno*/



  /*********************************************************************************************************************/



SET @COMANDO = 'INSERT INTO [dbo].[PagamentoAuto_TEMP] ( 



							ID,



							NumeroProposta,



							--TipoRegistro,



							NumeroApolice,



							PropostaSIVPF,



							EndossoContrato,



							EndossoPagamento,



							Parcela,



							Operacao,



							DescricaoOperacao,



							Produto,



							Titulo,



							CodigoSituacao,



							DescricaoSituacao,



							DataVencimento,



							DataQuitacao,



							ValorBruto,



							ValorLiquido,



							ValorIOF,



							ValorTotal,



							QuantidadeOcorrencias,



							DataArquivo,



							NomeArquivo,



							ValorTotalEndosso,



							ValorLiquidoEndosso,



							ValorIOFEndosso,



							QuantidadeParcelas



					   )



                SELECT ID,



					NumeroProposta,       



					--TipoRegistro,



					NumeroApolice,



					PropostaSIVPF,



					EndossoContrato,



					EndossoPagamento,



					Parcela,



					Operacao,



					DescricaoOperacao, 



					Produto, 



					Titulo,         



					CodigoSituacao, 



					DescricaoSituacao,              



					DataVencimento, 



					DataQuitacao, 



					ValorBruto,                              



					ValorLiquido,                            



					ValorIOF,                                



					ValorTotal,                              



					QuantidadeOcorrencias, 



					DataArquivo, 



					NomeArquivo,



					ValorTotalEndosso,



					ValorLiquidoEndosso,



					ValorIOFEndosso,



					QuantidadeParcelas



                FROM OPENQUERY ([OBERON], 



                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_Auto]  ''''' + @PontoDeParada + ''''''') PRP'







EXEC (@COMANDO)      



                



	SELECT @MaiorCodigo= MAX(ID)



	FROM [dbo].[PagamentoAuto_TEMP]







END







IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PagamentoAuto_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)



	DROP TABLE [dbo].PagamentoAuto_TEMP;				



	



END TRY                



BEGIN CATCH



	



  EXEC CleansingKit.dbo.proc_RethrowError	



 -- RETURN @@ERROR	



END CATCH



































--select   * from PagamentoAuto_TEMP t



--inner join Dados.Produto p on t.Produto = p.CodigoComercializado



--where p.IDRamoPAR is not null

