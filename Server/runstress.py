#!/usr/bin/python3

# Author: Giovanni Rasera
import os
import sys
import subprocess
import threading
import time
import random as rnd

maxThreads = 100
iterationsPerThread = 10

folder = sys.argv[1]

def runTests():
    start = time.time()
    for runCount in range(0, iterationsPerThread):
        # run
        proc = subprocess.Popen(["./runtest.py", folder, "1"], stdout=subprocess.PIPE, shell=False)
        (out, err) = proc.communicate()
        result = False

    end = time.time()
    print(f"Test took {end - start}")

for numThread in range(0, maxThreads):
    t = (threading.Thread(target=runTests))
    t.start()

