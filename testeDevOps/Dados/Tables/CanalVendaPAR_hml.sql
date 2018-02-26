CREATE TABLE [Dados].[CanalVendaPAR_hml] (
    [ID]                              INT          NOT NULL,
    [IDCanalMestre]                   INT          NULL,
    [DigitoIdentificador]             BIT          NOT NULL,
    [ProdutoIdentificador]            BIT          NOT NULL,
    [MatriculaVendedorIdentificadora] BIT          NOT NULL,
    [VendaAgencia]                    BIT          NOT NULL,
    [Codigo]                          VARCHAR (20) NULL,
    [CodigoHierarquico]               VARCHAR (40) NULL,
    [Nome]                            VARCHAR (80) NOT NULL,
    [DataInicio]                      DATE         NOT NULL,
    [DataFim]                         DATE         NULL,
    [CanalVinculador]                 BIT          NULL
);

