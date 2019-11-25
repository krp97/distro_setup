from datetime import datetime
from os import path
from sys import exit

TMP_FILE_DIR = path.expanduser('~/time_keeper')
TMP_FILE_PATH = path.join(TMP_FILE_DIR, 'checkin_tmp')

if path.exists(TMP_FILE_PATH):
    print("---> You're already checked in.")
    exit(1)
elif not path.exists(TMP_FILE_DIR):
    print("---> Temporary files directory does not exist.")
    exit(1)
else :
    now = datetime.now()
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    with open(TMP_FILE_PATH, 'w') as tmp_file:
        tmp_file.write(dt_string + '\n')
    print(f"---> Checked in successfully on: {now}.")