﻿
DROP PROCEDURE IF EXISTS dbo.UpsertResource

declare @sql varchar(max)=''

select @sql =@sql + 'drop table ' + name  + '; ' 
from sys.objects where type = 'U'

select @sql =@sql + 'drop type ' + name  + '; ' 
from sys.table_types

select @sql =@sql + 'drop sequence ' + name  + '; ' 
from sys.sequences


exec(@sql) 

CREATE TYPE [dbo].[ResourceTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[RawResource] [varbinary](max)
)
GO


/****** Object:  UserDefinedTableType [dbo].[DateSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[DateSearchParamTableType] AS TABLE(	
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[NumberSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[NumberSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Number] [decimal](18, 6) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuantitySearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[QuantitySearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [nvarchar](256) NULL,
	[Code] [nvarchar](256) NULL,
	[Quantity] [decimal](18, 6) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ReferenceSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[ReferenceSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[BaseUri] [varchar](512) NULL,
	[ReferenceResourceTypeId] [smallint] NULL,
	[ReferenceResourceId] [varchar](64) NOT NULL
)
GO


/****** Object:  UserDefinedTableType [dbo].[StringSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[StringSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Value] [nvarchar](512) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TokenSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[TokenSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [nvarchar](256) NULL,
	[Code] [nvarchar](256) NULL
)
GO

CREATE TYPE [dbo].[TokenTextSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[Text] [nvarchar](512) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[UriSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[UriSearchParamTableType] AS TABLE(
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceBatchOffset] [int] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Uri] [varchar](256) NOT NULL
)
GO
GO
/****** Object:  Table [dbo].[Resource]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resource](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[Version] [int] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[LastUpdated] [datetime] NULL,
	[RawResource] [varbinary](max) NOT NULL)
GO

CREATE UNIQUE CLUSTERED INDEX [IXC_Resource] ON [dbo].[Resource]
(
	ResourceTypeId, 
	ResourceId
)
WITH IGNORE_DUP_KEY

CREATE NONCLUSTERED INDEX [IX_Resource_ResourceSurrogateId] on [dbo].[Resource]
(
	ResourceSurrogateId
)

/****** Object:  Table [dbo].[DateSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateSearchParam](
    [ResourceTypeId] [smallint] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX IXC_DateSearchParam ON [dbo].[DateSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	CompositeInstanceId,
	StartTime,
	EndTime
)

/****** Object:  Table [dbo].[NumberSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NumberSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
    [ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Number] [decimal](18, 6) NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX IXC_NumberSearchParam ON [dbo].[NumberSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	CompositeInstanceId,
	Number
)

/****** Object:  Table [dbo].[QuantitySearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuantitySearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
    [ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [varchar](128) NULL,
	[Code] [varchar](128) NULL,
	[Quantity] [decimal](18, 6) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

CREATE CLUSTERED INDEX IXC_QuantitySearchParam ON [dbo].[QuantitySearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	CompositeInstanceId,
	Quantity,
	Code,
	System
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE NONCLUSTERED INDEX IXC_QuantitySearchParam_SearchParamId_Code_System ON [dbo].[QuantitySearchParam]
(
	SearchParamId,
	Quantity,
	Code,
	System
)
WITH (DATA_COMPRESSION = PAGE)

/****** Object:  Table [dbo].[ReferenceSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReferenceSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
    [ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[BaseUri] [varchar](128) NULL,
	[ReferenceResourceTypeId] [smallint] NULL,
	[ReferenceResourceId] [varchar](64) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

GO

CREATE CLUSTERED INDEX IXC_ReferenceSearchParam ON [dbo].[ReferenceSearchParam]
(
	[ResourceTypeId],
	SearchParamId,
	BaseUri,
	ReferenceResourceTypeId,
	ReferenceResourceId
)

CREATE NONCLUSTERED INDEX IX_ReferenceSearchParam_SearchParamId_BaseUri_ResourceId
ON [dbo].[ReferenceSearchParam] 
(
	[ResourceSurrogateId],
	[SearchParamId]
)

GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceType](
	[ResourceTypeId] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [Id_ResourceType] PRIMARY KEY CLUSTERED 
(
	[ResourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchParam](
	[SearchParamId] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Uri] [varchar](128) NOT NULL,
	[ComponentIndex] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StringSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StringSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Value] [nvarchar](400) NOT NULL, 
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE CLUSTERED INDEX IXC_StringSearchParam ON [dbo].[StringSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	CompositeInstanceId,
	Value
)

/****** Object:  Table [dbo].[TokenSearchParam]    Script Date: 3/25/2019 2:29:57 PM ******/



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokenSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [varchar](256) NULL,
	[Code] [varchar](256) NULL,
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE CLUSTERED INDEX IXC_TokenSearchParam ON [dbo].[TokenSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	Code,
	System,
	CompositeInstanceId
)

CREATE NONCLUSTERED INDEX IX_TokenSearchParam_SearchParamId_Code_System ON [dbo].[TokenSearchParam]
(
	SearchParamId,
	Code,
	System
)
WITH (DATA_COMPRESSION = PAGE)

CREATE TABLE [dbo].[TokenTextSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[Text] [nvarchar](400	) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE CLUSTERED INDEX IXC_TokenTextSearchParam ON [dbo].[TokenTextSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	[SearchParamId],
	[Text]
)
GO

CREATE NONCLUSTERED INDEX IX_TokenTextSearchParam_SearchParamId_Text ON [dbo].[TokenTextSearchParam]
(
	[SearchParamId],
	[Text]
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE TABLE [dbo].[UriSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceSurrogateId] [bigint] NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Uri] [varchar](256) NOT NULL
) 
ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

