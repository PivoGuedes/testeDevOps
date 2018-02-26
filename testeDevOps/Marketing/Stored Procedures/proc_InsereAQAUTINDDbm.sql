CREATE PROCEDURE Marketing.proc_InsereAQAUTINDDbm
AS
DECLARE @PontoParada Date

--select convert(date,'2017-07-19',20)

select @PontoParada=CONVERT(Date,PontoParada,20) from controledados.pontoParada where NomeEntidade='IndenizacaoIntegralAQAUTIND'

insert into DBM.DBM_MKT.dbo.BA_Indenizacao_Integral
select DISTINCT s.NumeroSinistro,c.NumeroContrato,pa.ValorPagamento,pa.DescricaoEfeito,pa.SeguroTerceiro, cc.NomeCliente
	   ,cast(replace(replace(replace(cc.CPFCNPJ,'-',''),'.',''),'/','') as bigint),pa.NomeContato
	   ,cast(replace(replace(replace(pa.CPFCNPJContato,'-',''),'.',''),'/','') as bigint)
	   ,cc.Endereco, cc.Bairro,cc.Cidade,cc.DDD + cc.Telefone, pa.TelefoneComercial, pa.TelefoneCelular
	   ,pa.Email,pa.MarcaTipo,pa.Placa, sc.Descricao,pa.CategoriaPagamento,s.DataAviso,pa.DataPagamento,s.DataSinistro
from Corporativo.Marketing.PagamentosIndenizacaoIntegralCaixa pa
inner join Corporativo.Dados.Contrato c
on c.Id=pa.IdContrato
inner join Corporativo.Dados.Sinistro s
on s.ID=pa.IDSinistro
and s.IdContrato=c.Id
inner join Corporativo.Dados.ContratoCliente cc
on cc.IdContrato=c.Id
inner join Corporativo.Dados.SinistroCausa sc
on sc.ID=s.IDSinistroCausa
where pa.DataArquivo > @PontoParada
--Select top 10 * from DBM.DBM_MKT.dbo.BA_Indenizacao_Integral order by Data_inclusao desc


--Select * from DBM_MKT.dbo.BA_Indenizacao_Integral WHERE TEL_RES IS NULL AND TEL_COM IS NULL AND TEL_CEL IS NULL

-------------------------------------------------------------------------- GERAÇÃO ----------------------------------------------------------------------------
 
 
DECLARE @COD_CAMPANHA VARCHAR(16)='AQAUTIND20160601';
DECLARE @NOME_CAMPANHA VARCHAR(100)='AQUISIÇÃO AUTO - INDENIZAÇÃO INTEGRAL';
DECLARE @PRODUTO VARCHAR(10) ='AUTO';
DECLARE @OBJETIVO VARCHAR(20)= 'AQUISIÇÃO';


--DROP TABLE #TEMP0
SELECT 
@COD_CAMPANHA AS COD_CAMPANHA	,@NOME_CAMPANHA AS NOME_CAMPANHA	, 
CASE WHEN MONTH(GETDATE()) <10 AND DAY(GETDATE())<10 THEN 
@COD_CAMPANHA + '_' + LTRIM(RTRIM(CONVERT (VARCHAR (MAX),YEAR(GETDATE())) + '0' + CONVERT (VARCHAR (MAX), MONTH(GETDATE())) + '0' + CONVERT (VARCHAR (MAX), DAY(GETDATE()))))
WHEN MONTH(GETDATE()) >=10 AND DAY(GETDATE())<10 THEN 
@COD_CAMPANHA + '_' + LTRIM(RTRIM(CONVERT (VARCHAR (MAX),YEAR(GETDATE())) + CONVERT (VARCHAR (MAX), MONTH(GETDATE())) + '0' + CONVERT (VARCHAR (MAX), DAY(GETDATE()))))
WHEN MONTH(GETDATE()) <10 AND DAY(GETDATE())>=10 THEN 
@COD_CAMPANHA + '_' + LTRIM(RTRIM(CONVERT (VARCHAR (MAX),YEAR(GETDATE())) + '0' + CONVERT (VARCHAR (MAX), MONTH(GETDATE())) + CONVERT (VARCHAR (MAX), DAY(GETDATE()))))
ELSE @COD_CAMPANHA + '_' + LTRIM(RTRIM(CONVERT (VARCHAR (MAX),YEAR(GETDATE())) + CONVERT (VARCHAR (MAX), MONTH(GETDATE())) +  CONVERT (VARCHAR (MAX), DAY(GETDATE()))))
END as COD_MAILING,
@PRODUTO AS PRODUTO	, @OBJETIVO AS OBJETIVO	, M0.CPF	 ,[Segurado]  AS NOME	,

