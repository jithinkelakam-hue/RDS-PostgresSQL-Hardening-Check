-- RDS PostgreSQL Hardening Checks
-- Author: Jithin N K
-- Version: 1.0

-- Drop temporary table if it exists
DROP TABLE IF EXISTS security_checks;

-- Create temporary table to store results
CREATE TEMP TABLE security_checks (
    control_name TEXT,
    result TEXT
);

-- Insert security check results including the missing log checks
INSERT INTO security_checks (control_name, result)
VALUES 
    -- Logging Settings Checks
    ('Log File Lifetime Check', CASE WHEN current_setting('log_rotation_age') = '1d' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Rotation Size Check', CASE WHEN current_setting('log_rotation_size') = '500000kB' THEN 'PASSED' ELSE 'FAILED' END),
    ('Correct Messages Sent to Client Check', CASE WHEN current_setting('client_min_messages') IN ('notice', 'warning', 'error', 'log') THEN 'PASSED' ELSE 'FAILED' END),
    ('Correct Messages Written to Server Log Check', CASE WHEN current_setting('log_min_messages') IN ('warning', 'error', 'panic', 'fatal', 'log') THEN 'PASSED' ELSE 'FAILED' END),
    ('Correct SQL Statements Generating Errors Recorded Check', CASE WHEN current_setting('log_min_error_statement') IN ('warning', 'error', 'panic', 'fatal') THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Min Duration Statement Disabled', CASE WHEN current_setting('log_min_duration_statement') = '-1' THEN 'PASSED' ELSE 'FAILED' END),
    ('Debug Print Parse Disabled', CASE WHEN current_setting('debug_print_parse') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Debug Print Rewritten Disabled', CASE WHEN current_setting('debug_print_rewritten') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Debug Print Plan Disabled', CASE WHEN current_setting('debug_print_plan') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Debug Pretty Print Enabled', CASE WHEN current_setting('debug_pretty_print') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    
    -- Security & Connection Logging
    ('Log Checkpoints Enabled', CASE WHEN current_setting('log_checkpoints') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Connections Enabled', CASE WHEN current_setting('log_connections') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Disconnections Enabled', CASE WHEN current_setting('log_disconnections') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Duration Enabled', CASE WHEN current_setting('log_duration') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Error Verbosity Check', CASE WHEN current_setting('log_error_verbosity') IN ('terse', 'default', 'verbose') THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Hostname Enabled', CASE WHEN current_setting('log_hostname') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Lock Waits Enabled', CASE WHEN current_setting('log_lock_waits') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Statement Check', CASE WHEN current_setting('log_statement') IN ('none', 'ddl', 'mod', 'all') THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Temporary Files Check', CASE WHEN current_setting('log_temp_files') != '-1' THEN 'PASSED' ELSE 'FAILED' END),
    
    -- **Missing Log Checks**
    ('Log Parser Stats Disabled', CASE WHEN current_setting('log_parser_stats') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Planner Stats Disabled', CASE WHEN current_setting('log_planner_stats') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Executor Stats Disabled', CASE WHEN current_setting('log_executor_stats') = 'off' THEN 'PASSED' ELSE 'FAILED' END),
    ('Log Statement Stats Disabled', CASE WHEN current_setting('log_statement_stats') = 'off' THEN 'PASSED' ELSE 'FAILED' END),

    -- Excessive Privileges Checks
    ('Excessive Function Privileges Revoked', CASE WHEN NOT EXISTS (SELECT * FROM pg_proc WHERE proacl IS NOT NULL) THEN 'PASSED' ELSE 'FAILED' END),
    ('Excessive DML Privileges Revoked', CASE WHEN NOT EXISTS (SELECT * FROM information_schema.role_table_grants WHERE privilege_type IN ('INSERT', 'UPDATE', 'DELETE')) THEN 'PASSED' ELSE 'FAILED' END),
    
    -- Row-Level Security Check
    ('Row-Level Security Configured', CASE WHEN EXISTS (SELECT * FROM pg_class WHERE relrowsecurity = true) THEN 'PASSED' ELSE 'FAILED' END),

    -- Authentication Method Checks
    ('Local UNIX Domain Socket Login Configured', CASE WHEN EXISTS (SELECT * FROM pg_hba_file_rules WHERE type = 'local') THEN 'PASSED' ELSE 'FAILED' END),
    ('Host TCP/IP Socket Login Configured', CASE WHEN EXISTS (SELECT * FROM pg_hba_file_rules WHERE type = 'host') THEN 'PASSED' ELSE 'FAILED' END),

    -- Security & Replication Settings
    ('SSL Certificate Configured', CASE WHEN current_setting('ssl_cert_file') IS NOT NULL THEN 'PASSED' ELSE 'FAILED' END),
    ('WAL Archiving Configured', CASE WHEN current_setting('wal_level') IN ('replica', 'logical') THEN 'PASSED' ELSE 'FAILED' END),
    ('Archive Mode Enabled', CASE WHEN current_setting('archive_mode') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('Streaming Replication Configured', CASE WHEN current_setting('max_wal_senders')::int >= 2 THEN 'PASSED' ELSE 'FAILED' END),

    -- Cryptographic Settings
    ('SSL Enabled', CASE WHEN current_setting('ssl') = 'on' THEN 'PASSED' ELSE 'FAILED' END),
    ('FIPS 140-2 Compliance Check', CASE WHEN current_setting('ssl_ciphers') LIKE '%FIPS%' THEN 'PASSED' ELSE 'FAILED' END);

-- Display total passed and failed counts
SELECT 
    COUNT(*) FILTER (WHERE result = 'PASSED') AS total_passed,
    COUNT(*) FILTER (WHERE result = 'FAILED') AS total_failed
FROM security_checks;

-- List failed items with control names
SELECT control_name, result FROM security_checks WHERE result = 'FAILED';