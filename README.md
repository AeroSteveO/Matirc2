#MATLAB_IRC
A small proof of concept IRC client written in MATLAB

##USAGE:
Modify the options to your liking, then run the script

It joins a single channel.  Anything you type in the matlab command window
is sent to the channel.  

To quit type /quit.

To do a private message or register to a nickserv identification service type:

    /msg <nickname> <message>
    example: /msg nickserv identify hunter123

##COMMENTS:

Currently it waits using pause(2) for the server to respond, so connecting
will take at least 4 seconds to complete.

##REQUIREMENTS:
 * TCP/UDP/IP Toolbox from:
<https://www.mathworks.com/matlabcentral/fileexchange/345-tcpudpip-toolbox-2-0-6>

##DISCLAIMER:

sup,

I wrote this in an afternoon without any prior research into the irc protocol.
As such, it hasn't been tested, debugged, or verified to work, or guaranteed
for robustness.  Use at your own risk.

If you want to develop on the client please DO NOT do development by
connecting to a live irc server such as freenode.  Setup a private irc
server to connect to.  I recommend http://ircd.bircd.org/  as it is
easy to setup.

LICENSING

THIS SOFTWARE IS RELEASED UNDER THE WTFPL license 
<http://sam.zoy.org/wtfpl/>

    /* This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://sam.zoy.org/wtfpl/COPYING for more details. */
    
sincerely,

xixor
Feb. 13, 2012

MATIRC 0.1

website: <http://matirc.xixor.net>
email: <xixor@xixor.net>

MatIRC 0.5 by AeroSteveO


