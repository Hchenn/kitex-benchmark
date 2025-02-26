// Code generated by Kitex v0.1.4. DO NOT EDIT.

package secho

import (
	"github.com/cloudwego/kitex-benchmark/codec/protobuf/kitex_gen/echo"
	"github.com/cloudwego/kitex/server"
)

// NewInvoker creates a server.Invoker with the given handler and options.
func NewInvoker(handler echo.SEcho, opts ...server.Option) server.Invoker {
	var options []server.Option

	options = append(options, opts...)

	s := server.NewInvoker(options...)
	if err := s.RegisterService(serviceInfo(), handler); err != nil {
		panic(err)
	}
	if err := s.Init(); err != nil {
		panic(err)
	}
	return s
}