--CASE WHEN ([DDD do telefone residência] +[Número do telefone residência] ) = '0' THEN ''
--ELSE ([DDD do telefone residência] +[Número do telefone residência] ) END AS DDD_TELEFONE_1	,
(TEL_RES ) AS DDD_TELEFONE_1,

CASE WHEN (TEL_RES) IS NULL THEN ''
ELSE 'RESIDENCIAL' END AS TIPO_TELEFONE_1	,

--CASE WHEN ([DDD do telefone comercial]+CAST([Número de telefone comercial] AS FLOAT))  = '0' THEN ''  
--ELSE (CAST((CAST([DDD do telefone comercial] AS BIGINT)+CAST([Número de telefone comercial] AS BIGINT)) AS VARCHAR))  END AS DDD_TELEFONE_2	, 
(TEL_COM ) AS DDD_TELEFONE_2,

CASE WHEN (TEL_COM) IS NULL THEN ''
ELSE 'COMERCIAL' END AS TIPO_TELEFONE_2	,

TEL_CEL  DDD_TELEFONE_3	,
CASE WHEN (TEL_CEL) IS NULL THEN ''
ELSE 'CELULAR' END AS TIPO_TELEFONE_3	, M0.Email EMAIL	, replace(convert(NVARCHAR, DTNASCIMENTO , 103), ' ', '/')  DATA_DE_NASCIMENTO	, 

'SEGURO TRANQUILO AUTO' PRODUTO_OFERTA	, 
			 '' POSSE_PRODUTO_CS	,

CdProduto TIPO_CLIENTE	,CDUNIDADE AS AGENCIA_VINCULO	,CDUNIDADE AS AGENCIA_INDICACAO	, CDINDICADOR INDICADOR	,'-1' AS ASVEN_INDICADOR	,
'NÃO INFORMADA' AS REGIONAL_PAR	,''  SUPERINTENDENCIA_REGIONAL	, replace(convert(NVARCHAR, DATA_SINISTRO , 103), ' ', '/')    TERMINO_VIGENCIA_ATUAL	, 
 
'APOLICE = ' + cast(cast(NuApolice as numeric)as varchar(max)) CAMPO_X1	,
'MARCA = ' + [Marca Tipo] AS CAMPO_X2	,
'PLACA = ' + Placa AS CAMPO_X3	,
'CAUSA = ' + Causa  AS CAMPO_X4	,
'DATA_SINISTRO = ' + CAST(replace(convert(NVARCHAR, DATA_SINISTRO , 103), ' ', '/') AS VARCHAR(MAX))  AS CAMPO_X5	,
'DATA_INCLUSAO = ' + CAST(replace(convert(NVARCHAR, DATA_INCLUSAO , 103), ' ', '/') AS VARCHAR(MAX))  AS CAMPO_X6	,
'DATA_PGTO = ' + CAST(replace(convert(NVARCHAR, DATA_PGTO , 103), ' ', '/') AS VARCHAR(MAX))   as  CAMPO_X7,
'' CAMPO_X8	,'' CAMPO_X9	,'' CAMPO_X10	, '' CAMPO_X11	, '' CAMPO_X12	, '' CAMPO_X13	, '' CAMPO_X14	, '' CAMPO_X15	, '' CAMPO_X16	, '' CAMPO_X17	, '' CAMPO_X18	, '' CAMPO_X19	, '' CAMPO_X20	,
'' CAMPO_X21	, '' CAMPO_X22	, '' CAMPO_X23	, '' CAMPO_X24	, '' CAMPO_X25	, '' CAMPO_X26	, '' CAMPO_X27	, '' CAMPO_X28	, '' CAMPO_X29	, '' CAMPO_X30	, '' CAMPO_X31	, '' CAMPO_X32	,
'' CAMPO_X33	, '' CAMPO_X34	, '' CAMPO_X35	, '' CAMPO_X36	, '' CAMPO_X37	, '' CAMPO_X38	, '' CAMPO_X39	, '' CAMPO_X40	, '' CAMPO_X41	, '' CAMPO_X42,
GETDATE() AS DATA_MAILING

INTO #TEMP0

FROM 
(SELECT * FROM DBM.dbm_mkt.dbo.BA_Indenizacao_Integral
where CPF is not null and DATA_INCLUSAO between @PontoParada and getdate() ------------------------- ALTERAR DATAS!
--WHERE CONCAT(FORMAT(datepart(year,[Data do contrato - Ajustada]),'0000') ,'-', FORMAT(datepart(month,[Data do contrato - Ajustada]),'00')) = @MES
) M0
--LEFT JOIN DW_MKT.DADOS.DIMCLIENTE C
--ON M0.CPF  = CDCLIENTE
LEFT JOIN DBM.DW_MKT.DADOS.FCTAPOLICE P
ON NuApolice ='1103100' +Apolice  AND DtVersaoFim ='20500101'
 LEFT JOIN DBM.DW_MKT.DADOS.DIMUNIDADEDINAMICA G
