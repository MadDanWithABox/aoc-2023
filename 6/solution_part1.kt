import java.io.File


fun main() {
    //val filePath = "src/demo.txt"
    val filePath = "src/input.txt"
    val lines = File(filePath).readLines()
    val res = pairTimesAndDistances(lines[0], lines[1])
}

fun pairTimesAndDistances(time:String, distance:String): Int {
    // drop first elements of lists
    var times = time.substringAfter(':')
    var distances = distance.substringAfter(':')
    var timesArray = times.split("\\s+".toRegex())
    var distancesArray = distances.split(("\\s+".toRegex()))
    var waysToWin = mutableListOf<Int>()
    distancesArray = distancesArray.map { it.replace("\\s".toRegex(), "") }
    timesArray = timesArray.map { it.replace("\\s".toRegex(), "") }
    for (i in distancesArray.indices) {

        if (i ==0) {
            continue
        }
        else {
            waysToWin.add(computeRaces(timesArray[i].toInt(), distancesArray[i].toInt()))
        }
    }
    println("There are this many ways to win in each race: $waysToWin")
    val result = calculateProduct(waysToWin)
    println("Overall output: $result")
    return result
}

fun computeRaces(time: Int, record: Int): Int {
    var recordBeaters = 0
    var result = findCombinations(time)
    for (res in result) {
        if (res[0]*res[1] > record) {
            recordBeaters+=1
        }
    }
    return recordBeaters
}

fun findCombinations(targetSum: Int): MutableList<MutableList<Int>> {
    var numberPairs: MutableList<MutableList<Int>> = mutableListOf()
    for (i in 1 until targetSum) {
        for (j in i until targetSum) {
            if (i + j == targetSum) {
                numberPairs.add(mutableListOf(i, j))
                if (j != i) {
                    numberPairs.add(mutableListOf(j, i))
                }
            }
        }
    }
    return numberPairs
}

fun calculateProduct(numbers: List<Int>): Int {
    // Using fold to calculate the product
    return numbers.fold(1) { acc, number -> acc * number }
}
