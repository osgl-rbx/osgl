local counter = -1

return function<T>(): T
	counter += 1
	return counter
end
