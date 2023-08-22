##SQL database in Julia - SQLite tutorial
##https://www.youtube.com/watch?v=QsI_IRmD6QY

using HTTP
 
## 1 - Get the website data
# 1.1 - Get the http request
site = "https://www.theguardian.com/world"
r1 = HTTP.request("GET",site)
http_str = String(r1.body)
 
# 1.2 - Save the website data
f1 = open("output.txt","w")
write(f1,http_str)
 
## 2 - Search for the information
# 2.1 - Find pointers
search_str = "world/2022" #Keyword to search
search_location = findall(search_str,http_str)
 
#search_pnt = [search_location[i][1] for i=1:length(search_location)]
search_pnt = hcat(search_location...)[1,:]
 
#2.2 - Find the relevant String
interval = 170
sub_strings_intervals = range.(search_pnt.-interval, search_pnt.+interval)
str_array = String.(SubString.(http_str,sub_strings_intervals))
arr1 = split.(str_array,"href=\"")
relevant = size.(arr1,1) .== 2
 
relevant_str1 = arr1[relevant]
relevant_str2 = hcat(relevant_str1...)[2,:]
 
end_str = findfirst.("\"",relevant_str2)
end_str = hcat(end_str...) .-1
 
relevant_str3 = [relevant_str2[i][35:end_str[i]] for i=1:length(relevant_str1)]
relevant_str4 = unique(relevant_str3)
 
## 3 - Create a table with the data
# 3.1 - Get the url and separate it in the components
data_table = split.(relevant_str4,"/")
data_table = data_table[1:end-1]
 
for i=1:length(data_table)
    if size(data_table[i],1) == 4
        data_table[i] = ["article";data_table[i][1:end]]
    end
    data_table[i][5] = replace(data_table[i][5],"-" => " ")
end
 
# 3.2 - Save as an excel file
using DelimitedFiles
writedlm("data.csv", data_table, ',')
 
###########################################
## 4 - SQLite interface
###########################################
 
# 4.1 - Prepare the data for SQLite
using SQLite; using DataFrames #import Pkg; Pkg.add("DataFrames")
 
# Clean data 
data_table_string = permutedims(String.(hcat(data_table...)))
 
# 4.2 - Connect/create the database
db = SQLite.DB("news.db")
con = DBInterface
# Create a table inside the DB
SQLite.execute(db,"CREATE TABLE IF NOT EXISTS news_table(type TEXT,year TEXT,month TEXT,day TEXT,news TEXT)")
# Check if the table was created
SQLite.tables(db)
 
# 4.3 - Update the databe with new data
for k = 1:size(data_table_string,1)
    #Check if the entry exists already
    df = DataFrame(con.execute(db, "SELECT * FROM news_table WHERE news = '$(data_table_string[k,end])'"))
    if( size(df,1)<1)
        #Add the data to the DB
        sql_input = "INSERT INTO news_table(type,year,month,day,news) VALUES('$(data_table_string[k,1])','$(data_table_string[k,2])','$(data_table_string[k,3])','$(data_table_string[k,4])','$(data_table_string[k,5])')"
        SQLite.execute(db,sql_input)
    else
        #It already exists
    end
end
 
# 4.4 - SQL commands
df = DataFrame(con.execute(db, "SELECT * FROM news_table")) #Read the DB
 
data_table_string = [data_table_string; ["article" "2022" "dec" "01" "news"]] #Add a new line to DB
df = con.execute(db, "DELETE FROM news_table WHERE news='news'") #Delete a selection of lines
df = DataFrame(con.execute(db, "SELECT * FROM news_table WHERE news like '%pope%'")) #Search
 
df = con.execute(db, "DELETE FROM news_table") #Delete all, but leave the table
df = con.execute(db, "DROP TABLE news_table") #Delete the table
