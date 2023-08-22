## Web browser automation tutorial in Julia
## https://www.youtube.com/watch?v=KWYNlIOxQpo&t=45s

using WebDriver
using DefaultApplication
 
## 1 - Initialization
DefaultApplication.open("C:/Tutorial/chromedriver.exe")
sleep(5)
 
url = "https://www.google.com/travel/flights?hl=en-US"
 
capabilities = Capabilities("chrome")
wd = RemoteWebDriver(
    capabilities,
    host = "localhost",
    port = 9515
)
 
session = Session(wd)
 
wait_time = 0.2
## 2 - Open website
navigate!(session,url)
 
elem_cookie = Element(session, "xpath","/html/body/c-wiz/div/div/div/div[2]/div[1]/div[3]/div[1]/div[1]/form[2]/div/div/button/span")
click!(elem_cookie)
 
sleep(wait_time)
 
## 3 - Select city A
elem_cityA1 = Element(session, "xpath", "/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[1]/div[1]/div/div/div[1]/div/div/input")
click!(elem_cityA1)
 
sleep(wait_time)
 
elem_cityA2 = Element(session, "xpath", "/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[1]/div[6]/div[2]/div[2]/div[1]/div/input")
clear!(elem_cityA2)
element_keys!(elem_cityA2, "Los Angeles\n")
 
sleep(wait_time)
 
## 4 - Select city B
elem_cityB1 = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[1]/div[4]/div/div/div[1]/div/div/input")
click!(elem_cityB1)
 
sleep(wait_time)
 
elem_cityB2 = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[1]/div[6]/div[2]/div[2]/div[1]/div/input")
click!(elem_cityB2)
element_keys!(elem_cityB2,"Tokyo\n")
 
sleep(wait_time)
 
## 5 - Select date A
elem_dateA1 = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[2]/div/div/div[1]/div/div/div[1]/div/div[1]/div/input")
click!(elem_dateA1)
 
sleep(wait_time)
 
elem_dateA2 = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[2]/div/div/div[2]/div/div[2]/div[1]/div[1]/div[1]/div/input")
click!(elem_dateA2)
element_keys!(elem_dateA2,"Oct 1\n")
 
sleep(wait_time)
 
## 6 - Select date B
elem_dateB2 = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[2]/div/div/div[2]/div/div[2]/div[1]/div[1]/div[2]/div/input")
click!(elem_dateB2)
element_keys!(elem_dateB2,"Oct 8\n")
 
sleep(wait_time)
 
elem_submit = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[1]/div/div[2]/div[2]/div/div/div[2]/div/div[3]/div[3]/div/button/span")
click!(elem_submit)
 
sleep(wait_time)
 
elem_submit = Element(session,"xpath","/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[1]/div[1]/div[2]/div/button/span[2]")
click!(elem_submit)
 
## 7 - Wait for the data to be ready
str_data = "/html/body/c-wiz[2]/div/div[2]/c-wiz/div[1]/c-wiz/div[2]/div[2]/div[3]/ul/li[1]/div/div[2]/div" 
loading = true
while loading
    try
        elem_view = Element(session,"xpath",str_data)
        loading = ~(element_tag(elem_view) == "div")
    catch
    end
    sleep(wait_time) #timeout
end
 
## 8 - Get the data
elem_data = Element(session,"xpath",str_data)
println(element_text(elem_data))
