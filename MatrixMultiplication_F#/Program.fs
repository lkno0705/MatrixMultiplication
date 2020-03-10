// Learn more about F# at http://fsharp.org
module M
open System
open System.Threading

type Matrix =
    {data: float32 array; dimension : int*int}
    member self.mul(other: Matrix, res_buffer: Matrix) =
        let (d1,n,m) = (self.data, fst self.dimension, snd self.dimension)
        let (d2,m',p) = (other.data, fst other.dimension, snd other.dimension)
        assert(m = m')
        for i in 0..(m-1) do
            for k in 0..(p-1) do
                let mutable sum = 0.0f
                for j in 0..(n-1) do
                    sum <- sum+d1.[n*i+j]*d2.[p*j+k]
                res_buffer.data.[p*i+k] <- sum
        ()
let spawn_threads threads m1 m2 resbuf=
    let (d1,n,m) = (m1.data, fst m1.dimension, snd m1.dimension)
    let (d2,m',p) = (m2.data, fst m2.dimension, snd m2.dimension)
    assert(m = m')
    let step = m / threads
    let mutable thread_handles = []
    for i in 0..threads-1 do
        let threadBody() =
            let lower = i * step;
            let upper = if i <> threads-1 then (i+1)*step else m
            for i in lower..(upper-1) do
                for k in 0..(p-1) do
                    let mutable sum = 0.0f
                    for j in 0..(n-1) do
                        sum <- sum+d1.[n*i+j]*d2.[p*j+k]
                    resbuf.data.[p*i+k] <- sum
        let thread = new Thread(threadBody)
        thread.Start()
        thread_handles <- thread::thread_handles
    for thread in thread_handles do
        thread.Join()
    ()
[<EntryPoint>]
let main argv =
    let threads = Environment.ProcessorCount;
    let rand = System.Random();
    let matrix1 = {data = [| for i in 1..1440*1440 -> float32 (rand.NextDouble())|]; dimension = (1440, 1440)}
    let matrix2 = {data = [| for i in 1..1440*1440 -> float32 (rand.NextDouble())|]; dimension = (1440, 1440)}
    let res = {data = [| for i in 1..1440*1440 -> 0.0f|]; dimension = (1440, 1440)}
    let res2 = {data = [| for i in 1..1440*1440 -> 0.0f|]; dimension = (1440, 1440)}
    let timer = new System.Diagnostics.Stopwatch()
    timer.Start()
    matrix1.mul(matrix2, res)
    printfn "Elapsed Time: %ims" timer.ElapsedMilliseconds
    timer.Reset()
    timer.Start()
    spawn_threads threads matrix1 matrix2 res2
    printfn "Elapsed Time: %ims" timer.ElapsedMilliseconds
    assert(res = res2)
    0 // return an integer exit code
