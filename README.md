MATLAB IRC 2
=============
A small proof of concept IRC client written in MATLAB

USAGE:
------
Modify the options to your liking, then run the script

It joins a single channel.  Anything you type in the matlab command window
is sent to the channel.  

To quit type /quit.
Commands in the Client
To do a private message or register to a nickserv identification service type:

    /msg <nickname> <message>
    example: /msg nickserv identify hunter123
	
To send an action:

	/me <action>
	example: /me does something cool
	
COMMENTS:
---------

Currently it waits using pause(2) for the server to respond, so connecting
will take at least 4 seconds to complete.

REQUIREMENTS:
-------------
 * TCP/UDP/IP Toolbox from:
<https://www.mathworks.com/matlabcentral/fileexchange/345-tcpudpip-toolbox-2-0-6>

DISCLAIMER:
-----------

This was forked from [matirc] (https://bitbucket.org/xixor/matirc) in order to add more functionality and user scripting. I am also working on making the client more robust, however it is still not guaranteed to work, and can be quite problematic at times.

LICENSING

THIS SOFTWARE IS RELEASED UNDER THE WTFPL license 
<http://sam.zoy.org/wtfpl/>

    /* This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://sam.zoy.org/wtfpl/COPYING for more details. */
    
sincerely,

AeroSteveO

6-18-14
