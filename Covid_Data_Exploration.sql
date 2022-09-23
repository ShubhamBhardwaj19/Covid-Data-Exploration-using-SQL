-- ****Covid Death Table****

Select *
From [Covid Deaths]
Where continent is not null
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Covid Deaths]
Where continent is not null
Order by 1,2

-- Total cases vs Total Deaths
-- Case 1
Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as Death_Rate
From [Covid Deaths]
Where location like 'India'
Order by 1,2

-- Total cases vs Population
-- Case 2
Select Location, date, population, total_cases, (total_cases/population)*100 as Infection_Rate
From [Covid Deaths]
Where location like 'India'
Order by 1,2

Select Location, date, population, total_cases, (total_cases/population)*100 as Infection_Rate
From [Covid Deaths]
Where continent is not null
Order by 1,2

-- Highest Population Infected to Population for every country
-- Case 3*
Select Location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Total_Population_Infected
From [Covid Deaths]
Where continent is not null
Group by Location, population
Order by Total_Population_Infected desc

-- Highest Death Rate to Population for every country
-- Case 4
Select Location, MAX(cast(total_deaths as int)) as Highest_Death_Count
From [Covid Deaths]
Where continent is not null
Group by Location
Order by Highest_Death_Count desc

-- Highest Death Count to Population by Continent
-- Case 5*
Select continent, MAX(cast(total_deaths as int)) as Highest_Death_Count
From [Covid Deaths]
Where continent is not null
Group by continent
Order by Highest_Death_Count desc

-- Global Death rate per day
-- Case 6
Select date, SUM(new_cases) as Total_Cases_per_Day, SUM(CAST(new_deaths as int)) as Total_Deaths_per_Day, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Death_Rate
From [Covid Deaths]
Where continent is not null
Group by date
Order by 1,2

-- Global Death rate
-- Case 7 *
Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From [Covid Deaths]
Where continent is not null
Order by 1,2

-- Global Total Cases, Total Deaths and Total Survivors
-- Case 8
Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(new_cases)-SUM(CAST(new_deaths as int)) as Total_Survior
From [Covid Deaths]
Where continent is not null
Order by 1,2

-- Highest Death Count to Population by Country
-- Case 9
Select location, MAX(cast(total_deaths as int)) as Highest_Death_Count
From [Covid Deaths]
Where continent is not null
Group by location
Order by Highest_Death_Count desc

-- Highest Infection Rate to Population for every country per day
-- Case 10*
Select Location, population, date, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Total_Population_Infected
From [Covid Deaths]
Where continent is not null
Group by Location, population, date
Order by Total_Population_Infected desc

-- ****Covid Vaccination Table****

Select *
From [Covid Vaccinations]
Where continent is not null
Order by 3,4

Select Location, date, total_tests, new_tests, total_vaccinations
From [Covid Vaccinations]
Where continent is not null
Order by 1,2

-- Total Tests vs Total Vaccination
-- Case 1
Select Location, date, total_tests ,  total_vaccinations
From [Covid Vaccinations]
Where location like 'India'
Order by 1,2

-- Highest Death Rate to Population for every country
-- Case 2
Select Location, MAX(cast(total_vaccinations as bigint)) as Highest_Vaccination_Count
From [Covid Vaccinations]
Where continent is not null
Group by Location
Order by Highest_Vaccination_Count desc

-- Total Population vs Vaccination
-- Case 3
Select dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations) as New_Vaccination_per_day, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.date, dea.location) as Number_of_People_Vaccinated
FROM [Covid Deaths] dea
JOIN [Covid Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- Using Common Table Expression

With Population_vs_Vaccination (Continent, Location, Date, Population, New_Vaccination_per_day, Number_of_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations) as New_Vaccination_per_day, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.date, dea.location) as Number_of_People_Vaccinated
FROM [Covid Deaths] dea
JOIN [Covid Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *,(Number_of_People_Vaccinated/Population)*100 as Vaccination_Rate
From Population_vs_Vaccination
