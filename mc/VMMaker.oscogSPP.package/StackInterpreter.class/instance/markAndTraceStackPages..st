object memory support
markAndTraceStackPages: fullGCFlag
	"GC of pages.  Throwing away all stack pages on full GC is simple but dangerous
	 because it causes us to allocate lots of contexts immediately before a GC.
	 Reclaiming pages whose top context is not referenced is poor because it would
	 take N incrementalGCs to reclaim N unused pages.  Only the page whose top
	 context is not referred to by the bottom context of any other page would be
	 reclaimed.  Not until the next GC would the page whose top contect is the
	 previously reclaimed page's base frame's bottom context be reclaimed.

	 Better is to not mark stack pages until their contexts are encountered.  We can
	 eagerly trace the active page and the page reachable from its bottom context
	 if any, and so on.  Other pages can be marked when we encounter a married
	 context."
	| thePage context |
	<var: #thePage type: #'StackPage *'>
	<inline: false>
	objectMemory hasSpurMemoryManagerAPI ifFalse:
		[self initStackPageGC].

	"On an incremental GC simply consider all non-free stack pages to be roots."
	fullGCFlag ifFalse:
		[0 to: numStackPages - 1 do:
			[:i|
			thePage := stackPages stackPageAt: i.
			(stackPages isFree: thePage) ifFalse:
				[self markAndTraceStackPage: thePage]].
		^nil].

	"On a full GC only eagerly trace pages referenced from
	 the base of the active page, i.e. on the active stack."
	stackPage = 0 ifTrue: [^nil].
	thePage := stackPage.
	[self markAndTraceStackPage: thePage.
	 context := self frameCallerContext: thePage baseFP.
	 ((objectMemory isContext: context)
	  and: [(self isMarriedOrWidowedContext: context)
	  and: [self isStillMarriedContext: context]]) ifTrue:
		[thePage := stackPages stackPageFor:  (self frameOfMarriedContext: context).
		 self assert: (stackPages isFree: thePage) not].
	 thePage trace < StackPageTraced] whileTrue