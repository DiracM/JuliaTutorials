##Basic web scraping tutorial in Julia
##https://www.youtube.com/watch?v=eF8y9J_3R4M

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
search_str = "russia"
search_location = findall(search_str,http_str)
 
#search_pnt = [search_location[i][1] for i=1:length(search_location)]
search_pnt = hcat(search_location...)[1,:]
 
#2.2 - Find the relevant String
interval = 150
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
