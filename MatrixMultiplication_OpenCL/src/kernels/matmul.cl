void kernel MatMul(const __global float *a, const __global float *b, __global float *c, const int m, const int n, const int k) {
    const int globalRow = get_global_id(0); //M
    const int globalCol = get_global_id(1); //N

    float value = 0;
    for (int i = 0; i < k; i++) //K
    {
        value += a[i * m + globalRow] * b[i + k * globalCol];
    }
        
    c[globalCol * m + globalRow] = value;
}