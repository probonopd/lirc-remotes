#!/usr/bin/python

import os, glob
import xml.etree.ElementTree as ET
from pprint import pprint

def process(filepath):
    myfile = open(filepath)
    xml = myfile.read() # .replace("&","_").replace("<","LEFT")
    root = ET.fromstring(xml)

    codes = []
    protocol = None
    device = None
    subdevice = None
    for child in root:
        print child.tag, child.attrib
        brand = os.path.basename(os.path.dirname(os.path.abspath(filepath))).capitalize()
        print brand
        if(child.tag == "remote"):
            try:
                devicename = child.attrib["name"].split("_")[1]
            except:
                devicename = child.attrib["name"]
            print(brand)
            print(devicename)
        for childchild in child:

            functionname = None
            if(childchild.tag == "code"):
                functionname = childchild.attrib["name"]

            for childchildchild in childchild:
                if(childchildchild.tag == "decoding"):
                    if(protocol):
                        assert(protocol == childchildchild.attrib["protocol"])
                    protocol = childchildchild.attrib["protocol"]
                    if(device):
                        assert(device == int(childchildchild.attrib["device"]))
                    device = int(childchildchild.attrib["device"])
                    if(subdevice):
                        assert(subdevice == int(childchildchild.attrib["subdevice"]))
                    subdevice = int(childchildchild.attrib["subdevice"])
                    function = int(childchildchild.attrib["obc"])
            if(functionname):
                codes.append([protocol,device,subdevice,function, functionname])

    try:
        os.makedirs("/Users/user/irdb/codes/" + brand + "/Unknown_" + devicename)
    except:
        pass
    target = open("/Users/user/irdb/codes/" + brand + "/Unknown_" + devicename + "/" + str(device) + "," + str(subdevice) + ".csv", 'w')
    target.write("functionname,protocol,device,subdevice,function\n")
    codes = sorted(codes,key=lambda x: x[3])
    for code in codes:
        target.write("%s,%s,%i,%i,%i\n" % (code[4], code[0], code[1], code[2], code[3]))

if(__name__ == "__main__"):
    path = os.path.dirname(__file__)
    print path

    filepaths = glob.glob("./**/*.xml")

    i = 0
    j = 0
    for filepath in filepaths:
        try:
            process(filepath)
            j = j+1
            print ("SUCCESS %i" % j)
        except:
            i = i+1
            print ("ERROR %i" % i)