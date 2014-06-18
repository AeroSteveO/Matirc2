function matirc2()
% MATLAB_IRC - A small proof of concept IRC client written in MATLAB
%
% DESCRIPTION.  This is a pretty minimal proof-of-concept client.  There
% is not much error checking, or robustness.
%
% Supported commands:
% /msg  - send private message:  /msg <user> <message>
%         example: /msg nickserv identify hunter123
%
% /quit - disconnect and quit the client
% /me   - sends an action: /me <action>
%         example: /me decided to use matirc
%
% Coming Soon:
% /notice
% /kick
%
%
% REQUIREMENTS:
%  * TCP/UDP/IP Toolbox from:
%  https://www.mathworks.com/matlabcentral/fileexchange/345-tcpudpip-toolbox-2-0-6
%
% xixor
% Feb. 13, 2012
% MATIRC 0.1
% website: http://matirc.xixor.net
% email: xixor@xixor.net
%
%
% AeroSteveO
% Sept. 21, 2013
% MATIRC 0.5
% website: N/A
% email:
%

%% OPTIONS
global opt
host = 'irc.dhirc.com';
port = 6667;
opt.nick       = ['MATIRC'];  % Doesn't handle it if someone already has your nick, "add num2str(randi(1000,1))" to the end of the nick if you don't have a registered nick
opt.channel    = '#channel';
opt.username   = 'matirc';
opt.hostname   = 'www.xixor.net';
opt.servername = 'irc.url.com';
opt.realname   = 'Matrix Laboratory';
timer_period   = 0.1;
passwd='password'; %nickserv password

%% CONNECT
con=pnet('tcpconnect',host,port);
pnet(con,'setwritetimeout',5);
pnet(con,'setreadtimeout',5);
global con1
con1=con;
if con==-1
    error 'Bad url or server down.....';
end

disp(['MATLAB IRC Client connected to: ' host]);
%% setup the data buffer callback event to check if messages have arrived
t = timer('StartDelay', 0, 'Period', timer_period,  ...
    'ExecutionMode', 'fixedRate');
t.TimerFcn = {@tcpip_data_callback, con};

start(t);

c = onCleanup(@()on_exit_event(t,con));

%% Connection Things

pause(2);  % TODO: need a better way to wait for the connection to be initialized
register(con,opt);
pause(2);
register(con,opt);
msg_text = opt.channel;

pnet(con,'printf',[ 'MODE ' opt.nick ' +B \r\n']);
send_priv_msg(['/msg nickserv ghost ' opt.nick ' ' passwd],con);
send_priv_msg(['/msg nickserv identify ' passwd],con);

%pnet(con,'printf',['PRIVMSG ' opt.channel ' :' 'You hate MATLAB, I run MATLAB \r\n']);
while 1
    
    user_msg = input([msg_text ' >>'],'s');
    if isempty(user_msg), continue, end;
    user_msg = strtrim(user_msg);
    
    if numel(user_msg) >=4 && strcmp(user_msg(1:4),'/msg')
        send_priv_msg(user_msg,con);
        continue;
    end
    if numel(user_msg) >=3 && strcmp(user_msg(1:3),'/me')
        send_action(user_msg,con);
        continue;
    end
    if numel(user_msg) >=7 && strcmp(user_msg(1:7),'/notice')
        send_notice(user_msg,con);
        continue;
    end
    switch user_msg
        case '/quit'
            break;
        case '/help'
            display_help();
        otherwise
            send_msg = ['PRIVMSG ' opt.channel ' :' user_msg '\r\n'];
            pnet(con,'printf',send_msg);
    end
    
end

function send_priv_msg(msg,con)

[~,msg] = strtok(msg,' ');
[nick,msg] = strtok(msg,' ');
msg = strtrim(deblank(msg));
nick = strtrim(deblank(nick));

send_msg = ['PRIVMSG ' nick ' :' msg '\r\n'];
pnet(con,'printf',send_msg);
fprintf('\n    --> %s : %s\n', nick, msg);

function send_notice(msg,con)

[~,msg] = strtok(msg,' ');
[nick,msg] = strtok(msg,' ');
msg = strtrim(deblank(msg));
nick = strtrim(deblank(nick));

msg = strtrim(deblank(msg));
nick = strtrim(deblank(nick));
send_msg = ['NOTICE ' nick ' :' msg '\r\n'];
pnet(con,'printf',send_msg);
fprintf('\n    --> %s : %s\n', nick, msg);

function send_privmsg(msg,con)
global opt
msg = strtrim(deblank(msg));
send_msg = ['PRIVMSG ' opt.channel ' :' msg '\r\n'];
pnet(con,'printf',send_msg);
fprintf('\n    --> %s : %s\n', opt.channel, msg);

function send_action(msg,con)
global opt
msg=strtrim(deblank(msg));
send_msg=['PRIVMSG ' opt.channel ' \0001ACTION ' msg ' \0001 \r\n'];
pnet(con,'printf',send_msg);
fprintf('\n    * %s : %s\n', opt.channel, msg);


function tcpip_data_callback(~, ~, con)
% TCPIP CALLBACK - callback to check the TCP/IP data queue
% This function is executed by a timerand is called automatically
% INPUTS:
% con - connection object
% OUTPUTS:
% none
% no error checking or printable output.
%

data = pnet(con,'read',4096,'noblock');
if isempty(data), return, end

d = regexp(data,'\n','split');   % break the message into a cell array
for i=1:size(d,1)
    process_message(con,d{i});
end

function process_message(con,msg)
% PROCESS_MESSAGE - process irc messages received from the server
%
% INPUTS:
% con: connection object
% msg: the messgae to parse
%
% OUTPUTS: none.  This function calls other functions based on the message.
%
% TODO: need to parse irc messages in a general way
global opt
if ~isempty(strfind(msg,'PRIVMSG'))
    parse_privmsg(msg)
    return;
end

prefix = find(msg ==':',1,'first');
msg_name = strtrim(msg(1:prefix-1));
msg_body = strtrim(msg(prefix+1:end));

switch msg_name
    case 'NOTICE AUTH'
        % server messages
        fprintf('%s\n',msg);
        
    case 'PING'
        % ping requests from the server
        pnet(con,'printf',['PONG ' msg_body '\r\n']);
        fprintf('PING? PONG!\n');
    otherwise
        % TODO: parse other messages
        % This allows you to rejoin automatically on kick
        if strfind(msg,['KICK ' opt.channel ' ' opt.nick])
            pause(2);
            register(con,opt);
            pause(2);
            register(con,opt);
        end
        fprintf('%s\n',msg);
end

function parse_privmsg(msg)
% PARSE_PRIVMSG - parse a PRIVMSG, print to screen
%
% INPUTS
% msg : a privmsg string from the irc server
% con : connection object
% opt : options structure
% (con and opt unused, left for future implementation)
%
% OUTPUT:
% prints the <nick> msg to the command window
%
% No error checking or confirmation
%

% TODO: need a much more general and robust way of parsing irc messages
% fprintf('\n MSG: %s\n',msg); // debug statement
sent_nick = msg(find(msg==':',1,'first')+1:find(msg=='!',1,'first')-1);
fprintf('<%s> %s\n',sent_nick,strtrim(msg(find(msg ==':',1,'last')+1:end)));