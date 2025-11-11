#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = ["requests"]
# ///

import requests
import os
import json

username = 'your-username'  # Replace with your Chart Studio username
api_key = 'your-api-key'    # Replace with your API key from Chart Studio

headers = {"Plotly-Client-Platform": "Python 3 0.3.2"}
auth = requests.auth.HTTPBasicAuth(username, api_key)

# Fetch all plots with pagination
all_plots = []
page = 1
per_page = 10  # Max items per page

while True:
    url = f"https://api.plot.ly/v2/folders/home?user={username}&page={page}&per_page={per_page}"
    response = requests.get(url, auth=auth, headers=headers)

    if response.status_code != 200:
        print(f"❌ Error accessing plots: {response.status_code}")
        print(f"Response: {response.text}")
        exit(1)

    data = response.json()
    children = data.get("children", {}).get("results", [])

    if not children:
        break

    # Filter to only include plots (filetype == 'plot')
    plots = [p for p in children if p.get("filetype") == "plot"]
    all_plots.extend(plots)

    print(f"📄 Page {page}: Found {len(plots)} plots")

    # Check if there are more pages
    total_count = data.get("children", {}).get("count", 0)
    if len(all_plots) >= total_count or len(children) < per_page:
        break

    page += 1

print(f"\n✅ Total plots owned by {username}: {len(all_plots)}")

if all_plots:
    print(f"First plot: {all_plots[0]}")
fids = [p["fid"] for p in all_plots]

# Create output directory if it doesn't exist
os.makedirs("charts", exist_ok=True)

for fid in fids:
    # Get the chart JSON data
    plot_url = f"https://api.plotly.com/v2/plots/{fid}/content?inline_data=true"
    plot_response = requests.get(plot_url, auth=auth, headers=headers)

    if plot_response.status_code == 200:
        # Parse the JSON response
        chart_data = plot_response.json()

        # Generate standalone HTML with Plotly.js 1.58.5
        data_json = json.dumps(chart_data['data'])
        layout_json = json.dumps(chart_data['layout'])

        html_template = f"""<html>
    <head><meta charset="utf-8" /></head>
    <body>
        <div id="plotly-div"></div>
        <script src="https://cdn.plot.ly/plotly-1.58.5.min.js"></script>
        <script>
            var data = {data_json};
            var layout = {layout_json};
            Plotly.newPlot('plotly-div', data, layout);
        </script>
    </body>
</html>"""

        # Save as HTML
        safe_filename = f"{fid}.html"
        filepath = os.path.join("charts", safe_filename)
        with open(filepath, "w") as f:
            f.write(html_template)
        print(f"        ✅ Saved to {filepath}")
    else:
        print(f"        ❌ Failed: HTTP {plot_response.status_code}")
