-- ============================================================
-- DATABASE CONFIGURATION SCRIPT
-- Run as SYSTEM or SYS (requires SYSDBA privileges)
-- ============================================================

-- 1. MEMORY CONFIGURATION
-- Set SGA (System Global Area) - memory for Oracle instance
ALTER SYSTEM SET SGA_TARGET = 800M SCOPE=SPFILE;
ALTER SYSTEM SET SGA_MAX_SIZE = 800M SCOPE=SPFILE;

-- Set PGA (Program Global Area) - memory for user processes
ALTER SYSTEM SET PGA_AGGREGATE_TARGET = 200M SCOPE=SPFILE;

-- 2. PROCESSES AND SESSIONS
-- Increase maximum processes (allows more concurrent connections)
ALTER SYSTEM SET PROCESSES = 300 SCOPE=SPFILE;

-- Increase sessions (should be > processes)
ALTER SYSTEM SET SESSIONS = 330 SCOPE=SPFILE;

-- 3. REDO LOG CONFIGURATION
-- Create redo log groups (minimum 3 groups recommended)
ALTER DATABASE ADD LOGFILE GROUP 4 
('redo04a.log', 'redo04b.log') SIZE 50M;

ALTER DATABASE ADD LOGFILE GROUP 5 
('redo05a.log', 'redo05b.log') SIZE 50M;

ALTER DATABASE ADD LOGFILE GROUP 6 
('redo06a.log', 'redo06b.log') SIZE 50M;

-- 4. ARCHIVING CONFIGURATION
-- Enable archive logging mode (for backup/recovery)
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

-- Set archive log destination
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=/u01/app/oracle/archive/mberaMuganga' SCOPE=SPFILE;
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT = 'mbera_%t_%s_%r.arc' SCOPE=SPFILE;

-- 5. TABLESPACE CONFIGURATION
-- Check tablespace status
SELECT tablespace_name, status, contents FROM dba_tablespaces;

-- Add datafiles to tablespaces (if needed)
ALTER TABLESPACE MBERA_DATA 
ADD DATAFILE 'mbera_data02.dbf' SIZE 100M AUTOEXTEND ON;

ALTER TABLESPACE MBERA_IDX 
ADD DATAFILE 'mbera_idx02.dbf' SIZE 50M AUTOEXTEND ON;

-- 6. SECURITY CONFIGURATION
-- Set password policies
ALTER PROFILE DEFAULT LIMIT
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LIFE_TIME 90
PASSWORD_REUSE_TIME 365
PASSWORD_REUSE_MAX 10
PASSWORD_LOCK_TIME 1
PASSWORD_GRACE_TIME 7;

-- 7. PERFORMANCE CONFIGURATION
-- Set optimizer settings
ALTER SYSTEM SET OPTIMIZER_MODE = ALL_ROWS SCOPE=BOTH;
ALTER SYSTEM SET QUERY_REWRITE_ENABLED = TRUE SCOPE=BOTH;

-- Enable automatic statistics collection
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('TUE_29143_BENON_MBERAMUGANGA_ADMIN');

-- 8. NETWORK CONFIGURATION (tnsnames.ora - add entry)
/*
MBERAMUGANGA_DB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCL)  -- Change to your service name
    )
  )
*/

-- 9. DATABASE PARAMETERS FOR APPLICATION
-- Set cursor sharing (improves SQL parsing)
ALTER SYSTEM SET CURSOR_SHARING = SIMILAR SCOPE=SPFILE;

-- Set sort area size
ALTER SYSTEM SET SORT_AREA_SIZE = 1048576 SCOPE=SPFILE;

-- Set database block size (requires restart)
-- ALTER SYSTEM SET DB_BLOCK_SIZE = 8192 SCOPE=SPFILE; -- Typically 8K

-- 10. BACKUP CONFIGURATION
-- Configure RMAN backup settings (run in RMAN)
/*
RUN {
  CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
  CONFIGURE BACKUP OPTIMIZATION ON;
  CONFIGURE DEFAULT DEVICE TYPE TO DISK;
  CONFIGURE CONTROLFILE AUTOBACKUP ON;
  CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/backup/%F';
}
*/

-- 11. USER QUOTA CONFIGURATION
-- Grant additional quotas to admin user
ALTER USER tue_29143_benon_mberaMuganga_admin 
QUOTA 500M ON MBERA_DATA;

ALTER USER tue_29143_benon_mberaMuganga_admin 
QUOTA 200M ON MBERA_IDX;

