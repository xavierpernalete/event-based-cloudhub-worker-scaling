%dw 2.0
output application/json
---
{
  correlationId: correlationId,
  tracingId: vars.standardSystemAPIHeaders.tracing_id,
  status: {
    code: "404",
    messages: [
      {
        "type": "Error",
        "severity": vars.error.severity default '1',
        "reasonCode": vars.error.reasonCode default "ERR-404",
        "message": if(vars.error.description?)   // check for custom message from error variable
	               	vars.error.description
	           	   else                         // or from a validation module
	             	error.description default 'Not Found'
      }
    ]
  } 
} 