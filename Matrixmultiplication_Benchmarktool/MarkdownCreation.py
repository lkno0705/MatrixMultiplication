
class Readme:

    def newReadme(self, data):
        path = "E:/Programs/MatrixMultiplication-master/Matrixmultiplication_Benchmarktool/README.md"
        file = open(path, "w")

        langs = ["Python", "Java","C++", "CUDA", "Kotlin", "Rust", "C#", "C", "GO"]
        langs.sort()
        header = "# MatrixMultiplication" \
                 " Just a little playground, to test and try the benefits of Running Calculations on CPU or GPU with multiple threads. " \
                 "\n\n" \
                 "Compared Runtimes:\n\n" \
                 "Matrix size: 1440x1440 <br> " \
                 "Threads: 24\n\n"


