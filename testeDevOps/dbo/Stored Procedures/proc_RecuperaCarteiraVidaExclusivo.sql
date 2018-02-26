
CREATE PROCEDURE [dbo].[proc_RecuperaCarteiraVidaExclusivo]
as 
--drop table #PRP_VIDA

create table #PRP_VIDA
(IDProposta BIGINT DEFAULT(0)
,IDContrato BIGINT DEFAULT(0)
,IDCertificado BIGINT DEFAULT(0)
)
