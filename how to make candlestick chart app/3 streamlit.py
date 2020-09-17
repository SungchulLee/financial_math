# streamlit 설치 영상 : https://youtu.be/0TmWH5Rox_k

import streamlit as st
import yfinance as yf
import pandas as pd
import plotly.graph_objects as go
#from PIL import Image

# 타이틀 작성
st.write("""
# 주가 정보 프로그램
주가 정보를 시각화합니다!
""") 

# 이미지 디스플레이
# img = Image.open('/Users/sungchullee/Desktop/1fgsr.png')
# st.image(img, use_column_with=True)

# 왼쪽 위에 유저 인풋 헤더 만들기
st.sidebar.header('User Input')

# # 왼쪽 위에 유저 인풋 만들기 
ticker = st.sidebar.text_input('Stock Ticker', 'FB')
start = st.sidebar.text_input('Start Date', '2020-01-02')
end = st.sidebar.text_input('End Date', '2020-07-02')

# 데이터 획득하기
try:
    stock = yf.Ticker(ticker)
    #df = stock.history(start=start, end=end)
    df = stock.history(period='max') 
except:
    print('Please Check Your Input')
    
# 1개월, 3개월 이동평균 계산
df['avg_1m'] = df.Close.rolling(window=21*1).mean()
df['avg_3m'] = df.Close.rolling(window=21*3).mean()
   
# 최종 데이터 획득하기
df = df[start:end]

# 종가 보여주기
st.header(f'{ticker} 종가')
st.line_chart(df.Close)

# 캔들스틱
st.header(f'{ticker} 캔들스틱')

trace1 = go.Candlestick(
    x = df.index,
    open = df.Open,
    high = df.High,
    low = df.Low,
    close = df.Close,
    increasing_line_color = 'red',
    decreasing_line_color = 'blue',
    name =  f'{ticker}'
)

trace2 = {
    'x': df.index,
    'y': df.avg_1m,
    'type': 'scatter',
    'mode': 'lines',
    'line': {
        'width': 1,
        'color': 'blue'
            },
    'name': '1개월 이동평균선'
}

trace3 = {
    'x': df.index,
    'y': df.avg_3m,
    'type': 'scatter',
    'mode': 'lines',
    'line': {
        'width': 1,
        'color': 'red'
            },
    'name': '3개월 이동평균선'
}

trace4 = {
    'x': df.index,
    'y': df.Volume / df.Volume.max() * (0.2 * df.Close.min()) + (0.7 * df.Close.min()),
    'type': 'scatter',
    'mode': 'lines',
    'line': {
        'width': 1,
        'color': '#43da25'
            },
    'name': '거래량'
}

data= [trace1, trace2, trace3, trace4]

fig = go.Figure(data=data)
                    
fig.update_layout(
    title = f'{ticker}',
    xaxis_title = 'Date',
    yaxis_title = 'Stock Price',
    xaxis_rangeslider_visible = False
)

st.plotly_chart(fig, use_container_width=True)

# 볼륨 보여주기
st.header(f'{ticker} 볼륨')
st.line_chart(df.Volume)

# 통계 보여주기
st.header(f'{ticker} 통계')
st.write(df.describe())