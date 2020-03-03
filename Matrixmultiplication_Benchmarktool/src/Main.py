import subprocess

def run():
    cmd = ["python", "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Python/Matrixmult.py"]
    out = subprocess.Popen(cmd, stdout=subprocess.PIPE ).communicate()[0]
    print(out)

run()