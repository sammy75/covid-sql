SELECT * FROM `analysis covid`.coviddeaths_1;

SELECT DISTINCT continent
FROM coviddeaths_1;

SELECT DISTINCT continent
FROM covidvaccinations;

--- Total cases VS Total deaths ---
--- shows likelyhood of dying if you contract Covid in your country ---
SELECT continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percantage
FROM coviddeaths_1
WHERE continent = 'Africa'
ORDER BY 1,2; 

--- Total cases VS Population ---
--- shows what percantage of the population got covid ---
SELECT continent, location, date, population, total_cases, (total_cases/population)*100 AS death_percantage
FROM coviddeaths_1
WHERE continent = 'Africa'
ORDER BY 1,2;


--- Countries with the highest infection rate per population---

Select continent, location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths_1
-- Where location like '%states%' --
Group by continent, location, Population
order by PercentPopulationInfected desc;

--- showing countries with highest death count per population ---

Select location, MAX(total_deaths) AS TotalDeathCount
From coviddeaths_1
Where continent is not null 
Group by location
order by TotalDeathCount desc;


SELECT location, MAX(CAST(Total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths_1
WHERE location IS NOT NULL AND Total_deaths REGEXP '^[0-9]+$'
GROUP BY location
ORDER BY TotalDeathCount DESC;

--- above replace location with continent ---


--- join death table and vaccine table ---
SELECT *
FROM covidvaccinations vac
JOIN coviddeaths_1 dea
ON dea.location = vac.location
and dea.date = vac.date;

--- total population vs total vaccination ---
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeaths_1 dea
JOIN covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent IS NOT NULL
ORDER BY 1, 2,3;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From coviddeaths_1 dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

