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

def smn(m, prog_g, inputs)#smn定理
  prog = decode(prog_g)
  args = "x[#{m}, 0] = " + inputs.to_s + "\n"
  encode(args + prog)
end

def fix(prog_g, n)#再帰定理
  prog = decode(prog_g)
  f = <<~EOS
  x[#{n}] = smn(#{n}, x[#{n}], [x[#{n}]])
  #{prog}
  EOS
  f_g = encode(f)
  smn(n, f_g, [f_g])
end

def recursion(prog_g, n)#クリーネの不動点定理
  f = <<~EOS
  universal(universal(#{prog_g},x),x)
  EOS
  f_g = encode(f)
  fix(f_g, n)
end


#debug
suc = <<~EOS
x[0] + 1
EOS
suc_g = encode(suc)
#後者関数のゲーデル数
#=>2220180143094223614218

add = <<~EOS
x[0] + x[1]
EOS
p add_g = encode(add)
#足し算のゲーデル数
#=>37248441819602698234340924682
p add3_g = smn(1, add_g, [3])
#smn定理によって構成された足す3をする関数のゲーデル数
#=>37248441819602698234340924682

#(0 .. 10).each do |n|
#  e = fix(add_g, 1)
#  d2 = universal(e,[n])
#  d1 = universal(add_g, [n, e])
#  p d1 == d2
#end
#print decode(d1)

#e = recursion(add3_g, 0)
#d1 = universal(e,[])
#d2 = universal(universal(e,[]), [])
#p d1 == d2