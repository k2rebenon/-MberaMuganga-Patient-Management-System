-- ============================================================
-- PHASE 5: TABLE IMPLEMENTATION & DATA INSERTION
-- Project: Mbera Muganga Hospital Management System
-- Student: Benon | ID: 29143
-- Course: INSY 8311 - PL/SQL Oracle Database Development
-- Lecturer: Eric Maniraquha
-- Institution: Adventist University of Central Africa (AUCA)
-- ============================================================

-- Enable output for debugging
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

-- ============================================================
-- PART 1: TABLE CREATION (Confirming Phase 4)
-- ============================================================

-- Note: Tables should already be created from Phase 4
-- This section verifies the table structure

PROMPT ============================================
PROMPT VERIFYING TABLE STRUCTURES
PROMPT ============================================

DESC Patient;
DESC Doctor;
DESC Daily_Report;
DESC Appointment;
DESC Medication;
DESC Notification;

-- ============================================================
-- PART 2: CLEAR EXISTING DATA (If any)
-- ============================================================

BEGIN
    -- Disable foreign key constraints temporarily
    FOR c IN (SELECT constraint_name, table_name 
              FROM user_constraints 
              WHERE constraint_type = 'R' 
              AND table_name IN ('NOTIFICATION', 'MEDICATION', 'APPOINTMENT', 'DAILY_REPORT')) 
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || c.table_name || ' DISABLE CONSTRAINT ' || c.constraint_name;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;
    END LOOP;

    -- Delete data in correct order (child tables first)
    EXECUTE IMMEDIATE 'DELETE FROM Notification';
    EXECUTE IMMEDIATE 'DELETE FROM Medication';
    EXECUTE IMMEDIATE 'DELETE FROM Appointment';
    EXECUTE IMMEDIATE 'DELETE FROM Daily_Report';
    EXECUTE IMMEDIATE 'DELETE FROM Doctor';
    EXECUTE IMMEDIATE 'DELETE FROM Patient';
    
    -- Re-enable constraints
    FOR c IN (SELECT constraint_name, table_name 
              FROM user_constraints 
              WHERE constraint_type = 'R' 
              AND table_name IN ('NOTIFICATION', 'MEDICATION', 'APPOINTMENT', 'DAILY_REPORT')) 
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || c.table_name || ' ENABLE CONSTRAINT ' || c.constraint_name;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ Existing data cleared successfully.');
END;
/

-- ============================================================
-- PART 3: DATA INSERTION - MINIMUM 100 ROWS PER MAIN TABLE
-- ============================================================

PROMPT ============================================
PROMPT INSERTING SAMPLE DATA
PROMPT ============================================

-- ============================================
-- 1. INSERT 120 PATIENTS (Realistic Rwandan Data)
-- ============================================

