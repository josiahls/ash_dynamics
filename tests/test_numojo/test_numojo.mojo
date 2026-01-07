# import numojo as nm
# from numojo.prelude import *


# fn main() raises:
#     # Generate two 1000x1000 matrices with random float64 values
#     var A = nm.random.randn(Shape(1000, 1000))
#     var B = nm.random.randn(Shape(1000, 1000))

#     # Generate a 3x2 matrix from string representation
#     var X = nm.fromstring[f32]("[[1.1, -0.32, 1], [0.1, -3, 2.124]]")

#     # Print array
#     print(A)

#     # Array multiplication
#     var C = A @ B

#     # Array inversion
#     var I = nm.inv(A)

#     # Array slicing
#     var A_slice = A[1:3, 4:19]

#     # Get scalar from array
#     var A_item = A[item(291, 141)]
#     var A_item_2 = A.item(291, 141)
