package response

type Message string 

const (
	Fail Message  = "fail"
	Success Message = "success"
	InvalidData Message = "invalid data"
)