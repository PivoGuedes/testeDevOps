
Create Function [dbo].[RemoveEspacosFormatacao] 
(@MyString as varchar(Max))
Returns varchar(Max)
As
Begin
    --NULL
    Set @MyString = Replace(@MyString,CHAR(0),'');
    --Horizontal Tab
    Set @MyString = Replace(@MyString,CHAR(9),'');
    --Line Feed
    Set @MyString = Replace(@MyString,CHAR(10),'');
    --Vertical Tab
    Set @MyString = Replace(@MyString,CHAR(11),'');
    --Form Feed
    Set @MyString = Replace(@MyString,CHAR(12),'');
    --Carriage Return
    Set @MyString = Replace(@MyString,CHAR(13),'');
    --Column Break
    Set @MyString = Replace(@MyString,CHAR(14),'');
    --Non-breaking space
    Set @MyString = Replace(@MyString,CHAR(160),'');

    Set @MyString = LTRIM(RTRIM(@MyString));
    Return @MyString
End

