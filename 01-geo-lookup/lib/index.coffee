fs = require 'fs'


GEO_FIELD_MIN = 0
GEO_FIELD_MAX = 1
GEO_FIELD_COUNTRY = 2


exports.ip2long = (ip) ->
  ip = ip.split '.', 4
  return +ip[0] * 16777216 + +ip[1] * 65536 + +ip[2] * 256 + +ip[3]


gindex = []
exports.load = ->
  data = fs.readFileSync "#{__dirname}/../data/geo.txt", 'utf8'
  data = data.toString().split '\n'

  for line in data when line
    line = line.split '\t'
    # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
    gindex.push [+line[0], +line[1], line[3]]


normalize = (row) -> country: row[GEO_FIELD_COUNTRY]


exports.lookup = (ip) ->
  return -1 unless ip

  find = this.ip2long ip

  #binary search inside the geo.txt array
  while minIndex <= maxIndex
    currentIndex = Math.round(minIndex + maxIndex) / 2
    currentLine = gindex[currentIndex]
    currentLineMin = currentLine[GEO_FIELD_MIN]
    currentLinedMax = currentLine[GEO_FIELD_MAX]
    if find >= currentLineMin and find <= currentLinedMax
      return normalize currentLine

    if find > currentLineMin
      minIndex = currentIndex + 1
    else
      maxIndex = currentIndex - 1

  #for line, i in gindex
  # if find >= line[GEO_FIELD_MIN] and find <= line[GEO_FIELD_MAX]
  #  return normalize line

  return null
