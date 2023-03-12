
# Cripto API with Python Project

In this project I used Python to pull data from an API, then clean it with Python, as well as added a timestamp to be able to see when the pull was done. 

Finally in the Tableau Dashboard, I show what are the most volatile, expensive and most traded Cripto currencies, as well as how much is the current supply and traded volume.

The original files used, the Jupyter Notebook and the Visualization are all in this folder.


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
