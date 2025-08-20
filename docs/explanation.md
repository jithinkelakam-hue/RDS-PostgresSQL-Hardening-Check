# 📘 Explanation of RDS PostgreSQL Hardening Checks

This document provides detailed explanations for each control included in the `hardening_check.sql` script. These checks are designed to assess the security posture of an Amazon RDS PostgreSQL instance by validating key configuration parameters and access controls.

---

## 🔍 Logging Settings

| Control Name | Purpose |
|--------------|---------|
| Log File Lifetime Check | Ensures logs are rotated daily to prevent excessive disk usage. |
| Log Rotation Size Check | Prevents log files from growing too large before rotation. |
| Client Min Messages | Controls verbosity of messages sent to clients. |
| Log Min Messages | Controls verbosity of messages written to server logs. |
| Log Min Error Statement | Ensures SQL statements causing errors are logged. |
| Log Min Duration Statement | Should be disabled unless performance auditing is needed. |
| Debug Print Options | Should be disabled to avoid exposing internal execution details. |
| Debug Pretty Print | Helps format debug output for readability. |

---

## 🔐 Security & Connection Logging

| Control Name | Purpose |
|--------------|---------|
| Log Checkpoints | Tracks checkpoint activity for performance and recovery. |
| Log Connections / Disconnections | Audits user access and session lifecycle. |
| Log Duration | Measures query execution time. |
| Log Error Verbosity | Controls detail level of error messages. |
| Log Hostname | Logs client hostnames for traceability. |
| Log Lock Waits | Detects contention issues. |
| Log Statement | Determines which SQL statements are logged. |
| Log Temp Files | Helps identify excessive use of temporary files. |

---

## 🧪 Missing Log Checks

These are often overlooked but critical for performance and security auditing.

| Control Name | Purpose |
|--------------|---------|
| Log Parser / Planner / Executor / Statement Stats | Should be disabled unless actively debugging performance. |

---

## 🛡️ Excessive Privileges

| Control Name | Purpose |
|--------------|---------|
| Function Privileges | Ensures functions aren’t exposed to unauthorized roles. |
| DML Privileges | Prevents unauthorized data manipulation. |

---

## 🧬 Row-Level Security

| Control Name | Purpose |
|--------------|---------|
| Row-Level Security Configured | Ensures fine-grained access control at the row level. |

---

## 🔑 Authentication Method Checks

| Control Name | Purpose |
|--------------|---------|
| UNIX Domain Socket Login | Validates local login configuration. |
| TCP/IP Socket Login | Ensures remote login is properly configured. |

---

## 🔁 Security & Replication Settings

| Control Name | Purpose |
|--------------|---------|
| SSL Certificate | Validates secure communication. |
| WAL Archiving | Ensures write-ahead logs are archived for recovery. |
| Archive Mode | Enables WAL archiving. |
| Streaming Replication | Ensures replication is configured for high availability. |

---

## 🔐 Cryptographic Settings

| Control Name | Purpose |
|--------------|---------|
| SSL Enabled | Ensures encrypted connections. |
| FIPS 140-2 Compliance | Validates use of approved cryptographic standards. |

---

## 📌 Notes

- **PASSED** means the setting meets the expected secure configuration.
- **FAILED** means further investigation or remediation is required.
- This script does not change any settings—it only reports.

---

## 🧠 Recommendation

Use this script as part of your regular security audits. Combine it with manual reviews and cloud-native tools like AWS Config or Security Hub for a comprehensive posture assessment.
