inline primitive generators generated code
genLowcodeFloat64Add
	<option: #LowcodeVM>
	<inline: true>
	"Generated by the Lowcode instruction generator."
	| second first |
	self allocateRegistersForLowcodeFloat2: [:secondValue :firstValue |
		second := secondValue.
		first := firstValue.
	].

	self ssNativeTop nativePopToReg: second.
	self ssNativePop: 1.
	self ssNativeTop nativePopToReg: first.
	self ssNativePop: 1.

	self AddRd: second Rd: first.
	self ssPushNativeRegisterDoubleFloat: first.

	^ 0

