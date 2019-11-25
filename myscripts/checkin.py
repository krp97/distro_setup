from datetime import datetime
import os
from sys import exit

TMP_FILE_DIR = os.path.expanduser(os.environ['TIME_KEEPER_DIR'])
print(TMP_FILE_DIR)
TMP_FILE_PATH = os.path.join(TMP_FILE_DIR, 'checkin_tmp')

if os.path.exists(TMP_FILE_PATH):
    print("---> You're already checked in.")
    exit(1)
elif not os.path.exists(TMP_FILE_DIR):
    print("---> Temporary files directory does not exist.")
    exit(1)
else :
    now = datetime.now()
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    with open(TMP_FILE_PATH, 'w') as tmp_file:
        tmp_file.write(dt_string + '\n')
    print(f"---> Checked in successfully on: {now}.")