"""
"""
import time

from twisted.internet.protocol import Protocol
from sys import stdout
from twisted.protocols.basic import LineReceiver

class TweetyClient(LineReceiver):

    def __init__(self):
        self.cmd = ""
        self.var1 = ""
        self.var2 = ""
        self.var3 = ""

    def connectionMade(self):
        print "Got new connection!"
        self.send()

    def lineReceived(self, line):
        print "Received:\n" + line

    def setCommand(self, cmd, var1, var2, var3):
        self.cmd = cmd
        self.var1 = var1
        self.var2 = var2
        self.vaf3 = var3

    def send(self):
        if self.cmd == "IAMAT":
            self.send_IAMAT(self.var1, self.var2, self.var3)
        elif self.cmd == "WHATSAT":
            self.send_WHATSAT(self.var1, self.var2, self.var3)
        else:
            print "Unrecognized command!"

    def send_IAMAT(self, name, geo, ts):
        ts = time.time()
        print ("Sending:\nIAMAT %s %s %s" % (name, geo, ts))
        self.sendLine("IAMAT %s %s %s" % (name, geo, ts))

    def send_WHATSAT(self, name, radius, lim):
        print ("Sending:\nWHATSAT %s %s %s" % (name, radius, lim))
        self.sendLine("WHATSAT %s %s %s" % (name, radius, lim))
