I am a shared pool for the constants that define the first-level method lookup cache.

self ensureClassPool.
#(#MethodCacheClass #MethodCacheEntries #MethodCacheEntrySize #MethodCacheMask #MethodCacheMethod #MethodCachePrimFunction #MethodCacheSelector #MethodCacheSize) do: [:k|
	self classPool declare: k from: StackInterpreter classPool]