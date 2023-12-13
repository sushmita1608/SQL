
Select * From Covid..Covid_Deaths
Where continent is not null

Select * From Covid..Covid_Vaccination
Where continent is not null

-- Looking at Total Cases vs Total Deaths
-- To Calculate DeathPercentage according to location
Select location, date, total_cases, total_deaths, new_cases, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From Covid..Covid_Deaths
Where location = 'India'
Order By 1,2

--Looking at Total Cases vs Population
-- Calculating the infection rate according to the location
Select location, date,  new_cases,population, total_cases, 
(CONVERT(float,total_cases)/ CONVERT(float,population))*100 as InfectionRatePercentage
From Covid..Covid_Deaths
Where location = 'India'
Order By 1,2

-- Calculating which country has the highest infection rate over the population
Select location,   population, MAX( total_cases) HighestInfection , 
MAX((CONVERT(float,total_cases)/ CONVERT(float,population))*100) as InfectionRatePercentage
From Covid..Covid_Deaths
Where continent is not null
Group By location,population
Order By InfectionRatePercentage desc

-- Calculationg the highest Death Count Per Population
-- To Calculate DeathPercentage according to location
Select location,  population, MAX(total_deaths) as HighestDeathCount
From Covid..Covid_Deaths
Where continent is not null
Group By location ,population
Order By HighestDeathCount desc


-- LET'S BREAK DOWN THINGS BY CONTINENT
-- Continent with highest death count
Select continent, MAX(total_deaths) as HighestDeathCount
From Covid..Covid_Deaths
Where continent is not null
Group By continent
Order By HighestDeathCount desc


--GLOBAL NUMBERS
Select  date, SUM(new_cases) as TotalCases ,  SUM(new_deaths) as TotalDeaths, 
(CONVERT(float, SUM(new_deaths))  / NULLIF(CONVERT(float, SUM(new_cases)),0))*100 as DeathPercentage
From Covid..Covid_Deaths
Where continent is not null
Group By date
Order By date


--Total Population vs Vaccination
Select de.continent, de.location, de.date , de.population , va.new_vaccinations,
SUM(CONVERT(bigint, va.new_vaccinations)) OVER (PARTITION BY de.location Order By de.location, de.date) as RollingPeopleVaccinated
From Covid..Covid_Deaths de Join Covid..Covid_Vaccination va
ON de.location= va.location and de.date = va.date
Where de.continent is not null


--Using CTE
 With PopvsVac(Continent,Location,Date,NewVaccinations,Population,RollingPeopleVaccinated)
 as(
 Select de.continent, de.location, de.date , de.population , va.new_vaccinations,
SUM(CONVERT(bigint, va.new_vaccinations)) OVER (PARTITION BY de.location Order By de.location, de.date) as RollingPeopleVaccinated
From Covid..Covid_Deaths de Join Covid..Covid_Vaccination va
ON de.location= va.location and de.date = va.date
Where de.continent is not null
 )
 Select * ,(RollingPeopleVaccinated/NULLIF(Population,0))*100
 From PopvsVac

 --TEMP TABLE
 DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select de.continent, de.location, de.date , de.population , va.new_vaccinations,
SUM(CONVERT(bigint, va.new_vaccinations)) OVER (PARTITION BY de.location Order By de.location, de.date) as RollingPeopleVaccinated
From Covid..Covid_Deaths de Join Covid..Covid_Vaccination va
ON de.location= va.location and de.date = va.date
Where de.continent is not null
Select *, (RollingPeopleVaccinated/NULLIF(Population,0))*100
From #PercentPopulationVaccinated


