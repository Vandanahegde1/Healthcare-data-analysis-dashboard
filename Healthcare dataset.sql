-- ============================================================
-- Schema + COPY commands for loading the 4 CSV files
-- Run this inside psql or pgAdmin after placing the CSVs
-- in a folder your PostgreSQL server can read.
-- ============================================================

-- 1. PATIENTS
CREATE TABLE IF NOT EXISTS patients (
    id                   TEXT PRIMARY KEY,
    birthdate            TEXT,
    deathdate            TEXT,
    ssn                  TEXT,
    drivers              TEXT,
    passport             TEXT,
    prefix               TEXT,
    first                TEXT,
    middle               TEXT,
    last                 TEXT,
    suffix               TEXT,
    maiden               TEXT,
    marital              TEXT,
    race                 TEXT,
    ethnicity            TEXT,
    gender               TEXT,
    birthplace           TEXT,
    address              TEXT,
    city                 TEXT,
    state                TEXT,
    county               TEXT,
    fips                 TEXT,
    zip                  TEXT,
    lat                  DOUBLE PRECISION,
    lon                  DOUBLE PRECISION,
    healthcare_expenses  DOUBLE PRECISION,
    healthcare_coverage  DOUBLE PRECISION,
    income               DOUBLE PRECISION
);

-- 2. ENCOUNTERS
CREATE TABLE IF NOT EXISTS encounters (
    id                   TEXT PRIMARY KEY,
    start                TIMESTAMP,
    stop                 TIMESTAMP,
    patient              TEXT REFERENCES patients(id),
    organization         TEXT,
    provider             TEXT,
    payer                TEXT,
    encounterclass       TEXT,
    code                 TEXT,
    description          TEXT,
    base_encounter_cost  DOUBLE PRECISION,
    total_claim_cost     DOUBLE PRECISION,
    payer_coverage       DOUBLE PRECISION,
    reasoncode           TEXT,
    reasondescription    TEXT
);

-- 3. CONDITIONS
CREATE TABLE IF NOT EXISTS conditions (
    id          SERIAL PRIMARY KEY,
    start       TEXT,
    stop        TEXT,
    patient     TEXT REFERENCES patients(id),
    encounter   TEXT REFERENCES encounters(id),
    system      TEXT,
    code        TEXT,
    description TEXT
);

-- 4. MEDICATIONS
CREATE TABLE IF NOT EXISTS medications (
    id                SERIAL PRIMARY KEY,
    start             TIMESTAMP,
    stop              TIMESTAMP,
    patient           TEXT REFERENCES patients(id),
    payer             TEXT,
    encounter         TEXT REFERENCES encounters(id),
    code              TEXT,
    description       TEXT,
    base_cost         DOUBLE PRECISION,
    payer_coverage    DOUBLE PRECISION,
    dispenses         INTEGER,
    totalcost         DOUBLE PRECISION,
    reasoncode        TEXT,
    reasondescription TEXT
);

DROP TABLE IF EXISTS conditions;

CREATE TABLE IF NOT EXISTS conditions (
    start TEXT,
    stop TEXT,
    patient TEXT REFERENCES patients(id),
    encounter TEXT REFERENCES encounters(id),
    system TEXT,
    code TEXT,
    description TEXT
);

DROP TABLE IF EXISTS medications;

CREATE TABLE medications (
    start TEXT,
    stop TEXT,
    patient TEXT REFERENCES patients(id),
    payer TEXT,
    encounter TEXT REFERENCES encounters(id),
    code TEXT,
    description TEXT,
    base_cost DOUBLE PRECISION,
    payer_coverage DOUBLE PRECISION,
    dispenses INTEGER,
    totalcost DOUBLE PRECISION,
    reasoncode TEXT,
    reasondescription TEXT
);


COPY patients FROM 'C:/data/patients.csv' CSV HEADER;

COPY encounters FROM 'C:/data/encounters.csv' CSV HEADER;

COPY conditions FROM 'C:/data/conditions.csv' CSV HEADER NULL '';

COPY medications FROM 'C:/data/medications.csv' CSV HEADER NULL '';

-------------------------------------------------------------
Cleaning patients table
-------------------------------------------------------------
select * from patients;

alter table patients add column full_name TEXT;

update patients set full_name = first || '' ||last ;

ALTER TABLE patients
DROP COLUMN ssn,
DROP COLUMN drivers,
DROP COLUMN passport,
DROP COLUMN prefix,
DROP COLUMN suffix,
DROP COLUMN maiden,
DROP COLUMN fips,
DROP COLUMN lat,
DROP COLUMN lon,
DROP COLUMN first,
DROP COLUMN middle,
DROP COLUMN last;

