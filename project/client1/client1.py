from tweetyclient import TweetyClient

from twisted.internet import reactor
from twisted.internet.protocol import Protocol
from twisted.internet.endpoints import TCP4ClientEndpoint, connectProtocol
from twisted.application import service, internet

def testServer(p):
    p.send_IMAT("kiwi.cs.ucla.edu", "+27.5916+086.5640", 0)

application = service.Application("client1")

point = TCP4ClientEndpoint(reactor, "localhost", 12460)

client = TweetyClient()
client.setCommand("IAMAT", "kiwi.cs.ucla.edu", "+27.5916+086.5640", "0")

d = connectProtocol(point, client)

reactor.run()
