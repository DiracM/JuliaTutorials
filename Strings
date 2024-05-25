## 1 - Chars to String
char1 = 'a'
typeof(char1)
char2 = 'b'
str1 = "ab"
str1 = char1 * char2
typeof(str1)

ptr = Base.unsafe_convert(Ptr{UInt8},str1)
binary_str = Base.unsafe_wrap(Vector{UInt8},ptr,3)

char1 = Char(0x61)
char1 = Char(97)
char1 = Char(0b01100001)

## 2 - String usage
str2 = "Line1\nLine2" #\n\r
print(str2)
str3 = "Special \"Characters\""
print(str3)

cstr1 = "I feel 🤔 today"
cstr1[9]

# Get the char indices
idx = collect(eachindex(cstr1))
cstr1[idx[8]]
cstr1[idx[9]]

# Transform string into a char array
char_array = [cstr1...]
char_array[8] = '😃'
char_array[9]
cstr1 = join(char_array)

# Variable in a string
x = 0:9
num_0_10 = "0"
for c in x
    num_0_10 = num_0_10 * " $(c+1)"
end
num_0_10

## 3 - String functions
"true" == "true"
"true" != "false"
txt_raw = read("text_to_read.txt")
txt_string = String(txt_raw)
txt_num = parse.(Int,split(txt_string," "))
txt_num.+1
str5 = "STRING,with,ISSUE"
str6 = uppercasefirst(lowercase(replace(str5,"," => " ")))

## 4 - Search
cstr2 = "Get the <equation>2π</equation>"
idx_start = findfirst("<equation>",cstr2)
idx_stop = findfirst("</equation>",cstr2)
#equation = cstr2[idx_start[end]+1:idx_stop[1]-1]
equation = cstr2[nextind(cstr2,idx_start[end]):prevind(cstr2,idx_stop[1])]

# Regex
regex = match(r"<equation>(.*?)</equation>",cstr2)
equation = regex.captures[1]
