#!/usr/bin/python3

# Author: Giovanni Rasera
import os
import sys
import subprocess
import threading
import time
import random as rnd

maxThreads = 20
iterationsPerThread = 100

folder = sys.argv[1]

def runTests(numThread):
    failCount = 0
    start = time.time()
    for runCount in range(0, iterationsPerThread):
        # run
        proc = subprocess.Popen(["./runtest.py", folder, "1"], stdout=subprocess.PIPE, shell=False)
        (out, err) = proc.communicate()
        result = False
        if("FAILED" in out.decode()):
            failCount += 1
            #print(out)

        print(f"th: ${numThread}, test: ${runCount} done, fail ${failCount}")
        time.sleep(rnd.random()*4 + 2)
        

    end = time.time()
    print(f"Test took {end - start}")

for numThread in range(0, maxThreads):
    t = (threading.Thread(target=runTests, kwargs={'numThread':numThread}))
    t.start()
    time.sleep(rnd.random()*10 + 2)

