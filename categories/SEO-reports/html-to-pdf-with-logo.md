# HTML to PDF Conversion with Logo

## Metadata
- **Date Created**: 2025-10-18
- **Category**: SEO-reports
- **Topic Tags**: [pdf-conversion, html-rendering, reporting, chrome-automation]
- **Use Case**: Convert styled HTML reports to PDF with logo placement on last page

## The Prompt

Convert HTML file to PDF with full styling preservation and logo on bottom right of last page.

**Source HTML**: `[HTML_FILE_PATH]`
**Logo Path**: `[LOGO_FILE_PATH]`
**Output PDF**: `[OUTPUT_PDF_PATH]`

Be concise. If directory is denied, stop and notify.

## Context/Variables

Required paths:
- **HTML_FILE_PATH**: Full path to source HTML file
  - Example: `\\192.168.0.165\Volume_2\Websites\eraze\report.html`
- **LOGO_FILE_PATH**: Full path to logo image (PNG/JPG)
  - Example: `C:\Users\aaron\Desktop\PixelOni\scripts\prompts\logo.png`
- **OUTPUT_PDF_PATH**: Desired PDF output location
  - Example: `\\192.168.0.165\Volume_2\Websites\eraze\report.pdf`

## Expected Output

Python script that:
1. Uses Selenium + Chrome headless to render HTML with full CSS/styling
2. Converts to PDF via Chrome's print-to-PDF function
3. Uses PyPDF2 to overlay logo on bottom right of last page
4. Preserves all images, charts, formatting from original HTML
5. Outputs single merged PDF file

**Key Technical Requirements**:
- Chrome headless rendering (preserves all styling)
- Print background: true (captures background colors/gradients)
- Logo positioning: bottom-right with 40px margin, 120x120px
- Clean up temporary files

## Implementation Pattern

```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from PyPDF2 import PdfReader, PdfWriter
from reportlab.pdfgen import canvas
import base64
import io

# Chrome headless setup
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--no-sandbox')

print_options = {
    'landscape': False,
    'displayHeaderFooter': False,
    'printBackground': True,
    'preferCSSPageSize': True,
}

# Convert HTML → PDF via Chrome
driver = webdriver.Chrome(options=chrome_options)
driver.get(f'file:///{html_path}')
result = driver.execute_cdp_cmd("Page.printToPDF", print_options)

# Add logo to last page via PyPDF2 overlay
# Position: x = page_width - 160, y = 30
# Size: 120x120px
```

## Notes

**Critical Success Factors**:
- Chrome/Selenium preserves 100% of HTML/CSS styling (unlike xhtml2pdf or reportlab alone)
- Relative image paths in HTML must be correct or converted to absolute paths
- UNC paths work fine with Chrome file:/// protocol
- Logo overlay uses reportlab Canvas → PyPDF2 merge on last page only

**Common Issues**:
- Image paths: If images don't show, check src paths are relative to HTML location or absolute
- Network drives: UNC paths (\\server\share) work, but convert backslashes to forward slashes for file:/// URLs
- Missing dependencies: Requires `selenium`, `PyPDF2`, `reportlab`, Chrome/Chromium installed

**When to Use**:
- Complex HTML reports with gradients, custom fonts, charts
- Client deliverables requiring exact brand styling
- Multi-page reports with embedded images

**Avoid Using When**:
- Simple text-only PDFs (use reportlab directly)
- Real-time generation at scale (Chrome is slower than pure Python libs)

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 100% when dependencies installed
- **Average Time**: ~5-10 seconds for 10-page report

## Dependencies

Required Python packages:
```bash
pip install selenium PyPDF2 reportlab
```

System requirements:
- Chrome or Chromium browser installed
- ChromeDriver (auto-managed by Selenium 4.6+)

## Revision History
- 2025-10-18: Initial creation - ERAZE recovery report conversion
