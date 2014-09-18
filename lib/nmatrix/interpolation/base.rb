#--
# = NMatrix
#
# A linear algebra library for scientific computation in Ruby.
# NMatrix is part of SciRuby.
#
# NMatrix was originally inspired by and derived from NArray, by
# Masahiro Tanaka: http://narray.rubyforge.org
#
# == Copyright Information
#
# SciRuby is Copyright (c) 2010 - 2014, Ruby Science Foundation
# NMatrix is Copyright (c) 2012 - 2014, John Woods and the Ruby Science Foundation
#
# Please see LICENSE.txt for additional copyright notices.
#
# == Contributing
#
# By contributing source code to SciRuby, you agree to be bound by
# our Contributor Agreement:
#
# * https://github.com/SciRuby/sciruby/wiki/Contributor-Agreement
#
# == interpolation/base.rb
#
# Base class for all interpolation methods.
#++

class NMatrix
  module Interpolation
    class Base
      def initialize x, y, type, opts
        @x, @y, @type, @opts = x, y, type, opts

        raise DataTypeError, "Invalid data type of x/y" unless valid_input_objects?
        raise RangeError, "Axis specified out of bounds" if invalid_axis?

        @opts[:precision] ||= 3

        axis  = (@opts[:axis] ? @opts[:axis] : 0)

        @size = [@x.size, (@y.is_a?(NMatrix) ? @y.column(axis).size : @y.size)].min
        @x    = @x.sort unless @opts[:sorted]
      end
     private

      def valid_input_objects?
        (@x.is_a?(Array) or @x.is_a?(NMatrix)) and
        (@y.is_a?(Array) or @y.is_a?(NMatrix))
      end

     protected

      def locate num 
        # Returns the index of the value 'num' such that x[j] > num > x[j+1]
        ascending = (@x[-1] >= @x[0])

        jl, jm, ju = 0, 0,@x.size-1

        while ju - jl > 1
          jm = (ju+jl)/2

          if num >= @x[jm] == ascending
            jl = jm
          else
            ju = jm
          end
        end

        return 0       if num == @x[0]     
        return @size-2 if num == @x[@size-1]
        return jl
      end 

      def invalid_axis?
        @opts[:axis] and @opts[:axis] > @y.cols-1
      end

    end
  end
end
