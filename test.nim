import crq_lib,std/[tables]
var
    res = initTable[string, Crq_value]()

res = get_current_values_crq(@["g1","g10","g18"],"http://10.39.15.55","","")
echo res["G1"]