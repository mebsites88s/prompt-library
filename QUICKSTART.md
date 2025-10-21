# PixelOni.ai Prompt Library - Quick Start

## 🚀 Running the System

1. **Install Flask** (if not already installed):
```bash
pip install flask
```

2. **Start the server**:
```bash
cd prompt-library
python app.py
```

3. **Open browser**:
Navigate to: http://localhost:5000

## ✨ Features

### Library Management
- **Live file reading**: Automatically scans prompt folders
- **Real-time search**: Search by title, content, or tags
- **Dynamic filtering**: Filter by category and subfolder
- **Click to open**: Opens .md files in new tab
- **Auto-refresh**: Reload page to see new prompts

### Prompt Builder (NEW!)
- **Visual interface**: Create prompts through web form
- **4 prompt types**: Basic, Research, Code, Analysis
- **Live preview**: See XML output before saving
- **Auto-generation**: Creates properly formatted .md files
- **Path management**: Specify source files and output locations

## 📝 Creating Prompts (Two Methods)

### Method 1: Use the Builder (Recommended)

1. Click **"+ Create New Prompt"** button
2. Select tab: Basic / Research / Code / Analysis
3. Fill in fields:
   - **Required**: Title (≥3 chars), Role (≥20 chars), Task (≥20 chars), Category
   - **Optional**: Description, Subfolder, Tags, all other sections
4. Add source paths if Claude needs to access files
5. Add output path if Claude should save to specific location
6. Click **Preview** to review
7. Click **Save Prompt**
8. Redirect to library automatically

### Method 2: Manual Creation

1. Copy `templates/prompt-template.md`
2. Fill metadata and prompt sections
3. Save to `categories/{category}/` or `categories/{category}/{subfolder}/`
4. Format: `YYYY-MM-DD_name.md`
5. Refresh browser

## 🎯 Quick Examples

### Create a Code Prompt
1. Open builder → **Code** tab
2. Title: "Python CSV Parser"
3. Role: "Expert Python developer specializing in data parsing"
4. Task: "Create a CSV parser that handles edge cases"
5. Language: "Python 3.11+"
6. Dependencies: "pandas, csv"
7. Save → Auto-generates to `categories/coding/`

### Create an Analysis Prompt
1. Open builder → **Analysis** tab
2. Title: "Q4 Sales Analysis"
3. Data Format: "CSV with columns: date, region, revenue"
4. Metrics: "QoQ growth, regional breakdown"
5. Add source path: `C:\Users\aaron\Desktop\sales_data.csv`
6. Add output path: `C:\Users\aaron\Desktop\analysis_report.docx`
7. Save

## 🔍 Using Source & Output Paths

**Source Paths** - When Claude needs to read files:
```
C:\Users\aaron\Desktop\data.csv
C:\Users\aaron\Documents\requirements.txt
```
Generated note in .md tells Claude to use Desktop Commander tools.

**Output Path** - Where Claude should save results:
```
C:\Users\aaron\Desktop\PixelOni\reports\output.docx
```
Generated note instructs Claude to save using Desktop Commander.

## 🎨 Customization

**Change Colors**: Edit CSS variables in `index.html` and `builder.html`

**Change Logo**: Replace `logo.png` file

**Add Categories**: Just create new folder in `categories/`

## 💡 Tips

- Use **subfolders** to organize by project/client/tech stack
- Add **tags** for better searchability
- Preview prompts before saving to catch errors
- Source paths must be **absolute paths** for Desktop Commander
- Server auto-detects new prompts on browser refresh

## 🐛 Troubleshooting

**Builder button not working?**
- Restart Flask server
- Check browser console for errors

**Prompts not saving?**
- Verify write permissions in `categories/` folder
- Check validation: Title ≥3 chars, Role/Task ≥20 chars

**Files not showing in library?**
- Refresh browser (F5)
- Check file is in `categories/` folder
- Verify .md extension

## 📚 Next Steps

- Read full README.md for API documentation
- Explore prompt templates in `templates/`
- Check existing prompts for examples
- Customize branding to match your style

Server runs on: http://localhost:5000
Repository: https://github.com/mebsites88s/prompt-library
