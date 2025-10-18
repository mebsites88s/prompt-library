# Prompt Library Manager

A dynamic, web-based prompt library system with nested folder organization, real-time search, and brand customization.

## Features

- **Dynamic Category Discovery**: Automatically detects all category folders
- **Nested Subfolder Support**: Organize prompts in hierarchical structures
- **Real-Time Search**: Search by title, content, or tags
- **Click-to-Filter**: Filter by category or subfolder with single click
- **Markdown-Based**: All prompts stored as .md files with metadata
- **Custom Branding**: Easy logo and color customization

## Quick Start

1. **Install Dependencies**:
```bash
pip install flask
```

2. **Run the Server**:
```bash
cd prompts
python app.py
```

3. **Open Browser**:
Navigate to http://localhost:5000

## Structure

```
prompts/
├── app.py                 # Flask backend
├── index.html             # Web interface
├── README.md              # Documentation
├── QUICKSTART.md          # Quick reference
├── categories/            # Prompt categories
│   ├── coding/
│   │   ├── python/       # Subfolders supported
│   │   ├── scraping/
│   │   └── elementor/
│   ├── writing/
│   ├── analysis/
│   ├── automation/
│   └── clients/
├── by-topic/              # Alternative organization
└── templates/
    └── prompt-template.md # Template for new prompts
```

## File Naming Convention

Format: `YYYY-MM-DD_descriptor.md`

Examples:
- `2025-10-18_csv-data-analysis.md`
- `2025-10-18_python-debugger.md`

## Adding New Prompts

1. Copy `templates/prompt-template.md`
2. Fill in metadata (date, category, tags, use case)
3. Write your prompt in the designated section
4. Save to appropriate category folder (or subfolder)
5. Refresh browser - it appears automatically

## Customization

### Brand Colors

Edit `index.html` CSS variables:
```css
:root {
    --dark-navy: #1a3a52;
    --teal: #7dd3c0;
    --coral: #ffa07a;
    --cream: #f5e6d3;
}
```

### Logo

Replace logo route in `app.py`:
```python
@app.route('/logo.png')
def get_logo():
    # Point to your logo file
    return send_from_directory('path/to/logo', 'your-logo.png')
```

## API Endpoints

- `GET /api/prompts` - List all prompts with metadata
- `GET /api/categories` - List categories with subfolder counts
- `GET /api/search?q=keyword` - Search prompts
- `GET /categories/{path}` - Serve prompt markdown files

## Search Examples

**Desktop Commander CLI**:
```bash
# Search by content
start_search(searchType="content", pattern="pandas", path="./prompts")

# Search by filename
start_search(searchType="files", pattern="*.md", path="./prompts")
```

**PowerShell**:
```powershell
# List all prompts
Get-ChildItem -Path "./categories" -Recurse -Filter *.md

# Search content
Select-String -Path "./categories/*/*.md" -Pattern "keyword"
```

## Requirements

- Python 3.7+
- Flask 3.0+

## License

MIT License - Feel free to use and modify

## Credits

Built with Claude + Desktop Commander
