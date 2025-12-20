# MBERA MUGANGA HEALTHCARE SYSTEM
## PHASE II: Business Process Modeling (BPMN)


## 1. BUSINESS PROCESS SCOPE

**Process Name:** Remote Patient Healthcare Monitoring and Management

**MIS Relevance:** This healthcare information system supports clinical decision-making, patient engagement, resource allocation, and operational efficiency for remote healthcare delivery.

**Primary Objectives:**
- Enable continuous patient health monitoring without physical hospital visits
- Facilitate asynchronous doctor-patient communication
- Automate appointment scheduling and conflict resolution
- Ensure timely medical intervention for urgent cases
- Maintain comprehensive electronic health records

**Expected Outcomes:**
- Reduced unnecessary hospital visits (target: 40% reduction)
- Improved chronic disease management through daily monitoring
- Faster response time for urgent medical cases (target: <2 hours)
- Increased doctor efficiency through prioritized workload
- Enhanced patient engagement and medication adherence

---

## 2. KEY ENTITIES AND ROLES

### Actors and Responsibilities

**1. PATIENT (Healthcare Consumer)**
- **Registration:** Provide personal information, medical history, emergency contacts
- **Daily Reporting:** Submit daily health reports with vitals (temperature, blood pressure, heart rate)
- **Symptom Documentation:** Describe current symptoms and medications taken
- **Appointment Management:** Schedule consultations with available doctors
- **Compliance:** Follow prescribed medication regimens and report adherence

**2. MBERA MUGANGA SYSTEM (Automated MIS)**
- **Data Validation:** Verify completeness and validity of all inputs
- **Storage:** Persist patient data, reports, appointments, medications in Oracle database
- **Notification Management:** Send reminders, alerts, and confirmations via SMS/email
- **Urgency Analysis:** Automatically classify cases based on vital sign thresholds
- **Conflict Detection:** Prevent double-booking and validate appointment slots
- **Audit Logging:** Track all system activities for compliance and analysis

**3. DOCTOR (Healthcare Provider)**
- **Report Review:** Evaluate patient daily reports and clinical trends
- **Clinical Assessment:** Analyze vital signs, symptoms, and medical history
- **Urgency Triage:** Prioritize emergency and urgent cases for immediate attention
- **Documentation:** Add clinical comments and recommendations to reports
- **Consultation:** Conduct in-person or telemedicine appointments
- **Prescription Management:** Prescribe medications with dosage and frequency instructions

---

## 3. BUSINESS PROCESS FLOW (BPMN SWIMLANES)

### 3.1 Registration Process

**Swimlane 1: Patient**
1. Access Mbera Muganga system via web/mobile app
2. Enter registration information (name, contact, medical history)

**Swimlane 2: System**
3. Validate registration data completeness
4. **Decision:** Data complete?
   - **No:** Send error message → Patient corrects → Return to validation
   - **Yes:** Store patient profile in database → Send confirmation

**Outcome:** Patient account created, assigned unique Patient_ID

---

### 3.2 Daily Health Reporting Process

**Swimlane 1: System (Trigger)**
1. Daily timer event (8:00 AM)
2. Send reminder notification to all active patients

**Swimlane 2: Patient**
3. Receive reminder (SMS/push notification)
4. Fill daily health report form:
   - Enter vital signs (temperature, blood pressure, heart rate)
   - Describe current symptoms
   - List medications taken today
5. Submit report

**Swimlane 3: System (Validation & Storage)**
6. Check report completeness
7. **Decision:** Report complete and valid?
   - **No:** Prompt patient to complete → Return to form
   - **Yes:** Validate vital signs against normal ranges
8. Store report in Daily_Report table
9. Analyze urgency based on vital thresholds:
   - Temperature >38.5°C or <35°C → Urgent
   - Heart rate >120 or <50 → Urgent
   - Blood pressure >180/110 → Emergency

**Swimlane 4: System (Notification)**
10. **Decision:** Is case urgent?
    - **Normal:** Send standard notification to assigned doctor
    - **Urgent/Emergency:** Send URGENT ALERT to doctor (SMS + email)

**Outcome:** Report stored, doctor notified

---

### 3.3 Doctor Review and Clinical Decision Process

