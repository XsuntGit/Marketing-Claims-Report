param(
[Parameter(Position=1)]
[String]$FilePath,
[Parameter(Position=2)]
[String]$CSVFilePath,
[Parameter(Position=3)]
[String]$Alias,
[Parameter(Position=4)]
[String]$RecordCount
)
Get-ChildItem $FilePath | Select-Object -Property @{Name="FileType";Expression={($Alias)}}, @{Name="FileName";Expression={($_.Name)}}, @{Name="RecordCount";Expression={($RecordCount)}}, @{Name="FileSize";Expression={[math]::ceiling($_.length/1kb)}}, @{Name="MD5";Expression={(Get-FileHash -Algorithm MD5 $_.FullName).hash}} | Export-Csv -Append -Path $CSVFilePath -NoTypeInformation
