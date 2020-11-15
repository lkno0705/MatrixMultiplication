using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace MatrixMultiplication
{
    public unsafe struct Matrix
    {
        private readonly float[] data;

        public Matrix(int m, int n)
        {
            data = new float[m * n];
            M = m;
            N = n;
        }

        public float this[int i, int j]
        {
            set => data[i + M * j] = value;
            get => data[i + M * j];
        }

        public readonly int M;
        public readonly int N;

        public static Matrix CreateRandomMatrix(int m, int n)
        {
            Matrix matrix = new Matrix(m, n);
            Random random = new Random();

            for (int i = 0; i < m; ++i)
            {
                for (int j = 0; j < n; ++j)
                {
                    matrix[i, j] = (float)random.NextDouble();
                }
            }

            return matrix;
        }

        public static Matrix Multiply(Matrix a, Matrix b, bool multiThreaded = false)
        {
            int aM = a.M;
            int bM = b.M;
            int bN = b.N;
            int aN = a.N;

            Matrix c = new Matrix(aN, bN);
            int cN = c.N;

            if (multiThreaded)
            {
                GCHandle aHandle = GCHandle.Alloc(a.data, GCHandleType.Pinned);
                float* aData = (float*)aHandle.AddrOfPinnedObject();
                GCHandle bHandle = GCHandle.Alloc(b.data, GCHandleType.Pinned);
                float* bData = (float*)bHandle.AddrOfPinnedObject();
                GCHandle cHandle = GCHandle.Alloc(c.data, GCHandleType.Pinned);
                float* cData = (float*)cHandle.AddrOfPinnedObject();

                Parallel.For(0, aM, i =>
                {
                    
                    for (int k = 0; k < bN; k += 4)
                    {
                        var sum = System.Runtime.Intrinsics.Vector128.CreateScalarUnsafe(0f);

                        for (int j = 0; j < aN; ++j)
                        {
                            var avec = System.Runtime.Intrinsics.X86.Avx.BroadcastScalarToVector128(aData + aN * i + j);
                            var bvec = System.Runtime.Intrinsics.X86.Avx.BroadcastScalarToVector128(bData + bN * j + k);
                            var product = System.Runtime.Intrinsics.X86.Sse.Multiply(avec, bvec);
                            sum = System.Runtime.Intrinsics.X86.Sse.Add(sum, product);
                        }

                        System.Runtime.Intrinsics.X86.Sse.Store(cData + cN * i + k, sum);
                    }
                });

                aHandle.Free();
                bHandle.Free();
                cHandle.Free();
            }
            else
            {
                GCHandle aHandle = GCHandle.Alloc(a.data, GCHandleType.Pinned);
                float* aData = (float*)aHandle.AddrOfPinnedObject();
                GCHandle bHandle = GCHandle.Alloc(b.data, GCHandleType.Pinned);
                float* bData = (float*)bHandle.AddrOfPinnedObject();
                GCHandle cHandle = GCHandle.Alloc(c.data, GCHandleType.Pinned);
                float* cData = (float*)cHandle.AddrOfPinnedObject();

                for (int i = 0; i < aM; ++i)
                {
                    for (int k = 0; k < bN; k += 4)
                    {
                        var sum = System.Runtime.Intrinsics.Vector128.CreateScalarUnsafe(0f);

                        for (int j = 0; j < aN; ++j)
                        {
                            var avec = System.Runtime.Intrinsics.X86.Avx.BroadcastScalarToVector128(aData + aN * i + j);
                            var bvec = System.Runtime.Intrinsics.X86.Avx.BroadcastScalarToVector128(bData + bN * j + k);
                            var product = System.Runtime.Intrinsics.X86.Sse.Multiply(avec, bvec);
                            sum = System.Runtime.Intrinsics.X86.Sse.Add(sum, product);
                        }

                        System.Runtime.Intrinsics.X86.Sse.Store(cData + cN * i + k, sum);
                    }
                }

                aHandle.Free();
                bHandle.Free();
                cHandle.Free();
            }

            return c;
        }
    }
}