update patients 
set marital = case
when marital ='M' then 'married'
when marital = 'S' then 'single'
when marital = 'W' then 'widowed'
when marital = 'D' then 'divorced'
else marital
end;

SELECT DISTINCT marital FROM patients;

alter table patients
alter column birth_date type DATE
using birth_date:: DATE;

alter table patients
alter column death_date type DATE
using death_date:: DATE;

alter table patients
rename column id to patient_id;

alter table patients
rename column birthplace to birth_place;

alter table patients
rename column birthdate to birth_date;

alter table patients
rename column deathdate to death_date;

SELECT * FROM patients LIMIT 5;

SELECT 
    patient_id,
    full_name,
    gender,
    race,
    birth_date,
    death_date,
    CASE 
        WHEN death_date IS NULL 
            THEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))
        ELSE 
            EXTRACT(YEAR FROM AGE(death_date::DATE, birth_date))
    END AS age
FROM patients;

-------------------------------------------------------------
Cleaning encounters table
-------------------------------------------------------------
select * from encounters;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(reasoncode) AS reasoncode_count,
    COUNT(reasondescription) AS reasondescription_count
FROM encounters;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'encounters'
ORDER BY ordinal_position;

alter table encounters
rename column patient to patient_id;

alter table encounters
rename column start to visit_start;

alter table encounters
rename column stop to visit_end;

alter table encounters
rename column id to encounter_id;

alter table encounters
rename column encounterclass to encounter_class;

alter table encounters
rename column reasoncode to reason_code;

alter table encounters
rename column reasondescription to reason_description;

-------------------------------------------------------------
Cleaning conditions table
-------------------------------------------------------------

select * from conditions;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'conditions';

SELECT 
    COUNT(*) AS total_rows,
    count(start)as start_count,
	count(stop)as stop_count
FROM conditions;

SELECT patient_id, encounter_id, code, start, COUNT(*) 
FROM conditions 
GROUP BY patient_id, encounter_id, code, start
HAVING COUNT(*) > 1;

alter table conditions
rename column patient to patient_id;

alter table conditions
rename column encounter to encounter_id;

alter table conditions
rename column start to condition_start;

alter table conditions
rename column stop to condition_end;

alter table conditions
alter column start type DATE
using start :: DATE;

alter table conditions
alter column stop type DATE
using stop :: DATE;

-------------------------------------------------------------
Cleaning medications table
-------------------------------------------------------------
select * from medications;

select column_name,data_type
from information_schema.columns
where table_name = 'medications';

select start, stop, patient_id, description, encounter_id
from medications
group by start, stop, patient_id, description, encounter_id
having count(*) > 1;

select 
    count(*) as total_rows,
	count(start)as total_start,
	count(stop)as total_stop
from medications;

alter table medications
alter column start type  TIMESTAMP
using start :: TIMESTAMP;

alter table medications
alter column stop type TIMESTAMP
using stop :: TIMESTAMP;

alter table medications
rename column patient to patient_id;

alter table medications
rename column start to medication_start;

alter table medications
rename column stop to medication_end;

alter table medications
rename column encounter to encounter_id;

alter table medications
rename column reasoncode to reason_code;

alter table medications
rename column reasondescription to reason_description;

alter table medications
rename column totalcost to total_cost;

alter table medications
rename column payer to payer_id;

---------------------------------------------------
--Basic analysis
--------------------------------------------------

--What is the gender distribution of patients?
select gender,
	   count(*)
from patients
group by  gender;


with distribution as ( select 
                        count(*)as total_count
						from patients)
							   
							   
select gender,
count(*)as gender_count,
round(count(*) * 100.0 / distribution.total_count,2)as percentage
from patients
cross join distribution
group by gender, total_count;

--What is the race and ethnicity breakdown of patients?
select race,
      ethnicity,
	  count(*)as patient_count
from patients
group by race,ethnicity;
	  


--What is the age distribution — grouped into buckets (0–18, 19–35, 36–60, 60+)?
select  patient_id,
        EXTRACT(YEAR FROM AGE(birth_date))::integer  AS age,
		case
             when EXTRACT(YEAR FROM AGE(current_date, birth_date))<= 18 THEN 'Child'
             when extract (year from age(current_date, birth_date)) between 19 and 35 then 'young_adult'
		     when extract (year from age(current_date, birth_date)) between 36 and 60 then 'adult'
             else 'senior'
			 end as age_group
from patients;

select * from patients;
Q4
--What is the marital status distribution of patients?
with total_counts as(select count(patient_id)as total_count
                     from patients),


