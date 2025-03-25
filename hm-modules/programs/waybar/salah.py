from datetime import datetime
import urllib.request
import json

current_date = datetime.now().strftime("%d-%m-%Y")
city = "Riyadh"
country = "Saudi+Arabia"
api_url = f"https://api.aladhan.com/v1/timingsByCity/{current_date}?city={city}&country={country}"

try:
    with urllib.request.urlopen(api_url) as response:
        data = json.loads(response.read())
        if data and data.get("data"):
            timings = data["data"]["timings"]
except Exception as e:
    print("API Error")
    timings = {}

current_time = datetime.now().strftime("%H:%M")
current_time_obj = datetime.strptime(current_time, "%H:%M")

prayer_times = {
    "Fajr": timings.get("Fajr"),
    "Dhuhr": timings.get("Dhuhr"),
    "Asr": timings.get("Asr"),
    "Maghrib": timings.get("Maghrib"),
    "Isha": timings.get("Isha")
}

next_prayer = None
next_prayer_time = None

for prayer_name, prayer_time in prayer_times.items():
    if prayer_time:
        prayer_time_obj = datetime.strptime(prayer_time, "%H:%M")
        if prayer_time_obj > current_time_obj:
            if next_prayer_time is None or prayer_time_obj < next_prayer_time:
                next_prayer = prayer_name
                next_prayer_time = prayer_time_obj

if next_prayer:
    print(f"{next_prayer}: {next_prayer_time.strftime('%H:%M')}")
else:
    print("🌙")