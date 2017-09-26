Name:        reach-app
Version:     17.10.10000
Release:     <REACH_VERSION>
Summary:     Contact Center
Group:       Misc
License: CPAL
AutoReqProv: no
URL:         http://ezuce.com
Requires: reach-app-recordings
%description
Reach is a skills-based, Call Center software based on FreeSWITCH and built in erlang.
%files
/usr/lib/reach/*
%attr(755,root,root) /etc/init.d/reach
/usr/share/sipxecs/cfinputs/plugin.d/sipxopeancd.cf
