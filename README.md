# RDS-PostgresSQL-Hardening-Check
This repository contains a SQL script that performs automated security checks on an Amazon RDS PostgreSQL instance. It evaluates logging, authentication, replication, and privilege configurations, and reports non-compliant items for further review.

## 📌 Features
- One-click SQL execution
- Temporary table with pass/fail results
- Summary of passed/failed checks
- Detailed list of failed controls

## 🚀 Usage
1. Connect to your RDS PostgreSQL instance.
2. Open the SQL console.
3. Copy and paste the contents of `hardening_check.sql`.
4. Review the summary and failed checks.

## 📂 Output
- `total_passed`: Number of controls that passed
- `total_failed`: Number of controls that failed
- List of failed controls with descriptions

## 📜 License
This project is licensed under the MIT License.
