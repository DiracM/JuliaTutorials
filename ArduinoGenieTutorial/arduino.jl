using LibSerialPort
using Plots

## 1 - Initialization
LibSerialPort.list_ports()
portname = "COM12"
baudrate = 115200
com = LibSerialPort.open(portname,baudrate)
dataarray = []

## 2 - Main loop
while true
    if bytesavailable(com) > 0
        comdata = String(read(com))
        comvalues = parse.(Float32,split(comdata,"\r\n",keepempty=false))
        append!(dataarray,comvalues)
        plt = plot(dataarray)
        display(plt)
    end
    sleep(0.2)
end