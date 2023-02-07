--Hien thi tong so ca nhiem covidva tong so ca tu vong
Select Location, date, population, total_cases, new_cases, total_deaths, (total_deaths/total_cases) as  ti_le_hi_sinh from Death where Location = 'Afghanistan' order by 1,2	
-- Hien thi tong so ca nhiem covid va tong dan so 
Select location, total_cases, date, population, (total_cases/population*100) as ti_le_mac_nhiem from Death
-- Tong so ca nhiem tai moi dia diem
Select Location, sum(total_cases) as tong_so_ca_nhiem from Death group by "Location"
--Hien thi quoc gia co so ti le mac nhiem nhieu that
select Location, population, max(total_cases) as tong_so_ca, Max(total_cases/population)*100 as ti_le_mac_nhiem from Death group by Location, population order by ti_le_mac_nhiem DESC
--Quoc gia co so luong chet nhieu nhat
Select Location, Max(cast(total_deaths as bigint)) as ti_le_chet from Death group by Location, population order by ti_le_chet DESC
-- Quoc gia co ti le chet cao nhat
select Location, population, Max(cast(total_deaths/population)*100 as ti_le_chet from Death where continent is not null group by Location, population order by ti_le_chet DESC
-- so_luong_nguoi_chet_theo_chau_luc
select continent, sum(total_deaths) as so_hy_sinh  from Death where continent is not null group by continent 
union all
select 'total' as continent, sum(total_deaths) as so_hy_sinh from Death where continent is not null order by 2
-- so luong ca nhiem moi va so ca chet moi theo ngay
select date, sum(new_cases), sum(new_deaths) as so_ca_moi from Death group by date
-- so luong duoc tiem vaccine / dan so
with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated) as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over
(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated from Death dea
join Vaccination vac
on dea.location = vac.location
and dea.date = vac.date
and dea.iso_code = vac.iso_code
and dea.continent = vac.continent)
select * from popvsvac order by 5 desc

