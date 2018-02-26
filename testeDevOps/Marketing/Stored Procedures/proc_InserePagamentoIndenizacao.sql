CREATE PROCEDURE Marketing.proc_InserePagamentoIndenizacao  
AS  
BEGIN TRY  
 BEGIN TRAN  
 DECLARE @PontoParada as VARCHAR(400)  
 DECLARE @MaiorID as BigInt  
 DECLARE @Comando as NVarchar(max)  
  
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PagamentoIndenizacao_TEMP') AND type in (N'U'))  
  DROP TABLE dbo.PagamentoIndenizacao_TEMP;  
  
  
 CREATE TABLE PagamentoIndenizacao_TEMP  
 (  
   Codigo BIGINT  
  ,Sinistro BIGINT  
  ,Apolice BIGINT  
  ,ValorPgto DECIMAL(18,2)  
  ,DescricaoEfeito VARCHAR(200)  
  ,SegTerc VARCHAR(10)  
  ,Segurado VARCHAR(100)  
  ,CPFCNPJ VARCHAR(20)  
  ,NomeContato VARCHAR(100)  
  ,CpfCgcContato VARCHAR(20)  
  ,Endereco VARCHAR(200)  
  ,Bairro VARCHAR(50)  
  ,Municipio varchar(100)  
  ,TelefoneResidencial varchar(15)  
  ,TelefoneComercial varchar(15)  
  ,TelefoneCelular varchar(15)  
  ,Email varchar(200)  
  ,MarcaTipo varchar(200)  
  ,Placa varchar(10)  
  ,Causa varchar(500)  
  ,CategoriaPagamento varchar(100)  
  ,DataInclusao Date  
  ,DataPagto Date  
  ,DataAprovacao Date  
  ,DataSinistro Date  
  ,DataArquivo Date  
  ,NomeArquivo varchar(200)  
 )  
  
 --Definir ponto parada correto  
 select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='PagamentoIndenizacao')  
 SET @Comando = 'Insert into PagamentoIndenizacao_TEMP (  
         Codigo  
      ,Sinistro  
      ,Apolice  
      ,ValorPgto  
      ,DescricaoEfeito  
      ,SegTerc  
      ,Segurado  
      ,CPFCNPJ  
      ,NomeContato  
      ,CpfCgcContato  
      ,Endereco  
      ,Bairro  
      ,Municipio  
      ,TelefoneResidencial  
      ,TelefoneComercial  
      ,TelefoneCelular  
      ,Email  
      ,MarcaTipo  
      ,Placa  
      ,Causa  
      ,CategoriaPagamento  
      ,DataInclusao  
      ,DataPagto  
      ,DataAprovacao  
      ,DataSinistro  
      ,DataArquivo  
      ,NomeArquivo  
     )  
     SELECT  Codigo  
       ,Sinistro  
       ,Apolice  
       ,ValorPgto  
       ,DescricaoEfeito  
       ,SegTerc  
       ,Segurado  
       ,CPFCNPJ  
       ,NomeContato  
       ,CpfCgcContato  
       ,Endereco  
       ,Bairro  
       ,Municipio  
       ,TelefoneResidencial  
       ,TelefoneComercial  
       ,TelefoneCelular  
       ,Email  
       ,MarcaTipo  
       ,Placa  
       ,Causa  
       ,CatPagto  
       ,DataInclusao  
       ,DataPagto  
       ,DataAprovacao  
       ,DataSinistro  
       ,DataArquivo  
       ,NomeArquivo  
      FROM OPENQUERY ([OBERON],  
      ''EXEC FENAE.dbo.proc_Recupera_PagamentoIndenizacao ''''' + @PontoParada + ''''''') PRP'  
 EXEC(@Comando)  
  
 SELECT @MaiorID=MAx(Codigo)  
 from PagamentoIndenizacao_TEMP  
  
 SET @PontoParada = @MaiorID  
 WHILE @MaiorID IS NOT NULL  
 BEGIN  
    
  /***********************************************************************  
  
  Carregar CAUSA DE SINISTRO dos sinistros  
  
      ***********************************************************************/  
     
      ;MERGE INTO Dados.SinistroCausa AS T  
  USING (  
   SELECT DISTINCT  LEFT(ST.Causa,40) Causa  
   FROM PagamentoIndenizacao_TEMP ST  
   WHERE ST.Causa IS NOT NULL  
  ) C  
  ON T.Descricao = C.Causa  
  WHEN NOT MATCHED  
            THEN INSERT (Descricao)  
                 VALUES (C.Causa);   
  
     /***********************************************************************/  
  --Verifica existencia da apolice na tabela Dados.Contrato  
 MERGE INTO Dados.Contrato AS C USING  
 (  
  select *  
  from (  
   SELECT DISTINCT   
     CAST(Apolice as VARCHAR(20)) Apolice  
     ,ISNULL(DataArquivo, getdate()) DataArquivo  
     ,ISNULL(NomeArquivo,'') NomeArquivo  
     ,ROW_NUMBER() OVER (PARTITION BY Apolice ORDER BY DataArquivo Desc) Ordem  
   FROM PagamentoIndenizacao_TEMP  
  ) as x   
  where Ordem=1  
 ) AS T  
 ON T.Apolice=C.NumeroContrato  
 WHEN NOT MATCHED THEN INSERT (NumeroContrato,DataArquivo,Arquivo,IDSeguradora)  
  VALUES (Apolice,DataArquivo,NomeArquivo,1);  
  
  --Insere Contrato Cliente  
  MERGE INTO Dados.ContratoCliente as C USING  
  (  
   SELECT DISTINCT  
    c.ID IDContrato  
    ,Segurado  
    ,CPFCNPJ  
    ,LEFT(Endereco,40) Endereco  
    ,LEFT(Bairro,20) Bairro  
    ,LEFT(Municipio,20) Municipio  
    ,LEFT(TelefoneResidencial,2) DDD  
    ,RIGHT(TelefoneResidencial,8) Telefone  
    ,ISNULL(t.DataArquivo,getdate()) DataArquivo  
    ,NomeArquivo  
   from PagamentoIndenizacao_TEMP as t  
   INNER JOIN Dados.Contrato c  
   ON NumeroContrato=CAST(Apolice as VARCHAR(20))  
  ) as T  
  ON t.IDContrato=C.IDContrato  
  AND C.CPFCNPJ=T.CPFCNPJ  
  WHEN NOT MATCHED THEN INSERT (IDContrato,TipoPessoa,CPFCNPJ,NomeCliente,DDD,Telefone,Endereco,Bairro,Cidade,DataArquivo,Arquivo)  
   VALUES (IDCOntrato,'Pessoa Física',CPFCNPJ,Segurado,DDD,Telefone,Endereco,Bairro,Municipio,DataArquivo,NomeArquivo);  
  
    
  --insere na dados.Sinistro  
  MERGE INTO Dados.Sinistro AS C USING  
  (  
	   select *
		from (
		   Select DISTINCT  
			c.ID IDContrato  
			,s.ID IDCausa  
			,Sinistro  
			,DataInclusao  
			,DataSinistro  
			,ISNULL(t.DataArquivo,getdate()) DataArquivo  
			,ISNULL(NomeArquivo,'') NomeArquivo  
			,ROW_NUMBER() OVER (PARTITION BY Sinistro Order by DataSinistro) Ordem
		   FROM PagamentoIndenizacao_TEMP t  
		   INNER JOIN Dados.Contrato c  
		   ON NumeroContrato=CAST(Apolice as varchar(20))  
		   and id = (select MAX(ID) from dados.contrato where numerocontrato=c.numerocontrato)  
		   INNER JOIN Dados.SinistroCausa s  
		   on s.Descricao = t.Causa
	   ) as x
	   where Ordem=1
  ) as T  
  on T.Sinistro=C.NumeroSinistro  
  WHEN NOT MATCHED THEN INSERT (NumeroSinistro,IDContrato,IDSinistroCausa,DataAviso,DataSinistro,DataArquivo,Arquivo)  
   values (Sinistro,IDContrato,IDCausa,DataInclusao,DataSinistro,DataArquivo,NomeArquivo);  
  
  --Cadastra os dados na Tabela Marketing.PagamentosIndenizacaoIntegralCaixa  
  MERGE INTO Marketing.PagamentosIndenizacaoIntegralCaixa AS C USING  
  (  
   select  DISTINCT   
     c.ID IDContrato  
     ,cc.CodigoCliente  
     ,s.ID IdSinistro  
     ,ValorPgto  
     ,DescricaoEfeito  
     ,SegTerc  
     ,NomeContato  
     ,CpfCgcContato  
     ,TelefoneComercial  
     ,TelefoneCelular  
     ,Email  
     ,MarcaTipo  
     ,Placa  
     ,CategoriaPagamento  
     ,DataPagto  
     ,DataAprovacao  
     ,t.DataArquivo  
     ,t.DataInclusao  
   from PagamentoIndenizacao_TEMP t  
   inner join dados.contrato c  
   on c.NumeroContrato=t.Apolice  
   inner join Dados.ContratoCliente cc  
   on cc.IdContrato=c.Id  
   and cc.CPFCNPJ=t.CPFCNPJ  
   inner join Dados.Sinistro s  
   on s.NumeroSinistro=t.sinistro  
  )  
  AS T  
  ON C.IdSinistro = T.IdSinistro  
  AND C.IDContrato = T.IDContrato  
  AND C.ValorPagamento=T.ValorPgto  
  AND C.DataPagamento=T.DataPagto  
  AND C.Datainclusao=T.DataInclusao  
  WHEN NOT MATCHED THEN INSERT(IDContrato,IDSinistro,CodigoCliente,ValorPagamento,DescricaoEfeito,SeguroTerceiro,NomeContato,CPFCNPJCOntato,TelefoneComercial,TelefoneCelular  
    ,Email,MarcaTipo,Placa,CategoriaPagamento,DataPagamento,Dataaprovacao,DataArquivo,DataInclusao)  
   VALUES (IDContrato,IdSinistro,CodigoCliente,ValorPgto,DescricaoEfeito,SegTerc,NomeContato,CpfCgcContato,TelefoneComercial,TelefoneCelular,Email  
     ,MarcaTipo,Placa,CategoriaPagamento,DataPagto,DataAprovacao,DataArquivo,T.DataInclusao)  
  ;  
    
  
  truncate table PagamentoIndenizacao_TEMP  
  SET @Comando = 'Insert into PagamentoIndenizacao_TEMP (  
         Codigo  
      ,Sinistro  
      ,Apolice  
      ,ValorPgto  
      ,DescricaoEfeito  
      ,SegTerc  
      ,Segurado  
      ,CPFCNPJ  
      ,NomeContato  
      ,CpfCgcContato  
      ,Endereco  
      ,Bairro  
      ,Municipio  
      ,TelefoneResidencial  
      ,TelefoneComercial  
      ,TelefoneCelular  
      ,Email  
      ,MarcaTipo  
      ,Placa  
      ,Causa  
      ,CategoriaPagamento  
      ,DataInclusao  
      ,DataPagto  
      ,DataAprovacao  
      ,DataSinistro  
      ,DataArquivo  
      ,NomeArquivo  
     )  
     SELECT  Codigo  
       ,Sinistro  
       ,Apolice  
       ,ValorPgto  
       ,DescricaoEfeito  
       ,SegTerc  
       ,Segurado  
       ,CPFCNPJ  
       ,NomeContato  
       ,CpfCgcContato  
       ,Endereco  
       ,Bairro  
       ,Municipio  
       ,TelefoneResidencial  
       ,TelefoneComercial  
       ,TelefoneCelular  
       ,Email  
       ,MarcaTipo  
       ,Placa  
       ,Causa  
       ,CatPagto  
       ,DataInclusao  
       ,DataPagto  
       ,DataAprovacao  
       ,DataSinistro  
       ,DataArquivo  
       ,NomeArquivo  
      FROM OPENQUERY ([OBERON],  
      ''EXEC FENAE.dbo.proc_Recupera_PagamentoIndenizacao ''''' + @PontoParada + ''''''') PRP'  
  EXEC(@Comando)  
  
  SELECT @MaiorID=MAx(Codigo)  
  from PagamentoIndenizacao_TEMP  
  
  IF(@MaiorID IS NOT NULL)  
   SET @PontoParada = @MaiorID  
  
 END  
  
 if(@PontoParada IS NOT NULL)  
  --Atualiza o ponto de parada  
  update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='PagamentoIndenizacao'  
   
 --DROP Data tabela temporária  
 DROP TABLE PagamentoIndenizacao_TEMP  
 Commit  
END TRY                  
BEGIN CATCH  
 ROLLBACK  
  DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  

    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  

    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
END CATCH  
  
--exec Marketing.proc_InserePagamentoIndenizacao  
  
--select * from ControleDados.PontoParada where nomeentidade='PagamentoIndenizacao'  
  
--insert into ControleDados.PontoParada values ('PagamentoIndenizacao',0)  
  