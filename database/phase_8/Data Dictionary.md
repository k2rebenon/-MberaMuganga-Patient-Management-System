**Data** **Dictionary**

**3.** **COMPLETE** **DATA** **DICTIONARY**

**3.1** **TABLE:** **PATIENT**

**Description**: Stores patient registration, demographics, and medical
history **Primary** **Key**: Patient_ID

**Foreign** **Keys**: None

**Relationships**: Referenced by Daily_Report, Appointment, Medication,
Notification

> **Column** **Name**
>
> Patient_ID
>
> Name
>
> Contact_Informatio n
>
> Medical_History
>
> Registration_Date
>
> Status
>
> **Data** **Type**

NUMBER(10)

VARCHAR2(100 )

VARCHAR2(200 )

CLOB

TIMESTAMP

VARCHAR2(20)

> **Constraints**

PK, NOT NULL, AUTO_INCREMENT

NOT NULL

NOT NULL

NULL

DEFAULT SYSTIMESTAMP, NOT NULL

DEFAULT 'Active',

CHECK

> **Descriptio** **n**

Unique patient identifier

Patient full legal name

Phone and email

Previous medical conditions and surgeries

Account creation timestamp

Account

status

> **Example**

1001

Jean Claude MUGISHA

Phone: +25078812345 6, Email: jc@email.rw

Hypertension since 2015, Type 2 Diabetes

2024-01-15 10:30:00

Active, Inactive,

Suspended

**Business** **Rules**:

> ● Contact_Information must include at minimum phone number
>
> ● Medical_History can be updated by patient or doctor
>
> ● Status 'Suspended' requires admin approval to reactivate ●
> Auto-increment Patient_ID starts at 1001

**Indexes**:

> ● idx_patient_name ON Name (for search)
>
> ● idx_patient_status ON Status (for filtering active patients)

**3.2** **TABLE:** **DOCTOR**

**Description**: Healthcare provider credentials, specialties, and
availability **Primary** **Key**: Doctor_ID

**Foreign** **Keys**: None

**Relationships**: Referenced by Daily_Report, Appointment, Medication,
Notification

> **Column** **Name**
>
> Doctor_ID
>
> Name
>
> Specialty
>
> Contact_Informa tion
>
> Years_Experienc e
>
> Registration_Dat e
>
> Status
>
> **Data** **Type**

NUMBER(10)

VARCHAR2(1 00)

VARCHAR2(1 00)

VARCHAR2(2 00)

NUMBER(2)

TIMESTAMP

VARCHAR2(2

0\)

> **Constraints**

PK, NOT NULL, AUTO_INCREME NT

NOT NULL

NOT NULL

NULL

CHECK (\>= 0 AND \<= 50)

DEFAULT SYSTIMESTAMP, NOT NULL

DEFAULT 'Active',

CHECK

> **Description**

Unique doctor identifier

Doctor full legal name

Medical specialty/depart ment

Phone and email

Years in medical practice

Account creation timestamp

Account

availability status

> **Example**

2001

Dr. Alice MUKAMANA

Cardiology

Phone: +250788111222, Email: dr.alice@hospita l.rw

12

2023-06-10 14:20:00

Active, Inactive,

On Leave

**Business** **Rules**:

> ● Specialty must match predefined list (enforced at application layer)
> ● Years_Experience cannot exceed 50 (reasonable limit)
>
> ● Status 'On Leave' prevents new appointment scheduling ●
> Contact_Information required for active doctors

**Indexes**:

> ● idx_doctor_specialty ON Specialty (for finding doctors by specialty)
> ● idx_doctor_name ON Name (for search)
>
> ● idx_doctor_status ON Status (for filtering available doctors)

**3.3** **TABLE:** **DAILY_REPORT**

**Description**: Patient daily health reports with vitals, symptoms, and
review status **Primary** **Key**: Report_ID

**Foreign** **Keys**:

> ● Patient_ID → Patient(Patient_ID)
>
> ● Reviewed_By_Doctor → Doctor(Doctor_ID)

**Relationships**:

> ● Many-to-One with Patient
>
> ● Many-to-One with Doctor (optional)
>
> **Column** **Name**
>
> Report_ID
>
> Patient_ID
>
> Report_Date
>
> Symptoms
>
> **Data** **Type**

NUMBER(10)

NUMBER(10)

DATE

CLOB

> **Constraints**

PK, NOT NULL, AUTO_INCREMEN T

FK, NOT NULL, INDEX

DEFAULT SYSDATE, NOT NULL

NOT NULL

> **Description**

Unique report identifier

Reference to Patient table

Date of health report

Patient-reported