CREATE CLUSTERED INDEX IXC_UriSearchParam ON [dbo].[UriSearchParam]
(
	[ResourceTypeId],
	[ResourceSurrogateId],
	SearchParamId,
	CompositeInstanceId,
	Uri
)
GO

DECLARE @sequenceCount int = 128

declare @sql varchar(max) = ''

DECLARE @count INT = 0;

WHILE @count < @sequenceCount
BEGIN
DECLARE @start bigint = CAST(9223372036854775807 / @sequenceCount AS BIGINT) * @count
DECLARE @end bigint = CAST(9223372036854775807 / @sequenceCount AS BIGINT) * (@count + 1) -1

set @sql = @sql + FORMATMESSAGE(
	'CREATE SEQUENCE MySeq_%i
		AS BIGINT   
		START WITH %I64d
		INCREMENT BY 1   
		MAXVALUE %I64d
		NO CYCLE  
		CACHE 50;
		
		',
		@count,
		@start,
		@end)
   SET @count = @count + 1;
END;

EXEC(@sql)

GO

--EXEC UpsertResource 1, '123', 0x0

CREATE PROCEDURE dbo.UpsertResource
	@tvpResource [dbo].[ResourceTableType] READONLY,
	@tvpStringSearchParam [dbo].[StringSearchParamTableType] READONLY,
	@tvpTokenSearchParam [dbo].[TokenSearchParamTableType] READONLY,
	@tvpTokenTextSearchParam [dbo].[TokenTextSearchParamTableType] READONLY,
	@tvpDateSearchParam [dbo].[DateSearchParamTableType] READONLY,
	@tvpReferenceSearchParam [dbo].[ReferenceSearchParamTableType] READONLY,
	@tvpQuantitySearchParam [dbo].[QuantitySearchParamTableType] READONLY,
	@tvpNumberSearchParam [dbo].[NumberSearchParamTableType] READONLY,
	@tvpUriSearchParam [dbo].[UriSearchParamTableType] READONLY
	AS
		SET XACT_ABORT ON
		BEGIN TRANSACTION

		DECLARE @resourceSurrogateIdOffsetVariant sql_variant;  
		DECLARE @resourceCount int = (select count(*) from @tvpResource)
		DECLARE @sequenceName varchar(10) = 'MySeq_' +  CONVERT(varchar(10), (SELECT CAST(CRYPT_GEN_RANDOM(1) AS int) % 32))
  
		EXEC sp_sequence_get_range  
			@sequence_name = @sequenceName, 
			@range_size = @resourceCount, 
			@range_first_value = @resourceSurrogateIdOffsetVariant OUTPUT;  

		DECLARE @resourceSurrogateIdOffset bigint = CONVERT(bigint, @resourceSurrogateIdOffsetVariant)
		DECLARE @currentTime datetime2 = SYSUTCDATETIME()
		
		DECLARE @insertedResourceSurrogateId TABLE
		(
			ResourceSurrogateId bigint
		)

		DECLARE @skippedResourceSurrogateOffsetIds TABLE
		(
			ResourceSurrogateIdOffset int
		)

		INSERT INTO dbo.Resource
		(ResourceTypeId, ResourceId, Version, ResourceSurrogateId, LastUpdated, RawResource)
		OUTPUT inserted.ResourceSurrogateId
		INTO @insertedResourceSurrogateId
		SELECT new.ResourceTypeId, new.ResourceId, 1, (@resourceSurrogateIdOffset + ResourceBatchOffset), @currentTime, new.RawResource
		FROM @tvpResource new
		--WHERE NOT EXISTS (select * from Resource existing where existing.ResourceTypeId = new.ResourceTypeId AND existing.ResourceId = new.ResourceId)
		
		INSERT INTO @skippedResourceSurrogateOffsetIds
		SELECT ResourceBatchOffset
		FROM @tvpResource
		EXCEPT
		SELECT (ResourceSurrogateId - @resourceSurrogateIdOffset) 
		FROM @insertedResourceSurrogateId

		INSERT INTO dbo.StringSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, Value)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, Value 
		FROM @tvpStringSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.TokenSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, System, Code)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.System, p.Code
		FROM @tvpTokenSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.TokenTextSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, Text)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.Text p
		FROM @tvpTokenTextSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.DateSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, StartTime, EndTime)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.StartTime, p.EndTime 
		FROM @tvpDateSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.ReferenceSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, BaseUri, ReferenceResourceTypeId, ReferenceResourceId)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.BaseUri, p.ReferenceResourceTypeId, p.ReferenceResourceId 
		FROM @tvpReferenceSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.QuantitySearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, System, Code, Quantity)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.System, p.Code, p.Quantity 
		FROM @tvpQuantitySearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.NumberSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, Number)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.Number 
		FROM @tvpNumberSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		INSERT INTO dbo.UriSearchParam
		(ResourceTypeId, ResourceSurrogateId, SearchParamId, CompositeInstanceId, Uri)
		SELECT p.ResourceTypeId, @resourceSurrogateIdOffset + p.ResourceBatchOffset, p.SearchParamId, p.CompositeInstanceId, p.Uri 
		FROM @tvpUriSearchParam p
		--WHERE NOT EXISTS (SELECT * FROM @skippedResourceSurrogateOffsetIds s WHERE p.ResourceBatchOffset = s.ResourceSurrogateIdOffset)

		COMMIT TRANSACTION
	GO
