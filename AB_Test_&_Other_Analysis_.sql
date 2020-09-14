select ph_city, ph_state, prov_name
from user1.database1
where upper(prov_name) LIKE '%CVS%' and upper(ph_state) LIKE 'TX%'
order by ph_city ASC;

select unique ph_state
from user1.database1
order by ph_state ASC;

select upper(ph_city), prov_name, Count(*) as count
from user1.database1
where upper(ph_city) = 'HOUSTON'
group by upper(ph_city), prov_name
order by upper(ph_city) DESC;

select ph_city, prov_name, Count(*) as count
from user1.database1
where upper(ph_city) LIKE 'AUSTIN%'
group by ph_city, prov_name
order by count DESC;

select upper(ph_city), count(*) as CNT
from user1.database1
where upper(ph_city) = 'HOUSTON'
group by upper(ph_city);

select treat_date, count(*) as CNT
from user1.database1
where upper(ph_city) = 'HOUSTON' and treat_date between '2019/7/1' and '2020/6/30'
group by treat_date
order by treat_date DESC;


select a.YM, a.CNT/b.total
from (select extract(year from c.treat_date) * 100 + extract(month from c.treat_date) as YM, count(distinct c.claim_no) as CNT
from user1.database1 c
inner join user2.treatment_database d
on c.policy_no = d.policy_no and c.treat_date = d.treat_date and c.diag_code = d.diag_code
where c.treat_date between '01-JUL-2019' and '30-JUN-2020'
group by extract(year from c.treat_date) * 100 + extract(month from c.treat_date)) a
inner join (select sum(CNT) as total
from (select extract(year from cc.treat_date) * 100 + extract(month from cc.treat_date) as YM, count(distinct cc.claim_no) as CNT
from user1.database1 cc
inner join user2.treatment_database dd
on cc.policy_no = dd.policy_no and cc.treat_date = dd.treat_date and cc.diag_code = dd.diag_code
where cc.treat_date between '01-JUL-2019' and '30-JUN-2020'
group by extract(year from cc.treat_date) * 100 + extract(month from cc.treat_date))) b
on 1 = 1;

select a.YM, a.CNT/b.total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'AUSTIN'
group by extract(year from treat_date) * 100 + extract(month from treat_date)) a
inner join (select sum(CNT) as total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'AUSTIN'
group by extract(year from treat_date) * 100 + extract(month from treat_date))) b
on 1 = 1;

select a.YM, a.CNT/b.total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'DALLAS'
group by extract(year from treat_date) * 100 + extract(month from treat_date)) a
inner join (select sum(CNT) as total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'DALLAS'
group by extract(year from treat_date) * 100 + extract(month from treat_date))) b
on 1 = 1;

select a.YM, a.CNT/b.total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'SAN ANTONIO'
group by extract(year from treat_date) * 100 + extract(month from treat_date)) a
inner join (select sum(CNT) as total
from (select extract(year from treat_date) * 100 + extract(month from treat_date) as YM, count(distinct claim_no) as CNT
from user1.database1
where treat_date between '01-JUL-2019' and '30-JUN-2020' and upper(ph_city) = 'SAN ANTONIO'
group by extract(year from treat_date) * 100 + extract(month from treat_date))) b
on 1 = 1;

select policy_no, policy_term, sum(claimedamount), sum(paidamount)
from user2.treatment_database
group by policy_no, policy_term
order by policy_no;

select a.policy_no, b.mpt, a.cca, a.cpa, c.policy_term, c.pca, c.ppa, d.zip, e.name, e.RG_ABBREV, e.TOTPOP_CY, e.TOTHH_CY, e.AGE_AVG, e.AVG_HOME_INCOME, e.AVG_DEP_INCOME, e.AVG_HOMEVAL
from (select policy_no, policy_term, sum(claimedamount) as cca, sum(paidamount) as cpa
from user2.treatment_database
group by policy_no, policy_term) a
inner join (select policy_no, max(policy_term) as mpt
from user2.treatment_database
group by policy_no) b
on a.policy_no = b.policy_no and a.policy_term = b.mpt
left join (select policy_no, policy_term, sum(claimedamount) as pca, sum(paidamount) as ppa
from user1.database1
group by policy_no, policy_term) c
on a.policy_no = c.policy_no and (a.policy_term - 1) = c.policy_term
left join (select policy_no, substr(ph_zip, 1, 5) as zip
from user1.database1
group by policy_no, ph_zip) d
on a.policy_no = d.policy_no
left join (select zip, name, RG_ABBREV, TOTPOP_CY, TOTHH_CY, AGE_AVG, AVG_HOME_INCOME, AVG_DEP_INCOME, AVG_HOMEVAL
from user2.first_cbsa_1
group by zip, name, RG_ABBREV, TOTPOP_CY, TOTHH_CY, AGE_AVG, AVG_HOME_INCOME, AVG_DEP_INCOME, AVG_HOMEVAL) e
on d.zip = e.zip 
order by policy_no;

select zip, sum(cpa) as scpa, AVG_HOME_INCOME, TOTPOP_CY
from (select a.policy_no, b.mpt, a.cca, a.cpa, c.policy_term, c.pca, c.ppa, d.zip, e.name, e.RG_ABBREV, e.TOTPOP_CY, e.TOTHH_CY, e.AGE_AVG, e.AVG_HOME_INCOME, e.AVG_DEP_INCOME, e.AVG_HOMEVAL
from (select policy_no, policy_term, sum(claimedamount) as cca, sum(paidamount) as cpa
from user2.austin_database
group by policy_no, policy_term) a
inner join (select policy_no, max(policy_term) as mpt
from user2.austin_database
group by policy_no) b
on a.policy_no = b.policy_no and a.policy_term = b.mpt
left join (select policy_no, policy_term, sum(claimedamount) as pca, sum(paidamount) as ppa
from user1.database1
group by policy_no, policy_term) c
on a.policy_no = c.policy_no and (a.policy_term - 1) = c.policy_term
left join (select policy_no, substr(ph_zip, 1, 5) as zip
from user1.database1
group by policy_no, ph_zip) d
on a.policy_no = d.policy_no
left join (select zip, name, RG_ABBREV, TOTPOP_CY, TOTHH_CY, AGE_AVG, AVG_HOME_INCOME, AVG_DEP_INCOME, AVG_HOMEVAL
from user2.first_cbsa_1) e
on d.zip = e.zip)
group by zip, AVG_HOME_INCOME, TOTPOP_CY
order by scpa desc;

select policy_no, max(policy_term) as mpt, sum(claimedamount) as cca, sum(paidamount) as cpa
from user2.treatment_database
group by policy_no;

select unique b.zip
from (select policy_no
from user2.austin_database) a
inner join (select policy_no, substr(ph_zip, 1, 5) as zip
from user1.database1
group by policy_no, ph_zip) b
on a.policy_no = b.policy_no;

create table user2.first_CBSA (zip varchar(5), name varchar(30));

create table user2.first_CBSA_1(zip varchar(5), NAME varchar(30), RG_ABBREV varchar(2), TOTPOP_CY varchar(10), TOTHH_CY varchar(10), Age_avg varchar(4), 
       Avg_home_Income varchar(10), Avg_Dep_Income varchar(10), Avg_HomeVal varchar(10));
