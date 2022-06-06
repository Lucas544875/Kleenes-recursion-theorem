def encode(prog)#str -> int
  prog.unpack("H*")[0].to_i(16)
end

def decode(int)#int -> str
  [int.to_s(16)].pack("H*")
end

def universal(prog_g, inputs)#万能関数
  prog = decode(prog_g)
  args = "x = " + inputs.to_s + "\n"
  #print args + prog
  eval(args + prog)
end

def smn(m, n, prog_g, inputs)#smn定理
  prog = decode(prog_g)
  args = "x[#{m}, #{n}] = " + inputs[0, n].to_s + "\n"
  encode(args + prog)
end

def fix(prog_g, n)#再帰定理
  prog = decode(prog_g)
  f = <<~EOS
  x[#{n}] = smn(#{n}, 1, x[#{n}], [x[#{n}]])
  #{prog}
  EOS
  f_g = encode(f)
  smn(n, 1, f_g, [f_g])
end

def y_combinator(prog_g, n)#クリーネの不動点定理
  f = <<~EOS
  universal(universal(#{prog_g},x),x)
  EOS
  f_g = encode(f)
  fix(f_g, n)
end

suc = <<~EOS
x[0] + 1
EOS
suc_g = encode(suc)
#後者関数のゲーデル数
#=>2220180143094223614218

add = <<~EOS
x[0] + x[1]
EOS
add_g = encode(add)
#足し算のゲーデル数
#=>37248441819602698234340924682
add3_g = smn(1, 1, add_g, [3])
#smn定理によって構成された足す3をする関数のゲーデル数
#=>193404987271909102399300854068049772597487774415380303477562634
uni = <<~EOS
universal(x[0],[])
EOS
uni_g = encode(uni)

__END__

#print decode(add_fix_y)=>
"""
2338503694054129700761892357229106781713574819906288787062643677252478953416921735427169548552681240895788202212664394342217995280912771877207822655674484744402736362892408567353703038880241943113051164371307677069908779281175095737068167330338219716299248671016288114143000296794939105581440317600113559477695171854541026904792907670640218838028815548802090585206325177627565524786950530854397133090445300393592145363083868535135654357577167879680535041108712891501993865743441570757627576442369586188377902329248204891330657155218710858378497014829369678576850318392375915948817753931537183406243029685968515006179539878770469667321758230679755538195467111827872133959394998512458761630932825420259555810387085182418347279059466
i.e.
x[1, 0] = [code(x[1] = smn(1, x[1], [x[1]])
universal(universal(code(x[0] + x[1]),x),x))]
x[1] = smn(1, x[1] , [x[1]])
universal(universal(code(x[0] + x[1]),x),x)
"""

fixpoint = fix(add_g, 1)
#fix(prog_g, n): n には prog の引数の最後のインデックスを指定する
d2 = universal(fixpoint,[n])
d1 = universal(add_g, [n, fixpoint])
d1 == d2 #=> true
#任意の帰納的関数 f に対して
#f(x,e) = universal(e, x) となるような e を計算できる

p quine = y_combinator(uni_g, 0)
# 万能関数の不動点はクワインと呼ばれる