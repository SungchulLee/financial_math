# import modules
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.linear_model import LinearRegression
# %matplotlib inline


# make directory if not exist
if not os.path.isdir("img"):
    os.mkdir('img')


# read csv file
start = "2017-01-01"
end = "2017-12-31"
dates = pd.date_range(start, end)

benchmark = "SPY"
ticker_list = ["WMT", benchmark]

data_dir = "../data/finance/dow30"

for data_type in ["Open", "High", "Low", "Close", "Adj Close", "Volume"]:

    df = pd.DataFrame(index=dates)
    for ticker in ticker_list:
        csv_file_path = os.path.join(data_dir, ticker + ".CSV")

        df_temp = pd.read_csv(csv_file_path,
                              index_col="Date",
                              parse_dates=True,
                              usecols=["Date", data_type],
                              na_values=["null"])

        df_temp = df_temp.rename(columns={data_type: ticker})
        df = df.join(df_temp)

        if ticker == benchmark:
            df = df.dropna(subset=[benchmark])

    if data_type == "Open":
        df_open = df
    if data_type == "High":
        df_high = df
    if data_type == "Low":
        df_low = df
    if data_type == "Close":
        df_close = df
    if data_type == "Adj Close":
        df_adj_close = df
    if data_type == "Volume":
        df_volume = df


# normalize price
df_normalized_adj_close = df_adj_close / df_adj_close.iloc[0, :]


# compute daily return
df_daily_return = df_adj_close.pct_change()


# compute expected return
def compute_expected_return(df_daily_return):
    return 252 * df_daily_return.mean()


df_mu = compute_expected_return(df_daily_return)


# compute volatility
def compute_volatility(df_daily_return):
    return np.sqrt(252) * df_daily_return.std()


df_vol = compute_volatility(df_daily_return)


# compute covariance matrix
def compute_covariance_matrix(df_daily_return):
    return 252 * df_daily_return.cov()


df_cov = compute_covariance_matrix(df_daily_return)


# plot risk-return plot
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.savefig('img/two asset risk-return plot.png')


# linear regression
x = df_daily_return.SPY[1:]
y = df_daily_return.WMT[1:]

model = LinearRegression(fit_intercept=True)
model.fit(x[:, np.newaxis], y)
y_pred = model.predict(x[:, np.newaxis])

xfit = np.linspace(x.min(), x.max(), 2)
yfit = model.predict(xfit[:, np.newaxis])

plt.plot(x, y, '.')
plt.plot(xfit, yfit)
plt.grid()

plt.savefig('img/two asset linear regression.png')


# performance of linear regression
alpha = model.intercept_
beta = model.coef_[0]
R_square = 1 - (np.sum((y - y_pred)**2) / np.sum((y - y.mean())**2))


# construction of equal portfolio
portfolio_weight = [0.5, 0.5]
df_portfolio = df_normalized_adj_close.copy()
df_portfolio['Portfolio'] = (portfolio_weight * df_normalized_adj_close).sum(axis=1)


# compute statistics
df_daily_return = df_portfolio.pct_change()
df_mu = compute_expected_return(df_daily_return)
df_vol = compute_volatility(df_daily_return)
df_cov = compute_covariance_matrix(df_daily_return)


# plot risk-return plot
ticker_list = ['WMT', 'SPY', 'Portfolio']
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.savefig('img/two asset with portfolio risk-return plot.png')


# compute statistics of many random portfolios
num_assets = df_normalized_adj_close.shape[1]
num_portfolios = 25000
mc_results = np.zeros((num_portfolios, 3 + num_assets))

for i in range(num_portfolios):
    portfolio_weight = np.random.random(num_assets)
    portfolio_weight /= np.sum(portfolio_weight)

    df_portfolio = (portfolio_weight * df_normalized_adj_close).sum(axis=1)
    df_daily_return = df_portfolio.pct_change()

    df_mu = compute_expected_return(df_daily_return)
    df_vol = compute_volatility(df_daily_return)

    mc_results[i, 0] = df_mu
    mc_results[i, 1] = df_vol
    mc_results[i, 2] = df_mu / df_vol

    for j in range(num_assets):
        mc_results[i, j + 3] = portfolio_weight[j]

columns = ['mu', 'vol', 'sharpe']
for j in range(num_assets):
    columns.append(df_normalized_adj_close.columns[j] + '_weight')

pd_mc_results = pd.DataFrame(mc_results, columns=columns)


# plot risk-return plot
plt.figure(figsize=(12, 6))
plt.scatter(pd_mc_results.vol,
            pd_mc_results.mu,
            c=pd_mc_results.sharpe)
plt.grid()
plt.savefig('img/many random portfolios risk-return plot.png')


# portfolio with highest sharpe ratio
max_sharpe_port = pd_mc_results.iloc[pd_mc_results.sharpe.idxmax()]


# GMVP
min_vol_port = pd_mc_results.iloc[pd_mc_results.vol.idxmin()]


# plot risk-return plot with GMVP and portfolio with highest sharpe ratio
plt.figure(figsize=(12, 6))
plt.scatter(pd_mc_results.vol,
            pd_mc_results.mu,
            c=pd_mc_results.sharpe)
plt.colorbar()
plt.grid()

plt.xlabel('Volatility')
plt.ylabel('Returns')

plt.scatter(max_sharpe_port[1], max_sharpe_port[0], c='r',
            marker='*', s=500)
plt.scatter(min_vol_port[1], min_vol_port[0], c='g',
            marker='*', s=500)

plt.savefig('img/two asset efficient frontier.png')