symptoms

> **Example**

3001

1001

2024-12-0 1

Mild headache , fatigue,

dizziness

> Medication
>
> Temperature
>
> Blood_Pressure
>
> Heart_Rate
>
> Submission_Time
>
> Reviewed_By_Doct or
>
> Review_Date
>
> Urgency_Level

VARCHAR2(500 )

NUMBER(4,1)

VARCHAR2(20)

NUMBER(3)

TIMESTAMP

NUMBER(10)

TIMESTAMP

VARCHAR2(20)

NULL

CHECK (\>= 30.0 AND \<= 45.0)

NULL

CHECK (\>= 30 AND \<= 250)

DEFAULT SYSTIMESTAMP, NOT NULL

FK, NULL, INDEX

NULL

DEFAULT 'Normal',

CHECK

Medications taken that day

Body temperature in Celsius

Systolic/Diastoli c reading

Heart rate in beats per minute

Exact submission timestamp

Doctor who reviewed (NULL=pending )

When doctor reviewed report

Clinical urgency

classification

Metformin 500mg twice, Lisinopril 10mg

36.8

140/90

78

2024-12-0 1 8:15:30

2001

2024-12-0 1 14:30:00

Normal, Urgent, Emergenc

y

**Business** **Rules**:

> ● One patient can submit maximum one report per day (unique constraint
> on Patient_ID + TRUNC(Report_Date))
>
> ● Temperature range: 30.0°C to 45.0°C (abnormal values trigger
> automatic alerts) ● Heart_Rate range: 30 to 250 bpm (extreme values
> flagged)
>
> ● Urgency_Level: 'Emergency' triggers immediate doctor notification
>
> ● Review_Date must be \>= Report_Date (cannot review before
> submission) ● Reviewed_By_Doctor can be NULL (report pending review)

**Indexes**:

> ● idx_report_patient ON Patient_ID (for patient history queries) ●
> idx_report_date ON Report_Date (for date range queries)
>
> ● idx_report_doctor ON Reviewed_By_Doctor (for doctor workload
> queries) ● idx_report_urgency ON Urgency_Level (for urgent case
> filtering)

**3.4** **TABLE:** **APPOINTMENT**

**Description**: Appointment scheduling between patients and doctors
**Primary** **Key**: Appointment_ID

**Foreign** **Keys**:

> ● Patient_ID → Patient(Patient_ID) ● Doctor_ID → Doctor(Doctor_ID)

**Relationships**:

> ● Many-to-One with Patient ● Many-to-One with Doctor
>
> **Column** **Name**
>
> Appointment_ID
>
> Patient_ID
>
> Doctor_ID
>
> Appointment_Dat e
>
> Appointment_Tim e
>
> Reason
>
> Status
>
> **Data** **Type**

NUMBER(10)

NUMBER(10)

NUMBER(10)

DATE

VARCHAR2(10)

VARCHAR2(500 )

VARCHAR2(20)

> **Constraints**

PK, NOT NULL, AUTO_INCREMENT

FK, NOT NULL, INDEX

FK, NOT NULL, INDEX

NOT NULL

NOT NULL

NULL

DEFAULT

'Scheduled', CHECK

> **Description**

Unique appointment identifier

Reference to Patient table

Reference to Doctor table

Date of appointment

Appointment time slot

Purpose of appointment

Appointment

status

> **Example**

4001

1001

2001

2024-12-05

14:30

Follow-up for diabetes management

Scheduled, Completed, Cancelled,

No Show

> Created_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
>
> NOT NULL

When appointment

was booked

2024-11-28

9:15:00

**Business** **Rules**:

> ● No double-booking: UNIQUE constraint on (Doctor_ID,
> Appointment_Date, Appointment_Time)
>
> ● Appointment_Date should be \>= SYSDATE (future dates, enforced at
> application layer) ● Status transitions: Scheduled →
> Completed/Cancelled/No Show
>
> ● Cancelled appointments cannot be reactivated (must create new) ●
> Appointment_Time in HH:MM format (e.g., "14:30")

**Indexes**:

> ● idx_appt_patient ON Patient_ID (for patient appointment history) ●
> idx_appt_doctor ON Doctor_ID (for doctor schedule)
>
> ● idx_appt_date ON Appointment_Date (for date-based queries) ●
> idx_appt_status ON Status (for filtering by status)

**Unique** **Constraint**:

> ● uq_doctor_time ON (Doctor_ID, Appointment_Date, Appointment_Time) -
> Prevents double-booking

**3.5** **TABLE:** **MEDICATION**

**Description**: Medication prescriptions and management tracking
**Primary** **Key**: Medication_ID

