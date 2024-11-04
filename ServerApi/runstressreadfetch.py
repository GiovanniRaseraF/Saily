#!/usr/bin/python3

# node tests/boatapitests/test_send_generic.js 0x0001 test test g.rasera@huracanmarine.com MoroRacing2024
# node tests/boatapitests/test_send_generic.js 0x0001 test test g.rasera@huracanmarine.com MoroRacing2024

# Author: Giovanni Rasera
import os
import sys
import subprocess
import threading
import time
import random as rnd

maxThreads = 50
iterationsPerThread = 10000

def runTests(numThread):
    failCount = 0
    start = time.time()
    for runCount in range(0, iterationsPerThread):
        # run
        proc = subprocess.Popen(["node", "tests/boatapitests/test_send_generic.js", "0x00"+str(numThread+1), "test", "test", "g.rasera@huracanmarine.com", "MoroRacing2024"], stdout=subprocess.PIPE, shell=False)
        (out, err) = proc.communicate()
        result = False
        if("FAILED" in out.decode()):
            failCount += 1
            print(out)

        print(f"th: ${numThread}, test: ${runCount} done, fail ${failCount}")
        time.sleep(rnd.random()*2)
        

    end = time.time()
    print(f"Test took {end - start}")

for numThread in range(0, maxThreads):
    t = (threading.Thread(target=runTests, kwargs={'numThread':numThread}))
    t.start()
    time.sleep(rnd.random())
