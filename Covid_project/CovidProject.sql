-- Retrieve data from CovidDeaths table
SELECT * FROM [Portfolio Project]..CovidDeaths$

-- Retrieve specific columns from CovidDeaths table and sort by Location and Date
Select Location, date, total_cases, new_cases, total_deaths, population 
from [Portfolio Project]..CovidDeaths$
order by 1, 2

-- Total Cases VS Total Deaths in Czech Republic 

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from [Portfolio Project]..CovidDeaths$
where location = 'Czechia'
order by 1, 2

-- Total Cases Vs Population in Czech Republic 

Select Location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
from [Portfolio Project]..CovidDeaths$
where location = 'Czechia'
Order by 1,2

-- Countries with highest infection rate compared to Population

Select location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as PopulationInfected
From [Portfolio Project]..CovidDeaths$
Group by location, population
Order by PopulationInfected Desc

-- Countries with Highest mortality rate

Select location, population, MAX(cast(total_deaths as int)) as TotalDeaths, MAX((total_deaths/population)) * 100 as MortalityRate
FROM [Portfolio Project]..CovidDeaths$
where continent is not null 
Group by location, population
Order by MortalityRate desc

-- Deaths by Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeaths, MAX(total_deaths/population) * 100 as MortalityRate
From [Portfolio Project]..CovidDeaths$
Where continent is not null
Group by continent
Order by MortalityRate desc

-- Global Numbers
Select date, SUM(new_cases) as Cases, SUM(cast(new_deaths as int)) as Deaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentageWorld
from [Portfolio Project]..CovidDeaths$
where continent is not null
Group by date
order by 1, 2 

-- Joining CovidDeaths and CovidVaccinations tables
Select *
From [Portfolio Project]..CovidDeaths$ as deaths
Join [Portfolio Project]..CovidVaccinations$ as vaccinations
On deaths.location = vaccinations.location
AND deaths.date = vaccinations.date


-- Population Vaccinated

Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations, 
	SUM(cast(vaccinations.new_vaccinations as int)) OVER (Partition by deaths.location Order by deaths.location, deaths.date) as PeopleVaccinated
From [Portfolio Project]..CovidDeaths$ as deaths
Join [Portfolio Project]..CovidVaccinations$ as vaccinations
	On deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
Where deaths.continent is not null
Order by 2,3


-- CTE

With PopVsVac (Continent, Location, Date, Population, New_vaccinations, PeopleVaccinated)
as 
(Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations, 
	SUM(cast(vaccinations.new_vaccinations as int)) OVER (Partition by deaths.location Order by deaths.location, deaths.date) as PeopleVaccinated
From [Portfolio Project]..CovidDeaths$ as deaths
Join [Portfolio Project]..CovidVaccinations$ as vaccinations
	On deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
Where deaths.continent is not null
)
Select *, (PeopleVaccinated/Population)*100 as PopVac
FROM PopVsVac

-- View for later visualization

Create view PopVsVac as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations, 
	SUM(cast(vaccinations.new_vaccinations as int)) OVER (Partition by deaths.location Order by deaths.location, deaths.date) as PeopleVaccinated
From [Portfolio Project]..CovidDeaths$ as deaths
Join [Portfolio Project]..CovidVaccinations$ as vaccinations
	On deaths.location = vaccinations.location
	And deaths.date = vaccinations.date
Where deaths.continent is not null