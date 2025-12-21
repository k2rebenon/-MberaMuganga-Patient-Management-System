

-- ============================================
-- STEP 1: Check Prerequisites
-- ============================================

-- Verify you are connected as SYSDBA
SHOW USER;
-- Expected: USER is "SYS"

-- Check Oracle version
SELECT banner FROM v$version WHERE banner LIKE 'Oracle%';

-- Check container database name
SELECT name, cdb FROM v$database;

-- Check existing PDBs (to avoid duplicates)
SELECT pdb_name, status, open_mode FROM cdb_pdbs;

-- ============================================
-- STEP 2: Drop Existing PDB (if it exists)
-- ============================================

-- If the PDB already exists and has errors, close and drop it
-- IMPORTANT: Uncomment these lines ONLY if you need to recreate

/*
ALTER PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db INCLUDING DATAFILES;
*/

-- ============================================
-- STEP 3: Create Pluggable Database
-- ============================================

CREATE PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db
  ADMIN USER benon_admin IDENTIFIED BY benon
  FILE_NAME_CONVERT = (
    'C:\APP\K2REBENON\PRODUCT\21C\ORADATA\XE\PDBSEED\',
    'C:\APP\K2REBENON\PRODUCT\21C\ORADATA\XE\TUE_29143_BENON_MBERAMUGANGA_DB\'
  )
  STORAGE (
    MAXSIZE UNLIMITED
    MAX_SHARED_TEMP_SIZE UNLIMITED
  );

-- Expected output: Pluggable database created.

-- ============================================
-- STEP 4: Open the PDB
-- ============================================

-- IMPORTANT: Open BEFORE creating tablespaces
ALTER PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db OPEN;

-- Expected output: Pluggable database altered.

-- Save state so it opens automatically on restart
ALTER PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db SAVE STATE;

-- Verify PDB is open
SELECT pdb_name, status, open_mode, restricted
FROM cdb_pdbs
WHERE pdb_name = 'TUE_29143_BENON_MBERAMUGANGA_DB';

-- Expected output:
-- PDB_NAME                              STATUS    OPEN_MODE    RESTRICTED
-- TUE_29143_BENON_MBERAMUGANGA_DB       NORMAL    READ WRITE   NO

-- ============================================
-- STEP 5: Switch to the PDB
-- ============================================

-- Set session to work within the PDB
ALTER SESSION SET CONTAINER = tue_29143_benon_mberamuganga_db;

-- Verify current container
SHOW CON_NAME;
-- Expected: CON_NAME = TUE_29143_BENON_MBERAMUGANGA_DB

-- ============================================
-- STEP 6: Grant Privileges to Admin User
-- ============================================

-- Grant DBA role (super admin privileges)
GRANT DBA TO benon_admin;

-- Grant unlimited tablespace
GRANT UNLIMITED TABLESPACE TO benon_admin;

-- Grant additional system privileges
GRANT CREATE SESSION TO benon_admin;
GRANT CREATE TABLE TO benon_admin;
GRANT CREATE VIEW TO benon_admin;
GRANT CREATE SEQUENCE TO benon_admin;
GRANT CREATE PROCEDURE TO benon_admin;
GRANT CREATE TRIGGER TO benon_admin;
GRANT CREATE TYPE TO benon_admin;
GRANT CREATE SYNONYM TO benon_admin;
GRANT CREATE TABLESPACE TO benon_admin;
GRANT ALTER TABLESPACE TO benon_admin;
GRANT DROP TABLESPACE TO benon_admin;

-- Verify privileges
SELECT * FROM dba_sys_privs WHERE grantee = 'BENON_ADMIN' ORDER BY privilege;
SELECT * FROM dba_role_privs WHERE grantee = 'BENON_ADMIN';

-- ============================================
-- STEP 7: Connect as benon_admin
-- ============================================

-- From this point, commands should be executed as benon_admin
-- In SQL*Plus:
--   CONNECT benon_admin/benon@localhost:1521/tue_29143_benon_mberamuganga_db
-- In SQL Developer:
--   Create new connection with username: benon_admin, password: benon

CONNECT benon_admin/benon@localhost:1521/tue_29143_benon_mberamuganga_db;

-- Verify connection
SHOW USER;
-- Expected: USER is "BENON_ADMIN"

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS current_pdb FROM dual;
-- Expected: TUE_29143_BENON_MBERAMUGANGA_DB

-- ============================================
-- STEP 8: Create Data Tablespace
-- ============================================

CREATE TABLESPACE mbera_data
  DATAFILE 'C:\APP\K2REBENON\PRODUCT\21C\ORADATA\XE\TUE_29143_BENON_MBERAMUGANGA_DB\mbera_data01.dbf'
  SIZE 100M
  AUTOEXTEND ON NEXT 10M
  MAXSIZE 2G
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

-- Expected output: Tablespace created.

-- ============================================
-- STEP 9: Create Index Tablespace
-- ============================================

CREATE TABLESPACE mbera_idx
  DATAFILE 'C:\APP\K2REBENON\PRODUCT\21C\ORADATA\XE\TUE_29143_BENON_MBERAMUGANGA_DB\mbera_idx01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 1G
  EXTENT MANAGEMENT LOCAL
  SEGMENT SPACE MANAGEMENT AUTO;

