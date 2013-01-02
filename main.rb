#!/usr/bin/ruby

solvedBoard = <<END
+-------+-------+-------+
| 9 6 3 | 1 7 4 | 2 5 8 |
| 1 7 8 | 3 2 5 | 6 4 9 |
| 2 5 4 | 6 8 9 | 7 3 1 |
+-------+-------+-------+
| 8 2 1 | 4 3 7 | 5 9 6 |
| 4 9 6 | 8 5 2 | 3 1 7 |
| 7 3 5 | 9 6 1 | 8 2 4 |
+-------+-------+-------+
| 5 8 9 | 7 1 3 | 4 6 2 |
| 3 1 7 | 2 4 6 | 9 8 5 |
| 6 4 2 | 5 9 8 | 1 7 3 |
+-------+-------+-------+
END

unsolvedBoard = <<END
+-------+-------+-------+
| _ 6 _ | 1 _ 4 | _ 5 _ |
| _ _ 8 | 3 _ 5 | 6 _ _ |
| 2 _ _ | _ _ _ | _ _ 1 |
+-------+-------+-------+
| 8 _ _ | 4 _ 7 | _ _ 6 |
| _ _ 6 | _ _ _ | 3 _ _ |
| 7 _ _ | 9 _ 1 | _ _ 4 |
+-------+-------+-------+
| 5 _ _ | _ _ _ | _ _ 2 |
| _ _ 7 | 2 _ 6 | 9 _ _ |
| _ 4 _ | 5 _ 8 | _ 7 _ |
+-------+-------+-------+
END

require 'board'

me = Board.new

#puts unsolvedBoard
puts "\n\n"
me.load(unsolvedBoard)
me.display


#c = (gets "col 1-9: ").to_i
#r = (gets "row 1-9: ").to_i

#p "cell is: " + self.get(c,r).to_s
#self.set(1,1,2)
#p "cell is: " + self.get(c,r).to_s

#p "column: " + self.col(c).join(" ").to_s
#p "row: " + self.row(r).join(" ").to_s
#p "grid: " + self.grid(gridNum(c,r)).join(" ").to_s

p "board is " + (me.solved? ? "solved." : "NOT solved")


puts me.togo.to_s << " cells left"
while me.simplify! do
  puts me.togo.to_s << " cells left"
  me.display
end

