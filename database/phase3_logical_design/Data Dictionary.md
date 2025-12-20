# **Data Dictionary**

## **3. COMPLETE DATA DICTIONARY**

### **3.1 TABLE: PATIENT**

**Description**: Stores patient registration, demographics, and medical
history

**Primary Key**: Patient_ID

**Foreign Keys**: None

**Relationships**: Referenced by Daily_Report, Appointment, Medication,
Notification

  ------------------------------------------------------------------------------------------
  **Column Name**       **Data Type**   **Constraints**   **Description**   **Example**
  --------------------- --------------- ----------------- ----------------- ----------------
  Patient_ID            NUMBER(10)      PK, NOT NULL,     Unique patient    1001
                                        AUTO_INCREMENT    identifier        

  Name                  VARCHAR2(100)   NOT NULL          Patient full      Jean Claude
                                                          legal name        MUGISHA

  Contact_Information   VARCHAR2(200)   NOT NULL          Phone and email   Phone:
                                                                            +250788123456,
                                                                            Email:
                                                                            jc@email.rw

  Medical_History       CLOB            NULL              Previous medical  Hypertension
                                                          conditions and    since 2015, Type
                                                          surgeries         2 Diabetes

  Registration_Date     TIMESTAMP       DEFAULT           Account creation  2024-01-15
                                        SYSTIMESTAMP, NOT timestamp         10:30:00
                                        NULL                                

  Status                VARCHAR2(20)    DEFAULT           Account status    Active,
                                        \'Active\', CHECK                   Inactive,
                                                                            Suspended
  ------------------------------------------------------------------------------------------

**Business Rules**:

-   Contact_Information must include at minimum phone number

-   Medical_History can be updated by patient or doctor

-   Status \'Suspended\' requires admin approval to reactivate

-   Auto-increment Patient_ID starts at 1001

**Indexes**:

-   idx_patient_name ON Name (for search)

-   idx_patient_status ON Status (for filtering active patients)

### **3.2 TABLE: DOCTOR**

**Description**: Healthcare provider credentials, specialties, and
availability

**Primary Key**: Doctor_ID

**Foreign Keys**: None

**Relationships**: Referenced by Daily_Report, Appointment, Medication,
Notification

  -----------------------------------------------------------------------------------------------------
  **Column Name**       **Data Type**   **Constraints**   **Description**        **Example**
  --------------------- --------------- ----------------- ---------------------- ----------------------
  Doctor_ID             NUMBER(10)      PK, NOT NULL,     Unique doctor          2001
                                        AUTO_INCREMENT    identifier             

  Name                  VARCHAR2(100)   NOT NULL          Doctor full legal name Dr. Alice MUKAMANA

  Specialty             VARCHAR2(100)   NOT NULL          Medical                Cardiology
                                                          specialty/department   

  Contact_Information   VARCHAR2(200)   NULL              Phone and email        Phone: +250788111222,
                                                                                 Email:
                                                                                 dr.alice@hospital.rw

  Years_Experience      NUMBER(2)       CHECK (\>= 0 AND  Years in medical       12
                                        \<= 50)           practice               

  Registration_Date     TIMESTAMP       DEFAULT           Account creation       2023-06-10 14:20:00
                                        SYSTIMESTAMP, NOT timestamp              
                                        NULL                                     

  Status                VARCHAR2(20)    DEFAULT           Account availability   Active, Inactive, On
                                        \'Active\', CHECK status                 Leave
  -----------------------------------------------------------------------------------------------------

**Business Rules**:

-   Specialty must match predefined list (enforced at application layer)

-   Years_Experience cannot exceed 50 (reasonable limit)

-   Status \'On Leave\' prevents new appointment scheduling

-   Contact_Information required for active doctors

**Indexes**:

-   idx_doctor_specialty ON Specialty (for finding doctors by specialty)

-   idx_doctor_name ON Name (for search)

-   idx_doctor_status ON Status (for filtering available doctors)

### **3.3 TABLE: DAILY_REPORT**

**Description**: Patient daily health reports with vitals, symptoms, and
review status

**Primary Key**: Report_ID

**Foreign Keys**:

-   Patient_ID → Patient(Patient_ID)

-   Reviewed_By_Doctor → Doctor(Doctor_ID)

**Relationships**:

-   Many-to-One with Patient

