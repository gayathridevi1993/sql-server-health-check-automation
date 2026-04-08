
# SQL Server Health Check Automation

## Overview

This project automates health checks in SQL Server by detecting common production issues and storing them in a central log table.

## What It Detects

- Blocking sessions  
- Long-running queries  
- High CPU usage  
- Failed SQL Agent jobs  

## How It Works

- Uses SQL Server DMVs  
- Stores results in a log table  
- Runs via SQL Server Agent  
- Provides reporting queries  

## How to Use

1. Run table script  
2. Create stored procedure  
3. Execute:

```sql
EXEC dbo.RunHealthCheck;
