/*
참고 블로그 : https://bigenergy.tistory.com/entry/MSSQL-Trigger-%ED%8A%B8%EB%A6%AC%EA%B1%B0-%EC%82%AC%EC%9A%A9%EB%B0%A9%EB%B2%95%EC%9D%84-%EC%95%8C%EC%95%84%EB%B3%B4%EC%9E%90
*/

CREATE TRIGGER TRIGGER_NAME
	ON TRIGGER_TABLE
	AFTER INSERT, DELETE, UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
        @ACTION CHAR(1)

    SET @ACTION = 'I'

    IF EXISTS(SELECT * FROM DELETED)
    BEGIN
        SET @ACTION = (CASE WHEN EXISTS(SELECT * FROM INSERTED) THEN 'U' ELSE 'D' END)
    END

    DECLARE
        @VAR1   VARCHAR(10),
        @VAR2   VARCHAR(10),
        @VAR3   VARCHAR(10),
        @VAR4   VARCHAR(10),
        @VAR5   VARCHAR(10)

    IF @ACTION = 'D'
    BEGIN
        SELECT
            @VAR1 = VAR1,
            @VAR2 = VAR2,
            @VAR3 = VAR3,
            @VAR4 = VAR4,
            @VAR5 = VAR5
        FROM DELETED
    END
    ELSE
    BEGIN
        SELECT
            @VAR1 = VAR1,
            @VAR2 = VAR2,
            @VAR3 = VAR3,
            @VAR4 = VAR4,
            @VAR5 = VAR5
        FROM INSERTED
    END

    INSERT INTO LOG_TABLE (VAR1,VAR2,VAR3,VAR4,VAR5,TRI_TYPE,TRI_DTS)
        VALUES (@VAR1,@VAR2,@VAR3,@VAR4,@VAR5,@ACTION,GETDATE())

END
GO