-   Many-to-One with Doctor (optional)

  -----------------------------------------------------------------------------------------
  **Column Name**      **Data Type**   **Constraints**   **Description**      **Example**
  -------------------- --------------- ----------------- -------------------- -------------
  Report_ID            NUMBER(10)      PK, NOT NULL,     Unique report        3001
                                       AUTO_INCREMENT    identifier           

  Patient_ID           NUMBER(10)      FK, NOT NULL,     Reference to Patient 1001
                                       INDEX             table                

  Report_Date          DATE            DEFAULT SYSDATE,  Date of health       2024-12-01
                                       NOT NULL          report               

  Symptoms             CLOB            NOT NULL          Patient-reported     Mild
                                                         symptoms             headache,
                                                                              fatigue,
                                                                              dizziness

  Medication           VARCHAR2(500)   NULL              Medications taken    Metformin
                                                         that day             500mg twice,
                                                                              Lisinopril
                                                                              10mg

  Temperature          NUMBER(4,1)     CHECK (\>= 30.0   Body temperature in  36.8
                                       AND \<= 45.0)     Celsius              

  Blood_Pressure       VARCHAR2(20)    NULL              Systolic/Diastolic   140/90
                                                         reading              

  Heart_Rate           NUMBER(3)       CHECK (\>= 30 AND Heart rate in beats  78
                                       \<= 250)          per minute           

  Submission_Time      TIMESTAMP       DEFAULT           Exact submission     2024-12-01
                                       SYSTIMESTAMP, NOT timestamp            8:15:30
                                       NULL                                   

  Reviewed_By_Doctor   NUMBER(10)      FK, NULL, INDEX   Doctor who reviewed  2001
                                                         (NULL=pending)       

  Review_Date          TIMESTAMP       NULL              When doctor reviewed 2024-12-01
                                                         report               14:30:00

  Urgency_Level        VARCHAR2(20)    DEFAULT           Clinical urgency     Normal,
                                       \'Normal\', CHECK classification       Urgent,
                                                                              Emergency
  -----------------------------------------------------------------------------------------

**Business Rules**:

-   One patient can submit maximum one report per day (unique constraint
    > on Patient_ID + TRUNC(Report_Date))

-   Temperature range: 30.0°C to 45.0°C (abnormal values trigger
    > automatic alerts)

-   Heart_Rate range: 30 to 250 bpm (extreme values flagged)

-   Urgency_Level: \'Emergency\' triggers immediate doctor notification

-   Review_Date must be \>= Report_Date (cannot review before
    > submission)

-   Reviewed_By_Doctor can be NULL (report pending review)

**Indexes**:

-   idx_report_patient ON Patient_ID (for patient history queries)

-   idx_report_date ON Report_Date (for date range queries)

-   idx_report_doctor ON Reviewed_By_Doctor (for doctor workload
    > queries)

-   idx_report_urgency ON Urgency_Level (for urgent case filtering)

### **3.4 TABLE: APPOINTMENT**

**Description**: Appointment scheduling between patients and doctors

**Primary Key**: Appointment_ID

**Foreign Keys**:

-   Patient_ID → Patient(Patient_ID)

-   Doctor_ID → Doctor(Doctor_ID)

**Relationships**:

-   Many-to-One with Patient

-   Many-to-One with Doctor

  -------------------------------------------------------------------------------------
  **Column Name**    **Data Type**   **Constraints**    **Description**   **Example**
  ------------------ --------------- ------------------ ----------------- -------------
  Appointment_ID     NUMBER(10)      PK, NOT NULL,      Unique            4001
                                     AUTO_INCREMENT     appointment       
                                                        identifier        

  Patient_ID         NUMBER(10)      FK, NOT NULL,      Reference to      1001
                                     INDEX              Patient table     

  Doctor_ID          NUMBER(10)      FK, NOT NULL,      Reference to      2001
                                     INDEX              Doctor table      

  Appointment_Date   DATE            NOT NULL           Date of           2024-12-05
                                                        appointment       

  Appointment_Time   VARCHAR2(10)    NOT NULL           Appointment time  14:30
                                                        slot              

  Reason             VARCHAR2(500)   NULL               Purpose of        Follow-up for
                                                        appointment       diabetes
                                                                          management

  Status             VARCHAR2(20)    DEFAULT            Appointment       Scheduled,
                                     \'Scheduled\',     status            Completed,
                                     CHECK                                Cancelled, No
                                                                          Show

  Created_Date       TIMESTAMP       DEFAULT            When appointment  2024-11-28
                                     SYSTIMESTAMP, NOT  was booked        9:15:00
                                     NULL                                 
  -------------------------------------------------------------------------------------

**Business Rules**:

-   No double-booking: UNIQUE constraint on (Doctor_ID,
    > Appointment_Date, Appointment_Time)

-   Appointment_Date should be \>= SYSDATE (future dates, enforced at
    > application layer)

-   Status transitions: Scheduled → Completed/Cancelled/No Show

-   Cancelled appointments cannot be reactivated (must create new)

