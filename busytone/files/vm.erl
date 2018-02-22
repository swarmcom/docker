% example

UUID = call_sup:originate("1234"),
call:wait(UUID),
timer:sleep(1000),
call:send_dtmf(UUID, "*"),
timer:sleep(2000),
call:hangup(UUID).
