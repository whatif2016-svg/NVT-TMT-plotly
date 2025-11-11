#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///

import json
import os
import sys

def convert_json_to_html(json_path, output_path):
    """Convert a Chart Studio JSON export to standalone HTML"""
    with open(json_path, 'r') as f:
        chart_data = json.load(f)

    # Extract data and layout from the JSON
    data_json = json.dumps(chart_data.get('data', []))
    layout_json = json.dumps(chart_data.get('layout', {}))

    # Generate standalone HTML with Plotly.js 1.58.5
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

    with open(output_path, 'w') as f:
        f.write(html_template)

    return output_path

def main():
    # Convert all JSON files in the json/ directory (including subdirectories)
    json_dir = "json"
    charts_dir = "charts"

    if not os.path.exists(json_dir):
        print(f"❌ Directory '{json_dir}' does not exist")
        sys.exit(1)

    os.makedirs(charts_dir, exist_ok=True)

    # Walk through all directories and files
    converted_count = 0
    failed_count = 0

    for root, dirs, files in os.walk(json_dir):
        for filename in files:
            if filename.endswith('.json'):
                json_path = os.path.join(root, filename)

                # Calculate relative path from json_dir
                rel_path = os.path.relpath(json_path, json_dir)

                # Create corresponding output path in charts_dir
                html_rel_path = rel_path.replace('.json', '.html')
                html_path = os.path.join(charts_dir, html_rel_path)

                # Create subdirectories if needed
                os.makedirs(os.path.dirname(html_path), exist_ok=True)

                try:
                    convert_json_to_html(json_path, html_path)
                    print(f"✅ Converted {rel_path} → {html_rel_path}")
                    converted_count += 1
                except Exception as e:
                    print(f"❌ Failed to convert {rel_path}: {e}")
                    failed_count += 1

    if converted_count == 0 and failed_count == 0:
        print(f"No JSON files found in '{json_dir}' directory")
    else:
        print(f"\n✨ Converted {converted_count} file(s), {failed_count} failed")

if __name__ == "__main__":
    main()
