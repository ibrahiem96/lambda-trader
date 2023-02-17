import os
import boto3
from alpaca.data.historical import StockHistoricalDataClient
from alpaca.data.requests import StockQuotesRequest

ssm_client = boto3.client('ssm')

api_key_response = ssm_client.get_parameter(Name='alpacatrader-api-key', WithDecryption=True)
secret_key_response = ssm_client.get_parameter(Name='alpaca-secret-key', WithDecryption=True)

api_key = api_key_response['Parameter']['Value']
secret_key = secret_key_response['Parameter']['Value']

alpaca_client = StockHistoricalDataClient(api_key, secret_key)

def lambda_handler(event, context):
    request_params = StockQuotesRequest(
        symbol_or_symbols=['SPY']
    )
    spy_quote = alpaca_client.get_stock_latest_quote(request_params)
    print(spy_quote)


