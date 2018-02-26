CREATE ROLE [db_spExec]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_spExec] ADD MEMBER [UsrSistemaBox];


GO
ALTER ROLE [db_spExec] ADD MEMBER [PARCORRETORA\CleomarPestilli];


GO
ALTER ROLE [db_spExec] ADD MEMBER [PARCORRETORA\Parser_sql01];


GO
ALTER ROLE [db_spExec] ADD MEMBER [PARCORRETORA\pedroluiz];


GO
ALTER ROLE [db_spExec] ADD MEMBER [usrCORPLinked];


GO
ALTER ROLE [db_spExec] ADD MEMBER [usrCorporativo];

