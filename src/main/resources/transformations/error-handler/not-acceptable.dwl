%dw 2.0
output application/json
---
{
 	"applicationErrorCode": vars.error.applicationErrorCode default "AMRN-406",
 	"severity": vars.error.severity default '1',
	"errorDescription": if(vars.error.description?)   // check for custom message from error variable
	             vars.error.description
	           else                      // or from a validation module
	             error.description default 'Not Acceptable',
	"errorCode": 406		             
}