# PixelOni.ai Prompt Library Manager

A dynamic, web-based prompt library system with **built-in prompt builder**, nested folder organization, real-time search, and brand customization.

## ✨ Features

### Prompt Builder (NEW!)
- **Tab-Based Interface**: Create Basic, Research, Code, or Analysis prompts
- **7 Core Sections**: Role, Task, Context, Examples, Output Format, Constraints, Thinking
- **Tab-Specific Fields**: Additional fields per prompt type (sources, dependencies, metrics, etc.)
- **Live Preview**: See formatted XML output before saving
- **Source Path Integration**: Specify absolute paths to source documents
- **Output Path Specification**: Define where Claude should save outputs
- **Auto-Generation**: XML-tagged .md files following Anthropic best practices

### Library Management
- **Dynamic Category Discovery**: Automatically detects all category folders
- **Nested Subfolder Support**: Organize prompts in hierarchical structures
- **Real-Time Search**: Search by title, content, or tags
- **Click-to-Filter**: Filter by category or subfolder with single click
- **Markdown-Based**: All prompts stored as .md files with metadata
- **Custom Branding**: PixelOni.ai design with easy customization

## 🚀 Quick Start

1. **Clone Repository**:
```bash
git clone https://github.com/mebsites88s/prompt-library.git
cd prompt-library
```

2. **Install Dependencies**:
```bash
pip install flask
```

3. **Run the Server**:
```bash
python app.py
```

4. **Open Browser**:
Navigate to http://localhost:5000

## 📁 Structure

```
prompt-library/
├── app.py                 # Flask backend with builder endpoints
├── index.html             # Main library interface
├── builder.html           # Prompt builder interface (NEW!)
├── logo.png               # PixelOni.ai branding
├── README.md              # This file
├── QUICKSTART.md          # Quick reference
├── categories/            # Prompt categories
│   ├── coding/
│   │   ├── python/       # Subfolders supported
│   │   └── automation/
│   ├── writing/
│   ├── analysis/
│   ├── automation/
│   └── clients/
└── templates/
    └── prompt-template.md # Manual template (optional)
```

## 🎨 Using the Prompt Builder

1. Click **"+ Create New Prompt"** button in header
2. Choose tab: **Basic**, **Research**, **Code**, or **Analysis**
3. Fill in required fields (Title, Role, Task, Category)
4. Add optional fields as needed
5. Click **Preview** to see formatted output
6. Click **Save Prompt** to generate .md file
7. File auto-saves to `categories/{category}/{subfolder}/`

### Tab-Specific Fields

**Basic Tab** (7 core sections only):
- Role, Task, Context, Examples, Output Format, Constraints, Thinking

**Research Tab** (+4 sections):
- Sources, Methodology, Literature Review, Quality Criteria

**Code Tab** (+6 sections):
- Language, Dependencies, Tests, Performance Requirements, Style Guide, Error Handling

**Analysis Tab** (+6 sections):
- Data Format, Metrics, Formulas, Visualization Requirements, Comparison Criteria, Confidence Levels

### Source & Output Paths

**Source Document Paths**:
- Specify absolute paths to input files (one per line)
- Claude uses Desktop Commander to access these files
- Generates note in .md: "Use desktop-commander:read_file to access"

**Output Path**:
- Define where Claude should save final output
- Example: `C:\Users\aaron\Desktop\output.docx`
- Generates note in .md: "Save to this path using Desktop Commander"

## 📝 File Naming Convention

Auto-generated format: `{title-slug}-YYYYMMDDHHMMSS.md`

Examples:
- `sales-analysis-20251021143015.md`
- `python-debugger-20251021150230.md`

## 🎯 Manual Prompt Creation

You can still manually create prompts:

1. Copy `templates/prompt-template.md`
2. Fill in metadata (date, category, tags, use case)
3. Write your prompt in the designated section
4. Save to appropriate category folder (or subfolder)
5. Refresh browser

## 🎨 Customization

### Brand Colors

Edit CSS variables in `index.html` and `builder.html`:
```css
:root {
    --navy-dark: #1a3a52;
    --navy-light: #2a4a62;
    --teal: #7dd3c0;
    --coral: #ffa07a;
    --cream: #f5e6d3;
}
```

### Logo

Replace `logo.png` with your own logo file (keep filename or update route in `app.py`).

## 🔌 API Endpoints

### Library Endpoints
- `GET /` - Main library interface
- `GET /api/prompts` - List all prompts with metadata
- `GET /api/categories` - List categories with subfolder counts
- `GET /api/search?q=keyword` - Search prompts
- `GET /categories/{path}` - Serve prompt markdown files

### Builder Endpoints (NEW!)
- `GET /builder` - Prompt builder interface
- `POST /api/save-prompt` - Save new prompt file
  - Validates title (≥3 chars), role (≥20 chars), task (≥20 chars), category
  - Creates directories as needed
  - Returns filename and path on success

## 🔍 Search Examples

**Desktop Commander CLI**:
```bash
# Search by content
start_search(searchType="content", pattern="pandas", path="./categories")

# Search by filename
start_search(searchType="files", pattern="*.md", path="./categories")
```

**PowerShell**:
```powershell
# List all prompts
Get-ChildItem -Path "./categories" -Recurse -Filter *.md

# Search content
Select-String -Path "./categories/*/*.md" -Pattern "keyword"
```

## 📋 Requirements

- Python 3.7+
- Flask 3.0+
- Modern web browser (Chrome, Firefox, Edge)

## 🛠️ Technologies

- **Backend**: Flask (Python)
- **Frontend**: Vanilla JavaScript (no dependencies)
- **Styling**: Custom CSS with PixelOni.ai branding
- **Format**: XML-tagged Markdown following Anthropic prompt engineering standards

## 📄 License

MIT License - Feel free to use and modify

## 👏 Credits

Built with Claude + Desktop Commander by PixelOni.ai

## 🐛 Troubleshooting

**Logo not loading?**
- Ensure `logo.png` exists in project root
- Check Flask route in `app.py` line 11-13

**Prompts not saving?**
- Verify write permissions in `categories/` folder
- Check browser console for validation errors

**Categories not showing?**
- Ensure `categories/` folder exists
- Check folder naming (lowercase, no spaces)

## 🤝 Contributing

Contributions welcome! Open an issue or submit a PR.

Repository: https://github.com/mebsites88s/prompt-library
