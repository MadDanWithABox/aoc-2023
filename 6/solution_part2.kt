import java.io.File

fun main() {
    //val filePath = "src/demo.txt"
    val filePath = "src/input.txt"
    val lines = File(filePath).readLines()
    val res = pairTimesAndDistances(lines[0], lines[1])
}

fun pairTimesAndDistances(time: String, distance: String): Int {
    val timesValue = time.substringAfter(':').replace("\\s".toRegex(), "")
    val distancesValue = distance.substringAfter(':').replace("\\s".toRegex(), "")

    val waysToWin = mutableListOf(computeRaces(timesValue.toLong(), distancesValue.toLong()))
    val result = calculateProduct(waysToWin)
    println("Overall output: $result")
    return result
}

fun computeRaces(time: Long, record: Long): Int {
    var result = findAddends(time)
    val recordBeaters = result.count { (i, j) -> i * j > record }
    return (recordBeaters*2)-1
}

fun findAddends(targetSum: Long): List<Pair<Long, Long>> {
    val addends = mutableListOf<Pair<Long, Long>>()

    for (i in 1 until targetSum / 2 + 1) {
        val j = targetSum - i
        addends.add(i to j)
    }

    return addends
}

fun calculateProduct(numbers: List<Int>): Int {
    // Using fold to calculate the product
    return numbers.fold(1) { acc, number -> acc * number }
}
