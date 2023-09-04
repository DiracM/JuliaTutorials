using LibGEOS
using Geodesy
using GeoInterface
using Plots
using HTTP
using ArchGDAL
 
## 1 - Get the country map
resp = HTTP.get("http://cartographyvectors.com/vectors/MDG.geojson")
 
geojson = ArchGDAL.read(String(resp.body))
layer1 = ArchGDAL.getlayer(geojson)
 
layer2 = iterate(layer1)[1]
g1 = ArchGDAL.getgeom(layer2)
coords = GeoInterface.coordinates(g1)
 
## 2 - Generate the perimeter around each land mass polygon
full_land = LibGEOS.createEmptyPolygon()
full_coverage = LibGEOS.createEmptyPolygon()
 
for k1 = 1:length(coords)
 
    ## 2.1 - Convert polygon to UTM and calculate the perimeter around each point 
    poly1 = collect.(coords[k1]...)
    poly2 = hcat(poly1...)
    poly_geos = LibGEOS.Polygon([poly1])
 
    poly_lla = Geodesy.LLA.(poly2[2,:],poly2[1,:],0.0)
    poly_utm = Geodesy.UTMZfromLLA(wgs84).(poly_lla)
    points_utm = LibGEOS.Point.(getfield.(poly_utm,:x),getfield.(poly_utm,:y))
    perim = LibGEOS.buffer.(points_utm,22000)
 
    ## 2.2 - Convert each circle poly back to Lat and Lon and merge them
    coverage = LibGEOS.createEmptyPolygon()
    for k2 = 1:length(perim)
        p1 = GeoInterface.coordinates(perim[k2])
        p2 = hcat(p1[1]...)
        p_utm = Geodesy.UTMZ.(p2[1,:],p2[2,:],0.0,poly_utm[k2].zone,poly_utm[k2].isnorth)
        trans = LLAfromUTMZ(wgs84)
        p_lla1 = trans.(p_utm)
        p_lla2 = [getfield.(p_lla1,:lon) getfield.(p_lla1,:lat)]
        p_lla3 = [p_lla2[k2,:] for k2 in 1:size(p_lla2,1)]
        p_poly = LibGEOS.Polygon([p_lla3])
        coverage = LibGEOS.union(coverage,p_poly)
    end
 
    ## 2.3 - Save the land and perimeter polygons
 
    full_land = LibGEOS.union(full_land,poly_geos)
    full_coverage = LibGEOS.union(full_coverage,coverage)
 
end
 
## 3 - Calculate the national water boundary and output to a file
water_coverage = LibGEOS.difference(full_coverage,full_land)
plot(water_coverage)
 
ArchGDAL.createmultipolygon([GeoInterface.coordinates(water_coverage)])
file = open("debug.geojson","w")
write(file,ArchGDAL.toJSON(water_coverage_ag))
close(file)
 
LibGEOS.intersects(water_coverage,LibGEOS.Point(50.2442905537923,-13.974505017773694))
LibGEOS.intersects(water_coverage,LibGEOS.Point(50.560764008163034,-13.97450475425596))