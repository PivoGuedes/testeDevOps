
CREATE FUNCTION [dbo].[fn_GetPartitionRangeValueForPartitionFunctionAndNumber]
(
	@PFName sysname,
	@PartitionNumber INT
)
RETURNS SQL_VARIANT
AS
BEGIN
	/***************************************************************************
	Procedure	: dbo.fn_GetPartitionRangeValueForPartitionFunctionAndNumber
	Created By	: Saru Radhakrishnan

	Purpose		: To get the partition value for a given partition number and 
				  given partition function
	
	Modification History:
	Date		Name				Comment
	----------------------------------------------------------------------------
	07/07/2011	Saru Radhakrishnan	Initial version. 
	****************************************************************************/
	
	DECLARE @Value SQL_VARIANT

	IF @PartitionNumber > 0
	BEGIN
		SELECT @Value = prv.value
		  FROM sys.partition_range_values prv
		  JOIN sys.partition_functions pf
			ON pf.function_id = prv.function_id
		 WHERE pf.name = @PFName
		   AND prv.boundary_id = @PartitionNumber
	END

	RETURN @Value
END



