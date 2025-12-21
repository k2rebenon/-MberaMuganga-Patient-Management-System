-- STEP 1: Check Prerequisites

-- Verify you are connected as SYSDBA
SHOW USER;
-- Expected: USER is "SYS"

-- Check Oracle version
SELECT banner FROM v$version WHERE banner LIKE 'Oracle%';

-- Check container database name
SELECT name, cdb FROM v$database;

-- Check existing PDBs (to avoid duplicates)
SELECT pdb_name, status, open_mode FROM cdb_pdbs;

-- STEP 2: Drop Existing PDB (if it exists)

ALTER PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE tue_29143_benon_mberamuganga_db INCLUDING DATAFILES;


-- STEP 3: Create Pluggable Database


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



