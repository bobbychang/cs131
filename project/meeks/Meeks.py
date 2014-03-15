from tweetyserver import TweetyServer

from twisted.internet import protocol
from twisted.application import service, internet

factory = protocol.ServerFactory()
factory.protocol = TweetyServer
factory.name = "Meeks"
factory.clientLocations = {}
factory.serverConnections = {}
 
application = service.Application("TweetyServer")

internet.TCPServer(12461, factory).setServiceParent(application)

from twisted.internet import reactor
from twisted.internet.protocol import Protocol
from twisted.internet.endpoints import TCP4ClientEndpoint, connectProtocol


def gotConnection(p):
    p.connectPeer()

pointGasol = TCP4ClientEndpoint(reactor, "localhost", 12462)
dGasol = connectProtocol(pointGasol, TweetyServer(factory))
dGasol.addCallback(gotConnection)
reactor.run()

pointFarmar = TCP4ClientEndpoint(reactor, "localhost", 12462)
dFarmar = connectProtocol(pointFarmar, TweetyServer(factory))
dFarmar.addCallback(gotConnection)
reactor.run()

pointHill = TCP4ClientEndpoint(reactor, "localhost", 12460)
dHill = connectProtocol(pointHill, TweetyServer(factory))
dHill.addCallback(gotConnection)
reactor.run()
