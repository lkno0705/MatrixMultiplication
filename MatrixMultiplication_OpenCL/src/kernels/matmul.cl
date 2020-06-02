void kernel MatMul(const __global float *a, const __global float *b, __global float *c, const int n) {
    const int globalRow = get_global_id(0);
    const int globalCol = get_global_id(1);

    float value = 0;
    for (int i = 0; i < n; i++)
    {
        value += a[i * n + globalRow] * b[i + n * globalCol];
    }
        
    c[globalCol * n + globalRow] = value;
}