libname in '/home/u63354426/SAS_Project';


 Clean the data first
*Import crsp and calculate forward 1 month returns;
*Create year_month column and we can use this as a primary key;
proc sort data = crsp_monthly; by permno descending date;
run;
data crsp_monthly; set in.crsp_monthly;
  fwd_ret = lag(ret);
  m = put(month(date),z2.);
  y = year(date);
  year_month = cats(y,m);
run;
proc sort data = crsp_monthly; by permno date;
run;


 Get the monthly tweet count using data from daily tweets;
data tweets_daily; set in.tweets_daily;
  m = put(month(date),z2.);
  y = year(date);
  year_month = cats(y,m);
run;

*We sum the daily tweets for each stock in a month to obtain monthly tweet count;
proc sql;
  create table tweets_monthly
  as select permno, year_month, sum(tweets) as monthly_tweets
  from tweets_daily 
  group by permno, year_month;
run;
data in.tweets_monthly; set tweets_monthly;
run;

* Clean the analyst report dataset and obtain a monthly version;
* Create year_month column;
data analyst_reports; set in.analyst_reports;
  m = put(month(date),z2.);
  y = year(date);
  year_month = cats(y,m);
run;
*Monthly data is obtained by getting the average of the tone and the average buy sell recommendation for the month;
proc sql;
  create table analyst_reports_monthly
  as select permno, year_month, avg(tone) as tone ,avg(buysell) as buysell
  from analyst_reports
  group by permno, year_month;
data in.analyst_reports_monthly; set analyst_reports_monthly;
run;

proc export data=work.tweets_daily
  outfile = '/home/u63354426/Output/tweets_daily.csv'
  dbms = csv replace;
run;

proc sort data = crsp_monthly; by permno year_month;
proc sort data = analyst_reports_monthly; by permno year_month;
proc sort data = tweets_monthly; by permno year_month;
*Create features for long short decision making;
proc sql;
  create table df as
  select c.permno,c.date,c.year_month,c.ret,c.fwd_ret,t.monthly_tweets, r.tone,r.buysell
  from crsp_monthly as c, tweets_monthly as t, analyst_reports_monthly as r
  where (c.permno = t.permno and c.year_month = t.year_month)
  and (c.permno = r.permno and c.year_month = r.year_month);
run;
proc sort data = df;by year_month;
run;

*Rank the data by the number of tweets and analyst reports tone, and analyst report recommendations;
proc rank data=df out=df_ranked groups = 5;
  by year_month;
  var tone;
  ranks tone_rank;
run;
* Rank the tweets in a descending manner => higher tweet count = lower score. We assume that retail investors on twitter do not 
have an information edge and retail investors have a negative probabilistic edge;
proc rank data = df_ranked out = df_ranked groups = 5 descending;
  by year_month;
  var monthly_tweets;
  ranks tweets_rank;
run;
proc rank data=df_ranked out=df_ranked groups = 3;
  by year_month;
  var buysell;
  ranks analyst_recommendation_rank;
run;
*Use weighted arithmetic mean to obtain the combined score;
proc sql;
  create table df_final as(
  select *, (3*tone_rank+5*analyst_recommendation_rank+3*tweets_rank)/11 as combined_score
  from
  df_ranked
  group by permno, year_month);
run;
proc sort data = df_final; by year_month;
* Rank the combined score into 3 distinct groups;
proc rank data=df_final out=df_final groups = 3;
  by year_month;
  var combined_score;
  ranks combined_rank;
run;
*If combined score is == 0, we short, if the combined rank == 2, we long, else we have no view and do not take a position;
data df_backtest; set df_final;
  signal = combined_rank;
  if combined_rank =0 then signal = -1;
  if combined_rank = 2 then signal = 1;
  if combined_rank = 1 then signal = 0;
run;

data in.df_backtest; set df_backtest;
run;


proc export data=work.df_backtest
  outfile = '/home/u63354426/Output/df_backtest.csv'
  dbms = csv replace;
run;

* Delete rows where the signal is equal to zero and calculate backtested returns;
data df_backtest; set df_backtest;
  if signal = 0 then delete;
  returns = signal * fwd_ret;
run;

* Obtain long/short datasets for the signals;
proc sql;
  create table long_df as(
  select * from df_backtest
  where signal =1
  );
proc sql;
  create table short_df as(
  select * from df_backtest
  where signal = -1
  );
  
proc export data=work.long_df
  outfile = '/home/u63354426/Output/long_backtest.csv'
  dbms = csv replace;
run;
proc export data=work.short_df
  outfile = '/home/u63354426/Output/short_backtest.csv'
  dbms = csv replace;
run;

proc sql;
  create table df_returns as(
  select date,avg(returns) as long_short_returns
  from df_backtest
  group by date
  );
run;
* Calculate compounded returns;
data df_returns; set df_returns;
  retain long_short_compounded_returns 1;
  long_short_compounded_returns = (1+long_short_returns) * long_short_compounded_returns;
data df_returns; set df_returns;
  long_short_compounded_returns = long_short_compounded_returns-1;
run;

proc export data=work.df_returns
  outfile = '/home/u63354426/Output/df_returns.csv'
  dbms = csv replace;
run;

*Join fama french factors and market factor to long/short strategy to evaluate the alpha of the portfolio;
proc sql;
  create table temp as(
  select df_returns.*, factors_monthly.*
  from df_returns join in.factors_monthly
  on df_returns.date = factors_monthly.date
  );
run;

*Calculate alphas for the long_short strategy;
data alpha_eval; set temp;
  mkt_factor = rf+mktrf;
  market_alpha = long_short_returns - mkt_factor;
  size_alpha = long_short_returns -smb;
  value_alpha = long_short_returns - hml;
  momentum_alpha = long_short_returns - umd;
run;
proc export data=work.alpha_eval
  outfile = '/home/u63354426/Output/alpha_eval.csv'
  dbms = csv replace;

*Calculate Sharpe Ratio;
*First create a year column since that is going to be our group by criteria;
data alpha_eval; set alpha_eval;
  year = year(date);
proc sql;
  create table sharpe_ratio as(
  select year,((avg(long_short_returns-rf))/std(long_short_returns)) as sharpe
  from alpha_eval
  group by year
  );
run;

proc export data=work.sharpe_ratio
  outfile = '/home/u63354426/Output/sharpe_ratio.csv'
  dbms = csv replace;
  
proc sgplot data = df_returns;
  series x = date y=long_short_compounded_returns;
run;
proc export data=work.short_df
  outfile = '/home/u63354426/Output/short_backtest.csv'
  dbms = csv replace;
run;
proc sql;
  create table short_returns as(
  select year_month,avg(fwd_ret * signal) as short_returns
  from short_df
  group by year_month);
run;

proc sql;
  create table long_returns as(
  select year_month,avg(fwd_ret * signal) as short_returns
  from long_df
  group by year_month);
run;
proc export data=work.short_returns
  outfile = '/home/u63354426/Output/short_returns.csv'
  dbms = csv replace;
run;
proc export data=work.long_returns
  outfile = '/home/u63354426/Output/long_returns.csv'
  dbms = csv replace;
run;
