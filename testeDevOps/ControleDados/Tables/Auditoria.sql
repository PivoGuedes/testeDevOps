CREATE TABLE [ControleDados].[Auditoria] (
    [AuditoriaID]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [Type]            CHAR (1)       NULL,
    [TableName]       VARCHAR (128)  NULL,
    [PrimaryKeyField] VARCHAR (1000) NULL,
    [FieldName]       VARCHAR (128)  NULL,
    [FieldType]       VARCHAR (128)  NULL,
    [OldValue]        VARCHAR (1000) NULL,
    [NewValue]        VARCHAR (1000) NULL,
    [UpdateDate]      DATETIME       CONSTRAINT [DF__Auditoria__Updat__1FCE88421] DEFAULT (getdate()) NULL,
    [UserName]        VARCHAR (128)  NULL,
    CONSTRAINT [PK_Auditoria] PRIMARY KEY CLUSTERED ([AuditoriaID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [idx_NCLAuditoriaUpdateDate]
    ON [ControleDados].[Auditoria]([UpdateDate] DESC)
    INCLUDE([AuditoriaID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

