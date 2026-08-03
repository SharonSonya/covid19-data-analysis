-- ==========================================
-- COVID-19 DATA ANALYSIS PROJECT
-- Our World in Data COVID-19 Dataset
-- Author: Sharon Kam'mambala
-- ==========================================

-- -- Source:
-- Our World in Data COVID-19 Dataset.
--
-- Dataset Type:
-- Public health time-series dataset containing information
-- on COVID-19 cases, deaths, testing, vaccinations,
-- population and demographic indicators.
--
-- Date Range:
-- January 2020 to June 2026.
--
-- Tools Used:
-- MySQL
--
-- Objective:
-- Analyze global COVID-19 trends, identify countries
-- with the highest impact, examine vaccination progress,
-- and uncover patterns in cases and deaths.
-- ==========================================

USE covid19_analysis;

-- =====================================================
-- STEP 1: DATA QUALITY ASSESSMENT
-- =====================================================
--
-- Objective:
-- Assess the quality and completeness of the COVID-19
-- dataset before performing analysis.
-- =====================================================


-- Check total records

SELECT COUNT(*) AS total_rows
FROM covid_data;


-- Check missing country values

SELECT COUNT(*) AS missing_countries
FROM covid_data
WHERE country IS NULL;


-- Check missing dates

SELECT COUNT(*) AS missing_dates
FROM covid_data
WHERE date IS NULL;


-- Check duplicate records

SELECT
    country,
    date,
    COUNT(*) AS duplicate_count
FROM covid_data
GROUP BY country, date
HAVING COUNT(*) > 1;


-- =====================================================
-- STEP 1 COMPLETE: DATA QUALITY ASSESSMENT
-- =====================================================
--
-- Summary:
-- • Total records verified.
-- • Missing values checked.
-- • Duplicate records assessed.
-- • Dataset quality confirmed before analysis.
-- =====================================================

-- =====================================================
-- STEP 2: DATA EXPLORATION
-- =====================================================
--
-- Objective:
-- Explore the structure and contents of the COVID-19
-- dataset to understand available variables, countries,
-- time range and data coverage before analysis.
-- =====================================================


-- Check dataset structure

DESCRIBE covid_data;


-- Total number of records

SELECT COUNT(*) AS total_rows
FROM covid_data;


-- Check date range

SELECT
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM covid_data;


-- Check countries included

SELECT COUNT(DISTINCT country) AS total_countries
FROM covid_data;


-- Check continents included

SELECT DISTINCT continent
FROM covid_data
WHERE continent IS NOT NULL;


-- Preview sample data

SELECT *
FROM covid_data
LIMIT 10;


-- =====================================================
-- STEP 2 COMPLETE: DATA EXPLORATION
-- =====================================================
--
-- Summary:
-- • Dataset structure reviewed.
-- • Total records verified.
-- • Date range confirmed: 2020-01-01 to 2026-06-28.
-- • Countries and continents identified.
-- • Dataset ready for exploratory analysis.
-- =====================================================


-- =====================================================
-- STEP 3: EXPLORATORY DATA ANALYSIS (EDA)
-- =====================================================
--
-- Objective:
-- Analyze COVID-19 trends to identify patterns in
-- cases, deaths, vaccination progress and differences
-- between countries and continents.
-- =====================================================

-- -----------------------------------------------------
-- BUSINESS QUESTION 1
-- -----------------------------------------------------
-- Question:
-- What was the overall global impact of COVID-19?
-- -----------------------------------------------------

-- Global COVID-19 summary
-- Uses maximum values per country to avoid
-- double counting cumulative daily records.

SELECT 
    SUM(max_cases) AS global_total_cases,
    SUM(max_deaths) AS global_total_deaths
FROM (
    SELECT
        country,
        MAX(total_cases) AS max_cases,
        MAX(total_deaths) AS max_deaths
    FROM covid_data
    GROUP BY country
) AS country_totals;

-- Results:
-- Global totals calculated using the highest cumulative
-- value recorded for each country.
--
-- Interpretation:
-- This approach prevents double counting because COVID-19
-- cumulative values are repeated across daily records.

-- -----------------------------------------------------
-- BUSINESS QUESTION 2
-- -----------------------------------------------------
-- Question:
-- Which countries recorded the highest number of
-- COVID-19 cases?
-- -----------------------------------------------------

-- Top 10 countries by total COVID-19 cases
--
-- MAX(total_cases) is used because cumulative case
-- values are repeated for every date in the dataset.

SELECT
    country,
    MAX(total_cases) AS total_cases
