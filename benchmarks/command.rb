# frozen_string_literal: true

require 'benchmark'
require 'evnt'

# Cost to instantiate
# ####################################################

class GeneralClass
end

class CommandClass < Evnt::Command
end

puts
puts 'Cost to instantiate:'
puts '#' * 60
Benchmark.benchmark(Benchmark::CAPTION) do |x|
  x.report('general:') { GeneralClass.new }
  x.report('command:') { CommandClass.new }
end
puts '#' * 60
puts '#' * 60
puts '#' * 60

# Cost to instantiate with validation
# ####################################################

class CommandValidation1Class < Evnt::Command

  validates :name, presence: true

end

puts
puts 'Cost to instantiate with validation:'
puts '#' * 60
Benchmark.benchmark(Benchmark::CAPTION) do |x|
  x.report('validation 1:') { CommandValidation1Class.new(name: 'foo') }
end
puts '#' * 60
puts '#' * 60
puts '#' * 60