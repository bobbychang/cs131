from tweetyserver import TweetyServer

from twisted.internet import protocol
from twisted.application import service, internet

factory = protocol.Factory()
factory.protocol = TweetyServer
factory.name = "Gasol"
factory.clientLocations = {}
factory.serverConnections = {}

application = service.Application("TweetyServer")

internet.TCPServer(12462, factory).setServiceParent(application)
