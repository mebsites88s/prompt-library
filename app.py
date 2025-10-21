from flask import Flask, jsonify, send_from_directory, request
from pathlib import Path
import os
import re
from datetime import datetime
import json

app = Flask(__name__)

BASE_DIR = Path(__file__).parent

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/logo.png')
def logo():
    return send_from_directory('.', 'logo.png')

@app.route('/builder')
def builder():
    return send_from_directory('.', 'builder.html')

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

@app.route('/api/save-prompt', methods=['POST'])
def save_prompt():
    try:
        data = request.json
        
        # Validation
        if not data.get('title') or len(data['title'].strip()) < 3:
            return jsonify({'error': 'Title required (minimum 3 characters)'}), 400
        
        if not data.get('role') or len(data['role'].strip()) < 20:
            return jsonify({'error': 'Role required (minimum 20 characters)'}), 400
        
        if not data.get('task') or len(data['task'].strip()) < 20:
            return jsonify({'error': 'Task required (minimum 20 characters)'}), 400
        
        if not data.get('category'):
            return jsonify({'error': 'Category selection required'}), 400
        
        # Generate filename
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        safe_title = re.sub(r'[^\w\s-]', '', data['title']).strip().replace(' ', '-').lower()
        filename = f"{safe_title}-{timestamp}.md"
        
        # Build directory path
        categories_path = BASE_DIR / 'categories'
        category_path = categories_path / data['category']
        
        if data.get('subfolder') and data['subfolder'].strip():
            safe_subfolder = re.sub(r'[^\w\s-]', '', data['subfolder']).strip().replace(' ', '-').lower()
            target_dir = category_path / safe_subfolder
        else:
            target_dir = category_path
        
        # Create directories
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Build content
        created_timestamp = datetime.now().isoformat()
        tags = data.get('tags', '').strip()
        description = data.get('description', '').strip() or data['title']
        citation_format = data.get('citation_format', 'APA')
        subfolder_line = f"  <subfolder>{data.get('subfolder', '').strip()}</subfolder>\n" if data.get('subfolder', '').strip() else ""
        source_paths = data.get('source_paths', '').strip()
        output_path = data.get('output_path', '').strip()
        
        content = f"""<metadata>
  <title>{data['title']}</title>
  <description>{description}</description>
  <category>{data['category']}</category>
{subfolder_line}  <tags>{tags}</tags>
  <created>{created_timestamp}</created>
  <brand>pixeloni.ai</brand>
  <citation_format>{citation_format}</citation_format>
</metadata>

<role>
{data['role']}
</role>

<task>
{data['task']}
</task>

<context>
{data.get('context', '')}
</context>
"""
        
        if source_paths:
            content += f"""
<source_paths>
{source_paths}

NOTE: Use Desktop Commander tools (desktop-commander:read_file, desktop-commander:read_multiple_files) to access these file paths. If Claude cannot access these paths, STOP and request help accessing the file paths.
</source_paths>
"""
        
        # Add tab-specific sections
        tab_type = data.get('tab_type', 'basic')
        
        if tab_type == 'research':
            if data.get('sources'):
                content += f"\n<sources>\n{data['sources']}\n</sources>\n"
            if data.get('methodology'):
                content += f"\n<methodology>\n{data['methodology']}\n</methodology>\n"
        
        elif tab_type == 'code':
            if data.get('language'):
                content = content.replace('<task>', f"<language>\n{data['language']}\n</language>\n\n<task>")
            if data.get('dependencies'):
                content += f"\n<dependencies>\n{data['dependencies']}\n</dependencies>\n"
        
        elif tab_type == 'analysis':
            if data.get('data_format'):
                content += f"\n<data_format>\n{data['data_format']}\n</data_format>\n"
            if data.get('metrics'):
                content += f"\n<metrics>\n{data['metrics']}\n</metrics>\n"
            if data.get('formulas'):
                content += f"\n<formulas>\n{data['formulas']}\n</formulas>\n"
            if data.get('visualization_requirements'):
                content += f"\n<visualization_requirements>\n{data['visualization_requirements']}\n</visualization_requirements>\n"
        
        # Add examples section
        content += f"\n<examples>\n{data.get('examples', '')}\n</examples>\n"
        
        # Add remaining tab-specific sections
        if tab_type == 'research' and data.get('literature_review'):
            content += f"\n<literature_review>\n{data['literature_review']}\n</literature_review>\n"
        
        if tab_type == 'code':
            if data.get('tests'):
                content += f"\n<tests>\n{data['tests']}\n</tests>\n"
            if data.get('performance_requirements'):
                content += f"\n<performance_requirements>\n{data['performance_requirements']}\n</performance_requirements>\n"
        
        if tab_type == 'analysis' and data.get('comparison_criteria'):
            content += f"\n<comparison_criteria>\n{data['comparison_criteria']}\n</comparison_criteria>\n"
        
        # Add output_format and constraints
        content += f"\n<output_format>\n{data.get('output_format', '')}\n</output_format>\n"
        
        if output_path:
            content += f"""
<output_path>
{output_path}

NOTE: Save the final output to this absolute path using Desktop Commander tools.
</output_path>
"""
        
        content += f"\n<constraints>\n{data.get('constraints', '')}\n</constraints>\n"
        
        # Add remaining tab-specific sections before thinking
        if tab_type == 'research' and data.get('quality_criteria'):
            content += f"\n<quality_criteria>\n{data['quality_criteria']}\n</quality_criteria>\n"
        
        if tab_type == 'code':
            if data.get('style_guide'):
                content += f"\n<style_guide>\n{data['style_guide']}\n</style_guide>\n"
            if data.get('error_handling'):
                content += f"\n<error_handling>\n{data['error_handling']}\n</error_handling>\n"
        
        if tab_type == 'analysis' and data.get('confidence_levels'):
            content += f"\n<confidence_levels>\n{data['confidence_levels']}\n</confidence_levels>\n"
        
        # Add thinking section
        content += f"\n<thinking>\n{data.get('thinking', '')}\n</thinking>\n"
        
        # Save file
        file_path = target_dir / filename
        file_path.write_text(content, encoding='utf-8')
        
        return jsonify({
            'success': True,
            'filename': filename,
            'path': str(file_path.relative_to(BASE_DIR))
        })
    
    except Exception as e:
        return jsonify({'error': f'Save failed: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
