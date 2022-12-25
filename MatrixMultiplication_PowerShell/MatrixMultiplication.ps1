$aM = 1440
$aN = 1440
$bN = 1440

$matrixA = New-Object 'Float[,]' $aM, $aN
$matrixB = New-Object 'Float[,]' $aN, $bN
$matrixC = New-Object 'Float[,]' $aM, $bN

for ($i = 0; $i -lt $aM; $i++) {
    for ($j = 0; $j -lt $aN; $j++) {
        $matrixA[$i, $j] = Get-Random -Minimum 1.0 -Maximum 10.0
    }
}

for ($i = 0; $i -lt $aN; $i++) {
    for ($j = 0; $j -lt $bN; $j++) {
        $matrixB[$i, $j] = Get-Random -Minimum 1.0 -Maximum 10.0
    }
}

$stopwatch = [system.diagnostics.stopwatch]::StartNew()
for ($i = 0; $i -lt $aM; $i++) {
    for ($j = 0; $j -lt $bN; $j++) {
        $matrixC[$i, $j] = 0.0
        for ($k = 0; $k -lt $aN; $k++) {
            $matrixC[$i, $j] += $matrixA[$i, $k] * $matrixB[$k, $j]
        }
    }
}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($stopwatch.Elapsed.TotalSeconds,"Execution time in seconds",0)