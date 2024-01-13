module App
using LibSerialPort
# set up Genie development environment
using GenieFramework
@genietools

# add reactive code to make the UI interactive
@app begin
    # reactive variables are tagged with @in and @out
    @out plotdata = PlotData[]
    @out layout = PlotLayout(xaxis=[PlotLayoutAxis(xy="x",title="Sample number")],yaxis=[PlotLayoutAxis(xy="y",title="Voltage (V)")])
    @out update = false

    portname = "COM12"
    baudrate = 115200
    com = LibSerialPort.open(portname,baudrate)
    dataarray = []

    # watch a variable and execute a block of code when
    # its value changes
    @onchange isready begin
        @async begin
            while true
                update = ~update
                sleep(1)
            end
        end
    end

    @onchange update begin
        if bytesavailable(com) > 0
            comdata = String(read(com))
            comvalues = parse.(Float32,split(comdata,"\r\n",keepempty=false))
            append!(dataarray,comvalues)
        end
        plotdata = [PlotData(x = 1:length(dataarray), y = dataarray)]
    end
end

# register a new route and the page that will be
# loaded on access
@page("/", "app.jl.html")
end
