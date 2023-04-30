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








