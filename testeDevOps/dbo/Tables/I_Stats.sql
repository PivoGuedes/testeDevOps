CREATE TABLE [dbo].[I_Stats] (
    [database_id]                    SMALLINT      NULL,
    [object_id]                      INT           NULL,
    [index_id]                       INT           NULL,
    [partition_number]               INT           NULL,
    [index_type_desc]                NVARCHAR (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [alloc_unit_type_desc]           NVARCHAR (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [index_depth]                    TINYINT       NULL,
    [index_level]                    TINYINT       NULL,
    [avg_fragmentation_in_percent]   FLOAT (53)    NULL,
    [fragment_count]                 BIGINT        NULL,
    [avg_fragment_size_in_pages]     FLOAT (53)    NULL,
    [page_count]                     BIGINT        NULL,
    [avg_page_space_used_in_percent] FLOAT (53)    NULL,
    [record_count]                   BIGINT        NULL,
    [ghost_record_count]             BIGINT        NULL,
    [version_ghost_record_count]     BIGINT        NULL,
    [min_record_size_in_bytes]       INT           NULL,
    [max_record_size_in_bytes]       INT           NULL,
    [avg_record_size_in_bytes]       FLOAT (53)    NULL,
    [forwarded_record_count]         BIGINT        NULL,
    [compressed_page_count]          BIGINT        NULL
);

