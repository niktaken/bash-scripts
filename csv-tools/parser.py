#!/usr/bin/env python

import yaml
import csv
import sys

# main
p_csv= sys.argv[1] 
p_yaml= sys.argv[2] 
print 'csv=', p_csv,'conf=',p_yaml


#
stream = open(p_yaml, "r")
specification = yaml.load_all(stream)


with open(p_csv) as csvfile:
    reader = csv.reader(csvfile,delimiter=',', quotechar='"')
    fieldnames = reader.next() 
#    print(', '.join(fieldnames))


for doc in specification:
    for k,v in doc.items():
        if k == 'columns':
             print 'columns', v
             for k1 in v:
                 for k2 in k1.split(' '):
                     for k3 in k2.split(':'):
                         print 'k1',k1[0],'k2',k2[0],'k3',k3
#                     print 'k2',k2

#    for row in reader:
#        print('AAA',', '.join(row))




#    headers = reader.next()
#    print ', '.join(headers)
