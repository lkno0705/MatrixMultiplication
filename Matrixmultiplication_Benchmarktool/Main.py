import subprocess

# python cmd: "python", "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Python/Matrixmult.py"
# CUDA cmd: "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_CUDA.exe"
# C cmd: "E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_C.exe"


def run():
    cmd = ["E:/Programs/MatrixMultiplication-master/MatrixMultiplication_Exec/MatrixMultiplication_Go.exe"]
    out = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
    out = str(out).replace("\\n", " ")
    out = out.replace("\\r", " ")
    out = out.replace("ms", " ")
    out = out.replace("s", " ")
    out = out.replace(",", ".")
    print(out)
    return out


def convertOutput(out):
    data = []
    for i in out.split():
        try:
            data.append(int(i))
        except ValueError:
            try:
                data.append(float(i))
            except ValueError:
                pass
    print(data)


out = run()
convertOutput(out)
