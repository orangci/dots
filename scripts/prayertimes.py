import requests
import datetime
import time
import subprocess

# Define the location for prayer times
city = "Riyadh"
country = "sa"
method = 4  # Method 4 is for Umm-al Qura

# Fetch prayer times
def get_prayer_times():
    url = f"http://api.aladhan.com/v1/timingsByCity?city={city}&country={country}&method={method}"
    response = requests.get(url)
    data = response.json()
    return data['data']['timings']

# Send notification
def send_notification(prayer_name, prayer_time, notification_type):
    message = f"It's time for the {prayer_name} {notification_type} at {prayer_time}."
    subprocess.run(['notify-send', 'Prayer Time', message])

# Main function to check prayer times and notify
def main():
    prayer_times = get_prayer_times()
    print("Fetched Prayer Times:", prayer_times)
    
    # List of prayers we are interested in
    prayers_of_interest = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
    
    for prayer_name, prayer_time in prayer_times.items():
        if prayer_name in prayers_of_interest:
            # Convert prayer time to datetime object
            prayer_datetime = datetime.datetime.strptime(prayer_time, "%H:%M")
            now = datetime.datetime.now()
            prayer_datetime = now.replace(hour=prayer_datetime.hour, minute=prayer_datetime.minute, second=0, microsecond=0)

            # Calculate time difference
            time_difference = (prayer_datetime - now).total_seconds()
            
            # If prayer time is in the future, set a timer for Adhan
            if time_difference > 0:
                time.sleep(time_difference)
                send_notification(prayer_name, prayer_time, "Adhan")
                
                # Calculate and set timer for Iqama
                if prayer_name == "Maghrib":
                    iqama_time = prayer_datetime + datetime.timedelta(minutes=10)
                else:
                    iqama_time = prayer_datetime + datetime.timedelta(minutes=20)
                    
                iqama_time_difference = (iqama_time - datetime.datetime.now()).total_seconds()
                if iqama_time_difference > 0:
                    time.sleep(iqama_time_difference)
                    iqama_time_str = iqama_time.strftime("%H:%M")
                    send_notification(prayer_name, iqama_time_str, "Iqama")

if __name__ == "__main__":
    main()