# 🏥 Healthcare Data Analysis Dashboard

As someone with a background in Allied Health Sciences, I have always been curious about what happens to patient data beyond the lab — how it gets analyzed, what patterns it reveals, and how it drives decisions in healthcare. This project is my step toward bridging that gap.

I used the **Synthea synthetic dataset** because it closely mirrors real hospital data — covering patient demographics, clinical conditions, encounter types, and cost records — without any privacy concerns. My goal was to understand the structure of healthcare data and explore how condition trends, patient demographics, and costs interact with each other.

---

##  What I Wanted to Explore

- How are patients distributed across age groups, gender, and race?
- What does the burden of chronic vs resolved conditions look like?
- How do healthcare costs vary across age groups and encounter types?
- What share of costs are covered by payers vs paid out of pocket?

---

## 📊 Dashboard Pages

### 1. Patient Overview

> 117 patients analyzed — seniors show significantly higher average healthcare expenses (0.41M) compared to other age groups, driven by chronic and inpatient cases.

---

### 2. Conditions and Encounters

> Out of 4,023 total conditions, 70% were resolved and 30% are chronic. Ambulatory encounters dominate at 63%, with encounter volume peaking around 2018–2020.

---

### 3. Cost Analysis

> Total healthcare cost stands at 27.09M. Payer coverage absorbs 76% of costs — but patients still bear 24% out of pocket, highlighting a significant financial burden.

---

## 💡 Key Insights

- Seniors cost **13x more** on average than children due to chronic and inpatient conditions
- **70% of conditions resolve** — chronic disease management is still a major concern
- Despite payer coverage, **patients pay 24% out of pocket** — a meaningful gap
- **Ambulatory care** dominates encounters, reflecting outpatient-first healthcare delivery
- Encounter volume shows a sharp rise post-2000, peaking near 2020

---

##  Tools Used

| Tool | Purpose |
|------|---------|
| PostgreSQL | Data extraction, joins, aggregations, CTEs |
| Power BI | Interactive dashboards, DAX measures, visual storytelling |
| Synthea | Synthetic patient dataset mirroring real hospital records |

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `Healthcare_dataset.sql` | SQL queries used for data extraction and analysis |
| `healthcare_synthe.pbix` | Power BI dashboard (open in Power BI Desktop) |
| `screenshots/` | Dashboard preview images |

---

##  Dataset

- **117 patients** | **4,023 conditions** | **8,316 encounters**
- Source: [Synthea by MITRE](https://synthea.mitre.org/) — open-source synthetic patient data that realistically models real-world hospital records

---

##  What I Learned

Working with this dataset gave me a much clearer picture of how healthcare data is structured in the real world — from patient encounters and condition codes to cost breakdowns by payer. It also strengthened my ability to ask the right analytical questions and translate data into insights that matter in a clinical context.

---

*Built by [Vandana Hegde](https://www.linkedin.com/in/vandanagh) —  exploring the intersection of healthcare and data analytics*
