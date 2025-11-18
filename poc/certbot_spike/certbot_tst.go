// comment
package main

import (
	"fmt"
	"os/exec"
	"sync"
	"time"
)

func main() {
	fmt.Println("=== Certbot Multi-Worker Spike ===")

	domains := []string{
		"example1.com",
		"example2.com",
		"example3.com",
		"example4.com",
		"example5.com",
	}

	workers := 3 // Тестируем 3 workers
	fmt.Printf("Testing %d parallel Certbot workers\n\n", workers)

	startTime := time.Now()

	// Запустить workers
	var wg sync.WaitGroup
	semaphore := make(chan struct{}, workers)

	for _, domain := range domains {
		wg.Add(1)
		go func(d string) {
			defer wg.Done()

			// Acquire semaphore
			semaphore <- struct{}{}
			defer func() { <-semaphore }()

			workerStart := time.Now()
			fmt.Printf("Worker starting: %s\n", d)

			// Симуляция certbot вызова
			cmd := exec.Command("sleep", "5") // Simulate 5 sec processing
			err := cmd.Run()

			duration := time.Since(workerStart)
			if err != nil {
				fmt.Printf("❌ Worker failed: %s (error: %v, duration: %v)\n", d, err, duration)
			} else {
				fmt.Printf("✅ Worker completed: %s (duration: %v)\n", d, duration)
			}
		}(domain)
	}

	wg.Wait()
	totalDuration := time.Since(startTime)

	fmt.Printf("\n=== Results ===\n")
	fmt.Printf("Total duration: %v\n", totalDuration)
	fmt.Printf("Workers: %d\n", workers)
	fmt.Printf("Domains processed: %d\n", len(domains))
	fmt.Printf("Sequential would take: ~%v\n", time.Duration(len(domains)*5)*time.Second)
}
