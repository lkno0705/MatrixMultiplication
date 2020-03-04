const THREADS = 24

function matrix_mult(c::Matrix{Float64}, b::Matrix{Float64}, a::Matrix{Float64}, upper::Int64, lower::Int64=1)
    range = size(c,1)
    for i = lower:upper
        for j = 1:range
            sum = 0
            for k = 1:size(b,1)
                sum += a[i, k] * b[k, j]
            end
            c[i, j] = sum
        end
    end
end

function matrix_mult_threaded(c::Matrix{Float64}, b::Matrix{Float64}, a::Matrix{Float64})
    threads = Array{Task, 1}(undef, THREADS)
    step::Int64 = floor(size(b, 1) / THREADS)
    for i = 0:THREADS-1
        upper = (i+1)*step+1
        if i == THREADS-1
            upper = size(c,1)
        end
        threads[i+1] = Threads.@spawn matrix_mult(c, b, a, upper, i*step+1)
    end
    for i = 1:THREADS 
        wait(threads[i])
    end
end


function run()
    card = 1440
    a = randn(Float64, (card, card))
    b = randn(Float64, (card, card))
    c = zeros(Float64, card, card)
    @time matrix_mult(c, b, a, card)
     
    c = zeros(Float64, card, card)
    @time matrix_mult_threaded(c, b, a)
end

run()

