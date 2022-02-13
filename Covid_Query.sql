-- *** Source: https://ourworldindata.org/covid-deaths
-- *** Date range: Jan 2020 to Jan 2022


-- *** This is the Data to use ***

SELECT DATE, location, total_cases, new_cases, total_deaths FROM deaths
ORDER BY 1,2; -- Order by Date and Location

-- *** How many Total Cases are versus Total Deaths

SELECT DATE, location, total_cases, total_deaths, (total_deaths/total_cases) *100 as deaths_percentage FROM deaths
WHERE location LIKE '%canada%'
ORDER BY 2,1; -- Order by Location

-- *** % of population got Covid

SELECT DATE, location, population, total_cases, (total_cases/population) *100 as population_with_covid_percentage FROM deaths
WHERE location LIKE '%canada%'
ORDER BY 2,1; 

-- *** % Countries with highest infection rate

SELECT DATE, location, population, max(total_cases) AS higuest_cases, MAX((total_cases/population)) *100 as higuest_cases_rate FROM deaths
GROUP BY location, population
ORDER BY higuest_cases_rate DESC; 

-- *** % Countries with highest death rate

SELECT DATE, location, population, max(total_deaths) AS higuest_deaths, MAX((total_deaths/population)) *100 as higuest_deaths_rate FROM deaths
WHERE continent != ""
GROUP BY location, population
ORDER BY higuest_deaths_rate DESC; 

-- *** % Continents with highest death and cases rate

SELECT DATE, continent, max(total_deaths) AS higuest_deaths, max(total_cases) AS higuest_cases, MAX((total_deaths/population)) *100 as higuest_deaths_rate, 
MAX((total_cases/population)) *100 as higuest_cases_rate FROM deaths
WHERE continent != ""
GROUP BY continent
ORDER BY higuest_deaths_rate DESC;

-- *** % Global Deaths rayes by date

SELECT DATE, SUM(new_deaths), SUM(new_cases),(SUM(new_deaths)/SUM(new_cases))*100 AS deaths_rate FROM deaths
WHERE continent !=""
GROUP BY DATE;

-- *** Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccin.new_vaccinations, SUM(vaccin.new_vaccinations) OVER(PARTITION by deaths.location ORDER BY deaths.location)  FROM deaths 
JOIN vaccin ON deaths.location = vaccin.location AND deaths.date = vaccin.date
WHERE deaths.continent !=""
ORDER BY 1,2,3;
