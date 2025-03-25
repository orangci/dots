import time
import json
import urllib.request
from datetime import datetime, timedelta
import subprocess
import os

city, country =  "Riyadh", "Saudi+Arabia"
icon_path = os.path.expanduser(f'/home/{subprocess.check_output(['whoami']).decode('utf-8').strip()}/dots/files/kabah.png')

def get_prayer_times():
    current_date = datetime.now().strftime("%d-%m-%Y")
    api_url = f"https://api.aladhan.com/v1/timingsByCity/{current_date}?city={city}&country={country}"
    
    try:
        with urllib.request.urlopen(api_url) as response:
            data = json.loads(response.read())
            if data and data.get("data"):
                return data["data"]["timings"]
    except Exception as e:
        subprocess.run(['notify-send', "Salawāt Script", "API Error", '-i', icon_path])
    return {}

def send_notification(prayer_name, prayer_time, calltype):
    subprocess.run(['notify-send', f"{prayer_name.capitalize()} Time", f" It is {prayer_time}, the time for the {prayer_name.capitalize()} {calltype}.", '-i', icon_path])

def main():
    prayer_times = get_prayer_times()

    while True:
        current_time = datetime.now().strftime("%H:%M")
        for prayer_name, prayer_time in prayer_times.items():
            if prayer_time:
                prayer_time_obj = datetime.strptime(prayer_time, "%H:%M").time()
                current_time_obj = datetime.strptime(current_time, "%H:%M").time()

                if prayer_time_obj == current_time_obj:
                    send_notification(prayer_name, prayer_time, "adhān")
                    time.sleep(60)

                    reminder_time_obj = (datetime.combine(datetime.today(), prayer_time_obj) + timedelta(minutes=15)).time()
                    while datetime.now().time() < reminder_time_obj:
                        time.sleep(10)
                    send_notification(prayer_name, prayer_time, "iqāma")

        time.sleep(30)

if __name__ == "__main__":
    main()