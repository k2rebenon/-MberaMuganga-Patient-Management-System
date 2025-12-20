
-- TESTING QUERIES

-- 1. BASIC RETRIEVAL (SELECT *)

PROMPT 1. BASIC RETRIEVAL - First 5 rows from each table:

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

