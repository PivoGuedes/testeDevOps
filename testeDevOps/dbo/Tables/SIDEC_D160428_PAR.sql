﻿CREATE TABLE [dbo].[SIDEC_D160428_PAR] (
    [Column 0]  VARCHAR (255) NULL,
    [Column 1]  VARCHAR (255) NULL,
    [Column 2]  VARCHAR (255) NULL,
    [Column 3]  VARCHAR (255) NULL,
    [Column 4]  VARCHAR (255) NULL,
    [Column 5]  VARCHAR (255) NULL,
    [Column 6]  VARCHAR (255) NULL,
    [Column 7]  VARCHAR (255) NULL,
    [Column 8]  VARCHAR (255) NULL,
    [Column 9]  VARCHAR (255) NULL,
    [Column 10] VARCHAR (255) NULL,
    [Column 11] VARCHAR (255) NULL,
    [Column 12] VARCHAR (255) NULL,
    [Column 13] VARCHAR (255) NULL,
    [Column 14] VARCHAR (255) NULL,
    [id]        INT           IDENTITY (1, 1) NOT NULL
);


GO
CREATE CLUSTERED INDEX [CL_IDX_CC_TEMP_P]
    ON [dbo].[SIDEC_D160428_PAR]([Column 0] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);

