import json
import requests

# Google Apps Script API URL (replace with your URL)
API_URL = "https://script.google.com/macros/s/AKfycbwREEWd0srlkiIUEe6gvW0Wd2_H_fOOdfP8B9qVS-m6ElFti2epHqtQ1HfLhgloJVTg/exec"

# Fetch data from Google Forms responses
response = requests.get(API_URL)
data = response.json()

# Terraform requires JSON formatted output
print(json.dumps({
    "result": data
}))
