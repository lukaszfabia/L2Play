package response

import "github.com/gin-gonic/gin"

type Gin struct {
	Ctx *gin.Context
}

type Response struct {
	HTTPCode int     `json:"code"`
	Msg      Message `json:"msg"`
	Data     any     `json:"data,omitempty"`
}

func (g *Gin) NewResponse(httpCode int, msg Message, data any) {
	g.Ctx.JSON(httpCode,
		Response{
			HTTPCode: httpCode,
			Msg:      msg,
			Data:     data,
		})
}
