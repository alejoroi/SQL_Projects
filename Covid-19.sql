-- *** This is the Data to use ***
SELECT 
	DATE, 
	country, 
	total_infected, 
	new_infections, 
	total_deaths 
FROM deaths
ORDER BY country; -- Order by Date and Country


-- *** How many Total Infection are versus Total Deaths
SELECT 
	DATE, 
	country, 
	total_infected, 
	total_deaths, 
	(total_deaths/total_infected) *100 AS deaths_percentage 
FROM deaths
WHERE country LIKE '%canada%'		-- Filter by Canada
ORDER BY deaths_percentage DESC;	-- Order from highest to lowest
						-- Not grouped to check the evolution in time (DATE)




-- *** % of population got Covid in Canada
SELECT 
DATE, 
country, 
population, 
total_infected, 
(total_infected/population) *100 AS population_with_covid_percentage 
FROM deaths
WHERE country LIKE '%canada%'		-- Filter by Canada
ORDER BY population_with_covid_percentage DESC; -- Order from highest to lowest
-- Not grouped to check the evolution in time (DATE)


-- *** % Countries with highest infection rate
SELECT 
DATE, 
country, 
population, 
MAX(total_infected) AS higuest_infection, -- New column with highest value
MAX((total_infected/population)) *100 AS higuest_infection_rate 
FROM deaths
GROUP BY country, population -– Show each country and population grouped.
ORDER BY higuest_infection_rate DESC; 


-- *** % Countries with highest death rate
SELECT 
DATE, 
country, 
population, 
MAX(total_deaths) AS higuest_country_deaths, 
MAX((total_deaths/population)) *100 AS higuest_country_deaths_rate 
FROM deaths
WHERE continent != "" –- Avoid empty continents
GROUP BY country, population  -– Show each country and population grouped.
ORDER BY higuest_country_deaths_rate DESC; 


-- *** % Continents with highest death and infection rate
SELECT 
DATE, 
continent, 
MAX(total_deaths) AS higuest_country_deaths, 
MAX(total_infected) AS higuest_infection, 
MAX((total_deaths/population)) *100 AS higuest_country_deaths_rate, 
MAX((total_infected/population)) *100 AS higuest_infection_rate 
FROM deaths
WHERE continent != "" –- Avoid empty continents
GROUP BY continent -– Show each continent grouped.
ORDER BY higuest_country_deaths_rate DESC;


-- *** % Global Deaths rates by date
SELECT 
DATE, 
country, 
SUM(new_deaths), -- Total number of new deaths in the country
SUM(new_infections), -- Total number of new infections in the country
SUM(new_deaths)/SUM(new_infections))*100 AS deaths_rate 
FROM deaths
WHERE continent !=""
GROUP BY country
LIMIT 10		-- Show only the first 10 rows
;

-- ***  Shows Percentage of Population that has received at least one Covid Vaccine

-- Create a temporary table to hold data
WITH RunningVaccinations AS (
    SELECT
        deaths.continent,
        deaths.country,
        deaths.date,
        deaths.population,
        vaccin.new_vaccinations,

-- Sum all new vaccinations to have a total, keep track(partition by) of the running sum separately for each location and order the date to calculate the sum correctly
        SUM(vaccin.new_vaccinations) OVER (PARTITION BY deaths.country ORDER BY deaths.date) AS running_sum
    FROM deaths
-- Combine death and vaccin table where the location and date match between both tables

    JOIN vaccin ON deaths.country = vaccin.country AND deaths.date = vaccin.date
    WHERE deaths.continent != ""
)
-- Now I can use the information from RunningVaccinations
SELECT
    continent,
    country,
    date,
    population,
    new_vaccinations,
    (running_sum / population) * 100 AS percentage_vaccinated
FROM RunningVaccinations
ORDER BY continent, country, date;
