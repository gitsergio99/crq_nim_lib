import std/[tables,sequtils,strformat, httpclient, base64, strutils]

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
            res_table[tmp_seq[0]] = Crq_value(time:tmp_seq[1],value:tmp_seq[2],state:tmp_seq[3])
    result = res_table

