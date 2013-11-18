# Copyright 2013 Arman Darini

# usage (from main game directory): ruby lib/square.rb assets/dictionaries/113809of.fic
# requires ruby >= 2.0.0

require 'json'

##################################################
class Hash
  def has_rkey?(search)
    search = Regexp.new(search.to_s) unless search.is_a?(Regexp)
    !!keys.detect{ |key| key =~ search }
  end
end

##################################################
def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

##################################################
def print_square(square)  
  square.each { |e| puts e.join(" ").upcase }
end

##################################################
def find_words(y, x, word, checked)
  word[:spelling] += $letters_square[y][x]
  word[:path].push([y, x])
#  puts word
  $combinations_checked += 1
  checked[y][x] = true
  if Dictionary_hash[word[:spelling]] then
    $words_found.push(deep_copy(word))
  end
  if word[:spelling].size > 2 then
    closest_dictionary_word = Dictionary_array.bsearch { |w| w >= word[:spelling] }
    if !(closest_dictionary_word =~ /^#{word[:spelling]}/) then
      return
    end
  end

  if 0 <= x-1 and x-1 < W and !checked[y][x-1] then
    find_words(y, x-1, deep_copy(word), deep_copy(checked))
  end
  if 0 <= x+1 and x+1 < W and !checked[y][x+1] then
    find_words(y, x+1, deep_copy(word), deep_copy(checked))
  end
  if 0 <= y-1 and y-1 < H and !checked[y-1][x] then
    find_words(y-1, x, deep_copy(word), deep_copy(checked))
  end
  if 0 <= y+1 and y+1 < H and !checked[y+1][x] then
    find_words(y+1, x, deep_copy(word), deep_copy(checked))
  end
  if 0 <= x-1 and x-1 < W and 0 <= y-1 and y-1 < H and !checked[y-1][x-1] then
    find_words(y-1, x-1, deep_copy(word), deep_copy(checked))
  end
  if 0 <= x-1 and x-1 < W and 0 <= y+1 and y+1 < H and !checked[y+1][x-1] then
    find_words(y+1, x-1, deep_copy(word), deep_copy(checked))
  end
  if 0 <= x+1 and x+1 < W and 0 <= y-1 and y-1 < H and !checked[y-1][x+1] then
    find_words(y-1, x+1, deep_copy(word), deep_copy(checked))
  end
  if 0 <= x+1 and x+1 < W and 0 <= y+1 and y+1 < H and !checked[y+1][x+1] then
    find_words(y+1, x+1, deep_copy(word), deep_copy(checked))
  end
end

##################################################
def calculate_scores()
  $words_found.map do |word|
    lmult = 1
    word[:score] = 0
    word[:path].each { |l| word[:score] += Letters[$letters_square[l[0]][l[1]]] * $lmult_square[l[0]][l[1]]; lmult *= $wmult_square[l[0]][l[1]] }
    word[:score] *= lmult
  end
end

##################################################
def prepare_score_multiplier(dl, tl, dw, tw)
  $lmult_square = Array.new(H) { |e| e = Array.new(W) { |e| e = 1 } }
  $wmult_square = Array.new(H) { |e| e = Array.new(W) { |e| e = 1 } }
  indices = Array(0..(W*H-1)).sample(dl + tl + dw + tw)
  for i in 1..dl
    index = indices.pop()
    $lmult_square[index / H][index % W] = 2
  end
  for i in 1..tl
    index = indices.pop()
    $lmult_square[index / H][index % W] = 3
  end
  for i in 1..dw
    index = indices.pop()
    $wmult_square[index / H][index % W] = 2
  end
  for i in 1..tw
    index = indices.pop()
    $wmult_square[index / H][index % W] = 3
  end
end

##################################################
def write_json(filename)
  board = []
  for j in 0..H-1
    for i in 0..W-1
      board.push({ "i" => i + 1, "j" => j + 1, "l" => $letters_square[j][i], "s" => Letters[$letters_square[j][i]], "lm" => $lmult_square[j][i], "wm" => $wmult_square[j][i] })
    end
  end
  puts board

  words = {}
  $words_found.each do |w|
    path = w[:path].map { |l| [l[1] + 1, l[0] + 1] }
    if words[w[:spelling]] then
      words[w[:spelling]].push(path)
    else
      words[w[:spelling]] = [path]
    end
  end
  puts words

  output = { :board => board, :words => words }

  File.open(filename,"w") do |f|
    f.write(output.to_json)
  end
end

##################################################
Letters = Hash["a", 1, "b", 4, "c", 2, "d", 2, "e", 1, "f", 4, "g", 3, "h", 4, "i", 1, "j", 10, "k", 5, "l", 1, "m", 3, "n", 1, "o", 1, "p", 3, "q", 10, "r", 1, "s", 1, "t", 1, "u", 2, "v", 5, "w", 5, "x", 8, "y", 4, "z", 8]

W = 4
H = 4
Dictionary_array = File.open(ARGV[0]).read.split("\r\n")
Dictionary_string = Dictionary_array.join()
Dictionary_hash = Hash[Dictionary_array.map { |v| [v,true] }]
puts "Dictionary has #{Dictionary_hash.size} words and #{Dictionary_string.size} letters"

for l in 1..100
  $words_found = []
  $lmult_square = []
  $wmult_square = []
  $combinations_checked = 0

  $letters_square = Array.new(H) { |e| e = Array.new(W) { |e| e = Dictionary_string[rand(Dictionary_string.size)] } }

  for j in 0..H-1
    for i in 0..W-1
      find_words(j, i, Hash[:spelling => "", :path => []], Array.new(H) { |e| e = Array.new(W, false) })
    end
  end

  prepare_score_multiplier(1, 2, 2, 1)
  calculate_scores()

  words_spellings = $words_found.map{ |w| w[:spelling] }
  puts "******* combinations checked #{$combinations_checked} words found #{$words_found.count} unique #{words_spellings.uniq.count}"
  if words_spellings.uniq.count > 250 then
    print_square($letters_square)
    puts
    print_square($lmult_square)
    puts
    print_square($wmult_square)
  #  $words_found.sort! { |a, b| a[:spelling] <=> b[:spelling] }
    $words_found.sort! { |a, b| b[:score] <=> a[:score] }
#    puts $words_found
    write_json("levels/1.json")
    break
  end
end