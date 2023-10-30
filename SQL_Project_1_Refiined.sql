

select * from dbo.Covid_Vaccinations_Dataset
Order by 3,4 8

Select location, date, new_cases, total_deaths, population
from dbo.Covid_Deaths_Dataset
Order by 3,4 

/*--Looking at Total Cases Vs. Total Deaths--*/

Select location, date, total_cases_per_million, total_deaths_per_million, total_deaths, (total_deaths_per_million/total_cases_per_million) * 100 As Percentage_Death 
from dbo.Covid_Deaths_Dataset
where total_cases_per_million>0 and total_deaths_per_million>0  and date is not Null 
 select location = 'kenya' ,  date, total_cases_per_million, total_deaths_per_million, total_deaths, (total_deaths_per_million/total_cases_per_million) * 100 As Percentage_Death 
 from dbo.Covid_Deaths_Dataset
 where total_cases_per_million is not Null and total_deaths_per_million is not Null and total_deaths is not Null and date is not Null  and total_cases_per_million>0 and total_deaths_per_million>0 

 --Looking at the Total Cases Vs. Population--

 Select location ='Kenya', date, total_cases_per_million, total_deaths_per_million, total_deaths, population, (total_cases_per_million/population) * 100 As Percentage_Death 
from dbo.Covid_Deaths_Dataset
where total_cases_per_million>0 and total_deaths_per_million is not Null and date is not Null
Order by Percentage_Death Desc

--Looking at Countries with highest infection rates compared to population--

select location, date, population, MAX(total_cases_per_million) As Highest_Infection_Count, MAX((total_cases_per_million/population)*100) as Percentage_Death
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset
where total_cases_per_million > 0 and population > 0 and total_cases_per_million < population and total_deaths_per_million is not Null and date is not Null
group by date, location, population 

-- Showing Countries with highest Death Count Per Population--

elect location, Max(Cast (total_deaths_per_million as int)) as Death__Count
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset 

group by location
order by Death__Count Desc 
/*--explanantion-- */
/*Vatican recorded the highest number of deaths per million. (6511) followed by Vanuatu and Turkamenistan. */

--Showing Continents with the Highest Death Count per million--
select continent, Max ( Cast(total_deaths_per_million as int)) as Death_By_Continent from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset
where continent is not null 
group by continent
order by Death_By_Continent Desc 

--Explanantion; Europe had the highest death per million and teh least was sount America followed by Africa. --


--GLOBAL NUMBERS--
select location, date, population, total_cases_per_million, total_deaths_per_million, (total_deaths_per_million/total_cases_per_million)*100 as Percentage_Death_Per_Location
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset 
where total_cases_per_million > 0 and total_deaths_per_million > 0 and location is not null and population is not null and  total_cases_per_million > total_deaths_per_million
order by 1,2,3 Desc  

select date, SUM (new_cases) as Sum_of_New_Cases, SUM(new_deaths) as Sum_New_Deaths, (SUM(new_deaths)/SUM(new_cases))*100 as Percentage_Death_Per_New_Cases
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset
where date is not null and (new_cases)>0
group by date 
order by 1,2,3 

Select * from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset dea
join Allan_SQL_Portforlio_Projects.dbo.Covid_Vaccinations_Dataset vac
on dea.location=vac.location 
and 
dea.date=vac.date 

--Looking For Totl Population Vs. The Vaccinations--
with PopVsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset dea
join Allan_SQL_Portforlio_Projects.dbo.Covid_Vaccinations_Dataset vac
on dea.location=vac.location 
and 
dea.date=vac.date
--order by 1,2,3
where dea.continent is not null and vac.new_vaccinations is not null

)
select*, (Rolling_People_Vaccinated/population)*100 from PopVsVac as Peecentage_Of_People_Vaccinated */

/*--To get (Rolling_People_Vaccinated)*100 which is the comparison of total number of people vaccinated against the population, we aregoing to need to use CTE or TRMP tables.--
--Use CTE, see it above the above querry--*/

--Creating Views to Store Data foor Later Use--
Create view percent_ppl_Vacc_1 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from Allan_SQL_Portforlio_Projects.dbo.Covid_Deaths_Dataset dea
join Allan_SQL_Portforlio_Projects.dbo.Covid_Vaccinations_Dataset vac
on dea.location=vac.location 
and 
dea.date=vac.date
--order by 1,2,3
where dea.continent is not null and vac.new_vaccinations is not null