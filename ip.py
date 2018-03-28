#!/usr/bin/python

def leerDato():
    import urllib2
    html = urllib2.urlopen('http://ip.42.pl/raw').read()
    return html

print leerDato()
print ":)"
