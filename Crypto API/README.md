
# **Crypto Currency Data Analysis**
In this project, I used Python to pull data from an API, automated the process, added a column to show when the pull was made and then saved it all to a local CSV file for visualization.

# **Data Cleaning**
Using Python, I requested the data from the API. Since it was delivered in a JSON format, I utilized Panda's normalize function and converted it to a DataFrame. To automate the process, a function was defined; it made the request to the API, intially created a file in my local storage and then on further pulls it kept appending the data. With a sleeper the function could be used with the desired time interval, in my case every 5 minutes.

# **Data Visualization**
I used Tableau to create a dashboard that displays the most volatile, expensive, and traded cryptocurrencies. The dashboard features the following charts:
- A heatmap with the Top 10 Crypto Currencies by volume.
- Bubble graph with the Top 10 Cryptos by Volatility.
- Bar chart with the prices (In USD)
- A table containing the total circulating supply and the amount in USD of the total volume traded in 24 hours.

# **Conclusion**
Analyzing cryptocurrency data can help provide insights into the performance and trends of different cryptocurrencies over time. By pulling data from an API, cleaning it, and visualizing it using Tableau, we can better understand which cryptocurrencies are performing well and which ones are not. This project provides a comprehensive analysis of cryptocurrency data, allowing for a deeper understanding of the factors that contribute to a cryptocurrency's success, which could help someone trying to initiate in crypto currency trading. All files used in this project, including the Jupyter Notebook and the visualization, are included in this folder.

## Tableau

(https://public.tableau.com/app/profile/emiliano.zapata.fernandez/viz/Cryptocurrency_16775252217950/Dashboard1)


## API 

(https://coinmarketcap.com/api/)

from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'100',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': '4eb0bfde-4800-4afb-8df9-adc8b4c0c687',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)
