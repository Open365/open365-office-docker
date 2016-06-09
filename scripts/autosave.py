#!/usr/bin/python3

import time
import os

import LOffice

autosave_time = float(os.environ.get('AUTOSAVE_TIME', 60))

if __name__ == "__main__":


    while True:
        desktop = LOffice.connect()
        LOffice.saveAllDocs(desktop)
        time.sleep(autosave_time)
