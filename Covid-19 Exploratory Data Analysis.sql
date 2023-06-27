SELECT *
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

-- To select the data that will be used for this project

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio..CovidDeaths
ORDER BY 1,2

-- Looking at the Total Cases vs Population in United States
SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM Portfolio..CovidDeaths
WHERE location like '%states%' AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at countries with Highest Infection Rate compared to Population. 
-- This is what percentage of the population got infected/got Covid
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
FROM Portfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing the Count by Countries with the Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- TO BETTER NARROW THINGS DOWN BY CONTINENT
/* In order to have a more accurate value count across the location, we have decided not to exclude the
NULL values. This is evident in the code below. */

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking Down to Continents
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Now, Showing continents with the Highest Death Count per Population
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS using aggregate functions to find the sum of; NEW CASES, TOTAL DEATHS

SELECT date, SUM(new_cases) as total_cases, SUM(NULLIF(cast(new_deaths as int), 0)) as total_deaths, 
SUM(NULLIF(cast(new_deaths as int), 0)) / SUM(New_Cases)*100 as DeathPercentage
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2 


-- To know the Total Cases

SELECT SUM(new_cases) as total_cases, SUM(NULLIF(cast(new_deaths as int), 0)) as total_deaths, 
SUM(NULLIF(cast(new_deaths as int), 0)) / SUM(New_Cases)*100 as DeathPercentage
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY total_cases, total_deaths


-- Combining the two tables to look at the Total Population vs Vaccinations
  
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM Portfolio..CovidDeaths dea
JOIN Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


