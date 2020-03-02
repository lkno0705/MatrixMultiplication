package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

var waitGroup sync.WaitGroup

func main() {
	random := rand.New(rand.NewSource(2309487))
	var matrixA, matrixB [1440 * 1440]float32
	for i := 0; i < 1440*1440; i++ {
		matrixA[i] = random.Float32()
		matrixB[i] = random.Float32()
	}
	startST := time.Now()
	multiply(matrixA[:], matrixB[:])
	elapsedST := time.Since(startST)
	fmt.Printf("Single Threaded: Took: %fs \n", elapsedST.Seconds())
	startMT := time.Now()
	multiplyThreaded(matrixA[:], matrixB[:])
	elapsedMT := time.Since(startMT)
	fmt.Printf("Multi Threaded: Took: %fs \n", elapsedMT.Seconds())
	fmt.Println("Press enter to exit.")
	fmt.Scanln()
}

func multiply(matA []float32, matB []float32) []float32 {
	var matC [1440 * 1440]float32
	for i := 0; i < 1440; i++ {
		for k := 0; k < 1440; k++ {
			var sum float32 = 0.0
			for j := 0; j < 1440; j++ {
				sum += matA[i+1440*j] * matB[j+1440*k]
			}
			matC[i+1440*k] = sum
		}
	}
	return matC[:]
}

func multiplyRangeInto(from int, to int, matA []float32, matB []float32, matC []float32) {
	for i := from; i < to; i++ {
		for k := 0; k < 1440; k++ {
			var sum float32 = 0.0
			for j := 0; j < 1440; j++ {
				sum += matA[i+1440*j] * matB[j+1440*k]
			}
			matC[i+1440*k] = sum
		}
	}
	waitGroup.Done()
}

func multiplyThreaded(matA []float32, matB []float32) []float32 {
	var matC [1440 * 1440]float32
	waitGroup.Add(8)
	l := 1440 / 8
	for i := 0; i < 8; i++ {
		go multiplyRangeInto(l*i, l*(i+1), matA, matB, matC[:])
	}
	waitGroup.Wait()
	return matC[:]
}
