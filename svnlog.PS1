# Copyright (c) 2024 jskyzero 
# Licensed under the MIT License. See LICENSE file for details.

# param (
#     [int]$Limit = 20  # 定义一个参数 $Limit，默认值为20
# )

# 设置PowerShell的默认编码为UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# 创建一个更易读的SVN日志并在浏览器中打开

# 1. 创建临时文件
# 2. 调用svn log（带有可选参数）并将CSS注入到XML输出中
# 3. 在默认浏览器中打开文件

# 创建临时文件
# $tmpFile = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.xml'
$tmpFile = "$env:TEMP\svnlog.xml"


# 获取脚本路径
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 替换字符串
$replacement = '<\?xml version="1\.0" encoding="UTF-8"\?>'
$replacementWithCss = '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/css" media="screen" href="' + $scriptPath + '\svnlog.css"?>'

# 调用svn log并注入CSS
# 使用Out-String将输出转换为字符串，以确保正确处理中文字符
# $svnLogOutput = svn log --xml --limit $Limit | Out-String
$svnLogOutput = svn log --xml --limit 20 @args | Out-String


# 使用正则表达式进行替换
$modifiedOutput = $svnLogOutput -replace $replacement, $replacementWithCss

# 将结果输出到临时文件中，使用UTF-8编码
[System.IO.File]::WriteAllText($tmpFile, $modifiedOutput, [System.Text.Encoding]::UTF8)

# 打开文件在默认浏览器中
# Start-Process $tmpFile

# 确保使用默认浏览器打开文件
Start-Process "msedge.exe" $tmpFile -ErrorAction SilentlyContinue -ErrorVariable err
if ($err) {
    Start-Process "chrome.exe" $tmpFile -ErrorAction SilentlyContinue -ErrorVariable err
    if ($err) {
        Start-Process "firefox.exe" $tmpFile -ErrorAction SilentlyContinue -ErrorVariable err
        if ($err) {
            Start-Process $tmpFile
        }
    }
}