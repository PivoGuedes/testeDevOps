
CREATE PROCEDURE Mailing.sp_SLA_EnvioMailing
AS

WITH CT AS (

	select count(*) QTD, Mailing, DataRefMailing,case WHEN ERROR like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END Error
	from [Stage_Salesforce].[dbo].[LogEnvioOpportunity]
	where DataRefMailing >= '2017-06-01'
	--and ERROR like '%Operation Successful%'
	group by Mailing, DataRefMailing,case WHEN ERROR like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
	UNION
	SELECT count(*) Qtd,'Renovação Residencial FABRICA_CAMP - ' + [Tipo Renovacao] COLLATE Latin1_General_CI_AS, DATA_MAILING,''
	FROM DBM.Fabrica_camp.dbo.MKDRERES_SFMC
	WHERE DATA_MAILING >= '2017-06-01'
	group by DATA_MAILING,[Tipo Renovacao]
	UNION
	select Count(*) QTD, 'Mailing Auto KPN', DataGeracao,''
	from mailing.mailingautokpn
	where DataRefMailing >=  '2017-06-01'
	group by DataGeracao
	UNION
	select Count(*) ,'Mini Opportunity' ,DataHoraSistema,case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
	from Stage_Salesforce.ErrorLog.Log_Mini_Oportunidade__c
	where DataHoraSistema >= '2017-06-01'
	--and Error like '%Operation Successful%'
	group by DataHoraSistema,case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
	UNION
	select count(*),'Leads', DataHoraSistema,case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
	from Stage_Salesforce.ErrorLog.Log_Lead
	where DataHoraSistema >= '2017-06-01'
	--and Error like '%Operation Successful%'
	and Origem_Integracao__c='AQAUTSIS20150901'
	group by DataHoraSistema,case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
	UNION
	select count(*), 'RetencaoResidencial',DataMailing, case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END Error
	from [Salesforce Backups].dbo.Log_Opportunity_load_RD_PF_RetencaoResidencial
	where DataMailing  >= '2017-06-01'
	--and Error like '%Operation Successful%'
	group by DataMailing,case WHEN Error like '%Operation Successful%' THEN 'Operation Successful' ELSE 'Error' END
)
SELECT *, MONTH(DataRefMailing) AS Mes , (convert(varchar(10), DataRefMailing, 108) ) AS HORA, (case when convert(varchar(10), DataRefMailing, 108) < '08:30' then 1 ELSE 0 END) HoraSLA
FROM CT
WHERE Error NOT LIKE '%Error%'
--order by DataRefMailing, Mailing





