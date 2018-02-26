CREATE TABLE [Dados].[SimuladorAuto] (
    [ID]                              INT             IDENTITY (1, 1) NOT NULL,
    [IDSituacaoCalculo]               TINYINT         NULL,
    [DataCalculo]                     DATE            NULL,
    [NumeroCalculo]                   INT             NULL,
    [DataInicioVigencia]              DATE            NULL,
    [CodModelo]                       INT             NULL,
    [IDVeiculo]                       INT             NULL,
    [Placa]                           VARCHAR (8)     NULL,
    [Chassis]                         VARCHAR (18)    NULL,
    [Ano]                             SMALLINT        NULL,
    [Carroceria]                      VARCHAR (40)    NULL,
    [IDAgenciaVenda]                  SMALLINT        NULL,
    [IDIndicador]                     INT             NULL,
    [CPFCNPJ]                         VARCHAR (19)    NULL,
    [NomeCliente]                     VARCHAR (150)   NULL,
    [TipoPessoa]                      CHAR (1)        NULL,
    [IDSexo]                          TINYINT         NULL,
    [DataNascimento]                  DATE            NULL,
    [IDTipoCliente]                   TINYINT         NULL,
    [IDEstadoCivil]                   TINYINT         NULL,
    [DDDTelefoneContato]              VARCHAR (3)     NULL,
    [TelefoneContato]                 VARCHAR (10)    NULL,
    [UF]                              CHAR (2)        NULL,
    [Cidade]                          VARCHAR (200)   NULL,
    [CEP]                             VARCHAR (10)    NULL,
    [Apelido]                         VARCHAR (100)   NULL,
    [IDClasseBonusAnterior]           TINYINT         NULL,
    [IDTipoSeguro]                    TINYINT         NULL,
    [IDFaixaMediaKMParticular]        TINYINT         NULL,
    [IDFaixaMediaKMComercial]         TINYINT         NULL,
    [EstendeCoberturaMenores]         BIT             NULL,
    [PrecisaVistoria]                 BIT             NULL,
    [ProdutoMulher]                   BIT             NULL,
    [Produto0Km]                      BIT             NULL,
    [IsentoFran1Sin]                  BIT             NULL,
    [IsentoFranEquip]                 BIT             NULL,
    [IsentoFranCarroc]                BIT             NULL,
    [Turbinado]                       BIT             NULL,
    [Blindado]                        BIT             NULL,
    [CobVidros]                       BIT             NULL,
    [CobDespesasExtras]               BIT             NULL,
    [CobLantFarRetro]                 BIT             NULL,
    [CobDanosMateriais]               DECIMAL (19, 2) NULL,
    [CobDanosMorais]                  DECIMAL (19, 2) NULL,
    [CobDanosCorporais]               DECIMAL (19, 2) NULL,
    [CobAPP]                          DECIMAL (19, 2) NULL,
    [DespesasMedHosp]                 DECIMAL (19, 2) NULL,
    [ValorPremio]                     DECIMAL (19, 2) NULL,
    [ValorFIPE]                       DECIMAL (19, 2) NULL,
    [IDFormaPagtoParcela1]            TINYINT         NULL,
    [IDFormaPagtoDemaisParcelas]      TINYINT         NULL,
    [IDPerfil_Qar]                    TINYINT         NULL,
    [IDAss24h]                        TINYINT         NULL,
    [IDCarroReserva]                  TINYINT         NULL,
    [IDTipoUsoVeiculo]                TINYINT         NULL,
    [IDFormaContratacao]              TINYINT         NULL,
    [IDTipoFranquia]                  TINYINT         NULL,
    [IDTipoRelacaoSegurado]           TINYINT         NULL,
    [IDTipoCarroReserva]              TINYINT         NULL,
    [QRRespondido]                    BIT             NULL,
    [QtdParcelas]                     TINYINT         NULL,
    [Email]                           VARCHAR (70)    NULL,
    [IDProposta]                      BIGINT          NULL,
    [IDContratoAnterior]              BIGINT          NULL,
    [Arquivo]                         VARCHAR (150)   NULL,
    [DataArquivo]                     DATE            NULL,
    [CPFCNPJ_NOFORMAT]                AS              (replace(replace(replace([CPFCNPJ],'.',''),'/',''),'-','')) PERSISTED,
    [CPFCNPJ_BIGINT]                  AS              (CONVERT([bigint],replace(replace(replace([CPFCNPJ],'.',''),'/',''),'-',''))) PERSISTED,
    [DataNascimentoPrincipalCondutor] DATE            NULL,
    [EstadoCivilPrincipalCondutor]    VARCHAR (20)    NULL,
    [PrincipalCondutorTrabalha]       VARCHAR (20)    NULL,
    [PrincipalCondutorEstuda]         VARCHAR (20)    NULL,
    [CadastroOpcionais]               VARCHAR (200)   NULL,
    [ValorFranquia]                   DECIMAL (19, 2) NULL,
    [TIPO_COMBUSTIVEL]                VARCHAR (50)    NULL,
    [UFPLACA]                         CHAR (2)        NULL,
    [CEPResidenciaEOMesmo]            VARCHAR (20)    NULL,
    [GuardaVeiculoGaragem]            VARCHAR (50)    NULL,
    [CPFPrincipalCondutor]            VARCHAR (20)    NULL,
    [NomePrincipalCondutor]           VARCHAR (200)   NULL,
    [SexoPrincipalCondutor]           VARCHAR (20)    NULL,
    [CodigoFipe]                      VARCHAR (10)    NULL,
    [CodFipe_Fabricante]              AS              (substring(right('0000000'+CONVERT([varchar](10),[CodigoFipe]),(7)),(1),(3))),
    [CodFipe_Modelo]                  AS              (substring(right('0000000'+CONVERT([varchar](10),[CodigoFipe]),(7)),(4),(3))),
    [CodFipe_ModeloDV]                AS              (substring(right('0000000'+CONVERT([varchar](10),[CodigoFipe]),(7)),(7),(1))),
    [Rowversion]                      ROWVERSION      NOT NULL,
    [CPFCNPJ_CI_AS]                   AS              ([CPFCNPJ] collate SQL_Latin1_General_CP1_CI_AS),
    [NomeUsuarioLogado]               VARCHAR (100)   NULL,
    [CPFUsuarioLogado]                VARCHAR (50)    NULL,
    CONSTRAINT [PK_SimuladorAuto] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_SimuladorAuto_ClasseBonus] FOREIGN KEY ([IDClasseBonusAnterior]) REFERENCES [Dados].[ClasseBonus] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_ClasseFranquia] FOREIGN KEY ([IDTipoFranquia]) REFERENCES [Dados].[ClasseFranquia] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Contrato] FOREIGN KEY ([IDContratoAnterior]) REFERENCES [Dados].[Contrato] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_EstadoCivil] FOREIGN KEY ([IDEstadoCivil]) REFERENCES [Dados].[EstadoCivil] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_FormaContratacao] FOREIGN KEY ([IDFormaContratacao]) REFERENCES [Dados].[FormaContratacao] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_FormaPagamento] FOREIGN KEY ([IDFormaPagtoParcela1]) REFERENCES [Dados].[FormaPagamento] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_FormaPagamento1] FOREIGN KEY ([IDFormaPagtoDemaisParcelas]) REFERENCES [Dados].[FormaPagamento] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Funcionario] FOREIGN KEY ([IDIndicador]) REFERENCES [Dados].[Funcionario] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_MediaQuilometragem] FOREIGN KEY ([IDFaixaMediaKMComercial]) REFERENCES [Dados].[MediaQuilometragem] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_MediaQuilometragem1] FOREIGN KEY ([IDFaixaMediaKMParticular]) REFERENCES [Dados].[MediaQuilometragem] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_PerfilQuestionarioRisco] FOREIGN KEY ([IDPerfil_Qar]) REFERENCES [Dados].[PerfilQuestionarioRisco] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Proposta] FOREIGN KEY ([IDProposta]) REFERENCES [Dados].[Proposta] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Sexo] FOREIGN KEY ([IDSexo]) REFERENCES [Dados].[Sexo] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_SituacaoCalculo] FOREIGN KEY ([IDSituacaoCalculo]) REFERENCES [Dados].[SituacaoCalculo] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_TipoCarroReserva] FOREIGN KEY ([IDTipoCarroReserva]) REFERENCES [Dados].[TipoCarroReserva] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_TipoCliente] FOREIGN KEY ([IDTipoCliente]) REFERENCES [Dados].[TipoCliente] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_TipoRelacaoSegurado] FOREIGN KEY ([IDTipoRelacaoSegurado]) REFERENCES [Dados].[TipoRelacaoSegurado] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_TipoSeguro] FOREIGN KEY ([IDTipoSeguro]) REFERENCES [Dados].[TipoSeguro] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_TipoUsoVeiculo] FOREIGN KEY ([IDTipoUsoVeiculo]) REFERENCES [Dados].[TipoUsoVeiculo] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Unidade] FOREIGN KEY ([IDAgenciaVenda]) REFERENCES [Dados].[Unidade] ([ID]),
    CONSTRAINT [FK_SimuladorAuto_Veiculo] FOREIGN KEY ([IDVeiculo]) REFERENCES [Dados].[Veiculo] ([ID]),
    CONSTRAINT [UNQ_SimuladorAuto] UNIQUE NONCLUSTERED ([NumeroCalculo] ASC, [DataCalculo] ASC, [DataArquivo] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_SimuladorAuto_CPFCNPJ]
    ON [Dados].[SimuladorAuto]([CPFCNPJ] ASC, [IDSituacaoCalculo] ASC, [DataCalculo] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_SimuladorAuto_DataCalculo]
    ON [Dados].[SimuladorAuto]([DataCalculo] ASC)
    INCLUDE([CPFCNPJ], [IDSituacaoCalculo], [NomeCliente], [DDDTelefoneContato], [TelefoneContato], [IDTipoSeguro], [NumeroCalculo], [ValorFIPE], [TipoPessoa]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_SimuladorAuto_CPFCNPJ_MailingMS]
    ON [Dados].[SimuladorAuto]([CPFCNPJ] ASC, [IDSituacaoCalculo] ASC, [DataCalculo] ASC)
    INCLUDE([IDTipoSeguro], [DataNascimento], [NumeroCalculo], [ValorFIPE], [NomeCliente], [TipoPessoa], [IDSexo], [IDClasseBonusAnterior], [CEP], [IDEstadoCivil], [IDTipoRelacaoSegurado], [DataInicioVigencia], [Ano], [CodModelo], [Blindado], [Chassis], [IDFormaContratacao], [IDTipoFranquia], [CobDanosMateriais], [CobDanosMorais], [IDAss24h], [Email], [IDCarroReserva], [IDTipoCarroReserva], [CobAPP], [DespesasMedHosp], [IDVeiculo], [CobLantFarRetro], [CobVidros], [CobDespesasExtras], [EstendeCoberturaMenores], [IDTipoCliente], [IDTipoUsoVeiculo], [CobDanosCorporais], [Placa], [ValorPremio]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [NCL_IDX_simuladorauto_CPFNoFormat]
    ON [Dados].[SimuladorAuto]([CPFCNPJ_NOFORMAT] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_DataCalculo_ValorFranquia_MailingAutoKPN]
    ON [Dados].[SimuladorAuto]([DataCalculo] ASC, [ValorFranquia] ASC)
    INCLUDE([NumeroCalculo], [DataInicioVigencia], [IDVeiculo], [Placa], [Chassis], [Ano], [CPFCNPJ], [TipoPessoa], [IDSexo], [IDTipoCliente], [IDEstadoCivil], [CEP], [IDClasseBonusAnterior], [IDTipoSeguro], [EstendeCoberturaMenores], [Blindado], [CobVidros], [CobDespesasExtras], [CobLantFarRetro], [CobDanosMateriais], [CobDanosMorais], [CobDanosCorporais], [CobAPP], [DespesasMedHosp], [ValorPremio], [ValorFIPE], [IDAss24h], [IDCarroReserva], [IDTipoUsoVeiculo], [IDFormaContratacao], [IDTipoFranquia], [IDTipoRelacaoSegurado]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE ON PARTITIONS (8), DATA_COMPRESSION = PAGE ON PARTITIONS (9), DATA_COMPRESSION = PAGE ON PARTITIONS (10), DATA_COMPRESSION = PAGE ON PARTITIONS (11), DATA_COMPRESSION = PAGE ON PARTITIONS (12), DATA_COMPRESSION = PAGE ON PARTITIONS (13), DATA_COMPRESSION = PAGE ON PARTITIONS (14), DATA_COMPRESSION = PAGE ON PARTITIONS (15), DATA_COMPRESSION = PAGE ON PARTITIONS (16), DATA_COMPRESSION = PAGE ON PARTITIONS (17), DATA_COMPRESSION = PAGE ON PARTITIONS (18), DATA_COMPRESSION = PAGE ON PARTITIONS (19), DATA_COMPRESSION = PAGE ON PARTITIONS (20), DATA_COMPRESSION = PAGE ON PARTITIONS (21), DATA_COMPRESSION = PAGE ON PARTITIONS (22), DATA_COMPRESSION = PAGE ON PARTITIONS (23), DATA_COMPRESSION = PAGE ON PARTITIONS (24), DATA_COMPRESSION = PAGE ON PARTITIONS (25), DATA_COMPRESSION = PAGE ON PARTITIONS (26), DATA_COMPRESSION = PAGE ON PARTITIONS (27), DATA_COMPRESSION = PAGE ON PARTITIONS (28), DATA_COMPRESSION = PAGE ON PARTITIONS (29), DATA_COMPRESSION = PAGE ON PARTITIONS (30), DATA_COMPRESSION = PAGE ON PARTITIONS (31), DATA_COMPRESSION = PAGE ON PARTITIONS (32), DATA_COMPRESSION = PAGE ON PARTITIONS (33), DATA_COMPRESSION = PAGE ON PARTITIONS (34), DATA_COMPRESSION = PAGE ON PARTITIONS (35), DATA_COMPRESSION = PAGE ON PARTITIONS (36), DATA_COMPRESSION = PAGE ON PARTITIONS (37), DATA_COMPRESSION = PAGE ON PARTITIONS (38), DATA_COMPRESSION = PAGE ON PARTITIONS (39), DATA_COMPRESSION = PAGE ON PARTITIONS (40), DATA_COMPRESSION = PAGE ON PARTITIONS (41), DATA_COMPRESSION = PAGE ON PARTITIONS (42), DATA_COMPRESSION = PAGE ON PARTITIONS (43), DATA_COMPRESSION = PAGE ON PARTITIONS (44), DATA_COMPRESSION = PAGE ON PARTITIONS (45), DATA_COMPRESSION = PAGE ON PARTITIONS (46), DATA_COMPRESSION = PAGE ON PARTITIONS (47), DATA_COMPRESSION = PAGE ON PARTITIONS (48), DATA_COMPRESSION = PAGE ON PARTITIONS (49), DATA_COMPRESSION = PAGE ON PARTITIONS (50), DATA_COMPRESSION = PAGE ON PARTITIONS (51), DATA_COMPRESSION = PAGE ON PARTITIONS (52), DATA_COMPRESSION = PAGE ON PARTITIONS (53), DATA_COMPRESSION = PAGE ON PARTITIONS (54), DATA_COMPRESSION = PAGE ON PARTITIONS (55), DATA_COMPRESSION = PAGE ON PARTITIONS (56), DATA_COMPRESSION = PAGE ON PARTITIONS (57), DATA_COMPRESSION = PAGE ON PARTITIONS (58), DATA_COMPRESSION = PAGE ON PARTITIONS (59), DATA_COMPRESSION = PAGE ON PARTITIONS (60), DATA_COMPRESSION = PAGE ON PARTITIONS (61), DATA_COMPRESSION = PAGE ON PARTITIONS (62), DATA_COMPRESSION = PAGE ON PARTITIONS (63), DATA_COMPRESSION = PAGE ON PARTITIONS (64), DATA_COMPRESSION = PAGE ON PARTITIONS (65), DATA_COMPRESSION = PAGE ON PARTITIONS (66), DATA_COMPRESSION = PAGE ON PARTITIONS (67), DATA_COMPRESSION = PAGE ON PARTITIONS (68), DATA_COMPRESSION = PAGE ON PARTITIONS (69), DATA_COMPRESSION = PAGE ON PARTITIONS (70), DATA_COMPRESSION = PAGE ON PARTITIONS (71), DATA_COMPRESSION = PAGE ON PARTITIONS (72), DATA_COMPRESSION = PAGE ON PARTITIONS (73), DATA_COMPRESSION = PAGE ON PARTITIONS (74), DATA_COMPRESSION = PAGE ON PARTITIONS (75), DATA_COMPRESSION = PAGE ON PARTITIONS (76), DATA_COMPRESSION = PAGE ON PARTITIONS (77), DATA_COMPRESSION = PAGE ON PARTITIONS (78), DATA_COMPRESSION = PAGE ON PARTITIONS (79), DATA_COMPRESSION = PAGE ON PARTITIONS (80), DATA_COMPRESSION = PAGE ON PARTITIONS (81), DATA_COMPRESSION = PAGE ON PARTITIONS (82), DATA_COMPRESSION = PAGE ON PARTITIONS (83), DATA_COMPRESSION = PAGE ON PARTITIONS (84), DATA_COMPRESSION = PAGE ON PARTITIONS (85), DATA_COMPRESSION = PAGE ON PARTITIONS (86), DATA_COMPRESSION = PAGE ON PARTITIONS (87), DATA_COMPRESSION = PAGE ON PARTITIONS (88), DATA_COMPRESSION = PAGE ON PARTITIONS (89), DATA_COMPRESSION = PAGE ON PARTITIONS (90), DATA_COMPRESSION = PAGE ON PARTITIONS (91), DATA_COMPRESSION = PAGE ON PARTITIONS (92), DATA_COMPRESSION = PAGE ON PARTITIONS (93), DATA_COMPRESSION = PAGE ON PARTITIONS (94), DATA_COMPRESSION = PAGE ON PARTITIONS (95), DATA_COMPRESSION = PAGE ON PARTITIONS (96), DATA_COMPRESSION = PAGE ON PARTITIONS (97), DATA_COMPRESSION = PAGE ON PARTITIONS (98), DATA_COMPRESSION = PAGE ON PARTITIONS (99), DATA_COMPRESSION = PAGE ON PARTITIONS (100), DATA_COMPRESSION = PAGE ON PARTITIONS (101), DATA_COMPRESSION = PAGE ON PARTITIONS (102), DATA_COMPRESSION = PAGE ON PARTITIONS (103), DATA_COMPRESSION = PAGE ON PARTITIONS (104), DATA_COMPRESSION = PAGE ON PARTITIONS (105), DATA_COMPRESSION = PAGE ON PARTITIONS (106), DATA_COMPRESSION = PAGE ON PARTITIONS (107), DATA_COMPRESSION = PAGE ON PARTITIONS (108), DATA_COMPRESSION = PAGE ON PARTITIONS (109), DATA_COMPRESSION = PAGE ON PARTITIONS (110), DATA_COMPRESSION = PAGE ON PARTITIONS (111), DATA_COMPRESSION = PAGE ON PARTITIONS (112), DATA_COMPRESSION = PAGE ON PARTITIONS (113), DATA_COMPRESSION = PAGE ON PARTITIONS (114), DATA_COMPRESSION = PAGE ON PARTITIONS (115), DATA_COMPRESSION = PAGE ON PARTITIONS (116), DATA_COMPRESSION = PAGE ON PARTITIONS (117), DATA_COMPRESSION = PAGE ON PARTITIONS (118), DATA_COMPRESSION = PAGE ON PARTITIONS (119), DATA_COMPRESSION = PAGE ON PARTITIONS (120), DATA_COMPRESSION = PAGE ON PARTITIONS (121), DATA_COMPRESSION = PAGE ON PARTITIONS (122), DATA_COMPRESSION = PAGE ON PARTITIONS (123), DATA_COMPRESSION = PAGE ON PARTITIONS (124), DATA_COMPRESSION = PAGE ON PARTITIONS (125), DATA_COMPRESSION = PAGE ON PARTITIONS (126), DATA_COMPRESSION = PAGE ON PARTITIONS (127), DATA_COMPRESSION = PAGE ON PARTITIONS (128), DATA_COMPRESSION = PAGE ON PARTITIONS (129), DATA_COMPRESSION = PAGE ON PARTITIONS (130), DATA_COMPRESSION = PAGE ON PARTITIONS (131), DATA_COMPRESSION = PAGE ON PARTITIONS (132), DATA_COMPRESSION = PAGE ON PARTITIONS (133), DATA_COMPRESSION = PAGE ON PARTITIONS (134), DATA_COMPRESSION = PAGE ON PARTITIONS (135), DATA_COMPRESSION = PAGE ON PARTITIONS (136), DATA_COMPRESSION = PAGE ON PARTITIONS (137), DATA_COMPRESSION = PAGE ON PARTITIONS (138), DATA_COMPRESSION = PAGE ON PARTITIONS (139), DATA_COMPRESSION = PAGE ON PARTITIONS (140), DATA_COMPRESSION = PAGE ON PARTITIONS (141), DATA_COMPRESSION = PAGE ON PARTITIONS (142), DATA_COMPRESSION = PAGE ON PARTITIONS (143), DATA_COMPRESSION = PAGE ON PARTITIONS (144), DATA_COMPRESSION = PAGE ON PARTITIONS (145), DATA_COMPRESSION = PAGE ON PARTITIONS (146), DATA_COMPRESSION = PAGE ON PARTITIONS (147), DATA_COMPRESSION = PAGE ON PARTITIONS (148), DATA_COMPRESSION = PAGE ON PARTITIONS (149), DATA_COMPRESSION = PAGE ON PARTITIONS (150), DATA_COMPRESSION = PAGE ON PARTITIONS (151), DATA_COMPRESSION = PAGE ON PARTITIONS (1), DATA_COMPRESSION = PAGE ON PARTITIONS (2), DATA_COMPRESSION = PAGE ON PARTITIONS (3), DATA_COMPRESSION = PAGE ON PARTITIONS (4), DATA_COMPRESSION = PAGE ON PARTITIONS (5), DATA_COMPRESSION = PAGE ON PARTITIONS (6), DATA_COMPRESSION = PAGE ON PARTITIONS (7))
    ON [PS_DADOS_DataCompetencia] ([DataCalculo]);


GO
CREATE NONCLUSTERED INDEX [IDX_NCL_SimuladorAuto_IDSituacaoCalculo_DataArquivo]
    ON [Dados].[SimuladorAuto]([IDSituacaoCalculo] ASC, [DataArquivo] ASC)
    INCLUDE([IDAgenciaVenda], [IDProposta]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_DataArquivo]
    ON [Dados].[SimuladorAuto]([DataArquivo] ASC)
    INCLUDE([ID], [IDSituacaoCalculo], [DataCalculo], [NumeroCalculo], [DataInicioVigencia], [CodModelo], [IDVeiculo], [Placa], [Chassis], [Ano], [Carroceria], [IDAgenciaVenda], [IDIndicador], [CPFCNPJ], [IDTipoCliente], [IDClasseBonusAnterior], [IDTipoSeguro], [IDFaixaMediaKMParticular], [IDFaixaMediaKMComercial], [EstendeCoberturaMenores], [PrecisaVistoria], [ProdutoMulher], [Produto0Km], [IsentoFran1Sin], [IsentoFranEquip], [IsentoFranCarroc], [Turbinado], [Blindado], [CobVidros], [CobDespesasExtras], [CobLantFarRetro], [CobDanosMateriais], [CobDanosMorais], [CobDanosCorporais], [CobAPP], [DespesasMedHosp], [ValorPremio], [ValorFIPE], [IDFormaPagtoParcela1], [IDFormaPagtoDemaisParcelas], [IDPerfil_Qar], [IDAss24h], [IDCarroReserva], [IDTipoUsoVeiculo], [IDFormaContratacao], [IDTipoFranquia], [IDTipoRelacaoSegurado], [IDTipoCarroReserva], [QRRespondido], [QtdParcelas], [IDProposta], [IDContratoAnterior]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_SuportaConsultaSF]
    ON [Dados].[SimuladorAuto]([IDProposta] ASC)
    INCLUDE([Placa], [Chassis], [Ano], [IDTipoCliente], [IDTipoSeguro], [CodigoFipe]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [<ncl_idx_Simulador_IDProposta]
    ON [Dados].[SimuladorAuto]([IDProposta] ASC)
    INCLUDE([IDTipoCliente], [IDTipoSeguro], [IDFormaPagtoParcela1], [CodFipe_Fabricante], [CodFipe_Modelo]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [ncl_idx_simulador]
    ON [Dados].[SimuladorAuto]([CPFCNPJ] ASC, [ID] DESC)
    INCLUDE([CodFipe_Fabricante], [CodFipe_Modelo], [IDTipoSeguro], [IDFormaPagtoParcela1]) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