-- Expected output: Tablespace created.

-- ============================================
-- STEP 10: Create Temporary Tablespace
-- ============================================

CREATE TEMPORARY TABLESPACE mbera_temp
  TEMPFILE 'C:\APP\K2REBENON\PRODUCT\21C\ORADATA\XE\TUE_29143_BENON_MBERAMUGANGA_DB\mbera_temp01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 500M;

-- Expected output: Tablespace created.

-- ============================================
-- STEP 11: Set Default Tablespaces for User
-- ============================================

-- Set default tablespace for benon_admin user
ALTER USER benon_admin
  DEFAULT TABLESPACE mbera_data
  TEMPORARY TABLESPACE mbera_temp
  QUOTA UNLIMITED ON mbera_data
  QUOTA UNLIMITED ON mbera_idx;

-- Verify user configuration
SELECT 
    username,
    default_tablespace,
    temporary_tablespace,
    account_status
FROM dba_users
WHERE username = 'BENON_ADMIN';

-- Expected output:
-- USERNAME      DEFAULT_TABLESPACE  TEMPORARY_TABLESPACE  ACCOUNT_STATUS
-- BENON_ADMIN   MBERA_DATA          MBERA_TEMP            OPEN

-- ============================================
-- STEP 12: Verify Tablespaces
-- ============================================

-- Check all tablespaces
SELECT 
    tablespace_name,
    status,
    contents,
    extent_management,
    ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
FROM dba_data_files
WHERE tablespace_name IN ('MBERA_DATA', 'MBERA_IDX')
GROUP BY tablespace_name, status, contents, extent_management
UNION ALL
SELECT 
    tablespace_name,
    status,
    contents,
    extent_management,
    ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
FROM dba_temp_files
WHERE tablespace_name = 'MBERA_TEMP'
GROUP BY tablespace_name, status, contents, extent_management;

-- Expected output:
-- TABLESPACE_NAME  STATUS    CONTENTS    EXTENT_MGMT  SIZE_MB
-- MBERA_DATA       ONLINE    PERMANENT   LOCAL        100.00
-- MBERA_IDX        ONLINE    PERMANENT   LOCAL        50.00
-- MBERA_TEMP       ONLINE    TEMPORARY   LOCAL        50.00

-- ============================================
-- STEP 13: Configure Database Parameters (OPTIONAL)
-- ============================================

-- Note: These require SYSDBA privileges and affect the entire CDB
-- Uncomment and run as SYSDBA if needed

/*
CONNECT / AS SYSDBA;
ALTER SESSION SET CONTAINER = tue_29143_benon_mberamuganga_db;

-- Set memory parameters (adjust based on available RAM)
ALTER SYSTEM SET sga_target = 512M SCOPE = SPFILE;
ALTER SYSTEM SET pga_aggregate_target = 256M SCOPE = SPFILE;

-- Restart required for memory changes
SHUTDOWN IMMEDIATE;
STARTUP;
*/

-- ============================================
-- STEP 14: Enable Auditing (OPTIONAL)
-- ============================================

-- Enable auditing for critical operations
AUDIT CREATE TABLE;
AUDIT DROP TABLE;
AUDIT ALTER TABLE;
AUDIT INSERT TABLE, UPDATE TABLE, DELETE TABLE BY ACCESS;

-- View audit settings
SELECT * FROM dba_stmt_audit_opts;

-- ============================================
-- STEP 15: Create Directories for Data Pump
-- ============================================

-- Create directory for exports/imports
CREATE OR REPLACE DIRECTORY mbera_export AS 'C:\mbera_exports';

-- Grant permissions
GRANT READ, WRITE ON DIRECTORY mbera_export TO benon_admin;

-- Verify directory
SELECT directory_name, directory_path FROM dba_directories
WHERE directory_name = 'MBERA_EXPORT';

-- ============================================
-- STEP 16: Final Verification
-- ============================================

-- Verify PDB status
SELECT 
    pdb_name,
    status,
    open_mode,
    restricted,
    total_size/1024/1024 AS size_mb
FROM v$pdbs
WHERE pdb_name = 'TUE_29143_BENON_MBERAMUGANGA_DB';

-- Verify user configuration
SELECT 
    username,
    account_status,
    default_tablespace,
    temporary_tablespace,
    created
FROM dba_users
WHERE username = 'BENON_ADMIN';

-- Check granted privileges
SELECT granted_role FROM dba_role_privs WHERE grantee = 'BENON_ADMIN';

-- Verify all tablespaces
SELECT 
    tablespace_name,
    status,
    ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
FROM dba_data_files
WHERE tablespace_name IN ('MBERA_DATA', 'MBERA_IDX')
GROUP BY tablespace_name, status
UNION ALL
SELECT 
    tablespace_name,
    status,
    ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
FROM dba_temp_files
WHERE tablespace_name = 'MBERA_TEMP'
GROUP BY tablespace_name, status;

-- ============================================
-- STEP 17: Display Summary
-- ============================================

SELECT 'Phase IV: Database Creation COMPLETE' AS status FROM dual;

SELECT 
    'Database: tue_29143_benon_mberamuganga_db' AS info1,
    'Admin User: benon_admin' AS info2,
    'Password: benon' AS info3,
    'Status: READY FOR PHASE V' AS info4
FROM dual;


/*


