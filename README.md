# Plotly Chart Studio HTML Template

Host your Plotly Chart Studio visualizations online for free using GitHub Pages. Export your charts from Chart Studio as HTML files and publish them with a simple web link.

<div>
    <a href="https://www.loom.com/share/0e95c5e3bb334e288c09f80719d0027c">
      <p>Migrate Chart Studio Charts to Github Pages - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/0e95c5e3bb334e288c09f80719d0027c">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/0e95c5e3bb334e288c09f80719d0027c-e8e7dcd1079f042c-full-play.gif">
    </a>
  </div>

## What This Does

Upload your Chart Studio HTML exports or JSON data files, and they'll be automatically published online:
- An **index page** listing all your Plotly charts is created at `https://yourusername.github.io/your-project/`
- Each chart gets its own web address: `https://yourusername.github.io/your-project/my-chart.html`
- **NEW:** Support for JSON exports - just place Chart Studio JSON files in the `json/` directory and they'll be automatically converted to HTML

Perfect for sharing interactive Plotly visualizations with your team or embedding in presentations!

## Step-by-Step Guide

### Step 1: Create Your Own Copy

1. At the top of this page on GitHub, click the green **"Use this template"** button
2. Select **"Create a new repository"**
3. Give your project a name (like "my-plotly-charts")
4. Click **"Create repository"**

### Step 2: Export Your Charts from Chart Studio

