CREATE TABLE [dbo].[TOP_VIRTUALIDX] (
    [IDX_ENV]   VARCHAR (32)  CONSTRAINT [TOP_VIRTUALIDX_IDX_ENV_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_TABLE] VARCHAR (32)  CONSTRAINT [TOP_VIRTUALIDX_IDX_TABLE_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_NAME]  VARCHAR (32)  CONSTRAINT [TOP_VIRTUALIDX_IDX_NAME_DF] DEFAULT ('                                ') NOT NULL,
    [IDX_KEY]   VARCHAR (255) CONSTRAINT [TOP_VIRTUALIDX_IDX_KEY_DF] DEFAULT ('                                                                                                                                                                                                                                                               ') NOT NULL
) ON [PRIMARY];

