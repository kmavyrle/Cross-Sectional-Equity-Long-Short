libname in '/home/u63354426/SAS_Project';

** Clean the data first
*Import crsp and calculate forward returns;
data crsp_monthly; set in.crsp_monthly;
proc sort data = crsp_monthly; by permno descending date;
data crsp_monthly; set crsp_monthly;
	fwd_ret = lag(ret);
proc sort data = crsp_monthly; by permno date;
run;
** Get the monthly tweet count;
data tweets_daily; set in.tweets_daily;
	m = put(month(date),z2.);
	y = year(date);
	year_month = cats(y,m);
run;
proc sql;
	create table tweets_monthly
	as select permno, year_month, sum(tweets) as monthly_tweets
	from tweets_daily 
	group by permno, year_month;
run;
data in.tweets_monthly; set tweets_monthly;
run;
* Clean the analyst report dataset;
data analyst_reports; set in.analyst_reports;
	m = put(month(date),z2.);
	y = year(date);
	year_month = cats(y,m);
run;
proc sql;
	create table analyst_reports_monthly
	as select permno, year_month, avg(tone) as tone ,avg(buysell) as buysell
	from analyst_reports
	group by permno, year_month;
data in.analyst_reports_monthly; set analyst_reports_monthly;
run;
