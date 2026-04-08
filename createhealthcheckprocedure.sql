IF OBJECT_ID('dbo.RunHealthCheck', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RunHealthCheck;
GO

CREATE PROCEDURE dbo.RunHealthCheck
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------
    -- 1. Blocking Sessions
    ---------------------------------------------------
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        BlockingSessionID,
        WaitType,
        WaitTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'Blocking',
        r.session_id,
        r.blocking_session_id,
        r.wait_type,
        r.wait_time,
        DB_NAME(r.database_id),
        'Blocked session detected'
    FROM sys.dm_exec_requests r
    WHERE r.blocking_session_id <> 0;

    ---------------------------------------------------
    -- 2. Long-Running Queries
    ---------------------------------------------------
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        WaitType,
        TotalElapsedTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'LongRunningQuery',
        r.session_id,
        r.wait_type,
        r.total_elapsed_time,
        DB_NAME(r.database_id),
        'Query running longer than threshold'
    FROM sys.dm_exec_requests r
    WHERE r.total_elapsed_time > 10000; -- 10 seconds

    ---------------------------------------------------
    -- 3. High CPU Requests
    ---------------------------------------------------
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        CPUTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'HighCPU',
        r.session_id,
        r.cpu_time,
        DB_NAME(r.database_id),
        'High CPU request detected'
    FROM sys.dm_exec_requests r
    WHERE r.cpu_time > 5000; -- threshold

    ---------------------------------------------------
    -- 4. Failed SQL Agent Jobs
    ---------------------------------------------------
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        JobName,
        Details
    )
    SELECT
        'JobFailure',
        j.name,
        h.message
    FROM msdb.dbo.sysjobhistory h
    INNER JOIN msdb.dbo.sysjobs j
        ON h.job_id = j.job_id
    WHERE h.run_status = 0
      AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(MINUTE, -15, GETDATE());
END;
GO
