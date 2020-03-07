using System;
using System.Diagnostics;

namespace MatrixMultiplication
{
    class Program
    {
        static void Main(string[] args)
        {
            Matrix a = Matrix.CreateRandomMatrix(1440, 1440);
            Matrix b = Matrix.CreateRandomMatrix(1440, 1440);

            Stopwatch singleStopWatch = Stopwatch.StartNew();
            Matrix cSingle = Matrix.Multiply(a, b);
            singleStopWatch.Stop();
            Console.WriteLine($"Single-Thread time: {singleStopWatch.ElapsedMilliseconds / 1000f}s");

            Stopwatch multiStopwatch = Stopwatch.StartNew();
            Matrix cMulti = Matrix.Multiply(a, b, true);
            multiStopwatch.Stop();
            Console.WriteLine($"Multi-Thread time: {multiStopwatch.ElapsedMilliseconds / 1000f}s");
            Console.ReadKey();
        }
    }
}
