CREATE ROLE [Pessoal]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Pessoal] ADD MEMBER [PARCORRETORA\CleomarPestilli];


GO
ALTER ROLE [Pessoal] ADD MEMBER [usrQlikview];

