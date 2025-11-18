package main

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

type Agent struct {
	id    string
	lease bool
	mu    sync.Mutex
}

func main() {
	fmt.Println("=== Active-Passive HA Failover Spike ===\n")

	primary := &Agent{id: "primary", lease: true}
	backup := &Agent{id: "backup", lease: false}

	// Heartbeat counter
	var heartbeatsMissed int32
	var failover bool

	fmt.Println("Scenario 1: Normal operation")
	fmt.Printf("Primary: %v (has lease)\n", primary.lease)
	fmt.Printf("Backup: %v (standby)\n\n", backup.lease)

	fmt.Println("Scenario 2: Primary fails")
	// Simulate primary failure
	for i := 0; i < 3; i++ {
		atomic.AddInt32(&heartbeatsMissed, 1)
		fmt.Printf("Heartbeat %d: FAILED (missed %d)\n", i+1, atomic.LoadInt32(&heartbeatsMissed))

		if atomic.LoadInt32(&heartbeatsMissed) >= 3 {
			failover = true
			backup.lease = true
			primary.lease = false
			fmt.Println("⚠️  FAILOVER TRIGGERED!")
			break
		}

		time.Sleep(100 * time.Millisecond)
	}

	fmt.Printf("\nResult: %v\n", failover)
	fmt.Printf("Primary has lease: %v\n", primary.lease)
	fmt.Printf("Backup has lease: %v\n", backup.lease)
	fmt.Printf("Failover time: ~300ms (3 heartbeats × 100ms)\n")
}
