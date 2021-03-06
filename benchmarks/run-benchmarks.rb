#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))

require 'partial-date'
require 'benchmark'
require 'date'

class PartialDateBenchmarks
  def initialize(iterations)
    @iterations = (iterations || 10000).to_i
    @benches    = []

    stdlib_date = Date.new(2012,12,1)
    partial_date = PartialDate::Date.new {|d| d.year = 2012; d.month = 12; d.day = 1}

    bench('(1a) create empty stdlib date objects')  do |d|
      Date.new
    end

    bench('(1b) create empty partial-date objects')  do |d|
      PartialDate::Date.new
    end

    bench('(2a) create populated stdlib date objects')  do |d| 
      Date.new(2012,12,1)
    end

    bench('(2b) create populated partial-date objects from block')  do |d| 
      PartialDate::Date.new { |d| d.year = 2012; d.month = 12; d.day = 1 }
    end

    bench('(3) create partial-date objects from load method')  do |d| 
      PartialDate::Date.load 20121201
    end

    bench('(4a) read stdlib date parts') do |d|
      stdlib_date.year
      stdlib_date.month
      stdlib_date.day
    end

    bench('(4b) read partial-date date parts') do |d|
      partial_date.year
      partial_date.month
      partial_date.day
    end

    bench('(5a) call stdlib date strftime') do |d|
      stdlib_date.strftime('%Y-%m-%d')
    end

    bench('(5b) call partial-date to_s') do |d|
      partial_date.to_s
    end

    bench('(5c) call partial-date old to_s') do |d|
      partial_date.old_to_s
    end
  end

  def run
    puts "#{@iterations} Iterations"
    Benchmark.bmbm do |x|
      @benches.each do |name, block|
        x.report name.to_s do
          @iterations.to_i.times { block.call }
        end
      end
    end
  end

  def bench(name, &block)
    @benches.push([name, block])
  end
end

PartialDateBenchmarks.new(ENV['iterations']).run
