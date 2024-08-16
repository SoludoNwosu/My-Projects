select *
from [PortfolioProject].[dbo].[CovidDeaths$]
Where continent is not Null
order by 3,4


--Let's select the following data for this project;

Select location, date, total_cases, new_cases, total_deaths, population
From [PortfolioProject].[dbo].[CovidDeaths$]
Where continent is not Null
Order By 1,2



--Let's look at the Total Cases VS The Total Deaths
--This shows the likelihood of death for victims of Covid19 for each Country 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From [PortfolioProject].[dbo].[CovidDeaths$]
Where location like '%Nigeria%'
and continent is not Null
Order By 1,2



--Let's look at the Total Cases VS the Population 
--This shows the percentage of the population that has gotten Covid 19

Select location, date, population, total_cases, (total_cases/population)*100 as Population_Percentage
From [PortfolioProject].[dbo].[CovidDeaths$]
Where continent is not Null --and location like '%Nigeria%'
Order By 1,2
 


 --Let's look at the countries with the highest infection rate compared to the population 

Select location, population, MAX(total_cases) as Highest_Infections, MAX((total_cases/population))*100 as Population_Percentage
From [PortfolioProject].[dbo].[CovidDeaths$]
Where continent is not Null
Group By location, population
--Where location like '%Nigeria%'
Order By Population_Percentage DESC



--Let's look at the countries with the highest number of deaths recorded 

Select location, MAX(cast(total_deaths as int)) as Highest_Death_Count
From PortfolioProject.dbo.CovidDeaths$
Where continent is not Null
Group By location
--Where location like '%Nigeria%'
Order By Highest_Death_Count DESC



--Let's break things down by continent
--Let's show the continents with the highest death counts

Select continent, MAX(cast(total_deaths as int)) as Highest_Death_Count
From [PortfolioProject].[dbo].[CovidDeaths$]
Where continent is not Null
Group By continent
--Where location like '%Nigeria%'
Order By Highest_Death_Count DESC



--GLOBAL Death Percentage per day

Select date, SUM(new_cases) as Total_New_Cases, SUM(cast (new_deaths as int)) as Total_New_Deaths, Sum(cast(new_deaths as int))/SUM(new_cases)*100 as Global_Death_Percentage
From [PortfolioProject].[dbo].[CovidDeaths$]
--Where location like '%Nigeria%'
Where continent is not Null
Group By date
Order By 1,2



--Global Death Percentage Totally 

Select SUM(new_cases) as Total_New_Cases, SUM(cast (new_deaths as int)) as Total_New_Deaths, Sum(cast(new_deaths as int))/SUM(new_cases)*100 as Global_Death_Percentage
From [PortfolioProject].[dbo].[CovidDeaths$]
--Where location like '%Nigeria%'
Where continent is not Null
--Group By date
Order By 1,2



--Covid Vaccinations 

Select *
From PortfolioProject.dbo.CovidVaccinations$



--Joining the two tables
--Total Population VS Total Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert( int, vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,dea.date) as Total_New_Vaccinations_Brought_Down
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not Null
Order by 2,3

--Using Our CTEs

WITH CTE_POPvsVAC as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert( int, vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,dea.date) as Total_New_Vaccinations_Brought_Down
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not Null
--Order by 2,3
)
Select *, (Total_New_Vaccinations_Brought_Down/population)*100 as Percentage_of_New_Vaccinations_over_Population
From CTE_POPvsVAC

--Using Temp Tanles

Drop Table if exists #Percentage_of_New_Vaccinations_over_Population
Create Table #Percentage_of_New_Vaccinations_over_Population
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Total_New_Vaccinations_Brought_Down numeric
)

Insert Into #Percentage_of_New_Vaccinations_over_Population
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert( int, vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,dea.date) as Total_New_Vaccinations_Brought_Down
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--Where dea.continent is not Null
--Order by 2,3

Select *, (Total_New_Vaccinations_Brought_Down/population)*100 as Percentage_of_New_Vaccinations_over_Population
From #Percentage_of_New_Vaccinations_over_Population



--Creating Views For Data Visualisations 

Create View Percentage_of_New_Vaccinations_over_Population as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert( int, vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,dea.date) as Total_New_Vaccinations_Brought_Down
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not Null
--Order by 2,3

Select *
From PortfolioProject.dbo.Percentage_of_New_Vaccinations_over_Population