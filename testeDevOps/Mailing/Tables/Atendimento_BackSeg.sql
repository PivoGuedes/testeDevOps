CREATE TABLE [Mailing].[Atendimento_BackSeg] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [Data_Vigencia] DATE          NULL,
    [Data_Acao]     DATE          NULL,
    [Cod_Cliente]   VARCHAR (200) NULL,
    [Num_Titulo]    VARCHAR (200) NULL,
    [Num_CPF]       VARCHAR (200) NULL,
    [Nom_Devedor]   VARCHAR (200) NULL,
    [End_Com_Cargo] VARCHAR (200) NULL,
    [End_Res_UF]    VARCHAR (200) NULL,
    [Tipo_Fone]     VARCHAR (200) NULL,
    [Cod_Acao]      VARCHAR (200) NULL,
    [Hora_Acao]     VARCHAR (200) NULL,
    [Fone_1]        VARCHAR (200) NULL,
    [Fone_2]        VARCHAR (200) NULL,
    [Fone_3]        VARCHAR (200) NULL,
    [Fone_4]        VARCHAR (200) NULL,
    [Fone_5]        VARCHAR (200) NULL,
    [Dcr_Sub_Acao]  VARCHAR (200) NULL,
    [Email_1]       VARCHAR (200) NULL,
    [Email_2]       VARCHAR (200) NULL,
    [Num_Fone]      VARCHAR (200) NULL,
    [APPL]          VARCHAR (200) NULL,
    [Cod_Fase]      VARCHAR (200) NULL
)
WITH (DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_atendimento_backseg_NUM_CPF]
    ON [Mailing].[Atendimento_BackSeg]([Num_CPF] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_atendimento_backseg_NUM_TITULO]
    ON [Mailing].[Atendimento_BackSeg]([Num_Titulo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