**Foreign** **Keys**:

> ● Patient_ID → Patient(Patient_ID) ● Doctor_ID → Doctor(Doctor_ID)

**Relationships**:

> ● Many-to-One with Patient ● Many-to-One with Doctor
>
> **Column** **Name**
>
> Medication_ID
>
> **Data** **Type**

NUMBER(10)

> **Constraints**

PK, NOT NULL,

AUTO_INCREMENT

> **Description**

Unique medication

record ID

> **Example**

5001

> Patient_ID
>
> Doctor_ID
>
> Medication_Nam e
>
> Dosage
>
> Frequency
>
> Start_Date
>
> End_Date
>
> Status

NUMBER(10)

NUMBER(10)

VARCHAR2(200 )

VARCHAR2(100 )

VARCHAR2(100 )

DATE

DATE

VARCHAR2(20)

FK, NOT NULL, INDEX

FK, NOT NULL, INDEX

NOT NULL

NOT NULL

NULL

DEFAULT SYSDATE, NOT NULL

NULL, CHECK (\>= Start_Date)

DEFAULT 'Active',

CHECK

Reference to Patient table

Reference to Doctor (prescriber)

Name of medication/drug

Dosage amount and form

How often to take

Date to begin medication

Date to stop medication (NULL=ongoing)

Prescription

status

1001

2001

Metformin

500mg tablets

Twice daily with meals

2024-01-15

2024-07-15

Active, Completed, Discontinue

d

**Business** **Rules**:

> ● End_Date must be \>= Start_Date (if provided)
>
> ● End_Date NULL means ongoing/chronic medication
>
> ● Status 'Discontinued' requires reason (enforced at application
> layer)
>
> ● Medication_Name should reference drug database (future enhancement)
> ● Active medications counted for patient adherence metrics

**Indexes**:

> ● idx_med_patient ON Patient_ID (for patient medication list) ●
> idx_med_doctor ON Doctor_ID (for prescriptions by doctor) ●
> idx_med_status ON Status (for active medication queries)

**3.6** **TABLE:** **NOTIFICATION**

**Description**: System notifications, alerts, and reminders for
patients and doctors **Primary** **Key**: Notification_ID

**Foreign** **Keys**:

> ● Patient_ID → Patient(Patient_ID) (optional) ● Doctor_ID →
> Doctor(Doctor_ID) (optional)

**Relationships**:

> ● Many-to-One with Patient (optional) ● Many-to-One with Doctor
> (optional)
>
> **Column** **Name**
>
> Notification_ID
>
> Patient_ID
>
> Doctor_ID
>
> Notification_Typ e
>
> Message
>
> Is_Read
>
> Created_Date
>
> Sent_Date
>
> **Data** **Type**

NUMBER(10)

NUMBER(10)

NUMBER(10)

VARCHAR2(20)

CLOB

NUMBER(1)

TIMESTAMP

TIMESTAMP

> **Constraints**

PK, NOT NULL, AUTO_INCREMENT

FK, NULL, INDEX

FK, NULL, INDEX

NOT NULL, CHECK

NOT NULL

DEFAULT 0, CHECK (0 or 1)

DEFAULT SYSTIMESTAMP, NOT NULL

NULL

> **Description**

Unique notification identifier

Patient recipient (if applicable)

Doctor recipient (if applicable)

Type of notification

Notification message content

Read status: 0=unread, 1=read

When notification was created

When notification was

delivered

> **Example**

6001

1001

2001

Reminder, Alert, Communication

Time to submit your daily health report

0

2024-12-01 6:00:00

2024-12-01

6:00:15

**Business** **Rules**:

> ● Either Patient_ID or Doctor_ID must be NOT NULL (CHECK constraint)
>
> ● Cannot target both patient and doctor simultaneously (one recipient
> per notification) ● Notification_Type: 'Reminder' (daily report),
> 'Alert' (urgent case), 'Communication'
>
> (general)
>
> ● Is_Read: 0 (false/unread), 1 (true/read) - boolean stored as
> NUMBER(1) ● Sent_Date tracks delivery time for monitoring purposes

**Indexes**:

> ● idx_notif_patient ON Patient_ID (for patient notifications) ●
> idx_notif_doctor ON Doctor_ID (for doctor notifications) ●
> idx_notif_type ON Notification_Type (for filtering by type) ●
> idx_notif_read ON Is_Read (for unread notifications)

**Check** **Constraint**:

> ● chk_notif_recipient CHECK (Patient_ID IS NOT NULL OR Doctor_ID IS
> NOT NULL) -Ensures at least one recipient
