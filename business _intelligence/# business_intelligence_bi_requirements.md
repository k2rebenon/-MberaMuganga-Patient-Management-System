Business Intelligence (BI) in Your Capstone Project
Business Intelligence (BI) refers to the strategies, technologies, and processes for collecting, analyzing, and presenting data to support better decision-making. In your MBERA MUGANGA project (and the INSY 8311 capstone), BI is not about full tools like Oracle BI Enterprise Edition or Power BI. Instead, it focuses on database-level analytics using Oracle PL/SQL features to prepare data for reporting and insights.
Key BI Requirements (from Project PDF, Phase VIII – Optional +2 Marks)

Define KPIs that matter (e.g., % High-Risk patients).
Identify decision support needs and stakeholders.
Specify reporting frequency (real-time, weekly, monthly).
Provide dashboard mockups (minimum 3: Executive Summary, Audit, Performance).
Include analytical queries (using aggregations and window functions).

Your project implements BI through:

Fact/Dimension Tables (Phase III): DAILY_READINGS (fact – time-series measurements), PATIENTS/DOCTORS (dimensions).
Advanced Queries (Phase VI/VIII): Window functions (LAG/LEAD for trends, ROW_NUMBER for ranking, rolling averages), GROUP BY for summaries (e.g., weekly BP by NCD type).
Automation: Triggers/procedures generate risk logs and trends in real-time.
Outputs: Mockups (ASCII/text descriptions + PPT charts), .md files, and executable SQL queries.

How Your MBERA MUGANGA Aligns with Real-World Needs (Rwanda NCD Surveillance)
Rwanda's National NCD Strategy (2020–2025) aims to reduce premature NCD mortality by 25% by 2025, using DHIS2 for digital tracking (launched 2022, screening rates >91%). Your system complements this:

Real-time risk stratification → early alerts (like DHIS2 screenings).
Aggregated KPIs → supports MoH/RBC national reports (e.g., High-Risk % by doctor/district).
Audit trails → compliance monitoring.

Your BI turns raw readings into actionable intelligence for doctors (daily alerts) and policymakers (monthly trends).
Your Completed BI Files (All Done!)

bi_requirements.md — KPIs, stakeholders, frequency.
kpi_definitions.md — Table with calculations.
dashboards.md — 4 mockups (Executive, Audit, Performance, NCD Analytics).
analytical_queries.sql — 7+ queries with window/aggregations
