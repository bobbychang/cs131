"""
"""

from twisted.internet.protocol import Factory 
from twisted.internet.protocol import Protocol
from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor

class TweetyServer(LineReceiver):

    def __init__(self):
        self.state = "UNKNOWN"

    def connectionMade(self): 
        print "Got new connection!"

    def connectionLost(self, reason):
        if self.state == "CLIENT":
            print "Client disconnected"
        elif self.state == "SERVER":
            print "Server disconnected!"
            # If this server made the initial connection, reconnect
            # otherwise, wait for the other server to connect
        return

    def lineReceived(self, line):
        print "Got message:\n\t" + line
        msg = str.split(line)
        if msg[0] == 'IAM':
            self.handle_IAM(msg)
        elif msg[0] == 'ACK':
            self.handle_ACK(msg)
        elif msg[0] == 'AT':
            self.handle_AT(msg, line)
        elif msg[0] == 'IAMAT':
            self.handle_IAMAT(msg)
        elif msg[0] == 'WHATSAT':
            self.handle_WHATSAT(msg)
        elif msg[0] == '?':
            self.handle_ERROR(line)
        else:
            self.sendLine("? " + line)
        return

    def connectPeer(self):
        greeting = "IAM " + self.name
        self.sendLine(greeting)
        self.factory.serverConnections.append(self)

    def handle_IAM(self, msg):
        if len(msg) != 2:
            self.sendError(msg)
        else:
            self.state = "SERVER"
            self.factory.serverConnections.append(self)
            self.sendLine("ACK " + self.factory.name)
        return

    def handle_ACK(self, msg):
        if len(msg) != 2:
            self.sendError(msg)
        else:
            self.state = "SERVER"
            self.factory.serverConnections.append(self)
        return

    def handle_AT(self, msg, line):
        if len(msg) != 6 or self.state != "SERVER":
            self.sendError(msg)
            return

        lastLine = self.factory.clientLocations.get(msg[3])
        if lastLine != line:
            # The updates are considered more recent based on these criteria in descending order:
            #     most recent time sent
            #     quickest recieved
            #     alphabetical by server
            #     greatest latitude
            lastMsg = str.split(lastLine)
            if lastLine != None:
                if float(lastMsg[5]) > float(msg[5]):
                    return
                elif float(lastMsg[5]) == float(msg[5]):
                    if float(lastMsg[2]) < float(msg[2]):
                        return
                    elif float(lastMsg[2]) == float(msg[2]):
                        if lastMsg[1][0] < msg[1][0]:
                            return
                        elif lastMsg[1][0] == msg[1][0]:
                            # If it's still a tie check geo location
                            return
                            # Chang this ^
            self.factory.clientLocations[msg[3]] = line
            for server in self.factory.serverConnections:
                server.sendLine(line)
        return

    def handle_IAMAT(self, msg):
        if len(msg) != 4:
            self.sendError(msg)
            return
        self.state = "CLIENT"
        reply = 'AT '
        reply = reply + self.factory.name
        timeDiff = time.time() - float(msg[3])
        if timeDiff > 0:
            reply = reply + "+"
        reply = reply + ("%.9f " % timeDiff)
        reply = reply + ("%s %s %s" % (msg[1], msg[2], msg[3]))
        self.factory.clientLocations[msg[1]] = reply
        for server in self.factory.serverConnections:
            server.sendLine(reply)
        return

    def handle_WHATSAT(self, msg):
        if len(msg) != 4:
            self.sendError(msg)
            return
        self.state = "CLIENT"
        if msg[1] in self.factory.clientLocations:
            reply = self.factory.clientLocations[msg[1]]
            # get tweets
            tweets = '{"results":[{"location":"Ever","profile_image_url":"http://a3.twimg.com/profile_images/524342107/avatar_normal.jpg","created_at":"Fri, 16 Nov 2012 07:38:34 +0000","from_user":"C_86","to_user_id":null,"text":"RT @ionmobile: @SteelCityHacker everywhere but nigeria // LMAO!","id":5704386230,"from_user_id":34011528,"geo":null,"iso_language_code":"en","source":"&lt;a href=&quot;http://socialscope.net&quot; rel=&quot;nofollow&quot;&gt;SocialScope&lt;/a&gt;"},{"location":"Ever","profile_image_url":"http://a3.twimg.com/profile_images/524342107/avatar_normal.jpg","created_at":"Fri, 16 Nov 2012 07:37:16 +0000","from_user":"C_86","to_user_id":null,"text":"RT @ionmobile: 25 minutes left! RT Who will win????? Follow @ionmobile","id":5704370354,"from_user_id":34011528,"geo":null,"iso_language_code":"en","source":"&lt;a href=&quot;http://socialscope.net&quot; rel=&quot;nofollow&quot;&gt;SocialScope&lt;/a&gt;"}],"max_id":5704386230,"since_id":5501341295,"refresh_url":"?since_id=5704386230&q=","next_page":"?page=2&max_id=5704386230&rpp=2&geocode=27.5916%2C86.564%2C100.0km&q=","results_per_page":2,"page":1,"completed_in":0.090181,"warning":"adjusted since_id to 5501341295 (2012-11-07 07:00:00 UTC), requested since_id was older than allowed -- since_id removed for pagination.","query":""}'
            reply = reply + '\r\n' + tweets
            self.transport.write(reply)
        else:
            self.sendLine("NOAT " + msg[1])
        return

    def handle_ERROR(self, line):
        print "received error: " + line
        return

    def sendError(self, msg):
        reply = "?"
        for s in msg:
            reply = reply + " " + s
        self.sendLine(reply)
        return


#class TweetyServerFactory(Factory):

#    def buildProtocol(self, addr):
#        p = self.protocol(self)
#        p.factory = self
#        return p

# class TwitterClient(Protocol):
