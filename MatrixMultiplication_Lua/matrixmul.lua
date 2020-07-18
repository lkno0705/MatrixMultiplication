-- multiply random matrices with the size m x n * n x p  
m = 1440;
n = 1440;
p = 1440;

function single()
    local a = randomMatrix(m, n)
    local b = randomMatrix(n, p)
    local c = {}
    
    for row=1,m do
        for col=1,p do
            local sum = 0
            for k=1,n do
                sum = sum + (a[(row-1)*n + k] * b[(k-1)*p + col])
            end
            c[(row-1)*n + col] = sum
        end
    end
end

function randomMatrix(size_m, size_n)
    a = {}
    for i=1,(size_m*size_n) do
        a[i] = math.random()
    end
    return a
end

t_start = os.clock()
single()
t_end = os.clock()
print("Single: " .. (t_end-t_start) .. "s")