distribution as (select marital,
                 count(patient_id)as patient_count
                 from patients
				 group by marital)

select d.marital,
       d.patient_count,
	   round(d.patient_count * 100.0 / t.total_count,2)as percentage
 from distribution d
 cross join total_counts t
 order by total_count desc;


Q5
--What are the avg, min, and max healthcare costs — broken down by gender and race?
select p.gender,
       p.race,
       round(avg(total_claim_cost)::numeric,2)as avg_cost,
	   min(total_claim_cost)as min_cost,
	   max(total_claim_cost)as max_cost
from patients p
join encounters e
on p.patient_id = e.patient_id
group by p.race,p.gender;



Q6
--How many patients are deceased vs alive? What is the avg age at death?

select patient_id,
        case
	    when death_date is null then 'alive'
		else 'deceased'
		end as information
from patients;


select 
round(avg(EXTRACT(YEAR FROM AGE(death_date,birth_date))),2) AS avg_ageof_death
from patients
where death_date is not null;


Q7
--What are the top 10 most common conditions across all patients?
select description as condition,
      count (*)as total_cases
from conditions
where description  ILIKE '%(disorder)%'
group by description
order by total_cases desc
limit 10;




Q8
--How many conditions are chronic (no end date) vs resolved (have end date)?

select
      case
	  when condition_end is null then 'chronic'
      else 'resolved'
	  end as disease_type,
	  count(*)as total_condition
from conditions
where description ILIKE '%disorder%'
group by disease_type;


Q9
--Which patients have the most conditions? (top 10 with patient name)
with ranked_patients as(select p.full_name,
                               p.patient_id,
                               count (*)as total_cases,
	                           dense_rank() over (order by count(*) desc) AS rnk
                        from conditions c
                        join patients p
                        on p.patient_id = c.patient_id
                        where c.description  ILIKE '%(disorder)%'
                        group by p.full_name,p.patient_id)

select *
from ranked_patients
where rnk <= 10;



Q10
What are the top 5 conditions per gender? (ranked within each gender group)

WITH base  as(select p.gender,
                     c.description,
               count(*) as total_cases
		       from patients p
			   join conditions c
			   on p.patient_id = c.patient_id
			   where description ILIKE '%disorder%'
			   group by p.gender,c.description),
			
ranked as (select *,
           dense_rank() over(partition by gender order by total_cases desc)as rnk
		   from base)

select *
from ranked
where rnk <= 5;

Q11
--What is the avg number of conditions per patient by age group?
with ranked_age as(select  
                   p.patient_id,
				   EXTRACT(YEAR FROM AGE(current_date, birth_date)) AS age
				   from patients p),
						
patient_condition as (select p.patient_id,	
                             case
							     when EXTRACT(YEAR FROM AGE(current_date, birth_date))<= 18 THEN 'Child'
                                 when extract (year from age(current_date, birth_date)) between 18 and 35 then 'young_adult'
								 when extract (year from age(current_date, birth_date)) between 36 and 60 then 'adult'
                             else 'senior'
							 end as age_group,
							 count(*) as total_conditions
							 from patients p
							 left join conditions c
							 on c.patient_id = p.patient_id
							 group by p.patient_id, p.birth_date)
				
select age_group,
        round(avg(total_conditions),2)as avg_conditions
from patient_condition
group by age_group;


Section 3
Encounters analysis
Q12
--What is the distribution of encounter types (wellness, ambulatory, emergency, etc.)?
select encounter_class,
       count(*)as total_encounters
from encounters
group by encounter_class
order by total_encounters desc;

Q13
--What are the avg, min, and max total claim costs by encounter class?

select 
       round(avg(total_claim_cost)::numeric,2)as avg_cost,
	   min(total_claim_cost)as min_cost,
	   max(total_claim_cost)as max_cost
from encounters
group by encounter_class
order by avg_cost desc;


Q14
--What are the top 10 most frequent reasons for encounters?
select reason_description,
       count(*)as total_description
from encounters
where reason_description is NOT NULL
group by reason_description
order by total_description desc
limit 10;


Q15
--How many encounters happened per year? (trend over time)
select EXTRACT(year from visit_start)as year,
       count(*)as total_encouters
from encounters
group by year
order by year asc;


Q16
--What is the running total of encounter costs per patient over time?
select patient_id,
       visit_start,
	   total_claim_cost,
	round(sum(total_claim_cost)
	over(partition by patient_id order by visit_start, encounter_id)::numeric,2)as running_total
from encounters;


Q17
--Which patients have the highest number of encounters? (ranked using window function)
with patient_encounter as(select patient_id,
                                count(*)as encounter_count
						  from encounters
						  group by patient_id),

