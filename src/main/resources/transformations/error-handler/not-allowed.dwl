%dw 2.0
output application/json
---
{
  correlationId: correlationId,
  tracingId: vars.standardSystemAPIHeaders.tracing_id,
  status: {
    code: "405",
    messages: [
      {
        "type": "Error",
        "severity": vars.error.severity default '1',
        "reasonCode": vars.error.reasonCode default "ERR-405",
        "message": if(vars.error.description?)   // check for custom message from error variable
	               	vars.error.description
	           	   else                         // or from a validation module
	             	error.description default 'Method Not Allowed'
      }
    ]
  } 
} 