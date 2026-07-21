# Healthcare Data Analysis Dashboard

## Business Problem
Healthcare administrators and payers need visibility into how costs, chronic disease burden, and encounter types vary across patient demographics, in order to plan resources and understand where financial strain falls hardest — on the system or on the patient. This analysis explores patient demographics, condition trends, and cost breakdowns using a realistic synthetic hospital dataset, with a particular focus on how much of the cost burden patients carry themselves versus what payers absorb.

## Dataset
- **Source:** [Synthea by MITRE](https://synthea.mitre.org/) — open-source synthetic patient dataset that realistically models real-world hospital records, with no privacy concerns
- **Size:** 117 patients, 4,023 conditions, 8,316 encounters
- **Key variables:** patient demographics (age, gender, race), condition type and status (chronic vs. resolved), encounter type, healthcare costs, payer coverage vs. out-of-pocket cost

## Tools & Technologies
- **PostgreSQL** — data extraction, joins, aggregations, CTEs
- **Power BI** — interactive dashboards, DAX measures

## Key Questions Answered
1. How are patients distributed across age groups, gender, and race?
2. What does the burden of chronic vs. resolved conditions look like?
3. How do healthcare costs vary across age groups and encounter types?
4. What share of costs are covered by payers vs. paid out of pocket by patients?

## Key Findings
- **Seniors cost roughly 13x more on average than children** (average expense of 0.41M vs. far lower for younger age groups), driven by chronic and inpatient cases.
- **70% of conditions resolve, while 30% are chronic** — out of 4,023 total conditions — indicating chronic disease management remains a significant ongoing concern despite the majority resolving.
- **Ambulatory (outpatient) encounters dominate at 63%** of all encounter types, reflecting an outpatient-first pattern of care delivery. Encounter volume rose sharply after 2000, peaking around 2018–2020.
- **Total healthcare cost across the dataset is 27.09M**, with payer coverage absorbing 76% of that — but patients still carry **24% out of pocket**, a meaningful financial burden despite insurance coverage.

## Business Recommendations
1. **Prioritize chronic disease management programs for senior patients**, given they drive disproportionately higher costs (13x children) tied to chronic and inpatient care.
2. **Review out-of-pocket cost exposure for patients**, since a 24% patient-borne share — even with payer coverage in place — represents a real financial burden worth addressing through payer negotiation or assistance programs.
3. **Continue investing in ambulatory/outpatient care infrastructure**, since it already accounts for the majority of encounters and reflects where care delivery is concentrated.

## Dashboard / Visualisations
Three pages:

1. **Patient Overview** — patient demographics and average costs by age group
2. **Conditions and Encounters** — chronic vs. resolved condition breakdown, encounter type distribution, and encounter volume trends over time
3. **Cost Analysis** — total healthcare costs, payer coverage vs. out-of-pocket split

[Screenshot or link to dashboard]

## A Note on Methodology
Working with this dataset clarified how healthcare data is structured in the real world — from patient encounters and condition codes to cost breakdowns by payer — and sharpened the ability to ask analytical questions that translate into insights with real clinical and financial relevance, rather than just descriptive statistics.
