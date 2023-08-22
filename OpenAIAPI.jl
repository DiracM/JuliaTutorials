##Using OpenAI API on your Julia code
##https://www.youtube.com/watch?v=t_EnnhwVFt8

using OpenAI
using GMT
 
# 1 - GPT initilization
secret_key = "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"
model = "gpt-3.5-turbo"
prompt_beg = "You are supporting me on selecting all the countries that match the prompt that I will ask you next. The list should be comma seperated with the names being described in the format ISO 3166-1 alpha-2. For example if I ask the coutries from South America you will list like the following: BR,AR,CL ... and so on."
 
# 2 - User input
waiting_input = true
user_input = ""
while waiting_input
    println("Describe the countries that you want to be part of the map (2 to 100 chars)")
    user_input = readline()
    if length(user_input) > 1 && length(user_input) < 100
        waiting_input = false
    end
end
 
# 3 - API call
prompt = prompt_beg * user_input * ":"
r = create_chat(secret_key,model,[Dict("role" => "user", "content" => prompt)])
gpt_resp = r.response[:choices][begin][:message][:content]
 
countries = replace(gpt_resp," " => "")
 
# 4 - Output
coast(region="-180/180/-90/90", S=:blue, N=:1, DCW=(country=countries, fill=:red),show=true)
