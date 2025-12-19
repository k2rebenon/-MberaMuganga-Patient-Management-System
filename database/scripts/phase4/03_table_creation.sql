 CREATE TABLES WITH ORACLE SYNTAX
CREATE TABLE Patients (
    Patient_ID NUMBER(10) PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Contact_Information VARCHAR2(100) NOT NULL,
    Medical_History CLOB,
    Date_Of_Birth DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(200),
    Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
    Updated_Date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE Doctors (
    Doctor_ID NUMBER(10) PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Specialty VARCHAR2(100) NOT NULL,
    License_Number VARCHAR2(50) UNIQUE,
    Contact_Information VARCHAR2(100),
    Years_Experience NUMBER(3),
    Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE Daily_Reports (
    Report_ID NUMBER(10) PRIMARY KEY,
    Patient_ID NUMBER(10) NOT NULL,
    Report_Date DATE NOT NULL,
    Symptoms VARCHAR2(500),
    Diagnosis VARCHAR2(500),
    Medication_Prescribed VARCHAR2(200),
    Doctor_Notes CLOB,
    Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_report_patient 
        FOREIGN KEY (Patient_ID) 
        REFERENCES Patients(Patient_ID)
        ON DELETE CASCADE
);

CREATE TABLE Appointments (
    Appointment_ID NUMBER(10) PRIMARY KEY,
    Patient_ID NUMBER(10) NOT NULL,
    Doctor_ID NUMBER(10) NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIMESTAMP NOT NULL,
    Status VARCHAR2(20) DEFAULT 'SCHEDULED',
    Reason VARCHAR2(200),
    Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_appointment_patient 
        FOREIGN KEY (Patient_ID) 
        REFERENCES Patients(Patient_ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor 
        FOREIGN KEY (Doctor_ID) 
        REFERENCES Doctors(Doctor_ID)
        ON DELETE CASCADE,
    CONSTRAINT chk_appointment_status 
        CHECK (Status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW'))
);

CREATE TABLE Medications (
    Medication_ID NUMBER(10) PRIMARY KEY,
    Medication_Name VARCHAR2(100) NOT NULL UNIQUE,
    Dosage VARCHAR2(50) NOT NULL,
    Manufacturer VARCHAR2(100),
    Side_Effects CLOB,
    Storage_Conditions VARCHAR2(100),
    Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE Patient_Medications (
    Prescription_ID NUMBER(10) PRIMARY KEY,
    Patient_ID NUMBER(10) NOT NULL,
    Medication_ID NUMBER(10) NOT NULL,
    Prescribed_Date DATE NOT NULL,
    Duration_Days NUMBER(5),
    Instructions VARCHAR2(200),
    Doctor_ID NUMBER(10),
    CONSTRAINT fk_prescription_patient 
        FOREIGN KEY (Patient_ID) 
        REFERENCES Patients(Patient_ID),
    CONSTRAINT fk_prescription_medication 
        FOREIGN KEY (Medication_ID) 
        REFERENCES Medications(Medication_ID),
    CONSTRAINT fk_prescription_doctor 
        FOREIGN KEY (Doctor_ID) 
        REFERENCES Doctors(Doctor_ID)
);
