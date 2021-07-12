# �G���R�[�f�B���O�iSJIS�j
$OutputEncoding = [console]::OutputEncoding

# �t�@�C���ۑ��_�C�A���O
Add-Type -AssemblyName System.Windows.Forms
$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog 
$SaveFileDialog.Filter = "csv�t�@�C��(*.csv)|*.csv|���ׂẴt�@�C��(*.*)|*.*"
$SaveFileDialog.InitialDirectory = ".\"

# �t�@�C���J���_�C�A���O
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog 
$OpenFileDialog.Filter = "csv�t�@�C��(*.csv)|*.csv|���ׂẴt�@�C��(*.*)|*.*"
$OpenFileDialog.InitialDirectory = ".\"

Write-Progress -Activity "�ύX�OCSV�̓ǂݍ���" -Status �ǂݍ��݊J�n
$OpenFileDialog.Filename = "�ύX�O.csv"
if($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
  $Header = (Get-Content -Path $OpenFileDialog.Filename)[0].Split(",") | % Replace "`"" "" | % Trim
  Write-Progress -Activity "�ύX�OCSV�̓ǂݍ���" -Status �ǂݍ��ݒ�
  $A = Get-Content -Path $OpenFileDialog.Filename | % Insert 0 "�폜,"
  Write-Progress -Activity "�ύX�OCSV�̓ǂݍ���" -Status �ǂݍ��ݏI��
  $A[0] = $A[0].Replace("�폜", "�ύX�敪")
}

Write-Progress -Activity "�ύX��CSV�̓ǂݍ���" -Status �ǂݍ��݊J�n
$OpenFileDialog.Filename = "�ύX��.csv"
if($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
  Write-Progress -Activity "�ύX��CSV�̓ǂݍ���" -Status �ǂݍ��ݒ�
  $B = Get-Content -Path $OpenFileDialog.Filename | % Insert 0 "�ǉ�,"
  Write-Progress -Activity "�ύX��CSV�̓ǂݍ���" -Status �ǂݍ��ݏI��
  $B[0] = $B[0].Replace("�ǉ�", "��\��")
}


Write-Progress "CSV���\�[�g"
$SortKey  = $Header | Out-GridView -PassThru -Title "�\�[�g�L�[��I��ł�������"
$C = $A + $B | ConvertFrom-CSV | Sort-Object ($SortKey + "�ύX�敪")

Write-Progress "CSV���r" -percentComplete 0
$CompKey = $Header | Out-GridView -PassThru -Title "��r�L�[��I��ł�������"
for($i = 0; $i -lt $C.length - 1; $i++){
  Write-Progress "CSV���r" -percentComplete (100 * ($i)/($C.length))
  if($C[$i].�ύX�敪 -eq "�폜" -and $C[$i+1].�ύX�敪 -eq "�ǉ�"){
    if(
      ($C[$i]   | Select-Object $CompKey | ConvertTo-Json) -eq
      ($C[$i+1] | Select-Object $CompKey | ConvertTo-Json)
    ){
      $C[$i].�ύX�敪 = "��\��"
      $C[$i+1].�ύX�敪 = ""
    } elseif(
      ($C[$i]   | Select-Object $SortKey | ConvertTo-Json) -eq
      ($C[$i+1] | Select-Object $SortKey | ConvertTo-Json)
    ){
      $C[$i].�ύX�敪 = "�ύX�O"
      $C[$i+1].�ύX�敪 = "�ύX��"
    }
    $i++
  }
}

$C = $C | ? �ύX�敪 -ne "��\��"
$C | Out-GridView -title "��r����" -PassThru | Out-Null

$SaveFileDialog.Filename = "��r����.csv"
if ($SaveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
  $C | Export-Csv -Encoding Default -NoTypeInformation -Path $SaveFileDialog.Filename
}