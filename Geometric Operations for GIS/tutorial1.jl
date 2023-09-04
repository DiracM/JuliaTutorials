using LibGEOS
using Plots
 
## 1 - Points
p1 = LibGEOS.Point(0,0)
p2 = LibGEOS.Point(1,0)
 
plot(p1)
plot!(p2)
 
## 2 - Circles
c1 = LibGEOS.buffer(p1,1)
c2 = LibGEOS.buffer(p2,1)
 
plot(c2)
plot!(c1)
 
## 3 - Geometrical calculatons
LibGEOS.centroid(c2)
LibGEOS.area(c2)
π
 
c2 = LibGEOS.buffer(p2,1,100)
LibGEOS.getSize(c2.ptr)
LibGEOS.area(c2)
 
## 4 - Boolean operations
LibGEOS.intersects(c1,c2)
LibGEOS.intersects(p1,c2)
 
## 5 - Geometrical set operations
plot(LibGEOS.union(c1,c2))
plot!(LibGEOS.intersection(c1,c2))
 
plot(LibGEOS.difference(c1,c2))
plot(LibGEOS.difference(c2,c1))