**Swimlane 1: Doctor**
1. Receive new report alert (email/dashboard notification)
2. Review patient report and medical history
3. Check vital signs trends over time (last 30 days)
4. **Decision:** Is issue urgent?
   - **Yes:** Mark case as URGENT (flag in system)
   - **No:** Proceed to standard review

**Swimlane 2: Doctor (Clinical Action)**
5. Add clinical comments and recommendations
6. **Decision:** Action needed?
   - **Schedule Appointment:** Proceed to appointment booking
   - **Add Comments Only:** Update report as REVIEWED → End

**Swimlane 3: System**
7. Store doctor's comments in Daily_Report.Doctor_Comments
8. Update Review_Date timestamp
9. Mark report as reviewed

**Outcome:** Patient receives feedback, clinical decision documented

---

### 3.4 Appointment Scheduling Process

**Swimlane 1: Patient (or Doctor initiates)**
1. View available doctors (filtered by specialty)
2. Select doctor and time slot
3. Provide reason for visit

**Swimlane 2: System**
4. Check appointment conflicts (same doctor, same time)
5. **Decision:** Doctor available?
   - **No:** Send conflict message → Patient selects different time
   - **Yes:** Store appointment in database

**Swimlane 3: System (Confirmation)**
6. Send appointment confirmation to patient (SMS + email)
7. Send confirmation to doctor
8. Set reminder timer (24 hours before appointment)

**Outcome:** Appointment scheduled, both parties notified

---

### 3.5 Consultation and Medication Prescription Process

**Swimlane 1: System**
1. Send reminder 24 hours before appointment
2. Send reminder 1 hour before appointment

**Swimlane 2: Doctor**
3. Conduct patient consultation (in-person or telemedicine)
4. **Decision:** Prescription needed?
   - **Yes:** Prescribe medication
   - **No:** Mark appointment COMPLETED → End

**Swimlane 3: Doctor (Prescription)**
5. Enter medication details:
   - Medication name (e.g., Metformin)
   - Dosage (e.g., 500mg)
   - Frequency (e.g., twice daily with meals)
   - Duration (start date, end date)

**Swimlane 4: System**
6. Store prescription in Medication table
7. Link to Patient_ID and Doctor_ID
8. Mark appointment as COMPLETED

**Outcome:** Prescription recorded, patient can view in system

---

## 4. DECISION POINTS AND BRANCHES

**Key Gateways (XOR Decision Points):**

1. **Registration Valid?** (System)
   - Path A: No → Validation error → Correction loop
   - Path B: Yes → Profile created → Continue

2. **Report Complete?** (System)
   - Path A: No → Prompt completion → Re-submission loop
   - Path B: Yes → Stored → Urgency analysis

3. **Is Case Urgent?** (System - Automated)
   - Path A: Normal → Standard notification
   - Path B: Urgent/Emergency → Priority alert

4. **Is Issue Urgent?** (Doctor - Manual Assessment)
   - Path A: Yes → Mark urgent → Escalate
   - Path B: No → Routine handling

5. **Action Needed?** (Doctor)
   - Path A: Schedule Appointment → Booking process
   - Path B: Comments Only → Review complete

6. **Doctor Available?** (System)
   - Path A: No → Conflict message → Reschedule
   - Path B: Yes → Appointment confirmed

7. **Prescription Needed?** (Doctor)
   - Path A: Yes → Medication entry → Database storage
   - Path B: No → Appointment complete

---

## 5. DATA FLOWS AND HANDOFFS

**Critical Data Handoff Points:**

1. **Patient → System:** Registration data, daily reports, appointment requests
2. **System → Patient:** Validation errors, reminders, confirmations
3. **System → Doctor:** New report notifications, urgent alerts, appointment schedule
4. **Doctor → System:** Clinical comments, urgency flags, prescriptions
5. **System → Database:** All persistent data (CREATE, UPDATE operations)

**Data Stored in Database:**
- Patient profile (Patient table)
- Daily health reports (Daily_Report table)
- Doctor reviews and comments (Daily_Report table)
- Appointments (Appointment table)
- Medications (Medication table)
- Notifications (Notification table)

---

## 6. MIS FUNCTIONS SUPPORTED

**Operational Functions:**
- **Patient Registration and Profile Management:** Onboard new patients, maintain demographics
- **Daily Health Data Collection:** Capture vital signs and symptoms consistently
- **Clinical Review Workflow:** Route reports to appropriate doctors for review
- **Appointment Scheduling:** Manage doctor availability and patient bookings
- **Prescription Management:** Track medications and refills

