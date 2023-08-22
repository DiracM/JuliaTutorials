##Introduction on Geospatial operations and how to use KML files in Julia
##https://www.youtube.com/watch?v=M4fD2GcIp2E

using GMT
using Geodesy
 
# 1 - Create a point in Paris
x = GMTdataset([2.35 48.85])
data_out = gmt2kml(x).text
write("output.kml",join(data_out,"\n"))
 
# 2 - Import poly from Google Earth and move it 100 m to the north
path ="C:\\Tutorial\\road.kml"
poly = gmtread(path)
x_lla = LLA.(poly.data[:,2],poly.data[:,1])
x_utmz = [UTMZ(x_lla[k],wgs84) for k=1:length(x_lla)]
x_utmz_t = [UTMZ(x_utmz[k].x, x_utmz[k].y + 100, x_utmz[k].zone, x_utmz[k].isnorth) for k = 1:length(x_lla)]
trans = LLAfromUTMZ(wgs84)
x_lla_t = trans.(x_utmz_t)
poly.data = getfield.(x_lla_t,[:lon :lat])
data_out = gmt2kml(poly,F="p").text
write("output.kml",join(data_out,"\n"))
 
# 3 - Create a cirle around a point
poly = GMTdataset([2.35 48.85])
x_lla = LLA(poly.data[2], poly.data[1])
x_utmz = UTMZ(x_lla, wgs84)
nsides = 50 + 1
θ = range(0,2π,nsides)
radius = 40000 # meters
circle = UTMZ.(x_utmz.x .+ radius*cos.(θ), x_utmz.y .+ radius*sin.(θ), x_utmz.zone, x_utmz.isnorth)
trans = LLAfromUTMZ(wgs84)
circle_ll = trans.(circle)
poly.data = getfield.(circle_ll,[:lon :lat])
data_out = gmt2kml(poly,F="p").text
write("output.kml",join(data_out,"\n"))
 
# 4 - Plot with the GMT toolbox
coast(region=:EUR)
plot!(poly,fill=:blue,show=true)
