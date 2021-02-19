#create database Asian_Games;


use Asian_Games;



-- -----------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLES
-- -----------------------------------------------------------------------------------------------------------------------------


create table Asian_Games(
Year int not null,
Code varchar(5) not null,
Gold int not null,
Silver int not null,
Bronze int not null
);

insert into Asian_Games (Year, Code, Gold, Silver, Bronze) 
values

(2018,  'CHN',	132,	92,	66),
(2018, 'JPN',	75,	57,	73),
(2018, 'KOR',	49,	58,	70),
(2018, 'INA'	,31,	24,	43),
(2018, 'IRI'	,20,	20,	22),
(2018, 'IND'	,16,	23,	31),
(2018, 'KAZ',	15,	18,	43),	
(2018,'PRK',	12,	12,	13),	
(2018,'SIN',	4,	4,	14),
(2018,'PAK',	0,	0,	4),

(2014,  'CHN',	151,	109,	85),
(2014,  'JPN',	47,	77,	76),	
(2014,  'KOR',	79,	70,	79),
(2014,  'INA',	10,	18,	23),	
(2014,  'IRI',	21,	18,	18),	
(2014,  'IND',	11,	10,	36),	
(2014,  'KAZ',	28,	23,	33),	
(2014,  'PRK',	11,	11,	14),	
(2014,  'SIN',	5,	6,	14),	
(2014,  'PAK',	1,	1,	3),	

(2010,  'CHN',	199	,119,98),
(2010, 'JPN',	48,74,94)	,
(2010, 'KOR',	76,65,91),
(2010, 'INA',4	,2,13),
(2010, 'IRI',20	,15,24),
(2010, 'IND',14,17,34),
(2010, 'KAZ',18,23,38),	
(2010,'PRK',6,10,20),	
(2010,'SIN',4,7,6),
(2010,'PAK',3,2,3),

(2006,  'CHN',165,88,63),
(2006, 'JPN',	50,	72	,78)	,
(2006, 'KOR',	58,	52	,83),
(2006, 'INA',2,	4,	14),
(2006, 'IRI',11	,15	,22),
(2006, 'IND',10	,17,	26),
(2006, 'KAZ',23,	20,	42),	
(2006,'PRK',6,	8,	15),	
(2006,'SIN',8,	7,	12),
(2006,'PAK',0,	1	,3),

(2002,'CHN',150,	84,	74),	
(2002,'JPN',	44,	73,	72),
(2002,'KOR',96,	80,	84),	
(2002,'INA',	4,	7,	12),	
(2002,'IRI',	8,	14,	14),	
(2002,'IND',	11,	12,	13),	
(2002,'KAZ',20,	26,	30),
(2002,'PRK',9,	11,	13),	
(2002,'SIN',	5,	2,	10),	
(2002,'PAK',1,	6,	6);


select * from Asian_Games;



create table dictionary(country varchar(20) not null unique, 
code varchar(5) unique, 
population float, 
GDP_per_capita_USD float,
location_id int not null );


insert into dictionary values ( 'China' ,'CHN',1387160730,19503,2);
insert into dictionary values ( 'Japan' ,'JPN',126891000,46827,1);
insert into dictionary values ( 'South Korea' ,'KOR',50617000,44740,1);
insert into dictionary values ( 'Indonesia' ,'INA',255462000,13998,21);
insert into dictionary values ( 'India' ,'IND',1324009090,9026,2);
insert into dictionary values ( ' Iran' ,'IRI',82000000,17661,3);
insert into dictionary values ( 'Kazakhstan' ,'KAZ',18906000,28849,4);
insert into dictionary values ( 'North Korea' ,'PRK',25863000,44540,1);
insert into dictionary values ('Pakistan', 'PAK', 202785000, 5871, 2);
insert into dictionary values ('Singapore', 'SIN', 5541000, 103180, 21);


select * from dictionary;


create table locations(location_id int primary key, location_name varchar(20));

insert into locations values(1,'East_Asia');
insert into locations values(2,'South_Asia');
insert into locations values(21,'SouthEast_Asia');
insert into locations values(3,'West_Asia');
insert into locations values(4,'Central_Asia');

select * from locations;

-- -----------------------------------------------------------------------------------------------------------------------------
-- VIEW TABLES
-- -----------------------------------------------------------------------------------------------------------------------------

create view All_Data as(
select a.Year,a.Code,d.country,a.Gold,a.Silver,a.Bronze,
a.Gold+a.Silver+a.Bronze as Total_Medal,
d.population,d.GDP_per_capita_USD,l.location_name 
from Asian_Games as a 
inner join dictionary as d 
on a.Code=d.code 
inner join locations as l 
on l.location_id=d.location_id);

select * from All_Data;


create view TM as (
select a.year, a.code, d.country, a.gold, a.silver, a.bronze, 
(a.gold + a.silver + a.bronze) as Total_Medal
from Asian_Games a inner join dictionary d
on d.code = a.code
order by Total_Medal desc);

select * from TM;

create view Diff_val as(
select *, lag(Total_Medal,1) over (partition by country order by year) as Lag_val,
Total_medal - lag(Total_Medal,1) over (partition by country) as Difference_val
from tm
order by country);


select * from Diff_val;


create view avr as(select Year,avg(Gold+Silver+Bronze) over(partition by Year) as Average 
from asian_games);

select * from avr;





-- -----------------------------------------------------------------------------------------------------------------------------
-- Questions
-- -----------------------------------------------------------------------------------------------------------------------------
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


-- Q1- Show The rank of all country on the basics of Gold medals

select a.Year,a.Code,
d.country,a.gold,a.silver,a.Bronze ,d.GDP_per_capita_USD,
rank()over (partition by year order by a.gold desc) rank_gold_wise
from asian_games a  join dictionary d
on a.code=d.code;

-- Q2-show The rank of top performing country gdp wise per Year

select a.Year,a.Code,d.country,a.gold,a.silver,a.Bronze ,d.GDP_per_capita_USD,
rank()over (partition by year order by d.GDP_per_capita_USD desc) RANK_GDP_wise
from asian_games a  join dictionary d
on a.code=d.code
group by a.year,a.code order by RANK_GDP_wise
limit 5;

-- Q3- Distribution of Total Medals Per country through out the years

select * from All_Data;

-- Q4- Average medals won by all the countries over a span of 5 Year

select Year,Average from avr group  by year;

-- Q5 percent rank on total gold medals won by each country, gdp and population

select Country, Code, GDP_per_capita_USD, Population,
round(percent_rank() over(partition by year order by gdp_per_capita_USD ),3) as "GDP_%" ,
round(percent_rank() over(partition by year order by population ),3) as 'Populationrank%'
from All_Data
order by year;

-- Q6- percent rank on total medals over the period of 5 years

select year,country, total_medal, 
round(percent_rank() over(partition by year order by total_medal),3) as 'percent rank on total medals' 
from tm order by year ;

-- Q7. Compare the increse and decrease in the no of medals won by India and China.

select Year, Country, Difference_val 
from diff_val
where country = 'China' or country = 'Japan' or country = 'South Korea'
order by year;

-- Q8. which country faced the most increase and most decrease in the no of medals won?

select Year, Country, Difference_val as Most_Decrease 
from diff_val
where Difference_val=(select  min(Difference_val) from diff_val);

select Year, Country, (Difference_val) as Most_Increase 
from diff_val
where Difference_val=(select  max(Difference_val) from diff_val);



