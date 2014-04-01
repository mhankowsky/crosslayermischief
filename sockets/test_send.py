import socket

host = 'localhost'
port = 18637

mb = '\1';
mf = '\36';
mi = '\37';
me = '\4';

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host,port))


##c = '';
##p = '';
##while (c != me):
##    c = s.recv(1);
##    p += c;
##    
##print p;

a = s.recv(1);
print a;

s.send(mb + 'head' + mf + 'a' + mi + str(1.2) + mi + str(1) + mf + 'bc' + mi + str(313) + mi + str(0) + me)

print "sent";

st = '';
c = '';
while (1):
    c = s.recv(1);
    st += c;
    print 'Packet Status:'
    print ord(c)
    print st
