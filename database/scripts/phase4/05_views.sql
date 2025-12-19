CREATE OR REPLACE VIEW vw_patient_appointments AS
SELECT 
    p.Patient_ID,
    p.Name AS Patient_Name,
    d.Name AS Doctor_Name,
    d.Specialty,
    a.Appointment_Date,
    a.Appointment_Time,
    a.Status
FROM Patients p
JOIN Appointments a ON p.Patient_ID = a.Patient_ID
JOIN Doctors d ON a.Doctor_ID = d.Doctor_ID;

CREATE OR REPLACE VIEW vw_patient_medications AS
SELECT 
    p.Patient_ID,
    p.Name AS Patient_Name,
    m.Medication_Name,
    m.Dosage,
    pm.Prescribed_Date,
    pm.Duration_Days,
    pm.Instructions,
    doc.Name AS Prescribing_Doctor
FROM Patients p
JOIN Patient_Medications pm ON p.Patient_ID = pm.Patient_ID
JOIN Medications m ON pm.Medication_ID = m.Medication_ID
LEFT JOIN Doctors doc ON pm.Doctor_ID = doc.Doctor_ID;

-- Additional useful view
CREATE OR REPLACE VIEW vw_patient_summary AS
SELECT 
    p.Patient_ID,
    p.Name AS Patient_Name,
    p.Gender,
    TRUNC(MONTHS_BETWEEN(SYSDATE, p.Date_Of_Birth)/12) AS Age,
    p.Contact_Information,
    COUNT(DISTINCT a.Appointment_ID) AS Total_Appointments,
    COUNT(DISTINCT pm.Prescription_ID) AS Total_Prescriptions,
    MAX(a.Appointment_Date) AS Last_Appointment
FROM Patients p
LEFT JOIN Appointments a ON p.Patient_ID = a.Patient_ID
LEFT JOIN Patient_Medications pm ON p.Patient_ID = pm.Patient_ID
GROUP BY p.Patient_ID, p.Name, p.Gender, p.Date_Of_Birth, p.Contact_Information;
