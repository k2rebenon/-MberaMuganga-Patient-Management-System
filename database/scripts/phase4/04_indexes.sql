
CREATE INDEX idx_patients_name ON Patients(Name);
CREATE INDEX idx_doctors_specialty ON Doctors(Specialty);
CREATE INDEX idx_reports_date ON Daily_Reports(Report_Date);
CREATE INDEX idx_appointments_date ON Appointments(Appointment_Date);
CREATE INDEX idx_patient_medications ON Patient_Medications(Patient_ID, Medication_ID);

