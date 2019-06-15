package main

// Author: Jim Conner <sn*****@gma****om>
// This is like my second golang application ever
// and I used this as a learning program.

/*
 How?

 from right to left
 pos[0] = val(16^0) == 0 (always)
 pos[n] = val(16^(length(value)))
 final: each +=pos[n]
*/

import (
  "fmt"
  "strings"
  "os"
  "strconv"
  "math"
)

func reverse(StrArray []string) []string {
  for i := len(StrArray)/2-1; i >= 0; i-- {
    opp := len(StrArray) - 1 - i
    StrArray[i], StrArray[opp] = StrArray[opp], StrArray[i]
  }

  return StrArray
}

func h2d(value string) {
  total    := 0
  StrArray := make([]string,len(value))
  HexAtoI  := map[string]float64 {
    "A" : 10,
    "B" : 11,
    "C" : 12,
    "D" : 13,
    "E" : 14,
    "F" : 15,
  }

  StrArray = reverse(strings.Split(value, ""))

  // val is string
  for i, val := range StrArray {
    var iVal int
    var f64iVal float64

    if hati, ok := HexAtoI[strings.ToUpper(val)]; ok == true {
      // hati is int
      f64iVal = hati
    } else {
      iVal, _ = strconv.Atoi(val)
      f64iVal = float64(iVal)
    }

    total += int(f64iVal * math.Pow(16,float64(i)))
  }

  fmt.Println(total)
}

func main() {
  arg := os.Args[1]

  h2d(arg)
}
