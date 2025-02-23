import json
import requests

# Google Apps Script API URL (replace with your URL)
API_URL = "https://script.google.com/macros/s/AKfycbyXdW6l0NW6Z-c7fw-EsdafjQV-FeH3m8zlMdiEXWvd8F7m03eIbKgq8rFC3opD4Tki/exec"

# Fetch data from Google Forms responses
response = requests.get(API_URL)
data = response.json()

# Terraform requires JSON formatted output
print(json.dumps({
    "result": data
}))