**Analytical Functions:**
- **Trend Analysis:** Identify patterns in patient vital signs over time
- **Urgency Classification:** Automatically flag cases requiring immediate attention
- **Workload Distribution:** Balance patient cases across available doctors
- **Compliance Monitoring:** Track patient adherence to daily reporting and medications
- **Performance Metrics:** Measure doctor response times and patient engagement

**Decision Support:**
- **Risk Stratification:** Identify high-risk patients based on vital sign trends
- **Resource Allocation:** Optimize doctor scheduling based on case urgency
- **Predictive Alerts:** Warn of potential health deterioration before critical events
- **Outcome Tracking:** Measure effectiveness of interventions over time

---

## 7. ORGANIZATIONAL IMPACT

**For Patients:**
- **Convenience:** Submit reports from home, reducing travel and wait times
- **Empowerment:** Active participation in health monitoring and management
- **Continuity:** Consistent tracking of health status over time
- **Safety:** Faster identification and response to urgent medical issues

**For Doctors:**
- **Efficiency:** Prioritized workload with urgent cases flagged automatically
- **Insights:** Access to longitudinal patient data for better clinical decisions
- **Flexibility:** Review reports asynchronously without fixed appointment times
- **Documentation:** Comprehensive electronic records reduce paperwork

**For Healthcare Organizations:**
- **Cost Reduction:** Fewer unnecessary in-person visits and emergency room admissions
- **Quality Improvement:** Better chronic disease management through continuous monitoring
- **Capacity Expansion:** Serve more patients with same number of doctors
- **Data-Driven Management:** Analytics for resource planning and quality metrics

**For Healthcare System (Rwanda):**
- **Access:** Extend healthcare reach to rural and underserved populations
- **Prevention:** Early detection of complications reduces hospitalizations
- **Efficiency:** Better utilization of limited healthcare resources
- **Scalability:** Digital platform can grow to national coverage

---

## 8. ANALYTICS OPPORTUNITIES

**Real-Time Analytics:**
- Dashboard showing pending urgent cases (count, patient names, submission times)
- Doctor workload visualization (reports pending per doctor)
- System usage metrics (reports submitted today, appointments scheduled)

**Trend Analytics:**
- Patient vital sign trends (line charts showing temperature, BP, HR over 30/60/90 days)
- Symptom frequency analysis (word cloud of most common symptoms)
- Medication adherence rates (% of patients taking medications as prescribed)

**Predictive Analytics:**
- Risk scoring: Predict which patients likely to have complications in next 30 days
- No-show prediction: Identify appointments at high risk of cancellation
- Medication non-adherence prediction: Flag patients likely to stop taking medications

**Performance Analytics:**
- Average doctor response time (submission to review)
- Patient engagement score (daily report submission consistency)
- Appointment utilization rate (completed vs. scheduled)
- System uptime and reliability metrics

---

## 9. BPMN NOTATION USED

**Elements in Diagram:**

| Symbol | Element Type | Meaning | Example |
|--------|--------------|---------|---------|
| ○ | Start Event | Process initiation | Patient needs monitoring |
| ◆ | Gateway (XOR) | Decision point | Data valid? |
| □ | Task | Activity performed | Validate data |
| ⬬ | Data Store | Database operation | Store in DB |
| ⊙ | End Event | Process termination | Report reviewed |
| ⏰ | Timer Event | Scheduled trigger | Daily 8:00 AM |
| ✉ | Message Event | Notification/alert | Send reminder |

**Swimlanes:**
- **Patient Pool:** 3 lanes (Registration, Daily Reporting, Appointment Management)
- **System Pool:** 2 lanes (Validation & Storage, Notifications & Scheduling)
- **Doctor Pool:** 2 lanes (Review & Decision, Appointment & Medication)

**Flow Types:**
- **Solid arrows:** Standard sequence flow
- **Dotted arrows:** Message flow (notifications, data passing between actors)

---

## 10. CONCLUSION

The Mbera Muganga business process model demonstrates a comprehensive **Management Information System** that:

✅ **Automates routine tasks** (reminders, validation, storage)  
✅ **Facilitates collaboration** between patients and doctors  
✅ **Supports clinical decision-making** with data and analytics  
✅ **Ensures data integrity** through validation and constraints  
✅ **Enables scalability** with digital-first architecture  


