CREATE TABLE [dbo].[Temp_Enriquecimento_Parentes_012016] (
    [CPF]             NVARCHAR (255) NULL,
    [Nome]            NVARCHAR (255) NULL,
    [Parentesco]      NVARCHAR (255) NULL,
    [CPF_Parente]     NVARCHAR (255) NULL,
    [Nome_Parente]    NVARCHAR (255) NULL,
    [Tipo_Logradouro] NVARCHAR (255) NULL,
    [Logradouro]      NVARCHAR (255) NULL,
    [Numero]          NVARCHAR (255) NULL,
    [Complemento]     NVARCHAR (255) NULL,
    [Bairro]          NVARCHAR (255) NULL,
    [Cidade]          NVARCHAR (255) NULL,
    [UF]              NVARCHAR (255) NULL,
    [CEP]             NVARCHAR (255) NULL,
    [Telefone1]       NVARCHAR (255) NULL,
    [Telefone2]       NVARCHAR (255) NULL,
    [Telefone3]       NVARCHAR (255) NULL,
    [Telefone4]       NVARCHAR (255) NULL,
    [Celular1]        NVARCHAR (255) NULL,
    [Celular2]        NVARCHAR (255) NULL,
    [Celular3]        NVARCHAR (255) NULL,
    [Celular4]        NVARCHAR (255) NULL,
    [Email1]          NVARCHAR (255) NULL,
    [Email2]          NVARCHAR (255) NULL,
    [Email3]          NVARCHAR (255) NULL,
    [Email4]          NVARCHAR (255) NULL
);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_CPF]
    ON [dbo].[Temp_Enriquecimento_Parentes_012016]([CPF_Parente] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

