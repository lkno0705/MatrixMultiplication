import subprocess

# python cmd: "python", "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Python/Matrixmult.py"
# CUDA cmd: "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_CUDA.exe"
# C cmd: "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_C.exe"

def run():
    cmd = ["E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_CUDA.exe"]
    out = subprocess.Popen(cmd, stdout=subprocess.PIPE ).communicate()[0]
    print(out)

run()