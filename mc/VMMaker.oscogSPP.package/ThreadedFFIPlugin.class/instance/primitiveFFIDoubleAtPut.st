primitives
primitiveFFIDoubleAtPut
	"Return a (signed or unsigned) n byte integer from the given byte offset."
	| byteOffset rcvr addr floatValue floatOop |
	<export: true>
	<inline: false>
	<var: #floatValue type: #double>
	floatOop := interpreterProxy stackValue: 0.
	(interpreterProxy isIntegerObject: floatOop)
		ifTrue:[floatValue := self cCoerce: (interpreterProxy integerValueOf: floatOop) to:'double']
		ifFalse:[floatValue := self cCoerce: (interpreterProxy floatValueOf: floatOop) to:'double'].
	byteOffset := interpreterProxy stackIntegerValue: 1.
	rcvr := interpreterProxy stackObjectValue: 2.
	interpreterProxy failed ifTrue:[^0].
	addr := self ffiAddressOf: rcvr startingAt: byteOffset size: 8.
	interpreterProxy failed ifTrue:[^0].
	self mem: addr cp: (self addressOf: floatValue) y: (self sizeof: floatValue).
	^interpreterProxy pop: 3 thenPush: floatOop