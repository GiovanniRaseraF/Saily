#!/usr/bin/python3

# Author: Giovanni Rasera
import os
import sys
import subprocess

tests_folder_name = "tests"
print_test_output = 1

try:
    tests_folder_name = sys.argv[1]
    print_test_output = int(sys.argv[2])
except:
    print("USAGE: ./runtest {tests_folder} {print_test_output 1/0}")

l_files = os.listdir(f"./{tests_folder_name}")
l_files_names = [f"{f}" for f in l_files]
fails = []

def assertResult(file_input_text, expectToPass=True):
    return 

# Running all tests
for file in sorted(l_files_names):
    if("test" not in file): continue
    print(f"Testing: {file}")
    
    # run
    proc = subprocess.Popen(["node", f"./{tests_folder_name}/{file}"], stdout=subprocess.PIPE, shell=False)
    (out, err) = proc.communicate()
    result = False
    output = str(out)
    output = output.replace("\\n","\n")
    output = output.replace("\n\n","")
    output = output.replace("\n\n","")
    output = output.replace("\n\n","")
    output = output.replace("\n\n","")
    output = output.replace("\n\n","")
    output = output.strip()
    if(" FAIL" in str(out) or "FAILED" in str(out) or "OK :)" not in str(out)):
        result = False
        print(f"./{tests_folder_name}/{file}: FAILED { output if print_test_output else ''} \n")
    else:
        result = True
        print(f"./{tests_folder_name}/{file}: PASSED { output if print_test_output else ''} \n")

    # check passed
    if(result):
        continue
    else:
        fails.append(file)
    
    proc.kill()

print("-- Testing Done --")
print(f"Failed Count: {len(fails)}")
print(f"Failed: {(fails)}")