params["_msg",["_type",""]];
switch (toLower _type) do 
{
	case "warning": {_msg = format["[GMSAI] <WARNING>  %1",_msg]};
	case "error": {_msg = format["[GSAI] <ERRR>  %1",_msg]};
	default {_msg = format["[GMSAI]  %1",_msg]};
};
diag_log _msg;
