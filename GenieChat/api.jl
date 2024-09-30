using Genie, Genie.Renderer.Json, Genie.Requests
using HTTP

mutable struct User
    username::String
    password::String
    id::String
    timeStamp::Float64
end

struct Chat
    id::Int64
    text::String
end

global debug = ""

#function start_api()
	usersDB = User[]
	push!(usersDB,User("1","2","3",time()))

	chatDB = Chat[]
	idChat = 0

	Genie.config.run_as_server = true

	route("/login", method = POST) do
	  global debug = Genie.Requests.request()
	  message = jsonpayload()

	  userRcv = User(message["username"], message["password"], message["id"] ,time())
	  response = "Fail"

	  usernameExists = [userRcv.username == usersDB[k].username for k=1:size(usersDB,1)] 

	  if !(sum(usernameExists)>0)
		response = "Success - New user"
		push!(usersDB,userRcv)
	  else
		if usersDB[usernameExists][1].password == userRcv.password
			usersDB[usernameExists][1] = userRcv
			response = "Success - Password correct" 
		else
			response = "Fail - Password incorrect" 
		end
	  end

	  (:response => response) |> json
	end

	route("/send", method = POST) do
		message = jsonpayload()

		usernameExists = [message["id"] == usersDB[k].id for k=1:size(usersDB,1)] 
		if(sum(usernameExists)>0)
		  txUser = usersDB[usernameExists][end].username

		  global idChat = idChat + 1
		  chatRcv = Chat(idChat, "$txUser: $(message["message"]) \n")
		  response = "Success"

		  push!(chatDB,chatRcv)
		else
		  response = "Error"
		end
	  
		(:response => response) |> json

	end

	route("/getChat", method = POST) do
		message = jsonpayload()

		usernameExists = [message["id"] == usersDB[k].id for k=1:size(usersDB,1)] 

		if(sum(usernameExists)>0)
		  usersDB[usernameExists][1].timeStamp = time()
		  print("Updated: $(usersDB[usernameExists][1].username) \n")
		  recentUsers = [time() - usersDB[k].timeStamp < 30 for k=1:size(usersDB,1)]
		  userListDB = usersDB[recentUsers]
		  userListSort = sort([userListDB[k].username*"\n" for k=1:size(userListDB,1)])
		  userList = join(userListSort)

		  chatLog = join([chatDB[k].text for k=1:size(chatDB,1)])
		else
		  userList = ""
		  chatLog = ""
		end

		(:response => (chatLog, userList)) |> json
		
	end

	up(9102, "127.0.0.1", async = false)
#end