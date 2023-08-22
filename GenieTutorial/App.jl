##Create a web app with Genie Builder GUI - Julia Tutorial
##https://www.youtube.com/watch?v=RdeWPcd12ew

module App
# set up Genie development environmet
using GenieFramework
using SQLite
using DataFrames
@genietools
 
# add reactive code to make the UI interactive
@app begin
    # reactive variables are tagged with @in and @out
    @in continent_selection = [""]
    @in date = RangeData(1950:2021)
    @out continent_list = ["","Asia","Africa","America","Europe","Oceania"]
    @out plotgraph = PlotData[]
 
    # watch a variable and execute a block of code when
    # its value changes
    @onchange continent_selection , date begin
        # the values of result and msg in the UI will
        # be automatically updated
        @show date
        @show continent_selection
 
        # Connect to the SQLite database
        db = SQLite.DB("sqlite.db")
        con = DBInterface
 
        # Read data and plot 
        df = DataFrame(con.execute(db,"SELECT * FROM population WHERE Continent = '$(uppercase(continent_selection[]))'"))
        plotgraph = [PlotData( x = date.range[1]:date.range[end], y = df.Population.*1000, name = continent_selection[])]
    end
end
 
# register a new route and the page that will begin
# loaded on access
@page("/", "app.jl.html")
end
 
