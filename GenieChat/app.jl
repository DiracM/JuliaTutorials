module App
# set up Genie development environment
using GenieFramework
@genietools
using GenieSession
using HTTP
using JSON
using Stipple

# add reactive code to make the UI interactive
@app begin
    # Reactive variable definition
    @in userText = ""
    @in username = ""
    @in password = ""
    @in readyButton = false
    @out chatText = "Messages will appear here\n"
    @out LoginStatus = "Login with a username and account"
    @out userList = ""
    @out ready = false
    @out update = false
    @private chatId = 0
    @private sessionId = ""
    @private boot = true

    #Watchtime
    # Timer(0.0; interval = 1.0) do timer
    #     if (isready == true)
    #         update = ~update
    #     end
    # end

    @onchange isready begin
        if boot
            @async begin
                while true
                    update = ~update
                    sleep(1)
                end
            end

            Base.run(__model__,raw"this.runAnalytics()")

            sessionId = Genie.Cookies.getcookies(Genie.Router.params()[:REQUEST])[1].value
            println(sessionId)
            boot = false
        end
    end
    
    @onchange userText begin
        if contains(userText,"\n") || contains(userText,"\r")
            
            TextToSend = replace(userText, r"(/|\r\n|\r|\n)" => "")
            TextToSend = replace(TextToSend, "\""  => "＂")

            if (length(TextToSend)>0)
                response = HTTP.request("POST", "http://localhost:9102/send", [("Content-Type", "application/json")], """{"message":"$TextToSend", "id":"$sessionId"}""")
            end
            response_done = response.body |> String |> JSON.parse

            userText = ""
            @show response_done["response"]
        end
    end

    @onchange update begin
        if ready
            response = HTTP.request("POST", "http://localhost:9102/getChat", [("Content-Type", "application/json")], """{"id":"$sessionId"}""")            
            response_done = response.body |> String |> JSON.parse
            
            if (chatText != response_done["response"][1])
                chatText = response_done["response"][1]
                Base.run(__model__,raw"this.scrollToBottom()")
            end

            if (userList != response_done["response"][2])
                userList = response_done["response"][2]
            end
        end

    end

    @onbutton readyButton begin

        if length(username) > 0 && length(password) > 0

            response = HTTP.request("POST", "http://localhost:9102/login", [("Content-Type", "application/json")], """{"username":"$username", "password":"$password", "id":"$sessionId"}""")

            response_done = response.body |> String |> JSON.parse
            if response_done["response"] == "Success - New user" || response_done["response"] == "Success - Password correct"
                ready = true
            end
            LoginStatus = response_done["response"]
        end

        @show response_done
    end

end

#https://github.com/search?q=org%3ABuiltWithGenie%20scroll&type=code
@methods begin
    """
    scrollToBottom: function() {
        const element = document.evaluate('/html/body/div[1]/div/div/div/div[2]/div/div/div/label/div/div/div/textarea', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
        element.scrollTop = element.scrollHeight;
    },

    runAnalytics: function() {
        var script_tag = document.createElement('script');
        script_tag.src='https://www.googletagmanager.com/gtag/js?id=G-W31LRY5NER';
        document.head.appendChild(script_tag);
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        
        gtag('config', 'G-W31LRY5NER');
    }
    """
    #https://www.opinions.co.il/ogdan/loading-google-analytics-in-external-js-file/
end

# register a new route and the page that will be
# loaded on access
@page("/", "app.jl.html")
end
