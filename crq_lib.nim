import std/[tables,strformat, httpclient, base64, strutils]


type
    Crq_value* = object
        time*: string
        value*: string
        state*: string

proc get_current_values_crq*(params:seq[string], url: string, user: string, pass: string): Table[string, Crq_value] =
    var
        http_C = newHttpClient()
        get_req: string = url & "/crq?req=current"
        param_count: int =1
        res_table = initTable[string, Crq_value]()
        resp_seq: seq[string]
        tmp_seq: seq[string]
    if user == "":
        http_C.headers["Authorization"] = "Basic " & base64.encode(user & ":" & pass)
    for pr in params:
        get_req.add(fmt"&g{intToStr(param_count)}={pr}")
        param_count+=1
    resp_seq = http_C.getContent(get_req).splitLines()
    param_count = len(resp_seq)
    echo param_count
    if param_count>1:
        for x in countup(1,param_count-2):
            tmp_seq = resp_seq[x].split(", ")
            res_table[tmp_seq[0]] = Crq_value(time:tmp_seq[1][0..^2],value:tmp_seq[2],state:tmp_seq[3])
    result = res_table

proc get_spec_info*(req: string, url: string, user: string, pass: string): string =
    #[
    some usefull req for ecom 3000:
        dev_info - information about ecom 3000;
        cpuuse - current cpu load of ecom 300-;
        events - events by chanels;
        gettime - current time at ecom 3000;
        ident - identificator of ecom 3000;
        last_event;
        sys_events - system events;
        version - version of system software ecom 3000
    ]#
    var
        http_C = newHttpClient()
        get_req: string = url & fmt"/crq?req={req}"
    if user == "":
        http_C.headers["Authorization"] = "Basic " & base64.encode(user & ":" & pass)
    get_req.add(req)
    result = http_C.getContent(get_req)

proc get_arch_crq*(param: string, start_t: string, end_t: string, url: string, user: string, pass: string): Table[string, Crq_value] =
    var
        http_C = newHttpClient()
        get_req: string = url & fmt"/crq?req=archive&type={param[0]}&n1={param[1..^1]}&{param[0]}&n2={param[1..^1]}&t1={start_t}&t2={end_t}"
        res_table = initTable[string, Crq_value]()
        resp_seq: seq[string]
        tmp_seq: seq[string]
        param_count: int
    if user == "":
        http_C.headers["Authorization"] = "Basic " & base64.encode(user & ":" & pass)
    resp_seq = http_C.getContent(get_req).splitLines()
    param_count = len(resp_seq)
    if param_count>1:
        for x in countup(1,param_count-2):
            tmp_seq = resp_seq[x].split(", ")
            res_table[tmp_seq[1][0..^2]] = Crq_value(time:tmp_seq[1][0..^2],value:tmp_seq[2],state:tmp_seq[3])
    result = res_table
