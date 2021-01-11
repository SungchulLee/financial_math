# import modules
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import scipy.linalg as la
# %matplotlib inline


# make directory if not exist
if not os.path.isdir('img'):
    os.mkdir('img')


# prepare for data loading
start = "2017-01-01"
end = "2017-12-31"
dates = pd.date_range(start, end)

data_dir = "../data/finance/dow30"


# make csv file list
csv_file_list = os.listdir(data_dir)
if csv_file_list[0] == '.DS_Store':
    csv_file_list = os.listdir(data_dir)[1:]


# make ticker list including benchmark
ticker_list = []
for csv_file in csv_file_list:
    ticker_list.append(csv_file.replace(".csv", ""))

benchmark = 'SPY'
if benchmark not in ticker_list:
    ticker_list.append(benchmark)


# data loading
for data_type in ["Open", "High", "Low", "Close", "Adj Close", "Volume"]:

    df = pd.DataFrame(index=dates)
    for ticker in ticker_list:
        csv_file_path = os.path.join(data_dir, ticker + ".csv")

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
def normalize_price(price):
    return price / price.iloc[0, :]


df_normalized_adj_close = normalize_price(df_adj_close)


# compute daily return
def compute_daily_return(price):
    return price.pct_change()


df_daily_return = compute_daily_return(df_adj_close)


# compute expected return
def compute_expected_return(df_daily_return):
    return 252 * df_daily_return.mean()


df_mu = compute_expected_return(df_daily_return)


# compute volatility
def compute_volatility(df_daily_return):
    return np.sqrt(252) * df_daily_return.std()


df_vol = compute_volatility(df_daily_return)


# compute sharpe ratio
def compute_sharpe_ratio(mu, vol):
    return mu / vol


df_sharpe = compute_sharpe_ratio(df_mu, df_vol)


# compute covariance matrix
def compute_covariance_matrix(df_daily_return):
    return 252 * df_daily_return.cov()


df_cov = compute_covariance_matrix(df_daily_return)


# plot risk-return plot
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.savefig('img/many assets risk-return plot.png')


# construction of equal portfolio
n = len(ticker_list)
weights_equal = np.ones((n,)) / n
adj_close_equal = np.sum(weights_equal * df_normalized_adj_close, axis=1)
daily_return_equal = adj_close_equal.pct_change()
mu_equal = compute_expected_return(daily_return_equal)
vol_equal = compute_volatility(daily_return_equal)


# plot risk-return plot
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
ax.scatter(vol_equal, mu_equal, alpha=0.5)
ax.annotate('EQL', (vol_equal, mu_equal))
plt.savefig('img/many assets + EQL risk-return plot.png')


# construction of random portfolio with no short positions
n = len(ticker_list)
weights = np.random.uniform(0., 1., (n,))
weights_random = weights / np.sum(weights)
adj_close_random = np.sum(weights_random * df_normalized_adj_close, axis=1)
daily_return_random = adj_close_random.pct_change()
mu_random = compute_expected_return(daily_return_random)
vol_random = compute_volatility(daily_return_random)


# plot risk-return plot
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
ax.scatter(vol_random, mu_random, alpha=0.5)
ax.annotate('RND', (vol_random, mu_random))
plt.savefig('img/many assets + RND_no_short risk-return plot.png')


# construction of random portfolio
n = len(ticker_list)
weights = 1 + np.random.normal(0., 1., (n,))
weights_random = weights / np.sum(weights)
adj_close_random = np.sum(weights_random * df_normalized_adj_close, axis=1)
daily_return_random = adj_close_random.pct_change()
mu_random = compute_expected_return(daily_return_random)
vol_random = compute_volatility(daily_return_random)


# plot risk-return plot
fig, ax = plt.subplots()
for i, ticker in enumerate(ticker_list):
    ax.scatter(df_vol[i], df_mu[i], alpha=0.5)
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
ax.scatter(vol_random, mu_random, alpha=0.5)
ax.annotate('RND', (vol_random, mu_random))
plt.savefig('img/many assets + RND risk-return plot.png')


# construction of many random portfolios
n_portfolios = 10000

weights_list = []
mu_list = []
vol_list = []
sharpe_list = []
for _ in range(n_portfolios):
    n = len(ticker_list)
    weights = 1 + np.random.normal(0., 1., (n,))
    weights = weights / np.sum(weights)
    adj_close = np.sum(weights * df_normalized_adj_close, axis=1)

    daily_return = adj_close.pct_change()
    mu = compute_expected_return(daily_return)
    vol = compute_volatility(daily_return)

    weights_list.append(weights)
    mu_list.append(mu)
    vol_list.append(vol)
    sharpe_list.append(mu / vol)

mu_list = pd.Series(mu_list)
vol_list = pd.Series(vol_list)
sharpe_list = pd.Series(sharpe_list)


# portfolio with highest sharpe ratio obtained using simulation
sharpe_idx = sharpe_list.idxmax()
sharpe_weights = weights_list[sharpe_idx]


# GMVP obtained using simulation
gmvp_idx = vol_list.idxmin()
gmvp_weights = weights_list[gmvp_idx]


# plot risk-return plot with GMVP and portfolio with highest sharpe ratio
fig = plt.figure()
ax = fig.gca()

plt.scatter(df_vol, df_mu, alpha=0.5, c=df_sharpe)
plt.scatter(vol_list, mu_list, alpha=0.5, c=sharpe_list)
for i, ticker in enumerate(ticker_list):
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.colorbar()

