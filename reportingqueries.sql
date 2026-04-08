-- Recent issues
SELECT TOP 50
    LogID,
    CaptureTime,
    IssueType,
    SessionID,
    BlockingSessionID,
    JobName,
    WaitType,
    WaitTimeMs,
    CPUTimeMs,
    TotalElapsedTimeMs,
    DatabaseName,
    Details
FROM dbo.HealthCheckLog
ORDER BY CaptureTime DESC;
GO

-- Issue counts by type
SELECT
    IssueType,
    COUNT(*) AS IssueCount
FROM dbo.HealthCheckLog
GROUP BY IssueType
ORDER BY IssueCount DESC;
GO

-- Blocking summary
SELECT
    BlockingSessionID,
    COUNT(*) AS BlockedCount,
    MAX(WaitTimeMs) AS MaxWaitTimeMs
FROM dbo.HealthCheckLog
WHERE IssueType = 'Blocking'
GROUP BY BlockingSessionID
ORDER BY MaxWaitTimeMs DESC;
GO

-- Failed jobs summary
SELECT
    JobName,
    COUNT(*) AS FailureCount
FROM dbo.HealthCheckLog
WHERE IssueType = 'JobFailure'
GROUP BY JobName
ORDER BY FailureCount DESC;
GO
