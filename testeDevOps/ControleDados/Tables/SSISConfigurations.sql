CREATE TABLE [ControleDados].[SSISConfigurations] (
    [ConfigurationFilter] NVARCHAR (255) NOT NULL,
    [ConfiguredValue]     NVARCHAR (255) NULL,
    [PackagePath]         NVARCHAR (255) NOT NULL,
    [ConfiguredValueType] NVARCHAR (20)  NOT NULL
) ON [PRIMARY];