ax.scatter(vol_list[sharpe_idx], mu_list[sharpe_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='r')
ax.scatter(vol_list[gmvp_idx], mu_list[gmvp_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='g')
ax.annotate('Sharpe', (vol_list[sharpe_idx], mu_list[sharpe_idx]))
ax.annotate('GMVP', (vol_list[gmvp_idx], mu_list[gmvp_idx]))

plt.xlabel('Volatility')
plt.ylabel('Returns')
plt.grid()

plt.savefig('img/risk-return plot with GMVP and portfolio with highest sharpe ratio.png')


# gmvp obtained using formular
A = df_cov
B = la.inv(np.array(A))
C = B@np.ones((31, 1))
C = C / np.sum(C)
w_gmvp = C.reshape((-1,))
adj_close = np.sum(w_gmvp * df_normalized_adj_close, axis=1)
daily_return = adj_close.pct_change()
mu_gmvp = compute_expected_return(daily_return)
vol_gmvp = compute_volatility(daily_return)


# plot risk-return plot with GMVP, GMVP2 and portfolio with highest sharpe ratio
fig = plt.figure()
ax = fig.gca()

plt.scatter(df_vol, df_mu, alpha=0.5, c=df_sharpe)
plt.scatter(vol_list, mu_list, alpha=0.5, c=sharpe_list)
for i, ticker in enumerate(ticker_list):
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.colorbar()

ax.scatter(vol_list[sharpe_idx], mu_list[sharpe_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='r')
ax.scatter(vol_list[gmvp_idx], mu_list[gmvp_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='g')
ax.scatter(vol_gmvp, mu_gmvp, alpha=0.5,
           marker=(5, 1, 0), s=300, c='g')
ax.annotate('Sharpe', (vol_list[sharpe_idx], mu_list[sharpe_idx]))
ax.annotate('GMVP', (vol_list[gmvp_idx], mu_list[gmvp_idx]))
ax.annotate('GMVP2', (vol_gmvp, mu_gmvp))

plt.xlabel('Volatility')
plt.ylabel('Returns')
plt.grid()

plt.savefig('img/risk-return plot with GMVP, GMVP2 and portfolio with highest sharpe ratio.png')


# formula wins over simulation
print("GMVP Vol obtained using simulation: {}".format(vol_list[gmvp_idx]))
print("GMVP Vol obtained using formula:    {}".format(vol_gmvp))


# sharpe portfolio obtained using formular
def sharpe(r):
    A = df_cov
    B = la.inv(np.array(A))
    C = B@(np.array(df_mu).reshape((-1, 1)) - r)
    C = C / np.sum(C)
    w_sharpe = C.reshape((-1,))
    adj_close = np.sum(w_sharpe * df_normalized_adj_close, axis=1)
    daily_return = adj_close.pct_change()
    mu_sharpe = compute_expected_return(daily_return)
    vol_sharpe = compute_volatility(daily_return)
    return w_sharpe, mu_sharpe, vol_sharpe


w_sharpe, mu_sharpe, vol_sharpe = sharpe(0)


# formula wins over simulation
print("Sharpe Ratio obatined using simulation: {}".format(mu_list[sharpe_idx] / vol_list[sharpe_idx]))
print("Sharpe Ratio obatined using formula:    {}".format(mu_sharpe / vol_sharpe))


# construction of efficient frontier
n_portfolio = 1000

t = np.linspace(-2, 2, n_portfolio)
frontier_weights_list = []
frontier_mu_list = []
frontier_vol_list = []
for i in range(n_portfolio):
    n = len(ticker_list)
    frontier_weights = t[i] * w_gmvp + (1 - t[i]) * w_sharpe
    adj_close = np.sum(frontier_weights * df_normalized_adj_close, axis=1)

    daily_return = adj_close.pct_change()
    frontier_mu = compute_expected_return(daily_return)
    frontier_vol = compute_volatility(daily_return)

    frontier_weights_list.append(frontier_weights)
    frontier_mu_list.append(frontier_mu)
    frontier_vol_list.append(frontier_vol)

frontier_mu_list = pd.Series(frontier_mu_list)
frontier_vol_list = pd.Series(frontier_vol_list)


# plot of efficient frontier
fig = plt.figure()
ax = fig.gca()

plt.scatter(df_vol, df_mu, alpha=0.5, c=df_sharpe)
plt.scatter(vol_list, mu_list, alpha=0.5, c=sharpe_list)
for i, ticker in enumerate(ticker_list):
    ax.annotate(ticker, (df_vol[i], df_mu[i]))
plt.colorbar()

ax.scatter(vol_list[sharpe_idx], mu_list[sharpe_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='r')
ax.scatter(vol_list[gmvp_idx], mu_list[gmvp_idx], alpha=0.5,
           marker=(5, 1, 0), s=300, c='g')
ax.scatter(vol_sharpe, mu_sharpe, alpha=0.5,
           marker=(5, 1, 0), s=300, c='r')
ax.scatter(vol_gmvp, mu_gmvp, alpha=0.5,
           marker=(5, 1, 0), s=300, c='g')
ax.annotate('Sharpe', (vol_list[sharpe_idx], mu_list[sharpe_idx]))
ax.annotate('GMVP', (vol_list[gmvp_idx], mu_list[gmvp_idx]))
ax.annotate('Sharpe2', (vol_sharpe, mu_sharpe))
ax.annotate('GMVP2', (vol_gmvp, mu_gmvp))

ax.plot(frontier_vol_list, frontier_mu_list)

plt.xlabel('Volatility')
plt.ylabel('Returns')
plt.grid()

plt.savefig('img/efficient frontier.png')
