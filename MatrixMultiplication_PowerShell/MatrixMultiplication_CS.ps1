$source = @”
public class MatrixMultiplication
{
    public static float[,] Multiply(float[,] matrixA, float[,] matrixB)
    {
        int aM = matrixA.GetLength(0);
        int aN = matrixA.GetLength(1);
        int bN = matrixB.GetLength(1);
        float[,] matrixC = new float[aM, bN];
        for (int i = 0; i < aM; i++)
        {
            for (int j = 0; j < bN; j++)
            {
                matrixC[i, j] = 0.0f;
                for (int k = 0; k < aN; k++)
                {
                    matrixC[i, j] += matrixA[i, k] * matrixB[k, j];
                }
            }
        }
        return matrixC;
    }
}
“@

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

Add-Type -TypeDefinition $Source -Language CSharp 

$stopwatch = [system.diagnostics.stopwatch]::StartNew()

$matrixC = [MatrixMultiplication]::Multiply($matrixA, $matrixB)

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($stopwatch.Elapsed.TotalSeconds,"Execution time in seconds",0)