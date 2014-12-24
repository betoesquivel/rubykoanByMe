# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def invalid_triangle(triangle)
  #triangle is an integer array with the 3 sides of the triangle
  larger_side = triangle.index(triangle.max)
  # select both sides that are not the larger side, remove index with map, add sides, and compare to larger_side
  triangle.each_with_index.select{ |x,i| i != larger_side }.map{|x,i| x}.inject(:+) <= triangle[larger_side]
end

def triangle(a, b, c)
  triangle = [a,b,c]
  if  triangle.any? { |x| x<=0 } or invalid_triangle(triangle)
      raise TriangleError, "Invalid triangle."
  else
    if a == b or a == c or b == c
      if a == b and b == c
        :equilateral
      else
        :isosceles
      end
    else
      :scalene
    end
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
