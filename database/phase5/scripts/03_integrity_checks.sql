
-- DATA INTEGRITY VERIFICATION

-- 1. Verify row counts (meets 100-500+ requirement)
SELECT 'Patient' AS Table_Name, COUNT(*) AS Row_Count FROM Patient
UNION ALL
SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL
SELECT 'Daily_Report', COUNT(*) FROM Daily_Report
UNION ALL
SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL
SELECT 'Medication', COUNT(*) FROM Medication
UNION ALL
SELECT 'Notification', COUNT(*) FROM Notification
ORDER BY Table_Name;

-- 2. Verify foreign key relationships
DECLARE
    v_count NUMBER;
BEGIN
    -- Check Daily_Report foreign keys
    SELECT COUNT(*) INTO v_count
    FROM Daily_Report dr
    WHERE NOT EXISTS (SELECT 1 FROM Patient p WHERE p.patient_id = dr.patient_id);
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓ All Daily_Report records have valid Patient_ID');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ ' || v_count || ' Daily_Report records have invalid Patient_ID');
    END IF;
    
    -- Check Appointment foreign keys
    SELECT COUNT(*) INTO v_count
    FROM Appointment a
    WHERE NOT EXISTS (SELECT 1 FROM Patient p WHERE p.patient_id = a.patient_id)
       OR NOT EXISTS (SELECT 1 FROM Doctor d WHERE d.doctor_id = a.doctor_id);
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓ All Appointment records have valid Patient_ID and Doctor_ID');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ ' || v_count || ' Appointment records have invalid foreign keys');
    END IF;
    
    -- Check Medication foreign keys
    SELECT COUNT(*) INTO v_count
    FROM Medication m
    WHERE NOT EXISTS (SELECT 1 FROM Patient p WHERE p.patient_id = m.patient_id)
       OR NOT EXISTS (SELECT 1 FROM Doctor d WHERE d.doctor_id = m.doctor_id);
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓ All Medication records have valid Patient_ID and Doctor_ID');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ ' || v_count || ' Medication records have invalid foreign keys');
    END IF;
END;
/

-- 3. Check constraint violations
SELECT 'Check Constraint: No violations found' AS Validation_Result
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM Patient WHERE gender NOT IN ('M', 'F')
    UNION ALL
    SELECT 1 FROM Patient WHERE blood_group NOT IN ('A+','A-','B+','B-','AB+','AB-','O+','O-') AND blood_group IS NOT NULL
    UNION ALL
    SELECT 1 FROM Doctor WHERE is_available NOT IN ('Y', 'N')
    UNION ALL
    SELECT 1 FROM Daily_Report WHERE review_status NOT IN ('PENDING','REVIEWED','APPROVED')
    UNION ALL
    SELECT 1 FROM Appointment WHERE status NOT IN ('SCHEDULED','COMPLETED','CANCELLED','NO-SHOW')
    UNION ALL
    SELECT 1 FROM Notification WHERE notification_type NOT IN ('Appointment Reminder','Medication Reminder','General Alert')
);

-- 4. Check data completeness (NOT NULL columns)
SELECT 'Data Completeness: All required columns populated' AS Validation_Result
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM Patient WHERE first_name IS NULL OR last_name IS NULL OR phone IS NULL
    UNION ALL
    SELECT 1 FROM Doctor WHERE first_name IS NULL OR last_name IS NULL OR phone IS NULL OR license_number IS NULL
    UNION ALL
    SELECT 1 FROM Daily_Report WHERE symptoms IS NULL
    UNION ALL
    SELECT 1 FROM Appointment WHERE appointment_date IS NULL OR appointment_time IS NULL
    UNION ALL
    SELECT 1 FROM Medication WHERE medication_name IS NULL OR dosage IS NULL
    UNION ALL
    SELECT 1 FROM Notification WHERE message IS NULL
);