-   Appointment_Time in HH:MM format (e.g., \"14:30\")

**Indexes**:

-   idx_appt_patient ON Patient_ID (for patient appointment history)

-   idx_appt_doctor ON Doctor_ID (for doctor schedule)

-   idx_appt_date ON Appointment_Date (for date-based queries)

-   idx_appt_status ON Status (for filtering by status)

**Unique Constraint**:

-   uq_doctor_time ON (Doctor_ID, Appointment_Date, Appointment_Time) -
    > Prevents double-booking

### **3.5 TABLE: MEDICATION**

**Description**: Medication prescriptions and management tracking

**Primary Key**: Medication_ID

**Foreign Keys**:

-   Patient_ID → Patient(Patient_ID)

-   Doctor_ID → Doctor(Doctor_ID)

**Relationships**:

-   Many-to-One with Patient

-   Many-to-One with Doctor

  ------------------------------------------------------------------------------------
  **Column Name**   **Data Type**   **Constraints**   **Description**   **Example**
  ----------------- --------------- ----------------- ----------------- --------------
  Medication_ID     NUMBER(10)      PK, NOT NULL,     Unique medication 5001
                                    AUTO_INCREMENT    record ID         

  Patient_ID        NUMBER(10)      FK, NOT NULL,     Reference to      1001
                                    INDEX             Patient table     

  Doctor_ID         NUMBER(10)      FK, NOT NULL,     Reference to      2001
                                    INDEX             Doctor            
                                                      (prescriber)      

  Medication_Name   VARCHAR2(200)   NOT NULL          Name of           Metformin
                                                      medication/drug   

  Dosage            VARCHAR2(100)   NOT NULL          Dosage amount and 500mg tablets
                                                      form              

  Frequency         VARCHAR2(100)   NULL              How often to take Twice daily
                                                                        with meals

  Start_Date        DATE            DEFAULT SYSDATE,  Date to begin     2024-01-15
                                    NOT NULL          medication        

  End_Date          DATE            NULL, CHECK (\>=  Date to stop      2024-07-15
                                    Start_Date)       medication        
                                                      (NULL=ongoing)    

  Status            VARCHAR2(20)    DEFAULT           Prescription      Active,
                                    \'Active\', CHECK status            Completed,
                                                                        Discontinued
  ------------------------------------------------------------------------------------

**Business Rules**:

-   End_Date must be \>= Start_Date (if provided)

-   End_Date NULL means ongoing/chronic medication

-   Status \'Discontinued\' requires reason (enforced at application
    > layer)

-   Medication_Name should reference drug database (future enhancement)

-   Active medications counted for patient adherence metrics

**Indexes**:

-   idx_med_patient ON Patient_ID (for patient medication list)

-   idx_med_doctor ON Doctor_ID (for prescriptions by doctor)

-   idx_med_status ON Status (for active medication queries)

### **3.6 TABLE: NOTIFICATION**

**Description**: System notifications, alerts, and reminders for
patients and doctors

**Primary Key**: Notification_ID

**Foreign Keys**:

-   Patient_ID → Patient(Patient_ID) (optional)

-   Doctor_ID → Doctor(Doctor_ID) (optional)

**Relationships**:

-   Many-to-One with Patient (optional)

-   Many-to-One with Doctor (optional)

  ---------------------------------------------------------------------------------------
  **Column Name**     **Data Type**  **Constraints**    **Description**   **Example**
  ------------------- -------------- ------------------ ----------------- ---------------
  Notification_ID     NUMBER(10)     PK, NOT NULL,      Unique            6001
                                     AUTO_INCREMENT     notification      
                                                        identifier        

  Patient_ID          NUMBER(10)     FK, NULL, INDEX    Patient recipient 1001
                                                        (if applicable)   

  Doctor_ID           NUMBER(10)     FK, NULL, INDEX    Doctor recipient  2001
                                                        (if applicable)   

  Notification_Type   VARCHAR2(20)   NOT NULL, CHECK    Type of           Reminder,
                                                        notification      Alert,
                                                                          Communication

  Message             CLOB           NOT NULL           Notification      Time to submit
                                                        message content   your daily
                                                                          health report

  Is_Read             NUMBER(1)      DEFAULT 0, CHECK   Read status:      0
                                     (0 or 1)           0=unread, 1=read  

  Created_Date        TIMESTAMP      DEFAULT            When notification 2024-12-01
                                     SYSTIMESTAMP, NOT  was created       6:00:00
                                     NULL                                 

  Sent_Date           TIMESTAMP      NULL               When notification 2024-12-01
                                                        was delivered     6:00:15
  ---------------------------------------------------------------------------------------

**Business Rules**:

-   Either Patient_ID or Doctor_ID must be NOT NULL (CHECK constraint)

-   Cannot target both patient and doctor simultaneously (one recipient
    > per notification)

-   Notification_Type: \'Reminder\' (daily report), \'Alert\' (urgent
    > case), \'Communication\' (general)

-   Is_Read: 0 (false/unread), 1 (true/read) - boolean stored as
    > NUMBER(1)

-   Sent_Date tracks delivery time for monitoring purposes

**Indexes**:

-   idx_notif_patient ON Patient_ID (for patient notifications)

-   idx_notif_doctor ON Doctor_ID (for doctor notifications)

-   idx_notif_type ON Notification_Type (for filtering by type)

-   idx_notif_read ON Is_Read (for unread notifications)

**Check Constraint**:

-   chk_notif_recipient CHECK (Patient_ID IS NOT NULL OR Doctor_ID IS
    > NOT NULL) - Ensures at least one recipient
