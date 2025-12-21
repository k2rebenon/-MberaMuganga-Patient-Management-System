# MBERA MUGANGA HEALTH CARE SYSTEM (The Doctor’s Helper)

**PL/SQL Oracle Database Capstone Project**  
**Course:** INSY 8311 – Database Development with PL/SQL  
**Student:** Katurebe Benon  
**Student ID:** 29143  
**Group:** Monday  
**Institution:** Adventist University of Central Africa (AUCA)  
**Academic Year:** 2025-2026 | Semester I  
**Completion Date:** December 21, 2025  

## Project Overview (2-3 Sentences)
MBERA MUGANGA is a real-time PL/SQL-powered early warning system for Non-Communicable Diseases (Diabetes and Hypertension) in Rwanda. The system automates daily vital sign monitoring, instantly stratifies risk using clinical thresholds inside Oracle, generates alerts for high-risk cases, and provides weekly trend reports to doctors. It transforms reactive healthcare into proactive prevention while delivering powerful Business Intelligence for national NCD surveillance.

## Problem Statement
Patients with Diabetes and Hypertension record daily blood pressure and glucose readings but only share them during monthly appointments. Rapid deterioration between visits often goes undetected, leading to preventable complications or emergencies. MBERA MUGANGA solves this by automatically analysing every new reading in the database and alerting doctors immediately when a patient enters a high-risk zone.

## Key Objectives
- Detect life-threatening changes within hours instead of weeks  
- Automate clinical decision support entirely in PL/SQL (packages, triggers, window functions)  
- Enforce strict DML restrictions (no changes on weekdays or public holidays) with full auditing  
- Provide BI dashboards and KPIs for doctors, clinics, and Ministry of Health  
- Achieve production-ready quality: normalized schema, configured PDB, realistic test data

## Phase Completion Summary

| Phase | Description                                      | Status   | Key Files / Folders                          |
|-------|--------------------------------------------------|----------|----------------------------------------------|
| I     | Problem Identification                           | Completed | `phase1_problem_identification/mon_29143_Benon_MberaMuganga_DB.pptx` |
| II    | Business Process Modeling (BPMN)                 | Completed | `phase2_business_process/BPMN_MberaMuganga_Process.png` + explanation.md |
| III   | Logical Model Design (ER + Data Dictionary)      | Completed | `phase3_logical_design/` (ER diagram, data_dictionary.md, normalization.md) |
| IV    | Database Creation (PDB + Configuration)          | Completed | `phase4_database_creation/create_pdb_and_user.sql` + screenshots/oem_monitoring/ |
| V     | Table Implementation & Data Insertion            | Completed | `database/scripts/create_tables.sql`, `insert_data.sql` (300+ rows) + validation queries |
| VI    | PL/SQL Development (Procs, Fns, Packages, Cursors, Window Functions) | Completed | `database/scripts/plsql_package.sql`, procedures, functions, cursors with BULK & analytic functions |
| VII   | Advanced Programming (Triggers, Auditing, DML Restrictions) | Completed | `phase7_advanced_programming/` (holidays, audit table, restriction functions, compound trigger) |
| VIII  | Final Documentation, BI & Presentation           | Completed | Full repo structure, BI folder, 10-slide PPT, all screenshots including test_results/ |

## Quick Start Instructions
1. Clone the repository:  
[   `git clone https://github.com/[your-username]/mbera_muganga_plsql_capstone`](https://github.com/k2rebenon/-MberaMuganga-Patient-Management-System.git)
2. Connect as SYS/SYSTEM and run `database/scripts/create_pdb_and_user.sql` to create PDB `mon_29143_Benon_MberaMuganga_DB`
3. Connect as user `benon/benon` and execute all scripts in `database/scripts/` in this order:
   - create_tables.sql
   - insert_data.sql
   - plsql_*.sql (functions, package, procedures)
   - holidays_setup.sql
   - triggers.sql
4. Test features using scripts in `queries/` and `phase7_advanced_programming/test_restriction.sql`
5. View BI analytics: Run queries in `business_intelligence/analytical_queries.sql`

## Key Features & Innovation
- **Real-time Risk Engine:** PKG_RISK_ENGINE package with clinical threshold functions  
- **Automation:** AFTER INSERT trigger instantly calls risk assessment procedure  
- **Security Rule:** Compound trigger blocks DML on weekdays & public holidays (audit logged)  
- **Advanced Analytics:** Window functions (LAG/LEAD, ROW_NUMBER, rolling averages), weekly/monthly aggregations  
- **BI Bonus:** Executive, Audit, Performance & NCD Analytics dashboards (mockups + queries)

## Links to Documentation & Evidence
- [Data Dictionary

- [ER Diagram]
- [Test Results & Screenshots]  
- [BI Requirements & Dashboards]
- [Final Presentation](

All code is original, thoroughly tested, and production-ready. Screenshots prove execution (procedures <1s, triggers block/allow correctly, BI queries return meaningful results).

**"Whatever you do, work at it with all your heart..." – Colossians 3:23**  
Thank you, Dr. Eric Maniraguha, for an excellent course.

---
**Repository last updated:** December 21, 2025  
**Final Capstone Submission – Ready for Review**