FROM covid_data
WHERE continent IN (
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY country
ORDER BY total_cases DESC
LIMIT 10;

-- Results:
--
-- Top countries by total COVID-19 cases:
-- 1. United States - 103,436,829
-- 2. China - 99,381,761
-- 3. India - 45,056,221
-- 4. France - 39,060,813
-- 5. Germany - 38,437,953
-- 6. Brazil - 38,039,158
-- 7. South Korea - 34,571,873
-- 8. Japan - 33,803,572
-- 9. Italy - 26,969,918
-- 10. United Kingdom - 25,118,310
--
-- Interpretation:
-- The United States recorded the highest number of
-- confirmed COVID-19 cases, followed by China and India.
--
-- Business Insight:
-- Countries with large populations and high testing
-- capacity recorded the highest number of reported cases.

-- -----------------------------------------------------
-- BUSINESS QUESTION 3
-- -----------------------------------------------------
-- Question:
-- Which countries recorded the highest number of
-- COVID-19 deaths?
-- -----------------------------------------------------

-- Top 10 countries by total COVID-19 deaths
--
-- MAX(total_deaths) is used because cumulative death
-- values are repeated across daily records.

SELECT
    country,
    MAX(total_deaths) AS total_deaths
FROM covid_data
WHERE continent IN (
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY country
ORDER BY total_deaths DESC
LIMIT 10;

-- Results:
--
-- Top countries by total COVID-19 deaths:
-- 1. United States - 1,238,563
-- 2. Brazil - 704,029
-- 3. India - 533,849
-- 4. Russia - 404,290
-- 5. Mexico - 335,111
-- 6. United Kingdom - 232,112
-- 7. Peru - 221,071
-- 8. Italy - 198,523
-- 9. Germany - 174,979
-- 10. France - 168,207
--
-- Interpretation:
-- The United States recorded the highest number of
-- COVID-19 deaths, followed by Brazil and India.
--
-- Business Insight:
-- The countries with the highest deaths were affected
-- by factors such as population size, healthcare system
-- capacity, timing of outbreaks and public health
-- responses.

-- -----------------------------------------------------
-- BUSINESS QUESTION 4
-- -----------------------------------------------------
-- Question:
-- Which countries recorded the highest number of
-- fully vaccinated people?
-- -----------------------------------------------------

-- Top 10 countries by fully vaccinated population
--
-- MAX(people_fully_vaccinated) is used because
-- vaccination totals are cumulative values repeated
-- across daily records.

SELECT
    country,
    MAX(people_fully_vaccinated) AS fully_vaccinated
FROM covid_data
WHERE continent IN (
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY country
ORDER BY fully_vaccinated DESC
LIMIT 10;

-- Results:
--
-- Top countries by fully vaccinated population:
-- 1. China - 1,284,479,600
-- 2. India - 951,990,500
-- 3. United States - 230,637,340
-- 4. Brazil - 176,164,200
-- 5. Indonesia - 174,965,140
-- 6. Bangladesh - 142,201,680
-- 7. Pakistan - 140,475,870
-- 8. Japan - 103,455,224
-- 9. Vietnam - 85,961,570
-- 10. Mexico - 81,849,960
--
-- Interpretation:
-- China and India recorded the highest number of fully
-- vaccinated people, largely due to their large
-- population sizes.
--
-- Business Insight:
-- Vaccination coverage played an important role in
-- reducing the impact of COVID-19 and restoring
-- economic and social activities globally.

-- -----------------------------------------------------
-- BUSINESS QUESTION 5
-- -----------------------------------------------------
-- Question:
-- How did COVID-19 cases change over time?
-- -----------------------------------------------------

-- Monthly COVID-19 case trends
--
-- New cases are grouped by month to identify major
-- periods of increase and decline throughout the pandemic.

SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(new_cases) AS monthly_new_cases
FROM covid_data
GROUP BY month
ORDER BY month;

-- Results:
--
-- Key periods identified:
--
-- • Cases increased rapidly throughout 2020 as the
--   virus spread globally.
--
-- • Significant increases occurred during late 2020
--   and early 2021.
--
-- • The highest monthly increase occurred in
--   January 2022 during the Omicron wave.
--
-- • Reported cases declined significantly after 2023.
--
-- Interpretation:
-- COVID-19 infections occurred in several global waves,
-- with the largest increase happening during the
-- Omicron period.
--
-- Business Insight:
-- Understanding case trends helps governments,
-- healthcare organisations and businesses prepare
-- responses during periods of increased transmission.

-- -----------------------------------------------------
-- BUSINESS QUESTION 6
-- -----------------------------------------------------
-- Question:
-- How did COVID-19 impact different continents?
-- -----------------------------------------------------

-- COVID-19 cases and deaths by continent
--
-- MAX() is used because total_cases and total_deaths
-- are cumulative values repeated across daily records.

SELECT
    continent,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths
FROM covid_data
WHERE continent IN (
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY continent
ORDER BY total_cases DESC;

-- Results:
--
-- North America:
-- Total Cases: 103,436,829
-- Total Deaths: 1,238,563
--
-- Asia:
-- Total Cases: 99,381,761
-- Total Deaths: 533,849
--
-- Europe:
-- Total Cases: 39,060,813
-- Total Deaths: 404,290
--
-- South America:
-- Total Cases: 38,039,158
-- Total Deaths: 704,029
--
-- Oceania:
-- Total Cases: 11,861,161
-- Total Deaths: 25,236
--
-- Africa:
-- Total Cases: 4,073,188
-- Total Deaths: 102,595
--
-- Interpretation:
-- North America recorded the highest number of cases
-- and deaths among continents, while Africa recorded
-- the lowest reported cases.
--
-- Business Insight:
-- Differences between continents may be influenced by
-- population size, healthcare infrastructure, testing
-- availability, reporting methods and public health
-- responses.

-- =====================================================
-- STEP 3 COMPLETE: EXPLORATORY DATA ANALYSIS
-- =====================================================
--
-- Summary:
-- • Global COVID-19 impact analysed.
-- • Highest case and death countries identified.
-- • Vaccination trends analysed.
-- • Monthly case patterns examined.
-- • Continental differences evaluated.
--
-- Status:
-- ✔ Exploratory Data Analysis Completed Successfully
-- =====================================================

-- =====================================================
-- STEP 4: KEY FINDINGS
-- =====================================================
--
-- Key Finding 1:
-- The United States recorded the highest number of
-- confirmed COVID-19 cases and deaths among individual
-- countries.
--
-- -----------------------------------------------------
--
-- Key Finding 2:
-- China and India recorded the highest numbers of fully
-- vaccinated people, mainly due to their large
-- population sizes.
--
-- -----------------------------------------------------
--
-- Key Finding 3:
-- Global COVID-19 cases reached their highest levels
-- during January 2022, corresponding with the Omicron
-- wave.
--
-- -----------------------------------------------------
--
-- Key Finding 4:
-- North America recorded the highest number of reported
-- COVID-19 cases and deaths among the analysed continents.
-- -----------------------------------------------------
--
-- Key Finding 5:
-- COVID-19 cases declined significantly after 2023
-- compared with earlier pandemic peaks.
--
-- -----------------------------------------------------
--
-- Key Finding 6:
-- Vaccination programmes played an important role in
-- reducing the impact of COVID-19 and supporting the
-- recovery of social and economic activities.
--
-- =====================================================
-- STEP 4 COMPLETE: KEY FINDINGS
-- =====================================================
--
-- Summary:
-- • Major countries affected by COVID-19 were identified.
-- • Vaccination progress was evaluated.
-- • Global case trends were analysed.
-- • Continental differences were highlighted.
--
-- Status:
-- ✔ Key Findings Completed Successfully
-- =====================================================

-- =====================================================
-- STEP 5: FINAL CONCLUSION
-- =====================================================
--
-- The analysis provided insights into the global impact
-- of COVID-19 by examining cases, deaths, vaccination
-- progress and trends over time.
--
-- The findings showed that the United States experienced
-- the highest reported number of COVID-19 cases and
-- deaths among individual countries, while China and
-- India achieved the highest vaccination numbers due to
-- their large populations.
--
-- COVID-19 cases occurred in multiple waves, with the
-- largest increase recorded during January 2022 during
-- the Omicron period. After 2023, reported cases declined
-- significantly compared with earlier pandemic peaks.
--
-- Differences between continents highlighted the impact
-- of factors such as population size, healthcare capacity,
-- testing availability and public health responses.
--
-- Overall, the analysis demonstrates how data can be used
-- to understand the progression of a global health crisis,
-- evaluate vaccination efforts and identify patterns
-- that support informed decision-making.
--
-- =====================================================
-- END OF PROJECT
-- =====================================================
--
-- End of COVID-19 Data Analysis Project
-- Our World in Data COVID-19 Dataset
-- Author: Sharon Kam'mambala
-- =====================================================