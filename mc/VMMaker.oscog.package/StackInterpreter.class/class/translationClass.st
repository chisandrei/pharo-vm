translation
translationClass
	"Return te class to use as the interpreterCLass when translating.  For the all-in-one
	 VMs that inherit from ObjectMemory this is the receiver.  But for the separate VMs
	 where most primitives are in a subclass it will be the subclass with the primitives."
	^self subclasses detect: [:s| s name = (self name, 'Primitives')] ifNone: [self]