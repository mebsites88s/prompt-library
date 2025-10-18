from flask import Flask, jsonify, send_from_directory, request
from pathlib import Path
import os
import re
from datetime import datetime

app = Flask(__name__)
BASE_DIR = Path(__file__).parent

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/api/prompts')
def get_prompts():
    prompts = []
    categories_path = BASE_DIR / 'categories'
    
    if categories_path.exists():
        for category_dir in categories_path.iterdir():
            if category_dir.is_dir():
                category = category_dir.name
                for md_file in category_dir.rglob('*.md'):
                    content = md_file.read_text(encoding='utf-8')
                    
                    title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
                    title = title_match.group(1) if title_match else md_file.stem
                    
                    tags_match = re.search(r'Topic Tags.*?\[(.+?)\]', content)
                    tags = [t.strip() for t in tags_match.group(1).split(',')] if tags_match else []
                    
                    date_match = re.search(r'Date Created.*?(\d{4}-\d{2}-\d{2})', content)
                    date = date_match.group(1) if date_match else md_file.stem.split('_')[0]
                    
                    rel_path = md_file.relative_to(categories_path)
                    subfolder = None
                    if len(rel_path.parts) > 2:
                        subfolder = rel_path.parts[1]
                    
                    prompts.append({
                        'title': title,
                        'category': category,
                        'subfolder': subfolder,
                        'tags': tags,
                        'date': date,
                        'file': md_file.name,
                        'path': f'/categories/{rel_path.as_posix()}'
                    })
    
    return jsonify(prompts)

@app.route('/api/search')
def search_prompts():
    query = request.args.get('q', '').lower()
    prompts = []
    categories_path = BASE_DIR / 'categories'
    
    if categories_path.exists():
        for category_dir in categories_path.iterdir():
            if category_dir.is_dir():
                category = category_dir.name
                for md_file in category_dir.rglob('*.md'):
                    content = md_file.read_text(encoding='utf-8')
                    
                    if query in content.lower() or query in md_file.name.lower():
                        title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
                        title = title_match.group(1) if title_match else md_file.stem
                        
                        tags_match = re.search(r'Topic Tags.*?\[(.+?)\]', content)
                        tags = [t.strip() for t in tags_match.group(1).split(',')] if tags_match else []
                        
                        rel_path = md_file.relative_to(categories_path)
                        subfolder = None
                        if len(rel_path.parts) > 2:
                            subfolder = rel_path.parts[1]
                        
                        prompts.append({
                            'title': title,
                            'category': category,
                            'subfolder': subfolder,
                            'tags': tags,
                            'file': md_file.name,
                            'path': f'/categories/{rel_path.as_posix()}'
                        })
    
    return jsonify(prompts)

@app.route('/logo.png')
def get_logo():
    # Customize this to point to your logo file
    # Default: looks for logo.png in the prompts directory
    # For PixelOni setup: logo_path = BASE_DIR.parent.parent / 'Branding'
    logo_path = BASE_DIR
    return send_from_directory(logo_path, 'logo.png', mimetype='image/png')

@app.route('/api/categories')
def get_categories():
    categories = {}
    categories_path = BASE_DIR / 'categories'
    
    if categories_path.exists():
        for category_dir in categories_path.iterdir():
            if category_dir.is_dir():
                category = category_dir.name
                
                subfolders = {}
                for item in category_dir.iterdir():
                    if item.is_dir():
                        count = len(list(item.rglob('*.md')))
                        subfolders[item.name] = count
                
                root_count = len(list(category_dir.glob('*.md')))
                total_count = len(list(category_dir.rglob('*.md')))
                
                categories[category] = {
                    'total': total_count,
                    'root': root_count,
                    'subfolders': subfolders
                }
    
    return jsonify(categories)

@app.route('/categories/<path:filepath>')
def get_prompt_file(filepath):
    return send_from_directory('categories', filepath)

if __name__ == '__main__':
    app.run(debug=True, port=5000)

