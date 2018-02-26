﻿CREATE TABLE [dbo].[TASKSALESFORCE] (
    [AccountId]                                  NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ActivityDate]                               DATETIME2 (7)   NULL,
    [AvaliacaoRegistroChamada__c]                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Call_Ani__c]                                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Call_CalledNumber__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Call_ConversationId__c]                     NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Call_QueueName__c]                          NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CallDisposition]                            NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CallDurationInSeconds]                      INT             NULL,
    [CallObject]                                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CallType]                                   NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Campanha__c]                                NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Categoria__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Categoria_v2__c]                            NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Comit_s_de_Partes_Relacionadas_e_Gente__c]  VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Concluido__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Conta__c]                                   NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CreatedById]                                NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CreatedDate]                                DATETIME2 (7)   NOT NULL,
    [Data_agendamento__c]                        NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Data_da_intera_o__c]                        DATETIME2 (7)   NULL,
    [Data_da_tarefa__c]                          DATETIME2 (7)   NULL,
    [Data_Hora_Cria_o__c]                        DATETIME2 (7)   NULL,
    [Data_Hora_de_agendamento__c]                DATETIME2 (7)   NULL,
    [Data_hora_integracao__c]                    DATETIME2 (7)   NULL,
    [DB_Activity_Type__c]                        NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Descricao_do_agendamento__c]                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Description]                                NTEXT           COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DEV_Nota_Atendimento__c]                    NVARCHAR (2)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DEV_OrigemAtividade_Tipo__c]                DECIMAL (18)    NULL,
    [DEV_Papel__c]                               NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DEV_Tabulada__c]                            DECIMAL (18)    NULL,
    [DEV_Telefonia__c]                           DECIMAL (18)    NULL,
    [DEV_Venda__c]                               DECIMAL (18)    NULL,
    [Dia_Falta_MKT__c]                           DECIMAL (18)    NULL,
    [Expans_o_de_ASVENS__c]                      VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Fila__c]                                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FoiPossivelAtivarCCA__c]                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Gerou_Intera_o__c]                          VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Gerou_Tarefa__c]                            VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Governan_a_corporativa_da_Par_Corretora__c] VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Hora_agendamento__c]                        NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Id]                                         NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ID_da_ligacao_PureCloud__c]                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Id_Dev__c]                                  NVARCHAR (20)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ININ_Link__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [IsArchived]                                 VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsClosed]                                   VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsDeleted]                                  VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsHighPriority]                             VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsRecurrence]                               VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsReminderSet]                              VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsVisibleInSelfService]                     VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Justificativa__c]                           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [LastModifiedById]                           NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [LastModifiedDate]                           DATETIME2 (7)   NOT NULL,
    [Local__c]                                   NVARCHAR (30)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Mgmt_Turnaround_ap_s_entrada_da_GP_CS__c]   VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Minuto_Falta_Mkt__c]                        DECIMAL (18)    NULL,
    [Modelo_de_Neg_cio_Par_Investment_Case__c]   VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo__c]                                  NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_da_Liga_o_Muda__c]                   NVARCHAR (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_Espec_fico__c]                       NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_ININ__c]                             NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_Ligacao__c]                          NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Motivo_v2__c]                               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Oportunidade__c]                            NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Or_amento__c]                               VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [OutboundDialing_CampaignId__c]              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [OutboundDialing_ContactId__c]               NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [OutboundDialing_ContactListId__c]           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Outros__c]                                  VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [OwnerId]                                    NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Participant_CustomFieldName__c]             NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Participantes_PAR__c]                       NTEXT           COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Performance_de_outros_produtos__c]          VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Performance_do_produto_Habitacional__c]     VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Performance_do_produto_Prestamista__c]      VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Performance_do_produto_Vida__c]             VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Plano_de_recuperacao__c]                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Prioridade_da_Tarefa__c]                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Priority]                                   NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Privado__c]                                 VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Produto__c]                                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Produto_questionado__c]                     NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecordTypeId]                               NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceActivityId]                       NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceDayOfMonth]                       INT             NULL,
    [RecurrenceDayOfWeekMask]                    INT             NULL,
    [RecurrenceEndDateOnly]                      DATETIME2 (7)   NULL,
    [RecurrenceInstance]                         NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceInterval]                         INT             NULL,
    [RecurrenceMonthOfYear]                      NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceRegeneratedType]                  NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceStartDateOnly]                    DATETIME2 (7)   NULL,
    [RecurrenceTimeZoneSidKey]                   NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RecurrenceType]                             NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Regiao__c]                                  NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Relacionado_a__c]                           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ReminderDateTime]                           DATETIME2 (7)   NULL,
    [ReminderTaskId__c]                          NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Replica_compromisso_na_agenda_de_asven__c]  NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Replica_Compromisso_para_Agenda_de_GV__c]   NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Requer_agendamento__c]                      VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Resultados_do_trimestre_corrente__c]        VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Sa_da_da_GP_do_Bloco_de_Controle__c]        VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Salesforce_AfterCallTime__c]                DECIMAL (18)    NULL,
    [Salesforce_CallDuration__c]                 NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Salesforce_ParticipantId__c]                NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Segundo_Contato__c]                         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status]                                     NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Status__c]                                  NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_Chamada__c]                          NVARCHAR (100)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_da_Intera_o__c]                      NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_da_negocia_o_da_exclusividade__c]    VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_da_Tarefa__c]                        NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_de_novos_projetos__c]                VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_do_procejo_Prestamista_PJ_e_CCA__c]  VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Status_Registro_de_Chamada__c]              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Sub_motivo__c]                              NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Sub_motivo_v2__c]                           NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Sub_Status_Registro_de_Chamadas__c]         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Subject]                                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [SystemModstamp]                             DATETIME2 (7)   NOT NULL,
    [TaskSubtype]                                NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Telefone__c]                                NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Telefone_discado__c]                        NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tem_Mais_Caixa__c]                          VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tempo_da_ligacao_segundos__c]               DECIMAL (18)    NULL,
    [Tempo_de_trabalho_pos_liga_o_segundos__c]   DECIMAL (18)    NULL,
    [Tipo__c]                                    NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_atendimento_v2__c]                     NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_de_Intera_o__c]                        NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_de_ligacao__c]                         NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Tipo_de_Tarefa__c]                          NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Type]                                       NVARCHAR (40)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [URL_gravacao__c]                            NVARCHAR (255)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WhatCount]                                  INT             NULL,
    [WhatId]                                     NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WhoCount]                                   INT             NULL,
    [WhoId]                                      NCHAR (18)      COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);

