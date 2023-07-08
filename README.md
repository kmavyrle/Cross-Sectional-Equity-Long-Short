# Cross Sectional Equity Long Short

SAS Project 
1. Detail how you constructed your long-short portfolio.
Our long-short portfolio is constructed using three factors namely 1) monthly tweet count, 2) analyst report buy or sell signal and 3) the analyst report tone.. To construct portfolio, we looked at the monthly signals whereby we transformed the daily tweets and analyst reports to a monthly basis. Daily tweets were summed on a monthly basis to obtain the data, and we took averages of analyst signals and sentiment to form our monthly dataset. Our resultant factors used for our long-short portfolio were: monthly tweet count, monthly analyst buy-sell signal, and monthly average tone of analyst reports.
We ranked the stocks by each of these signals and grouped them according to the month and permno. A combined signal was then created using the average of the aforementioned rank. The following logic was used to the stocks for each factor:
Monthly tweet count: For monthly tweet counts, we grouped stocks into 3 groups per month. Stocks with higher tweets were given a lower rank. The underlying rationale being that retail investors tend to have little information edge and it would be a good idea to inverse their calls.
Analyst Buy Sell Recommendation and Tone: For these two factors, we grouped stocks into five distinct groups with highest analyst recommendation and the most positive tone given the higher rank.
 After that, we took a combined weighted average of the above ranking to form a new combined signal in which we re-ranked the stocks into 3 different groups (based on this new combined signal) which are:
Highest rank: buy
Lowest rank: sell
Middle rank: do nothing
We then calculated the forward looking returns and multiplied them by the signal in order to get the final values. The last step was to perform a cumulative returns calculation.

2. Detail your rationale for constructing your long-short portfolio. 
We will be executing our quantitative strategy monthly because we reckon that it will take a few days or even weeks for potential trading signals to form on the Twitter platform. Trading monthly will also allow us to minimize trading and transaction fees. Although we are aware of the fact that aggregating tweets and retweets monthly might not be the most appropriate approach (as Twitter is a very dynamic and fast-paced platform and public sentiments might not be captured very effectively), our research showed us some interesting statistics which led to us constructing our long-short portfolio based on monthly tweets:
Twitter is ranked 15th in terms of the number of users which is behind other social media platforms like Instagram and Facebook. 
96% of Twitter users claim that they only check or share content on Twitter on a monthly basis, 84% do this on a weekly basis, and only 52% use it daily. 
Additionally, we believe that a daily trading strategy is not the most favorable as it is more prone to variability and noise. An example of this could be: Wall Street Journal has discovered that about 20% of earnings on Fridays have a higher probability of being negative in comparison to the one announced on other weekdays. They also have a 25% chance of falling below the forecasts of analysts. Therefore, by taking a monthly measure of tweets and retweets, we can minimize the impact of such noises. Moreover, when thinking about analyst reports, they tend to be more forward looking, which take more than just a few days for their views to begin being priced in by the market. For example, analyst reports tend to take into account potential upside or downside risk events for a stock that may be coming in a few months, and a monthly view for this signal would make more sense.
Put differently, why should we expect your strategy to generate abnormal returns? Why should your strategy work in theory? [most important part; go back to Week 4, slides 12-20]
We expect out strategy to generate abnormal returns due to the fact that Twitter is a platform where we can see buzz and excitement from retail investors. Since tweets and retweets happen on a real-time basis and are easy to capture, they can be considered an alternative source of data which are often underutilized by mainstream investors. According to a study done by Ferrara and Yang (2015), positive content is much more preferred by Twitter users. The Positive Bias Effect or Pollyanna Effect claims that positive tweets are five times more favorable and 2.5 times more retweeted in comparison to negative or neutral content. Twitter is a platform where news and sentiments are conveyed faster compared to traditional sources of media. Additionally, since this strategy is based on buying stocks that are expected to outperform (long) while at the same time short selling stocks that are expected to perform poorly (short), investors will have the privilege of profiting from both the positive and negative movements in the market, despite of how the overall market’s performance is. This strategy should work in theory due to the fact that investors can reap the benefits of market inefficiencies. Market inefficiencies provide opportunities for mispricings, meaning that the value of a stock does not indicate its true worth. Therefore, by taking both long and short positions, these inefficiencies can be exploited by investors as they can profit from them.
Furthermore, analyst reports are often generated by financial analysts in the industry with deep knowledge and access to proprietary technology and information. They are also likely to have an information edge that the typical investor would not have access to. For example, financial analysts regularly conduct visits to portfolio companies which help them gain deeper insight on-the-ground, and generate more relevant analysis. We believe this will be a potential source of alpha for investors by evaluating analyst reports.

3. Plot the cumulative performance of your long-short strategy (in terms of raw returns). [Hint: If you work on a computer in the computer lab, export your returns from SAS into Excel and go from there. If you use SAS OnDemand, open the SAS dataset, copy the relevant data and paste them into Excel.


4. What was the average annual return on your long leg? What was the average annual return on your short leg? What was the average annual return on your long-short portfolio? What were the corresponding Sharpe Ratios? Finally, what were the corresponding alphas with respect to the Market Model and the 4-Factor Model? [go back to Week 5, slides 15-22]
Annualized Measures
Average Annual Returns (Longs)
Average Annual Returns (Shorts)
Returns 
18.34%
-9.41%
Standard Deviation
14.58%
14.26%
Sharpe Ratio
1.26
-0.66



 
Combined
Long Leg
Short Leg
Alpha (w.r.t 4 Factor Model)
1.2%
15%
-12.68%
Alpha (w.r.t Market Model)
-7.05%
6.64%
-13.69%


6. Overall, how would you assess your strategy's performance?
In assessing the strategy’s performance, I would look at several metrics such as the absolute returns level, standard deviation, and the sharpe of the portfolio. Our portfolio generated an annualised returns of 4.46% returns with a standard deviation of 2.73%. This gives an approximate sharpe of 1.63. We feel that this is a promising result as our portfolio volatility is very low relative to the returns that we have generated. In comparison a long only portfolio will be very susceptible to large drawdowns. Our long-short portfolio is more nimble and is able to take a short position in stocks that we have a negative view on.
In terms of generating abnormal returns over the market benchmark, our team felt that it was not a representative comparison. However, when we compare with the 4 factor model, which are essentially long-short portfolios (size, value and momentum) themselves(with the exception of the market portfolio), our portfolio had generated positive alpha over them.



References:
https://thesocialshepherd.com/blog/twitter-statistics 

