#!/bin/bash

# Generate index.html with links to all charts

cd charts

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chart Gallery</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        header {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        h1 {
            color: #119dff;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .plotly-logo {
            font-weight: 700;
            color: #119dff;
        }

        .subtitle {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .powered-by {
            margin-top: 1rem;
            font-size: 0.9rem;
            color: #95a5a6;
        }

        .powered-by a {
            color: #119dff;
            text-decoration: none;
        }

        .powered-by a:hover {
            text-decoration: underline;
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .chart-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .chart-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .chart-card a {
            text-decoration: none;
            color: #119dff;
            font-size: 1.1rem;
            font-weight: 500;
            display: block;
        }

        .chart-card a:hover {
            color: #0d7ec9;
        }

        .chart-name {
            margin-top: 0.5rem;
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .button-group {
            margin-top: 1rem;
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: #119dff;
            color: white !important;
        }

        .btn-primary:hover {
            background: #0d7ec9;
            color: white !important;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        .btn.copied {
            background: #27ae60;
        }

        .empty-state {
            background: white;
            border-radius: 8px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .empty-state h2 {
            color: #7f8c8d;
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: #95a5a6;
        }
    </style>
    <script>
        function copyEmbedCode(filename) {
            // Get the base URL dynamically from the current page
            const baseUrl = window.location.href.replace(/\/[^\/]*$/, '');
            const url = baseUrl + '/' + filename;
            const embedCode = '<iframe src="' + url + '" width="100%" height="600" frameborder="0"></iframe>';

            navigator.clipboard.writeText(embedCode).then(function() {
                const button = event.target;
                const originalText = button.textContent;
                button.textContent = 'Copied!';
                button.classList.add('copied');

                setTimeout(function() {
                    button.textContent = originalText;
                    button.classList.remove('copied');
                }, 2000);
            }).catch(function(err) {
                alert('Failed to copy: ' + err);
            });
        }
    </script>
</head>
<body>
    <div class="container">
        <header>
            <h1><span class="plotly-logo">Plotly</span> Chart Gallery</h1>
            <p class="subtitle">Charts previously hosted on Plotly Chart Studio</p>
        </header>

        <div class="chart-grid">
EOF

# Find all HTML files except index.html and add them to the page
html_files=$(find . -name "*.html" ! -name "index.html" | sort)

if [ -z "$html_files" ]; then
    cat >> index.html << 'EOF'
        </div>
        <div class="empty-state">
            <h2>No Plotly charts yet</h2>
            <p>Export your charts from Chart Studio as HTML and add them to the charts/ folder.</p>
        </div>
EOF
else
    for file in $html_files; do
        # Remove leading ./ from path
        relative_path="${file#./}"
        filename=$(basename "$file")
        # URL encode the path for use in href attributes
        # This handles special characters like spaces, %, etc.
        encoded_path=$(printf '%s' "$relative_path" | jq -sRr @uri)
        # Convert filename to readable title (remove .html, replace hyphens/underscores with spaces, capitalize)
        # Also decode any URL-encoded characters for the display title
        decoded_filename=$(printf '%s' "$filename" | sed 's/%20/ /g' | sed 's/%/ /g')
        title=$(echo "$decoded_filename" | sed 's/.html$//' | sed 's/[-_]/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

        cat >> index.html << EOF
            <div class="chart-card">
                <a href="$encoded_path">$title</a>
                <div class="chart-name">$relative_path</div>
                <div class="button-group">
                    <a href="$encoded_path" class="btn btn-primary">View Chart</a>
                    <button class="btn btn-secondary" onclick="copyEmbedCode('$encoded_path')">Copy Embed Code</button>
                </div>
            </div>
EOF
    done

    cat >> index.html << 'EOF'
        </div>
EOF
fi

cat >> index.html << 'EOF'
    </div>
</body>
</html>
EOF

echo "Generated index.html with $(echo "$html_files" | wc -l | tr -d ' ') charts"
