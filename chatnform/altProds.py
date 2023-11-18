import cohere 
import requests
from cohere.responses.classify import Example
import os
import json
from dotenv import load_dotenv
load_dotenv()  # loads variables from .env


cohereAPIKey = os.getenv("COHERE_API_KEY")
googleSearchID = os.getenv("GOOGLE_SEARCH_ID")
searchEngineID = os.getenv("SEARCH_ENGINE_ID")
# Retrieve the credentials JSON string
credentials_json = os.getenv("GOOGLE_CREDENTIALS_JSON")
# Convert the string back to a JSON object
credentials = json.loads(credentials_json)


co = cohere.Client(cohereAPIKey)

def get_links(nutr_label, user_info):
  response = co.chat( 
    model='command',
    message=f'links to healthier alternate food products for food item with this nutritional label: {nutr_label}, and tailored for this user: {user_info}',
    search_queries_only=True
  ) 

  search_query_text = response.search_queries[0]['text']

  print(search_query_text)


  searchQuery = f"links to buy food products for {search_query_text}"
  url = "https://www.googleapis.com/customsearch/v1"

  params  = {
      "q": searchQuery,
      "key": googleSearchID,
      "cx": searchEngineID
  }

  response = requests.get(url, params=params)
  results = response.json()

  links_array = [item['link'] for item in results['items']]

  for i in enumerate(links_array):
      print(i)

  return links_array
