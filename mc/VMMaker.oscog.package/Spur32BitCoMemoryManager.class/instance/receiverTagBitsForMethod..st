cog jit support
receiverTagBitsForMethod: aMethodObj
	"Answer the tag bits for the receiver based on the method's methodClass, if any."
	<api>
	| methodClassOrNil |
	methodClassOrNil := coInterpreter methodClassOf: aMethodObj.
	(methodClassOrNil = nilObj
	 or: [(self instSpecOfClass: methodClassOrNil) ~= self forwardedFormat]) ifTrue:
		[^0].
	^methodClassOrNil = (self fetchPointer: self smallIntegerTag ofObject: classTableFirstPage)
		ifTrue: [self smallIntegerTag]
		ifFalse: [self assert: methodClassOrNil = (self fetchPointer: self characterTag ofObject: classTableFirstPage).
				self characterTag]