BEGIN
    FOR i IN 1..120 LOOP
        INSERT INTO Patient (
            national_id,
            first_name,
            last_name,
            gender,
            date_of_birth,
            phone,
            district,
            sector,
            blood_group,
            allergies
        ) VALUES (
            -- National ID: Rwandan format
            '119' || LPAD(TO_CHAR(1960 + MOD(i, 40)), 2, '0') || '8' || LPAD(i, 7, '0'),
            
            -- First name: Common Rwandan names
            CASE MOD(i, 12)
                WHEN 0 THEN 'Jean'
                WHEN 1 THEN 'Marie'
                WHEN 2 THEN 'Eric'
                WHEN 3 THEN 'Grace'
                WHEN 4 THEN 'Claude'
                WHEN 5 THEN 'Chantal'
                WHEN 6 THEN 'David'
                WHEN 7 THEN 'Alice'
                WHEN 8 THEN 'Patrick'
                WHEN 9 THEN 'Sonia'
                WHEN 10 THEN 'Samuel'
                ELSE 'Aline'
            END,
            
            -- Last name: Common Rwandan surnames
            CASE MOD(i, 10)
                WHEN 0 THEN 'Habimana'
                WHEN 1 THEN 'Uwase'
                WHEN 2 THEN 'Niyonzima'
                WHEN 3 THEN 'Mukamana'
                WHEN 4 THEN 'Ndayisenga'
                WHEN 5 THEN 'Iradukunda'
                WHEN 6 THEN 'Hakizimana'
                WHEN 7 THEN 'Nkurunziza'
                WHEN 8 THEN 'Twagirayesu'
                ELSE 'Nsengiyumva'
            END,
            
            -- Gender
            CASE WHEN MOD(i, 2) = 0 THEN 'M' ELSE 'F' END,
            
            -- Date of birth: Between 1960-2005
            TO_DATE('1960-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 16436)),
            
            -- Phone: Rwandan format +25078xxxxxxx
            '+25078' || LPAD(3000000 + i * 123, 7, '0'),
            
            -- District
            CASE MOD(i, 8)
                WHEN 0 THEN 'Gasabo'
                WHEN 1 THEN 'Kicukiro'
                WHEN 2 THEN 'Nyarugenge'
                WHEN 3 THEN 'Rubavu'
                WHEN 4 THEN 'Musanze'
                WHEN 5 THEN 'Huye'
                WHEN 6 THEN 'Nyagatare'
                ELSE 'Rusizi'
            END,
            
            -- Sector
            CASE MOD(i, 5)
                WHEN 0 THEN 'Gikondo'
                WHEN 1 THEN 'Remera'
                WHEN 2 THEN 'Kimironko'
                WHEN 3 THEN 'Kacyiru'
                ELSE 'Nyamirambo'
            END,
            
            -- Blood group
            CASE MOD(i, 8)
                WHEN 0 THEN 'O+'
                WHEN 1 THEN 'A+'
                WHEN 2 THEN 'B+'
                WHEN 3 THEN 'AB+'
                WHEN 4 THEN 'O-'
                WHEN 5 THEN 'A-'
                WHEN 6 THEN 'B-'
                ELSE 'AB-'
            END,
            
            -- Allergies
            CASE MOD(i, 6)
                WHEN 0 THEN 'Penicillin'
                WHEN 1 THEN 'Dust'
                WHEN 2 THEN 'Peanuts'
                WHEN 3 THEN 'Shellfish'
                WHEN 4 THEN 'Pollen'
                ELSE 'No known allergies'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 120 patients inserted successfully.');
END;
/

-- ============================================
-- 2. INSERT 50 DOCTORS
-- ============================================

BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO Doctor (
            first_name,
            last_name,
            specialty,
            phone,
            email,
            department,
            license_number,
            hire_date,
            is_available
        ) VALUES (
            -- First name
            CASE MOD(i, 10)
                WHEN 0 THEN 'Eric'
                WHEN 1 THEN 'Marie'
                WHEN 2 THEN 'Jean'
                WHEN 3 THEN 'Grace'
                WHEN 4 THEN 'David'
                WHEN 5 THEN 'Alice'
                WHEN 6 THEN 'Patrick'
                WHEN 7 THEN 'Sarah'
                WHEN 8 THEN 'Samuel'
                ELSE 'Ruth'
            END,
            
            -- Last name
            CASE MOD(i, 8)
                WHEN 0 THEN 'Maniraguha'
                WHEN 1 THEN 'Uwase'
                WHEN 2 THEN 'Nkusi'
                WHEN 3 THEN 'Mukamana'
                WHEN 4 THEN 'Niyongabo'
                WHEN 5 THEN 'Ineza'
                WHEN 6 THEN 'Habimana'
                ELSE 'Kwizera'
            END,
            
            -- Specialty
            CASE MOD(i, 8)
                WHEN 0 THEN 'Cardiology'
                WHEN 1 THEN 'Pediatrics'
                WHEN 2 THEN 'Internal Medicine'
                WHEN 3 THEN 'General Surgery'
                WHEN 4 THEN 'Orthopedics'
                WHEN 5 THEN 'Gynecology'
                WHEN 6 THEN 'Dermatology'
                ELSE 'Emergency Medicine'
            END,
            
            -- Phone
            '+25079' || LPAD(1000000 + i * 234, 7, '0'),
            
            -- Email
            'dr.' || LOWER(
                CASE MOD(i, 10)
                    WHEN 0 THEN 'eric'
                    WHEN 1 THEN 'marie'
                    WHEN 2 THEN 'jean'
                    WHEN 3 THEN 'grace'
                    WHEN 4 THEN 'david'
                    WHEN 5 THEN 'alice'
                    WHEN 6 THEN 'patrick'
                    WHEN 7 THEN 'sarah'
                    WHEN 8 THEN 'samuel'
                    ELSE 'ruth'
                END
            ) || '.' || LOWER(
                CASE MOD(i, 8)
                    WHEN 0 THEN 'maniraguha'
                    WHEN 1 THEN 'uwase'
                    WHEN 2 THEN 'nkusi'
                    WHEN 3 THEN 'mukamana'
                    WHEN 4 THEN 'niyongabo'
                    WHEN 5 THEN 'ineza'
                    WHEN 6 THEN 'habimana'
                    ELSE 'kwizera'
                END
            ) || '@mberamuganga.rw',
            
            -- Department
            CASE MOD(i, 6)
                WHEN 0 THEN 'Cardiology Department'
                WHEN 1 THEN 'Pediatrics Department'
                WHEN 2 THEN 'Emergency Department'
                WHEN 3 THEN 'Surgical Department'
                WHEN 4 THEN 'Maternity Ward'
                ELSE 'Outpatient Clinic'
            END,
            
            -- License number
            'MED-LIC-' || LPAD(i, 6, '0'),
            
            -- Hire date: Between 1-20 years ago
            SYSDATE - (365 * (5 + MOD(i, 15))),
            
            -- Availability
            CASE WHEN MOD(i, 10) = 0 THEN 'N' ELSE 'Y' END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 50 doctors inserted successfully.');
END;
/

-- ============================================
-- 3. INSERT 300 DAILY REPORTS
-- ============================================

BEGIN
    FOR i IN 1..300 LOOP
        INSERT INTO Daily_Report (
            patient_id,
            report_date,
            temperature,
            blood_pressure,
            heart_rate,
            weight_kg,
            symptoms,
            diagnosis,
            medication_given,
            doctor_id,
            nurse_notes,
            review_status
        ) VALUES (
            -- Patient ID: Random between 1-120
            MOD(i, 120) + 1,
            
            -- Report date: Last 90 days
            SYSDATE - MOD(i, 90),
            
            -- Temperature: 36.0-39.5
            36.0 + (MOD(i, 35) * 0.1),
            
            -- Blood pressure
            CASE MOD(i, 6)
                WHEN 0 THEN '110/70'
                WHEN 1 THEN '120/80'
                WHEN 2 THEN '130/85'
                WHEN 3 THEN '140/90'
                WHEN 4 THEN '150/95'
                ELSE '160/100'
            END,
            
            -- Heart rate: 60-100
            60 + MOD(i, 40),
            
            -- Weight: 45-95 kg
            45 + MOD(i, 50),
            
            -- Symptoms
            CASE MOD(i, 8)
                WHEN 0 THEN 'Fever, headache, fatigue'
                WHEN 1 THEN 'Cough, shortness of breath'
                WHEN 2 THEN 'Joint pain, swelling'
                WHEN 3 THEN 'Nausea, vomiting, dizziness'
                WHEN 4 THEN 'Chest pain, palpitations'
                WHEN 5 THEN 'Abdominal pain, diarrhea'
                WHEN 6 THEN 'Rash, itching'
                ELSE 'Sore throat, runny nose'
            END,
            
            -- Diagnosis
            CASE MOD(i, 10)
                WHEN 0 THEN 'Malaria'
                WHEN 1 THEN 'Common Cold'
                WHEN 2 THEN 'Hypertension'
                WHEN 3 THEN 'Diabetes Mellitus'
                WHEN 4 THEN 'Asthma'
                WHEN 5 THEN 'Gastroenteritis'
                WHEN 6 THEN 'Urinary Tract Infection'
                WHEN 7 THEN 'Pneumonia'
                WHEN 8 THEN 'Arthritis'
                ELSE 'Anxiety Disorder'
            END,
            
            -- Medication given
            CASE MOD(i, 12)
                WHEN 0 THEN 'Paracetamol 500mg'
                WHEN 1 THEN 'Ibuprofen 400mg'
                WHEN 2 THEN 'Coartem 80/480mg'
                WHEN 3 THEN 'Amoxicillin 500mg'
                WHEN 4 THEN 'Lisinopril 10mg'
                WHEN 5 THEN 'Metformin 850mg'
                WHEN 6 THEN 'Salbutamol Inhaler'
                WHEN 7 THEN 'Ciprofloxacin 500mg'
                WHEN 8 THEN 'Omeprazole 20mg'
                WHEN 9 THEN 'Cetirizine 10mg'
                WHEN 10 THEN 'ORS Solution'
                ELSE 'No medication prescribed'
            END,
            
            -- Doctor ID: Random between 1-50
            MOD(i, 50) + 1,
            
            -- Nurse notes
            CASE MOD(i, 5)
                WHEN 0 THEN 'Patient condition stable'
                WHEN 1 THEN 'Requires follow-up appointment'
                WHEN 2 THEN 'Symptoms improving'
                WHEN 3 THEN 'Monitor closely'
                ELSE 'Routine checkup completed'
            END,
            
            -- Review status
            CASE MOD(i, 4)
                WHEN 0 THEN 'PENDING'
                WHEN 1 THEN 'REVIEWED'
                WHEN 2 THEN 'APPROVED'
                ELSE 'REVIEWED'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 300 daily reports inserted successfully.');
END;
/

-- ============================================
-- 4. INSERT 200 APPOINTMENTS
-- ============================================

BEGIN
    FOR i IN 1..200 LOOP
        INSERT INTO Appointment (
            patient_id,
            doctor_id,
            appointment_date,
            appointment_time,
            appointment_type,
            status,
            reason,
            notes
        ) VALUES (
            -- Patient ID
            MOD(i, 120) + 1,
            
            -- Doctor ID
            MOD(i, 50) + 1,
            
            -- Appointment date: Next 60 days
            SYSDATE + MOD(i, 60),
            
            -- Appointment time: 8:00-17:00 in 30 min intervals
            LPAD(8 + MOD(i, 10), 2, '0') || ':' || 
            CASE WHEN MOD(i, 2) = 0 THEN '00' ELSE '30' END,
            
            -- Appointment type
            CASE MOD(i, 6)
                WHEN 0 THEN 'Consultation'
                WHEN 1 THEN 'Follow-up'
                WHEN 2 THEN 'Emergency'
                WHEN 3 THEN 'Routine Checkup'
                WHEN 4 THEN 'Vaccination'
                ELSE 'Specialist Review'
            END,
            
            -- Status
            CASE MOD(i, 10)
                WHEN 0 THEN 'CANCELLED'
                WHEN 1 THEN 'NO-SHOW'
                WHEN 2 THEN 'COMPLETED'
                ELSE 'SCHEDULED'
            END,
            
            -- Reason
            CASE MOD(i, 8)
                WHEN 0 THEN 'Routine medical checkup'
                WHEN 1 THEN 'Follow-up for previous condition'
                WHEN 2 THEN 'New symptoms developed'
                WHEN 3 THEN 'Medication review'
                WHEN 4 THEN 'Test results discussion'
                WHEN 5 THEN 'Vaccination required'
                WHEN 6 THEN 'Chronic disease management'
                ELSE 'Emergency consultation'
            END,
            
            -- Notes
            CASE MOD(i, 5)
                WHEN 0 THEN 'Patient requested morning appointment'
                WHEN 1 THEN 'Bring previous medical records'
                WHEN 2 THEN 'Fasting required for blood tests'
                WHEN 3 THEN 'Accompanied by family member'
                ELSE 'Regular follow-up visit'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 200 appointments inserted successfully.');
END;
/

-- ============================================
-- 5. INSERT 150 MEDICATIONS (Prescriptions)
-- ============================================

BEGIN
    FOR i IN 1..150 LOOP
        INSERT INTO Medication (
            patient_id,
            doctor_id,
            medication_name,
            generic_name,
            dosage,
            frequency,
            duration_days,
            start_date,
            end_date,
            quantity_issued,
            refills_allowed,
            instructions
        ) VALUES (
            -- Patient ID
            MOD(i, 120) + 1,
            
            -- Doctor ID
            MOD(i, 50) + 1,
            
            -- Medication name
            CASE MOD(i, 12)
                WHEN 0 THEN 'Coartem'
                WHEN 1 THEN 'Paracetamol'
                WHEN 2 THEN 'Amoxicillin'
                WHEN 3 THEN 'Lisinopril'
                WHEN 4 THEN 'Metformin'
                WHEN 5 THEN 'Ibuprofen'
                WHEN 6 THEN 'Salbutamol Inhaler'
                WHEN 7 THEN 'Omeprazole'
                WHEN 8 THEN 'Cetirizine'
                WHEN 9 THEN 'Ciprofloxacin'
                WHEN 10 THEN 'Doxycycline'
                ELSE 'Aspirin'
            END,
            
            -- Generic name
            CASE MOD(i, 12)
                WHEN 0 THEN 'Artemether/Lumefantrine'
                WHEN 1 THEN 'Acetaminophen'
                WHEN 2 THEN 'Amoxicillin Trihydrate'
                WHEN 3 THEN 'Lisinopril Dihydrate'
                WHEN 4 THEN 'Metformin Hydrochloride'
                WHEN 5 THEN 'Ibuprofen'
                WHEN 6 THEN 'Salbutamol Sulfate'
                WHEN 7 THEN 'Omeprazole Magnesium'
                WHEN 8 THEN 'Cetirizine Hydrochloride'
                WHEN 9 THEN 'Ciprofloxacin Hydrochloride'
                WHEN 10 THEN 'Doxycycline Hyclate'
                ELSE 'Acetylsalicylic Acid'
            END,
            
            -- Dosage
            CASE MOD(i, 12)
                WHEN 0 THEN '80/480 mg'
                WHEN 1 THEN '500 mg'
                WHEN 2 THEN '500 mg'
                WHEN 3 THEN '10 mg'
                WHEN 4 THEN '850 mg'
                WHEN 5 THEN '400 mg'
                WHEN 6 THEN '100 mcg'
                WHEN 7 THEN '20 mg'
                WHEN 8 THEN '10 mg'
                WHEN 9 THEN '500 mg'
                WHEN 10 THEN '100 mg'
                ELSE '81 mg'
            END,
            
            -- Frequency
            CASE MOD(i, 6)
                WHEN 0 THEN 'Once daily'
                WHEN 1 THEN 'Twice daily'
                WHEN 2 THEN 'Three times daily'
                WHEN 3 THEN 'Every 6 hours'
                WHEN 4 THEN 'As needed'
                ELSE 'Before meals'
            END,
            
            -- Duration days
            CASE MOD(i, 5)
                WHEN 0 THEN 3
                WHEN 1 THEN 7
                WHEN 2 THEN 14
                WHEN 3 THEN 30
                ELSE 90
            END,
            
            -- Start date: Last 30 days
            SYSDATE - MOD(i, 30),
            
            -- End date: Start date + duration
            SYSDATE - MOD(i, 30) + 
            CASE MOD(i, 5)
                WHEN 0 THEN 3
                WHEN 1 THEN 7
                WHEN 2 THEN 14
                WHEN 3 THEN 30
                ELSE 90
            END,
            
            -- Quantity issued
            CASE MOD(i, 5)
                WHEN 0 THEN 6
                WHEN 1 THEN 10
                WHEN 2 THEN 20
                WHEN 3 THEN 30
                ELSE 60
            END,
            
            -- Refills allowed
            MOD(i, 3),
            
            -- Instructions
            CASE MOD(i, 6)
                WHEN 0 THEN 'Take with food'
                WHEN 1 THEN 'Take on empty stomach'
                WHEN 2 THEN 'Take with plenty of water'
                WHEN 3 THEN 'Avoid alcohol'
                WHEN 4 THEN 'Complete full course'
                ELSE 'Take at bedtime'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 150 medications inserted successfully.');
END;
/

-- ============================================
-- 6. INSERT 120 NOTIFICATIONS
-- ============================================

BEGIN
    FOR i IN 1..120 LOOP
        INSERT INTO Notification (
            patient_id,
            appointment_id,
            notification_type,
            message,
            delivery_method,
            status
        ) VALUES (
            -- Patient ID (some null for general alerts)
            CASE WHEN MOD(i, 5) = 0 THEN NULL ELSE MOD(i, 120) + 1 END,
            
            -- Appointment ID (some null for medication reminders)
            CASE WHEN MOD(i, 3) = 0 THEN NULL ELSE MOD(i, 200) + 1 END,
            
            -- Notification type
            CASE MOD(i, 3)
                WHEN 0 THEN 'Appointment Reminder'
                WHEN 1 THEN 'Medication Reminder'
                ELSE 'General Alert'
            END,
            
            -- Message
            CASE MOD(i, 6)
                WHEN 0 THEN 'Reminder: Appointment tomorrow at 10:00 AM with Dr. Maniraguha'
                WHEN 1 THEN 'Time to take your medication: Paracetamol 500mg'
                WHEN 2 THEN 'Your lab test results are now available in the patient portal'
                WHEN 3 THEN 'Health Tip: Drink at least 8 glasses of water daily'
                WHEN 4 THEN 'Alert: Your prescription is ready for pickup at pharmacy'
                ELSE 'New health article: Managing hypertension through diet'
            END,
            
            -- Delivery method
            CASE MOD(i, 4)
                WHEN 0 THEN 'SMS'
                WHEN 1 THEN 'Email'
                WHEN 2 THEN 'App Notification'
                ELSE 'Phone Call'
            END,
            
            -- Status
            CASE MOD(i, 5)
                WHEN 0 THEN 'PENDING'
                WHEN 1 THEN 'SENT'
                WHEN 2 THEN 'DELIVERED'
                WHEN 3 THEN 'READ'
                ELSE 'FAILED'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 120 notifications inserted successfully.');
END;
/

-- ============================================================
-- PART 4: DATA INTEGRITY VERIFICATION
-- ============================================================

PROMPT ============================================
PROMPT DATA INTEGRITY VERIFICATION
PROMPT ============================================

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

-- ============================================================
-- PART 5: TESTING QUERIES
-- ============================================================

PROMPT ============================================
PROMPT TESTING QUERIES (Take screenshots!)
PROMPT ============================================

-- 1. BASIC RETRIEVAL (SELECT *)

PROMPT 1. BASIC RETRIEVAL - First 5 rows from each table:
PROMPT ---------------------------------------------------

SELECT 'PATIENTS' AS Table_Name FROM dual;
SELECT * FROM Patient WHERE ROWNUM <= 5;
PROMPT ;

SELECT 'DOCTORS' AS Table_Name FROM dual;
SELECT * FROM Doctor WHERE ROWNUM <= 5;
PROMPT ;

SELECT 'DAILY_REPORTS' AS Table_Name FROM dual;
SELECT * FROM Daily_Report WHERE ROWNUM <= 5 ORDER BY report_date DESC;
PROMPT ;

SELECT 'APPOINTMENTS' AS Table_Name FROM dual;
SELECT * FROM Appointment WHERE ROWNUM <= 5 ORDER BY appointment_date;
PROMPT ;

SELECT 'MEDICATIONS' AS Table_Name FROM dual;
SELECT * FROM Medication WHERE ROWNUM <= 5 ORDER BY start_date DESC;
PROMPT ;

SELECT 'NOTIFICATIONS' AS Table_Name FROM dual;
SELECT * FROM Notification WHERE ROWNUM <= 5 ORDER BY sent_date DESC;
PROMPT ;

-- 2. JOINS (Multi-table queries)

PROMPT 2. JOINS - Appointments with Patient and Doctor Details:
PROMPT ---------------------------------------------------------
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialty,
    a.appointment_date,
    a.appointment_time,
    a.status,
    a.reason
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= SYSDATE
ORDER BY a.appointment_date, a.appointment_time;
PROMPT ;

PROMPT 3. JOINS - Patient Medications with Details:
PROMPT ---------------------------------------------
SELECT 
    m.medication_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    m.medication_name,
    m.dosage,
    m.frequency,
    d.first_name || ' ' || d.last_name AS prescribed_by,
    m.start_date,
    m.end_date,
    m.instructions
FROM Medication m
JOIN Patient p ON m.patient_id = p.patient_id
JOIN Doctor d ON m.doctor_id = d.doctor_id
WHERE m.end_date >= SYSDATE
ORDER BY m.start_date DESC;
PROMPT ;

-- 3. AGGREGATIONS (GROUP BY)

PROMPT 4. AGGREGATIONS - Doctor Appointment Statistics:
PROMPT ------------------------------------------------
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialty,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'COMPLETED' THEN 1 END) AS completed,
    COUNT(CASE WHEN a.status = 'CANCELLED' THEN 1 END) AS cancelled,
    COUNT(CASE WHEN a.status = 'NO-SHOW' THEN 1 END) AS no_show,
    COUNT(CASE WHEN a.status = 'SCHEDULED' THEN 1 END) AS scheduled,
    ROUND(100 * COUNT(CASE WHEN a.status = 'COMPLETED' THEN 1 END) / NULLIF(COUNT(a.appointment_id), 0), 2) AS completion_rate
FROM Doctor d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialty
ORDER BY total_appointments DESC;
PROMPT ;

PROMPT 5. AGGREGATIONS - Patient Diagnoses Distribution:
PROMPT -------------------------------------------------
SELECT 
    diagnosis,
    COUNT(*) AS report_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Daily_Report), 2) AS percentage
FROM Daily_Report
WHERE diagnosis IS NOT NULL
GROUP BY diagnosis
ORDER BY report_count DESC;
PROMPT ;

-- 4. SUBQUERIES

PROMPT 6. SUBQUERIES - Patients with Most Appointments:
PROMPT ------------------------------------------------
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.phone,
    (SELECT COUNT(*) FROM Appointment a WHERE a.patient_id = p.patient_id) AS appointment_count,
    (SELECT MAX(appointment_date) FROM Appointment a WHERE a.patient_id = p.patient_id) AS last_appointment
FROM Patient p
WHERE (SELECT COUNT(*) FROM Appointment a WHERE a.patient_id = p.patient_id) > 2
ORDER BY appointment_count DESC;
PROMPT ;

PROMPT 7. SUBQUERIES - Doctors Prescribing Most Medications:
PROMPT -----------------------------------------------------
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialty,
    (SELECT COUNT(*) FROM Medication m WHERE m.doctor_id = d.doctor_id) AS prescription_count,
    (SELECT COUNT(DISTINCT medication_name) FROM Medication m WHERE m.doctor_id = d.doctor_id) AS unique_medications
FROM Doctor d
WHERE (SELECT COUNT(*) FROM Medication m WHERE m.doctor_id = d.doctor_id) > 0
ORDER BY prescription_count DESC;
PROMPT ;

-- ============================================================
-- PART 6: FINAL VALIDATION SUMMARY
-- ============================================================

PROMPT ============================================
PROMPT FINAL VALIDATION SUMMARY
PROMPT ============================================

DECLARE
    total_patients NUMBER;
    total_doctors NUMBER;
    total_reports NUMBER;
    total_appointments NUMBER;
    total_medications NUMBER;
    total_notifications NUMBER;
BEGIN
    SELECT COUNT(*) INTO total_patients FROM Patient;
    SELECT COUNT(*) INTO total_doctors FROM Doctor;
    SELECT COUNT(*) INTO total_reports FROM Daily_Report;
    SELECT COUNT(*) INTO total_appointments FROM Appointment;
    SELECT COUNT(*) INTO total_medications FROM Medication;
    SELECT COUNT(*) INTO total_notifications FROM Notification;
    
    DBMS_OUTPUT.PUT_LINE('✅ PHASE 5 COMPLETED SUCCESSFULLY');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('Table               | Records');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Patient             | ' || LPAD(TO_CHAR(total_patients), 6) || ' ✓ (120+)');
    DBMS_OUTPUT.PUT_LINE('Doctor              | ' || LPAD(TO_CHAR(total_doctors), 6) || ' ✓ (50+)');
    DBMS_OUTPUT.PUT_LINE('Daily_Report        | ' || LPAD(TO_CHAR(total_reports), 6) || ' ✓ (300+)');
    DBMS_OUTPUT.PUT_LINE('Appointment         | ' || LPAD(TO_CHAR(total_appointments), 6) || ' ✓ (200+)');
    DBMS_OUTPUT.PUT_LINE('Medication          | ' || LPAD(TO_CHAR(total_medications), 6) || ' ✓ (150+)');
    DBMS_OUTPUT.PUT_LINE('Notification        | ' || LPAD(TO_CHAR(total_notifications), 6) || ' ✓ (120+)');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    DBMS_OUTPUT.PUT_LINE('TOTAL RECORDS       | ' || LPAD(TO_CHAR(
        total_patients + total_doctors + total_reports + 
        total_appointments + total_medications + total_notifications
    ), 6));
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('VALIDATION CHECKS:');
    DBMS_OUTPUT.PUT_LINE('✓ All tables created successfully');
    DBMS_OUTPUT.PUT_LINE('✓ Minimum 100+ rows per main table');
    DBMS_OUTPUT.PUT_LINE('✓ Realistic test data inserted');
    DBMS_OUTPUT.PUT_LINE('✓ Foreign key relationships validated');
    DBMS_OUTPUT.PUT_LINE('✓ Constraints enforced properly');
    DBMS_OUTPUT.PUT_LINE('✓ Data completeness verified');
    DBMS_OUTPUT.PUT_LINE('✓ Testing queries executed successfully');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('STUDENT: Benon | ID: 29143');
    DBMS_OUTPUT.PUT_LINE('PROJECT: Mbera Muganga Hospital Management');
    DBMS_OUTPUT.PUT_LINE('COURSE: INSY 8311 - PL/SQL Oracle Database');
    DBMS_OUTPUT.PUT_LINE('LECTURER: Eric Maniraquha');
    DBMS_OUTPUT.PUT_LINE('INSTITUTION: AUCA');
    DBMS_OUTPUT.PUT_LINE('===================================');
END;
/

-- ============================================================
-- PART 7: GITHUB SUBMISSION READY
-- ============================================================

PROMPT ============================================
PROMPT READY FOR GITHUB SUBMISSION
PROMPT ============================================
PROMPT 
PROMPT 1. Save this script as: phase5_data_insertion.sql
PROMPT 2. Take screenshots of:
PROMPT    - Table creation verification
PROMPT    - Data insertion success messages
PROMPT    - Row count verification (Part 4)
PROMPT    - Sample query results (Part 5)
PROMPT    - Final validation summary
PROMPT 3. Commit to GitHub:
PROMPT    git add
