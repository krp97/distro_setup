from datetime import datetime, date
import os
from sys import exit

TMP_FILE_DIR = os.path.expanduser(os.environ['TIME_KEEPER_DIR']) 
TMP_FILE_PATH = os.path.join(TMP_FILE_DIR, 'checkin_tmp')
LEDGER_PATH = os.path.join(TMP_FILE_DIR, 'ledger')


def date_from_file(filepath):
    start = ''
    with open(TMP_FILE_PATH, 'r') as tmp_file:
        start = tmp_file.readline()
    start = start.rstrip()
    return datetime.strptime(start, "%d/%m/%Y %H:%M:%S")


def main():
    if not os.path.exists(TMP_FILE_PATH):
        print('---> You\'re not checked in. Run the checkin command first.')
        exit(1)
    else:
        start = date_from_file(TMP_FILE_PATH)
        time_diff = datetime.now() - start
        hours = time_diff.seconds//3600
        minutes = (time_diff.seconds//60) % 60
        today = date.today().strftime("%d/%m/%Y")
        with open(LEDGER_PATH, 'a+') as f:
            f.write(f"{today} -- {hours}:{minutes}\n")
        os.remove(TMP_FILE_PATH)
        print(
            f"---> Checked out {hours} hours and {minutes} minutes on {today}.")


if __name__ == "__main__":
    main()
