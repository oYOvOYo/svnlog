# 创建一个更易读的SVN日志并在浏览器中打开

# 1. 创建临时文件
# 2. 调用svn log（带有可选参数）并将CSS注入到XML输出中
# 3. 在默认浏览器中打开文件

# 创建临时文件
$tmpFile = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.xml'

# 获取脚本路径
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 替换字符串
$replacement = 's|<\?xml version="1\.0"\?>|<\?xml version="1\.0"\?><\?xml-stylesheet type="text/css" media="screen" href="' + $scriptPath + '\svnlog.css"\?>|'

# 调用svn log并注入CSS
svn log --xml --limit 20 @args | Select-String -Pattern $replacement -AllMatches | ForEach-Object { $_.Line } | Out-File -FilePath $tmpFile -Encoding utf8

# 打开文件在默认浏览器中
Start-Process $tmpFile
