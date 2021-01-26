require "selenium-webdriver"

# Declare your Instagram credentials in your .bashrc or .zshrc
username = ENV["INSTAFOLLOWUSER"]
password = ENV["INSTAFOLLOWPW"]

$waittime = 5 #sec
$TMRwaittime = 90 #sec for Too Many Request (429) HTTP Response Code

print("Initializing Chrome...")
# TODO: Don't use global variables
$driver = Selenium::WebDriver.for :chrome
# use Ruby backquote to retrieve STDOUT from UNIX command 'which'
Selenium::WebDriver::Chrome::Service.driver_path = `which chromedriver`.chomp
# use timeouts to handle page load time varying by network conditions
$driver.manage.timeouts.implicit_wait = 10 #msec
print("Complete\n")

print("Loading list...")
accounts = []
File.readlines('list').each do |line|
  accounts.append(line.chomp)
end
print("Complete\n")

print("Logging into Instagram...")
$driver.get('https://www.instagram.com/accounts/login/?source=auth_switcher')
username_input = $driver.find_element(xpath: '//*[@id="loginForm"]/div/div[1]/div/label/input')
username_input.send_keys(username)
password_input = $driver.find_element(xpath: '//*[@id="loginForm"]/div/div[2]/div/label/input')
password_input.send_keys(password, :return)
print("(Should be) Complete\n") # if the login was successful

sleep($waittime)

def btnFor(label)
  begin
    return $driver.find_element(xpath: "//button[contains(.,'#{label}')]")
  rescue => e
    return e
  end
end

def isThereBtnFor(label)
  exists = false
  begin
    btn = btnFor(label)
    if btn.class == Selenium::WebDriver::Error::NoSuchElementError
      raise btn
    end
    puts(" '#{label}' button exists")
    exists = true
  rescue => e
    puts e
  end
  return exists
end

def follow(url)
  begin
    puts("> Accessing: #{url}")
    $driver.get(url)
    if isThereBtnFor('Message') or isThereBtnFor('Requested')
      puts(" Moving to next account...")
      return
    elsif isThereBtnFor('Follow')
      followBtn = btnFor('Follow')
      print(" Clicking on 'Follow'...")
      followBtn.click
      print("Done\n")
      # Wait for follow to be accepted
      sleep(2)
    end
  rescue => e
    print " Error: " 
    print e
    print("\n")
  end
end

def wait(tmr = false) #tmr stands for "Too Many Requests"
  # wait to avoid being considered a bot
  interval = tmr ? $TMRwaittime : $waittime
  randInt = rand(1..interval)
  # TODO: singular form "second" for 1 second
  msg = "> Waiting: #{randInt} seconds"
  if tmr then msg = msg + " because of Too Many Requests" end
  puts(msg)
  sleep(randInt)
end

for account in accounts do
  accountURL = "https://instagram.com/#{account}/"
  follow(accountURL)
  wait()
end

# End process
$driver.quit();
print("Program ended")