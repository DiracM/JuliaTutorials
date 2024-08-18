using Sockets

server = connect(ip"192.168.137.251",12345)

button_now = "1"
button_before = "1"

while (true)
    if bytesavailable(server)>0
        button_now = readline(server)
        if( button_now == "0" && button_before == "1")
            run(`powershell "(New-Object -ComObject WScript.Shell).SendKeys(\"^+{M}\")"`)
        end
        button_before = button_now
    else
        print(server,"?")    
        sleep(0.5)
        eof(server)
    end
end
