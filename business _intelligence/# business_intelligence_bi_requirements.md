\# business_intelligence/bi_requirements.md

Business Intelligence Requirements

MBERA MUGANGA HEALTH CARE SYSTEM (The Doctor’s Helper)


 December 21, 2025
 1. KPIs That Matter

These Key Performance Indicators directly support preventive care and
national NCD management in Rwanda.

\| KPI \| Definition \| Target \| Importance \|

\|-----------------------------------\|----------------------------------------------------------------------------\|-------------------------\|------------\|

\| % Patients in High-Risk Zone \| Percentage of active patients with at
least one "High Risk" assessment in the last 7 days \| \< 10% weekly \|
Early warning effectiveness \|

\| Average Risk Score (Weekly) \| Average numeric risk (Good=1,
Medium=2, High=3) per patient over 7 days \| \< 1.8 \| Overall
population control \|

\| Alert Response Time \| Average hours from High-Risk assessment to
doctor action (future audit) \| \< 24 hours \| Speed of intervention \|

\| Crises Prevented Rate \| % of High-Risk cases followed by "IMPROVING"
trend in next 7 days \| \> 60% \| Proof of preventive impact \|

\| Patient Monitoring Consistency \| % of patients with ≥5 readings per
week \| \> 80% \| Data quality & adherence \|

\| High-Risk Count per Doctor \| Number of High-Risk assessments per
doctor per month \| \< 20 per doctor/month \| Workload balancing \|

\## 2. Decision Support Needs

\- \*\*Doctors/Clinics:\*\* Real-time view of high-risk patients, weekly
trend summaries, and priority lists for follow-up calls or visits.

\- \*\*Community Health Workers:\*\* Simple feedback on data entry
quality and patient consistency. - \*\*Ministry of Health / Rwanda
Biomedical Centre (RBC):\*\* Aggregated national/regional trends for NCD
surveillance and resource allocation.

\- \*\*Hospital Administrators:\*\* Doctor workload monitoring and early
detection performance.

\## 3. Stakeholders

\| Stakeholder \| Role \| BI Needs \|

\|-----------------------------------\|-------------------------------------------\|---------------------------------------\|

\| Doctors & Nurses \| Primary care providers \| Daily alerts, patient
trends, weekly reports \|

\| Patients & Community Health Workers \| Data entry & monitoring \|
Simple confirmation & consistency feedback \|

\| Clinic Managers \| Oversight \| Doctor performance & high-risk load
\|

\| Ministry of Health / RBC \| National policy & surveillance \|
Monthly/quarterly aggregates by district, age, gender \|

\| System Administrators \| Maintenance \| Audit logs of restricted
actions \|

\## 4. Reporting Frequency

\| Report Type \| Frequency \| Delivery Method \|
\|-----------------------------------\|-------------------\|----------------------------------\|

\| Real-time High-Risk Alerts \| Immediate (trigger) \| Flag in database
(future: email/SMS) \| \| Doctor Daily Dashboard \| Daily \| Query-based
view \|

\| Weekly Patient Trend Report \| Every Monday \| Automated PL/SQL
summary \| \| Clinic Performance Report \| Weekly \| Aggregated KPIs \|

\| National NCD Surveillance Report \| Monthly \| Exportable aggregates
(district, NCD type) \|

\## 5. Dashboard Mockups (Implemented in dashboards.md)

1.Executive Summary Dashboard\*\* – KPI cards + trend lines

2.Audit & Security Dashboard\*\* – Denied actions, restriction
violations

3.Performance & Resource Dashboard\*\* – SGA/PGA usage, query
performance

4. NCD Analytics Dashboard\*\* (Bonus) – Weekly averages by NCD
type, doctor load, retention trends

This BI implementation turns raw daily readings into actionable clinical
and public health intelligence, fully leveraging Oracle analytic
functions (LAG, LEAD, ROW_NUMBER, rolling aggregates) for real-time and
historical insights.

