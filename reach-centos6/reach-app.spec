Name:        reach-app
Version:     17.10.<EPOCH>
Release:     <COMMIT>
Summary:     Contact Center
Group:       Misc
License: CPAL
AutoReqProv: no
URL:         http://ezuce.com
%description
Reach is a skills-based, Call Center software based on FreeSWITCH and built in erlang.
%files
/usr/lib/reach/*
%dir %attr(700,sipx,sipx) /var/sipxdata/key
%attr(755,root,root) /etc/init.d/reach
%attr(755,root,root) /etc/init.d/reach_recordings
%attr(755,root,root) /usr/bin/apply-reach-log.sh
%attr(644,root,root) /usr/share/sipxecs/cfinputs/plugin.d/sipxopenacd.cf