1. Go to [Chart Studio](https://chart-studio.plotly.com/)
2. Open the chart you want to publish
3. Click **Export** and select **HTML**
4. Save the `.html` file to your computer
5. Repeat for any other charts you want to publish

### Step 3: Turn On GitHub Pages

This is the most important step - your charts won't be published without it!

**Note:** If you're using a free GitHub account, your repository must be **public** to use GitHub Pages. If your repo is private, go to **Settings** → **General** → scroll to the bottom → click **Change visibility** → select **Make public**.

1. In your new repository, click **Settings** at the top
2. Look in the left sidebar and click **Pages**
3. Under "Build and deployment", find the **Source** dropdown
4. Select **GitHub Actions** (not "Deploy from a branch")
5. The page will refresh - you're all set!

### Step 4: Upload Your Chart Studio HTML Files

You can add files directly on GitHub (easiest) or use GitHub Desktop:

**Option A: Upload on GitHub (Easiest)**
1. Click on the `charts` folder
2. Click **Add file** → **Upload files**
3. Drag and drop your Chart Studio `.html` files
4. Click **Commit changes** at the bottom

**Option B: Using GitHub Desktop**
1. Download [GitHub Desktop](https://desktop.github.com/)
2. Clone your repository to your computer
3. Copy your Chart Studio `.html` files into the `charts` folder
4. In GitHub Desktop, write a description and click **Commit to main**
5. Click **Push origin** to upload

**Option C: Upload JSON Files (Alternative)**
If you have JSON exports from Chart Studio instead of HTML files:
1. Click on the `json` folder (or create it if it doesn't exist)
2. Click **Add file** → **Upload files**
3. Drag and drop your Chart Studio JSON files (e.g., `chart_data.json` files)
4. Click **Commit changes** at the bottom
5. The GitHub Action will automatically convert these to HTML files in the `charts` folder

### Step 5: Wait for Publishing

After uploading files:
1. Click the **Actions** tab at the top of your repository
2. You'll see a workflow running (yellow dot = in progress, green check = done)
3. This usually takes 30-60 seconds

### Step 6: View Your Plotly Charts Online

Your interactive Plotly charts are now live!

**View All Charts:**
Go to your main page to see a gallery of all your Plotly visualizations:
```
https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/
```

**View Individual Charts:**
Each Plotly chart has its own direct link:
```
https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/FILENAME.html
```

**Example:**
- If your GitHub username is `jane-smith`
- Your repository is named `my-plotly-charts`
- Your main gallery page is at: `https://jane-smith.github.io/my-plotly-charts/`
- A specific chart is at: `https://jane-smith.github.io/my-plotly-charts/sales-report.html`

## Finding Your Chart URLs

Don't remember the exact address?

1. Go to **Settings** → **Pages**
2. At the top you'll see "Your site is live at [address]"
3. Visit that address to see all your charts listed with clickable links
4. Or add a filename to the end for a specific chart: `[address]/your-file.html`

## Adding More Charts

Just repeat Step 4! Every time you export a new chart from Chart Studio and add the `.html` file to the `charts` folder:
- GitHub will automatically publish it within about a minute
- The index page will automatically update to include your new Plotly chart

## Troubleshooting

**My chart isn't showing up**
- Double-check that GitHub Pages is enabled (Settings → Pages → Source should say "GitHub Actions")
- Make sure your file is in the `charts` folder, not somewhere else
- Wait 1-2 minutes after uploading - it's not instant
- Check the Actions tab to see if there were any errors (red X icon)

**I see a 404 error**
- Make sure you're using the exact filename (including `.html`)
- Check that the file name doesn't have spaces - use dashes instead (`my-chart.html` not `my chart.html`)

**Need to remove a chart?**
- Go to the `charts` folder, click on the file, and click the trash icon
- Commit the change, and it will be removed from your site within a minute

## Bulk Export All Your Charts (Advanced)

If you have many charts in Chart Studio and want to download them all at once, you can use the `poll_all_charts.py` script instead of manually exporting each one.

### What This Script Does

The script automatically:
1. Connects to your Chart Studio account using your API credentials
2. Fetches all charts that you own
3. Downloads the chart data as JSON
4. Generates standalone HTML files using Plotly.js 1.58.5
5. Saves them to the `charts/` folder, ready to be published

This is much faster than manually exporting charts one-by-one from the Chart Studio interface, especially if you have dozens or hundreds of visualizations.

### How to Use It

**Step 1: Install UV**

UV is a fast Python package manager. Install it by running:

```bash
# On macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# On Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Step 2: Get Your Chart Studio API Credentials**

1. Log in to [Chart Studio](https://chart-studio.plotly.com/)
2. Go to Settings → API Keys
3. Copy your API key

**Step 3: Update the Script**

Open `poll_all_charts.py` and update these lines with your credentials:

```python
username = 'your-username'  # Replace with your Chart Studio username
api_key = 'your-api-key'    # Replace with your API key from Step 2
```

**Step 4: Run the Script**

In your terminal, navigate to the repository folder and run:

```bash
./poll_all_charts.py
```

Or:
```bash
uv run poll_all_charts.py
```

The script will download all your charts and save them as HTML files in the `charts/` folder. Then just commit and push the changes to publish them on GitHub Pages!

**Note:** This script uses Plotly.js version 1.58.5 to ensure compatibility and consistent rendering across all your charts.

## Working with JSON Exports

If you have Chart Studio JSON exports (such as `chart_data.json` files from bulk exports), this repository can automatically convert them to HTML files.

### Why Use JSON Files?

- Bulk exports from Chart Studio often come as JSON files
- JSON files are more portable and easier to version control
- You can modify chart data programmatically before converting to HTML
- Smaller file sizes compared to full HTML files

### How to Use JSON Files

**Option 1: Manual Conversion (Local)**

1. Place your JSON files in the `json/` directory
2. Run the conversion script locally:
   ```bash
   ./convert_json_to_html.py
   ```
3. The script will create HTML files in the `charts/` directory

**Option 2: Automatic Conversion (GitHub)**

1. Upload your JSON files to the `json/` folder in your repository
2. Commit and push the changes
3. GitHub Actions will automatically:
   - Detect the JSON files
   - Convert them to HTML using the same Plotly.js version (1.58.5)
   - Include them in your published site

### JSON File Format

The JSON files should match the Chart Studio export format:

```json
{
  "data": [
    {
      "type": "scatter",
      "x": [1, 2, 3],
      "y": [2, 4, 6],
      "mode": "lines+markers"
    }
  ],
  "layout": {
    "title": {
      "text": "My Chart"
    },
    "xaxis": {"title": {"text": "X Axis"}},
    "yaxis": {"title": {"text": "Y Axis"}}
  }
}
```

The conversion script reads the `data` and `layout` fields and generates standalone HTML files with embedded Plotly.js.
