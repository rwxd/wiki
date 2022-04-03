# Concurrency in Go

## Mutex

Safely access data across multiple goroutines

```go
func editFile(path string, mu *sync.Mutex){
	mu.Lock()
	defer mu.Unlock()
	// I/O stuff
}
```
