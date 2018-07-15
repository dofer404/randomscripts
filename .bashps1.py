#!/usr/bin/env python
import sys
import os
from socket import gethostname

hostname = gethostname()

username = os.environ['USER']
pwd = os.getcwd()
homedir = os.path.expanduser('~')
if pwd.startswith(homedir):
	pwd = pwd.replace(homedir, '~', 1)

try:
    length = int(sys.argv[1])
    length = length-3
    start = length/2
    if start > 5:
    	start = 7
    end    = (length-start) * -1
except:
    print >>sys.stderr, "Usage: $0 <length>"
    sys.exit(1)


if length<1 or not (len(pwd) > (length+3)):
	pass
else:
	pwd = pwd[:start]+'...'+pwd[end:];
	
print ' %s> ' % (pwd)
