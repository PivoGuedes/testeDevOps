CREATE TABLE [dbo].[TOP_IDXSTATS] (
    [IDX_ENV]    VARCHAR (32)  CONSTRAINT [TOP_IDXSTATS_IDX_ENV_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_TABLE]  VARCHAR (32)  CONSTRAINT [TOP_IDXSTATS_IDX_TABLE_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_NAME]   VARCHAR (32)  CONSTRAINT [TOP_IDXSTATS_IDX_NAME_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_KEY]    VARCHAR (255) CONSTRAINT [TOP_IDXSTATS_IDX_KEY_DF] DEFAULT ('                                                                                                                                                                                                                                                               ') NOT NULL,
    [IDX_USE]    FLOAT (53)    CONSTRAINT [TOP_IDXSTATS_IDX_USE_DF] DEFAULT ((0)) NOT NULL,
    [R_E_C_N_O_] INT           CONSTRAINT [TOP_IDXSTATS_R_E_C_N_O__DF] DEFAULT ((0)) NOT NULL
) ON [PRIMARY];

