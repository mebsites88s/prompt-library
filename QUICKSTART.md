# PixelOni.ai Prompt Library - Quick Start

## Running the Dynamic GUI

1. **Install Flask** (if not already installed):
```powershell
pip install flask
```

2. **Start the server**:
```powershell
cd C:\Users\aaron\Desktop\PixelOni\scripts\prompts
python app.py
```

3. **Open browser**:
Navigate to: http://localhost:5000

## Features

- **Live file reading**: Automatically scans prompt folders
- **Real-time search**: Search by title, content, or tags
- **Category counts**: Dynamic stats for each category
- **Click to open**: Opens .md files in new tab
- **Auto-refresh**: Reload page to see new prompts

## Adding Prompts

1. Copy template: `templates\prompt-template.md`
2. Fill it out
3. Save to category folder with format: `YYYY-MM-DD_name.md`
4. Refresh browser to see it

Server will automatically detect and display new prompts.
