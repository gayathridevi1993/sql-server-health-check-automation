# SQL Server Agent Job Steps

## Job Name
SQL Server Health Check Monitor

## Schedule
Run every 15 minutes

## Step
Execute:

```sql
EXEC dbo.RunHealthCheck;