-- 12. ENABLE AUDITING (Optional - for security)
-- Enable standard auditing
AUDIT CREATE TABLE BY tue_29143_benon_mberaMuganga_admin;
AUDIT ALTER TABLE BY tue_29143_benon_mberaMuganga_admin;
AUDIT DROP TABLE BY tue_29143_benon_mberaMuganga_admin;
AUDIT INSERT ON tue_29143_benon_mberaMuganga_admin.Patients;
AUDIT UPDATE ON tue_29143_benon_mberaMuganga_admin.Patients;
AUDIT DELETE ON tue_29143_benon_mberaMuganga_admin.Patients;

-- 13. CREATE PROFILE FOR APPLICATION USERS
CREATE PROFILE mbera_app_user LIMIT
SESSIONS_PER_USER 5
CPU_PER_SESSION UNLIMITED
CPU_PER_CALL 3000
CONNECT_TIME 480
IDLE_TIME 30
LOGICAL_READS_PER_SESSION DEFAULT
LOGICAL_READS_PER_CALL 1000
PRIVATE_SGA 15K
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 60
PASSWORD_REUSE_TIME 180
PASSWORD_REUSE_MAX 5
PASSWORD_LOCK_TIME 1/24
PASSWORD_GRACE_TIME 5;

-- 14. CREATE APPLICATION USER (for app connections)
CREATE USER mbera_app_user IDENTIFIED BY app_password123
DEFAULT TABLESPACE MBERA_DATA
TEMPORARY TABLESPACE MBERA_TEMP
PROFILE mbera_app_user
QUOTA 100M ON MBERA_DATA;

GRANT CONNECT, CREATE SESSION TO mbera_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tue_29143_benon_mberaMuganga_admin.Patients TO mbera_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tue_29143_benon_mberaMuganga_admin.Doctors TO mbera_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tue_29143_benon_mberaMuganga_admin.Appointments TO mbera_app_user;
GRANT SELECT, INSERT, UPDATE ON tue_29143_benon_mberaMuganga_admin.Daily_Reports TO mbera_app_user;
GRANT SELECT ON tue_29143_benon_mberaMuganga_admin.Medications TO mbera_app_user;
GRANT SELECT ON tue_29143_benon_mberaMuganga_admin.Patient_Medications TO mbera_app_user;

-- 15. CREATE SYNONYMS FOR APPLICATION USER
CREATE OR REPLACE SYNONYM mbera_app_user.Patients FOR tue_29143_benon_mberaMuganga_admin.Patients;
CREATE OR REPLACE SYNONYM mbera_app_user.Doctors FOR tue_29143_benon_mberaMuganga_admin.Doctors;
CREATE OR REPLACE SYNONYM mbera_app_user.Appointments FOR tue_29143_benon_mberaMuganga_admin.Appointments;
CREATE OR REPLACE SYNONYM mbera_app_user.Daily_Reports FOR tue_29143_benon_mberaMuganga_admin.Daily_Reports;
CREATE OR REPLACE SYNONYM mbera_app_user.Medications FOR tue_29143_benon_mberaMuganga_admin.Medications;
CREATE OR REPLACE SYNONYM mbera_app_user.Patient_Medications FOR tue_29143_benon_mberaMuganga_admin.Patient_Medications;

-- 16. DATABASE LINKS (if connecting to other databases)
-- CREATE DATABASE LINK remote_db
-- CONNECT TO remote_user IDENTIFIED BY password
-- USING 'remote_tns';

-- 17. MATERIALIZED VIEWS (for reporting)
-- CREATE MATERIALIZED VIEW mv_daily_appointments
-- REFRESH COMPLETE START WITH SYSDATE NEXT SYSDATE + 1
-- AS SELECT * FROM vw_patient_appointments;

-- 18. SYSTEM STATISTICS
-- Collect system statistics for better query optimization
EXEC DBMS_STATS.GATHER_SYSTEM_STATS('INTERVAL', 60);

-- 19. CHECK DATABASE STATUS
SELECT name, open_mode, database_role FROM v$database;
SELECT tablespace_name, file_name, bytes/1024/1024 AS MB FROM dba_data_files;
SELECT username, account_status, default_tablespace FROM dba_users 
WHERE username LIKE '%MBERA%' OR username = 'MBERA_APP_USER';

-- 20. RESTART DATABASE TO APPLY SPFILE CHANGES
SHUTDOWN IMMEDIATE;
STARTUP;

COMMIT;
