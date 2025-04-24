import crq_lib,std/[tables,strutils]
var
    res = initTable[string, Crq_value]()
    #x = Ecom3000_info.dev_info
    tmp_str:string = "G12"

echo tmp_str[1..^1]

#res = get_current_values_crq(@["g1","g10","g18"],"http://10.39.15.55","","")
#echo res["G1"]

echo get_arch_crq("g17","202503100000000","202503110000000","http://10.39.15.55","","")