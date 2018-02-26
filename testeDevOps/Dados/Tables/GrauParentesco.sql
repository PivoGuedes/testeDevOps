﻿CREATE TABLE [Dados].[GrauParentesco] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Descricao] VARCHAR (20) NULL,
    [Codigo]    VARCHAR (2)  NULL,
    CONSTRAINT [PK_GRAUPARENTESCO] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [PRIMARY]
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141112-173103]
    ON [Dados].[GrauParentesco]([Codigo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
    ON [PRIMARY];
