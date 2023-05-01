Select *
From PortfolioProject.dbo.CovidDeath
order by 3,4 
--Select *
--From PortfolioProject.dbo.CovidVaccination
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject.dbo.CovidDeath
order by 1,2 


--We are going to look at Total Cases Vs Population

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeath
--Where location like '%pakistan%'
order by 1,2

--Looking at the highest infection rate compared to population

Select location, population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeath
--Where location like '%pakistan%'
Group by location, population
Order by PercentPopulationInfected DESC

--Showing Countries with Highest Death Count Per Population

Select location, population, Max(total_deaths) as HighestDeathCount, Max((total_deaths/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeath
--Where location like '%pakistan%'
Group by location, population
Order by HighestDeathCount DESC

--Let's break things down by continent

--Showing the continent with Highest Death Count Per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeath
--Where location like '%pakistan%'
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalDeathPercentage
From PortfolioProject.dbo.CovidDeath
--Where location like '%pakistan%'
Where continent is not null
--Group by date
Order by 1,2

--Looking Total Population Vs Vaccination

--With CTE

With PopVsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3
)
Select *, (rollingpeoplevaccinated/population)*100 
From PopVsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order By 2,3
Select *, (rollingpeoplevaccinated/population)*100 
From #PercentPopulationVaccinated

--Create View

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated,
--,(rollingpeoplevaccinated/population)*100
From PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select *
From PercentPopulationVaccinated




		








