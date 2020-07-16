function main()
    -- multiply random matrices with the size m x n * n x p  
    local m = 244;
    local n = 244;
    local p = 244;

    local a = randomMatrix(m, n)
    local b = randomMatrix(n, p)
    local c = {}
    
    for row=0,(m-1) do
        for col=0,(p-1) do
            local sum = 0
            for k=0,(n-1) do
                -- print(((row*n) + col) .. " > " .. ((row*n) + k) .. "," .. ((k*p) + col))
                sum = sum + (a[row*n + k] * b[k*p + col])
            end
            c[row*n + col] = sum
        end
    end

    for k=0,(m*p -1) do
        -- print(c[k])
    end
end

function randomMatrix(size_m, size_n)
    a = {}
    for i=0,(size_m*size_n -1) do
        a[i] = math.random()
    end
    return a
end

t_start = os.time()
main()
t_end = os.time()
print("Time: " .. (t_end - t_start))