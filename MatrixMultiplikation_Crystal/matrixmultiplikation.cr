require "random"
require "benchmark"

module MatrixMultiplication
	
  	@@r = Random.new

	def self.makeMatrix(size) : Array(Array(Float64))
  		arr = Array(Array(Float64)).new
    	size.times do |x|
   	    	row = Array(Float64).new
      		size.times do |y|
    	    	row << @@r.next_float
      		end
      		arr << row
    	end
  		arr
 	end
  
  def self.multiply(m1, m2)
    m2Width = m2[0].size
    arr = Array(Array(Float64)).new(m1.size, Array(Float64).new)
    row = Array(Float64).new(m2Width,0)
    m1.size.times do |x| # zeile in m1
      m2Width.times do |y|# spalte in m2
        total = 0.0
        m2.size.times do |z|# wert in der zeile von m1
          total += m1[x][z] * m2[z][y]
        end
        row[y] = total
      end
      arr[x] = row
    end
    arr
  end

  
end

SIZE = 1440
THREADS = 24

m1 = MatrixMultiplication.makeMatrix(SIZE)
m2 = MatrixMultiplication.makeMatrix(SIZE)

puts Benchmark.realtime {
  m3 = MatrixMultiplication.multiply(m1, m2)
}