ON P.CDUNIDADE=G.PVCODIGO
 LEFT JOIN DBM.[DBM_MKT].[dbo].[BLACKLIST_MAILINGS] BL
ON cast(M0.CPF as bigint) = BL.CPF
Where BL.CPF is null



/*
Select CPF, count(*) 
from #TEMP0
group by CPF
order by count(*) desc
*/
 --INSERT INTO  [FABRICA_CAMP].[dbo].PSAUTIND20160601

  insert into DBM.[FABRICA_CAMP].CAMP.AQAUTIND
 select distinct 
  COD_CAMPANHA,NOME_CAMPANHA,COD_MAILING,PRODUTO,OBJETIVO,CPF,NOME,
  case when DDD_TELEFONE_1 IS NULL THEN CAST(CAST(TELEFONE AS NUMERIC) AS VARCHAR(MAX)) ELSE DDD_TELEFONE_1 END DDD_TELEFONE_1,
 case when TIPO_TELEFONE_1='' AND TELEFONE IS NOT NULL THEN 'RESIDENCIAL' ELSE TIPO_TELEFONE_1 END TIPO_TELEFONE_1,
   case when DDD_TELEFONE_2 IS NULL THEN CAST(CAST(TELEFONE_COMERCIAL AS NUMERIC) AS VARCHAR(MAX)) ELSE REPLACE(DDD_TELEFONE_2,'Ramal:0220','') END DDD_TELEFONE_2,
 case when TIPO_TELEFONE_2='' AND TELEFONE_COMERCIAL IS NOT NULL THEN 'COMERCIAL' ELSE TIPO_TELEFONE_2 END TIPO_TELEFONE_2,
    case when DDD_TELEFONE_3 IS NULL THEN CAST(CAST(TELEFONE_CELULAR AS NUMERIC) AS VARCHAR(MAX)) ELSE REPLACE(DDD_TELEFONE_3,'Ramal:0220','') END DDD_TELEFONE_3,
 case when TIPO_TELEFONE_3='' AND TELEFONE_CELULAR IS NOT NULL THEN 'CELULAR' ELSE TIPO_TELEFONE_3 END TIPO_TELEFONE_3 ,
  
   EMAIL,
 DATA_DE_NASCIMENTO,PRODUTO_OFERTA,POSSE_PRODUTO_CS,TIPO_CLIENTE,AGENCIA_VINCULO,AGENCIA_INDICACAO,INDICADOR,ASVEN_INDICADOR,REGIONAL_PAR,SUPERINTENDENCIA_REGIONAL,
 TERMINO_VIGENCIA_ATUAL,CAMPO_X1,CAMPO_X2,CAMPO_X3,CAMPO_X4,CAMPO_X5,CAMPO_X6,CAMPO_X7,CAMPO_X8,CAMPO_X9,CAMPO_X10,CAMPO_X11,CAMPO_X12,CAMPO_X13,CAMPO_X14,CAMPO_X15,
 CAMPO_X16,CAMPO_X17,CAMPO_X18,CAMPO_X19,CAMPO_X20,CAMPO_X21,CAMPO_X22,CAMPO_X23,CAMPO_X24,CAMPO_X25,CAMPO_X26,CAMPO_X27,CAMPO_X28,CAMPO_X29,CAMPO_X30,CAMPO_X31,CAMPO_X32,
 CAMPO_X33,CAMPO_X34,CAMPO_X35,CAMPO_X36,CAMPO_X37,CAMPO_X38,CAMPO_X39,CAMPO_X40,CAMPO_X41,CAMPO_X42,DATA_MAILING
 


 from(
select a.*,CASE WHEN REPLACE(s.DDD+TELEFONE,' ','') ='' THEN NULL ELSE REPLACE(s.DDD+TELEFONE,' ','') END TELEFONE ,CASE WHEN TELEFONE_CELULAR ='' THEN NULL ELSE TELEFONE_CELULAR END TELEFONE_CELULAR,CASE WHEN TELEFONE_COMERCIAL='' THEN NULL ELSE REPLACE(TELEFONE_COMERCIAL,'Ramal:0220','') END TELEFONE_COMERCIAL 
,Row_number() over (PARTITION BY [CPFCNPJ], Campo_x1 ORDER BY NUMERO_DO_CALCULO DESC, DATA_ARQUIVO DESC) AS Rank
from #TEMP0 a
left join dbm.dbm_mkt.dbo.simulador_sas s
on a.cpf=s.cpfcnpj
)a where rank=1

--select convert(date,'2017-07-19',20)

update controledados.pontoParada 
set PontoParada=(Select max(DataArquivo) from Corporativo.Marketing.PagamentosIndenizacaoIntegralCaixa)
where NomeEntidade='IndenizacaoIntegralAQAUTIND'
