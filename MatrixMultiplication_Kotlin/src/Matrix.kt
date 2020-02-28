import kotlin.random.Random

class Matrix(n: Int, m: Int) {
    var matrix = Array(n) {IntArray(m)}

    fun randomize() {
        val generator = Random(System.currentTimeMillis())
        for(r in matrix.indices) {
            for(c in matrix[r].indices) matrix[r][c] = 2//generator.nextInt(0, 99)
        }
    }

    fun print() {
        matrix.forEach { row ->
            row.forEach { item -> print("$item ")}
            println()
        }
        println()
    }
}