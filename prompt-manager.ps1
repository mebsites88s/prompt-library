# PixelOni.ai Prompt Library Manager
param([string]$Action = "generate", [string]$PromptFile = "", [switch]$OpenInBrowser)
$PromptRoot = "C:\Users\aaron\Desktop\PixelOni\scripts\prompts"
$IndexPath = "$PromptRoot\index.html"

function Parse-PromptFile {
    param([string]$FilePath)
    $content = Get-Content -Path $FilePath -Raw
    $metadata = @{}
    if ($content -match '## Metadata\s+([\s\S]*?)(?=\n##)') {
        $metaBlock = $matches[1]
        $metaBlock -split "`n" | ForEach-Object {
            if ($_ -match '^\s*-\s*\*\*(.+?)\*\*:\s*(.+)$') {
                $metadata[$matches[1].Trim()] = $matches[2].Trim()
            }
        }
    }
    if ($content -match '# (.+)') { $metadata['Title'] = $matches[1].Trim() }
    $metadata['FileName'] = Split-Path -Leaf $FilePath
    $metadata['FilePath'] = $FilePath
    $metadata['RelativePath'] = $FilePath.Replace("$PromptRoot\", "").Replace('\', '/')
    return $metadata
}

function Get-AllPrompts {
    $prompts = @()
    @('coding', 'writing', 'analysis', 'automation') | ForEach-Object {
        $catPath = "$PromptRoot\categories\$_"
        if (Test-Path $catPath) {
            Get-ChildItem -Path $catPath -Filter *.md | ForEach-Object {
                $prompt = Parse-PromptFile $_.FullName
                $prompt['Category'] = $cat
                $prompts += $prompt
            }
        }
    }
    return $prompts
}

function Get-CategoryStats {
    $stats = @{ coding = 0; writing = 0; analysis = 0; automation = 0 }
    $stats.Keys | ForEach-Object {
        $catPath = "$PromptRoot\categories\$_"
        if (Test-Path $catPath) { $stats[$_] = (Get-ChildItem -Path $catPath -Filter *.md).Count }
    }
    return $stats
}

function Create-ClaudeThread {
    param([string]$PromptPath)
    if (-not (Test-Path $PromptPath)) { Write-Error "Prompt not found: $PromptPath"; return }
    $promptContent = Get-Content -Path $PromptPath -Raw
    if ($promptContent -match '## The Prompt\s+([\s\S]*?)(?=\n##)') {
        $actualPrompt = $matches[1].Trim()
    } else { $actualPrompt = $promptContent }
    Set-Clipboard -Value $actualPrompt
    Start-Process "https://claude.ai/new"
    Write-Host "`n✓ Prompt copied to clipboard" -ForegroundColor Green
    Write-Host "✓ Opening Claude.ai..." -ForegroundColor Green
    Write-Host "`nPaste (Ctrl+V) to start conversation`n" -ForegroundColor Cyan
}

switch ($Action.ToLower()) {
    "generate" {
        Write-Host "Generating..." -ForegroundColor Cyan
        $prompts = Get-AllPrompts
        $stats = Get-CategoryStats
        $total = $prompts.Count
        $date = Get-Date -Format "yyyy-MM-dd"
        $list = ""
        $prompts | Sort-Object {$_.FileName} -Descending | Select-Object -First 20 | ForEach-Object {
            $t=$_.Title;$c=$_.Category;$f=$_.RelativePath;$tags=""
            if($_['Topic Tags']){$tl=$_['Topic Tags'] -replace '[\[\]]','' -split ',';$tags=($tl|%{"<span class='tag'>$($_.Trim())</span>"})-join''}
            $list+="<div class='prompt-item'><div class='prompt-title' onclick='viewPrompt(`"$f`")'>$t</div><div class='prompt-meta'><span>📁 $c</span>$tags</div><div class='prompt-actions'><button onclick='openInClaude(`"$f`")' class='claude-btn'>Open in Claude</button></div></div>"
        }
        if($total -eq 0){$list="<div class='prompt-item'><div class='prompt-title'>No prompts yet</div><p>Add your first prompt!</p></div>"}
        $html=@"
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>PixelOni.ai - Prompt Library</title><style>*{margin:0;padding:0;box-sizing:border-box}:root{--dn:#1a3a52;--n:#2a4a62;--c:#f5e6d3;--t:#7dd3c0;--co:#ffa07a;--td:#1a3a52}body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:var(--c);color:var(--td);line-height:1.6}.header{background:linear-gradient(135deg,var(--dn) 0%,var(--n) 100%);padding:2rem;box-shadow:0 4px 6px rgba(0,0,0,0.1)}.header-content{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:2rem}.logo-container{flex-shrink:0}.logo{width:120px;height:120px;border-radius:50%;background:var(--c);padding:10px;box-shadow:0 4px 12px rgba(0,0,0,0.2)}.header-text h1{color:var(--c);font-size:2.5rem;margin-bottom:0.5rem;text-shadow:2px 2px 4px rgba(0,0,0,0.3)}.header-text p{color:var(--t);font-size:1.1rem}.container{max-width:1200px;margin:2rem auto;padding:0 2rem}.search-bar{background:white;padding:1.5rem;border-radius:12px;box-shadow:0 2px 8px rgba(0,0,0,0.1);margin-bottom:2rem;border:2px solid var(--t)}.search-bar input{width:100%;padding:1rem;font-size:1rem;border:2px solid var(--n);border-radius:8px;outline:none;transition:all 0.3s}.search-bar input:focus{border-color:var(--t);box-shadow:0 0 0 3px rgba(125,211,192,0.2)}.categories{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1.5rem;margin-bottom:2rem}.category-card{background:white;padding:1.5rem;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,0.1);border-left:4px solid var(--t);transition:all 0.3s;cursor:pointer}.category-card:hover{transform:translateY(-4px);box-shadow:0 6px 20px rgba(0,0,0,0.15);border-left-color:var(--co)}.category-card h3{color:var(--dn);font-size:1.4rem;margin-bottom:0.5rem}.category-card .count{color:var(--t);font-weight:bold;font-size:1.1rem}.prompts-section{background:white;padding:2rem;border-radius:12px;box-shadow:0 2px 8px rgba(0,0,0,0.1)}.prompt-item{border-bottom:1px solid #e0e0e0;padding:1.5rem 0;transition:all 0.2s}.prompt-item:last-child{border-bottom:none}.prompt-item:hover{background:rgba(125,211,192,0.05);padding-left:1rem;margin-left:-1rem;border-radius:8px}.prompt-title{color:var(--dn);font-size:1.2rem;font-weight:600;margin-bottom:0.5rem;cursor:pointer}.prompt-meta{display:flex;gap:1rem;flex-wrap:wrap;font-size:0.9rem;color:#666;margin-bottom:0.5rem}.tag{background:var(--t);color:white;padding:0.3rem 0.8rem;border-radius:20px;font-size:0.85rem}.prompt-actions{display:flex;gap:0.5rem;margin-top:0.5rem}.claude-btn{padding:0.5rem 1rem;border:none;border-radius:6px;cursor:pointer;font-size:0.9rem;transition:all 0.2s;background:var(--co);color:white}.claude-btn:hover{background:#ff8c5a;transform:translateY(-2px)}.stats{display:flex;gap:2rem;margin-bottom:2rem;flex-wrap:wrap}.stat-card{flex:1;min-width:200px;background:linear-gradient(135deg,var(--t) 0%,var(--co) 100%);color:white;padding:1.5rem;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,0.1)}.stat-card h4{font-size:0.9rem;opacity:0.9;margin-bottom:0.5rem}.stat-card .number{font-size:2.5rem;font-weight:bold}.footer{text-align:center;padding:2rem;color:var(--n);margin-top:4rem}.refresh-btn{position:fixed;bottom:2rem;right:2rem;background:var(--co);color:white;border:none;padding:1rem 1.5rem;border-radius:50px;cursor:pointer;box-shadow:0 4px 12px rgba(0,0,0,0.2);font-size:1rem;transition:all 0.3s}.refresh-btn:hover{background:#ff8c5a;transform:scale(1.05)}</style></head><body><div class="header"><div class="header-content"><div class="logo-container"><img src="../../Branding/Logo-beard.png" alt="PixelOni.ai Logo" class="logo"></div><div class="header-text"><h1>PixelOni.ai Prompt Library</h1><p>Your organized collection of AI prompts and workflows</p></div></div></div><div class="container"><div class="stats"><div class="stat-card"><h4>Total Prompts</h4><div class="number">$total</div></div><div class="stat-card"><h4>Categories</h4><div class="number">4</div></div><div class="stat-card"><h4>Last Updated</h4><div class="number" style="font-size:1.2rem;">$date</div></div></div><div class="search-bar"><input type="text" id="searchInput" placeholder="Search prompts by title, tags, or content..."/></div><div class="categories"><div class="category-card" onclick="filterByCategory('coding')"><h3>🔧 Coding</h3><p>Development and programming prompts</p><div class="count">$($stats.coding) prompts</div></div><div class="category-card" onclick="filterByCategory('writing')"><h3>✍️ Writing</h3><p>Content creation and documentation</p><div class="count">$($stats.writing) prompts</div></div><div class="category-card" onclick="filterByCategory('analysis')"><h3>📊 Analysis</h3><p>Data processing and insights</p><div class="count">$($stats.analysis) prompts</div></div><div class="category-card" onclick="filterByCategory('automation')"><h3>⚙️ Automation</h3><p>Scripts and workflow automation</p><div class="count">$($stats.automation) prompts</div></div></div><div class="prompts-section"><h2 style="color:var(--dn);margin-bottom:1.5rem;">Recent Prompts</h2><div id="promptsList">$list</div></div></div><div class="footer"><p>PixelOni.ai Prompt Library | satanzhand since 1980s</p></div><button class="refresh-btn" onclick="refreshLibrary()">🔄 Refresh</button><script>function viewPrompt(p){window.open('file:///C:/Users/aaron/Desktop/PixelOni/scripts/prompts/'+p,'_blank')}function openInClaude(p){const f='C:\\Users\\aaron\\Desktop\\PixelOni\\scripts\\prompts\\'+p.replace(/\//g,'\\');const cmd='powershell.exe -ExecutionPolicy Bypass -Command "& {. '+f.replace(/\\/g,'\\\\')+'; Create-ClaudeThread -PromptPath '+f.replace(/\\/g,'\\\\')+'}"';window.location.href='command://'+encodeURIComponent(cmd);alert('Opening in Claude...')}function filterByCategory(c){document.querySelectorAll('.prompt-item').forEach(i=>{i.style.display=i.textContent.includes(c)?'block':'none'})}function refreshLibrary(){window.location.reload()}document.getElementById('searchInput').addEventListener('input',e=>{const t=e.target.value.toLowerCase();document.querySelectorAll('.prompt-item').forEach(i=>{i.style.display=i.textContent.toLowerCase().includes(t)?'block':'none'})})</script></body></html>
"@
        $html | Set-Content -Path $IndexPath -Encoding UTF8
        Write-Host "✓ Generated: $IndexPath" -ForegroundColor Green
        if($OpenInBrowser){Start-Process $IndexPath;Write-Host "✓ Opened in browser" -ForegroundColor Green}
    }
    "create-thread" { if($PromptFile){Create-ClaudeThread -PromptPath $PromptFile}else{Write-Error "PromptFile required"} }
    "list" { Write-Host "`nPixelOni.ai Prompt Library" -ForegroundColor Cyan;Write-Host ("="*50) -ForegroundColor Gray;Get-AllPrompts|Sort-Object Category,FileName|%{Write-Host "`n📝 $($_.Title)" -ForegroundColor Yellow;Write-Host "   Category: $($_.Category)" -ForegroundColor Gray;Write-Host "   File: $($_.FileName)" -ForegroundColor Gray;if($_.['Topic Tags']){Write-Host "   Tags: $($_.['Topic Tags'])" -ForegroundColor Gray}};Write-Host "`nTotal: $((Get-AllPrompts).Count) prompts" -ForegroundColor Green }
    "stats" { $s=Get-CategoryStats;$t=($s.Values|Measure-Object -Sum).Sum;Write-Host "`nPrompt Library Statistics" -ForegroundColor Cyan;Write-Host ("="*50) -ForegroundColor Gray;Write-Host "`nTotal Prompts: $t" -ForegroundColor Green;Write-Host "`nBy Category:" -ForegroundColor Yellow;$s.GetEnumerator()|Sort-Object Name|%{Write-Host "  $($_.Key): $($_.Value)" -ForegroundColor Gray};Write-Host "" }
    default { Write-Host "PixelOni.ai Prompt Library Manager" -ForegroundColor Cyan;Write-Host "Usage:" -ForegroundColor Yellow;Write-Host "  .\prompt-manager.ps1 -Action generate [-OpenInBrowser]";Write-Host "  .\prompt-manager.ps1 -Action create-thread -PromptFile <path>";Write-Host "  .\prompt-manager.ps1 -Action list";Write-Host "  .\prompt-manager.ps1 -Action stats" }
}