ranked as (select patient_id,
                 encounter_count,
                  rank()over( order by  encounter_count desc)as rnk
             from patient_encounter)
				  
select *
from ranked
where rnk = 1




Q18
--What is the average payer coverage % by encounter class? (how much insurance covers)
select  encounter_class,
	   round((avg(payer_coverage / total_claim_cost) * 100.0)::numeric,2)as coverage_percentage
from encounters
group by encounter_class;


Section 4
select * from medications;
Medications analysis
Q19
--What are the top 10 most prescribed medications?
select description,
       count(*)as description_count
from medications
group by description
order by description_count desc
limit 10;



Q20
--Total medication cost vs payer coverage — how much do patients pay out of pocket?
select  total_cost as medication_cost,
        payer_coverage,
	    round((base_cost - payer_coverage)::numeric,2) as remining_pay_cost
from medications;

		
Q21
--Which medications are ongoing (no stop date) vs completed?
 select description,
       case
	   when medication_end is null then 'ongoing'
       else 'completed'
end as medication_status,
count(*)as med_count
from medications
where description is not null
group by description,medication_status
order by med_count desc;


Q22
--What are the top 5 medications per reason/condition? (ranked within each reason)
with reason_medication as (select description as medication,
                                  reason_description as reason,
                                count(DISTINCT patient_id) as patient_count
                           from medications
						   where reason_description IS NOT NULL
                           group by reason_description, description
                           ),
                
ranked as (select *,
            dense_rank()over(partition by reason order by patient_count desc ) as rnk
			from reason_medication)


select * 
from ranked
where rnk <=5;

Q23
--Which patients have the highest total medication costs? (top 10 with names)
 with medication_cost as (select p.patient_id,
                                p.full_name,
                               round (sum(m.total_cost)::numeric,2)as final_cost
                          from patients p
                          join medications m
                          on p.patient_id = m.patient_id
                          group by p.patient_id,p.full_name),
 ranked as (select *,
           rank() over(order by final_cost desc)as rnk
		   from medication_cost)

select *
from ranked
where rnk <= 10;


Section 5
Healthcare cost analysis
Q24
--How do healthcare expenses vary across income brackets? (low / mid / high income)

Q25
--What is the avg healthcare expense and coverage by gender and race?
select  gender,
        race,
		round(avg(healthcare_expenses::numeric),2)as avg_expense,
        round(avg(healthcare_coverage::numeric),2)as avg_cover
from patients
group by race,gender;

		
Q26
--Rank all patients by total healthcare expenses using DENSE_RANK
with total_expense as( select patient_id,
                              sum(healthcare_expenses)as expense
						from patients
						group by patient_id),
                        
ranked as(select *,
dense_rank()over( order by expense desc)as rnk
from total_expense)

select *
from ranked
order by rnk;


Q27
--For each patient, what % of healthcare expenses is covered by insurance?
    SELECT 
    patient_id,
    round(sum(total_claim_cost)::numeric, 2) AS total_cost,
    round(sum(payer_coverage)::numeric, 2) AS payer_coverage,
    round(
        CASE 
            WHEN sum(total_claim_cost) = 0 THEN 0
            ELSE ((sum(payer_coverage) / sum(total_claim_cost)) * 100)::numeric
        END,
        2
    ) AS percentage
FROM encounters
GROUP BY patient_id;


Q28
--Patient 360 view — total encounters, conditions, medications, and cost per patient in one query
WITH encounter_data AS (
    SELECT 
        patient_id,
        COUNT(*) AS total_encounters,
        SUM(total_claim_cost) AS total_cost
    FROM encounters
    GROUP BY patient_id
),

condition_data AS (
    SELECT 
        patient_id,
        COUNT(*) AS total_conditions
    FROM conditions
    GROUP BY patient_id
),

medication_data AS (
    SELECT 
        patient_id,
        COUNT(*) AS total_medications
    FROM medications
    GROUP BY patient_id
)

SELECT 
    p.patient_id,
    p.full_name,

    COALESCE(e.total_encounters, 0) AS total_encounters,
    COALESCE(c.total_conditions, 0) AS total_conditions,
    COALESCE(m.total_medications, 0) AS total_medications,

    ROUND(COALESCE(e.total_cost, 0)::numeric, 2) AS total_cost

FROM patients p

LEFT JOIN encounter_data e 
    ON p.patient_id = e.patient_id

LEFT JOIN condition_data c 
    ON p.patient_id = c.patient_id

LEFT JOIN medication_data m 
    ON p.patient_id = m.patient_id

ORDER BY total_cost DESC;
					 
